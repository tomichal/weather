require 'http'

class AccuCondition
  include ApiModel

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

  API_PATH = "currentconditions/v1"

  class << self
    def find(id)
      result = from_api("#{self::API_HOST}/#{API_PATH}/#{id}", { details: true })
      result.is_a?(Array) ? result.first : result
    end

    def from_api_data(data)
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
