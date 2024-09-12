var dataTable;
var d;
$(document).ready(function () {
    loadDataTable();
    //loadAJAX();
});

function loadAJAX() {
    $.ajax({
        url: "/Employee/GetAll",
        method: "GET",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data) {
            d = data;
 
            $('#tblData').dataTable({
                data: d,
                "columnDefs": [{
                    targets: 4, render: function (data) {
                        return moment(data).format('DD-MMM-YYYY');
                    }
                }],
                "columns": [
                    { "data":"employeeId"},
                    { "data": "firstName" },
                    { "data": "lastName" },
                    { "data": "email" },
                    { "data": "hireDate" },
                    { "data": "jobId" },
                    { "data": "job" }
                ]
            });
        }
    });
}


function loadDataTable() {
    var table = $("#tblData").DataTable({
        "responsive": true,
        "processing": true,

        "language": {
            "loadingRecords": "<span class='fa-stack fa-lg'>\n\
                            <i class='fa fa-spinner fa-spin fa-stack-2x fa-fw'></i>\n\
                       </span>&emsp;Processing ..."
        },
        'columnDefs': [
            {
                "targets": 0,
                "className": "text-center",
                "className": "align-middle",
                "width": "4%"
            },
            { responsivePriority: 1, targets: 0 },
            { responsivePriority: 2, targets: -1 }
        ],
        "ajax": {
            "url": "/Employee/GetAll",
            "type": "GET",
            "contentType": "application/json; charset=utf-8",
            "datatype": "json",
            "dataSrc" : ""
        },
        "columns": [
            { "data": "employeeId" },
            { "data": "firstName" },
            { "data": "lastName" },
            { "data": "email" },
            { "data": "hireDate" },
            { "data": "jobId" },
            { "data": "job" }
        ],
        "language": {
            "emptyTable": "No records found",
            "width": "100%"
        }
    });

    //new $.fn.dataTable.FixedHeader(table);
};
