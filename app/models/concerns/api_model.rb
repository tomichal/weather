module ApiModel
  extend ActiveSupport::Concern

  include ActiveModel::Model
  include ActiveModel::Attributes

  attr_accessor :is_cached

  API_HOST = "https://dataservice.accuweather.com"
  API_KEY = Rails.application.credentials.accuweather_api_key

  class_methods do
    def from_api(path, params = {}, data_key = nil)
      response = client.get(path, params: params.merge(apikey: self::API_KEY))
      if response.status.success?
        data = response.parse(:json)
        data = data[data_key] if data_key.present?
        data = [data] if data.is_a?(Hash)
        data.map do |d|
          underscored_data = d.deep_transform_keys { |key| key.to_s.underscore.to_sym }
          from_api_data(underscored_data)
        end
      else
        raise "API search request failed: #{response.status} - #{response.body}"
      end
    end

    private

    def client
      HTTP.timeout(connect: 5, read: 10)
          .use(:auto_inflate)
          .headers(
            accept: "application/json",
            accept_encoding: "gzip",
            )
    end
  end
end