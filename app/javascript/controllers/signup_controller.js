import { Controller } from "stimulus"

export default class extends Controller {

	static targets = [ "continueBtn" ]

	targetValue;

	setRoute(event) {
		if (event.target.value !== 'Select a portal to get started') {
			this.targetValue = event.target.value;
			this.continueBtnTarget.closest('fieldset').removeAttribute('disabled')
		} else {
			this.continueBtnTarget.closest('fieldset').setAttribute('disabled', true)
		}

		if (event.target.value == 0) {
			localStorage.setItem('Is Admin', true)
		} else {
			localStorage.removeItem('Is Admin')
		}
	}

	goToRoute() {
		if (this.targetValue === 'register') {
			window.location.pathname = 'employers/new'
		} else {
			window.location.pathname = 'dashboard'
		}
	}
}
