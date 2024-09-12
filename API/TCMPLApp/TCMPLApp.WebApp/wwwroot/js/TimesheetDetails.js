
/*-----------  Region for employee-----------*/

function loadTimesheetEmployeeProjectDataTable() {
    genericLoadDataTable({
        pDataTableId: "#tbTimesheetEmployeeProjectGrid",
        pColumns: datatableColumnsEmployeeProjectList,
        pUrl: pvvUrlEmployeeProjectPartial,
        pUrlParams: {
            genericSearch: $('#TimesheetEmployeeProjectSearch').val() ? $('#TimesheetEmployeeProjectSearch').val() : null,
            empno: $('#Empno').val(),
            yymm: $('#Yyyymm').val(),
            costcode: $('#Costcode').val()
        },
        pRequestVerificationToken: $('input[name="__RequestVerificationToken"]').val(),
    });
}
function loadTimesheetStatusDataTable() {
    genericLoadDataTable({
        pDataTableId: "#tbTimesheetStatusGrid",
        pColumns: datatableColumnsStatusDetails,
        pUrl: pvvUrlTimesheetStatusDetails,
        pUrlParams: {
            genericSearch: $('#TimesheetStatusSearch').val() ? $('#TimesheetStatusSearch').val() : null,
            yymm: $('#Yyyymm').val(),
        },
        pRequestVerificationToken: $('input[name="__RequestVerificationToken"]').val(),

    });    
}

function loadTimesheetLockedDataTable() { 
    genericLoadDataTable({
        pDataTableId: "#tbTimesheetLockedGrid",
        pColumns: datatableColumnsLockedDetails,
        pUrl: pvvUrlTimesheetLockedDetails,
        pUrlParams: {
            genericSearch: $('#TimesheetLockedSearch').val() ? $('#TimesheetLockedSearch').val() : null,
            yymm: $('#Yyyymm').val(),
        },
        pRequestVerificationToken: $('input[name="__RequestVerificationToken"]').val()
    });
}

function loadTimesheetApprovedDataTable() {
    genericLoadDataTable({
        pDataTableId: "#tbTimesheetApprovedGrid",
        pColumns: datatableColumnsApprovedDetails,
        pUrl: pvvUrlTimesheetApprovedDetails,
        pUrlParams: {
            genericSearch: $('#TimesheetApprovedSearch').val() ? $('#TimesheetApprovedSearch').val() : null,
            yymm: $('#Yyyymm').val(),
        },
        pRequestVerificationToken: $('input[name="__RequestVerificationToken"]').val(),

    });
}

function loadTimesheetPostedDataTable() {
    genericLoadDataTable({
        pDataTableId: "#tbTimesheetPostedGrid",
        pColumns: datatableColumnsPostedDetails,
        pUrl: pvvUrlTimesheetPostedDetails,
        pUrlParams: {
            genericSearch: $('#TimesheetPostedSearch').val() ? $('#TimesheetPostedSearch').val() : null,
            yymm: $('#Yyyymm').val(),
        },
        pRequestVerificationToken: $('input[name="__RequestVerificationToken"]').val()
    });
}

function loadTimesheetNotfilledDataTable() {
    genericLoadDataTable({
        pDataTableId: "#tbTimesheetNotfilledGrid",
        pColumns: datatableColumnsNotfilledDetails,
        pUrl: pvvUrlTimesheetNotfilledDetails,
        pUrlParams: {
            genericSearch: $('#TimesheetNotfilledSearch').val() ? $('#TimesheetNotfilledSearch').val() : null,
            yymm: $('#Yyyymm').val(),
        },
        pRequestVerificationToken: $('input[name="__RequestVerificationToken"]').val()
    });
}

/*-----------  Region for department -----------*/

function loadEmployeeCountPartialDataTable() {
    genericLoadDataTable({
        pDataTableId: "#tbEmployeeCountPartialGrid",
        pColumns: datatableColumnsEmployeeCountPartial,
        pUrl: pvvUrlEmployeeCountPartial,
        pUrlParams: {
            genericSearch: $('#EmployeeCountPartialSearch').val() ? $('#EmployeeCountPartialSearch').val() : null,
            yymm: $('#Yyyymm').val(),
            costcode: $('#Costcode').val()
        },
        pRequestVerificationToken: $('input[name="__RequestVerificationToken"]').val(),

    });
}

function loadTimesheetStatusPartialDataTable() {
    genericLoadDataTable({
        pDataTableId: "#tbPartialGrid",
        pColumns: datatableColumnsPartial,
        pUrl: pvvUrlTimesheetStatusPartial,
        pUrlParams: {
            genericSearch: $('#TimesheetPartialSearch').val() ? $('#TimesheetPartialSearch').val() : null,
            yymm: $('#Yymm').val(),
            costcode: $('#Costcode').val(),
            statusString: $('#Statusstring').val()
        },
        pRequestVerificationToken: $('input[name="__RequestVerificationToken"]').val(),

    });
}

function loadTimesheetFilledPartialDataTable() {
    genericLoadDataTable({
        pDataTableId: "#tbFilledPartialGrid",
        pColumns: datatableColumnsFilledPartial,
        pUrl: pvvUrlTimesheetFilledPartial,
        pUrlParams: {
            genericSearch: $('#TimesheetFilledPartialSearch').val() ? $('#TimesheetFilledPartialSearch').val() : null,
            yymm: $('#Yyyymm').val(),
            costcode: $('#Costcode').val(),
            statusString: $('#Statusstring').val()
        },
        pRequestVerificationToken: $('input[name="__RequestVerificationToken"]').val(),

    });
}

function loadTimesheetLockedPartialDataTable() {    
    genericLoadDataTable({
        pDataTableId: "#tbLockedPartialGrid",
        pColumns: datatableColumnsLockedPartial,
        pUrl: pvvUrlTimesheetLockedPartial,
        pUrlParams: {
            genericSearch: $('#TimesheetLockedPartialSearch').val() ? $('#TimesheetLockedPartialSearch').val() : null,
            yymm: $('#Yyyymm').val(),
            costcode: $('#Costcode').val(),
            statusstring: $('#Statusstring').val()
        },
        pRequestVerificationToken: $('input[name="__RequestVerificationToken"]').val()
    });
}

function loadTimesheetApprovedPartialDataTable() {    
    genericLoadDataTable({
        pDataTableId: "#tbApprovedPartialGrid",
        pColumns: datatableColumnsApprovedPartial,
        pUrl: pvvUrlTimesheetApprovedPartial,
        pUrlParams: {
            genericSearch: $('#TimesheetApprovedPartialSearch').val() ? $('#TimesheetApprovedPartialSearch').val() : null,
            yymm: $('#Yyyymm').val(),
            costcode: $('#Costcode').val(),
            statusstring: $('#Statusstring').val()
        },
        pRequestVerificationToken: $('input[name="__RequestVerificationToken"]').val()
    });       
}

function loadTimesheetPostedPartialDataTable() {
    genericLoadDataTable({
        pDataTableId: "#tbPostedPartialGrid",
        pColumns: datatableColumnsPostedPartial,
        pUrl: pvvUrlTimesheetPostedPartial,
        pUrlParams: {
            genericSearch: $('#TimesheetPostedPartialSearch').val() ? $('#TimesheetPostedPartialSearch').val() : null,
            yymm: $('#Yyyymm').val(),
            costcode: $('#Costcode').val(),
            statusstring: $('#Statusstring').val()
        },
        pRequestVerificationToken: $('input[name="__RequestVerificationToken"]').val()
    });
}


/*-----------  Region for projects -----------*/

function loadTimesheetProjectDataTable() { 
    genericLoadDataTable({
        pDataTableId: "#tbTimesheetProjectGrid",
        pColumns: datatableColumnsProjectList,
        pUrl: pvvUrlProjectTimesheetList,
        pUrlParams: {
            genericSearch: $('#TimesheetProjectSearch').val() ? $('#TimesheetProjectSearch').val() : null,
            yymm: $('#Yyyymm').val(),
            costcode: $('#Costcode').val()
        },
        pRequestVerificationToken: $('input[name="__RequestVerificationToken"]').val(),
    });
}

function loadTimesheetProjectDetailsDataTable() {
    genericLoadDataTable({
        pDataTableId: "#tbTimesheetProjectPartialGrid",
        pColumns: datatableColumnsProjectDetails,
        pUrl: pvvUrlProjectTimesheetDetails,
        pUrlParams: {
            genericSearch: $('#TimesheetProjectDetailPartialSearch').val() ? $('#TimesheetProjectDetailPartialSearch').val() : null,
            yymm: $('#Yyyymm').val(),            
            projno: $('#Projno').val(),
            costcode: $('#Costcode').val()
        },
        pRequestVerificationToken: $('input[name="__RequestVerificationToken"]').val(),
    });
}

/*-----------  Common area -----------*/

function genericSearchKeypress(fnName) {
    if (this.event.keyCode === 13) {
        var cc = $('#selCostcode').val();
        var yymm = $('#Yyyymm').val(); 
        var projno = $('#Projno').val(); 

        if (this.length) {
            //---- Employee wise

            if (fnName == "TimesheetEmployeeProjectSearch") {                
                $('#FilterDataModel_GenericSearch').val($("#TimesheetEmployeeProjectSearch").val());
                loadTimesheetEmployeeProjectDataTable();
            }

            if (fnName == "TimesheetStatusSearch") {  
                $('#xlsEmployeeStatus').attr('data-id', yymm + '!-!status!-!' + $("#TimesheetStatusSearch").val());
                $('#FilterDataModel_GenericSearch').val($("#TimesheetStatusSearch").val());
                loadTimesheetStatusDataTable();
            } if (fnName == "TimesheetLockedSearch") {
                $('#xlsEmployeeLocked').attr('data-id', yymm + '!-!locked!-!' + $("#TimesheetLockedSearch").val());
                $('#FilterDataModel_GenericSearch').val($("#TimesheetLockedSearch").val());
                loadTimesheetLockedDataTable();
            } if (fnName == "TimesheetApprovedSearch") {
                $('#xlsEmployeeApproved').attr('data-id', yymm + '!-!approved!-!' + $("#TimesheetApprovedSearch").val());
                $('#FilterDataModel_GenericSearch').val($("#TimesheetApprovedSearch").val());
                loadTimesheetApprovedDataTable();
            } if (fnName == "TimesheetPostedSearch") {
                $('#xlsEmployeePosted').attr('data-id', yymm + '!-!posted!-!' + $("#TimesheetPostedSearch").val()); 
                $('#FilterDataModel_GenericSearch').val($("#TimesheetPostedSearch").val());
                loadTimesheetPostedDataTable();
            } if (fnName == "TimesheetNotfilledSearch") {
                $('#xlsEmployeeNotfilled').attr('data-id', yymm + '!-!notfilled!-!' + $("#TimesheetNotfilledSearch").val()); 
                $('#FilterDataModel_GenericSearch').val($("#TimesheetNotfilledSearch").val());
                loadTimesheetNotfilledDataTable();
            }

            //---- Department wise
            
            if (fnName == "EmployeeCountPartialSearch") {
                $('#FilterDataModel_GenericSearch').val($("#EmployeeCountPartialSearch").val());
                loadEmployeeCountPartialDataTable();
            }

            if (fnName == "TimesheetFilledPartialSearch") {
                $('#FilterDataModel_GenericSearch').val($("#TimesheetFilledPartialSearch").val());
                $('#xlsFilledPartialStatus').attr('data-id', yymm + '!-!' + cc + '!-!Filled!-!' + $("#TimesheetFilledPartialSearch").val());
                loadTimesheetFilledPartialDataTable();
            } if (fnName == "TimesheetLockedPartialSearch") {                
                $('#FilterDataModel_GenericSearch').val($("#TimesheetLockedPartialSearch").val());
                $('#xlsLockedPartialStatus').attr('data-id', yymm + '!-!' + cc + '!-!Locked!-!' + $("#TimesheetLockedPartialSearch").val()); 
                loadTimesheetLockedPartialDataTable();
            } if (fnName == "TimesheetApprovedPartialSearch") {
                $('#FilterDataModel_GenericSearch').val($("#TimesheetApprovedPartialSearch").val());
                $('#xlsApprovedPartialStatus').attr('data-id', yymm + '!-!' + cc + '!-!Approved!-!' + $("#TimesheetApprovedPartialSearch").val());
                loadTimesheetApprovedPartialDataTable();
            } if (fnName == "TimesheetPostedPartialSearch") {
                $('#FilterDataModel_GenericSearch').val($("#TimesheetPostedPartialSearch").val());
                $('#xlsPostedPartialStatus').attr('data-id', yymm + '!-!' + cc + '!-!Posted!-!' + $("#TimesheetPostedPartialSearch").val());
                loadTimesheetPostedPartialDataTable();
            }

            //---- Project wise
            

            if (fnName == "TimesheetProjectSearch") {
                $('#FilterDataModel_GenericSearch').val($("#TimesheetProjectSearch").val());                
                $('#downloadProjectStatus').attr('data-id', yymm + '!-!' + cc + '!-!' + $("#TimesheetProjectSearch").val());
                loadTimesheetProjectDataTable();
            }

            if (fnName == "TimesheetProjectDetailPartialSearch") {
                $('#FilterDataModel_GenericSearch').val($("#TimesheetProjectDetailPartialSearch").val());
                $('#xlsProjectDeatilPartialStatus').attr('data-id', yymm + '!-!' + projno + '!-!' + cc + '!-!' + $("#TimesheetProjectDetailPartialSearch").val());
                loadTimesheetProjectDetailsDataTable();
            }
        }
    }
}

function genericSearchOnClick(fnName) {
    var cc = $('#selCostcode').val();
    var yymm = $('#Yyyymm').val(); 
    var projno = $('#Projno').val(); 

    if (this.length) {
        //---- Employee wise

        if (fnName == "TimesheetEmployeeProjectSearch") {
            $('#FilterDataModel_GenericSearch').val($("#TimesheetEmployeeProjectSearch").val());
            loadTimesheetEmployeeProjectDataTable();
        }

        if (fnName == "TimesheetStatusSearch") {
            $('#xlsEmployeeStatus').attr('data-id', yymm + '!-!status!-!' + $("#TimesheetStatusSearch").val());
            $('#FilterDataModel_GenericSearch').val($("#TimesheetStatusSearch").val());
            loadTimesheetStatusDataTable();
        } if (fnName == "TimesheetLockedSearch") {
            $('#xlsEmployeeLocked').attr('data-id', yymm + '!-!locked!-!' + $("#TimesheetLockedSearch").val());
            $('#FilterDataModel_GenericSearch').val($("#TimesheetLockedSearch").val());
            loadTimesheetLockedDataTable();
        } if (fnName == "TimesheetApprovedSearch") {
            $('#xlsEmployeeApproved').attr('data-id', yymm + '!-!approved!-!' + $("#TimesheetApprovedSearch").val());
            $('#FilterDataModel_GenericSearch').val($("#TimesheetApprovedSearch").val());
            loadTimesheetApprovedDataTable();
        } if (fnName == "TimesheetPostedSearch") {
            $('#xlsEmployeeApproved').attr('data-id', yymm + '!-!approved!-!' + $("#TimesheetPostedSearch").val());
            $('#FilterDataModel_GenericSearch').val($("#TimesheetPostedSearch").val());
            loadTimesheetPostedDataTable();
        } if (fnName == "TimesheetNotfilledSearch") {
            $('#xlsEmployeeNotfilled').attr('data-id', yymm + '!-!notfilled!-!' + $("#TimesheetNotfilledSearch").val()); 
            $('#FilterDataModel_GenericSearch').val($("#TimesheetNotfilledSearch").val());
            loadTimesheetNotfilledDataTable();
        }

        //---- Department wise
        if (fnName == "EmployeeCountPartialSearch") {
            $('#FilterDataModel_GenericSearch').val($("#EmployeeCountPartialSearch").val());
            loadEmployeeCountPartialDataTable();
        } if (fnName == "TimesheetFilledPartialSearch") {
            $('#FilterDataModel_GenericSearch').val($("#TimesheetFilledPartialSearch").val());
            $('#xlsFilledPartialStatus').attr('data-id', yymm + '!-!' + cc + '!-!Filled!-!' + $("#TimesheetFilledPartialSearch").val());
            loadTimesheetFilledPartialDataTable();
        } if (fnName == "TimesheetLockedPartialSearch") {
            $('#FilterDataModel_GenericSearch').val($("#TimesheetLockedPartialSearch").val());
            $('#xlsLockedPartialStatus').attr('data-id', yymm + '!-!' + cc + '!-!Locked!-!' + $("#TimesheetLockedPartialSearch").val()); 
            loadTimesheetLockedPartialDataTable();
        } if (fnName == "TimesheetApprovedPartialSearch") {
            $('#FilterDataModel_GenericSearch').val($("#TimesheetApprovedPartialSearch").val());
            $('#xlsApprovedPartialStatus').attr('data-id', yymm + '!-!' + cc + '!-!Approved!-!' + $("#TimesheetApprovedPartialSearch").val());
            loadTimesheetApprovedPartialDataTable();
        } if (fnName == "TimesheetPostedPartialSearch") {
            $('#FilterDataModel_GenericSearch').val($("#TimesheetPostedPartialSearch").val());
            $('#xlsPostedPartialStatus').attr('data-id', yymm + '!-!' + cc + '!-!Posted!-!' + $("#TimesheetPostedPartialSearch").val());
            loadTimesheetPostedPartialDataTable();
        }

        //---- Project wise

        if (fnName == "TimesheetProjectSearch") {
            $('#FilterDataModel_GenericSearch').val($("#TimesheetProjectSearch").val());
            $('#downloadProjectStatus').attr('data-id', yymm + '!-!' + cc + '!-!' + $("#TimesheetProjectSearch").val());
            loadTimesheetProjectDataTable();
        }

        if (fnName == "TimesheetProjectDetailPartialSearch") {
            $('#FilterDataModel_GenericSearch').val($("#TimesheetProjectDetailPartialSearch").val());
            console.log($("#TimesheetProjectDetailPartialSearch").val());
            $('#xlsProjectDeatilPartialStatus').attr('data-id', yymm + '!-!' + projno + '!-!' + cc + '!-!' + $("#TimesheetProjectDetailPartialSearch").val());
            loadTimesheetProjectDetailsDataTable();
        }

    }
}

function setTabName(tabname) {
    if (tabname == null) {
        $('#selTabName').val(home);
    } else {
        $('#selTabName').val(tabname);
    }         
}

function PostSaveReLoadDataTable(data) {    
    if (data.success) {
        var tabname = $('#selTabName').val();       
        $('#tabs-' + tabname + '-tab').click();        
        hideLoader();
        notify('success', data.message, 'Success');
    }
}

function callCancelButtonListeners(url) {
    $('#btnTimesheetCancel').on('click', function (e) {
        $.ajax({
            url: url,
            type: 'GET',
            beforeSend: function () {
                showLoader();
            },
            success: function (data) {
                $('#modalcontainer').modal('hide');
                if (data[0].value == 'location.reload();') {
                    location.reload();
                }
            },
            error: function (result) {
                hideLoader();
                notify($.i18n('Error'), result.responseText, 'danger');
            }
        });
    });
}
