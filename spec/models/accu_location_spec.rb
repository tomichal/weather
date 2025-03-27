require 'rails_helper'

RSpec.describe AccuLocation, type: :model do
  let(:coordinates) { "40.7128,-74.0060" }

  describe ".find_by" do
    it "sets the attributes from API response" do
      VCR.use_cassette('accu_locations/find_by_coordinates') do
        location = AccuLocation.find_by(coordinates)
        aggregate_failures do
          expect(location.id).to eq '2627449'
          expect(location.primary_postal_code).to eq '10007'
          expect(location.country).to eq 'US'
          expect(location.latitude).to eq 40.714
          expect(location.longitude).to eq -74.003
        end
      end
    end

    it "caches the response" do
      VCR.use_cassette('accu_locations/find_by_coordinates') do
        full_cache_key = "/#{AccuLocation.model_name.collection}/#{AccuLocation::API_PATH}/q=#{coordinates}"
        aggregate_failures do
          expect(AccuLocation).to receive(:full_cache_key)
                                    .with("#{AccuLocation::API_HOST}/#{AccuLocation::API_PATH}", { q: coordinates }, nil)
                                    .and_return(full_cache_key)
          expect(Rails.cache).to receive(:fetch).with(full_cache_key, expires_in: 30.minutes)

          AccuLocation.find_by("40.7128,-74.0060")
        end
      end
    end
  end

  describe '.conditions' do
    let(:id) { '2627449' }
    let(:location) { build(:accu_location, id: id) }

    it "sets the attributes from API response" do
      VCR.use_cassette('accu_locations/conditions') do
        condition = location.conditions
        aggregate_failures do
          expect(condition.id).to eq id
          expect(condition.starts_at).to eq '2025-03-27T12:38:00-04:00'
          expect(condition.weather_text).to eq 'Sunny'
          expect(condition.weather_icon).to eq 1
          expect(condition.temperature).to eq 43.0
          expect(condition.temperature_unit).to eq 'F'
          expect(condition.wind_speed).to eq 13.7
          expect(condition.wind_unit).to eq 'mi/h'
          expect(condition.wind_direction).to eq 'WNW'
        end
      end
    end

    it "caches the response" do
      VCR.use_cassette('accu_locations/conditions') do
        full_cache_key = "/#{AccuCondition.model_name.collection}/#{AccuCondition::API_PATH}/#{location.primary_postal_code}"
        aggregate_failures do
          expect(AccuCondition).to receive(:full_cache_key)
                                     .with("#{AccuCondition::API_HOST}/#{AccuCondition::API_PATH}/#{id}",
                                           { details: true },
                                           location.primary_postal_code)
                                     .and_return(full_cache_key)
          expect(Rails.cache).to receive(:fetch).with(full_cache_key, expires_in: 30.minutes).and_return([{ "EpochTime" => 1223456789 }])

          location.conditions
        end
      end
    end
  end
end
