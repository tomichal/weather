require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :webmock

  config.filter_sensitive_data('<ACCU_API_KEY>') do |interaction|
    Rails.application.credentials.accuweather_api_key
  end
end