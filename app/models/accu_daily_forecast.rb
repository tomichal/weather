require 'http'

class AccuDailyForecast
  include RemoteApiModel

  attribute :id, :string
  attribute :starts_at, :date
  attribute :weather_text, :string
  attribute :weather_icon, :integer
  attribute :temperature_min, :string
  attribute :temperature_max, :string
  attribute :temperature_unit, :string
  attribute :wind_speed, :float
  attribute :wind_unit, :string
  attribute :wind_direction, :string

  validates :id, presence: true
  validates :starts_at, presence: true

  API_PATH = "forecasts/v1/daily/5day"

  class << self
    private

    def from_api_data(data)
      new(
        id: data[:epoch_date],
        starts_at: Time.at(data[:epoch_date]).to_date,
        weather_icon: data.dig(:day, :icon),
        weather_text: data.dig(:day, :icon_phrase),
        temperature_min: data.dig(:temperature, :minimum, :value),
        temperature_max: data.dig(:temperature, :maximum, :value),
        temperature_unit: data.dig(:temperature, :maximum, :unit),
        wind_speed: data.dig(:day, :wind, :speed, :value),
        wind_unit: data.dig(:day, :wind, :speed, :unit),
        wind_direction: data.dig(:day, :wind, :direction, :localized),
      )
    end
  end

  def temperature
    "#{temperature_min} - #{temperature_max}"
  end
end
