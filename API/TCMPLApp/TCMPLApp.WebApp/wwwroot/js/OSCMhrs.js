
function loadOSCMhrsDataTable() {
    genericLoadDataTable({
        pDataTableId: "#tbOSCMhrsDetails",
        pColumns: datatableColumnsOSCMhrsDetails,
        pUrl: pvvUrlOSCMhrsDetails,
        pUrlParams: {
            genericSearch: $('#OSCMhrsDetailsSearch').val() ? $('#OSCMhrsDetailsSearch').val() : null,
            yymm: $('#Yymm').val(),
        },
        pRequestVerificationToken: $('input[name="__RequestVerificationToken"]').val(),

    });
}

function loadOSCMhrsSummaryDataTable() {
    genericLoadDataTable({
        pDataTableId: "#tbOSCMhrsSummary",
        pColumns: datatableColumnsOSCMhrsSummary,
        pUrl: pvvUrlOSCMhrsSummary ,
        pUrlParams: {
            genericSearch: $('#OSCMhrsSummarySearch').val() ? $('#OSCMhrsSummarySearch').val() : null,
            yymm: $('#Yymm').val(),
        },
        pRequestVerificationToken: $('input[name="__RequestVerificationToken"]').val(),

    });
}

function PostDeleteReLoadDataTables(data) {    
    if (data.success) {        
        loadOSCMhrsDataTable();
        hideLoader();
        notify('success', data.message, 'Success');
    }
}

function PostLockUnlockReLoadOSCMhrsSummaryDataTables(data) {
    if (data.success) {
        loadOSCMhrsDataTable();
        loadOSCMhrsSummaryDataTable();
        hideLoader();
        notify('success', data.message, 'Success');
    }
}

function genericSearchKeypress(fnName) {
    if (this.event.keyCode === 13) {
        if (this.length) {
            if (fnName == "OSCMhrsDetailsSearch") {
                loadOSCMhrsDataTable();
            } if (fnName == "OSCMhrsSummarySearch") {
                loadOSCMhrsSummaryDataTable();
            }
            
        }
    }
}
function genericSearchOnClick(fnName) {
    if (this.length) {
        if (fnName == "OSCMhrsDetailsSearch") {
            loadOSCMhrsDataTable();
        } if (fnName == "OSCMhrsSummarySearch") {
            loadOSCMhrsSummaryDataTable();
        }
        
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