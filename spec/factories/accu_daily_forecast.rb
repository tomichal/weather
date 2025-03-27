FactoryBot.define do
  factory :accu_daily_forecast do
    id { '2627449' }
    starts_at { '2025-03-27' }
    weather_text { 'Sunny' }
    weather_icon { 1 }
    temperature_min { 43.0 }
    temperature_max { 53.0 }
    temperature_unit { 'F' }
    wind_speed { 13.7 }
    wind_unit { 'mi/h' }
    wind_direction { 'WNW' }
  end
end
