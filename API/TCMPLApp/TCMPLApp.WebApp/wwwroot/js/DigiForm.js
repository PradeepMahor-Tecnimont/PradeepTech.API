function loadApprovalsList() {
    genericLoadDataTable({
        pDataTableId: "#tbApprovalDetails",
        pColumns: datatableColumnsApprovalDetails,
        pUrl: pvvUrlApprovalDetailsList,
        pUrlParams: {
            keyId: $('#formGetAllApprovalsDetails #KeyId').val() ? $('#formGetAllApprovalsDetails #KeyId').val() : null
        },
        pRequestVerificationToken: $('input[name="__RequestVerificationToken"]').val(),
        pPagination: false,
    });
}
function loadCostcodeChangeRequestDataTable() {
    genericLoadDataTable({
        pDataTableId: "#tbCostcodeChangeRequest",
        pColumns: datatableCostcodeChangeRequestColumns,
        pUrl: vVUloadCostcodeChangeRequestDataTableList,
        pUrlParams: {
            genericSearch: $('#GenericSearch').val() ? $('#GenericSearch').val() : null,
        },
        pRequestVerificationToken: $('input[name="__RequestVerificationToken"]').val()
    });
};
function loadHodApprovalsRequestsDataTable() {
    genericLoadDataTable({
        pDataTableId: "#tbHodApprovalsRequests",
        pColumns: datatableHodApprovalsColumns,
        pUrl: vVUloadHodApprovalsRequestsDataTableList,
        pUrlParams: {
            genericSearch: $('#GenericSearch').val() ? $('#GenericSearch').val() : null,
        },
        pRequestVerificationToken: $('input[name="__RequestVerificationToken"]').val()
    });
};
function loadHodApprovalsHistoryDataTable() {
    genericLoadDataTable({
        pDataTableId: "#tbHodApprovalsHistory",
        pColumns: datatableHodApprovalHistoryColumns,
        pUrl: vVUloadHodApprovalsHistoryDataTableList,
        pUrlParams: {
            genericSearch: $('#GenericSearch').val() ? $('#GenericSearch').val() : null,
            currentCostcode: $('#FilterDataModel_CurrentCostcode').val() ? $('#FilterDataModel_CurrentCostcode').val() : null,
            targetCostcode: $('#FilterDataModel_TargetCostcode').val() ? $('#FilterDataModel_TargetCostcode').val() : null,
        },
        pRequestVerificationToken: $('input[name="__RequestVerificationToken"]').val()
    });
};
function loadHrApprovalsHistoryDataTable() {
    genericLoadDataTable({
        pDataTableId: "#tbHrApprovalsHistory",
        pColumns: datatableHrApprovalHistoryColumns,
        pUrl: vVUloadHrApprovalsHistoryDataTableList,
        pUrlParams: {
            genericSearch: $('#GenericSearch').val() ? $('#GenericSearch').val() : null,
            currentCostcode: $('#FilterDataModel_CurrentCostcode').val() ? $('#FilterDataModel_CurrentCostcode').val() : null,
            targetCostcode: $('#FilterDataModel_TargetCostcode').val() ? $('#FilterDataModel_TargetCostcode').val() : null,
        },
        pRequestVerificationToken: $('input[name="__RequestVerificationToken"]').val()
    });
};
function loadHRApprovalsRequestsDataTable() {
    genericLoadDataTable({
        pDataTableId: "#tbHRApprovalsRequests",
        pColumns: datatableHRApprovalsColumns,
        pUrl: vVUloadHRApprovalsRequestsDataTableList,
        pUrlParams: {
            genericSearch: $('#GenericSearch').val() ? $('#GenericSearch').val() : null,
        },
        pRequestVerificationToken: $('input[name="__RequestVerificationToken"]').val()
    });
};
function loadHRApprovedApprovalsDataTable() {
    genericLoadDataTable({
        pDataTableId: "#tbHRApprovedApprovals",
        pColumns: datatableHrApprovedApprovalColumns,
        pUrl: vVUloadHrApprovedApprovalsDataTableList,
        pUrlParams: {
            genericSearch: $('#GenericSearch').val() ? $('#GenericSearch').val() : null,
        },
        pRequestVerificationToken: $('input[name="__RequestVerificationToken"]').val()
    });
};
function loadHRApprovalsReturnRequestsDataTable() {
    genericLoadDataTable({
        pDataTableId: "#tbHRApprovalsReturnRequests",
        pColumns: datatableHRApprovalReturnColumns,
        pUrl: vVUloadHRApprovalsReturnRequestsDataTableList,
        pUrlParams: {
            genericSearch: $('#GenericSearch').val() ? $('#GenericSearch').val() : null,
        },
        pRequestVerificationToken: $('input[name="__RequestVerificationToken"]').val()
    });
};
function loadTemporaryEmployeesDataTable() {
    genericLoadDataTable({
        pDataTableId: "#tbTemporaryEmployees",
        pColumns: datatableTemporaryEmployeesColumns,
        pUrl: vVUloadTemporaryEmployeesDataTableList,
        pUrlParams: {
            genericSearch: $('#GenericSearch').val() ? $('#GenericSearch').val() : null,
        },
        pRequestVerificationToken: $('input[name="__RequestVerificationToken"]').val()
    });
};

function loadHodTransferEmployeesDataTable() {
    genericLoadDataTable({
        pDataTableId: "#tbHodTransferEmployees",
        pColumns: datatableHodTransferEmployeesColumns,
        pUrl: vVUloadHodTransferEmployeesDataTableList,
        pUrlParams: {
            genericSearch: $('#GenericSearch').val() ? $('#GenericSearch').val() : null,
        },
        pRequestVerificationToken: $('input[name="__RequestVerificationToken"]').val()
    });
};

function loadHrTransferEmployeesDataTable() {
    genericLoadDataTable({
        pDataTableId: "#tbHrTransferEmployees",
        pColumns: datatableHrTransferEmployeesColumns,
        pUrl: vVUloadHrTransferEmployeesDataTableList,
        pUrlParams: {
            genericSearch: $('#GenericSearch').val() ? $('#GenericSearch').val() : null,
        },
        pRequestVerificationToken: $('input[name="__RequestVerificationToken"]').val()
    });
};
function loadSiteMasterDataTable() {
    genericLoadDataTable({
        pDataTableId: "#tbSiteMaster",
        pColumns: datatableColumnsSiteMasterDetails,
        pUrl: vVUloadSiteMasterDataTableList,
        pUrlParams: {
            genericSearch: $('#GenericSearch').val() ? $('#GenericSearch').val() : null,
        },
        pRequestVerificationToken: $('input[name="__RequestVerificationToken"]').val()
    });
};

function loadHODAnnualPendingEvaluationDataTable() {
    genericLoadDataTable({
        pDataTableId: "#tbPendingAnnualEvaluation",
        pColumns: datatableHODAnnualEvaluationPendingColumns,
        pUrl: vVUloadHODAnnualPendingEvaluationDataTableList,
        pUrlParams: {
            genericSearch: $('#GenericSearch').val() ? $('#GenericSearch').val() : null,
            grade: $('#FilterDataModel_Grade').val() ? $('#FilterDataModel_Grade').val() : null,
            parent: $('#FilterDataModel_Parent').val() ? $('#FilterDataModel_Parent').val() : null,
        },
        pRequestVerificationToken: $('input[name="__RequestVerificationToken"]').val()
    });
};

function loadHRAnnualPendingEvaluationDataTable() {
    genericLoadDataTable({
        pDataTableId: "#tbHRPendingAnnualEvaluation",
        pColumns: datatableHRAnnualEvaluationPendingColumns,
        pUrl: vVUloadHRAnnualPendingEvaluationDataTableList,
        PStateSave: false,
        pUrlParams: {
            genericSearch: $('#GenericSearch').val() ? $('#GenericSearch').val() : null,
            grade: $('#FilterDataModel_Grade').val() ? $('#FilterDataModel_Grade').val() : null,
            parent: $('#FilterDataModel_Parent').val() ? $('#FilterDataModel_Parent').val() : null,
        },
        pRequestVerificationToken: $('input[name="__RequestVerificationToken"]').val()
    });
};

function loadHRAnnualHistoryEvaluationDataTable() {
    genericLoadDataTable({
        pDataTableId: "#tbHRHistoryAnnualEvaluation",
        pColumns: datatableHRAnnualEvaluationHistoryColumns,
        pUrl: vVUloadHRAnnualHistoryEvaluationDataTableList,
        pUrlParams: {
            genericSearch: $('#GenericSearch').val() ? $('#GenericSearch').val() : null,
            grade: $('#FilterDataModel_Grade').val() ? $('#FilterDataModel_Grade').val() : null,
            parent: $('#FilterDataModel_Parent').val() ? $('#FilterDataModel_Parent').val() : null,
        },
        pRequestVerificationToken: $('input[name="__RequestVerificationToken"]').val()
    });
};

function loadHRAnnualActionPendingEvaluationDataTable() {
    genericLoadDataTable({
        pDataTableId: "#tbHRActionAnnualEvaluation",
        pColumns: datatableHRAnnualEvaluationActionPendingColumns,
        pUrl: vVUloadHRAnnualActionPendingEvaluationDataTableList,
        pUrlParams: {
            genericSearch: $('#GenericSearch').val() ? $('#GenericSearch').val() : null,
            grade: $('#FilterDataModel_Grade').val() ? $('#FilterDataModel_Grade').val() : null,
            parent: $('#FilterDataModel_Parent').val() ? $('#FilterDataModel_Parent').val() : null,
        },
        pRequestVerificationToken: $('input[name="__RequestVerificationToken"]').val()
    });
};

function loadHODAnnualHistoryEvaluationDataTable() {
    genericLoadDataTable({
        pDataTableId: "#tbHistoryAnnualEvaluation",
        pColumns: datatableHODAnnualEvaluationHistoryColumns,
        pUrl: vVUloadHODAnnualHistoryEvaluationDataTableList,
        pUrlParams: {
            genericSearch: $('#GenericSearch').val() ? $('#GenericSearch').val() : null,
            grade: $('#FilterDataModel_Grade').val() ? $('#FilterDataModel_Grade').val() : null,
            parent: $('#FilterDataModel_Parent').val() ? $('#FilterDataModel_Parent').val() : null,
        },
        pRequestVerificationToken: $('input[name="__RequestVerificationToken"]').val()
    });
};
function initDatePicker() {
    var minDate = moment().add('-30', 'days');
    $('.datepicker').bootstrapMaterialDatePicker({
        format: 'DD-MMM-YYYY',
        weekStart: 0,
        time: false,
        nowButton: true,
        minDate: minDate
    });

    $('#transferDate').bootstrapMaterialDatePicker({
        format: 'DD-MMM-YYYY',
        weekStart: 0,
        time: false
    }).on('change', function (e, date) {
        $("#TransferDate").val(date.format('DD-MMM-YYYY'));

        $("#transferEndDate").val(date.format('DD-MMM-YYYY'));

        $('#transferEndDate').bootstrapMaterialDatePicker('setMinDate', date);
        $("#TransferEndDate").val($("#transferEndDate").val());
    });

    $('#transferEndDate').bootstrapMaterialDatePicker({
        format: 'DD-MMM-YYYY',
        weekStart: 0,
        time: false,
        minDate: $("#TransferEndDate").val()
    }).on('change', function (e, date) {
        $("#TransferEndDate").val(date.format('DD-MMM-YYYY'));
    });

    $('#effectiveTransferDate').bootstrapMaterialDatePicker({
        format: 'DD-MMM-YYYY',
        weekStart: 0,
        time: false
    }).on('change', function (e, date) {
        $("#EffectiveTransferDate").val(date.format('DD-MMM-YYYY'));
    });

    if ($('#TransferDate').val()) {
        $('#transferDate').bootstrapMaterialDatePicker('setDate', new Date($("#TransferDate").val()));
    }
    if ($('#TransferEndDate').val()) {
        $('#transferEndDate').bootstrapMaterialDatePicker('setDate', new Date($("#TransferEndDate").val()));
        $('#transferEndDate').bootstrapMaterialDatePicker('setMinDate', new Date($("#TransferDate").val()));
    }
}