function ImportFile() {

    $("#myawesomedropzone").dropzone({
        init: function () {
            this.on("addedfile", function (file) {
                showLoader();
                $('#response').html('');
                $('#result').html('');
            });
            this.on("success", function (file, data) {

                if (data.success == false) {
                    $('#response').addClass('text-c-red');
                    $('#response').html(data.response);
                    $('#result').html('');

                    if (data.data != null) {
                        var table = '<table class="display table nowrap" style="width:100%">';
                        table += '<thead><tr role="row">';
                        table += '<th>' + $.i18n('Excel row number') + '</th>';
                        table += '<th>' + $.i18n('Field name') + '</th>';
                        table += '<th>' + $.i18n('Message') + '</th>';
                        table += '</tr></thead>';

                        $(data.data).each(function () {
                            table += '<tr><td>' + ((this.excelRowNumber == null) ? '' : this.excelRowNumber) + '</td><td>' + this.fieldName + '</td><td>' + this.message + '</td></tr>';
                        });
                        table += '</table>';
                        $('#result').html(table);
                    }

                    if (data.fileContent != null) {
                        var blob = b64toBlob(data.fileContent.fileContents, data.fileContent.contentType);
                        var link = document.createElement('a');
                        link.href = window.URL.createObjectURL(blob);
                        link.download = data.fileContent.fileDownloadName;
                        link.click();
                    }

                } else {
                    $('#reload').val('True');
                    $('#response').removeClass('text-c-red');
                    $('#response').html(data.response);
                    $('#result').html('');
                }

                hideLoader();
            });
        }
    });

    $("#mywalletdropzone").dropzone({
        preventDuplicates: true,
        maxFiles: 5,
        acceptedFiles: "image/*,application/pdf",
        maxFilesize: 5
    });

    const b64toBlob = (b64Data, contentType = '', sliceSize = 512) => {
        const byteCharacters = atob(b64Data);
        const byteArrays = [];

        for (let offset = 0; offset < byteCharacters.length; offset += sliceSize) {
            const slice = byteCharacters.slice(offset, offset + sliceSize);

            const byteNumbers = new Array(slice.length);
            for (let i = 0; i < slice.length; i++) {
                byteNumbers[i] = slice.charCodeAt(i);
            }

            const byteArray = new Uint8Array(byteNumbers);
            byteArrays.push(byteArray);
        }

        const blob = new Blob(byteArrays, { type: contentType });
        return blob;
    };

}