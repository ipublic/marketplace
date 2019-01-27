import { Controller } from "stimulus"
import Rails from 'rails-ujs'
import $ from 'jquery'

export default class extends Controller {
  static targets = [ "roleName", "keyName", "permissionTable", "permissionsTableHeader", "checkboxValue" ]

  currentRoles = [];
  currentKeys = [];
  currentPermissions = [];
  selectedPermissions = [];

  initialize() {
    this.getRoles()
    this.getKeys()
  }

  getRoles() {
    let ul = document.getElementById('currentRolesList');
    // Emptys current list items in ul
    while (ul.hasChildNodes()) {
      ul.removeChild(ul.firstChild);
    }
    fetch('/settings/1/get_roles')
      .then(response => {
        return response.json();
      })
      .then(data => {
        // clear currentRoles array before pushing newly added role
        this.currentRoles = [];
        data.map(role => {
          let li = document.createElement("li");
          li.classList.add('list-group-item');
          li.innerText = role.name;
          ul.appendChild(li)
          this.currentRoles.push(role.name)
        })
    })
  }

  getKeys() {
    let ul = document.getElementById('currentKeysList');
    // Emptys current list items in ul
    while (ul.hasChildNodes()) {
      ul.removeChild(ul.firstChild);
    }
    fetch('/settings/2/get_keys')
      .then(response => {
        return response.json();
      })
      .then(data => {
        // clear currentKeys array before pushing newly added role
        this.currentKeys = [];
        data.map(key => {
          let li = document.createElement("li");
          li.classList.add('list-group-item');
          li.innerText = key.name;
          ul.appendChild(li)
          this.currentKeys.push(key.name)
        })
    })
  }

  roleNameValid() {
    let roleName = this.roleNameTarget.value;
    if (!roleName) {
      return false;
    }
    if (this.currentRoles.indexOf(roleName) != -1) {
      $('#exampleModal').modal('show');
      document.getElementById('mdlTxt').innerText = "This role is currently present in the system."
      this.roleNameTarget.value = ''
      return false;
    } else {
      return true
    }
  }

  keyNameValid() {
    let keyName = this.keyNameTarget.value;
    if (!keyName) {
      return false;
    }
    if (this.currentKeys.indexOf(keyName) != -1) {
      $('#exampleModal').modal('show');
      document.getElementById('mdlTxt').innerText = "This key is currently present in the system."
      this.keyNameTarget.value = ''
      return false;
    } else {
      return true
    }
  }

  postRole() {
    let role = this.roleNameTarget.value;
    fetch('/settings/11/create_role', {
      method: 'POST',
      body: JSON.stringify({name: role}),
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': Rails.csrfToken()
      },
      credentials: 'same-origin',
    })
    .then(response => response.json())
    .then(response => {
      if (response.code === 200) {
        this.getRoles()
        this.roleNameTarget.value = ''
      }
    })
  }

  postKey() {
    let key = this.keyNameTarget.value;
    fetch('/settings/12/create_key', {
      method: 'POST',
      body: JSON.stringify({name: key}),
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': Rails.csrfToken()
      },
      credentials: 'same-origin',
    })
    .then(response => response.json())
    .then(response => {
      if (response.code === 200) {
        this.getKeys()
        this.keyNameTarget.value = ''
      }
    })
  }

  validateForm(event) {
    event.preventDefault()
    let id = event.target.id;
    if (id === 'roleForm' && this.roleNameValid()) {
      this.postRole()
    }
    if (id === 'keyForm' && this.keyNameValid()) {
      this.postKey()
    }
  }

  loadTableData() {
    this.loadTableHeaders()
    this.loadTableRows()
    this.setCheckboxes()
  }

  loadTableHeaders() {
    let tr = document.getElementById('permissionsHeaderRow')
    let col = document.createElement("th")
    // Clears current th values from ui
    while (tr.hasChildNodes()) {
      tr.removeChild(tr.firstChild);
    }

    let th1 = document.createElement("th");
    th1.innerText = "";
    tr.appendChild(th1)

    this.currentKeys.map((key, i) => {
      let th = document.createElement("th");
      th.innerText = key;
      tr.appendChild(th)
    })
  }

  loadTableRows() {
    let tableBody = document.getElementById('permissionsTableBody')
    // Clears current th values from tableBody
    while (tableBody.hasChildNodes()) {
      tableBody.removeChild(tableBody.firstChild);
    }

    this.currentRoles.map(role => {
      let tr = document.createElement("tr")
      let th = document.createElement("th")
      th.setAttribute('scope', 'col')
      th.innerText = role;
      tr.appendChild(th)

      this.currentKeys.map((key, i) => {
         let role = document.createElement("td")
         role.innerHTML = `
          <label class="cb-container">
            <input type="checkbox" data-target="settings.checkboxValue" data-index="${i}" id="permissionCheckbox" data-key="${key}">
            <span class="checkmark"></span>
          </label>
         `
         tr.appendChild(role)
      })
      tableBody.appendChild(tr)
    })
  }

  submitPermissions() {
    let table = this.permissionTableTarget
    let rows = table.querySelector('tr#permissionsHeaderRow').querySelectorAll('th')
    let roleRows = table.querySelector('#permissionsTableBody').querySelectorAll('tr')
    let tableKeys = [];
    let tmpArr = [];
    let permissions = [];
    this.selectedPermissions = [];
    Array.prototype.forEach.call(rows, function (row, i) {
      if (i > 0) tableKeys.push(row.innerText)
    });
    Array.prototype.forEach.call(roleRows, function (role, i) {
      let keys = role.querySelector('th').innerText;
      let values = role.querySelectorAll('td')
      tmpArr.push(keys)
      Array.prototype.forEach.call(values, function (value, i) {
        let hash = {}
        let inputKey = tableKeys[i];
        let inputValue = value.querySelector('input').checked;
        hash['role'] = keys
        hash['name'] = inputKey
        hash['granted'] = inputValue;

        permissions.push(hash)
      });
    });
     this.selectedPermissions.push(permissions)
     this.postPermissions()
  }

  postPermissions() {
    // Formats array for rails
    let data = this.selectedPermissions[0].reduce((a, e) => {
      // Groups by role and attaches permissions
      let estKey = (e['role']);

      (a[estKey] ? a[estKey] : (a[estKey] = null || [])).push(e);
      return a
    }, {});

    fetch('/settings/1/create_permissions', {
      method: 'POST',
      body: JSON.stringify({data: data}),
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': Rails.csrfToken()
      },
      credentials: 'same-origin',
    })
    .then(response => response.json())
    .then(response => {
      // console.log(response)
    })
  }

  setCheckboxes() {
    fetch('/settings/2/get_permissions')
      .then(response => {
        return response.json();
      })
      .then(data => {
        data.map(key => {
        this.checkboxValueTargets.map((checkbox) => {
          let role = checkbox.closest('tr').querySelector('th').innerText;
          let checkboxIndex = checkbox.dataset.index;
          let index = key['filter_tokens'];
          if (key['role_name'] === role && index[checkboxIndex]) {
            checkbox.checked = index[checkboxIndex]['granted'];
          }
        })
      })
    })
  }

}
