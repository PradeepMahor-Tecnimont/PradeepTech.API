
    function listenCostCenterCmId(url) {

        $('#CmId').on('change', function (e) {
            var cmId = $('#CmId').val();
            var phase = $('#Phase').val();

            if (cmId != null && cmId != '') {
                $.ajax({
                    url: url,
                    data: {
                        'cmid': cmId
                    },
                    type: 'GET',
                    beforeSend: function () {
                        showLoader();
                    },
                    success: function (data) {
                        let dropdown = $('#Phase');
                        dropdown.empty();
                        var flag = false;
                        var options = '';

                        $(data).each(function () {
                            if (this.dataValueField == phase) {
                                flag = true;
                                options += '<option selected="selected" value="' + this.dataValueField + '">' + this.dataTextField + '</option>';
                            }
                            else {
                                options += '<option value="' + this.dataValueField + '">' + this.dataTextField + '</option>';
                            }
                        });
                        dropdown.html(options);

                        if (flag == false) {
                            phase = null;
                        }

                        dropdown.val(phase);
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