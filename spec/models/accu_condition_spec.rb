require 'rails_helper'

RSpec.describe AccuCondition, type: :model do
  let(:location) { build(:accu_location) }
  let(:location_id) { location.id }
  let(:condition) { build(:accu_condition, id: location.id, location: location) }

  describe '.daily_forecasts' do
    it "sets the attributes from API response" do
      VCR.use_cassette('accu_conditions/daily_forecasts') do
        daily_forecasts = condition.daily_forecasts
        aggregate_failures do
          expect(daily_forecasts.size).to be 5
        end
      end
    end

    it "caches the response" do
      VCR.use_cassette('accu_conditions/daily_forecasts') do
        full_cache_key = "/#{AccuDailyForecast.model_name.collection}/#{AccuDailyForecast::API_PATH}/#{location.primary_postal_code}"
        aggregate_failures do
          expect(AccuDailyForecast).to receive(:full_cache_key)
                                         .with("#{AccuDailyForecast::API_HOST}/#{AccuDailyForecast::API_PATH}/#{location_id}",
                                               { details: true },
                                               location.primary_postal_code)
                                         .and_return(full_cache_key)
          expect(Rails.cache).to receive(:fetch).with(full_cache_key, expires_in: 30.minutes).and_return([ { "EpochDate" => 123456789 } ])

          condition.daily_forecasts
        end
      end
    end
  end
end
