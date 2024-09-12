using DocumentFormat.OpenXml.Drawing;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.Attendance;
using TCMPLApp.DataAccess.Repositories.Common;
using TCMPLApp.DataAccess.Repositories.ReportSiteMap;
using TCMPLApp.DataAccess.Repositories.SWPVaccine;
using TCMPLApp.Domain.Models.ReportSiteMap;
using TCMPLApp.Domain.Models.SelfService;
using TCMPLApp.WebApp.Classes;
using TCMPLApp.WebApp.Controllers;
using TCMPLApp.WebApp.CustomPolicyProvider;
using TCMPLApp.WebApp.Models;

namespace TCMPLApp.WebApp.Areas.SelfService.Controllers
{
    [Authorize]
    [Area("SelfService")]
    public class HomeController : BaseController
    {
        private const string ConstFilterActionMapData = "ActionMapData";
        private const string ConstSelfServiceModuleId = "M04";

        private readonly IAttendanceDeskDetailsRepository _attendanceDeskDetailsRepository;
        private readonly IAttendancePrintLogDataTableListRepository _attendancePrintLogDataTableListRepository;
        private readonly IAttendanceEmployeeDetailsRepository _attendanceEmployeeDetailsRepository;
        private readonly IFilterRepository _filterRepository;
        private readonly IUtilityRepository _utilityRepository;
        private readonly IReportSiteMapDataTableListRepository _reportSiteMapDataTableListRepository;
        private readonly IReportSiteMapFilterRepository _reportSiteMapParameterRepository;
        private readonly IRepSiteMapDataTableListRepository _repSiteMapDataTableListRepository;
        private readonly ISiteMapActionDetailsRepository _siteMapActionDetailsRepository;
        private readonly ISelectTcmPLRepository _selectTcmPLRepository;
        public HomeController(IAttendanceDeskDetailsRepository attendanceDeskDetailsRepository,
            IAttendancePrintLogDataTableListRepository attendancePrintLogDataTableListRepository,
            IAttendanceEmployeeDetailsRepository attendanceEmployeeDetailsRepository,
            IFilterRepository filterRepository,
            IUtilityRepository utilityRepository,
            IReportSiteMapDataTableListRepository reportSiteMapDataTableListRepository,
            IReportSiteMapFilterRepository reportSiteMapParameterRepository,
            IRepSiteMapDataTableListRepository repSiteMapDataTableListRepository,
            ISiteMapActionDetailsRepository siteMapActionDetailsRepository,
            ISelectTcmPLRepository selectTcmPLRepository) : base(
            )
        {
            _attendanceDeskDetailsRepository = attendanceDeskDetailsRepository;
            _attendancePrintLogDataTableListRepository = attendancePrintLogDataTableListRepository;
            _attendanceEmployeeDetailsRepository = attendanceEmployeeDetailsRepository;
            _filterRepository = filterRepository;
            _utilityRepository = utilityRepository;
            _reportSiteMapDataTableListRepository = reportSiteMapDataTableListRepository;
            _reportSiteMapParameterRepository = reportSiteMapParameterRepository;
            _repSiteMapDataTableListRepository = repSiteMapDataTableListRepository;
            _siteMapActionDetailsRepository = siteMapActionDetailsRepository;
            _selectTcmPLRepository = selectTcmPLRepository;
        }

        public async Task<IActionResult> Index()
        {

            var resultDeskDetails = await _attendanceDeskDetailsRepository.EmployeeDeskDetailsAsync(BaseSpTcmPLGet(), null);
            ViewData["DeskDetails"] = resultDeskDetails;

            var selfDetail = await _attendanceEmployeeDetailsRepository.AttendanceEmployeeDetailsAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            if (selfDetail.Emptype == "S" || selfDetail.EmpGrade.StartsWith("X"))
            {
                ViewData["EligibleForExtraHours"] = NotOk;
            }
            else
            {
                ViewData["EligibleForExtraHours"] = IsOk;
            }




            //var resultPrintLog7DaySummary = await _attendancePrintLogDataTableListRepository.Get7DaySummary(BaseSpTcmPLGet(), null);
            //ViewData["PrintLog7DaySummary"] = resultPrintLog7DaySummary;

            return View();
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleLead)]
        public IActionResult ApprovalsLeadIndex()
        {
            return View();
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleManagerHoD)]
        public IActionResult ApprovalsHoDIndex()
        {
            return View();
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleManagerHoDOnBeHalf)]
        public IActionResult ApprovalsOnBeHalfIndex()
        {
            return View();
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleAttendanceAdmin)]
        public IActionResult ActionsHRIndex()
        {
            return View();
        }


        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult ReportExcelDownload(DateTime startdate, DateTime enddate, DateTime date1, string singleline, string multiline)
        {
            long timeStamp = DateTime.Now.ToFileTime();
            string fileName = "Report Details_" + timeStamp.ToString();
            string reportTitle = "Report Details ";
            string sheetName = "Report Details";

            string strUser = User.Identity.Name;
            var data = "";


            if (data == null || data.Count() == 0) { throw new Exception("No Data Found"); }

            byte[] byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(data, reportTitle, sheetName);

            return File(byteContent, "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", fileName + ".xlsx");
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SelfServiceHelper.ActionViewHRReportsGeneral)]
        public async Task<IActionResult> ActionMapIndex()
        {
            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterActionMapData
            });

            ActionMapDataViewModel ActionMapDataViewModel = new ActionMapDataViewModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                ActionMapDataViewModel.FilterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            return View(ActionMapDataViewModel);
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SelfServiceHelper.ActionViewHRReportsGeneral)]
        public async Task<IActionResult> ActionParameters(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var reportFields = await _siteMapActionDetailsRepository.ActionDetailsAsync(BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PActionId = id,
                    PModuleId = ConstSelfServiceModuleId,
                    PSitemapId = "SM001"
                }
                );
            SiteMapFilterFieldsViewModel siteMapFilterFieldsViewModel = new SiteMapFilterFieldsViewModel
            {
                ActionDesc = reportFields.PActionDescription,
                ActionName = reportFields.PActionName,
                ControllerArea = reportFields.PControllerArea,
                ControllerMethod = reportFields.PControllerMethod,
                ControllerName = reportFields.PControllerName,
                FilterFormFields = reportFields.PFilterFormFields,
                RequestMethodType = reportFields.PControllerMethod

            };
            
            if (siteMapFilterFieldsViewModel.FilterFormFields.Any(field => field.FieldId == "F0012"))
            {
                ViewData["ListF0012"] = GetDropDownList(siteMapFilterFieldsViewModel.FilterFormFields, "F0012");
            }

            if (siteMapFilterFieldsViewModel.FilterFormFields.Any(field => field.FieldId == "F0013"))
            {
                ViewData["ListF0013"] = GetDropDownList(siteMapFilterFieldsViewModel.FilterFormFields, "F0013");
            }

            //if (siteMapFilterFieldsViewModel.FilterFormFields.Any(field => field.ControllerMethodParamName == "approvalFrom"))
            //{
            //    var ondutyApprovalsList = _selectTcmPLRepository.GetSelfServiceApprovalsList();
            //    ViewData["SiteMapDropdownList"] = new SelectList(ondutyApprovalsList, "DataValueField", "DataTextField");
            //}

            return PartialView("_ModalActionParameter", siteMapFilterFieldsViewModel);
        }

        private object GetDropDownList(IEnumerable<SiteMapFilterFormFields> filterFormFields, string fieldId)
        {

            if (filterFormFields.Any(field => field.ControllerMethodParamName == "approvalFrom") && filterFormFields.Any(field => field.FieldId == fieldId))
            {
                var dropdownList = _selectTcmPLRepository.GetSelfServiceApprovalsList();
                return new SelectList(dropdownList, "DataValueField", "DataTextField");
            }
            else
            {
                return null; 
            }
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SelfServiceHelper.ActionViewHRReportsGeneral)]
        public async Task<JsonResult> GetActionSiteMapData()
        {
            string retVal = string.Empty;
            try
            {
                var data = await _repSiteMapDataTableListRepository.RepSiteMapDataTableListForExcelAsync(
            BaseSpTcmPLGet(),
            new ParameterSpTcmPL
            {
                PModuleId = ConstSelfServiceModuleId,
                PSitemapId = "SM001"
            });
                foreach (System.Data.DataColumn col in data.Columns)
                {
                    col.ColumnName = StringHelper.TitleCase(col.ColumnName.ToLower().Replace("_", " ")).Replace(" ", "");
                }
                foreach (DataRow dr in data.Rows)
                {
                    if (dr["IsLeaf"].ToString() == "1")
                    {
                        dr["ActionUrl"] = Url.Action(dr["ControllerMethod"].ToString(), dr["ControllerName"].ToString(), new { Area = dr["ControllerArea"].ToString() });
                        dr["FilterPopupUrl"] = Url.Action("ActionParameters", "Home", new { Area = "SelfService" });
                    }
                }
                retVal = JsonConvert.SerializeObject(data);

                //throw new Exception("Testing json exception");
                return Json(retVal);
            }
            catch (Exception ex)
            {
                throw new CustomJsonException(ex.Message, ex);
            }

        }



    }
}