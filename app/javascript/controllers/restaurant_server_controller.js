import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="restaurant-server"
export default class extends Controller {
  static targets = ["ordered", "ready"]

  connect() {
    setInterval(() => { this.updateSinceOrdered() }, 60000);
    setInterval(() => { this.updateUntilReady() }, 60000);
  }

  updateSinceOrdered() {
    this.orderedTarget.innerHTML = (parseInt(this.orderedTarget.innerHTML, 10) + 1) + " min"
  }

  updateUntilReady() {
    this.readyTarget.innerHTML = (parseInt(this.readyTarget.innerHTML, 10) - 1) + " min"
  }


}
