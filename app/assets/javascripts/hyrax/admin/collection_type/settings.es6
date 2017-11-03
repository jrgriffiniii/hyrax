export default class {
  constructor(element) {
    this.element = element
  }

  setup() {
    // Watch for changes to "sharable" radio inputs
    let sharableInput = this.element.find("input[type='checkbox'][name$='[sharable]']")
    $(sharableInput).on('change', () => { this.sharableChanged() })
    this.sharableChanged()
  }

  // Based on the "sharable" checked/unchecked, enable/disable share_applies_to radio buttons
  sharableChanged() {
    let selected = this.element.find("input[type='checkbox'][name$='[sharable]']:checked")

    if(selected.val()) {
        this.element.find("input[type='radio'][name$='[share_applies_to]']").prop("disabled", false)
    }
    else {
        this.element.find("input[type='radio'][name$='[share_applies_to]']").prop("disabled", true)
    }
  }
}
