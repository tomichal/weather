module ForecastsHelper
  def last_fetched_at(forecast)
    forecast.observation_at.strftime("%Y-%m-%d %H:%M:%S")
  end
end
