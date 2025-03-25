import { Controller } from "@hotwired/stimulus"
import "google-maps"

export default class extends Controller {
    static targets = [ "searchTerm", "latitude", "longitude" ]

    connect() {
        if (typeof google === "undefined") {
            return
        }

        this.autocomplete = new google.maps.places.Autocomplete(this.searchTermTarget, {
            types: ['address'],
            fields: ["formatted_address", "geometry"]
        })

        this.autocomplete.addListener('place_changed', this._placeChanged.bind(this))
    }

    _placeChanged() {
        const place = this.autocomplete.getPlace()

        if (!place.geometry) {
            return
        }

        this.latitudeTarget.value = place.geometry.location.lat()
        this.longitudeTarget.value = place.geometry.location.lng()
    }

    disconnect() {
        if (this.autocomplete) {
            google.maps.event.clearInstanceListeners(this.autocomplete)
        }
    }
}