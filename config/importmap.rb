# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"

pin_all_from "app/javascript/controllers", under: "controllers"

pin "google-maps", to: "https://maps.googleapis.com/maps/api/js?key=#{Rails.application.credentials.google_maps_api_key}&libraries=places&v=beta"

