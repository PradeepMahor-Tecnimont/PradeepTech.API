$(document).ready(function () {
    loadModuleRolesDataTable();
});

function loadModuleRolesDataTable() {
    genericLoadDataTable({
        pDataTableId: "#tbModulesModuleRoles",
        pColumns: datatableColumnsModuleRoles,
        pUrl: pvvUrlModuleRolesList,
        pUrlParams: {
            genericSearch: $('#ModuleRoleSearch').val() ? $('#ModuleRoleSearch').val() : null,
            ModuleId: $('#ModuleId').val()
        },
        pRequestVerificationToken: $('input[name="__RequestVerificationToken"]').val(),

    });
}

function loadModuleRolesActionDataTable() {
    genericLoadDataTable({
        pDataTableId: "#tbModuleRolesActions",
        pColumns: datatableColumnsModuleRolesActions,
        pUrl: pvvUrlModuleRolesActionsList,
        pUrlParams: {
            genericSearch: $('#ModuleRoleActionSearch').val() ? $('#ModuleRoleActionSearch').val() : null,
            ModuleId: $('#ModuleId').val(),
            roleId: $('#FilterDataModel_RoleId').val() ? $('#FilterDataModel_RoleId').val() : null,
            actionId: $('#FilterDataModel_ActionId').val() ? $('#FilterDataModel_ActionId').val() : null,
        },
        pRequestVerificationToken: $('input[name="__RequestVerificationToken"]').val(),

    });
}

function loadModuleUserRolesDataTable() {
    genericLoadDataTable({
        pDataTableId: "#tbModuleUserRoles",
        pColumns: datatableColumnsModuleUserRoles,
        pUrl: pvvUrlModuleUserRolesList,
        pUrlParams: {
            genericSearch: $('#ModuleUserRoleSearch').val() ? $('#ModuleUserRoleSearch').val() : null,
            ModuleId: $('#ModuleId').val(),
            roleId: $('#FilterDataModel_RoleId').val() ? $('#FilterDataModel_RoleId').val() : null,
            empno: $('#FilterDataModel_Empno').val() ? $('#FilterDataModel_Empno').val() : null,
        },
        pRequestVerificationToken: $('input[name="__RequestVerificationToken"]').val(),

    });
}

function loadModuleUserRolesActionDataTable() {
    genericLoadDataTable({
        pDataTableId: "#tbModuleUserRolesActions",
        pColumns: datatableColumnsModuleUserRolesAction,
        pUrl: pvvUrlModuleUserRolesActionList,
        pUrlParams: {
            genericSearch: $('#ModuleUserRoleActionSearch').val() ? $('#ModuleUserRoleActionSearch').val() : null,
            ModuleId: $('#ModuleId').val(),
            roleId: $('#FilterDataModel_RoleId').val() ? $('#FilterDataModel_RoleId').val() : null,
            actionId: $('#FilterDataModel_ActionId').val() ? $('#FilterDataModel_ActionId').val() : null,
        },
        pRequestVerificationToken: $('input[name="__RequestVerificationToken"]').val(),

    });
}

function loadModuleUserRoleLogsDataTable() {
    genericLoadDataTable({
        pDataTableId: "#tbModuleUserRoleLogs",
        pColumns: datatableColumnsModuleUserRoleLogs,
        pUrl: vUrlModuleRoleLogsList,
        pUrlParams: {
            genericSearch: $('#ModuleUserRoleLogsSearch').val() ? $('#ModuleUserRoleLogsSearch').val() : null,
            ModuleId: $('#ModuleId').val(),
            roleId: $('#FilterDataModel_RoleId').val() ? $('#FilterDataModel_RoleId').val() : null,
            empno: $('#FilterDataModel_Empno').val() ? $('#FilterDataModel_Empno').val() : null,
        },
        pRequestVerificationToken: $('input[name="__RequestVerificationToken"]').val()

    });
};
function loadModuleDelegateDataTable() {
    genericLoadDataTable({
        pDataTableId: "#tbModuleDelegate",
        pColumns: datatableColumnsDelegate,
        pUrl: pvvUrlModuleDelegateList,
        pUrlParams: {
            genericSearch: $('#ModuleDelegateSearch').val() ? $('#ModuleDelegateSearch').val() : null,
            ModuleId: $('#ModuleId').val()
        },
        pRequestVerificationToken: $('input[name="__RequestVerificationToken"]').val(),

    });
}
function loadModuleDelegateLogsDataTable() {
    genericLoadDataTable({
        pDataTableId: "#tbModuleDelegateLogs",
        pColumns: datatableColumnsDelegateLogs,
        pUrl: pvvUrlModuleDelegateLogsList,
        pUrlParams: {
            genericSearch: $('#ModuleDelegateLogsSearch').val() ? $('#ModuleDelegateLogsSearch').val() : null,
            ModuleId: $('#ModuleId').val()
        },
        pRequestVerificationToken: $('input[name="__RequestVerificationToken"]').val(),
    });
}
function loadModuleUserRoleCostCodeDataTable() {
    genericLoadDataTable({
        pDataTableId: "#tbModuleUserRolesCostcode",
        pColumns: datatableColumnsModuleUserRoleCostCode,
        pUrl: pvvUrlModuleUserRoleCostCodeList,
        pUrlParams: {
            genericSearch: $('#ModuleUserRoleCostcodeSearch').val() ? $('#ModuleUserRoleCostcodeSearch').val() : null,
            ModuleId: $('#ModuleId').val()
        },
        pRequestVerificationToken: $('input[name="__RequestVerificationToken"]').val(),
    });
}
function GotoModuleUserRoleLogs() {

    loadModuleUserRoleLogsDataTable();
    $("#divModuleUserRoleLogs").hide();
    $("#divModuleUserRoles").show();
    $("#tblModuleUserRole").hide();
    $("#tblModuleUserRoleLogs").show();
}
function GotoModuleUserRole() {
    loadModuleUserRolesDataTable();
    $("#divModuleUserRoles").hide();
    $("#divModuleUserRoleLogs").show();
    $("#tblModuleUserRoleLogs").hide();
    $("#tblModuleUserRole").show();
}
function GotoModuleDelegateLogs() {
    loadModuleDelegateLogsDataTable();
    $("#divModuleDelegateLogs").hide();
    $("#divModuleDelegate").show();
    $("#tblModuleDelegate").hide();
    $("#tblModuleDelegateLogs").show();
}
function GotoModuleDelegate() {
    loadModuleDelegateDataTable();
    $("#divModuleDelegate").hide();
    $("#divModuleDelegateLogs").show();
    $("#tblModuleDelegateLogs").hide();
    $("#tblModuleDelegate").show();
}
function genericSearchKeypress(fnName) {
    if (this.event.keyCode === 13) {
        if (this.length) {
            if (fnName == "ModuleRoleActionSearch") {
                loadModuleRolesActionDataTable();
            }
            if (fnName == "ModuleRoleSearch") {
                loadModuleRolesDataTable();
            }
            if (fnName == "ModuleUserRoleActionSearch") {
                loadModuleUserRolesActionDataTable();
            }
            if (fnName == "ModuleUserRoleSearch") {
                loadModuleUserRolesDataTable();
            }
            if (fnName == "ModuleUserRoleLogsSearch") {
                loadModuleUserRoleLogsDataTable();
            }
            if (fnName == "ModuleDelegateSearch") {
                loadModuleDelegateDataTable();
            }
            if (fnName == "ModuleDelegateLogsSearch") {
                loadModuleDelegateLogsDataTable();
            }
            if (fnName == "ModuleUserRoleCostcodeSearch") {
                loadModuleUserRoleCostCodeDataTable();
            }
        }
    }
}
function genericSearchOnClick(fnName) {
    if (this.length) {
        if (fnName == "ModuleRoleActionSearch") {
            loadModuleRolesActionDataTable();
        }
        if (fnName == "ModuleRoleSearch") {
            loadModuleRolesDataTable();
        }
        if (fnName == "ModuleUserRoleActionSearch") {
            loadModuleUserRolesActionDataTable();
        }
        if (fnName == "ModuleUserRoleSearch") {
            loadModuleUserRolesDataTable();
        }
        if (fnName == "ModuleUserRoleLogsSearch") {
            loadModuleUserRoleLogsDataTable();
        }
        if (fnName == "ModuleDelegateSearch") {
            loadModuleDelegateDataTable();
        }
        if (fnName == "ModuleDelegateLogsSearch") {
            loadModuleDelegateLogsDataTable();
        }
        if (fnName == "ModuleUserRoleCostcodeSearch") {
            loadModuleUserRoleCostCodeDataTable();
        }
    }
}
function genericFilterReloadDatatabe(data, fnName) {
    $("#modalcontainer").modal('hide');
    if (fnName == "ModuleRoleActionFilter") {
        $("#FilterDataModel_RoleId").val(data.roleId);
        $("#FilterDataModel_ActionId").val(data.actionId);

        loadModuleRolesActionDataTable();
    }
    if (fnName == "ModuleUserRoleActionFilter") {
        $("#FilterDataModel_RoleId").val(data.roleId);
        $("#FilterDataModel_ActionId").val(data.actionId);
        loadModuleUserRolesActionDataTable();
    }
    if (fnName == "ModuleUserRoleFilter") {

        $("#FilterDataModel_RoleId").val(data.roleId);
        $("#FilterDataModel_Empno").val(data.empno);
        loadModuleUserRolesDataTable();
    }
    if (fnName == "ModuleUserRoleLogsFilter") {

        $("#FilterDataModel_RoleId").val(data.roleId);
        $("#FilterDataModel_Empno").val(data.empno);
        loadModuleUserRoleLogsDataTable();
    }
    hideLoader();
}
function ResetFilter() {
    $("#FilterDataModel_RoleId").val("");
    $("#FilterDataModel_ActionId").val("");
    $("#FilterDataModel_Empno").val("");


}


