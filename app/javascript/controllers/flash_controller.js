import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="flash"
export default class extends Controller {
  static values = { timeout: Number };

  connect() {
    setTimeout(() => {
      this.dismiss();
    }, this.timeoutValue || 3000); // Default to 3000ms if no timeout is provided
  }

  dismiss() {
    this.element.remove();
  }
}
