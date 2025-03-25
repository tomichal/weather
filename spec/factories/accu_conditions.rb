FactoryBot.define do
  factory :accu_condition do
    id { '2627449' }
    starts_at { '2025-03-27T12:38:00-04:00' }
    weather_text { 'Sunny' }
    weather_icon { 1 }
    temperature { 43.0 }
    temperature_unit { 'F' }
    wind_speed { 13.7 }
    wind_unit { 'mi/h' }
    wind_direction { 'WNW' }
  end
end
