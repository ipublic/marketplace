import { Controller } from "stimulus"
import $ from 'jquery';
import 'datatables';


export default class extends Controller {

  static targets = ["selectedEmployer"]

  initialize() {
    let table = $('#employerDataTable').DataTable({
      "data": [
        {
            "name": "Amazon",
            "fein": "01928435",
            "tpa": "Larry Miller",
            "active": "true"
        },
        {
          "name": "BestBuy",
          "fein": "1912345",
          "tpa": "John Brown",
          "active": "true"
        },
        {
          "name": "Costco",
          "fein": "7772345",
          "tpa": "N/A",
          "active": "true"
        },
        {
          "name": "Delta",
          "fein": "2211110",
          "tpa": "Sue Harris",
          "active": "true"
        },
        // ...
    ],
    "columns": [
        { "data": "name",
          "fnCreatedCell": function (nTd, sData, oData, iRow, iCol) {
              $(nTd).html("<a href='' data-action='click->employers#goToEmployer' data-target='employers.selectedEmployer'>"+oData.name+"</a>");
          }
        },
        { "data": "fein" },
        { "data": "tpa" },
        { "data": "active" },
    ]
    });
  }

  goToEmployer(event) {
    setTimeout(() => {
      document.querySelector('.fa-bars').click();
      document.getElementById('employers').classList.add('show')
      let selectedEmployerName = event.target.innerHTML;
      document.getElementById('employerName').innerHTML = selectedEmployerName;
    },400);
  }
}
