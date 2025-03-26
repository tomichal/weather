# app/models/location.rb
require 'http'

class AccuLocation
  include ApiModel

  attribute :id, :string
  attribute :primary_postal_code, :string
  attribute :country, :string
  attribute :latitude, :float
  attribute :longitude, :float

  validates :id, presence: true
  validates :primary_postal_code, presence: true
  validates :country, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true

  API_PATH = "locations/v1/cities/geoposition/search"

  class << self
    def find_by(query)
      response = client.get("#{self::API_HOST}/#{API_PATH}", params: { q: query, apikey: self::API_KEY })
      result = from_response(response)
      result.is_a?(Array) ? result.first : result
    end

    def from_api(data)
      new(
        id: data[:key],
        primary_postal_code: data[:primary_postal_code],
        country: data.dig(:country, :id),
        latitude: data[:geo_position][:latitude],
        longitude: data[:geo_position][:longitude]
      )
    end
  end
end
