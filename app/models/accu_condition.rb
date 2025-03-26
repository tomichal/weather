require 'http'

class AccuCondition
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :observation_at, :datetime
  attribute :weather_text, :string
  attribute :weather_icon, :integer
  attribute :has_precipitation, :boolean
  attribute :precipitation_type, :string
  attribute :is_day_time, :boolean
  attribute :temperature, :float
  attribute :temperature_unit, :string

  validates :observation_at, presence: true
  validates :weather_text, presence: true
  validates :temperature, presence: true
  validates :temperature_unit, presence: true

  API_HOST = "https://dataservice.accuweather.com"
  API_PATH = "currentconditions/v1"
  API_KEY = Rails.application.credentials.accuweather_api_key

  class << self
    def find(id)
      response = client.get("#{API_HOST}/#{API_PATH}/#{id}", params: { apikey: API_KEY })

      if response.status.success?
        data = response.parse(:json)
        data = data.first if data.is_a?(Array)
        from_api(data)
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


    #   attribute :weather_icon, :integer
    #   attribute :has_precipitation, :boolean
    #   attribute :precipitation_type, :string
    #   attribute :is_day_time, :boolean
    #   attribute :temperature, :float
    #   attribute :temperature_unit, :string
    #
    #   #   "WeatherIcon": 2,
    #   #   "HasPrecipitation": false,
    #   # "PrecipitationType": null,
    #   # "IsDayTime": true,
    #   # "Temperature": {
    #   #   "Metric": {
    #   #     "Value": 24.1,
    #   #     "Unit": "C",
    #   #     "UnitType": 17
    #   #   },
    #   # },
    def from_api(data)
      data = data.deep_transform_keys { |key| key.to_s.underscore.to_sym }

      new(
        observation_at: Time.at(data[:epoch_time]).to_datetime,
        weather_text: data[:weather_text],
        weather_icon: data[:weather_icon],
        temperature: data[:temperature][:imperial][:value],
        temperature_unit: data[:temperature][:imperial][:unit],
      )
    end
  end
end
