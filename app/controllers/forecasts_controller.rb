class ForecastsController < ApplicationController

  def search
    @search_query = SearchQuery.new(search_query_params)
  end

  private

  def search_query_params
    params.require(:search_query).permit(:formatted_address, :latitude, :longitude)
  end
end
