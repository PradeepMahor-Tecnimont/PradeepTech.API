//function detachDropZone() {
//    $("#dropZoneWrapper").hide();
//    $('div#iddropzone2').each(function () {
//        let dropzoneControl = $(this)[0].dropzone;
//        if (dropzoneControl) {
//            dropzoneControl.destroy();
//        }
//    });
//}

//function downloadJobmasterBudgetXLTemplate({ pUrl, pProjno }) {

//    $.ajax({
//        headers: { "RequestVerificationToken": $('#formJobmasterBudgetXLUpload input[name="__RequestVerificationToken"]').val() },
//        url: pUrl,
//        type: "GET",
//        data: {
//            projno: pProjno
//        },
//        cache: false,
//        xhr: function () {
//            var xhr = new XMLHttpRequest();
//            xhr.onreadystatechange = function () {
//                if (xhr.readyState == 2) {
//                    if (xhr.status == 200) {
//                        xhr.responseType = "blob";
//                    }
//                }
//            };
//            return xhr;
//        },
//        beforeSend: function () {
//            showLoader();
//        },

//        success: function (blob, status, xhr) {

//            var filename = "";
//            var disposition = xhr.getResponseHeader('Content-Disposition');
//            if (disposition && disposition.indexOf('attachment') !== -1) {
//                var filenameRegex = /filename[^;=\n]*=((['"]).*?\2|[^;\n]*)/;
//                var matches = filenameRegex.exec(disposition);
//                if (matches != null && matches[1]) filename = matches[1].replace(/['"]/g, '');
//            }
//            var link = document.createElement('a');
//            var url = window.URL.createObjectURL(blob);

//            link.href = window.URL.createObjectURL(blob);
//            link.download = filename;
//            link.click();
//            link.remove();
//            window.URL.revokeObjectURL(url);
//            hideLoader();
//            toastr.success("File downloaded successfully.");
//        },
//        error: function (xhr) {
//            showError(xhr);
//            hideLoader();
//        }
//    });
//}

//function submitJobmasterBudgetUpdateXL() {
//    var formJobmasterBudgetXLUpload = "#formJobmasterBudgetXLUpload";
//    if ($(formJobmasterBudgetXLUpload).length == 0) {
//        console.log("Form not found");
//        return;
//    }

//    oDropZone2 = Dropzone.forElement("div#iddropzone2");
//    if (oDropZone2.files.length == 0) {
//        notify("error", "No files selected.", "Error");
//        return;
//    }
//    oDropZone2.processQueue();
//}

function initJobBudgetExport() {
    $('#btnJobmasterBudgetExport').off('click').on('click', function () {
        var openmonth = $('#OpeningMonth').val();

        event.preventDefault();
        event.stopPropagation();

        if (openmonth != "") {
            $('#IsExport').val("1");
            downloadJobmasterBudgetXLTemplate();
        } else {
            alert('Opending month not entered');
        }

    });
}

function downloadJobmasterBudgetXLTemplate() {
    var openmonth = $('#OpeningMonth').val();

    $.ajax({
        headers: { "RequestVerificationToken": $('#formJobmasterBudgetXLUpload input[name="__RequestVerificationToken"]').val() },
        url: pvvUrlJobBudgetTemplateDownload,
        type: "GET",
        data: {
            projno: $('#Projno').val(),
            openmonth: openmonth,
            isexport: $('#IsExport').val()
        },
        cache: false,
        beforeSend: function () {
            showModalLoader();
        },
        xhr: function () {
            var xhr = new XMLHttpRequest();
            xhr.onreadystatechange = function () {
                if (xhr.readyState == 2) {
                    if (xhr.status == 200) {
                        xhr.responseType = "blob";
                    }
                }
            };
            return xhr;
        },
        success: function (blob, status, xhr) {

            var filename = "";
            var disposition = xhr.getResponseHeader('Content-Disposition');
            if (disposition && disposition.indexOf('attachment') !== -1) {
                var filenameRegex = /filename[^;=\n]*=((['"]).*?\2|[^;\n]*)/;
                var matches = filenameRegex.exec(disposition);
                if (matches != null && matches[1]) filename = matches[1].replace(/['"]/g, '');
            }
            var link = document.createElement('a');
            var url = window.URL.createObjectURL(blob);

            link.href = window.URL.createObjectURL(blob);
            link.download = filename;
            link.click();
            link.remove();
            window.URL.revokeObjectURL(url);
            hideLoader();
            toastr.success("File downloaded successfully.");
        },
        error: function (xhr) {
            showError(xhr);
            hideModalLoader();
        },
        complete: function () {
            hideModalLoader();
        }
        
    });
}



$('.datepicker').bootstrapMaterialDatePicker({
    format: 'DD-MMM-YYYY',
    weekStart: 0,
    time: false,
    useCurrent: false,
    nowButton: false,
    clearButton: true
});

$('#formDate').bootstrapMaterialDatePicker({
    format: 'DD-MMM-YYYY',
    weekStart: 0,
    time: false,
    clearBtn: true
}).on('change', function (e, date) {
    if (date == undefined) {
        $("#FormDate").val('');
    } else {
        $("#FormDate").val(date.format('DD-MMM-YYYY'));
    } 
});

$('#JobType').change(function () {
    var jobtype = $(this).val();

    if (jobtype.trim() == '6030') {
        $("#IsConsortium").attr("required", "required");
        $("#IsConsortium").val("1").change();
        $("#IsConsortium").removeAttr("disabled");
    }
    else {
        $("#IsConsortium").removeAttr("required");
        $("#IsConsortium").val("0").change();
        $("#IsConsortium").attr("disabled", "disabled");
    }
});


$('#IsConsortium').change(function () {
    var consortium = $(this).val();

    if (consortium.trim() == '1') {
        $("#Tcmno").attr("required", "required");
        $("#Tcmno").removeAttr("readonly");
    }
    else {
        $("#Tcmno").removeAttr("required");
        $("#Tcmno").val("");
        $("#Tcmno").attr("readonly", "readonly");
    }
});


$('#contractDate').bootstrapMaterialDatePicker({
    format: 'DD-MMM-YYYY',
    weekStart: 0,
    time: false
}).on('change', function (e, date) {    
    if (date == undefined) {
        $("#ContractDate").val('');
    } else {
        $("#ContractDate").val(date.format('DD-MMM-YYYY'));
    }    
});

$('#startDate').bootstrapMaterialDatePicker({
    format: 'DD-MMM-YYYY',
    weekStart: 0,
    time: false
}).on('change', function (e, date) {
    if (date == undefined) {
        $("#StartDate").val('');
    } else {
        $("#StartDate").val(date.format('DD-MMM-YYYY'));
    }  
});

$('#revCloseDate').bootstrapMaterialDatePicker({
    format: 'DD-MMM-YYYY',
    weekStart: 0,
    time: false,
    minDate: new Date()
}).on('change', function (e, date) {
    if (date == undefined) {
        $("#RevCloseDate").val('');
    } else {
        $("#RevCloseDate").val(date.format('DD-MMM-YYYY'));
    } 
});

$('#expCloseDate').bootstrapMaterialDatePicker({
    format: 'DD-MMM-YYYY',
    weekStart: 0,
    time: false
}).on('change', function (e, date) {
    if (date == undefined) {
        $("#ExpCloseDate").val('');
    } else {
        $("#ExpCloseDate").val(date.format('DD-MMM-YYYY'));
    } 
});

$("#PlantProgressNo").focusout(function (e) {
    CraftProjectTitle();
});

$("#Place").focusout(function (e) {
    CraftProjectTitle();
});

$("#Country").change(function (e) {
    CraftProjectTitle();
});

$("#ScopeOfWork").change(function (e) {
    CraftProjectTitle();
});

$("#Country").change(function () {

    var country = $(this).val();
    var state = $('#State').val();
    var stateUrl = $("#statesurl").val();

    if (country == '') {
        return;
    }

    $.ajax({
        url: stateUrl,
        data: {
            'id': country
        },
        type: 'GET',
        beforeSend: function () {
            showLoader();
        },
        success: function (data) {
            let dropdown = $('#State');
            dropdown.empty();

            if (country.trim() == 'IN') {
                $("#State").attr("required", "required");
            }
            else {
                $("#State").removeAttr("required");
            }

            var flag = false;
            var options = '';

            $(data).each(function () {
                if (this.dataValueField == state) {
                    flag = true;
                    options += '<option selected="selected" value="' + this.dataValueField + '">' + this.dataTextField + '</option>';
                }
                else {
                    options += '<option value="' + this.dataValueField + '">' + this.dataTextField + '</option>';
                }
            });

            if (flag == false) {
                state = null;
            }

            dropdown.html(options);
            dropdown.val(state);

            hideLoader();
        },
        error: function (result) {
            hideLoader();
            showError(result);
        }
    });
});


    

function loadJobPhaseDataTable() {

    genericLoadDataTable({
        pDataTableId: "#dataTablePhase",
        pColumns: datatableColumnsPhases,
        pUrl: pvvUrlJobPhaseList,
        pUrlParams: {
            genericSearch: $('#GenericSearch').val() ? $('#GenericSearch').val() : null,
            projno: $('#Projno').val()
        },
        pRequestVerificationToken: $('input[name="__RequestVerificationToken"]').val(),
        pCallBackHeaderData: "flagUnflagTabsCallback"

    });
}

function loadMailListDataTable() {
    genericLoadDataTable({
        pDataTableId: "#dataTableMailList",
        pColumns: datatableColumnsMailList,
        pUrl: pvvUrlJobMailList,
        pUrlParams: {
            genericSearch: $('#GenericSearch').val() ? $('#GenericSearch').val() : null,
            projno: $('#Projno').val()
        },
        pRequestVerificationToken: $('input[name="__RequestVerificationToken"]').val()
    });
}

function loadBudgetDataTable() {
    genericLoadDataTable({
        pDataTableId: "#dataTableBudget",
        pColumns: datatableColumnsBudget,
        pUrl: pvvUrlJobBudgetList,
        pUrlParams: {
            genericSearch: $('#GenericSearch').val() ? $('#GenericSearch').val() : null,
            projno: $('#Projno').val()
        },
        pRequestVerificationToken: $('input[name="__RequestVerificationToken"]').val(),
        pCallBackHeaderData: "flagUnflagTabsCallback"

    });
}

function loadJobResponsibleApproversDataTable() {
    genericLoadDataTable({
        pDataTableId: "#dataTableResponsibleApprovers",
        pColumns: datatableColumnsResponsible,
        pUrl: pvvUrlJobResponsibleList,
        pUrlParams: {
            projno: $('#Projno').val()
        },
        pRequestVerificationToken: $('input[name="__RequestVerificationToken"]').val(),
        pCallBackHeaderData: "flagUnflagTabsCallback"
    });
}

function CraftProjectTitle() {
    var titlename = "";
    var selPlantProgressNo = $('#PlantProgressNo').val();
    var selPlace = $('#Place').val();
    var selCountry = $('#Country option:selected').val();
    var selScopeOfWork = $('#ScopeOfWork option:selected').text();

    if (selPlantProgressNo != "" | selPlantProgressNo != null) {
        titlename = titlename + selPlantProgressNo;
    }

    if (selPlace) {
        if (titlename.length == 0) {
            titlename = titlename + selPlace;
        } else {
            titlename = titlename + ', ' + selPlace;
        }
    }

    if (selCountry) {
        titlename = titlename + " (" + selCountry + ")";
    }

    if (selScopeOfWork) {

        const arrScopeOfWork = selScopeOfWork.split("-");

        if (titlename.length == 0) {
            titlename = titlename + arrScopeOfWork[0].trim();
        } else {
            titlename = titlename + ", " + arrScopeOfWork[0].trim();
        }

    }

    $("#projectTitle").val(titlename.toUpperCase());
}



