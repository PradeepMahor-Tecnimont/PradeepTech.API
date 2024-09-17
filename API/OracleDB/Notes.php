----------------------------------------------------------
1) F5 : is used to start your project in debug mode and Ctrl-F5 is used to start your project without debug mode.
2) F7 : is used to show code view of your webpage.
		Shift-F7 is used to show design view of your webpage.
3) F6 / Shift-F6 / Ctrl-Shift-B : All of the above shortcuts are used to build the project or solutions.		

4) Ctrl-Shift-A : is used to add new item to your project.

5) Ctrl-K + Ctrl-C is used to do comment a selected block of code.
6) Ctrl-K + Ctrl-U is used to do uncomment a selected block of code.
----------------------------------------------------------
----------------------------------------------------------
----------------------------------------------------------
GitMahor#47@84240SmMahor

OraInfinif#47@84240SmMahor
LinkInfinif#47@84240SmMahor
PradeepInfinixUdemy@47
FGH2095196
FeturedeepInfinixUdemy@47


305085

Telerik#47@84240SmMahor
smpradeepmahor@gmail.com

https://github.com/PradeepMahor-Tecnimont/ServiceHub

smpradeepmahor+CreativeTIM@gmail.com

smpradeepmahor+CreativeTIM@gmail.com
smpPradeepInfinixUdemy@47

.NET Core MVC - The Complete Guide 2023 [E-commerce] [.NET8]
ASP.NET Core - SOLID and Clean Architecture
The Complete Oracle SQL Bootcamp (2024)
The Complete Oracle SQL Certification Course

/// <summary>
/// The main entry point for the application.
/// </summary>

----------------------------------------------------------
1) F5 : is used to start your project in debug mode and Ctrl-F5 is used to start your project without debug mode.
2) F7 : is used to show code view of your webpage.
		Shift-F7 is used to show design view of your webpage.
3) F6 / Shift-F6 / Ctrl-Shift-B : All of the above shortcuts are used to build the project or solutions.		

4) Ctrl-Shift-A : is used to add new item to your project.

5) Ctrl-K + Ctrl-C is used to do comment a selected block of code.
6) Ctrl-K + Ctrl-U is used to do uncomment a selected block of code.

7) Ctrl-M + Ctrl-O is used to collapse all code to definitions.
8) Ctrl-M + Ctrl-P is used to expand all code.

9) Ctrl-K + Ctrl-S & Alt-Shift-Arrow(Right,Left,Bottom,Top)
10) Ctrl-K + Ctrl-S is used to surrounded a block of code to an specific block or control.


11) if Tab-Tab : Creates a if directive and a #endif directive.

12) ~ Tab-Tab 			:  Creates a destructor for the containing class.
13) attribute Tab-Tab	:    Creates a declaration for a class that derives from Attribute.
14) checked  Tab-Tab 	:  Creates a checked block.
15) class  Tab-Tab 		:  Creates a class declaration.
16) ctor  Tab-Tab 		:  Creates a constructor for the containing class.
17) cw  Tab-Tab 		:  Creates a call to WriteLine.
18) do  Tab-Tab 		:  Creates a do while loop.
19) else  Tab-Tab 		:  Creates an else block.
20) enum  Tab-Tab 		:  Creates an enum declaration.
21) equals  Tab-Tab 	:  Creates a method declaration that overrides the Equals method defined in the Object class.
22) exception  Tab-Tab  :  Creates a declaration for a class that derives from an exception (Exception by default).
23) for  Tab-Tab 		:  Creates a for loop.
24) foreach  Tab-Tab 	:  Creates a foreach loop.
25) forr  Tab-Tab 		:  Creates a for loop that decrements the loop variable after each iteration.
26) if  Tab-Tab 		:  Creates an if block.
27) indexer  Tab-Tab    :  Creates an indexer declaration.
28) interface  Tab-Tab  :  Creates an interface declaration.
29) invoke  Tab-Tab 	:  Creates a block that safely invokes an event.
30) iterator  Tab-Tab   :  Creates an iterator.
31) iterindex  Tab-Tab  :  Creates a "named" iterator and indexer pair by using a nested class.
32) lock  Tab-Tab 		:  Creates a lock block.
33) mbox  Tab-Tab 		:  Creates a call to MessageBox.Show. You may have to add a reference to System.Windows.Forms.dll.
34) namespace  Tab-Tab  :  Creates a namespace declaration.
35) prop  Tab-Tab 		:  Creates an auto-implemented property declaration.
36) propfull  Tab-Tab 	:  Creates a property declaration with get and set accessors.
37) propg  Tab-Tab 		:  Creates a read-only auto-implemented property with a private "set" accessor.
38) sim  Tab-Tab 		:  Creates a static int Main method declaration.
39) struct Tab-Tab 		:   Creates a struct declaration.
40) svm  Tab-Tab 		:  Creates a static void Main method declaration.
41) switch  Tab-Tab 	:  Creates a switch block.
42) try  Tab-Tab 		:  Creates a try-catch block.
43) tryf  Tab-Tab 		:  Creates a try-finally block.
44) unchecked  Tab-Tab  :  Creates an unchecked block.
45) unsafe  Tab-Tab 	:  Creates an unsafe block.
46) using  Tab-Tab 		:  Creates a using directive.
47) while  Tab-Tab 		:  Creates a while loop.
48) 
49) 
50) Ctrl+K+X to insert snippet in your code.
	If these shortcuts are difficult to remember you then no worry, here is trick for that too. Just press

51) Ctrl+shift+V : Use for clicpBord fot VS
52) 
53) 
54) 
55) 

https://www.dofactory.com/csharp-coding-standards

----------------------------------------------------------

_ :- discord character [Use for do things and dont get any val from back]

----------------------------------------------------------
Scaffold-DbContext "Server=(localdb)\\MSSQLLocalDB;Database=DemoDB;Trusted_Connection=True;MultipleActiveResultSets=true" MySql.EntityFrameworkCore

----------------------------------------------------------

----------------------------------------------------------

 
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#- Wait - Loaders -#

showModalLoader();   
hideModalLoader();
	
showLoader();
hideLoader();
---------------------------------------------------------------------------------------------------------------------------------------------
function genericSearchKeypress(fnName) {
    if (this.event.keyCode === 13) {
        if (this.length) {
            if (fnName == "ModuleRoleActionSearch") {
                loadModuleRolesActionDataTable();
            }
        }
    }
}
function genericSearchOnClick(fnName) {
    if (this.length) {
        if (fnName == "ModuleRoleActionSearch") {
            loadModuleRolesActionDataTable();
        }
    }
}


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
OnTAb dataList With genericSearch


<input type="text" class="form-control form-control-sm border" id="ModuleRoleActionSearch" name="GenericSearch"
            onkeypress="genericSearchKeypress('ModuleRoleActionSearch')" placeholder="Search...">
<div class="input-group-append">
<button class="btn btn-sm btn-outline-info" type="button" id="buttonModuleRoleAction"
                onclick="genericSearchOnClick('ModuleRoleActionSearch')">
<i class="fa fa-search"></i>
</button>
</div>

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
Show Delete Confirmation Popup
Note
data-confirmationtype   = ""   // warning / error / success /info
data-confirmbuttonclass = "" // btn-danger btn-sm / btn-info btn-sm / btn-success btn-sm

{
	data: null,
	render: function (data, type, row) {
		 return '<button title="Delete" class="btn btn-outline-danger btn-sm border-none " ' +
				' onclick = "showDeleteConfirmationPopup(event,this);" ' +
				' data-jqueryselector = "showconfirmationmodal" ' +
				' data-url="@Url.Action("OFBRollbackDelete", "OFB", new { Area = "OffBoarding" })"' +
				' data-id="' + data.empno + '"' +
				' data-PostReLoadDataTables="OK" ' +
				' data-modaltitle="Please Confirm!" ' +
				' data-confirmationtype="warning" ' +
				' data-confirmationtext="Do you want to delete rollback request \n (' + data.empno + ' - ' + data.employeeName + ') ?" ' +
				' title="Delete" ' +
				' data-confirmbuttontext="Delete" > ' +
				' <i class="fas fa-trash" aria-hidden="true"></i> ' +
				' </button>';


	},
	className: "td-icon",
},

Show Approve Confirmation Popup
{
	data: null,
	render: function (data, type, row) {
			return '<button title="Approve rollback" class="btn btn-outline-info btn-sm border-none " ' +
					' onclick = "showDeleteConfirmationPopup(event,this);" ' +
					' data-jqueryselector = "showconfirmationmodal" ' +
					' data-url="@Url.Action("OFBRollbackApprove", "OFB", new { Area = "OffBoarding" })"' +
					' data-id="' + data.empno + '"' +
					' data-PostReLoadDataTables="OK" ' +
					' data-modaltitle="Please Confirm!" ' +
					' data-confirmationtype="success" ' +
					' data-confirmbuttonclass="btn-success btn-sm" ' +
					' data-confirmationtext="Do you want to approve rollback request \n (' + data.empno + ' - ' + data.employeeName + ') ?" ' +
					' title="approve" ' +
					' data-confirmbuttontext="approve" > ' +
							' <i class="fas fa-check-circle	" aria-hidden="true"></i> ' +
					' </button>';



	},
	className: "td-icon",
}
 
  function PostReLoadDataTables(data) {
            if (data.success) {
                loadOFBRollbackPendingIndexDataTable();
                hideLoader();
                notify('success', data.message, 'Success');
            }
        };

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
$("#btnconfirm").on("click", function () {
       let vbtn = $("#btnconfirm");
       vbtn.prop("disabled", true);
       vbtn.html(vbtn.data('loading-text'));
 
       $("#formAppointmentLetter").submit();
   });
   
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
var yourObject = {
          test:'test 1',
          testData: [ 
                {testName: 'do',testId:''}
          ],
          testRcd:'value'   
};

JSON.stringify(yourObject)

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

download file 

#----Js------#
 return '<button class="btn btn-outline-info btn-sm border-none  " ' +
	' data-jqueryselector="openmodal" ' +
	' data-modalcontainer="modmodalcontainer" ' +
	' data-url="@Url.Action("VoluntaryParentsPolicyDetailForHRIndex", "GeneralInfo", new { Area = "EmpGenInfo" })"' +
	' data-modalpopupwidth="rightw50" ' +
	' data-id="' + data.empno + '"' +
	' data-modaltitle="Voluntary parents policy detail list" ' +
	' data-modalheader="Voluntary parents policy detail" ' +
	' > ' +
	' <i class="far fa-eye" aria-hidden="true"></i> ' +
' </button>'
								


<a style="float:right" class="btn btn-outline-success btn-sm border border-white mx-2 ml-auto"
   href="#"
   data-jqueryselector="binarydownload"
   data-url="@(Url.Action("ExcelDownload", "LetterOfCredit", new { Area = "LC" }))"
>
	<i class="fas fa-file-excel green-color"></i> Export
</a>
			
			
#----C#------#
 #region Excel Download

        public async Task<IActionResult> ExcelDownload(string id)
        {
            try
            {
                string StrFimeName;

                var timeStamp = DateTime.Now.ToFileTime();
                StrFimeName = "FileName_" + timeStamp.ToString();

                DataTable dt = new DataTable();
                string strUser = User.Identity.Name;

                var data = await _afcLcMainExcelDataTableListRepository.AfcLcMainExcelDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                    });

                if (data == null) { return NotFound(); }

                var byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(data, "Report Title", "Sheet name");
               
                var mimeType = MimeTypeMap.GetMimeType("xlsx");

                FileContentResult file = File(byteContent, mimeType, StrFimeName);

                return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

#endregion Excel Download			

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
$('#txtcomplaint').bind('paste', function(e){ alert('pasting!') });

function logCopy(event) {
  log.innerText = `Copied!\n${log.innerText}`;
}

function logPaste(event) {
  log.innerText = `Pasted!\n${log.innerText}`;
}

const editor = document.getElementById("editor");
const log = document.getElementById("log");

editor.oncopy = logCopy;
editor.onpaste = logPaste;	
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Ajax Popup File Donload Sample search

data-url='@Url.Action("EmployeeMediclaimDetailsExcel", "Report", new { Area = "EmpGenInfo" })'>

public async Task<IActionResult> EmployeeMediclaimDetailsExcel()
public async Task<IActionResult> EmployeeMediclaimDetailsExcel(DateTime startDate, DateTime endDate)

_ModalMediclaimFilterSet


  function localScript() {
            initSelect2();
            initDatePicker();
            initFilter();

            $('#btnExportMediclaimStatusExcel').off('click').on('click', function () {
                event.preventDefault();
                event.stopPropagation();
                exportMediclaimStatusExcel();
            });

        }


  function initDatePicker() {
            $('.datepicker').bootstrapMaterialDatePicker({
                format: 'DD-MMM-YYYY',
                weekStart: 0,
                time: false,
                useCurrent: false,
                nowButton: true,
                clearButton: true
            });

            $("#endDate").on("change", function (event, date) {
                $("#EndDate").val($(this).val());
            });
            $("#startDate").on("change", function (event, date) {

                $("#StartDate").val($(this).val());
                if ($("#endDate").val()) {
                    let startDate = moment($(this).val(), "DD-MMM-YYYY");
                    let endDate = moment($("#endDate").val(), "DD-MMM-YYYY");
                    if (endDate < startDate) {
                        $("#endDate").val('');
                        $('#endDate').val(moment(startDate).format("DD-MMM-YYYY"));
                    }
                }
                else {
                    $("#endDate").val($(this).val());
                }

                $("#endDate").bootstrapMaterialDatePicker('setDate', $(this).val());
                $("#endDate").trigger('change');
            });

        }

        function initFilter() {


            $('.datepickerFilter').bootstrapMaterialDatePicker({
                format: 'DD-MMM-YYYY',
                weekStart: 0,
                time: false,
                useCurrent: false
            });

            $('#startDateFilter').bootstrapMaterialDatePicker({
                format: 'DD-MMM-YYYY',
                weekStart: 0,
                time: false
            }).on('change', function (e, date) {
                $('#endDateFilter').bootstrapMaterialDatePicker('setMinDate', date);
                $("#StartDate").val(date.format('DD-MMM-YYYY'));
            });

            $('#endDateFilter').bootstrapMaterialDatePicker({
                format: 'DD-MMM-YYYY',
                weekStart: 0,
                time: false
            }).on('change', function (e, date) {
                $("#EndDate").val(date.format('DD-MMM-YYYY'));
            });
        }


   function exportMediclaimStatusExcel() {

            let vStartDate = $("#formEmployeeMediclaimDetailsExcel input[id=StartDate]").val();
            let vEndDate = $("#formEmployeeMediclaimDetailsExcel input[id=EndDate]").val();

            if (vStartDate == null || vStartDate == '') {
                toastr.error('Invalid Start Date ');
                return;
            }
            if (vEndDate == null || vEndDate == '') {
                toastr.error('Invalid End Date');
                return;
            }


            $.ajax({
                headers: { "RequestVerificationToken": $('#EmployeeMediclaimDetailsExcel input[name="__RequestVerificationToken"]').val() },
                url: '@Url.Action("EmployeeMediclaimDetailsExcel", "Report", new {Area = "EmpGenInfo" })',
                type: "POST",
                data: {
                    startDate: vStartDate,
                    endDate: vEndDate
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
                    $("#btnExportMediclaimStatusExcel").hide();
                    $('#MediclaimStatus_Loader').removeClass("hidden");
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

                    $("#btnExportMediclaimStatusExcel").show();
                    $('#MediclaimStatus_Loader').addClass("hidden");
                },
                error: function (xhr) {
                    showError(xhr);
                    hideLoader();
                    $("#btnExportMediclaimStatusExcel").show();
                    $('#MediclaimStatus_Loader').addClass("hidden");
                }
            });
        }

------------------------------------------------------------------------------------------------------------------------------------------
Reading DataTable Row by Row and generating Json object.

      $('#btnSubmit').on('click', function () {

           let transactionDate = $('#TransDate').val();
           let transactionRemarks = $('#Remarks').val();

           if(transactionDate == null || transactionDate == '' ){
                notify("error", "Transaction date is required.. ", 'Error');
                $('#transDate').focus();
               return;
           }
           if(transactionRemarks.lenth <= 0 || transactionRemarks == '' ){
                notify("error", "Remarks date is required.. ", 'Error');
                $('#Remarks').focus();
               return;
           }

            var objs = [];
            var rturncount = 0;
              
            $("#tbGrid > tbody > tr").each(function (index,element)
            {
                //console.log($(element).find(".checkBox-Blue").val() + " , IsReturn :" + $(element).find(".checkBox-Blue").prop('checked') + " :- " + $(element).find(':selected').val());
                var vitemid = $(element).find(".checkBox-Blue").val();
                var vIsReturn = $(element).find(".checkBox-Blue").prop('checked');
                var vIsUsable = $(element).find(':selected').text();
                //var temp = vitemid +'~!~' + vIsReturn  +'~!~' + vIsUsable +',';

                var tempJson = {"itemId" : vitemid ,"isReturn" : vIsReturn ,"isUsable" : vIsUsable };                 

                objs.push(tempJson);

                if(vIsReturn == true || vIsReturn =="true"){
                    rturncount = rturncount + 1;
                }

            });

            if(rturncount == 0){
                notify("error", "Return Item not selected.. ", 'Error');
                return;
            }

            var JsObject = {
                    transDate   : transactionDate,
                    transRemark : transactionRemarks,
                    returnItem  : objs
            };

            JsObject = JSON.stringify(JsObject)
            console.log(JsObject); 

              notify("success", JsObject, 'Success');
              return;

              $.ajax({
                headers: { "RequestVerificationToken": $('input[name="__RequestVerificationToken"]').val() },
                url: '@Url.Action("SubmitReturn", "INV", new {Area = "DMS" })',
                type: 'POST',
                data: {
                    items: objs
                },
                beforeSend: function () {
                    showLoader();
                },
                success: function (data) {
                    hideLoader();
                    if (data.success) {
                        notify("success", data.response, "Success");
                        loadNewEmployeeDataTable();
                        $('#CheckAll').prop('checked', false);

                    }
                    else {
                        notify("error", data.response, "Error");
                    }

                },
                error: function (result) {
                    hideLoader();
                    errorText = result.responseText.indexOf("divErrorMessage") == -1 ? result.responseText : ($(result.responseText).find("div[id*=divErrorMessage]").text()).replace("text-danger", "text-white");
                    notify("error", errorText, 'Error');
                }
            });

            });
			
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
Bootstrap date Year Selection

 var curdate = new Date();

            var minYear = curdate.getFullYear() - 1;
            var maxYear = curdate.getFullYear();

            $('.selectYearFilter').datepicker({
                format: "yyyy",
                startView: "years",
                minViewMode: "years",
                maxViewMode: "years",
                clearBtn: true,
                changeYear: true,
                defaultViewDate: {
                    year: maxYear
                },
                startDate: '-25y', //2021 -1950
                endDate: 'y' //'+1y' //2021-2011
            });

            $('#SelectYearFilter').datepicker({
                format: 'yyyy',
                changeYear: true,

            }).on('change', function (e, date) {

                var fvDate = $(this).val();

                if (fvDate) {
                    $("#SelectYear").val(moment(fvDate, 'YYYY').format("YYYY"));
                }
                else {
                    $("#SelectYear").val("");
                }

                $(this).datepicker('hide');
            });

            if ($("#SelectYear").val()) {
                $('#SelectYearFilter').val(moment($("#SelectYear").val(), "YYYY").format('YYYY'));
            }

-------------------------------------------------------------------------------------------------------------------------------------------------------------------

https://www.gyrocode.com/articles/jquery-datatables-checkboxes/


For Reload Index Page a Delete
' data-redirecturl="@Url.Action("VoluntaryParentPolicyForHRIndex", "GeneralInfo", new { Area = "EmpGenInfo" })"' +
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
Sm#Infinix@ICT23#_Mahor

 function onSave() {
            var table = $('#tbNewEmployee').DataTable();
            var data = table.rows().data();
            var objs = [];
            var vParams = $($('#tbNewEmployee').find('input.check[type=checkbox]:checked').serializeArray());
            
            if(vParams.length === 0){
                  notify("error", "Employee not selected..", "Error");
                  return;
            }
            $.each(vParams, function (i, field) {
                itemApprl = {}
                //itemApprl["empno"] = field.name;
                //itemApprl["checked"] = field.value;
                var temp = field.name +'~!~' + field.value;
                objs.push(temp);
            });



            $.ajax({
                headers: { "RequestVerificationToken": $('input[name="__RequestVerificationToken"]').val() },
                url: '@Url.Action("SubmitNewEmployee", "DMS", new {Area = "DMS" })',
                type: 'POST',
                data: {
                    emps: objs
                },
                beforeSend: function () {
                    showLoader();
                },
                success: function (data) {
                    hideLoader();
                    if (data.success) {
                        notify("success", data.response, "Success");
                        loadNewEmployeeDataTable();
                        $('#CheckAll').prop('checked', false);

                    }
                    else {
                        notify("error", data.response, "Error");
                    }

                },
                error: function (result) {
                    hideLoader();
                    errorText = result.responseText.indexOf("divErrorMessage") == -1 ? result.responseText : ($(result.responseText).find("div[id*=divErrorMessage]").text()).replace("text-danger", "text-white");
                    notify("error", errorText, 'Error');
                }
            });

            return false;
        }

-------------------------------------------------------------------------------------------------------------------------------------------------------------------
Not complete status
 <li class="nav-item">
                        <a class="nav-link" id="tabs-phases-tab" data-toggle="pill" href="#tabs-phases" role="tab" aria-controls="tabs-phases" aria-selected="false"
                           data-url="@Url.Action("PhaseIndex", "JOB", new { Area = "JOB" })"
                           data-id="@Model.Projno"
                           data-divid="pw-phases"
                           data-callback="loadJobPhaseDataTable()"
                           data-area="JOB"
                           data-controller="JOB"
                           data-action="PhaseIndex"
                           >@localizer["Job phases"]
                            <i id="imgJobPhasesStatus" class="fas fa-info-circle text-danger" style="display:none"></i>
                        </a>
                    </li>
					
 if (data.pJobPhasesType == 'KO') {
                $("#imgJobPhasesStatus").show();
                $("#imgJobPhasesStatus").attr("title", data.pJobPhasesText);
                $("#spanJobPhasesStatus").text(data.pJobPhasesText);
            }
            else {
                $("#imgJobPhasesStatus").hide();
                $("#spanJobPhasesStatus").hide();
            }

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Jquery TextBox Functions

 onkeypress="return AvoidSpace(event);"
 onkeypress="return RestrictAlphabets(event);"
 onkeypress="return AllowNumbersOnly(event);"
 onkeypress="return AllowDecimalNumbersOnly(event);"
 			
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------


' data-PostDeleteReLoadDataTables="OK" ' +
' data-confirmationtext="Do you want to delete Project Type (' + data.shortDescription + ' - ' + data.description + ') ?" ' +

function PostDeleteReLoadDataTables(data) {
            console.log(data);
            if (data.success) {
                loadDataTable();
                hideLoader();
               notify('success', data.message, 'Success');
            }
        }
		
----------------------------------------------------------------------------------------------------------------------------------
Bootstrap DatePicker

 $('#nomDob').attr('readonly', 'true');
 
  $("#nomDob").datepicker({
        format: 'dd-M-yyyy',
        autoclose: true,
    }).on('changeDate', function (selected) {
        $("#NomDob").val($('#nomDob').datepicker('getFormattedDate'));
    });


---------------------------------------------------------------------------------------------------------------------	

DatePicker Manipulation

 $('#startDateFilter').bootstrapMaterialDatePicker({
		format: 'DD-MMM-YYYY',
		weekStart: 0,
		time: false
	}).on('change', function (e, date) {
		$("#StartDate").val(date.format('DD-MMM-YYYY'));

		var vStartDate = moment(date);
		var futureMonth = moment(vStartDate).add(1, 'M');
		futureMonth = moment(futureMonth).subtract(1, "days");

		$('#endDateFilter').bootstrapMaterialDatePicker('setDate', vStartDate);
		$('#endDateFilter').val(moment(futureMonth).format('DD-MMM-YYYY'));
		$("#EndDate").val(moment(futureMonth).format('DD-MMM-YYYY'));
	});

	$('#endDateFilter').bootstrapMaterialDatePicker({
		format: 'DD-MMM-YYYY',
		weekStart: 0,
		time: false
	}).on('change', function (e, date) {
		$("#EndDate").val(date.format('DD-MMM-YYYY'));
	});

var currentDate = moment('2015-10-30');
var futureMonth = moment(currentDate).add(1, 'M');
var futureMonthEnd = moment(futureMonth).endOf('month');

if(currentDate.date() != futureMonth.date() && futureMonth.isSame(futureMonthEnd.format('YYYY-MM-DD'))) {
    futureMonth = futureMonth.add(1, 'd');
}

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CR000265 : HR-MIS - ResignedEmployeeIndex : Set Default values in [Add Resigned Employee] popup.
	if ($('#StartDate').val()) {
		$('#startDateFilter').val($("#StartDate").val());
		$('#startDateFilter').bootstrapMaterialDatePicker('setDate', new Date($("#StartDate").val()));
	}

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		
$("#pwsEmpPlanningPreviousList input[id=Empno]").val()
 let formId = "#" + $("div#idLcChargesIndex").closest("form").attr("id");
 
----------------------------------------------------------------------------------------------------------------------------
 <label asp-for="FromDate" class="control-label"></label>
<input id="fromDate" class="form-control datepickerFilter" placeholder="@localizer["From date"]" value="@Model.FromDate?.ToString("dd-MMM-yyyy")" required />
<span asp-validation-for="FromDate" class="text-danger"></span>
							
----------------------------------------------------------------------------------------------------------------------------
Display date in dataTable

{
	data: "fromDate",
	width: '10.0rem',
	render: function(data, type, row) {
	return moment(data).format("DD-MMM-YYYY");
	-- With Time return moment(data).format("DD-MMM-YYYY HH:mm:ss");
}

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Roles /Action Check Access Grants
var canEdit = @(CurrentUserIdentity.ProfileActions.Any(pa=> pa.ActionId == TCMPLApp.Domain.Models.SWP.SWPHelper.ActionPrimaryWsAdminEdit) ? "true" : "false" )
let canEdit = @(CurrentUserIdentity.ProfileActions.Any(pa => pa.ActionId == TCMPLApp.Domain.Models.CoreSettings.CoreSettingsHelper.ActionEditUserAccess) ? "true" : "false");
if(canEdit == true){

}

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function initDatePicker() {
    var minDate = moment().add('-30', 'days');
    $('.datepicker').bootstrapMaterialDatePicker({
        format: 'DD-MMM-YYYY',
        weekStart: 0,
        time: false,
        nowButton: true,
        minDate: minDate
    });

    $('#transferDate').bootstrapMaterialDatePicker({
        format: 'DD-MMM-YYYY',
        weekStart: 0,
        time: false
    }).on('change', function (e, date) {
        $("#TransferDate").val(date.format('DD-MMM-YYYY'));

        $("#transferEndDate").val(date.format('DD-MMM-YYYY'));

        $('#transferEndDate').bootstrapMaterialDatePicker('setMinDate', date);
        $("#TransferEndDate").val($("#transferEndDate").val());
    });

    $('#transferEndDate').bootstrapMaterialDatePicker({
        format: 'DD-MMM-YYYY',
        weekStart: 0,
        time: false,
        minDate: $("#TransferEndDate").val()
    }).on('change', function (e, date) {
        $("#TransferEndDate").val(date.format('DD-MMM-YYYY'));
    });

    $('#effectiveTransferDate').bootstrapMaterialDatePicker({
        format: 'DD-MMM-YYYY',
        weekStart: 0,
        time: false
    }).on('change', function (e, date) {
        $("#EffectiveTransferDate").val(date.format('DD-MMM-YYYY'));
    });

    if ($('#TransferDate').val()) {
        $('#transferDate').bootstrapMaterialDatePicker('setDate', new Date($("#TransferDate").val()));
    }
    if ($('#TransferEndDate').val()) {
        $('#transferEndDate').bootstrapMaterialDatePicker('setDate', new Date($("#TransferEndDate").val()));
        $('#transferEndDate').bootstrapMaterialDatePicker('setMinDate', new Date($("#TransferDate").val()));
    }
}
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
a tag / Delete with Icon in Data-table

{
                        data: null,
                        render: function (data, type, row) {
                            if (data.approvAllowed == 1) {
                                return '<button title="Approve rollback" class="btn btn-outline-primary btn-sm border-none text-nowrap" ' +
                                    ' onclick = "showDeleteConfirmationPopup(event,this);" ' +
                                    ' data-jqueryselector = "showconfirmationmodal" ' +
                                    ' data-url="@Url.Action("OFBRollbackApprove", "OFB", new { Area = "OffBoarding" })"' +
                                    ' data-id="' + data.empno + '"' +
                                    ' data-postdeletereloaddatatables="OK" ' +
                                    ' data-modaltitle="Please Confirm!" ' +
                                    ' data-confirmationtype="success" ' +
                                    ' data-confirmbuttonclass="btn-success btn-sm" ' +
                                    ' data-confirmationtext="Do you want to approve rollback request \n (' + data.empno + ' - ' + data.employeeName + ') ?" ' +
                                    ' title="approve" ' +
                                    ' data-confirmbuttontext="Approve" > ' +
                                    ' <i class="fas fa-stamp" aria-hidden="true"></i>&nbsp;&nbsp;Approve' +
                                    ' </button>';
                            }
                            else {
                                if (data.deleteAllowed == 1) {
                                    return '<button title="Delete" class="btn btn-outline-danger btn-sm border-none text-nowrap" style="padding-left:15px;padding-right:15px;"' +
                                        ' onclick = "showDeleteConfirmationPopup(event,this);" ' +
                                        ' data-jqueryselector = "showconfirmationmodal" ' +
                                        ' data-url="@Url.Action("OFBRollbackDelete", "OFB", new { Area = "OffBoarding" })"' +
                                        ' data-id="' + data.empno + '"' +
                                        ' data-postsavereloaddatatable="OK" ' +
                                        ' data-modaltitle="Please Confirm!" ' +
                                        ' data-confirmationtype="warning" ' +
                                        ' data-confirmationtext="Do you want to delete rollback request \n (' + data.empno + ' - ' + data.employeeName + ') ?" ' +
                                        ' title="Delete" ' +
                                        ' data-confirmbuttontext="Delete" > ' +
                                        ' <i class="fas fa-trash" aria-hidden="true"></i>&nbsp;&nbsp;Delete' +
                                        ' </button>';
                                }
                            }
                        },
                        className: "td-icon",
                    },


----------------------------------------------------------------------------------------------------------------------------
document.querySelector("#movecreate").click();
Use for Click [A tag] by Jquery - Its very usefull when you one recored create and want to re-open create model from server 
----------------------------------------------------------------------------------------------------------------------------
JQuery

select2 get selected value/Text from DropDown list
let vActionId = $("#formActionsFilterSet select[id=ActionId]");
let vRoleId = $("#formModuleRoleFilterSet select[id=RoleId]");

let vActionId = $("#formModuleRoleActionsFilterSet select[id=ActionId]");
let vRoleId = $("#formModuleRoleActionsFilterSet select[id=RoleId]");

var vAssetCategoryVal = $("#formAssetWithITPoolExcel select[id=AssetCategory]").val();
var vassetCategoryText = $("#formAssetWithITPoolExcel select[id=AssetCategory]").find(':selected').text();

----------------------------------------------------------------------------------------------------------------------------
        function GetActions() {

                 $('#ModuleId').on('change', function (e) {
                 var vModule = $('#ModuleId').val();
                 var vRole = $('#RoleId').val();

                    $.ajax({
                        url: "@Url.Action("GetActionsList", "UserAccess", new { Area = "CoreSettings" })",
                        type: 'GET',
                        data: {
                            module: vModule,
                            role: vRole
                        },
                        beforeSend: function () {
                            showModalLoader();
                            $("#ActionId").prop("disabled", true);
                        },
                        success: function (data) {
                            let dropdown = $('#ActionId');
                            dropdown.empty();
                            var options = '';
                            var flag = false;
                            var phase = null;
                            $(data).each(function () {

                                options += '<option value="' + this.dataValueField + '">' + this.dataTextField + '</option>';

                            });
                            dropdown.html(options);
                            if (flag == false) {
                                phase = null;
                            }

                            dropdown.val(phase);
                            hideModalLoader()
                            $("#ActionId").prop("disabled", false);
                        },
                        error: function (result) {
                            hideModalLoader();
                            $("#ActionId").prop("disabled", false);
                            notify($.i18n('Error'), result.responseText, 'danger');
                        }
                    });

            });
    };

        function GetRolesList() {
            $('#ModuleId').on('change', function (e) {
            var vModule = $('#ModuleId').val();
            var vRole = $('#RoleId').val();

               $.ajax({
                   url: "@Url.Action("GetRolesList", "UserAccess", new { Area = "CoreSettings" })",
                   type: 'GET',
                   data: {
                       module: vModule,
                       role: vRole
                   },
                   beforeSend: function () {
                       showModalLoader();
                       $("#RoleId").prop("disabled", true);
                   },
                   success: function (data) {
                       let dropdown = $('#RoleId');
                       dropdown.empty();
                       var options = '';
                       var flag = false;
                       var phase = null;
                       $(data).each(function () {

                           options += '<option value="' + this.dataValueField + '">' + this.dataTextField + '</option>';

                       });
                       dropdown.html(options);
                       if (flag == false) {
                           phase = null;
                       }

                       dropdown.val(phase);
                       hideModalLoader()
                       $("#RoleId").prop("disabled", false);
                   },
                   error: function (result) {
                       hideModalLoader();
                       $("#RoleId").prop("disabled", false);
                       notify($.i18n('Error'), result.responseText, 'danger');
                   }
               });

       });
    };

        function GetEmployeesList() {

            $('#ModuleId').on('change', function (e) {
            var vModule = $('#ModuleId').val();
            var vRole = $('#RoleId').val();

               $.ajax({
                   url: "@Url.Action("GetActionsList", "UserAccess", new { Area = "CoreSettings" })",
                   type: 'GET',
                   data: {
                       module: vModule,
                       role: vRole
                   },
                   beforeSend: function () {
                       showModalLoader();
                       $("#Empno").prop("disabled", true);
                   },
                   success: function (data) {
                       let dropdown = $('#Empno');
                       dropdown.empty();
                       var options = '';
                       var flag = false;
                       var phase = null;
                       $(data).each(function () {

                           options += '<option value="' + this.dataValueField + '">' + this.dataTextField + '</option>';

                       });
                       dropdown.html(options);
                       if (flag == false) {
                           phase = null;
                       }

                       dropdown.val(phase);
                       hideModalLoader()
                       $("#Empno").prop("disabled", false);
                   },
                   error: function (result) {
                       hideModalLoader();
                       $("#Empno").prop("disabled", false);
                       notify($.i18n('Error'), result.responseText, 'danger');
                   }
               });

       });
};
----------------------------------------------------------------------------------------------------------------------------

Read DataTable Row by Row

  $("table > tbody > tr").each(function (index,element)
             {
                 //console.log(index);
                 console.log($(element).find(".checkBox-Blue").val() + " : " + $(element).find(".checkBox-Blue").prop('checked') + " :- " + $(element).find(':selected').text());
                // var vcheckBox = document.getElementById('takenBefore');
               // alert($(element).find(".checkBox-Blue:checked").val() + " : " + $(element).find(':selected').text());
              });
			  
----------------------------------------------------------------------------------------------------------------------------
function ItemTypeCodeChange() {
    $('#ItemTypeCode').on('change', function (e) {
    var itemTypeCode = $('#ItemTypeCode').val();
    var itemId = $('#ItemId').val();
 
    if (itemTypeCode != null && itemTypeCode != '') {
        $.ajax({
            url: "@Url.Action("GetItem", "INV", new {Area = "DMS"})",
            data: {
                'id': itemTypeCode
            },
            type: 'GET',
            beforeSend: function () {
                showLoader();
            },
            success: function (data) {
                let dropdown = $('#ItemId');
                dropdown.empty();
                var flag = false;
                var options = '';
 
                $(data).each(function () {
                    if (this.dataValueField == itemId) {
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
----------------------------------------------------------------------------------------------------------------------------
$("#BookingResourceTypeId").change(function (e) {
var selected = $('#BookingResourceTypeId').find(':selected');
var bookingResourceTypeName = selected[0].label;
var filters = $('#Filters').val();

$.ajax({
url: '/Facility/BookingResource/SelectFilters',
data: {
'bookingResourceTypeName': bookingResourceTypeName
},
type: 'GET',
beforeSend: function () {
showLoader();
},
success: function (data) {
let dropdown = $('#Filters');
dropdown.empty();
var flag = false;

$(data).each(function () {
var optgroup = dropdown.find('optgroup[label="' + this.dataGroupField + '"]');

if (optgroup.length == 0) {
$('<optgroup label="' + this.dataGroupField + '">').appendTo(dropdown);
optgroup = dropdown.find('optgroup[label="' + this.dataGroupField + '"]');
}

$('<option value="' + this.dataValueField + '">' + this.dataTextField + '</option>').appendTo(optgroup);
});

if (flag == false) {
filters = null;
}

dropdown.val(filters);
dropdown.trigger("change");
hideLoader();
},
error: function (result) {
hideLoader();
notify($.i18n('Error'), result.responseText, 'danger');
}
});

});


---------------------------------------------------------------------------------------------------------------------------------------------------------
  function showConfirmationPopup(){

            swal({
                title: "Are you sure?",
                text: "Do you want to save details..!",
                type: "warning",
                showCancelButton: true,
                confirmButtonColor: "#DD6B55",
                confirmButtonText: "Yes",
                cancelButtonText: "No",
                closeOnConfirm: false,
                closeOnCancel: false
            },
            function (isConfirm) {
                if (isConfirm) {
                    swal("Saved!", "Details has been saved.", "success");
                } else {
                        swal("Canceled", "Details not saved", "error");
                }
            });

        }
---------------------------------------------------------------------------------------------------------------------------------------------------------

  public async Task<IActionResult> ResignedEmployeeEdit(string id)
        {
            try
            {
                if (id == null)
                {
                    return NotFound();
                }

                ResignedEmployeeDetails result = await _resignedEmployeeDetailRepository.ResignedEmployeeDetail(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PKeyId = id
                    });

                ResignedEmployeeUpdateViewModel resignedEmployeeUpdateViewModel = new();

                if (result.PMessageType == IsOk)
                {
                    resignedEmployeeUpdateViewModel.KeyId = id;
                    resignedEmployeeUpdateViewModel.Empno = result.PEmpno;
                    resignedEmployeeUpdateViewModel.EmployeeName = result.PEmployeeName;
                    resignedEmployeeUpdateViewModel.EmpResignDate = result.PEmpResignDate;
                    resignedEmployeeUpdateViewModel.HrReceiptDate = result.PHrReceiptDate;
                    resignedEmployeeUpdateViewModel.DateOfRelieving = result.PDateOfRelieving;
                    resignedEmployeeUpdateViewModel.EmpResignReason = result.PEmpResignReason;
                    resignedEmployeeUpdateViewModel.PrimaryReason = result.PPrimaryReason;
                    resignedEmployeeUpdateViewModel.SecondaryReason = result.PSecondaryReason;
                    resignedEmployeeUpdateViewModel.AdditionalFeedback = result.PAdditionalFeedback;
                    resignedEmployeeUpdateViewModel.ExitInterviewComplete = result.PExitInterviewComplete;
                    resignedEmployeeUpdateViewModel.PercentIncrease = result.PPercentIncrease;
                    resignedEmployeeUpdateViewModel.MovingToLocation = result.PMovingToLocation;
                    resignedEmployeeUpdateViewModel.CurrentLocation = result.PCurrentLocation;
                    resignedEmployeeUpdateViewModel.ResignStatusCode = result.PResignStatusCode;
                    resignedEmployeeUpdateViewModel.CommitmentOnRollback = result.PCommitmentOnRollback;
                    resignedEmployeeUpdateViewModel.ActualLastDateInOffice = result.PActualLastDateInOffice;

                    resignedEmployeeUpdateViewModel.Doj = result.PDoj;
                    resignedEmployeeUpdateViewModel.Grade = result.PGrade;
                    resignedEmployeeUpdateViewModel.Designation = result.PDesignation;
                    resignedEmployeeUpdateViewModel.Department = result.PDepartment;
                }

                //IEnumerable<DataField> employeeList = await _selectTcmPLRepository.SWPEmployeeList4AdminAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL
                //{
                //});
                //ViewData["EmployeeList"] = new SelectList(employeeList, "DataValueField", "DataTextField");

                IEnumerable<DataField> primaryReasonTypeList = await _selectTcmPLRepository.HRMISResignReasonTypeList(BaseSpTcmPLGet(), new ParameterSpTcmPL
                {
                });
                ViewData["PrimaryReasonTypeList"] = new SelectList(primaryReasonTypeList, "DataValueField", "DataTextField", resignedEmployeeUpdateViewModel.PrimaryReason);

                IEnumerable<DataField> secondaryReasonTypeList = await _selectTcmPLRepository.HRMISResignReasonTypeList(BaseSpTcmPLGet(), new ParameterSpTcmPL
                {
                });
                ViewData["SecondaryReasonTypeList"] = new SelectList(secondaryReasonTypeList, "DataValueField", "DataTextField", resignedEmployeeUpdateViewModel.SecondaryReason);

                IEnumerable<DataField> resignStatusList = await _selectTcmPLRepository.HRMISResignStatusList(BaseSpTcmPLGet(), new ParameterSpTcmPL
                {
                });
                ViewData["ResignStatusList"] = new SelectList(resignStatusList, "DataValueField", "DataTextField", resignedEmployeeUpdateViewModel.ResignStatusCode);

                IEnumerable<DataField> yesNoList = _selectTcmPLRepository.GetListOkKoYesNo();

                ViewData["YesNoList"] = new SelectList(yesNoList, "DataValueField", "DataTextField", resignedEmployeeUpdateViewModel.ExitInterviewComplete);

                IEnumerable<DataField> currResidentialLocation = await _selectTcmPLRepository.HRMISCurrResidentialLocation(BaseSpTcmPLGet(), new ParameterSpTcmPL
                {
                });
                ViewData["CurrResidentialLocationList"] = new SelectList(currResidentialLocation, "DataValueField", "DataTextField", resignedEmployeeUpdateViewModel.CurrentLocation);

                return PartialView("_ModalResignedEmployeeUpdatePartial", resignedEmployeeUpdateViewModel);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
        }
		

Jquery bind Data to lable from Ajax / Ddl_changed_event

    $("#Empno").change(function (e) {
                var selected = $('#Empno').find(':selected');
                //var vempno = selected[0].label;
                var vempno = selected[0].value;
                if(vempno  ==  null || vempno ==""){

                    $("#empDetails").hide();
                    $("#Doj").text("");
                    $("#Department").text("");
                    $("#Department").text("");
                    $("#Designation").text("");
                    $("#Grade").text("");
                    return;
                }



                $.ajax({
                    url: '@Url.Action("EmployeeInfo", "HRMIS", new {Area = "HRMasters" })',
                    data: {
                        empno: vempno
                    },
                    type: 'GET',
                    dataType: "json",
                    beforeSend: function () {
                        showLoader();
                    },
                    success: function (data) {

                        if(data.success){
                            //$("#formResignedEmployee select[id=Doj]").val(data.Doj);
                            //$("#formResignedEmployee select[id=Department]").val(data.Department);
                            $("#empDetails").show();
                            $("#Doj").text(data.doj);
                            $("#Department").text(data.department);
                            $("#Department").text(data.department);
                            $("#Designation").text(data.designation);
                            $("#Grade").text(data.grade);
                        }
                        else{
                            $("#empDetails").hide();
                            //notify("Error", data.response, "danger");
                        }



                        hideLoader();
                    },
                    error: function (result) {
                        hideLoader();
                        notify($.i18n('Error'), result.responseText, 'danger');
                    }
                });

            });


---------------------------------------------------------------------------------------------------------------------------------------------------------

genericLoadDataTable({ pDataTableId, pColumns, pUrl, pUrlParams, pRequestVerificationToken, PStateSave = true, pCallBackHeaderData, pPagination = true })
 function loadModuleUserRoleDataTable() {
            genericLoadDataTable({
                pDataTableId: "#tbGrid",
                pColumns: datatableColumns,
                pUrl: vModuleUserRoleList,
                pUrlParams: {
                    genericSearch: $('#GenericSearch').val() ? $('#GenericSearch').val() : null,
                    moduleId: $('#FilterDataModel_ModuleId').val() ? $('#FilterDataModel_ModuleId').val() : null,
                    roleId: $('#FilterDataModel_RoleId').val() ? $('#FilterDataModel_RoleId').val() : null,
                    empno: $('#FilterDataModel_Empno').val() ? $('#FilterDataModel_Empno').val() : null,
                },
                pRequestVerificationToken: $('input[name="__RequestVerificationToken"]').val(),
                PStateSave : false, // If not need to save PageState
				pPagination : false // If not need of save Pagination

            });
        };

---------------------------------------------------------------------------------------------------------------------------------------------------------
alert('Error :- SelectedDate is less than CurrentDate');
notify('success', 'data.response', 'Success');
notify('error', 'Error :- SelectedDate is less than CurrentDate', 'Error');
---------------------------------------------------------------------------------------------------------------------------------------------------------


			document.body.style.zoom = "80%";
            document.body.style.marginTop = "10px";
            document.body.style.marginLeft = "auto";
            document.body.style.marginRight = "auto";
			
---------------------------------------------------------------------------------------------------------------------------------------------------------

DDL change

   function BookingDateChage() {
       $('#BookingDate').change(function () {
           var selectedDate = $(this).val();
           var office = $('#DeskOffice').val();
           var desk = $('#Desk').val();
           var selectedShift = $('#Shift').val();
           var areaId = $('#DeskArea').val();

           var newdate = moment($("#BookingDate").val(), "YYYY-MM-DD HH:mm").format('YYYY-MM-DD HH:mm');

           if (selectedDate === '' || selectedDate == null) {

               $('#DeskOffice').empty();
               $('#Shift').empty();
               $('#DeskArea').empty();
               $('#Desk').empty();
               return;
           }

           if (selectedDate != '' || selectedDate != null) {

               $('#DeskOffice').empty();
               $('#Shift').empty();
               $('#DeskArea').empty();
               $('#Desk').empty();

               $.ajax({
                   url: "@Url.Action("GetOfficeList", "Bookings", new { Area = "DeskBooking" })",
                   type: 'GET',
                   data: {},
                   beforeSend: function () {
                       showModalLoader();
                   },
                   success: function (data) {
                       let dropdown = $('#DeskOffice');
                       dropdown.empty();
                       var options = '';
                       var flag = false;
                       var phase = null;
                       $(data).each(function () {

                           options += '<option value="' + this.dataValueField + '">' + this.dataTextField + '</option>';

                       });
                       dropdown.html(options);
                       if (flag == false) {
                           phase = null;
                       }

                       dropdown.val(phase);
                       hideModalLoader();
                   },
                   error: function (result) {
                       hideModalLoader();
                       notify($.i18n('Error'), result.responseText, 'danger');
                   }
               });
           }
           else {
               $('#Shift').empty();
               $('#DeskArea').empty();
               $('#Desk').empty();

               if ($("#BookingDate").val() == null || $("#BookingDate").val() == '' || $("#BookingDate").val() == 'null') {
                   return;

               }

               var newdate = moment($("#BookingDate").val(), "YYYY-MM-DD HH:mm").format('YYYY-MM-DD HH:mm');

               $.ajax({
                   url: "@Url.Action("GetDeskListForBooking", "Bookings", new { Area = "DeskBooking" })",
                   type: 'GET',
                   data: {
                       office: office,
                       selectedDate: newdate,
                       shift: selectedShift,
                       areaId: areaId,
                   },
                   beforeSend: function () {
                       showModalLoader();
                   },
                   success: function (data) {
                       let dropdown = $('#Desk');
                       dropdown.empty();
                       var options = '';
                       var optgroup = null;
                       var optgroupValStart = null;
                       var optgroupValEnd = null;
                       var flag = false;
                       var phase = null;
                       optgroupValStart = '';
                       optgroupValEnd = '';
                       options += '<option> </option>';
                       $(data).each(function () {

                           if (this.dataGroupField != null && this.dataGroupField != optgroup) {
                               optgroup = this.dataGroupField;
                               optgroupValStart = ' <optgroup label="' + this.dataGroupField + '" style="color: teal!important;font - size: 16px!important; " >';
                               options += optgroupValStart;
                           }
                           options += ' <option value="' + this.dataValueField + '">' + this.dataTextField + '</option>';
                           if (this.dataGroupField != null && this.dataGroupField != optgroup) {
                               optgroup = this.dataGroupField;
                               optgroupValEnd = ' </optgroup>';
                               options += optgroupValEnd;
                           }
                       });
                       dropdown.html(options);
                       if (flag == false) {
                           phase = null;
                       }
                       dropdown.val(phase);
                       hideModalLoader();
                   },
                   error: function (result) {
                       hideModalLoader();
                       notify($.i18n('Error'), result.responseText, 'danger');
                   }
               });
           }

       });
   }




[HttpGet]
public async Task<IActionResult> GetOfficeList()
{
	var bookingOfficeList = await _selectTcmPLRepository.DeskBookEmpOfficeList(BaseSpTcmPLGet(), new ParameterSpTcmPL());

	return Json(bookingOfficeList);
}


[HttpGet]
public async Task<IActionResult> GetDeskListForBooking(string office, DateTime? selectedDate, string shift)
{
 if (office == null || selectedDate == null || shift == null)
 {
	 return Json(null);
 }

 var deskList = await _selectTcmPLRepository.DeskBookAvailableDesks(BaseSpTcmPLGet(), new ParameterSpTcmPL
 {
	 POffice = office,
	 PDate = selectedDate,
	 PShift = shift
 });

 return Json(deskList);
}


---------------------------------------------------------------------------------------------------------------------------------------------------------
CR000267 
scope
	The scope of this document is to send mail text.


general functionality
	Mail body for resigned employees email content.
	
	
	
git clone --depth 1 --branch master https://github.com/PradeepMahor-Tecnimont/ServiceHub.git

Voluntary parents policy - hr config


 CR000316 - Notification of change employee cost code
 


Dear Nilesh Sir,
 

We have implemened the notification of change employee cost code.

Please confirm.

 
CR000182
CR000048
CR000059

{
    data: null,
    render: function (data, type, row) {

        if (vdata === "" || vdata == "null") {
            vdata = $.trim(data.dept);
            return vdata;
        }

        if ($.trim(data.dept) != $.trim(vdata)) {
            vdata = $.trim(data.dept);
            return vdata;
        }
        else {
            return '';
        }
        return vdata;
    }
},


  $('#tbProspectiveEmployees').dataTable({
      destroy: true,
      layout: {
          topStart: null,
          bottomStart: 'pageLength',
          bottomEnd: 'paging'
      },
      'columnDefs': [
          { orderable: false, targets: 0 }
      ],
      order: [[1, "asc"]],
      sort: false,
      responsive: true,
      autoWidth: false,
      pageLength: 25,
      lengthMenu: [25, 50, 100, 200],
      processing: true,
      serverSide: true,
      stateSave: true,
      info: false,
      filter: false,
      paginate: true,
      lengthChange: true
  });

"cellAttributes" : {"class":{"fieldName": fieldName + "-css" }}

 rowsGroup: [0, 1, 2, 3],
 
  rowsGroup: [0]
  
  ,
        rowsGroup: [2, 0]
---------------------------------------------------------------------------------------------------------------------------------------------------------


 <a title="New Contract" class="btn btn-outline-primary btn-sm border border-white" href="#" id="newContract"
 
  function PostSave(data) {
            if (data.success) {
                //$("#modalcontainer").modal('hide');
                document.querySelector("#newContract").click();
                hideLoader();
                loadDataTable();
                notify('success', data.response, 'Success');
            }
        }
----------------------------------------------------------

----------------------------------------------------------
Retun Error Type
	- throw new Exception(result.Data.Value.Replace("-", " "));
	- Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
	- return Json(new { success = result.Status == Success, response = result.Data.Value + result.Message });
	- 
	
	- return StatusCode((int)HttpStatusCode.InternalServerError, result.Message.Replace("-", " "));
	- return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
	- Notify(result.PMessageType == IsOk ? "Success" : "Error", 
			StringHelper.CleanExceptionMessage(result.PMessageText), "", 
			result.PMessageType == IsOk ? NotificationType.success : NotificationType.error);
	
	- return result.PMessageType != IsOk
                       ? throw new Exception(result.PMessageText.Replace("-", " "))
                       : (IActionResult)Json(new { success = true, response = result.PMessageText });
					   
	message
	
----(*) OnPage Notification Msg (*)---- 
	
	> postMethod data-ajax-complete="initToastrMessage();"	
	and in page add below line of code
	
	<div id="results" style="display:none">@TempData["Message"]</div>
	
---------------------------------------------------------------------------------------------------------------------	
For Json result 

try{
	r Json(ResponseHelper.GetMessageObject("Msg",file))
}
 catch (Exception ex)
{
	throw new CustomJsonException(ex.Message, ex);
}
#region Examples
//throw new CustomJsonException();
//throw new CustomJsonException(message);
//throw new CustomJsonException("Exception with parameter value '{0}'", param);
//throw new CustomJsonException(message, innerException);
//throw new CustomJsonException("Exception with parameter value '{0}'", innerException, param); // param always floating
#endregion

---------------------------------------------------------------------------------------------------------------------	

<th>@Html.DisplayNameFor(model => model.Empno)</th>


<th>@localizer["Aadhaar scan file not uploaded"]@Html.DisplayNameFor(model => model.Empno)</th>
---------------------------------------------------------------------------------------------------------------------	
For De-Activate VPP [ Delete record ]

 

Select
    module_id, role_id, action_id, module_role_action_key_id, module_role_key_id
From
    sec_module_role_actions
    where action_id='F001';

----------------------------------------------------------------------------------------

M11    R045    F001    M11R045F001    M11R045

---------------------------------------------------------------------------------------------------------------------	

For large page 
<div class="row p-2 m-2">
    <div class="container-fluid bg-white border rounded shadow m-auto col-xl-12 p-2 ">
	</div>
</div>

---------------------------------------------------------------------------------------------------------------------	
@Html.TextBoxFor(model => model.FilterDataModel.StartDate, "{0:dd-MMM-yyyy}", htmlAttributes: new { @type = "hidden" })

<input type="hidden" asp-for="@Model.ProposedDoj" />

<div class="form-group">
	<label asp-for="ProposedDoj" class="control-label"></label>
	<input id="proposedDoj" class="form-control datepicker" value="@Model.ProposedDoj@.ToString("dd/MMM/yyyy")" required />
	<span asp-validation-for="ProposedDoj" class="text-danger"></span>
</div>
									
---------------------------------------------------------------------------------------------------------------------	
costom static Dll List

 public List<DataField> GetListLcDurationType()
        {
            var list = new List<DataField>();
            list.Add(new DataField { DataTextField = "", DataValueField = "" });
            list.Add(new DataField { DataTextField = "Usance Period(U)​", DataValueField = "1" });
            list.Add(new DataField { DataTextField = "LC Tenure(T)​", DataValueField = "2" });

            return list;
        }
---------------------------------------------------------------------------------------------------------------------	

var costCodeList = await _selectTcmPLRepository.CostCodeListAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());
ViewData["CostCodeList"] = new SelectList(costCodeList, "DataValueField", "DataTextField");

<div class="row">
	<div class="col-xl-12 col-md-12">
		<div class="form-group">
			<label asp-for="CostCode" class="control-label"></label>
			<select asp-for="CostCode" asp-items="ViewBag.CostCodeList" 
					class="form-control Select2"  data-placeholder="Please select..." required>
				<option selected></option>
			</select>
			<span asp-validation-for="CostCode" class="text-danger"></span>
		</div>
	</div>
</div>

---------------------------------------------------------------------------------------------------------------------	

Auth Or Role or Action Base DataTable -  Add/Update 
Reff - ResignedEmployeeIndex file

---------------------------------------------------------------------------------------------------------------------	
(LocalDB)\MSSQLLocalDB
sa
LocalDbAdmin
LocalDbAdmin@1
---------------------------------------------------------------------------------------------------------------------	
<span id="spnIdHasScanFile" class="alert alert-danger
                    @(string.IsNullOrEmpty(Model.HasScanFileAadhaar) ? "" : "hidden")
                    @(Model.HasAadhaar == IsOk ? "" : "hidden")"
              style="text-align: left;">
            @localizer["Aadhaar scan file not uploaded"]

        </span>


---------------------------------------------------------------------------------------------------------------------	
  <div class="form-group">
             <div class="row">
                <div class="col-md-12">
                    <div class="dt-met">@Html.DisplayNameFor(model => model.InvTransactionDetails.PRemarks)</div>
                    <div class="dd-met">
                        @if (Model.InvTransactionDetails.PRemarks != null)
                            @Html.Raw(System.Web.HttpUtility.HtmlEncode(Model.InvTransactionDetails.PRemarks).Replace("\n", "<br/>"))
                    </div>
                </div>
            </div>
        </div>

---------------------------------------------------------------------------------------------------------------------	
Details Page by Form Post usinf Ajax

<form asp-controller="EmpGenInfoDetails"
      asp-action="OnBeHalfGenInfoDetails"
      id="formOnBeHalfGenInfoDetails">

    <input type="hidden" asp-for="Empno" />
    <input type="hidden" asp-for="Parent" />
</form>



{
	data: null,
	render: function (data, type, row) {
		var tempEmp = "'" + data.empno + "'";
		return '<a class="btn btn-sm-icon" href="#" onclick="GotoDetails(' + tempEmp + ')" title="Detail"><i class="far fa-eye"></i></a>';
	},
	className: "td-icon",
}

 function GotoDetails(empno) {
	$('#Empno').val(empno);
	var frm = $('#formOnBeHalfGenInfoDetails');
	frm.submit();
}
		


---------------------------------------------------------------------------------------------------------------------	
Microsoft.Web.LibraryManager.Build
---------------------------------------------------------------------------------------------------------------------	
File Download ByAjaxPost


{
	data: null,
	render: function (data, type, row) {
		var tempEmp = "'" + data.empno + "'";
		var tempFileType = "'" + "AC" + "'";
		var tempLink = '';
		if (data.isAdhaarLock == "1") {
			tempLink = "Open";
		}
		else {
			tempLink = "Locked";
		}
		if (data.aadhaarExists == "1") {
			tempLink = tempLink + '<a class="btn btn-outline-primary btn-sm  border-none" style="float:right" href="#" onclick="downloadScanFile(' + tempFileType + ',' + tempEmp + ')"    title="Download Aadhaar form"><i class="fas fa-download"></i></a>';
		}
		return tempLink;
	}
},

  function downloadScanFile(pFileType, pEmpno) {


            if (pFileType == null || pFileType == '') {
                toastr.error('Invalid fileType ');
                return;
            }
            if (pEmpno == null || pEmpno == '') {
                toastr.error('Invalid empno');
                return;
            }


            $.ajax({
                headers: { "RequestVerificationToken": $('input[name="__RequestVerificationToken"]').val() },
                url: '@Url.Action("DownloadScanFile", "EmpGenInfoDetails", new {Area = "EmpGenInfo" })',
                type: "POST",
                data: {
                    fileType: pFileType,
                    empno: pEmpno
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
                },
                error: function (xhr) {
                    showError(xhr);
                    hideLoader();
                }
            });
        }
		
		
 [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateOnBehalf)]
        public async Task<IActionResult> DownloadScanFile(string fileType, string empno)
        {
            try
            {
                if (fileType == null || empno == null)
                {
                    throw new Exception("Invalid request");
                }

                if (empno == null)
                {
                    return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage("employee no not found"));
                }

                var employeeDetail = await _empPrimaryDetailsRepository.HREmpPrimaryDetailsAsync(
                             BaseSpTcmPLGet(),
                             new ParameterSpTcmPL { PEmpno = empno });

                var scanFileDetail = await _empScanFileDetailsRepository.HREmpScanFileDetailsAsync(
                           BaseSpTcmPLGet(),
                           new ParameterSpTcmPL
                           {
                               PEmpno = empno,
                               PFileType = fileType
                           });

                byte[] bytes = null;

                switch (fileType.Trim())
                {
                    case ConstFileTypePassport:
                        bytes = StorageHelper.DownloadFile(StorageHelper.EmpGenInfo.RepositoryEmpGenInfo, FileName: scanFileDetail.PFileName, Configuration);
                        break;

                    case ConstFileTypeAadhaarCard:
                        bytes = StorageHelper.DownloadFile(StorageHelper.EmpGenInfo.RepositoryEmpGenInfo, FileName: scanFileDetail.PFileName, Configuration);
                        break;

                    case ConstFileTypeGTLI:
                        bytes = StorageHelper.DownloadFile(StorageHelper.EmpGenInfo.RepositoryEmpGenInfo, FileName: scanFileDetail.PFileName, Configuration);
                        break;

                    case ConstFileTypeNO:
                        return RedirectToAction("DownloadNomination", "Report", new { id = empno });

                    default:
                        throw new Exception("InValid request");
                }

                return File(bytes, "application/octet-stream", scanFileDetail.PFileName);
            }
            catch (FileNotFoundException fEx)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, "Exception  - File not found..!");
            }
            catch (ArgumentNullException fEx)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, "Exception  - File not found..!");
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
        }
		
---------------------------------------------------------------------------------------------------------------------	
<div class="checkbox checkboxlist">
	<label asp-for="MaritalStatus" class="control-label"></label><br />

	<div class=" form-group d-inline radio ">
		<input type="radio" asp-for="MaritalStatus" name="MaritalStatus" id="Married" value="Married">
		<label for="Married" class="cr margin-top-5">Married</label>
	</div>
	<div class=" form-group d-inline radio ">
		<input type="radio" asp-for="MaritalStatus" name="MaritalStatus" id="UnMarried" value="UnMarried">
		<label for="UnMarried" class="cr margin-top-5">UnMarried</label>
	</div>
	<div class=" form-group d-inline radio ">
		<input type="radio" asp-for="MaritalStatus" name="MaritalStatus" id="Widow" value="Widow">
		<label for="Widow" class="cr margin-top-5">Widow</label>
	</div>
	<div class=" form-group d-inline radio ">
		<input type="radio" asp-for="MaritalStatus" name="MaritalStatus" id="Widower" value="Widower">
		<label for="Widower" class="cr margin-top-5">Widower</label>
	</div>

	<span asp-validation-for="MaritalStatus" class="text-danger"></span>
</div>
---------------------------------------------------------------------------------------------------------------------	
 <div class="checkbox">

            <div class="checkboxlabel">
                <input type="checkbox" class="checkBox-Blue" id="LockedAll" name="" value="">
                <label for="LockedAll">
                    <span>Select All </span>
                </label>
            </div>

            <div class="checkboxlabel">
                <input type="checkbox" class="locked checkBox-Blue" asp-for="LockPrimary" value="1" />
                <label for="LockPrimary">
                    <span>Lock Primary </span>
                </label>
            </div>
            <div class="checkboxlabel">
                <input type="checkbox" class="locked checkBox-Blue" asp-for="LockNomination" value="1" />
                <label for="LockNomination">
                    <span>Lock Nomination </span>
                </label>
            </div>
            <div class="checkboxlabel">
                <input type="checkbox" class="locked checkBox-Blue" asp-for="LockMediclaim" value="1" />
                <label for="LockMediclaim">
                    <span>Lock Mediclaim </span>
                </label>
            </div>
            <div class="checkboxlabel">
                <input type="checkbox" class="locked checkBox-Blue" asp-for="LockAdhaar" value="1" />
                <label for="LockAdhaar">
                    <span>Lock Adhaar </span>
                </label>
            </div>
            <div class="checkboxlabel">
                <input type="checkbox" class="locked checkBox-Blue" asp-for="LockPassport" value="1" />
                <label for="LockPassport">
                    <span>Lock Passport</span>
                </label>
            </div>
            <div class="checkboxlabel">
                <input type="checkbox" class="locked checkBox-Blue" asp-for="LockGTLI" value="1" />
                <label for="LockGTLI"><span>Lock GTLI</span></label>
            </div>
            
        </div>
---------------------------------------------------------------------------------------------------------------------	
 private string _isLaptopUser;  
  public string IsLaptopUser
        {
            get { return _isLaptopUser.StartsWith("1") ? "Yes" : "No"; }
            set { _isLaptopUser = value; }

        }
		
<i class="fas fa-file-pdf green-color"></i>&nbsp;
 
----------------------------------------------------------------------------------------------------------------------------

	   EmployeeDetails employeeDetails = new();
	   
	   
	    employeeDetails = await _commonEmployeeDetailsRepository.EmployeeDetailAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL { PEmpno = result.PEmpNo });
 if (employeeDetails != null)
 {
     approvalDetailsViewModel.Grade = employeeDetails.PGrade;
     approvalDetailsViewModel.CurrentDesignation = employeeDetails.PDesgCode + " - " + employeeDetails.PDesgName;
     approvalDetailsViewModel.CurrentJobTitle = employeeDetails.PJobTitle;
 }
 
 
	CostcodeChangeRequestDetailsViewModel
----------------------------------------------------------------------------------------------------------------------------
Two new function created in DB,
ok -> return string 
'OK'not_ok -> return 'KO'
It shall work from any schema.
Try following statement in any schemaSelect ok, not_ok from dual;
Start usingok instead of 'OK'not_ok instead of 'KO'in 
stored procedures/packages/functions etc....
----------------------------------------------------------------------------------------------------------------------------

 public class CustomContractResolver : DefaultContractResolver
    {
        private Dictionary<string, string> PropertyMappings { get; set; }

        public CustomContractResolver()
        {
            this.PropertyMappings = new Dictionary<string, string>
        {
            {"Barcode", "BarCode"},
            {"Ponum", "PP Number"},
            {"Podate", "PO Date"},
            {"Grnum", "GR Number"},
            {"SapAssetcode", "Sap Asset Code"},
            {"Serialnum", "Serial Number"},
            {"Model", "Asset Model"},
            {"Compname", "Company Name"},
            {"Scrap", "Scrap"},
            {"SubAssetType", "Sub Asset Type"},
            {"LotDesc", "Lot Description"},
            {"AsgmtType", "Assignment Type"},
            {"AssignedTo", "Assigned To"},
            {"NameOffice", "Office"},
            {"ParentFloor", "Parent / Floor"},
            {"AssignWing", "Assign / Wing"},
            {"GradeCabin", "Grade / Cabin"},
            {"EmptypeWorkarea", "Employee type / WorkArea"},
            {"EmpstatusDeskisblocked", "Employee status / Desk is blocked"}
        };
        }

        protected override string ResolvePropertyName(string propertyName)
        {
            string resolvedName = null;
            var resolved = this.PropertyMappings.TryGetValue(propertyName, out resolvedName);
            return (resolved) ? resolvedName : base.ResolvePropertyName(propertyName);
        }
    }
	
	
	   if (data == null) { return NotFound(); }

                var settings = new JsonSerializerSettings();
                settings.DateFormatString = "dd-MMM-yyyy";
                settings.Formatting = (Formatting)1;
                settings.ContractResolver = new CustomContractResolver();
                var json = JsonConvert.SerializeObject(data, settings);

                DataTable dt = new DataTable();

                IEnumerable<AssetDistributionForXlDataTableList> excelData = JsonConvert.DeserializeObject<IEnumerable<AssetDistributionForXlDataTableList>>(json, settings);

                var jsonLinq = JArray.Parse(JsonConvert.SerializeObject(excelData, settings));
                dt = JsonConvert.DeserializeObject<DataTable>(jsonLinq.ToString());

                var byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(dt.AsEnumerable(), "Asset Distribution", "Data");
				
----------------------------------------------------------------------------------------------------------------------------


[Display(AutoGenerateField = false, Description = "This column isn't created")]
[Display(ShortName = "Company", Name = "Company Name")]
[DataNames("first_name", "firstName")]
//Changes the Header Text of 'Attribute' Column.
this.gridDataBoundGrid1.Binder.InternalColumns["Attribute"].HeaderText = "NewHeaderText";



 return Json(new { success = result.PMessageType == "OK", response = result.PMessageType, message = result.PMessageText });
 ----------------------------------------------------------------------------------------------------------------------------------------------------------------------



Text Upper

 <div class="form-group">
                            <label asp-for="ShortDescription" class="control-label"></label>
                            <input asp-for="ShortDescription" class="form-control  text-uppercase " onkeypress="return AvoidSpace(event)" required />
                            <span asp-validation-for="ShortDescription" class="text-danger"></span>
                        </div>


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

[HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsModules(string paramJson)
        public async Task<JsonResult> GetListsModules(string paramJson)
        {
            DTResult<ModulesDataTableList> result = new();
            int totalRow = 0;

            try
            {
                var param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

                System.Collections.Generic.IEnumerable<ModulesDataTableList> data = await _modulesDataTableListRepository.ModulesDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch ?? " ",
                        PRowNumber = param.Start,
                        PPageLength = param.Length
                    }
                );

                if (data.Any())
                {
                    totalRow = (int)data.FirstOrDefault().TotalRow.Value;
                }

                result.draw = param.Draw;
                result.recordsTotal = totalRow;
                result.recordsFiltered = totalRow;
                result.data = data.ToList();

                return Json(result);
            }
            catch (Exception ex)
            {
                return Json(new { error = ex.Message });
            }
        }
----------------------------------------------------------------------------		
private readonly ICommonEmployeeDetailsRepository _commonEmployeeDetailsRepository;
ICommonEmployeeDetailsRepository commonEmployeeDetailsRepository,
_commonEmployeeDetailsRepository = commonEmployeeDetailsRepository;
var employeeDetails = await _commonEmployeeDetailsRepository.EmployeeDetailAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL { PEmpno = empno });

----------------------------------------------------------------------------		
    $(document).ready(function () {
            loadModuleDataTable();
        });

        function localScript() {
            initSelect2();
        };

        let vUrlModulesList = "@Url.Action("GetListsModules", "UserAccess")";

        function loadModuleDataTable() {
            genericLoadDataTable({
                pDataTableId: "#tbGrid",
                pColumns: datatableColumns,
                pUrl: vUrlModulesList,
                pUrlParams: {
                    genericSearch: $('#GenericSearch').val() ? $('#GenericSearch').val() : null
                },
                pRequestVerificationToken: $('input[name="__RequestVerificationToken"]').val()

            });
        };


    @if ((bool)@Context.Items["isMobile"] == false)
    {
        <text>

            let datatableColumns = [
                            { data: "moduleId" },
                            { data: "moduleName" },
                            { data: "moduleLongDesc" },
                            { data: "moduleIsActive" },
                            { data: "moduleSchemaName" },
                            { data: "funcToCheckUserAccess" },
                            { data: "moduleShortDesc" },
                            {
                                data: null,
                                render: function (data, type, row) {
                                    if (data.deleteAllowed == 0) {
                                        return '<button title="Delete" class="btn btn-outline-danger btn-sm border-none " ' +
                                            ' onclick = "showDeleteConfirmationPopup(event,this);" ' +
                                            ' data-jqueryselector = "showconfirmationmodal" ' +
                                            ' data-url="@Url.Action("ModulesDelete", "UserAccess", new { Area = "CoreSettings" })"' +
                                            ' data-id="' + data.moduleId + '"' +
                                            ' data-PostDeleteReLoadDataTables="OK" ' +
											' data-confirmationtext="Do you want to delete Module (' + data.moduleName + ' - ' + data.moduleLongDesc + ') ?" ' +
                                            ' data-modaltitle="Please Confirm!" ' +
                                            ' data-confirmationtype="warning" ' +
                                            ' title="Delete Module" ' +
                                            ' data-confirmbuttontext="Delete Module" > ' +
                                            ' <i class="fas fa-trash" aria-hidden="true"></i> ' +
                                            ' </button>';
                                    } else
                                    {
                                        return '';
                                    }
                                },
                                'className': "td-icon text-center  align-middle",
                            }
            ];


        </text>
    };


        $("#GenericSearch").keypress(function(event) {
            if (event.keyCode === 13) {
                if ($("#GenericSearch").length) {
                        loadModuleDataTable();
                }
            }
         });

         $('#buttonSearch').on('click', function () {

            if ($("#GenericSearch").length) {
               loadModuleDataTable();
            }
        });

        function PostSave(data) {
            if (data.success) {
                $("#modalcontainer").modal('hide');
                hideLoader();
                loadModuleDataTable();
                notify('success', data.response, 'Success');
            }
        };
		
		function PostDeleteReLoadDataTables(data) {
            if (data.success) {
                loadDataTable();
                hideLoader();
               notify('success', data.message, 'Success');
            }
        };
		
		
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------		
 if (string.IsNullOrEmpty(moduleId) || string.IsNullOrEmpty(onBehalfEmpno) || string.IsNullOrEmpty(principalEmpno))
                {
                    return Json(new { success = false, response = NotOk, message = "Error : Invalid request - missing important values" });
                }
				
	  function PostDeleteReLoadDataTables(data) {
          
            if (data.response == @NotOk) {
                notify('Error', data.message, 'Error');
                return;
            }
            if (data.success) {
                loadDelegateDataTable();
                hideLoader();
                notify('success', data.message, 'Success');
            }
        };
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
GetList - headerData

For Reff - GetListEmployeePrimaryWorkSpacePlanning

(meta.settings.json.headerData.pPwsOpen

  public async Task<JsonResult> GetListEmployeePrimaryWorkSpacePlanning(DTParameters param)
        {
            var swpPlanningStatus = await _swpPlanningStatusRepository.GetPlanningWeekDetails(BaseSpTcmPLGet(), null);

            if (swpPlanningStatus.PPlanningExists != "OK")
            {
                return Json(new { error = "Planning for next week not yet rolled over." });
            }

            //DTResult<SmartWorkSpaceDataTableList> result = new DTResult<SmartWorkSpaceDataTableList>();

            DTResultExtension<PrimaryWorkSpaceDataTableList, WeekPlanningStatusOutPut> result = new DTResultExtension<PrimaryWorkSpaceDataTableList, WeekPlanningStatusOutPut>();

            //DTResult<PrimaryWorkSpaceDataTableList> result = new DTResult<PrimaryWorkSpaceDataTableList>();
            int totalRow = 0;

            try
            {
                var data = await _primaryWorkSpaceDataTableListRepository.PrimaryWorkSpacePlanningDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
                        //PEmpno = param.Empno,
                        PAssignCode = param.Assign,
                        PEmptypeCsv = param.EmployeeType,
                        PPrimaryWorkspaceCsv = param.PrimaryWorkspace,
                        PGradeCsv = param.Grade,
                        PLaptopUser = param.LaptopUser,
                        PEligibleForSwp = param.EligibleForSWP,
                        PGenericSearch = param.GenericSearch
                    }
                );

                if (data.Any())
                {
                    totalRow = (int)data.FirstOrDefault().TotalRow.Value;
                }

                result.draw = param.Draw;
                result.recordsTotal = totalRow;
                result.recordsFiltered = totalRow;
                result.data = data.ToList();
                result.headerData = swpPlanningStatus;

                return Json(result);
            }
            catch (Exception ex)
            {
                return Json(new { error = ex.Message });
            }
        }

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

File download with loading ajax from Tile

 <div class="col-md-3 col-xl-3">
                    <div class="card card-tpl">
                        <div class="card-header">
                            <h5>Employee Nominee Details - Report</h5>
                        </div>
                        <div class="card-block card-tile">
                            <a id="lEmployeeNomineeDetails" href="#"
                               data-inprogress="0"
                               data-jqueryselector="generatereport"
                               data-url="@Url.Action("EmployeeNomineeDetailsExcel", "Report", new {Area ="EmpGenInfo"})">
                                <div class="row align-items-center justify-content-center stretched-link">
                                    <div class="col">
                                        <h7 id="lEmployeeNomineeDetails_Text" class="mb-2 f-w-300">

                                        </h7>
                                        <div class="text-center">
                                            <div id="lEmployeeNomineeDetails_Loader" class="spinner-border text-info text-center hidden "
                                                 style="width: 2.5rem; height: 2.5rem;" role="status">
                                                <span class="sr-only">Loading...</span>
                                            </div>
                                        </div>
                                        &#160;
                                    </div>
                                    <div id="lEmployeeNomineeDetails_Icon" class="col-auto">
                                        <i class="fas fa-cogs f-20 text-white theme-dark-green"></i>
                                    </div>
                                </div>
                            </a>
                        </div>
                    </div>
                </div>
				
<script src="~/js/site-rap.js" asp-append-version="true"></script>
				
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

File With Filer Popup download from Tile
 
 <div class="col-md-3 col-xl-3">
                    <div class="card card-tpl">
                        <div class="card-header">
                            <h5>Employee Mediclaim Details - Report</h5>
                        </div>
                        <div class="card-block card-tile">
                            <a href="#"
                               data-jqueryselector="openmodal"
                               data-modalcontainer="modalcontainer"
                               data-modalpopupwidth="rightw35"
                               data-url='@Url.Action("EmployeeMediclaimDetailsExcel", "Report", new { Area = "EmpGenInfo" })'>
                                <div class="row align-items-center justify-content-center stretched-link">
                                    <div class="col">
                                        <h3 class="mb-2 f-w-300"> </h3>
                                    </div>
                                    <div class="col-auto">
                                        <i class="fas fa-cogs f-20 text-white theme-dark-green"></i>
                                    </div>
                                </div>
                            </a>
                        </div>
                    </div>
                </div>				

 <script src="~/js/site-rap.js" asp-append-version="true"></script>

 function localScript() {
          

            $('#btnExportMediclaimStatusExcel').off('click').on('click', function () {
                event.preventDefault();
                event.stopPropagation();
                exportMediclaimStatusExcel();
            });

        }
 
 
  function exportMediclaimStatusExcel() {

            let vStartDate = $("#formEmployeeMediclaimDetailsExcel input[id=StartDate]").val();
            let vEndDate = $("#formEmployeeMediclaimDetailsExcel input[id=EndDate]").val();

            if (vStartDate == null || vStartDate == '') {
                toastr.error('Invalid Start Date ');
                return;
            }
            if (vEndDate == null || vEndDate == '') {
                toastr.error('Invalid End Date');
                return;
            }


            $.ajax({
                headers: { "RequestVerificationToken": $('#EmployeeMediclaimDetailsExcel input[name="__RequestVerificationToken"]').val() },
                url: '@Url.Action("EmployeeMediclaimDetailsExcel", "Report", new {Area = "EmpGenInfo" })',
                type: "POST",
                data: {
                    startDate: vStartDate,
                    endDate: vEndDate
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
                    $("#btnExportMediclaimStatusExcel").hide();
                    $('#MediclaimStatus_Loader').removeClass("hidden");
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

                    $("#btnExportMediclaimStatusExcel").show();
                    $('#MediclaimStatus_Loader').addClass("hidden");
                },
                error: function (xhr) {
                    showError(xhr);
                    hideLoader();
                    $("#btnExportMediclaimStatusExcel").show();
                    $('#MediclaimStatus_Loader').addClass("hidden");
                }
            });
        }
 
 
 [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateOnBehalf)]
        public async Task<IActionResult> EmployeeMediclaimDetailsExcel()
        {
            var retVal = await RetriveFilter(ConstFilterNominationStatusIndex);

            FilterDataModel filterDataModel = new FilterDataModel();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            var parentList = await _selectTcmPLRepository.CostCodeListAsync(BaseSpTcmPLGet(), null);

            ViewData["ParentList"] = new SelectList(parentList, "DataValueField", "DataTextField");

            return PartialView("_ModalMediclaimFilterSet", filterDataModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateOnBehalf)]
        public async Task<IActionResult> EmployeeMediclaimDetailsExcel(DateTime startDate, DateTime endDate)
        {
            try
            {

                if (startDate > endDate)
                    throw new Exception("End date should be greater than start date");
                var timeStamp = DateTime.Now.ToFileTime();

                string fileName = "Employee Mediclaim Details_" + timeStamp.ToString();
                string reportTitle = "Employee Mediclaim Details " + startDate.ToString("dd-MMM-yyyy") + " To " + endDate.ToString("dd-MMM-yyyy");
                string sheetName = "Employee Family Details";

                IEnumerable<HREmpMediclaimDataTableList> data = await _hREmpMediclaimDataTableListRepository.HREmpMediclaimDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PStartDate = startDate,
                        PEndDate = endDate,
                    });

                if (data == null) { return NotFound(); }

                var json = JsonConvert.SerializeObject(data);

                IEnumerable<HREmpMediclaimDetailsDataTableExcel> excelData = JsonConvert.DeserializeObject<IEnumerable<HREmpMediclaimDetailsDataTableExcel>>(json);

                byte[] byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, reportTitle, sheetName);

                return File(byteContent,
                            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                            fileName + ".xlsx");
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }
 
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------
  private void btnPost_Click(object sender, EventArgs e)
        {
            string val = txtEmployees.Text;
            string returnVal = StringManipulation(val);
            if (returnVal.Length > 0)
            {
                MessageBox.Show(returnVal);
            }
        }

        public string StringManipulation(string returnVal)
        {
            if (string.IsNullOrEmpty(returnVal))
            {
                MessageBox.Show("Error :- No input found  - Value Count " + returnVal.Length);
                return returnVal;
            }

            // Remove all WhiteSpace and ',' char from the 'returnVal' string variable
            returnVal = String.Concat(returnVal.Where(c => !Char.IsWhiteSpace(c) && c != ','));

            // Remove all newlines from the 'returnVal' string variable
            returnVal = returnVal.Replace("\n", "").Replace("\r", "");

            // Remove all Spacial char from the 'returnVal' string variable
            returnVal = Regex.Replace(returnVal, "[^0-9A-Za-z]", "");

            if (returnVal.Length > 0)
            {
                int val = returnVal.Length % 5;

                if (val != 0)
                {
                    MessageBox.Show("Invalid Employee no. count : " + val);
                }
                else
                {
                    returnVal = InsertCharAtDividedPosition(returnVal, 5, ",");
                }
            }

            return returnVal;
        }

        public string InsertCharAtDividedPosition(string str, int count, string character)
        {
            var i = 0;
            while (++i * count + (i - 1) < str.Length)
            {
                str = str.Insert((i * count + (i - 1)), character);
            }
            return str;
        }
---------------------------------------------------------------------------------------------------------------------		
https://dms.licdn.com/playlist/vid/C560DAQGro_V4Pj6zbA/learning-original-video-vbr-720/0/1599080155784?e=1687327639&v=beta&t=Wn5j1i_iUsBEx4uyFrWHoOLfz57cuJ9tduma2hLXnfg
---------------------------------------------------------------------------------------------------------------------		
---------------------------------------------------------------------------------------------------------------------		

alter session set "_ORACLE_SCRIPT"=true;  
https://excelchamps.com/vba/new-line/

System_AdminSys@1

Sub Range_Examples()

  Dim Rng As Range

  Set Rng = Range("K1:K21945")

  Rng.Value = Range("I1:I21945", "L1:L21945").Value
 
End Sub


CREATE USER Pradeep 
IDENTIFIED BY PradeepMahor1 
DEFAULT TABLESPACE tbs_perm_01 
TEMPORARY TABLESPACE tbs_temp_01 
QUOTA 20M on tbs_perm_01;

--GRANT ALL PRIVILEGES TO super;

GRANT create session TO Pradeep;  
GRANT CONNECT, RESOURCE, DBA TO Pradeep;
GRANT create table TO Pradeep;
GRANT create view TO Pradeep;
GRANT create any trigger TO Pradeep;
GRANT create any procedure TO Pradeep;
GRANT create sequence TO Pradeep;
GRANT create synonym TO Pradeep;

GRANT UNLIMITED TABLESPACE TO Pradeep;

/*
GRANT
  SELECT,
  INSERT,
  UPDATE,
  DELETE
ON
  schema.books
TO
  Pradeep;

*/
Disable the feature

Run the following command at an elevated command prompt to disable Internet Explorer 11: 
	dism /online /Remove-Capability /CapabilityName:Browser.InternetExplorer~~~~0.0.11.0
	
Run the following command at an elevated command prompt to re-enable Internet Explorer 11: 
	dism /online /Add-Capability /CapabilityName:Browser.InternetExplorer~~~~0.0.11.0

dism /online /Add-Capability /CapabilityName:Browser.InternetExplorer~~~~0.0.11.0



CREATE USER Rutuja
  IDENTIFIED BY RutujaG#1
  DEFAULT TABLESPACE tbs_perm_01
  TEMPORARY TABLESPACE tbs_temp_01
  QUOTA 20M on tbs_perm_01;
 
--GRANT ALL PRIVILEGES TO super;
 
GRANT create session TO Rutuja;  
GRANT CONNECT, RESOURCE, DBA TO Rutuja;
GRANT create table TO Rutuja;
GRANT create view TO Rutuja;
GRANT create any trigger TO Rutuja;
GRANT create any procedure TO Rutuja;
GRANT create sequence TO Rutuja;
GRANT create synonym TO Rutuja;
 
GRANT UNLIMITED TABLESPACE TO Rutuja;

---------------------------------------------------------------------------------------------------------------------		
---------------------------------------------------------------------------------------------------------------------		
---------------------------------------------------------------------------------------------------------------------		
to_char(a.nom_dob, 'DD-Mon-YYYY')
---------------------------------------------------------------------------------------------------------------------
Paswd : AdminSys@1
diirikbi
cccccbcbnctiddter

AdminSys@1

---------------------------------------------------------------------------------------------------------------------
 P_PERSON_ID := '01010936';
  P_META_ID := '46B8876C62E81974DACD';
  P_GENERIC_SEARCH := NULL;
  P_GRADE := NULL;
  P_PARENT := NULL;
  P_ROW_NUMBER := 0;
  P_PAGE_LENGTH := 9000000;
  
---------------------------------------------------------------------------------------------------------------------
  If (Sql%rowcount > 0) Then

            Insert Into dm_usermaster (empno, deskid, costcode, dep_flag)
            Values (v_guest_empno, p_guest_target_desk, p_guest_costcode, 0);

            p_message_type := ok;
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := not_ok;
            p_message_text := 'Error - Procedure not executed..';
        End If;
---------------------------------------------------------------------------------------------------------------------		
Grant select On tcmpl_app_config.sec_module_user_roles_costcode To "TCMPL_HR";
---------------------------------------------------------------------------------------------------------------------		

(
	upper(a.gnum) Like '%' || upper(Trim(p_generic_search)) || '%' Or
	upper(a.targetdesk) Like '%' || upper(Trim(p_generic_search)) || '%' Or
	upper(a.gname) Like '%' || upper(Trim(p_generic_search)) || '%'
)
And gcostcode    = nvl(p_costcode, a.gcostcode)
						
---------------------------------------------------------------------------------------------------------------------


With
    desk_areas As (
        Select
            b.area_key_id,
            c.description As work_area_categories,
            b.area_desc   As work_area_desc
        From
            dm_desk_areas           b,
            dm_desk_area_categories c
        Where
            c.area_catg_code = b.area_catg_code
    )
Select
    a.office               As office,
    a.floor                As floor,
    a.seatno               As seat_no,
    a.wing                 As wing,
    a.assetcode            As asset_code,
    a.isdeleted            As is_deleted,
    a.cabin                As cabin,
    a.remarks              As remarks,
    a.deskid_old           As deskid_old,
    a.work_area            As work_area_code,
    b.work_area_categories As work_area_categories,
    b.work_area_desc       As work_area_desc,
    a.bay                  As bay,
    a.isblocked            As is_blocked
From
    dm_deskmaster a,
    desk_areas    b
Where
    a.deskid        = :p_desk_id
    And a.work_area = b.area_key_id(+);
		
---------------------------------------------------------------------------------------------------------------------	
  Procedure import_movemast_costcode(
        p_person_id           Varchar2,
        p_meta_id             Varchar2,

        p_costcode            Varchar2,
        p_movemast_json       Blob,
        p_movemast_errors Out Sys_Refcursor,

        p_message_type    Out Varchar2,
        p_message_text    Out Varchar2
    ) As
        v_costcode                movemast.costcode%Type;
        v_yymm                    movemast.yymm%Type;

        v_yymm_remarks            Varchar2(200);
        v_movetotcm_remarks       Varchar2(200);
        v_movetosite_remarks      Varchar2(200);
        v_movetoothers_remarks    Varchar2(200);
        v_ext_subcontract_remarks Varchar2(200);
        v_fut_recruit_remarks     Varchar2(200);
        v_int_dept_remarks        Varchar2(200);
        v_hrs_subcont_remarks     Varchar2(200);

        v_pros_month              tsconfig.pros_month%Type;
        v_err_num                 Number;
        v_xl_row_number           Number := 0;
        is_error_in_row           Boolean;
        v_count                   Number;

        Cursor cur_json Is
            Select
                jt.*
            From
                Json_Table(p_movemast_json Format Json, '$[*]'
                    Columns (
                        costcode        Varchar2(4) Path '$.Costcode',
                        yymm            Varchar2(6) Path '$.Yymm',
                        movetotcm       Number      Path '$.Movetotcm',
                        movetosite      Number      Path '$.Movetosite',
                        movetoothers    Number      Path '$.Movetoothers',
                        ext_subcontract Number      Path '$.ExtSubcontract',
                        fut_recruit     Number      Path '$.FutRecruit',
                        int_dept        Number      Path '$.IntDept',
                        hrs_subcont     Number      Path '$.HrsSubcont'
                    )
                ) As "JT";

		v_empno varchar(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin

       v_empno := app_users.get_empno_from_meta_id(p_meta_id);
       If v_empno = 'ERRRR' Then
          Raise e_employee_not_found;
          Return Null;
       End If;
       
        v_err_num         := 0;

        For c1 In cur_json
        Loop
            is_error_in_row           := false;
            v_yymm_remarks            := Null;
            v_movetotcm_remarks       := Null;
            v_movetosite_remarks      := Null;
            v_movetoothers_remarks    := Null;
            v_ext_subcontract_remarks := Null;
            v_fut_recruit_remarks     := Null;
            v_int_dept_remarks        := Null;
            v_hrs_subcont_remarks     := Null;

            v_xl_row_number           := v_xl_row_number + 1;
            
            --costcode               
            If p_costcode != nvl(c1.costcode, '0') Then
                v_err_num       := v_err_num + 1;
                is_error_in_row := true;

                insert_movemast_errors(
                    p_person_id         => p_person_id,
                    p_meta_id           => p_meta_id,

                    p_id                => v_err_num,
                    p_section           => '',
                    p_excel_row_number  => v_xl_row_number,
                    p_field_name        => 'Costcode',
                    p_error_type        => 0,
                    p_error_type_string => 'Critical',
                    p_message           => 'Costcode does not match',

                    p_message_type      => p_message_type,
                    p_message_text      => p_message_text
                );
            End If;

            --yymm
            Begin
                v_yymm := To_Number(nvl(c1.yymm, 'yymm'));

                If length(c1.yymm) != 6 Then
                    v_err_num       := v_err_num + 1;
                    v_yymm_remarks  := 'Yymm should be 6 characters long';
                    is_error_in_row := true;
                Else
                    Select
                        pros_month
                    Into
                        v_pros_month
                    From
                        tsconfig;
                    If v_pros_month > c1.yymm Then
                        v_err_num       := v_err_num + 1;
                        v_yymm_remarks  := 'Yymm should not be earlier than Processing month';
                        is_error_in_row := true;
                    End If;
                End If;
            Exception
                When Others Then
                    v_err_num       := v_err_num + 1;
                    v_yymm_remarks  := 'Yymm should be in YYYYMM format';
                    is_error_in_row := true;
            End;

            If v_yymm_remarks Is Not Null Then
                insert_movemast_errors(
                    p_person_id         => p_person_id,
                    p_meta_id           => p_meta_id,

                    p_id                => v_err_num,
                    p_section           => '',
                    p_excel_row_number  => v_xl_row_number,
                    p_field_name        => 'Yymm',
                    p_error_type        => 0,
                    p_error_type_string => 'Critical',
                    p_message           => v_yymm_remarks,

                    p_message_type      => p_message_type,
                    p_message_text      => p_message_text
                );
            End If;

            validate_persons(
                p_person_id       => p_person_id,
                p_meta_id         => p_meta_id,
                p_persons         => c1.movetotcm,
                p_message_remarks => v_movetotcm_remarks);

            If v_movetotcm_remarks Is Not Null Then
                v_err_num           := v_err_num + 1;
                v_movetotcm_remarks := 'Move to TCM ' || v_movetotcm_remarks;
                is_error_in_row     := true;

                insert_movemast_errors(
                    p_person_id         => p_person_id,
                    p_meta_id           => p_meta_id,

                    p_id                => v_err_num,
                    p_section           => '',
                    p_excel_row_number  => v_xl_row_number,
                    p_field_name        => 'MoveToTCM',
                    p_error_type        => 0,
                    p_error_type_string => 'Critical',
                    p_message           => v_movetotcm_remarks,

                    p_message_type      => p_message_type,
                    p_message_text      => p_message_text
                );
            End If;

            validate_persons(
                p_person_id       => p_person_id,
                p_meta_id         => p_meta_id,
                p_persons         => c1.movetosite,
                p_message_remarks => v_movetosite_remarks);

            If v_movetosite_remarks Is Not Null Then
                v_err_num            := v_err_num + 1;
                v_movetosite_remarks := 'Move to site ' || v_movetosite_remarks;
                is_error_in_row      := true;

                insert_movemast_errors(
                    p_person_id         => p_person_id,
                    p_meta_id           => p_meta_id,

                    p_id                => v_err_num,
                    p_section           => '',
                    p_excel_row_number  => v_xl_row_number,
                    p_field_name        => 'MoveToSite',
                    p_error_type        => 0,
                    p_error_type_string => 'Critical',
                    p_message           => v_movetosite_remarks,

                    p_message_type      => p_message_type,
                    p_message_text      => p_message_text
                );
            End If;

            validate_persons(
                p_person_id       => p_person_id,
                p_meta_id         => p_meta_id,
                p_persons         => c1.movetoothers,
                p_message_remarks => v_movetoothers_remarks);

            If v_movetoothers_remarks Is Not Null Then
                v_err_num              := v_err_num + 1;
                v_movetoothers_remarks := 'Move to others ' || v_movetoothers_remarks;
                is_error_in_row        := true;

                insert_movemast_errors(
                    p_person_id         => p_person_id,
                    p_meta_id           => p_meta_id,

                    p_id                => v_err_num,
                    p_section           => '',
                    p_excel_row_number  => v_xl_row_number,
                    p_field_name        => 'MoveToOthers',
                    p_error_type        => 0,
                    p_error_type_string => 'Critical',
                    p_message           => v_movetoothers_remarks,

                    p_message_type      => p_message_type,
                    p_message_text      => p_message_text
                );
            End If;

            validate_persons(
                p_person_id       => p_person_id,
                p_meta_id         => p_meta_id,
                p_persons         => c1.ext_subcontract,
                p_message_remarks => v_ext_subcontract_remarks);

            If v_ext_subcontract_remarks Is Not Null Then
                v_err_num                 := v_err_num + 1;
                v_ext_subcontract_remarks := 'External subcontract ' || v_ext_subcontract_remarks;
                is_error_in_row           := true;

                insert_movemast_errors(
                    p_person_id         => p_person_id,
                    p_meta_id           => p_meta_id,

                    p_id                => v_err_num,
                    p_section           => '',
                    p_excel_row_number  => v_xl_row_number,
                    p_field_name        => 'Ext Subcontract',
                    p_error_type        => 0,
                    p_error_type_string => 'Critical',
                    p_message           => v_ext_subcontract_remarks,

                    p_message_type      => p_message_type,
                    p_message_text      => p_message_text
                );
            End If;

            validate_persons(
                p_person_id       => p_person_id,
                p_meta_id         => p_meta_id,
                p_persons         => c1.fut_recruit,
                p_message_remarks => v_fut_recruit_remarks);

            If v_fut_recruit_remarks Is Not Null Then
                v_err_num             := v_err_num + 1;
                v_fut_recruit_remarks := 'Future recruitment ' || v_fut_recruit_remarks;
                is_error_in_row       := true;

                insert_movemast_errors(
                    p_person_id         => p_person_id,
                    p_meta_id           => p_meta_id,

                    p_id                => v_err_num,
                    p_section           => '',
                    p_excel_row_number  => v_xl_row_number,
                    p_field_name        => 'Future recruit',
                    p_error_type        => 0,
                    p_error_type_string => 'Critical',
                    p_message           => v_fut_recruit_remarks,

                    p_message_type      => p_message_type,
                    p_message_text      => p_message_text
                );
            End If;

            validate_persons(
                p_person_id       => p_person_id,
                p_meta_id         => p_meta_id,
                p_persons         => c1.int_dept,
                p_message_remarks => v_int_dept_remarks);

            If v_int_dept_remarks Is Not Null Then
                v_err_num          := v_err_num + 1;
                v_int_dept_remarks := 'Internal dept ' || v_int_dept_remarks;
                is_error_in_row    := true;

                insert_movemast_errors(
                    p_person_id         => p_person_id,
                    p_meta_id           => p_meta_id,

                    p_id                => v_err_num,
                    p_section           => '',
                    p_excel_row_number  => v_xl_row_number,
                    p_field_name        => 'Internal department',
                    p_error_type        => 0,
                    p_error_type_string => 'Critical',
                    p_message           => v_int_dept_remarks,

                    p_message_type      => p_message_type,
                    p_message_text      => p_message_text
                );
            End If;

            validate_persons(
                p_person_id       => p_person_id,
                p_meta_id         => p_meta_id,
                p_persons         => c1.hrs_subcont,
                p_message_remarks => v_hrs_subcont_remarks);

            If v_hrs_subcont_remarks Is Not Null Then
                v_err_num             := v_err_num + 1;
                v_hrs_subcont_remarks := 'Hrs subcontractor ' || v_hrs_subcont_remarks;
                is_error_in_row       := true;

                insert_movemast_errors(
                    p_person_id         => p_person_id,
                    p_meta_id           => p_meta_id,

                    p_id                => v_err_num,
                    p_section           => '',
                    p_excel_row_number  => v_xl_row_number,
                    p_field_name        => 'Hours subcontract',
                    p_error_type        => 0,
                    p_error_type_string => 'Critical',
                    p_message           => v_hrs_subcont_remarks,

                    p_message_type      => p_message_type,
                    p_message_text      => p_message_text
                );
            End If;

            If is_error_in_row = false Then
                Select
                    Count(*)
                Into
                    v_count
                From
                    movemast
                Where
                    costcode = Trim(c1.costcode)
                    And yymm = Trim(c1.yymm);

                If v_count = 0 Then
                    insert_movemast(
                        p_person_id       => p_person_id,
                        p_meta_id         => p_meta_id,

                        p_costcode        => c1.costcode,
                        p_yymm            => c1.yymm,
                        p_movetotcm       => c1.movetotcm,
                        p_movetosite      => c1.movetosite,
                        p_movetoothers    => c1.movetoothers,
                        p_ext_subcontract => c1.ext_subcontract,
                        p_fut_recruit     => c1.fut_recruit,
                        p_int_dept        => c1.int_dept,
                        p_hrs_subcont     => c1.hrs_subcont,

                        p_message_type    => p_message_type,
                        p_message_text    => p_message_text
                    );
                Else
                    update_movemast(
                        p_person_id       => p_person_id,
                        p_meta_id         => p_meta_id,

                        p_costcode        => c1.costcode,
                        p_yymm            => c1.yymm,
                        p_movetotcm       => c1.movetotcm,
                        p_movetosite      => c1.movetosite,
                        p_movetoothers    => c1.movetoothers,
                        p_ext_subcontract => c1.ext_subcontract,
                        p_fut_recruit     => c1.fut_recruit,
                        p_int_dept        => c1.int_dept,
                        p_hrs_subcont     => c1.hrs_subcont,

                        p_message_type    => p_message_type,
                        p_message_text    => p_message_text
                    );
                End If;
            End If;
        End Loop;

        If v_err_num != 0 Then
            p_message_type := not_ok;
            p_message_text := 'Not all records were imported.';

        Else
            p_message_type := ok;
            p_message_text := 'File imported successfully.';
        End If;

        p_movemast_errors := tcmpl_app_config.pkg_process_excel_import_errors.fn_read_error_list(p_person_id => p_person_id,
                                                                                                 p_meta_id   => p_meta_id);

        Commit;

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := sqlcode || ' - ' || sqlerrm;
    End import_movemast_costcode;

---------------------------------------------------------------------------------------------------------------------	
  rec_obj_account('desk','tcmpl_app_config'),
            rec_obj_account('desk_mail','tcmpl_app_config'),
            rec_obj_account('dmsv2','tcmpl_app_config'),
            rec_obj_account('dms_select_list_qry','tcmpl_app_config'),
---------------------------------------------------------------------------------------------------------------------	
create or replace procedure send_mail_from_api (
    p_mail_to      varchar2,
    p_mail_cc      varchar2,
    p_mail_bcc     varchar2,
    p_mail_subject varchar2,
    p_mail_body    varchar2,
    p_mail_profile varchar2,
    p_success      out varchar2,
    p_message      out varchar2
) as
begin
   -- return;
    commonmasters.pkg_mail.send_api_mail(
                                        p_mail_to => p_mail_to,
                                        p_mail_cc => p_mail_cc,
                                        p_mail_bcc => p_mail_bcc,
                                        p_mail_subject => p_mail_subject,
                                        p_mail_body => p_mail_body,
                                        p_mail_profile => 'SELFSERVICE',
                                        p_success => p_success,
                                        p_message => p_message
    );
    /*
    Example

    send_mail_from_api (
        p_mail_to        => 'abc.yahoo.com, def.yahoo.com, ghy123.hotmail.com',
        p_mail_cc        => 'abc.yahoo.com, def.yahoo.com, ghy123.hotmail.com',
        p_mail_bcc       => p_mail_bcc,
        p_mail_subject   => 'This is a Subject of Sample mail',
        p_mail_body      => 'This is Body of Sample mail',
        p_mail_profile   => 'TIMESHEET',   (example --> SQSI, OSD, ALHR, etc...)
        p_success        => p_success,
        p_message        => p_message
    );

    */

end send_mail_from_api;


 Procedure send_email(
		p_mail_to 				In  Varchar2,
		p_book_by_empoloyee     In  Varchar2,
        p_office   				In  Varchar2,
        p_room     				In  Varchar2,        
		p_Date 					In  Varchar2,
		p_Start_time			In  Varchar2,
		p_end_time			In  Varchar2,
		       
        p_success  			Out Varchar2,
		p_message  			Out Varchar2
    ) As		
		v_mail_cc Varchar(2000) := NULL;
		v_mail_bcc Varchar(2000) := NULL;
		v_mail_subject Varchar(2000) := 'SELFSERVICE : ';
        v_mail_body Varchar(30000) := NULL;
		
    Begin 	   
	   v_mail_subject := v_mail_subject || 'Meeting room booked by '|| p_book_by_empoloyee;	   
	   v_mail_body := '
    
Dear

Meeting room has been booked by ' || p_book_by_empoloyee || '.

Date 			: - <b>' || p_Date   || '</b> 
Start Time      : - <b>' || p_Start_time || '</b>
End Time        : - <b>' || p_end_time || '</b>
Office          : - <b>' || p_office || '</b>
Meeting Room    : - <b>' || p_room || '</b>



This is an auto-generated mail. Please do not reply to this mail.



';
	   
        send_mail_from_api (
			p_mail_to        => p_mail_to,
			p_mail_cc        => v_mail_cc,
			p_mail_bcc       => v_mail_bcc,
			p_mail_subject   => v_mail_subject,
			p_mail_body      => v_mail_body,
			p_mail_profile   => 'SELFSERVICE',
			p_success        => p_success,
			p_message        => p_message
		);
        
    --param_success := 'OK';
    --param_message := 'Email was successfully sent.';
    Exception
        When Others Then
            p_success := 'KO';
            p_message := 'Error : ' || sqlcode || ' - ' || sqlerrm;
    End send_email;
	
	
---------------------------------------------------------------------------------------------------------------------	
FTC

Select * from vu_emplmast where emptype in ('FTC') and status = 1;

tpldevoradb
TPLQualOraDb
50044
50102	
---------------------------------------------------------------------------------------------------------------------		
 ( case a.is_consent when 'OK' then 'Yes' else '' end ) as is_consent,
 ( case a.is_consent when ok then 'Yes' else '' end ) as is_consent,
 ( case when a.key_id is null then '' else 'Save draft' end ) as status,
---------------------------------------------------------------------------------------------------------------------		
(
	Select
		Case
			When Count(business_line) > 0 Then
				1
			Else
				0
		End As delete_allowed
	From
		jobmaster
	Where
		business_line = a.code
) As delete_allowed,
---------------------------------------------------------------------------------------------------------------------		
IF( SQL%ROWCOUNT > 0 ) THEN
        param_msg_type:='SUCCESS';
      ELSE
        param_msg_type:='FAILURE';
        param_msgText :='Details not saved successfully';
      END IF;

---------------------------------------------------------------------------------------------------------------------		

select to_char(sysdate,'DD-MON-YYYY HH24:MI:SS') from dual;

---------------------------------------------------------------------------------------------------------------------		

  Procedure sp_deemed_emp_loa_acceptance (
        p_person_id    Varchar2,
        p_meta_id      Varchar2,
        p_emp_list     Out Sys_Refcursor,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno Varchar2(5);
        v_count Number;
        c       Sys_Refcursor;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(b.empno)
          Into v_count
          From
            emp_loa_addendum_acceptance b
         Where
            b.acceptance_status = 0;

        If v_count = 0 Then
            p_message_type := ok;
            p_message_text := 'LOA Pending employees not found..';
            Return;
        End If;

        Open p_emp_list For 
                Select
                    a1.empno emp_no
                From
                    tcmpl_hr.emp_loa_addendum_acceptance a1
                Where
                    a1.acceptance_status = 0;

        Update emp_loa_addendum_acceptance
           Set
            acceptance_status = 2,
            acceptance_date = sysdate
         Where
            acceptance_status = 0;

        If ( Sql%rowcount > 0 ) Then
            p_message_type := ok;
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := not_ok;
            p_message_text := 'Error...Invalid operation';
        End If;

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- '
                              || sqlcode
                              || ' - '
                              || sqlerrm;
    End sp_deemed_emp_loa_acceptance;


---------------------------------------------------------------------------------------------------------------------		
1. DENSE_RANK
It is a type of analytic function that calculates the rank of a row. Unlike the RANK function this function returns rank as consecutive integers.

Example:

In this example we are going to find the rank of the column city in EMPLOYEE table.

Code: SELECT city, DENSE_RANK () OVER (ORDER BY city) city_rank FROM EMPLOYEE;
---------------------------------------------------------------------------------------------------------------------
reading Json 

https://docs.oracle.com/en/database/oracle/oracle-database/19/adjsn/function-JSON_TABLE.html#GUID-0172660F-CE29-4765-BF2C-C405BDE8369A


Select jt.*
        From
         Json_Table ( :P_Parameter_Json Format Json, '$[*]'
            Columns (
               empno Varchar2 (5) Path '$.empno',
               transdate Varchar2 (20) Path '$.transDate',
               transremark Varchar2 (200) Path '$.transRemark',
               NESTED PATH '$.returnItem[*]'
               COLUMNS (
               itemid Varchar2 (20) Path   '$[*].itemId',
               isreturn Varchar2 (20) Path '$.isReturn',
               isusable Varchar2 (20) Path '$.isUsable')
            )
         )
      As "JT";

{
	"empno"	   : "04170",
    "transDate": "11-Jul-2023",
    "transRemark": "fgbgh",
    "returnItem": [{
            "itemId": "464SIXPI57US16IX1T0G",
            "isReturn": true,
            "isUsable": "Damaged / Non-Usable"
        },
		{
            "itemId": "048SIXPI57US16IX1T0G",
            "isReturn": false,
            "isUsable": "Usable"
        }
    ]
}
 
 

  Procedure sp_receive_transaction_json (
      p_person_id     Varchar2,
      p_meta_id       Varchar2,
      
      P_Parameter_Json  Varchar2, 
       P_Get_Trans_Id Out Varchar2,
      p_message_type  Out Varchar2,
      p_message_text  Out Varchar2
   ) As

      
      v_empno Varchar2(5);
      Cursor cur_json Is
      Select jt.*
        From
         Json_Table (  P_Parameter_Json Format Json, '$[*]'
            Columns (
               empno Varchar2 ( 5 ) Path '$.empno',
               transdate Varchar2 ( 20 ) Path '$.transDate',
               transremark Varchar2 ( 200 ) Path '$.transRemark',
               Nested Path '$.returnItem[*]'
                  Columns (
                     itemid Varchar2 ( 20 ) Path '$[*].itemId',
                     isreturn Varchar2 ( 20 ) Path '$.isReturn',
                     isusable Varchar2 ( 20 ) Path '$.isUsable'
                  )
            )
         )
      As "JT";

   Begin
      v_empno        := get_empno_from_meta_id(p_meta_id);
      If v_empno = 'ERRRR' Then
         p_message_type := 'KO';
         p_message_text := 'Invalid employee number';
         Return;
      End If;
      For c1 In cur_json
           Loop
           Begin
                 P_Get_Trans_Id  := P_Get_Trans_Id || ' - ' || c1.transdate || ' - ' || c1.transremark || ' - ' || 
                                    c1.itemid || ' - ' || c1.isreturn
                                    || ' - ' || c1.isusable ;
                 
                null;
            Exception
                When Others Then
                    p_message_type := 'KO';
                    p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
            End;
          End Loop;      
      null;
      
      Commit;
      p_message_type := 'OK';
      p_message_text := 'Procedure executed successfully.';
   Exception
      When Others Then
         p_message_type := 'KO';
         p_message_text := 'ERR :- '
                           || sqlcode
                           || ' - '
                           || sqlerrm;
   End sp_receive_transaction_json;

		
---------------------------------------------------------------------------------------------------------------------		
    procedure sp_timesheet_status_count (
        p_person_id                      varchar2,
        p_meta_id                        varchar2,
        --------------------------------------------
        p_yyyymm                         varchar2,
        --------------------------------------------
        p_starting_of_month_filled       out number,
        p_starting_of_month_approved     out number,
        p_starting_of_month_posted       out number,
        --------------------------------------------
        p_ending_of_month_filled         out number,
        p_ending_of_month_approved       out number,
        p_ending_of_month_posted         out number,
        --------------------------------------------
        p_starting_of_month_not_filled   out number,
        p_starting_of_month_not_approved out number,
        p_starting_of_month_not_posted   out number,
        --------------------------------------------
        p_ending_of_month_not_filled     out number,
        p_ending_of_month_not_approved   out number,
        p_ending_of_month_not_posted     out number,
        --------------------------------------------
        p_message_type                   out varchar2,
        p_message_text                   out varchar2
    ) as

        v_empno        varchar2(5);
        v_status       number := 0;
        v_user_tcp_ip  varchar2(5) := 'NA';
        v_message_type number := 0;
    begin
         v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        
        select 
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1 
        into 
            p_starting_of_month_filled,
            p_starting_of_month_approved,
            p_starting_of_month_posted,
            p_ending_of_month_filled,
            p_ending_of_month_approved,
            p_ending_of_month_posted,
            p_starting_of_month_not_filled,
            p_starting_of_month_not_approved,
            p_starting_of_month_not_posted,
            p_ending_of_month_not_filled,
            p_ending_of_month_not_approved,
            p_ending_of_month_not_posted
        from dual;
        
        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    exception
        when others then
            rollback;
            p_message_type := 'KO';
            p_message_text := 'ERR :- '
                              || sqlcode
                              || ' - '
                              || sqlerrm;
    end sp_timesheet_status_count;
---------------------------------------------------------------------------------------------------------------------		

1) Time_Mast - Timesheet filled recored 
	- Can be parent with same assign
	- Can be parent with diff assign
	
2) Emplmast
3) CC_PORT
4) 


---------------------------------------------------------------------------------------------------------------------		

-- Excel Download from Db Without Model


--C# Repos - AssetWithITPoolDataTableListRepository 
--C# Repos -IAssetWithITPoolDataTableListRepository

 Function fn_asset_with_itpool_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_asset_category Varchar2 Default Null
    ) Return Sys_Refcursor As
        c              Sys_Refcursor;
        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Return c;
        End If;

        Open c For
            Select                
                b.item_type_desc                                                                typename,
                Trim(a.barcode)                                                                 barcode,
                a.serialnum,
                a.model,
                a.compname,
                decode(a.out_of_service, 1, 'Yes', 'No')                                        out_of_service,
                pkg_dms_general.get_last_desk(Trim(a.barcode))                                  last_office,
                pkg_dms_general.get_desk_office(pkg_dms_general.get_last_desk(Trim(a.barcode))) last_deskno
            From
                dm_assetcode   a,
                inv_item_types b
            Where
                scrap_date Is Null
                And barcode Like 'IT%'
                And b.item_type_code In ('MO', 'NB', 'PC', 'IP', 'PR', 'DS')
                And b.item_type_key_id = nvl(p_asset_category, b.item_type_key_id)
                And Trim(a.barcode) Not In (
                    Select
                        Trim(assetid)
                    From
                        dm_deskallocation
                )
                And Trim(a.barcode)Not In (
                    Select
                        Trim(assetid)
                    From
                        dm_assetadd
                )
            Order By
                b.item_type_desc,
                a.barcode;

        Return c;
    End fn_asset_with_itpool_list;

---------------------------------------------------------------------------------------------------------------------		

	Procedure sp_assign_work_space(
		p_person_id           Varchar2,
		p_meta_id             Varchar2,

		p_emp_workspace_array typ_tab_string,
		p_message_type Out    Varchar2,
		p_message_text Out    Varchar2
	) As
		v_workspace_code      Number;
		v_mod_by_empno        Varchar2(5);
		v_count               Number;
		v_key                 Varchar2(10);
		v_empno               Varchar2(5);
		rec_config_week       swp_config_weeks%rowtype;
		c_planning_future     Constant Number(1) := 2;
		c_planning_current    Constant Number(1) := 1;
		c_planning_is_open    Constant Number(1) := 1;
		Type typ_tab_primary_workspace Is Table Of swp_primary_workspace%rowtype Index By Binary_Integer;
		tab_primary_workspace typ_tab_primary_workspace;
		v_ows_desk_id         Varchar2(10);
	Begin
		v_mod_by_empno := get_empno_from_meta_id(p_meta_id);
		If v_mod_by_empno = 'ERRRR' Then
			p_message_type := 'KO';
			p_message_text := 'Invalid employee number';
			Return;
		End If;
		Begin

			Select
				*
			Into
				rec_config_week
			From
				swp_config_weeks
			Where
				planning_flag = c_planning_future
				And pws_open  = c_planning_is_open;
		Exception
			When Others Then
				p_message_type := 'KO';
				p_message_text := 'Err - SWP Planning is not open. Cannot proceed.';
				Return;
		End;

		For i In 1..p_emp_workspace_array.count
		Loop

			With
				csv As (
					Select
						p_emp_workspace_array(i) str
					From
						dual
				)
			Select
				Trim(regexp_substr(str, '[^~!~]+', 1, 1)) empno,
				Trim(regexp_substr(str, '[^~!~]+', 1, 2)) workspace_code
			Into
				v_empno, v_workspace_code
			From
				csv;

			Select
				* Bulk Collect
			Into
				tab_primary_workspace
			From
				(
					Select
						*
					From
						swp_primary_workspace
					Where
						empno = Trim(v_empno)
					Order By start_date Desc
				)
			Where
				Rownum <= 2;

			If tab_primary_workspace.count > 0 Then
				--If same FUTURE record exists in database then continue
				--If no change then continue
				If tab_primary_workspace(1).primary_workspace = v_workspace_code Then
					Continue;
				End If;

				--Delete existing SWP DESK ASSIGNMENT planning
				del_emp_future_planning(
					p_empno               => v_empno,
					p_planning_start_date => trunc(rec_config_week.start_date)
				);
				--
				v_ows_desk_id := iot_swp_common.get_swp_planned_desk(v_empno);
				--Remove user desk association in DMS
				If Trim(v_ows_desk_id) Is Not Null Then
					iot_swp_dms.sp_remove_desk_user(
						p_person_id => p_person_id,
						p_meta_id   => p_meta_id,

						p_empno     => v_empno,
						p_deskid    => v_ows_desk_id
					);
				End If;

				--If furture planning is reverted to old planning then continue
				If tab_primary_workspace(1).active_code = c_planning_future Then
					If tab_primary_workspace.Exists(2) Then
						If tab_primary_workspace(2).primary_workspace = v_workspace_code Then
							Continue;
						End If;
					End If;
				End If;
			End If;
			v_key := dbms_random.string('X', 10);
			Insert Into swp_primary_workspace (
				key_id,
				empno,
				primary_workspace,
				start_date,
				modified_on,
				modified_by,
				active_code
			)
			Values (
				v_key,
				v_empno,
				v_workspace_code,
				rec_config_week.start_date,
				sysdate,
				v_mod_by_empno,
				c_planning_future
			);
			Commit;
		End Loop;

		p_message_type := 'OK';
		p_message_text := 'Procedure executed successfully.';
	Exception
		When Others Then
			Rollback;
			p_message_type := 'KO';
			p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
	End;
    

---------------------------------------------------------------------------------------------------------------------	

Send Email 
IN - PACKAGE

set define off;

c_mail_cc Constant Varchar2(5000) := 
'[HODEMAIL];A.Fernandes@tecnimont.in;K.Das2@tecnimont.in;A.Rawat@tecnimont.in;N.Sawant@tecnimont.in;G.Sarang@tecnimont.in;S.Athalye@tecnimont.in;s.kadam42@tecnimont.in; 
A.Kotian@tecnimont.in;V.Joshi@tecnimont.in;B.Mhatre@tecnimont.in;R.Sanghvi@tecnimont.in;S.Jadhav7@tecnimont.in;';

c_mail_body Constant Varchar2(8000) := '<p>Dear Mr./Ms. [EMPNAME],</p>

<p>We are in receipt of your resignation dated [RESIGNATIONDATE] (Date of Resignation). Please note that your resignation has been accepted and you will likely be relieved from the services of the Company effective [RELIEVINGDATE] (Date of Relieving)</p>

<p>A formal relieving letter will be issued to you on your last working day. Meanwhile, the concerned person from HR Dept. will contact you for an Exit Interview to help us analyse the reasons for leaving the organisation.</p>

<p>Regarding your Statutory (PF, Gratuity, Superannuation) dues if any, you need to contact Mr. Gurudatt Sarang/ Mr. Rakesh Sanghvi, and Mr. Nilesh Sawant/Mr. Sunil Kadam for your F&amp;F settlement.</p>

<p>Also, note that you need to withdraw all shares allotted to you by MET (Applicable to Permanent Employees only). For further details on the same, pls. contact Mr. Bipin Mhatre.</p>

<p>Your Exit Procedure will be initiated nearing your date of Relieving which will be intimated to you accordingly.</p>

<p>The IT assets issued to you should be returned to the IT department during working hours on your last working day. Please contact Mr. Sanjay Mistry of IT dept. for returning the IT assets.</p>

<p>Kindly send your contact details as mentioned below to email id a.fernandes@tecnimont.in  Please note, these details are required for initiating your off-boarding and future communication.</p>

<p>1. Telephone Numbers (Mobile &amp; Landline No.) 2. Personal email id  3. Postal Address</p>

<p>For any further queries on your resignation letter, kindly contact Ms. Annie Fernandes of HR Dept.</p>';


IN - PACKAGE BODY

   Procedure send_mail(
        p_empno Varchar2
    ) As
        v_emp_name         Varchar2(100);
        v_emp_email        Varchar2(100);
        v_hod_mail         Varchar2(100);
        v_resignation_date Date;
        v_relieving_date   Date;
        v_mail_subject     Varchar2(800);
        v_mail_to          Varchar2(2000);
        v_msg_body         Varchar2(2000);

        v_mail_cc          Varchar2(2000);
        v_success          Varchar2(20);
        v_message          Varchar2(2000);

    Begin

        Select
            a.name,
            a.email,
            (
                Select
                    vu_b.email
                From
                    vu_emplmast vu_b
                Where
                    vu_b.empno In
                    (
                        Select
                            hod
                        From
                            vu_costmast
                        Where
                            costcode = a.parent
                            And hod Not In ('04600', '04132')
                    )
            ) hod_email,
            re.emp_resign_date,
            re.date_of_relieving

        Into
            v_emp_name,
            v_emp_email,
            v_hod_mail,
            v_resignation_date,
            v_relieving_date
        From
            vu_emplmast                     a, mis_resigned_emp re
        Where
            a.empno     = p_empno
            And a.empno = re.empno;

        

        v_mail_to      := v_emp_email;

        v_mail_cc      := replace(c_mail_cc, '[HODEMAIL]', v_hod_mail);

        v_mail_subject := 'HR-MIS : Acceptance of Resignation - ' || p_empno || '-' || v_emp_name;

        v_msg_body     := replace(
                              c_mail_body,
                              '[EMPNAME]',
                              p_empno || '-' || v_emp_name
                          );
        v_msg_body     := replace(
                              v_msg_body,
                              '[RESIGNATIONDATE]',
                              to_char(v_resignation_date, 'dd-Mon-yyyy')
                          );
        v_msg_body     := replace(
                              v_msg_body,
                              '[RELIEVINGDATE]',
                              to_char(v_relieving_date, 'dd-Mon-yyyy')
                          );

        send_mail_from_api(
            p_mail_to      => v_mail_to,
            p_mail_cc      => v_mail_cc,
            p_mail_bcc     => Null,
            p_mail_subject => v_mail_subject,
            p_mail_body    => v_msg_body,
            p_mail_profile => 'SELFSERVICE',
            p_mail_format  => 'HTML',
            p_success      => v_success,
            p_message      => v_message
        );

        Insert Into mis_resigned_mail_log (
            mail_to,
            mail_from,
            mail_cc,
            mail_bcc,
            mail_success,
            mail_success_message,
            mail_date
        )
        Values (
            v_mail_to,
            Null,
            v_mail_cc,
            Null,
            v_success,
            v_message,
            sysdate
        );

        Commit;

    End send_mail;



  If (Sql%rowcount > 0) Then
            mis_resigned_employees.send_mail(
                p_empno => p_empno
            );
        End If;


---------------------------------------------------------------------------------------------------------------------	
Select *
From
    dm_newjoin_emp
Where
    Rowid Not In
    (
        Select
            Min(Rowid)
        From
            dm_newjoin_emp
        Group By
            empno, ccode
    ); --those are the columns that define which row is unique

---------------------------------------------------------------------------------------------------------------------	

Procedure sp_assign_work_space(
		p_person_id           Varchar2,
		p_meta_id             Varchar2,

		p_new_emp_array 	  typ_tab_string,
		p_message_type Out    Varchar2,
		p_message_text Out    Varchar2
	) As		
		v_mod_by_empno        Varchar2(5);		
		v_empno               Varchar2(5);
		v_costcode               Varchar2(5);
		rec_config_week       swp_config_weeks%rowtype;
		c_planning_future     Constant Number(1) := 2;
		c_planning_current    Constant Number(1) := 1;
		c_planning_is_open    Constant Number(1) := 1;
		Type typ_tab_primary_workspace Is Table Of swp_primary_workspace%rowtype Index By Binary_Integer;
		tab_primary_workspace typ_tab_primary_workspace;
		v_ows_desk_id         Varchar2(10);
	Begin
		v_mod_by_empno := get_empno_from_meta_id(p_meta_id);
		If v_mod_by_empno = 'ERRRR' Then
			p_message_type := 'KO';
			p_message_text := 'Invalid employee number';
			Return;
		End If;
		Begin

			 

		For i In 1..p_new_emp_array.count
		Loop

			With
				csv As (
					Select
						p_new_emp_array(i) str
					From
						dual
				)
			Select
				Trim(regexp_substr(str, '[^~!~]+', 1, 1)) empno,
				Trim(regexp_substr(str, '[^~!~]+', 1, 2)) cost_code
			Into
				v_empno, v_costcode
			From
				csv;

			Select
				* Bulk Collect
			Into
				tab_primary_workspace
			From
				(
					Select
						*
					From
						swp_primary_workspace
					Where
						empno = Trim(v_empno)
					Order By start_date Desc
				)
			Where
				Rownum <= 2;

			If tab_primary_workspace.count > 0 Then
				--If same FUTURE record exists in database then continue
				--If no change then continue
				If tab_primary_workspace(1).primary_workspace = v_workspace_code Then
					Continue;
				End If;

				--Delete existing SWP DESK ASSIGNMENT planning
				del_emp_future_planning(
					p_empno               => v_empno,
					p_planning_start_date => trunc(rec_config_week.start_date)
				);
				--
				v_ows_desk_id := iot_swp_common.get_swp_planned_desk(v_empno);
				--Remove user desk association in DMS
				If Trim(v_ows_desk_id) Is Not Null Then
					iot_swp_dms.sp_remove_desk_user(
						p_person_id => p_person_id,
						p_meta_id   => p_meta_id,

						p_empno     => v_empno,
						p_deskid    => v_ows_desk_id
					);
				End If;

				--If furture planning is reverted to old planning then continue
				If tab_primary_workspace(1).active_code = c_planning_future Then
					If tab_primary_workspace.Exists(2) Then
						If tab_primary_workspace(2).primary_workspace = v_workspace_code Then
							Continue;
						End If;
					End If;
				End If;
			End If;
			v_key := dbms_random.string('X', 10);
			Insert Into swp_primary_workspace (
				key_id,
				empno,
				primary_workspace,
				start_date,
				modified_on,
				modified_by,
				active_code
			)
			Values (
				v_key,
				v_empno,
				v_workspace_code,
				rec_config_week.start_date,
				sysdate,
				v_mod_by_empno,
				c_planning_future
			);
			Commit;
		End Loop;

		p_message_type := 'OK';
		p_message_text := 'Procedure executed successfully.';
	Exception
		When Others Then
			Rollback;
			p_message_type := 'KO';
			p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
	End;
    
	
---------------------------------------------------------------------------------------------------------------------		
  Procedure sp_update_emp_eps_4_all(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_key_id           Varchar2,
        p_nom_name         Varchar2,
        p_nom_add1         Varchar2,
        p_relation         Varchar2,
        p_nom_dob          Date,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_exists       Number;
        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        pkg_emp_eps_4_all.sp_update_eps_4_all(

            p_key_id       => p_key_id,
            p_empno        => v_empno,
            p_modified_by  => v_empno,
            p_nom_name     => p_nom_name,
            p_nom_add1     => p_nom_add1,
            p_relation     => p_relation,
            p_nom_dob      => p_nom_dob,
            p_message_type => p_message_type,
            p_message_text => p_message_text
        );

    Exception
        When dup_val_on_index Then
            p_message_type := 'KO';
            p_message_text := 'Duplicate record is not allowed. !!!';
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_update_emp_eps_4_all;
---------------------------------------------------------------------------------------------------------------------		
    insert into DG_MID_EVALUATION
      select dbms_random.string('X', 8)                          as KEY_ID,
             EMPNO,
             DESGCODE,
             PARENT,
             ATTENDANCE,
             LOCATION,
             SKILL_1,
             SKILL_1_RATING,
             SKILL_1_REMARK,
             SKILL_2,
             SKILL_2_RATING,
             SKILL_2_REMARK,
             SKILL_3,
             SKILL_3_RATING,
             SKILL_3_REMARK,
             SKILL_4,
             SKILL_4_RATING,
             SKILL_4_REMARK,
             SKILL_5,
             SKILL_5_RATING,
             SKILL_5_REMARK,
             QUE_2_RATING,
             QUE_2_REMARK,
             QUE_3_RATING,
             QUE_3_REMARK,
             QUE_4_RATING,
             QUE_4_REMARK,
             QUE_5_RATING,
             QUE_5_REMARK,
             QUE_6_RATING,
             QUE_6_REMARK,
             OBSERVATIONS,
             '04245'                             as CREATED_BY,
             sysdate as CREATED_On,
             '04025'                             as MODIFIED_BY,             
             sysdate as MODIFIED_On,
             ISDELETED
        from
         json_table ( '{
                   "empno": "04170",
                   "desgcode": "010642",
                   "parent": "0106",
                   "attendance": "attendance_val",
                   "location": "BOM",
                   "skill_1": "skill_1_val",
                   "skill_1_rating": 3,
                   "skill_1_remark": "skill_1_remark_val",
                   "skill_2": "skill_2_val",
                   "skill_2_rating": 2,
                   "skill_2_remark": "skill_2_remark_val",
                   "skill_3": "skill_3_val",
                   "skill_3_rating": 4,
                   "skill_3_remark": "skill_3_remark_val",
                   "skill_4": "skill_4_val",
                   "skill_4_rating": 3,
                   "skill_4_remark": "skill_4_remark_val",
                   "skill_5": "skill_5_val",
                   "skill_5_rating": 4,
                   "skill_5_remark": "skill_5_remark_val",
                   "que_2_rating": 3,
                   "que_2_remark": "que_2_remark_val",
                   "que_3_rating": 4,
                   "que_3_remark": "que_3_remark_val",
                   "que_4_rating": 1,
                   "que_4_remark": "que_4_remark_val",
                   "que_5_rating": 5,
                   "que_5_remark": "que_5_remark_val",
                   "que_6_rating": 3,
                   "que_6_remark": "que_6_remark_val",
                   "observations": "observations_val",
                   "isdeleted": 0
               }', '$'
            columns (
               empno varchar2 ( 5 ) path '$.empno',
               desgcode varchar2 ( 6 ) path '$.desgcode',
               parent varchar2 ( 4 ) path '$.parent',
               attendance varchar2 ( 50 ) path '$.attendance',
               location varchar2 ( 3 ) path '$.location',
               skill_1 varchar2 ( 50 ) path '$.skill_1',
               skill_1_rating number path '$.skill_1_rating',
               skill_1_remark varchar2 ( 100 ) path '$.skill_1_remark',
               skill_2 varchar2 ( 50 ) path '$.skill_2',
               skill_2_rating number path '$.skill_2_rating',
               skill_2_remark varchar2 ( 100 ) path '$.skill_2_remark',
               skill_3 varchar2 ( 50 ) path '$.skill_3',
               skill_3_rating number path '$.skill_3_rating',
               skill_3_remark varchar2 ( 100 ) path '$.skill_3_remark',
               skill_4 varchar2 ( 50 ) path '$.skill_4',
               skill_4_rating number path '$.skill_4_rating',
               skill_4_remark varchar2 ( 100 ) path '$.skill_4_remark',
               skill_5 varchar2 ( 50 ) path '$.skill_5',
               skill_5_rating number path '$.skill_5_rating',
               skill_5_remark varchar2 ( 100 ) path '$.skill_5_remark',
               que_2_rating number path '$.que_2_rating',
               que_2_remark varchar2 ( 100 ) path '$.que_2_remark',
               que_3_rating number path '$.que_3_rating',
               que_3_remark varchar2 ( 100 ) path '$.que_3_remark',
               que_4_rating number path '$.que_4_rating',
               que_4_remark varchar2 ( 100 ) path '$.que_4_remark',
               que_5_rating number path '$.que_5_rating',
               que_5_remark varchar2 ( 100 ) path '$.que_5_remark',
               que_6_rating number path '$.que_6_rating',
               que_6_remark varchar2 ( 100 ) path '$.que_6_remark',
               observations varchar2 ( 400 ) path '$.observations',
               isdeleted number path '$.isdeleted'
            )
         )
---------------------------------------------------------------------------------------------------------------------		
   insert into DG_MID_EVALUATION
      select dbms_random.string('X', 8)                          as KEY_ID,
             EMPNO,
             DESGCODE,
             PARENT,
             ATTENDANCE,
             LOCATION,
             SKILL_1,
             SKILL_1_RATING,
             SKILL_1_REMARK,
             SKILL_2,
             SKILL_2_RATING,
             SKILL_2_REMARK,
             SKILL_3,
             SKILL_3_RATING,
             SKILL_3_REMARK,
             SKILL_4,
             SKILL_4_RATING,
             SKILL_4_REMARK,
             SKILL_5,
             SKILL_5_RATING,
             SKILL_5_REMARK,
             QUE_2_RATING,
             QUE_2_REMARK,
             QUE_3_RATING,
             QUE_3_REMARK,
             QUE_4_RATING,
             QUE_4_REMARK,
             QUE_5_RATING,
             QUE_5_REMARK,
             QUE_6_RATING,
             QUE_6_REMARK,
             OBSERVATIONS,
             '04245'                             as CREATED_BY,
             sysdate as CREATED_On,
             '04025'                             as MODIFIED_BY,             
             sysdate as MODIFIED_On,
             ISDELETED
        from
         json_table ( :JsonObj, '$'
            columns (
               empno varchar2 ( 5 ) path '$.empno',
               desgcode varchar2 ( 6 ) path '$.desgcode',
               parent varchar2 ( 4 ) path '$.parent',
               attendance varchar2 ( 50 ) path '$.attendance',
               location varchar2 ( 3 ) path '$.location',
               skill_1 varchar2 ( 50 ) path '$.skill_1',
               skill_1_rating number path '$.skill_1_rating',
               skill_1_remark varchar2 ( 100 ) path '$.skill_1_remark',
               skill_2 varchar2 ( 50 ) path '$.skill_2',
               skill_2_rating number path '$.skill_2_rating',
               skill_2_remark varchar2 ( 100 ) path '$.skill_2_remark',
               skill_3 varchar2 ( 50 ) path '$.skill_3',
               skill_3_rating number path '$.skill_3_rating',
               skill_3_remark varchar2 ( 100 ) path '$.skill_3_remark',
               skill_4 varchar2 ( 50 ) path '$.skill_4',
               skill_4_rating number path '$.skill_4_rating',
               skill_4_remark varchar2 ( 100 ) path '$.skill_4_remark',
               skill_5 varchar2 ( 50 ) path '$.skill_5',
               skill_5_rating number path '$.skill_5_rating',
               skill_5_remark varchar2 ( 100 ) path '$.skill_5_remark',
               que_2_rating number path '$.que_2_rating',
               que_2_remark varchar2 ( 100 ) path '$.que_2_remark',
               que_3_rating number path '$.que_3_rating',
               que_3_remark varchar2 ( 100 ) path '$.que_3_remark',
               que_4_rating number path '$.que_4_rating',
               que_4_remark varchar2 ( 100 ) path '$.que_4_remark',
               que_5_rating number path '$.que_5_rating',
               que_5_remark varchar2 ( 100 ) path '$.que_5_remark',
               que_6_rating number path '$.que_6_rating',
               que_6_remark varchar2 ( 100 ) path '$.que_6_remark',
               observations varchar2 ( 400 ) path '$.observations',
               isdeleted number path '$.isdeleted'
            )
         )
---------------------------------------------------------------------------------------------------------------------		
DECLARE
  P_PERSON_ID VARCHAR2(200);
  P_META_ID VARCHAR2(200);
  P_GENERIC_SEARCH VARCHAR2(200);
  P_GRADE VARCHAR2(200);
  P_ROW_NUMBER NUMBER;
  P_PAGE_LENGTH NUMBER;
  v_Return sys_refcursor;
BEGIN
 P_PERSON_ID := '01010936';
  P_META_ID := '46B8876C62E81974DACD';
  P_GENERIC_SEARCH := NULL;
  P_GRADE := NULL;
  P_ROW_NUMBER := 0;
  P_PAGE_LENGTH := 50;

  v_Return := PKG_DG_MID_EVALUATION_QRY.FN_DG_MID_EVALUATION_HR_PENDING_LIST(
    P_PERSON_ID => P_PERSON_ID,
    P_META_ID => P_META_ID,
    P_GENERIC_SEARCH => P_GENERIC_SEARCH,
    P_GRADE => P_GRADE,
    P_ROW_NUMBER => P_ROW_NUMBER,
    P_PAGE_LENGTH => P_PAGE_LENGTH
  );
  /* Legacy output: 
DBMS_OUTPUT.PUT_LINE('v_Return = ' || v_Return);
*/ 
  :v_Return := v_Return; --<-- Cursor
--rollback; 
END;


---------------------------------------------------------------------------------------------------------------------		
Select
    a.empno                                                              As emp_no,
    a.empno || ' : ' || d.name                                           As employee,
    a.module_id                                                          As module_val,
    a.module_id || ' : ' || b.module_name || ' - ' || b.module_long_desc As module_text,
    a.role_id                                                            As role_val,
    a.role_id || ' : ' || c.role_name || ' - ' || c.role_desc            As role_text,
    a.costcode                                                           As parent_val,
    a.costcode || ' : ' || e.name                                        As parent_text,
    1                                                                    As delete_allowed,
    a.row_number                                                         row_number,
    a.total_row                                                          total_row
  From
    (
        Select
            a.empno,
            a.module_id,
            a.role_id,
            a.costcode,
            1      As delete_allowed,
            Row_Number() Over( Order By a.module_id, a.empno )      row_number,
            Count(*) Over() total_row 
            From
            sec_module_user_roles_costcode a
         Where
                a.costcode  = nvl( :p_parent, a.costcode ) 
                And a.module_id = nvl( :p_module_id, a.module_id )
                And a.empno     = nvl( :p_empno, a.empno )
    )           a,
    sec_modules b,
    sec_roles   c,
    vu_emplmast d,
    vu_costmast e
 Where
    a.module_id = b.module_id And
    a.role_id   = c.role_id And
    a.costcode  = e.costcode And
    a.empno     = d.empno
        
---------------------------------------------------------------------------------------------------------------------		
Select
    a.empno, 
    b.name,
    trunc(a.dob) tbl_fm_dob,
    trunc(b.dob) tbl_vu_dob
  From
    emp_family  a,
    vu_emplmast b
 Where
    b.status = 1 And
    a.relation = 5 and 
    a.empno = b.empno and 
    a.dob    != b.dob
---------------------------------------------------------------------------------------------------------------------		
Update emp_family a
   Set
    a.dob = (
        Select
            b.dob
          From
            vu_emplmast b
         Where
                b.status   = 1 And
            a.relation = 5 And
            a.empno    = b.empno And
            a.empno   = :v_empno And
            a.dob != b.dob
    )
 Where
    a.empno = :v_empno And relation = 5
	
---------------------------------------------------------------------------------------------------------------------		
select a.empno ,a.member tbl_fm_name,
b.name tbl_vu_emp_name
From
    emp_family  a,
    vu_emplmast b
 Where
    b.status = 1 And
    a.relation = 5 and 
    a.empno = b.empno  And
    a.MEMBER != b.name;
    --a.empno = :v_empno  And
    --a.dob != b.dob; 


select count(a.empno)
From
    emp_family  a,
    vu_emplmast b
 Where
    b.status = 1 And
    a.relation = 5 and 
    a.empno = b.empno  And
    a.MEMBER != b.name;
---------------------------------------------------------------------------------------------------------------------	
Select
    level,
    dbms_random.string('X',10)
  From
    dual
Connect By
    level <= 90000	
---------------------------------------------------------------------------------------------------------------------	
Select
    level,
    to_char( (sysdate + level), 'dd-Mon-yyyy') as date_list,
    iot_swp_common.fn_get_next_work_date(sysdate + level) as work_date,
    ( case when trunc((sysdate + level)) = trunc(iot_swp_common.fn_get_next_work_date(sysdate + level)) then 'Yes'
           --when trunc(sysdate + 2) = trunc(sysdate + level) then 'Yes'
           else 'No' end ) as can_exclude
  From
    dual
Connect By
    level <= 60	
	
	
	
	Select
    level,
    to_char( (sysdate + level), 'dd-Mon-yyyy') as date_list,
    --iot_swp_common.fn_get_next_work_date(sysdate + level) as work_date,
    ( case when trunc((sysdate + level)) = trunc(iot_swp_common.fn_get_next_work_date(sysdate + level)) then 'Yes'
           --when trunc(sysdate + 2) = trunc(sysdate + level) then 'Yes'
           else 'No' end ) as can_exclude
  From
    dual
Connect By
    level <= 60
---------------------------------------------------------------------------------------------------------------------		

Insert into TableName 
				(Key_id,
				 c_1,
				 c_2,
				 c_3
				 )				 
		values (dbms_random.string('X', 10),
				p_1,
				p_2,
				p_3
				)
				Returning 
                Key_id 
                    Into 
                p_Key_id_out;
				
---------------------------------------------------------------------------------------------------------------------		

 If commonmasters.pkg_environment.is_development = ok Or commonmasters.pkg_environment.is_staging = ok Then
            --p_message_type := ok;
            --p_message_text := 'Success';
            null;
        Elsif commonmasters.pkg_environment.is_production = ok Then
            --p_message_type := not_ok;
            --p_message_text := 'Error...';
            return;
        End If;
		
---------------------------------------------------------------------------------------------------------------------
BEGIN
PKG_OBJ_GRANTS_TO_ORCL_USERS.EXECUTE_GRANTS();
--rollback; 
END;
---------------------------------------------------------------------------------------------------------------------		
Select * from user_errors;
---------------------------------------------------------------------------------------------------------------------		
PRC_ for Private Store Procedure
FRC_ for Private Function  

---------------------------------------------------------------------------------------------------------------------		
---------------------------------------------------------------------------------------------------------------------		
---------------------------------------------------------------------------------------------------------------------		
---------------------------------------------------------------------------------------------------------------------		
---------------------------------------------------------------------------------------------------------------------		
---------------------------------------------------------------------------------------------------------------------		
---------------------------------------------------------------------------------------------------------------------		
---------------------------------------------------------------------------------------------------------------------		
---------------------------------------------------------------------------------------------------------------------		
---------------------------------------------------------------------------------------------------------------------		
---------------------------------------------------------------------------------------------------------------------		
---------------------------------------------------------------------------------------------------------------------		
---------------------------------------------------------------------------------------------------------------------		
---------------------------------------------------------------------------------------------------------------------		
---------------------------------------------------------------------------------------------------------------------		
---------------------------------------------------------------------------------------------------------------------		
---------------------------------------------------------------------------------------------------------------------		
---------------------------------------------------------------------------------------------------------------------		

----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------

----------------------------------------------------------


----------------------------------------------------------
