import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu", "content"]

  connect() {
    // 初期状態: サイドバーを非表示にする
    this.hide()
  }

  toggle() {
    if (this.menuTarget.classList.contains("-translate-x-full")) {
      this.show()
    } else {
      this.hide()
    }
  }

  show() {
    // サイドバーを表示
    this.menuTarget.classList.remove("-translate-x-full")
    this.contentTarget.classList.remove("ml-0")
    this.contentTarget.classList.add("ml-64")
  }

  hide() {
    // サイドバーを非表示
    this.menuTarget.classList.add("-translate-x-full")
    this.contentTarget.classList.remove("ml-64")
    this.contentTarget.classList.add("ml-0")
  }
}
