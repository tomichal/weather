class ForecastsController < ApplicationController

  def search
    @lat, @lng = [params[:latitude], params[:longitude]]
  end

end
