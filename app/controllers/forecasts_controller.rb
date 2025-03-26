class ForecastsController < ApplicationController

  def search
    @search_query = SearchQuery.new(search_query_params)
    if @search_query.valid?
      coords = "#{@search_query.latitude},#{@search_query.longitude}"
      location_cache_key = "/#{AccuLocation.model_name.collection}/#{coords}"
      @location = Rails.cache.fetch(location_cache_key, expires_in: 1.day) { AccuLocation.find_by(coords) }
      if @location&.valid?
        condition_cache_key = "/#{AccuCondition.model_name.collection}/#{@location.primary_postal_code}"
        is_cached = Rails.cache.exist?(condition_cache_key)
        @condition = Rails.cache.fetch(condition_cache_key, expires_in: 30.minutes) do
          AccuCondition.find(@location.id).tap { |c| c.daily_forecasts }
        end
        @condition.is_cached = is_cached
      end
    end
  end

  private

  def search_query_params
    params[:search_query]&.permit(:formatted_address, :latitude, :longitude)
  end
end
