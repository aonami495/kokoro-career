import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "button", "iconShow", "iconHide"]

  toggle() {
    const isPassword = this.inputTarget.type === "password"
    this.inputTarget.type = isPassword ? "text" : "password"
    this.iconShowTarget.classList.toggle("hidden", isPassword)
    this.iconHideTarget.classList.toggle("hidden", !isPassword)
    this.buttonTarget.setAttribute("aria-label", isPassword ? "パスワードを非表示" : "パスワードを表示")
  }
}
