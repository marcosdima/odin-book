import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["card"]

  connect() {
    this.cardTargets.forEach((card) => {
      card.timeout = setTimeout(() => {
        this.hide(card)
      }, 4000)
    })
  }

  close(event) {
    const card = event.target.closest(".flash-card")

    clearTimeout(card.timeout)
    this.hide(card)
  }

  hide(card) {
    if (card.classList.contains("flash-hide")) return

    card.classList.add("flash-hide")

    setTimeout(() => {
      card.remove()
    }, 400)
  }
}