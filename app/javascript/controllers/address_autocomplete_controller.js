import { Controller } from "@hotwired/stimulus"
import "google-maps"

export default class extends Controller {
    connect() {
        if (typeof google === "undefined") {
            return
        }

        this.autocomplete = new google.maps.places.Autocomplete(this.element, {
            types: ['address'],
            fields: ["formatted_address", "geometry", "name"],
            componentRestrictions: { country: "us" } // Optional: restrict to a specific country
        })

        this.autocomplete.addListener('place_changed', this._placeChanged.bind(this))
    }

    _placeChanged() {
        const place = this.autocomplete.getPlace()

        if (!place.geometry) {
            // User entered the name of a place that was not suggested
            return
        }

        // You can access additional place details here:
        // const address = place.formatted_address
        // const lat = place.geometry.location.lat()
        // const lng = place.geometry.location.lng()

        // If you need to store these values in hidden fields:
        // this.latitudeTarget.value = lat
        // this.longitudeTarget.value = lng
    }

    disconnect() {
        if (this.autocomplete) {
            google.maps.event.clearInstanceListeners(this.autocomplete)
        }
    }
}