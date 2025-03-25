class ForecastsController < ApplicationController

  def search
    @query = params[:query]
  end

end
