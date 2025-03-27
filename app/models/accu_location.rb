# app/models/location.rb
require 'http'

class AccuLocation
  include RemoteApiModel

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
    private

    def from_api_data(data)
      new(
        id: data[:key],
        primary_postal_code: data[:primary_postal_code],
        country: data.dig(:country, :id),
        latitude: data[:geo_position][:latitude],
        longitude: data[:geo_position][:longitude]
      )
    end
  end

  def conditions
    @conditions ||= AccuCondition.find(id, cache_key: primary_postal_code).tap do |condition|
      condition.location = self
    end
  end
end
