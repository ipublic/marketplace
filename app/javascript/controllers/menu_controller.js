import { Controller } from "stimulus"

export default class extends Controller {

  initialize() {
    let admin = localStorage.getItem('Is Admin');

    if (admin) {
      document.getElementById('ee-employer').classList.add('d-none');
    }

    if (admin == null) {
      document.getElementById('menu-settings').classList.add('d-none')
      document.getElementById('employer-menu-option').classList.add('d-none');
      document.getElementById('tpa-menu').classList.add('d-none');
      document.getElementById('dashboard-menu').classList.add('d-none');
      document.getElementById('notifications-menu').classList.add('d-none');
      document.getElementById('ee-employer').classList.remove('d-none');
    }
  }
}
