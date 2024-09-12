$('*[data-jqueryselector$=generatereport]').off('click').on('click', function () {

    var obj = $(this).attr("id");
    
    var v_yyyy = $("#Yyyy").val();
    var v_yearMode = $("#YearMode").val();

    //var v_yyyymm = $("#Yyyymm").val();
    // var v_yymm = $("#yymm").val();

    var v_yyyymm = $("#yymm").val();
    var v_yymm = $("#Yyyymm").val();
    var v_projno = $("#Projno").val();
    var v_costcode = $("#CostCode").val();
    var v_assign = $("#Assign").val();

    var v_activeyear = $("#Yyyy").val();

    var v_empno = $("#Empno").val();
    var v_costCenter = $("#CostCenter").val();

    var v_repFor = $("#RepFor").val();

    var v_status = $("#Status").val();
    var v_reportid = $("#Reportid").val();
    var v_runmode = $("#Runmode").val();

    var v_category = $("#Category").val();

    var v_reportType = $("#ReportType").val();
    var v_simul = $("#Simul").val();

    var processid = $(this).data('processid');
    var v_processqueue_key_id = $("#ProcessQueue_" + processid + "_KeyId").val();

    var inprogress = $(this).data('inprogress');
    var url = $(this).data('url');

    if (inprogress != "0") {
        return;
    }

    $.ajax({
        url: url,
        type: "GET",
        cache: false,
        data: {
            yyyy: v_yyyy,
            yearMode: v_yearMode,
            yymm: v_yymm,
            yyyymm: v_yyyymm,
            assign: v_assign,
            costcode: v_costcode,
            projno: v_projno,
            empno: v_empno,
            costCenter: v_costCenter,
            repFor: v_repFor,
            status: v_status,
            reportid: v_reportid,
            runmode: v_runmode,
            category: v_category,
            reportType: v_reportType,
            simul: v_simul,
            activeyear: v_activeyear,
            keyid: v_processqueue_key_id
        },
        beforeSend: function () {
            startDownload(obj);
            showLoader();
        },
        xhr: function () {
            var xhr = new XMLHttpRequest();
            xhr.onreadystatechange = function () {

                var contentType = xhr.getResponseHeader('Content-Type');
                //console.log(contentType);
                //console.log(xhr.readyState);
                if (xhr.readyState == 2) {
                    if (contentType != null) {
                        if (xhr.status == 200 && (
                            contentType == "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" ||
                            contentType.startsWith("application/zip")
                        )) {
                            //console.log(contentType)
                            xhr.responseType = "blob";
                        }
                    }
                }
            };
            return xhr;
        },
        success: function (data, status, xhr) {
            var disposition = xhr.getResponseHeader('Content-Disposition');
            if (disposition && disposition.indexOf('attachment') !== -1) {
                var filenameRegex = /filename[^;=\n]*=((['"]).*?\2|[^;\n]*)/;
                var matches = filenameRegex.exec(disposition);
                if (matches != null && matches[1]) filename = matches[1].replace(/['"]/g, '');
            }
            else {
                if (data) {
                    toastr.error(data.response, "Error");
                    stopDownload(obj);
                }
                else {
                    window.location.reload();
                    hideLoader();
                }
                return;
            }

            //var binaryData = [];
            //binaryData.push(data);
            ////window.URL.createObjectURL(new Blob(binaryData, { type: "application/zip" }))

            var link = document.createElement('a');

            //var binaryData = [];
            //console.log(binaryData);
            //binaryData.push(data);
            //link.href = window.URL.createObjectURL(new Blob(binaryData, { type: "application/zip" }));
            link.href = window.URL.createObjectURL(data);
            link.download = filename.replace("''", "");
            link.download = filename;
            link.click();
            link.remove();
            window.URL.revokeObjectURL(url);

            hideLoader();
            toastr.success("File downloaded successfully.");
        },
        error: function (xhr) {
            showError(xhr);
            stopDownload(obj);
            hideLoader();
        },
        complete: function () {
            stopDownload(obj);
            hideLoader();
        }
    });
});

function startDownload(obj) {
    $('#' + obj).data('inprogress', "1");
    $('#' + obj + '_Text').addClass("hidden");
    $('#' + obj + '_Icon').addClass("hidden");
    $('#' + obj).addClass("cursor-not-allowed");
    $('#' + obj + '_Loader').removeClass("hidden");
}

function stopDownload(obj) {
    $('#' + obj).data('inprogress', "0");
    $('#' + obj + '_Text').removeClass("hidden");
    $('#' + obj + '_Icon').removeClass("hidden");
    $('#' + obj).removeClass("cursor-not-allowed");
    $('#' + obj + '_Loader').addClass("hidden");
}

function callRapReportingFilterListeners(url) {
    $('#filterSetRapReporting_yyyy').on('change', function (e) {
        var yyyy = $('#filterSetRapReporting_yyyy').val();
        var yearMode = $('#filterSetRapReporting_yearmode').val();
        var yyyymm = $('#filterSetRapReporting_yyyymm').val();

        if (yyyy != null && yyyy != '' && yearMode != null && yearMode != '') {
            $.ajax({
                url: url,
                data: {
                    'yyyy': yyyy,
                    'yearmode': yearMode
                },
                type: 'GET',
                beforeSend: function () {
                    showLoader();
                },
                success: function (data) {
                    let dropdown = $('#filterSetRapReporting_yyyymm');
                    dropdown.empty();
                    var flag = false;
                    var options = '';

                    $(data).each(function () {
                        if (this.dataValueField == yyyymm) {
                            flag = true;
                            options += '<option selected="selected" value="' + this.dataValueField + '">' + this.dataTextField + '</option>';
                        }
                        else {
                            options += '<option value="' + this.dataValueField + '">' + this.dataTextField + '</option>';
                        }
                    });
                    dropdown.html(options);

                    if (flag == false) {
                        yyyymm = null;
                    }

                    dropdown.val(yyyymm);
                    if (yyyymm == null || yyyymm == '') {
                        $('#filterSetRapReporting_yyyymm option:eq(0)').prop('selected', true);
                    }
                    hideLoader();
                },
                error: function (result) {
                    hideLoader();
                    notify($.i18n('Error'), result.responseText, 'danger');
                }
            });
        }
    });

    $('#filterSetRapReporting_yearmode').on('change', function (e) {
        var yyyy = $('#filterSetRapReporting_yyyy').val();
        var yearMode = $('#filterSetRapReporting_yearmode').val();
        var yyyymm = $('#filterSetRapReporting_yyyymm').val();

        if (yyyy != null && yyyy != '' && yearMode != null && yearMode != '') {
            $.ajax({
                url: url,
                data: {
                    'yyyy': yyyy,
                    'yearmode': yearMode
                },
                type: 'GET',
                beforeSend: function () {
                    showLoader();
                },
                success: function (data) {
                    let dropdown = $('#filterSetRapReporting_yyyymm');
                    dropdown.empty();
                    var flag = false;
                    var options = '';

                    $(data).each(function () {
                        if (this.dataValueField == yyyymm) {
                            flag = true;
                            options += '<option selected="selected" value="' + this.dataValueField + '">' + this.dataTextField + '</option>';
                        }
                        else {
                            options += '<option value="' + this.dataValueField + '">' + this.dataTextField + '</option>';
                        }
                    });
                    dropdown.html(options);

                    if (flag == false) {
                        yyyymm = null;
                    }

                    dropdown.val(yyyymm);
                    if (yyyymm == null || yyyymm == '') {
                        $('#filterSetRapReporting_yyyymm option:eq(0)').prop('selected', true);
                    }

                    hideLoader();
                },
                error: function (result) {
                    hideLoader();
                    notify($.i18n('Error'), result.responseText, 'danger');
                }
            });
        }
    });
}

function callRapReportingPartialReportListeners() {
    $('*[data-jqueryselector$=generateReportPartial]').off('click').on('click', function () {
        
        var obj = $(this).attr("id");

        var v_yyyy = $("#Yyyy").val();
        var v_yearMode = $("#YearMode").val();

        //var v_yyyymm = $("#Yyyymm").val();
        // var v_yymm = $("#yymm").val();

        var v_yyyymm = $("#yymm").val();
        var v_yymm = $("#Yyyymm").val();
        var v_projno = $("#Projno").val();
        var v_costcode = $("#CostCode").val();
        var v_assign = $("#Assign").val();

        var v_empno = $("#Empno").val();
        var v_costCenter = $("#CostCenter").val();

        var v_repFor = $("#RepFor").val();

        var v_status = $("#Status").val();
        var v_reportid = $("#Reportid").val();
        var v_runmode = $("#Runmode").val();

        var v_category = $("#Category").val();

        var v_reportType = $("#ReportType").val();
        var v_simul = $("#Simul").val();
        var v_sim = $("#Sim").val();
        var v_projectno = $("#ProjectNo").val();
        var v_closedProjno = $("#ClosedProjno").val();
        var inprogress = $(this).data('inprogress');
        var url = $(this).data('url');
        
        if ((v_assign == null || v_assign == '') && (v_costCenter == null || v_costCenter == '') && (v_sim == null || v_sim == '') && (v_empno == null || v_empno == '') && (v_projectno == null || v_projectno == '') && (v_closedProjno == null || v_closedProjno == '')) {
            toastr.error("The field is required");
            return;
        }


        if (inprogress != "0") {
            return;
        }

        $.ajax({
            url: url,
            type: "GET",
            cache: false,
            data: {
                yyyy: v_yyyy,
                yearMode: v_yearMode,
                yymm: v_yymm,
                yyyymm: v_yyyymm,
                assign: v_assign,
                costcode: v_costcode,
                projno: v_projno,
                empno: v_empno,
                costCenter: v_costCenter,
                repFor: v_repFor,
                status: v_status,
                reportid: v_reportid,
                runmode: v_runmode,
                category: v_category,
                reportType: v_reportType,
                simul: v_simul,
                projectno: v_projectno,
                sim: v_sim,
                closedProjno: v_closedProjno
            },
            beforeSend: function () {
                /*startDownload(obj);*/
                showLoader();
            },
            xhr: function () {
                var xhr = new XMLHttpRequest();
                xhr.onreadystatechange = function () {
                    var contentType = xhr.getResponseHeader('Content-Type');
                    if (xhr.readyState == 2) {
                        if (xhr.status == 200 && (
                            contentType == "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" ||
                            contentType.startsWith("application/zip")
                        )) {
                            //console.log(contentType)
                            xhr.responseType = "blob";
                        }
                    }
                };
                return xhr;
            },
            success: function (data, status, xhr) {
                var filename = "";
                var disposition = xhr.getResponseHeader('Content-Disposition');
                if (disposition && disposition.indexOf('attachment') !== -1) {
                    var filenameRegex = /filename[^;=\n]*=((['"]).*?\2|[^;\n]*)/;
                    var matches = filenameRegex.exec(disposition);
                    if (matches != null && matches[1]) filename = matches[1].replace(/['"]/g, '');
                }
                else {
                    toastr.error(data.response, "Error");
                    //stopDownload(obj);
                    hideLoader();
                    return;
                }
                var link = document.createElement('a');

                link.href = window.URL.createObjectURL(data);
                link.download = filename.replace("''", "");
                link.download = filename;
                link.click();
                link.remove();
                window.URL.revokeObjectURL(url);
                hideLoader();
                toastr.success("File downloaded successfully.");
            },
            error: function (xhr) {
                showError(xhr);
                //stopDownload(obj);
                hideLoader();
            },
            complete: function () {
                //stopDownload(obj);
                hideLoader();
            }
        });
    });
}

function hideFilterCancelButton(hideShow) {
    if (hideShow == 'HIDE') {
        $('#btnRapReportingCancel').hide();
    }
    else {
        $('#btnRapReportingCancel').show();
    }
}

function callCancelButtonListeners(url) {
    $('#btnRapReportingCancel').on('click', function (e) {
        $.ajax({
            url: url,
            type: 'GET',
            beforeSend: function () {
                showLoader();
            },
            success: function (data) {
                $('#modalcontainer').modal('hide');
                if (data[0].value == 'history.go(-1);') {
                    history.go(-1);
                }
                else if (data[0].value == 'location.reload();') {
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

function callFilterDefaultsListeners() {
    if ($('#Yyyy').val() == null || $('#Yyyy').val() == '') {
        $('#filterSetRapReporting_yyyy option:eq(1)').prop('selected', 'selected').change();
    }
    if ($('#YearMode').val() == null || $('#YearMode').val() == '') {
        $('#filterSetRapReporting_yearmode option:eq(1)').prop('selected', 'selected').change();
    }
}

function setDownlodUrl() {
    var sapUrl = $('#lafcsapReport').attr('data-path');

    sapUrl = sapUrl.replace("~!R!~", $('#RptType').val());
    sapUrl = sapUrl.replace("~!C!~", $('#CostCode').val());
    sapUrl = sapUrl.replace("~!P!~", $('#Projno').val());
    sapUrl = sapUrl.replace("~!E!~", $('#EmpTypeList').val());
    $('#lafcsapReport').removeData('url')
    $('#lafcsapReport').attr('data-url', sapUrl);    
}

function callReportTypeListener() {
    $('#ReportType').on('change', function (e) {
        var reportType = $('#ReportType').val();

        $('#RptType').val(reportType);

        if (reportType == 'A') {           
            $('#CostCenter').val('').trigger("change");
            $('#CostCode').val('');            
            $('#CostCenter').attr('disabled', 'disabled');            
            $('#ProjectNo').val('').trigger("change");
            $('#Projno').val('');
            $('#ProjectNo').attr('disabled', 'disabled');
        }

        if (reportType == 'C') {            
            $('#CostCenter').removeAttr('disabled');
            $('#ProjectNo').val('').trigger("change");
            $('#Projno').val('');
            $('#ProjectNo').attr('disabled', 'disabled');
        }

        if (reportType == 'P') {   
            $('#CostCenter').val('').trigger("change");
            $('#CostCode').val(''); 
            $('#CostCenter').attr('disabled', 'disabled');
            $('#ProjectNo').removeAttr('disabled');
        }
    });
}

function calllReportTypeReportListener() {
    $('*[data-jqueryselector$=generateReportPartial]').off('click').on('click', function () {
        
        var obj = $(this).attr("id");

        var v_yymm = $("#Yyyymm").val();
        var v_costcenter = $("#CostCenter").val();
        var v_reporttype = $("#ReportType").val();
        var v_employeetype = $("#EmployeeTypeList").val();
        var v_projectno = $("#ProjectNo").val();
        var inprogress = $(this).data('inprogress');
        var url = $(this).data('url');

        if ((v_yymm == null || v_yymm == '') && (v_reporttype == null || v_reporttype == '') && (v_reporttype == null || v_reporttype == '') && v_employeetype.length == 0) {
            toastr.error("The field is required");
            return;
        }

        if (v_reporttype == 'C' && (v_costcenter == null || v_costcenter == '')) {
            toastr.error("The field is required");
            return;
        }

        if (v_reporttype == 'P' && (v_projectno == null || v_projectno == '')) {
            toastr.error("The field is required");
            return;
        }

        if (inprogress != "0") {
            return;
        }

        $.ajax({
            url: url,
            type: "GET",
            cache: false,
            data: {
                yymm: v_yymm,
                reporttype: v_reporttype,
                costcenter: v_costcenter,
                projno: v_projectno,
                employeetypelist: v_employeetype.join(", ")
            },
            beforeSend: function () {
                showLoader();
            },
            xhr: function () {
                var xhr = new XMLHttpRequest();
                xhr.onreadystatechange = function () {
                    var contentType = xhr.getResponseHeader('Content-Type');                   
                    
                    if (xhr.readyState == 2) {
                        if (xhr.status == 200 && (
                            contentType == "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" ||
                            contentType.startsWith("application/zip")
                        )) {                            
                            xhr.responseType = "blob";
                        }
                    }
                };
                return xhr;
            },
            success: function (data, status, xhr) {
                var filename = "";
                var disposition = xhr.getResponseHeader('Content-Disposition');
                console.log(disposition);
                if (disposition && disposition.indexOf('attachment') !== -1) {
                    var filenameRegex = /filename[^;=\n]*=((['"]).*?\2|[^;\n]*)/;
                    var matches = filenameRegex.exec(disposition);
                    if (matches != null && matches[1]) filename = matches[1].replace(/['"]/g, '');
                }
                else {
                    toastr.error(data.response, "Error");
                    //stopDownload(obj);
                    hideLoader();
                    return;
                }
                var link = document.createElement('a');

                link.href = window.URL.createObjectURL(data);
                link.download = filename.replace("''", "");
                link.download = filename;
                link.click();
                link.remove();
                window.URL.revokeObjectURL(url);
                hideLoader();
                toastr.success("File downloaded successfully.");
            },
            error: function (xhr) {
                showError(xhr);
                //stopDownload(obj);
                hideLoader();
            },
            complete: function () {
                //stopDownload(obj);
                hideLoader();
            }
        });
    });
}

function loadTSShiftProjectManhoursDataTable() {
    genericLoadDataTable({
        pDataTableId: "#tbTSShiftProjectManhoursLogs",
        pColumns: datatableTSShiftProjectManhoursLogsColumns,
        pUrl: vVUloadTSShiftProjectManhoursLogsDataTableList,
        pUrlParams: {
            genericSearch: $('#GenericSearch').val() ? $('#GenericSearch').val() : null,
            yyyymm: $('#Yyyymm').val() ? $('#Yyyymm').val() : null,
        },
        pRequestVerificationToken: $('input[name="__RequestVerificationToken"]').val(),
        pPagination: true,
    });
}