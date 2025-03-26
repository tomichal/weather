require 'http'

class AccuDailyForecast
  include ApiModel

  attribute :id, :string
  attribute :starts_at, :datetime
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
    def where(params = {})
      if params[:id].present?
        results = from_api("#{self::API_HOST}/#{API_PATH}/#{params[:id]}", { details: true }, "DailyForecasts")
        results.each { |r| r.id = params[:id] }
        results
      else
        raise "Invalid search parameters"
      end
    end

    def from_api_data(data)
      new(
        starts_at: Time.at(data[:epoch_date]).to_datetime,
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
end
