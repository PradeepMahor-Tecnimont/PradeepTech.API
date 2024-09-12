$(document).ready(function () {
    $('#tabs-EmployeePrimaryDetails-tab').click();
    //loadSuperannuationListDataTable();
    //loadGratuityListDataTable();
});

function localScript() {
    initSelect2();
    initDatePicker();
    initFileUpdateControls();

    $(function () {
        $("#HasAadhaar").change(function () {
            if ($(this).val() == "OK") {
                $("#AadhaarData").show();
                $("#divAadhaarDetails").show();
            }
            else {
                $("#AadhaarData").hide();
                $("#divAadhaarDetails").hide();
            }
        });
    });

    let hasPassport = $("#HasPassport").val();
    if (hasPassport == "OK") {
        $("#PassportData").show();
        $("#divPassportDetail").show();
    }
    else {
        $("#PassportData").hide();
        $("#divPassportDetail").hide();
    }

    let hasAadhaar = $("#HasAadhaar").val();

    if (hasAadhaar == "OK") {
        $("#AadhaarData").show();
        $("#divAadhaarDetail").show();
    }
    else {
        $("#AadhaarData").hide();
        $("#divAadhaarDetail").hide();
    }

    $(function () {
        $("#HasPassport").change(function () {
            if ($(this).val() == "OK") {
                $("#PassportData").show();
                $("#divPassportDetail").show();
            } else {
                $("#PassportData").hide();
                $("#divPassportDetail").hide();
            }
        });
    });

    $('#check').change(function () {
        if (this.checked) {
            $("#YesNoDadHusbInNameCheck").show();
            $("#YesNoDadHusbInNameLabel").show();
            $("#NoDadHusbInNameLabel").hide();
            $("#NoDadHusbInNameCheck").hide();
        }
        else {
            $("#NoDadHusbInNameCheck").show();
            $("#NoDadHusbInNameLabel").show();
            $("#YesNoDadHusbInNameLabel").hide();
            $("#YesNoDadHusbInNameCheck").hide();
        }
    });

    let isChecked = $("#getNoDadHusbInName").val();

    if (isChecked == "True") {
        $("#YesNoDadHusbInNameCheck").show();
        $("#YesNoDadHusbInNameLabel").show();
        $("#NoDadHusbInNameCheck").hide();
        $("#NoDadHusbInNameLabel").hide();
    }
    else {
        $("#NoDadHusbInNameCheck").show();
        $("#NoDadHusbInNameLabel").show();
        $("#YesNoDadHusbInNameCheck").hide();
        $("#YesNoDadHusbInNameLabel").hide();
    }
}

function activateGratuityTab() {
    $('#tabs-GratuityIndex-tab').click();
}

function loadGratuityListDataTable() {
    //console.log("Gratuity");
    genericLoadDataTable({
        pDataTableId: "#tbGratuityGrid",
        pColumns: isNominationOpen ? datatableColumnsGratuityEdit : datatableColumnsGratuity,
        pUrl: pvvUrlGratuityList,
        pUrlParams: {
            Empno: $('#Empno').val()
        },
        pRequestVerificationToken: $('input[name="__RequestVerificationToken"]').val(),
        pPagination: false
    });
    validateTabs();
}

function loadSuperannuationListDataTable() {
    genericLoadDataTable({
        pDataTableId: "#tbSupperannuationGrid",
        pColumns: isNominationOpen ? datatableColumnsSuperannuationEdit : datatableColumnsSuperannuation,
        pUrl: pvvUrlSuperannuationList,
        pUrlParams: {
            Empno: $('#Empno').val()
        },
        pRequestVerificationToken: $('input[name="__RequestVerificationToken"]').val(),
        pPagination: false
    });
    validateTabs();
}

function loadEmpProFundListDataTable() {
    genericLoadDataTable({
        pDataTableId: "#tbEmpProFundGrid",
        pColumns: isNominationOpen ? datatableColumnsEmpProFundEdit : datatableColumnsEmpProFund,
        pUrl: pvvUrlEmpProFundList,
        pUrlParams: {
            Empno: $('#Empno').val()
        },
        pRequestVerificationToken: $('input[name="__RequestVerificationToken"]').val(),
        pPagination: false
    });
    validateTabs();
}

function loadEmpPensionFundMarriedListDataTable() {
    genericLoadDataTable({
        pDataTableId: "#tbEmpPensionFundMarriedGrid",
        pColumns: isNominationOpen ? datatableColumnsEmpPensionFundMarriedEdit : datatableColumnsEmpPensionFundMarried,
        pUrl: pvvUrlEmpPensionFundMarriedList,
        pUrlParams: {
            Empno: $('#Empno').val()
        },
        pRequestVerificationToken: $('input[name="__RequestVerificationToken"]').val(),
        pPagination: false
    });
    validateTabs();
}

function loadEmpPensionFundListDataTable() {
    genericLoadDataTable({
        pDataTableId: "#tbEmpPensionFundGrid",
        pColumns: isNominationOpen ? datatableColumnsEmpPensionFundEdit : datatableColumnsEmpPensionFund,
        pUrl: pvvUrlEmpPensionFundList,
        pUrlParams: {
            Empno: $('#Empno').val()
        },
        pRequestVerificationToken: $('input[name="__RequestVerificationToken"]').val(),
        pPagination: false
    });
    validateTabs();
}

function loadEmpMediclaimListDataTable() {
    genericLoadDataTable({
        pDataTableId: "#tbMediclaimDetailsGrid",
        pColumns: isMediclaimOpen ? datatableColumnsEmpMediclaimEdit : datatableColumnsEmpMediclaim,
        pUrl: pvvUrlEmpMediclaimList,
        pUrlParams: {
            Empno: $('#Empno').val()
        },
        pRequestVerificationToken: $('input[name="__RequestVerificationToken"]').val(),
        pPagination: false
    });
    validateTabs();
}

function loadGTLIListDataTable() {
    genericLoadDataTable({
        pDataTableId: "#tbGTLIGrid",
        pColumns: isGtliOpen ? datatableColumnsGTLIEdit : datatableColumnsGTLI,
        pUrl: pvvUrlGTLIList,
        pUrlParams: {
            Empno: $('#Empno').val()
        },
        pRequestVerificationToken: $('input[name="__RequestVerificationToken"]').val(),
        pPagination: false
    });
    validateTabs();
}

$("#GenericSearch").keypress(function (event) {
    if (event.keyCode === 13) {
        if ($("#GenericSearch").length) {
            loadModuleDataTable();
        }
    }
});

function initDatePicker() {
    $('#nomDob').attr('readonly', 'true');
    $('#birthDate').attr('readonly', 'true');
    $('#issueDate').attr('readonly', 'true');
    $('#expiryDate').attr('readonly', 'true');

    $('.datepicker2').bootstrapMaterialDatePicker({
        format: 'MMM-YYYY',
        startView: 'year',
        minViewMode: 'month',
        changeMonth: true,
        changeYear: true,
        time: false
    }).on('change', function (e, date) {
        let fvDate = $(this).val();
        $("#MonthDate").val(moment(fvDate, 'MMMM-YYYY').format("YYYYMM"));
        $(this).datepicker('hide');
    });

    if ($("#MonthDate").val()) {
        $('#monthDate').val(moment($("#MonthDate").val()).format('MMMM-YYYY'));
    }

    $("#nomDob").datepicker({
        format: 'dd-M-yyyy',
        autoclose: true,
    }).on('changeDate', function (selected) {
        $("#NomDob").val($('#nomDob').datepicker('getFormattedDate'));
    });

    $("#birthDate").datepicker({
        format: 'dd-M-yyyy',
        autoclose: true,
    }).on('changeDate', function (selected) {
        $("#Dob").val($('#birthDate').datepicker('getFormattedDate'));
    });

    $("#issueDate").datepicker({
        format: 'dd-M-yyyy',
        autoclose: true,
    }).on('changeDate', function (selected) {
        $("#IssueDate").val($('#issueDate').datepicker('getFormattedDate'));
    });

    $("#expiryDate").datepicker({
        format: 'dd-M-yyyy',
        autoclose: true,
    }).on('changeDate', function (selected) {
        $("#ExpiryDate").val($('#expiryDate').datepicker('getFormattedDate'));
    });
}

function PostSaveAadhaar(data) {
    if (data.success) {
        notify('success', data.response, 'Success');
        $('#tabs-AadhaarDetails-tab').click();
    }
}

function PostSaveSecondary(data) {
    if (data.success) {
        notify('success', data.response, 'Success');
        $('#tabs-SecondaryDetails-tab').click();
    }
}

function PostSave(data) {
    if (data.success) {
        $("#modalcontainer").modal('hide');
        hideLoader();
        notify('success', data.response, 'Success');
    }
    else {
        // loadConfigProcessDataTable();
        // $("#modalcontainer").modal('hide');
        notify('error', data.message, 'Error');
                
    }
}

function PostDeleteReloadGratuityListDataTable(data) {
    if (data.success) {
        hideLoader();
        loadGratuityListDataTable();
        notify('success', data.message, 'Success');
    }
}

function PostDeleteReloadSuperannuationListDataTable(data) {
    if (data.success) {
        hideLoader();
        loadSuperannuationListDataTable();
        notify('success', data.message, 'Success');
    }
}
function PostDeleteReloadEmpProFundListDataTable(data) {
    if (data.success) {
        hideLoader();
        loadEmpProFundListDataTable();
        notify('success', data.message, 'Success');
    }
}
function PostDeleteReloadEmpPensionFundListDataTable(data) {
    if (data.success) {
        hideLoader();
        loadEmpPensionFundListDataTable();
        notify('success', data.message, 'Success');
    }
}

function PostDeleteReloadEmpPensionFundMarriedListDataTable(data) {
    if (data.success) {
        hideLoader();
        loadEmpPensionFundMarriedListDataTable();
        notify('success', data.message, 'Success');
    }
}

function PostDeleteReloadEmpMediclaimListDataTable(data) {
    if (data.success) {
        hideLoader();
        loadEmpMediclaimListDataTable();
        notify('success', data.message, 'Success');
    }
}

function PostDeleteReloadGTLIListDataTable(data) {
    if (data.success) {
        hideLoader();
        reloadGTLIDetailsTab();
        notify('success', data.message, 'Success');
    }
}

function isNumber(evt) {
    evt = (evt) ? evt : window.event;
    let charCode = (evt.which) ? evt.which : evt.keyCode;
    return !(charCode > 31 && (charCode < 48 || charCode > 57));
}

//Start File Upload Js

Dropzone.autoDiscover = false;

function detachDropZone() {
    $("#dropZoneWrapper").hide();
    $('div#iddropzone2').each(function () {
        let dropzoneControl = $(this)[0].dropzone;
        if (dropzoneControl) {
            dropzoneControl.destroy();
        }
    });
}
var fileType = "";
function initFileUpdateControls() {
    if ($("#formfileUploadEdit").length != 0) {
        initDropZoneFileUpload(".pdf");
    }

    $('#btnSaveFileUpdate').on('click').on('click', function () {
        fileType = $('#formfileUploadEdit input[name="FileType"]').val();

        event.preventDefault();
        event.stopPropagation();
        submitFileUpdate();
    });
}

function initDropZoneFileUpload(fileTypeExtension) {
    detachDropZone();

    let formId = "#" + $("div#iddropzone2").closest("form").attr("id");

    $("div#iddropzone2").dropzone({
        url: '@Url.Action("TrainingFileUpload", "EmployeeTraining", new {Area = "SWPVaccine"})',
        autoProcessQueue: false,
        uploadMultiple: false,
        parallelUploads: 1,
        maxFiles: 1,
        maxFilesize: 1,
        addRemoveLinks: true,
        createImageThumbnails: false,
        acceptedFiles: fileTypeExtension,
        init: function () {
            var myDropzone = this;

            this.on("processing", function (file) {
                this.options.url = $(formId).attr("action");
            });
            this.on("sending", function (file, xhr, formData) {
                formData.append("file", file);
                var data = $(formId).serializeArray();

                $.each(data, function (key, el) {
                    formData.append(el.name, el.value);
                });
                showModalLoader();
            });
            this.on("sendingmultiple", function () {
                // Gets triggered when the form is actually being sent.
                // Hide the success button or the complete form.
            });
            this.on("successmultiple", function (files, data) {
                if (data.success) {
                    $('#modalcontainer').modal('hide');
                }
                else
                    notify("error", data.response, "File upload failed.");

                hideModalLoader();

                this.removeAllFiles(true);
            });
            this.on("success", function (files, data) {
                if (data.success) {
                    notify('success', data.response, 'Success');

                    if (fileType == "AC") {
                        reloadAadhaarTab();
                    }
                    if (fileType == "PP") {
                        reloadPassportTab();
                    }
                    if (fileType == "GT") {
                        location.reload();
                        reloadGTLIDetailsTab();
                    }
                    fileType = "";
                    $('#modalcontainer').modal('hide');
                }
                else
                    notify("error", data.response, "File upload failed.");

                hideModalLoader();

                this.removeAllFiles(true);
            });
            this.on("errormultiple", function (files, data) {
                notify("error", "File not uploaded + " + data.response, "Error");
                this.removeAllFiles(true);
                hideModalLoader();

                // Gets triggered when there was an error sending the files.
                // Maybe show form again, and notify user of error
            });
        },
        error: function (request, status, error) {
            this.removeAllFiles(true);
            notify('error', status, request, error);
        }
    });
}

function submitFileUpdate() {
    var formfileUploadEdit = "#formfileUploadEdit";
    if ($(formfileUploadEdit).length == 0) {
        console.log("Form not found");
        return;
    }

    oDropZone3 = Dropzone.forElement("div#iddropzone2");
    if (oDropZone3.files.length == 0) {
        notify("error", "No files selected.", "Error");
        return;
    }
    oDropZone3.processQueue();
    //return;
}

function validateTabs() {
    //console.log("Validate1");
    var empno = $('#Empno').val();
    $.ajax({
        url: validateTabsUrl,
        data: {
            'empno': empno
        },
        type: 'GET',
        beforeSend: function () {
            showLoader();
        },
        success: function (data) {
            flagUnflagTabs(data);
            hideLoader();
        },
        error: function (result) {
            hideLoader();
            showError(result);
            //notify($.i18n('Error'), result.responseText, 'danger');
        }
    });
}

function reloadPassportTab() {
    $('#tabs-PassportDetails-tab').click();
}

function reloadAadhaarTab() {
    $('#tabs-AadhaarDetails-tab').click();
}

function reloadGTLIDetailsTab() {
    $('#tabs-GTLIDetails-tab').click();
}