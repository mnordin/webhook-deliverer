import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "expandable" ]
  static classes = [ "collapsed" ]

  connect() {
    this.expandableTargets.forEach((element) => {
      element.classList.add(this.collapsedClass)
    })
    this.element.classList.add("cursor-pointer")
  }

  expand() {
    this.expandableTargets.forEach((element) => {
      element.classList.remove(this.collapsedClass)
    })
    this.element.classList.remove("cursor-pointer")
  }
}
