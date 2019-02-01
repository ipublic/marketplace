import { Controller } from "stimulus"
import $ from 'jquery';
import 'datatables';


export default class extends Controller {

  static targets = ["selectedEmployer"]

  initialize() {
    let table = $('#employerDataTable').DataTable({
      "bPaginate": false,
      "ajax": {
        "url": "/employers/1/get_employers",
        "type": "get"
      },
      "columns": [
          { "data": "legal_name",
            "fnCreatedCell": function (nTd, sData, oData, iRow, iCol) {
                $(nTd).html("<a href='javascript:;' data-action='click->employers#goToEmployer' data-target='employers.selectedEmployer' data-id='"+oData._id['$oid']+"'>"+oData.legal_name+"</a>");
            }
          },
          { "data": "fein" },
          { "data": "entity_kind" }
      ]
    });
  }

  goToEmployer(event) {
    document.getElementById('employers').classList.add('show')
    let selectedEmployerName = event.target.innerHTML;
    let employerId = event.target.dataset.id;
    document.getElementById('employerName').innerHTML = selectedEmployerName;
    document.getElementById('employerWageReport').setAttribute("href", `/employers/${employerId}/wage_reports`);
    this.employerName = selectedEmployerName;
  }

}
