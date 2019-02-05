import { Controller } from "stimulus"
import $ from 'jquery';
import 'datatables';

export default class extends Controller {

  initialize() {
    $.fn.dataTable.ext.errMode = 'none';

    let table = $('#tpaDataTable').DataTable({
      "bPaginate": true,
			"columnDefs": [
            {
                "targets": [ 0 ],
                "className": 'mdl-data-table__cell--non-numeric'
            }
        ],
      "ajax": {
        "url": "/tpas/1/get_tpas",
        "type": "get"
      },
      "columns": [
          { "data": "current_first_name",
            "fnCreatedCell": function (nTd, sData, oData, iRow, iCol) {
                if (oData.current_first_name ) {
                  $(nTd).html(`${oData.current_first_name} ${oData.current_last_name}`);
                }
            }
          }
      ]
    });
  }

}
