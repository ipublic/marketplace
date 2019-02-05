import { Controller } from "stimulus"

export default class extends Controller {
  registeredEmployer;
  title;

  initialize() {
    let admin = localStorage.getItem('Is Admin');
    this.registeredEmployer = localStorage.getItem('Registered')

    if (admin) {
      document.getElementById('ee-employer').classList.add('d-none');
    }

    if (admin == null) {
      document.getElementById('menu-settings').classList.add('d-none')
      document.getElementById('employer-menu-option').classList.add('d-none');
      document.getElementById('tpa-menu').classList.add('d-none');
      document.getElementById('dashboard-menu').classList.add('d-none');
      document.getElementById('ee-employer').classList.remove('d-none');
      this.getIdeaCrew();
    }

    let titlePresent = localStorage.getItem('title')
    let erId = window.location.pathname.split('/')[2];

    if (this.registeredEmployer && !titlePresent) {
      let title = document.getElementById('account-title').innerText;
      localStorage.setItem('title', title);
      document.getElementById('er-name').innerText = localStorage.getItem('title');
      document.getElementById('ee-wage-report').setAttribute("href", `/employers/${erId}/wage_reports`);
      document.getElementById('ee-profile').setAttribute("href", `/employers/${erId}`);
      document.getElementById('ee-account').setAttribute("href", `/employers/${erId}/accounts`);
    }

    if (!this.registeredEmployer) {
      document.getElementById('er-name').innerText = 'IdeaCrew';
    }

    if (titlePresent) {
      document.getElementById('er-name').innerText = localStorage.getItem('title');
      document.getElementById('ee-wage-report').setAttribute("href", `/employers/${erId}/wage_reports`);
      document.getElementById('ee-profile').setAttribute("href", `/employers/${erId}`);
      document.getElementById('ee-account').setAttribute("href", `/employers/${erId}/accounts`);
    }
  }

  getIdeaCrew() {
    let employers = [];
    fetch('/employers/11/get_employers')
      .then(response => {
        return response.json();
      })
      .then(data => {
        data.data.filter(item => {
          if (item.legal_name === "IdeaCrew" && !this.registeredEmployer) {
            document.getElementById('ee-wage-report').setAttribute("href", `/employers/${item['_id']['$oid']}/wage_reports`);
            document.getElementById('ee-profile').setAttribute("href", `/employers/${item['_id']['$oid']}`);
            document.getElementById('ee-account').setAttribute("href", `/employers/${item['_id']['$oid']}/accounts`);
          }
        })
      })
  }
}
