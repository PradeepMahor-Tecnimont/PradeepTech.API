$(document).ready(function () {
    loadOFBAllApprovalsHistoryDataTable();
});
function loadOFBAllApprovalsHistoryDataTable() {
    genericLoadDataTable({
        pDataTableId: "#tbOFBAllApprovalsHistory",
        pColumns: datatableColumnsOFBAllApprovalsHistory,
        pUrl: pvvUrlOFBAllApprovalsHistoryList,
        pUrlParams: {
            genericSearch: $('#OFBAllApprovalsHistorySearch').val() ? $('#OFBAllApprovalsHistorySearch').val() : null,
        },
        pRequestVerificationToken: $('input[name="__RequestVerificationToken"]').val(),

    });
}
function loadOFBPendingApprovalsDataTable() {
    genericLoadDataTable({
        pDataTableId: "#tbOFBPendingApprovalsHistory",
        pColumns: datatableColumnsOFBPendingApprovalsHistory,
        pUrl: pvvUrlOFBPendingApprovalsHistoryList,
        pUrlParams: {
            genericSearch: $('#OFBPendingApprovalsHistorySearch').val() ? $('#OFBPendingApprovalsHistorySearch').val() : null,
        },
        pRequestVerificationToken: $('input[name="__RequestVerificationToken"]').val(),

    });
}
function loadOFBApprovedApprovalsDataTable() {
    genericLoadDataTable({
        pDataTableId: "#tbOFBApprovedApprovalsHistory",
        pColumns: datatableColumnsOFBApprovedApprovalsHistory,
        pUrl: pvvUrlOFBApprovedApprovalsHistoryList,
        pUrlParams: {
            genericSearch: $('#OFBApprovedApprovalsHistorySearch').val() ? $('#OFBApprovedApprovalsHistorySearch').val() : null,
        },
        pRequestVerificationToken: $('input[name="__RequestVerificationToken"]').val(),

    });
}

function loadApprovalsList() {
    genericLoadDataTable({
        pDataTableId: "#tbApprovalDetails",
        pColumns: datatableColumnsOFBApprovalDetails,
        pUrl: pvvUrlOFBApprovalDetailsList,
        pUrlParams: {

            empno: $('#formGetAllApprovals #Empno').val() ? $('#formGetAllApprovals #Empno').val() : null

        },
        pRequestVerificationToken: $('input[name="__RequestVerificationToken"]').val(),
        pPagination: false,
    });
}
function GotoDetails(id) {

    $('#Empno').val(id);
    var frm = $('#formApprovalDetails');
    frm.submit();
}
function initFilter() {

    $('.datepickerFilter').bootstrapMaterialDatePicker({
        format: 'DD-MMM-YYYY',
        weekStart: 0,
        time: false,
        useCurrent: false
    });

    var curdate = new Date();

    var minYear = curdate.getFullYear() - 1;
    var maxYear = curdate.getFullYear();

    $('.selectYearFilter').datepicker({
        format: "yyyy",
        startView: "years",
        minViewMode: "years",
        maxViewMode: "years",
        changeYear: true,
        clearBtn: true,
        defaultViewDate: {
            year: maxYear
        },
        endDate: 'y' 
    });

    $('#startYearFilter').datepicker({
        format: 'yyyy',
        changeYear: true,

    }).on('change', function (e, date) {

        var fvDate = $(this).val();
        if (fvDate) {
            $("#StartYear").val(moment(fvDate, 'YYYY').format("YYYY"));
            var vStartYear = $("#StartYear").val();
            var curdate = new Date();
            var curYear = curdate.getFullYear();

            if (curYear - vStartYear <= 2) {
                $('#endYearFilter').datepicker('setYear', curYear);
                $('#endYearFilter').val(moment(curYear, 'YYYY').format('YYYY'));
                $("#EndYear").val(moment(curYear, 'YYYY').format('YYYY'));
            }
            else {
                var setYear = parseInt(vStartYear) + 2;
                $('#endYearFilter').datepicker('setYear', setYear);
                $('#endYearFilter').val(moment(setYear, 'YYYY').format('YYYY'));
                $("#EndYear").val(moment(setYear, 'YYYY').format('YYYY'));
            }
        }
        else {
            $("#StartYear").val("");
        }
        $(this).datepicker('hide');
    });
    if ($("#StartYear").val()) {
        $('#startYearFilter').val(moment($("#StartYear").val(), "YYYY").format('YYYY'));
    }

    $('#endYearFilter').datepicker({
        format: 'yyyy',
        changeYear: true,

    }).on('change', function (e, date) {

        var fvDate = $(this).val();
        if (fvDate) {
            $("#EndYear").val(moment(fvDate, 'YYYY').format("YYYY"));
        }
        else {
            $("#EndYear").val("");
        }
        $(this).datepicker('hide');
    });
    if ($("#EndYear").val()) {
        $('#endYearFilter').val(moment($("#EndYear").val(), "YYYY").format('YYYY'));
    }
}

function genericSearchKeypress(fnName) {
    if (this.event.keyCode === 13) {
        if (this.length) {
            if (fnName == "OFBAllApprovalsHistorySearch") {
                loadOFBAllApprovalsHistoryDataTable();
            }
            if (fnName == "OFBPendingApprovalsHistorySearch") {
                loadOFBPendingApprovalsDataTable();
            }
            if (fnName == "OFBApprovedApprovalsHistorySearch") {
                loadOFBApprovedApprovalsDataTable();
            }
        }
    }
}

function genericSearchOnClick(fnName) {
    if (this.length) {
        if (fnName == "OFBAllApprovalsHistorySearch") {
            loadOFBAllApprovalsHistoryDataTable();
        }
        if (fnName == "OFBPendingApprovalsHistorySearch") {
            loadOFBPendingApprovalsDataTable();
        }
        if (fnName == "OFBApprovedApprovalsHistorySearch") {
            loadOFBApprovedApprovalsDataTable();
        }
    }
}