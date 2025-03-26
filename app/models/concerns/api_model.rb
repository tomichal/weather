module ApiModel
  extend ActiveSupport::Concern

  include ActiveModel::Model
  include ActiveModel::Attributes

  attr_accessor :is_cached

  API_HOST = "https://dataservice.accuweather.com"
  API_KEY = Rails.application.credentials.accuweather_api_key

  class_methods do
    def from_response(response)
      if response.status.success?
        data = response.parse(:json)
        data = [data] if data.is_a?(Hash)
        data.map { |d| from_api(d.deep_transform_keys { |key| key.to_s.underscore.to_sym }) }
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