# spec/features/forecasts_spec.rb

require 'rails_helper'
require 'helpers/cache_helper'

RSpec.feature "Forecasts", type: :feature do
  include CacheHelper

  let(:latitude) { 40.7128 }
  let(:longitude) { -74.0060 }

  scenario "User visits the forecasts search page for the first time for a given location" do
    VCR.use_cassette('forecasts/index') do
      visit forecasts_path(search_query: { latitude:, longitude:, formatted_address: "New York, NY" })

      within("#location_details") do
        expect(page).to_not have_content("(cached)")
      end

      within("#current_conditions") do
        expect(page).to have_content("Current Conditions")
        expect(page).to have_content("48.0F")
        within("#daily_forecasts") do
          expect(page).to have_content("5 Day Forecast")
          expect(page).to have_content("51.0 - 58.0F")
        end
      end
    end
  end

  scenario "User visits the forecasts search page for the second time for a given location" do
    VCR.use_cassette('forecasts/index') do
      with_cache_store do
        visit forecasts_path(search_query: { latitude:, longitude:, formatted_address: "New York, NY" })
        visit forecasts_path(search_query: { latitude:, longitude:, formatted_address: "New York, NY" })

        within("#location_details") do
          expect(page).to have_content("(cached)")
        end
      end
    end
  end
end
