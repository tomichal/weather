require 'rails_helper'

RSpec.describe "Forecasts", type: :request do
  describe "GET /forecasts/search" do
    let(:latitude) { "37.0" }
    let(:longitude) { "-122.0" }
    let(:location) { build(:accu_location, latitude: latitude, longitude: longitude) }
    let(:condition) { build(:accu_condition) }
    let(:daily_forecasts) { build_list(:accu_daily_forecast, 1) }

    before do
      expect(AccuLocation).to receive(:find_by).with("#{latitude},#{longitude}").and_return(location)
      expect(location).to receive(:conditions).and_return(condition)
      expect(condition).to receive(:daily_forecasts).twice.and_return(daily_forecasts)
    end

    it "returns a successful response" do
      get '/forecasts/search', params: { search_query: { latitude: latitude, longitude: longitude, formatted_address: 'Foo, Bar' } }

      aggregate_failures do
        expect(response).to have_http_status(:success)
        expect(response.body).to include("Current Conditions")
        expect(response.body).to include("#{condition.temperature.to_s}#{condition.temperature_unit}")
        expect(response.body).to include("#{daily_forecasts.size} Day Forecast")
        expect(response.body).to include("#{daily_forecasts.first.temperature.to_s}#{daily_forecasts.first.temperature_unit}")
      end
    end
  end
end
