import { Controller } from "stimulus"

export default class extends Controller {

  initialize() {
    let admin = localStorage.getItem('Is Admin');
    let employerLanding = document.getElementById('employerLanding')
    let adminLanding = document.getElementById('adminLanding')
    if (admin) {
      if (employerLanding) {
        employerLanding.classList.add('d-none')
        adminLanding.classList.remove('d-none')
      }
    }
    if (admin == null) {
      if (employerLanding) {
        employerLanding.classList.remove('d-none')
        adminLanding.classList.add('d-none')
      }
    }
  }
}
