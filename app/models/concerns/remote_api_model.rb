module RemoteApiModel
  extend ActiveSupport::Concern

  include ActiveModel::Model
  include ActiveModel::Attributes

  attr_accessor :is_cached

  API_HOST = "https://dataservice.accuweather.com"
  API_KEY = Rails.application.credentials.accuweather_api_key

  class_methods do
    def find(id, cache_key: nil)
      record = from_api("#{self::API_HOST}/#{self::API_PATH}/#{id}", params: { details: true }, cache_key:)

      return unless record.present?

      record = record.is_a?(Array) ? record.first : record
      record.id = id
      record
    end

    def find_by(query, cache_key: nil)
      record = from_api("#{self::API_HOST}/#{self::API_PATH}", params: { q: query }, cache_key:)

      return unless record.present?

      record.is_a?(Array) ? record.first : record

    end

    def where(params: {}, data_key: nil, cache_key: nil)
      raise "Invalid search parameters" unless params[:id].present?

      from_api("#{self::API_HOST}/#{self::API_PATH}/#{params[:id]}", params: { details: true }, data_key:, cache_key:)
    end

    private

    def from_api(uri, params: {}, cache_key: nil, data_key: nil)
      full_cache_key = full_cache_key(uri, params, cache_key)
      is_cached = true if Rails.cache.exist?(full_cache_key)
      data = Rails.cache.fetch(full_cache_key, expires_in: 30.minutes) do
        response = client.get(uri, params: params.merge(apikey: self::API_KEY))
        if response.status.success?
          data = response.parse(:json)
          data_key.present? ? data[data_key] : data
        else
          raise "API search request failed: #{response.status} - #{response.body}"
        end
      end

      return unless data.present?

      data = [data] if data.is_a?(Hash)
      data.map do |d|
        underscored_data = d.deep_transform_keys { |key| key.to_s.underscore.to_sym }
        from_api_data(underscored_data).tap { |o| o.is_cached = is_cached }
      end
    end

    def client
      HTTP.timeout(connect: 5, read: 10)
          .headers(
            accept: "application/json"
          )
    end

    def full_cache_key(uri, params, cache_key)
      "/#{self.model_name.collection}/#{cache_key || "#{URI.parse(uri).path}/#{params.to_query}"}"
    end
  end

end
