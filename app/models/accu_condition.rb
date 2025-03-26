require 'http'

class AccuCondition
  include ApiModel

  attribute :id, :string
  attribute :starts_at, :datetime
  attribute :weather_text, :string
  attribute :weather_icon, :integer
  attribute :temperature, :float
  attribute :temperature_unit, :string
  attribute :wind_speed, :float
  attribute :wind_unit, :string
  attribute :wind_direction, :string

  validates :starts_at, presence: true
  validates :weather_text, presence: true
  validates :temperature, presence: true
  validates :temperature_unit, presence: true

  API_PATH = "currentconditions/v1"

  class << self
    def find(id)
      result = from_api("#{self::API_HOST}/#{API_PATH}/#{id}", { details: true })
      result = result.is_a?(Array) ? result.first : result
      result.id = id
      result
    end

    def from_api_data(data)
      new(
        starts_at: Time.at(data[:epoch_time]).to_datetime,
        weather_text: data[:weather_text],
        weather_icon: data[:weather_icon],
        temperature: data.dig(:temperature, :imperial, :value),
        temperature_unit: data.dig(:temperature, :imperial, :unit),
        wind_speed: data.dig(:wind, :speed, :imperial, :value),
        wind_unit: data.dig(:wind, :speed, :imperial, :unit),
        wind_direction: data.dig(:wind, :direction, :localized),
      )
    end
  end

  def daily_forecasts
    @daily_forecasts ||= AccuDailyForecast.where(id: id)
  end
end
