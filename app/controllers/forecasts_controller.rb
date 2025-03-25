class ForecastsController < ApplicationController

  def search
    @address = params[:address]
  end

end
