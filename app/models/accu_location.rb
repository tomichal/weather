# app/models/location.rb
require 'http'

class AccuLocation
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :key, :string
  attribute :primary_postal_code, :string
  attribute :country, :string
  attribute :latitude, :float
  attribute :longitude, :float

  validates :key, presence: true
  validates :primary_postal_code, presence: true
  validates :country, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true

  API_HOST = "https://dataservice.accuweather.com"
  API_PATH = "locations/v1/cities/geoposition/search"
  API_KEY = Rails.application.credentials.accuweather_api_key

  class << self
    def find_by(query)
      response = client.get("#{API_HOST}/#{API_PATH}", params: { q: query, apikey: API_KEY })

      if response.status.success?
        data = response.parse(:json)
        if data.is_a?(Array)
          data.map { |location_data| from_api(location_data) }
        else
          from_api(data)
        end
      else
        raise "API search request failed: #{response.status} - #{response.body}"
      end
    end

    # Optional: If you need to handle timeout or other HTTP options
    def client
      HTTP.timeout(connect: 5, read: 10)
          .use(:auto_inflate)
          .headers(
            accept: "application/json",
            accept_encoding: "gzip",
          )
    end

    def from_api(data)
      data = data.deep_transform_keys { |key| key.to_s.underscore.to_sym }

      new(
        key: data[:key],
        primary_postal_code: data[:primary_postal_code],
        country: data.dig(:country, :id),
        latitude: data[:geo_position][:latitude],
        longitude: data[:geo_position][:longitude]
      )
    end
  end
end
