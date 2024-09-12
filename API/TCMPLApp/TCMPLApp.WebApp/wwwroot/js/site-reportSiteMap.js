function executeRequest(actionUrl, paramData, actionRequestMethodType, requestVerificationToken) {

    $.ajax({
        url: actionUrl,
        data: paramData,
        type: actionRequestMethodType,
        beforeSend: function (xhr) {
            if (requestVerificationToken)
                xhr.setRequestHeader('RequestVerificationToken', requestVerificationToken);
            showLoader();
        },
        success: function (result, status, xhr) {
            if (result.messageType == "OK") {
                if (result.messageFileContent != null) {
                    //console.log(data.messageFileContent);
                    var blob = convertToBlob(result.messageFileContent.fileContents, result.messageFileContent.contentType);
                    var link = document.createElement('a');
                    link.href = window.URL.createObjectURL(blob);
                    link.download = result.messageFileContent.fileDownloadName;
                    link.click();
                }
                notify("success", result.messageText, 'Success');
            }
            if (result.messageType == "KO") {
                showError(result);
            }
        },
        error: function (xhr, status, error) {
            showError(xhr);
        },
        complete: function (xhr, status) {
            hideLoader();
        }
    });
}

function executeModalAction() {
    let requestVerificationToken = $('form#formActionExecute input[name="__RequestVerificationToken"]').val();
    let actionUrl = $("form#formActionExecute").attr('action');
    let actionRequestMethodType = $("form#formActionExecute").attr('method');

    let paramData = {};
    $("form#formActionExecute :input.action-parameter").each(function () {
        var inputDataVal = $(this).data(); // This is the jquery object of the input, do what you will
        var inputVal = $(this).val();
        paramData[inputDataVal["controllerparamname"]] = inputVal;
    });

    executeRequest(actionUrl, paramData, actionRequestMethodType, requestVerificationToken);
}
function actionExecuteListener() {
    $('*[data-jqueryselector$=actionExecutor]').off('click').on('click', function () {

        let paramsForRequest = $(this).data();

        let controllerParams = paramsForRequest["controllermethodparams"];
        let paramValuesFromFields = paramsForRequest["indexformfields"];
        let requestUrl = paramsForRequest["actionurl"];
        let filterPopupUrl = paramsForRequest["filterpopupurl"];
        let requestMethodType = paramsForRequest["requestmethodtype"];

        let requestVerificationToken = $('input[name="__RequestVerificationToken"]').val();

        let actionId = paramsForRequest["actionid"];

        if (controllerParams == null) {
            executeRequest(requestUrl, null, requestMethodType, requestVerificationToken);
            return;
        }

        let aryParamValuesFromFields = paramValuesFromFields.split(",");
        let aryControllerParams = controllerParams.split(",");
        let jObjControllerParams = { "Test": "Sample data" };
        let canExecuteRequest = false;
        for (var i = 0; i < aryParamValuesFromFields.length; i++) {
            canExecuteRequest = false;
            if (($("input[id*='" + aryParamValuesFromFields[i] + "' i]").length > 0)) {
                let paramVal = $("input[id*='" + aryParamValuesFromFields[i] + "' i]").val();
                if (paramVal.length > 0) {
                    jObjControllerParams[aryControllerParams[i]] = paramVal;
                    canExecuteRequest = true;
                }
            }
            if (!canExecuteRequest) {
                break;
            }
        }

        if (canExecuteRequest) {
            requestVerificationToken = $('input[name="__RequestVerificationToken"]').val();
            executeRequest(requestUrl, jObjControllerParams, requestMethodType, requestVerificationToken);
        }
        else {
            let modalPopupParams = {};
            let urlParams = {};
            urlParams["id"] = actionId;
            modalPopupParams["url"] = filterPopupUrl;
            modalPopupParams["urlparameters"] = urlParams;
            modalPopupParams["modalcontainer"] = "modalcontainer";

            modalPopupParams["modalpopupwidth"] = "rightw35";
            modalPopupParams["modaltitle"] = "Parameter form";
            modalPopupParams["modalheader"] = "Provide appropriate values";

            modalPopupParams["modaldismiss"] = "";
            modalPopupParams["callback"] = "";
            modalPopupParams["statichtmlsourcedivid"] = "";
            modalPopupParams["cache"] = true;


            showModalPopup(modalPopupParams)
        }
    });
}

function showModalPopup(modalPopupParams) {
    var url = modalPopupParams["url"];
    var urlParameters = modalPopupParams["urlparameters"];
    var modalcontainer = modalPopupParams['modalcontainer'];

    var modalpopupwidth = modalPopupParams['modalpopupwidth'];
    var modaldismiss = modalPopupParams['modaldismiss'];
    var callBack = modalPopupParams['callback'];
    var staticHTMLSourceDivId = modalPopupParams['statichtmlsourcedivid'];


    modalcontainer = $('#' + modalcontainer);

    var modalcontent = modalcontainer.find('#modal-content');
    if (modaldismiss == 'undefined')
        modaldismiss = 'false';

    if (modalpopupwidth != null) {
        modalcontainer.removeClass("rightw25");
        modalcontainer.removeClass("rightw35");
        modalcontainer.removeClass("rightw50");
        modalcontainer.removeClass("rightw75");
        modalcontainer.addClass(modalpopupwidth);
    }

    var cache = $(this).data('cache');
    if (cache != true) {
        cache = false;
    }

    var modaltitle = $(this).data('modaltitle');
    var modalheader = $(this).data('modalheader');

    modalcontainer.find('#modaltitle').text(modaltitle);
    modalcontainer.find('#modalheader').text(modalheader);


    if (staticHTMLSourceDivId) {
        staticHTMLSourceDivId = '#' + staticHTMLSourceDivId;
        var staticHTML = $(staticHTMLSourceDivId).html();
        modalcontent.html(staticHTML);
        modalcontainer.modal();
        return;
    }


    $.ajax({
        url: url,
        type: "GET",
        data: urlParameters,
        success: function (data) {
            modalcontent.html(data);

            if (modaltitle !== null && modaltitle !== "undefined")
                modalcontainer.find('#modaltitle').text(modaltitle);
            if (modalheader !== null && modalheader !== "undefined")
                modalcontainer.find('#modalheader').text(modalheader);

            if (modalcontainer[0].id == "modalcontainer" && modaldismiss != "auto")
                modalcontainer.modal({ backdrop: 'static', keyboard: false });
            else
                modalcontainer.modal();

            if (typeof localScript == 'function') {
                localScript();
            }

            if (callBack) {
                window[callBack]();
            }
        },
        error: function (result) {
            errorText = result.responseText.indexOf("divErrorMessage") == -1 ? result.responseText : ($(result.responseText).find("div[id*=divErrorMessage]").text()).replace("text-danger", "text-white");
            notify("error", errorText, 'Error');
        }
    });
}
