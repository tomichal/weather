class ForecastsController < ApplicationController

  def search
    @search_query = SearchQuery.new(search_query_params)
    if @search_query.valid?
      @accu_location = AccuLocation.find_by("#{@search_query.latitude},#{@search_query.longitude}")
    end
  end

  private

  def search_query_params
    params.require(:search_query).permit(:formatted_address, :latitude, :longitude)
  end
end
