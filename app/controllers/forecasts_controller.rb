class ForecastsController < ApplicationController

  def search
    @search_query = SearchQuery.new(search_query_params)

    return unless @search_query.valid?

    @location = AccuLocation.find_by("#{@search_query.latitude},#{@search_query.longitude}")

    return unless @location&.valid?

    @condition = AccuCondition.find(@location.id)
  end

  private

  def search_query_params
    params[:search_query]&.permit(:formatted_address, :latitude, :longitude)
  end
end
