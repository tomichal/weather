class ForecastsController < ApplicationController

  def search
    @search_query = SearchQuery.new(search_query_params)
    if @search_query.valid?
      coords = "#{@search_query.latitude},#{@search_query.longitude}"
      @location = Rails.cache.fetch(coords, expires_in: 1.day) { AccuLocation.find_by(coords) }
      if @location&.valid?
        @condition = AccuCondition.find(@location.id)
      end
    end
  end

  private

  def search_query_params
    params[:search_query]&.permit(:formatted_address, :latitude, :longitude)
  end
end
