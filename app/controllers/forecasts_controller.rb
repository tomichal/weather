class ForecastsController < ApplicationController

  def search
    @search_query = SearchQuery.new(search_query_params)

    return unless @search_query.valid?

    @location = AccuLocation.find_by("#{@search_query.latitude},#{@search_query.longitude}")

    @conditions = @location.conditions
  end

  private

  def search_query_params
    params[:search_query]&.permit(:formatted_address, :latitude, :longitude)
  end
end
