var dataTable;
var d;
$(document).ready(function () {
    //loadDataTable();
    loadAJAX();
});

function loadAJAX() {
    $.ajax({
        url: "/Country/GetAll",
        method: "GET",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data) {
            d = data;
 
            $('#tblData').dataTable({
                dom: 'Bfrtip',
                buttons: [
                    'colvis',
                    'excel',
                    'print'
                ],
                data: d,
                "columns": [
                    { "data":"countryId"},
                    { "data": "countryName" },
                    { "data": "regionId" }
                ]
            });
        }
    });
}


function loadDataTable() {
    var table = $("#tblData").DataTable({
        //"responsive": true,
        //"processing": true,

        //"language": {
        //    "loadingRecords": "<span class='fa-stack fa-lg'>\n\
        //                    <i class='fa fa-spinner fa-spin fa-stack-2x fa-fw'></i>\n\
        //               </span>&emsp;Processing ..."
        //},
        //'columnDefs': [
        //    {
        //        "targets": 0,
        //        "className": "text-center",
        //        "className": "align-middle",
        //        "width": "4%"
        //    },
        //    { responsivePriority: 1, targets: 0 },
        //    { responsivePriority: 2, targets: -1 }
        //],
        //"scrollY": 300,
        //"scrollX": true,
        //responsive: {
        //    details: {
        //        display: $.fn.dataTable.Responsive.display.childRowImmediate
        //    }
        //},
        "ajax": {
            "url": "/Country/GetAll",
            "type": "GET",
            "datatype": "json"
        },
        "columns": [
            { "data": 0 },
            { "data": 1 },
            { "data": 2 },
            { "data": 3 },
            { "data": 4 }
        ]
        //    "language": {
        //        "emptyTable": "No records found",
        //        "width": "100%"
        //    },
    });

    //new $.fn.dataTable.FixedHeader(table);
};
