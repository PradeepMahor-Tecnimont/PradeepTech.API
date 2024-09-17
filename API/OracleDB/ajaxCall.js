function ajaxCall() {
	let empno = $("#Empno").val();
	let requestVerificationToken = $('#formInfoEdit input[name="__RequestVerificationToken"]').val();

	$.ajax({
		url: "@Url.Action("Action", "Controller", new { Area = "Area" })",

		data: {
			param1: $("#Empno").val(),
			param2: $("#formInfoEdit #Invo").val(),
		},

		type: 'GET',
		beforeSend: function (jqXhr, setting) {
			showModalLoader();
			if (requestVerificationToken)
				jqXhr.setRequestHeader('RequestVerificationToken', requestVerificationToken);
		},
		success: function (data, textStatus, jqXhr) {
			if (data.messageType == "OK") {
				//some processing
			} else {
				showError(data.messageText);
			}
		},
		error: function (jqXhr, textSatus, errorThrown) {

			showError(jqXhr);

		},
		complete: function (jqXhr, textSatus) {
			calculations();
			hideModalLoader();
		}
	});

}
