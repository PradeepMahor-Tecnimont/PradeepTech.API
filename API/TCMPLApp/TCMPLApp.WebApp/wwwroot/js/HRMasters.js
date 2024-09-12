function exportExcel(Purl) {
    let vStartDate = $("#formHRMISExcelDownload input[id=StartDate]").val();
    let vEndDate = $("#formHRMISExcelDownload input[id=EndDate]").val();
    let vTypeId = $("#formHRMISExcelDownload input[id=typeId]").val();

    if (vStartDate == null || vStartDate == '') {
        toastr.error('Invalid Start Date ');
        return;
    }
    if (vEndDate == null || vEndDate == '') {
        toastr.error('Invalid End Date');
        return;
    }
    if (vTypeId == null || vTypeId == '') {
        toastr.error('Invalid type');
        return;
    }

    $.ajax({
        headers: { "RequestVerificationToken": $('#formHRMISExcelDownload input[name="__RequestVerificationToken"]').val() },
        url: Purl,
        type: "POST",
        data: {
            startDate: vStartDate,
            endDate: vEndDate,
            typeId: vTypeId
        },
        cache: false,
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
        beforeSend: function () {
            showLoader();
            $("#btnExportExcel").hide();
            $('#exportExcel_Loader').removeClass("hidden");
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
            toastr.success("File downloaded successfully.");
            hideLoader();
            $("#modalcontainer").modal('hide');

            $("#btnExportExcel").show();
            $('#exportExcel_Loader').addClass("hidden");
        },
        error: function (xhr) {
            showError(xhr);
            hideLoader();
            $("#btnExportExcel").show();
            $('#exportExcel_Loader').addClass("hidden");
        }
    });
}