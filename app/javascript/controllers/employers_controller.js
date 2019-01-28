import { Controller } from "stimulus"
import $ from 'jquery';
import 'datatables';


export default class extends Controller {

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
        { "data": "name" },
        { "data": "fein" },
        { "data": "tpa" },
        { "data": "active" },
    ]
    });

    table.on( 'select', function ( e, dt, type, indexes ) {
    if ( type === 'row' ) {
        var data = table.rows( indexes ).data().pluck( 'id' );


    }
    console.log(table)
} );
  }

  loadDataTableData() {
    
  }
}
