using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using System.Threading.Tasks;
using System;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.Common;
using TCMPLApp.Library.Excel.Template;
using TCMPLApp.WebApp.Controllers;
using TCMPLApp.WebApp.Models;
using TCMPLApp.WebApp.Services;
using Newtonsoft.Json;
using TCMPLApp.DataAccess.Repositories.Timesheet;
using TCMPLApp.Domain.Models.Timesheet;
using static TCMPLApp.WebApp.Classes.DTModel;
using System.Linq;
using MimeTypes;
using ClosedXML.Excel;
using System.Collections.Generic;
using Microsoft.AspNetCore.Mvc.Rendering;
using System.Net;
using TCMPLApp.WebApp.Classes;
using TCMPLApp.DataAccess.Repositories.SWPVaccine;
using DocumentFormat.OpenXml.Drawing.Charts;
using TCMPLApp.Domain.Models.Common;
using System.Drawing;
using System.Globalization;
using TCMPLApp.WebApp.CustomPolicyProvider;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion.Internal;
using System.Runtime.Intrinsics.X86;

namespace TCMPLApp.WebApp.Areas.Timesheet.Controllers
{
    [Authorize]
    [Area("Timesheet")]
    public class TSStatusController : BaseController
    {
        private const string ConstFilterTimesheetIndex = "TimesheetCommonIndex";
        private const string ConstFilterEmployeeIndex = "EmployeeIndex";
        private const string ConstFilterDepartmentIndex = "DepartmentIndex";
        //private const string ConstFilterDepartmentIndex = "DepartmentIndex";

        private readonly IConfiguration _configuration;
        private readonly IFilterRepository _filterRepository;
        private readonly IHttpClientRapReporting _httpClientRapReporting;
        private readonly IExcelTemplate _excelTemplate;
        private readonly ISelectTcmPLRepository _selectTcmPLRepository;
        private readonly ITimesheetStatusDataTableListRepository _timesheetStatusDataTableListRepository;
        private readonly ITimesheetStatusDataTableListExcelRepository _timesheetStatusDataTableListExcelRepository;
        private readonly ITimesheetDepartmentStatusRepository _timesheetDepartmentStatusRepository;
        private readonly ITimesheetEmployeeStatusRepository _timesheetEmployeeStatusRepository;
        private readonly ITimesheetStatusPartialDataTableListRepository _timesheetStatusPartialDataTableListRepository;
        private readonly ITimesheetProjectDataTableListRepository _timesheetProjectDataTableListRepository;
        private readonly ITimesheetProjectDataTableExcelRepository _timesheetProjectDataTableExcelRepository;
        private readonly ITimesheetDepartmentDataTableListExcelRepository _timesheetDepartmentDataTableListExcelRepository;
        private readonly ITimesheetDepartmentRepository _timesheetDepartmentRepository;
        private readonly ITimesheetPartialStatusDataTableListExcelRepository _timesheetPartialStatusDataTableListExcelRepository;
        private readonly ITimesheetReminderEmailRepository _timesheetReminderEmailRepository;
        private readonly IUtilityRepository _utilityRepository;
        private readonly ITimesheetStatusEmployeeCountDataTableListRepository _timesheetStatusEmployeeCountDataTableListRepository;
        private readonly ITimesheetWrkHourCountRepository _timesheetWrkHourCountRepository;
        private readonly ITimesheetFreezeStatusRepository _timesheetFreezeStatusRepository;

        public TSStatusController(IConfiguration configuration,
                             IFilterRepository filterRepository,
                             IHttpClientRapReporting httpClientRapReporting,
                             IExcelTemplate excelTemplate,
                             ISelectTcmPLRepository selectTcmPLRepository,
                             ITimesheetStatusDataTableListRepository timesheetStatusDataTableListRepository,
                             ITimesheetStatusDataTableListExcelRepository timesheetStatusDataTableListExcelRepository,
                             ITimesheetDepartmentStatusRepository timesheetDepartmentStatusRepository,
                             ITimesheetEmployeeStatusRepository timesheetEmployeeStatusRepository,
                             ITimesheetStatusPartialDataTableListRepository timesheetStatusPartialDataTableListRepository,
                             ITimesheetProjectDataTableListRepository timesheetProjectDataTableListRepository,
                             ITimesheetProjectDataTableExcelRepository timesheetProjectDataTableExcelRepository,
                             IUtilityRepository utilityRepository,
                             ITimesheetDepartmentDataTableListExcelRepository timesheetDepartmentDataTableListExcelRepository,
                             ITimesheetDepartmentRepository timesheetDepartmentRepository,
                             ITimesheetPartialStatusDataTableListExcelRepository timesheetPartialStatusDataTableListExcelRepository,
                             ITimesheetReminderEmailRepository timesheetReminderEmailRepository,
                             ITimesheetStatusEmployeeCountDataTableListRepository timesheetStatusEmployeeCountDataTableListRepository,
                             ITimesheetWrkHourCountRepository timesheetWrkHourCountRepository,
                             ITimesheetFreezeStatusRepository timesheetFreezeStatusRepository
                             )
        {
            _configuration = configuration;
            _filterRepository = filterRepository;
            _httpClientRapReporting = httpClientRapReporting;
            _excelTemplate = excelTemplate;
            _selectTcmPLRepository = selectTcmPLRepository;
            _timesheetStatusDataTableListRepository = timesheetStatusDataTableListRepository;
            _timesheetStatusDataTableListExcelRepository = timesheetStatusDataTableListExcelRepository;
            _timesheetDepartmentStatusRepository = timesheetDepartmentStatusRepository;
            _timesheetEmployeeStatusRepository = timesheetEmployeeStatusRepository;
            _timesheetStatusPartialDataTableListRepository = timesheetStatusPartialDataTableListRepository;
            _utilityRepository = utilityRepository;
            _timesheetProjectDataTableListRepository = timesheetProjectDataTableListRepository;
            _timesheetProjectDataTableExcelRepository = timesheetProjectDataTableExcelRepository;
            _timesheetDepartmentDataTableListExcelRepository = timesheetDepartmentDataTableListExcelRepository;
            _timesheetDepartmentRepository = timesheetDepartmentRepository;
            _timesheetPartialStatusDataTableListExcelRepository = timesheetPartialStatusDataTableListExcelRepository;
            _timesheetReminderEmailRepository = timesheetReminderEmailRepository;
            _timesheetStatusEmployeeCountDataTableListRepository = timesheetStatusEmployeeCountDataTableListRepository;
            _timesheetWrkHourCountRepository = timesheetWrkHourCountRepository;
            _timesheetFreezeStatusRepository = timesheetFreezeStatusRepository;
        }

        #region Employee wise timesheet status ---------- 

        #region STATUS

        // Timesheet STATUS employee list
        public async Task<IActionResult> EmployeeIndex(string yymm)
        {
            if (!(CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TimesheetHelper.ActionDeptTimesheet) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TimesheetHelper.ActionAllEmployeeTimesheetReport)))
            {
                return Forbid();
            }

            TimesheetEmployeeIndexViewModel timesheetEmployeeViewModel = new TimesheetEmployeeIndexViewModel();

            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterTimesheetIndex
            });

            FilterDataModel filterDataModel;

            if (string.IsNullOrEmpty(retVal.OutPFilterJson))
                return NotFound();
            else
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            timesheetEmployeeViewModel.FilterDataModel = filterDataModel;

            TSWrkHourCount wrkhoursmodel = await _timesheetWrkHourCountRepository.MonthlyWrkHourCountAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PYymm = filterDataModel.Yyyymm
                    });

            TSFreezeStatus tsFreezeStatus = await _timesheetFreezeStatusRepository.FreezeStatusAsync(
                    BaseSpTcmPLGet(),
                    null);

            ViewData["IsTSFreeze"] = tsFreezeStatus.PStatus;
            ViewData["Yyyy"] = filterDataModel.Yyyy;
            ViewData["Yyyymm"] = filterDataModel.Yyyymm;
            ViewData["WrkHours"] = wrkhoursmodel.PWrkHours;

            return View(timesheetEmployeeViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsTimesheetStatus(string paramJSon)
        {
            DTResult<TSStatusDataTableList> result = new();
            int totalRow = 0;

            var strActionId = string.Empty;

            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TimesheetHelper.ActionDeptTimesheet))
            {
                strActionId = TimesheetHelper.ActionDeptTimesheet;
            }

            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TimesheetHelper.ActionAllEmployeeTimesheetReport))
            {
                strActionId = TimesheetHelper.ActionAllEmployeeTimesheetReport;
            }

            try
            {
                DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJSon);

                IEnumerable<TSStatusDataTableList> data = await _timesheetStatusDataTableListRepository.EmployeeStatusDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch ?? " ",
                        PActionId = strActionId ?? " ",
                        PYymm = param.yymm,
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

        #endregion STATUS

        #region LOCKED

        // Timesheet LOCKED employee list
        public async Task<IActionResult> EmployeeLockedIndex()
        {
            TSStatusDataTableList lockedDataTableList = new TSStatusDataTableList();

            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterTimesheetIndex
            });

            FilterDataModel filterDataModel;

            if (string.IsNullOrEmpty(retVal.OutPFilterJson))
                return NotFound();
            else
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            TSWrkHourCount wrkhoursmodel = await _timesheetWrkHourCountRepository.MonthlyWrkHourCountAsync(
                   BaseSpTcmPLGet(),
                   new ParameterSpTcmPL
                   {
                       PYymm = filterDataModel.Yyyymm
                   });

            ViewData["Yyyy"] = filterDataModel.Yyyy;
            ViewData["Yyyymm"] = filterDataModel.Yyyymm;
            ViewData["WrkHours"] = wrkhoursmodel.PWrkHours;           

            return PartialView("_EmployeeLockedListPartial", lockedDataTableList);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsTimesheetLocked(string paramJSon)
        {
            DTResult<TSStatusDataTableList> result = new();
            int totalRow = 0;

            var strActionId = string.Empty;

            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TimesheetHelper.ActionDeptTimesheet))
            {
                strActionId = TimesheetHelper.ActionDeptTimesheet;
            }

            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TimesheetHelper.ActionAllEmployeeTimesheetReport))
            {
                strActionId = TimesheetHelper.ActionAllEmployeeTimesheetReport;
            }

            try
            {
                DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJSon);

                IEnumerable<TSStatusDataTableList> data = await _timesheetStatusDataTableListRepository.EmployeeLockedDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch ?? " ",
                        PActionId = strActionId ?? " ",
                        PYymm = param.yymm,
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

        #endregion LOCKED

        #region APPROVED

        // Timesheet APPROVED employee list
        public async Task<IActionResult> EmployeeApprovedIndex()
        {
            TSStatusDataTableList approvedDataTableList = new TSStatusDataTableList();

            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterTimesheetIndex
            });

            FilterDataModel filterDataModel;

            if (string.IsNullOrEmpty(retVal.OutPFilterJson))
                return NotFound();
            else
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            TSWrkHourCount wrkhoursmodel = await _timesheetWrkHourCountRepository.MonthlyWrkHourCountAsync(
                   BaseSpTcmPLGet(),
                   new ParameterSpTcmPL
                   {
                       PYymm = filterDataModel.Yyyymm
                   });

            ViewData["Yyyy"] = filterDataModel.Yyyy;
            ViewData["Yyyymm"] = filterDataModel.Yyyymm;
            ViewData["WrkHours"] = wrkhoursmodel.PWrkHours;

            return PartialView("_EmployeeApprovedListPartial", approvedDataTableList);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsTimesheetApproved(string paramJSon)
        {
            DTResult<TSStatusDataTableList> result = new();
            int totalRow = 0;

            var strActionId = string.Empty;

            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TimesheetHelper.ActionDeptTimesheet))
            {
                strActionId = TimesheetHelper.ActionDeptTimesheet;
            }

            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TimesheetHelper.ActionAllEmployeeTimesheetReport))
            {
                strActionId = TimesheetHelper.ActionAllEmployeeTimesheetReport;
            }

            try
            {
                DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJSon);

                IEnumerable<TSStatusDataTableList> data = await _timesheetStatusDataTableListRepository.EmployeeApprovedDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch ?? " ",
                        PActionId = strActionId ?? " ",
                        PYymm = param.yymm,
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


        #endregion APPROVED

        #region POSTED

        // Timesheet POSTED employee list
        public async Task<IActionResult> EmployeePostedIndex()
        {
            TSStatusDataTableList postedDataTableList = new TSStatusDataTableList();

            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterTimesheetIndex
            });

            FilterDataModel filterDataModel;

            if (string.IsNullOrEmpty(retVal.OutPFilterJson))
                return NotFound();
            else
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            TSWrkHourCount wrkhoursmodel = await _timesheetWrkHourCountRepository.MonthlyWrkHourCountAsync(
                   BaseSpTcmPLGet(),
                   new ParameterSpTcmPL
                   {
                       PYymm = filterDataModel.Yyyymm
                   });

            ViewData["Yyyy"] = filterDataModel.Yyyy;
            ViewData["Yyyymm"] = filterDataModel.Yyyymm;
            ViewData["WrkHours"] = wrkhoursmodel.PWrkHours;

            return PartialView("_EmployeePostedListPartial", postedDataTableList);

        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsTimesheetPosted(string paramJSon)
        {
            DTResult<TSStatusDataTableList> result = new();
            int totalRow = 0;

            var strActionId = string.Empty;

            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TimesheetHelper.ActionDeptTimesheet))
            {
                strActionId = TimesheetHelper.ActionDeptTimesheet;
            }

            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TimesheetHelper.ActionAllEmployeeTimesheetReport))
            {
                strActionId = TimesheetHelper.ActionAllEmployeeTimesheetReport;
            }

            try
            {
                DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJSon);

                IEnumerable<TSStatusDataTableList> data = await _timesheetStatusDataTableListRepository.EmployeePostedDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch ?? " ",
                        PActionId = strActionId ?? " ",
                        PYymm = param.yymm,
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

        #endregion POSTED

        #region NOT FILLED

        // Timesheet NOT FILLED employee list
        public async Task<IActionResult> EmployeeNotfilledIndex()
        {
            TSStatusDataTableList notfilledDataTableList = new TSStatusDataTableList();

            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterTimesheetIndex
            });

            FilterDataModel filterDataModel;

            if (string.IsNullOrEmpty(retVal.OutPFilterJson))
                return NotFound();
            else
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            TSWrkHourCount wrkhoursmodel = await _timesheetWrkHourCountRepository.MonthlyWrkHourCountAsync(
                   BaseSpTcmPLGet(),
                   new ParameterSpTcmPL
                   {
                       PYymm = filterDataModel.Yyyymm
                   });

            ViewData["Yyyy"] = filterDataModel.Yyyy;
            ViewData["Yyyymm"] = filterDataModel.Yyyymm;
            ViewData["WrkHours"] = wrkhoursmodel.PWrkHours;

            return PartialView("_EmployeeNotfilledListPartial", notfilledDataTableList);

        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsTimesheetNotfilled(string paramJSon)
        {
            DTResult<TSStatusDataTableList> result = new();
            int totalRow = 0;

            var strActionId = string.Empty;

            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TimesheetHelper.ActionDeptTimesheet))
            {
                strActionId = TimesheetHelper.ActionDeptTimesheet;
            }

            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TimesheetHelper.ActionAllEmployeeTimesheetReport))
            {
                strActionId = TimesheetHelper.ActionAllEmployeeTimesheetReport;
            }

            try
            {
                DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJSon);

                IEnumerable<TSStatusDataTableList> data = await _timesheetStatusDataTableListRepository.EmployeeNotfilledDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch ?? " ",
                        PActionId = strActionId ?? " ",
                        PYymm = param.yymm,
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

        #endregion NOT FILLED

        #region STATUS UPDATE

        [HttpPost]
        public async Task<IActionResult> TimeSheetStatusUpdate(string id)
        {
            if (!(CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TimesheetHelper.ActionDeptTimesheet) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TimesheetHelper.ActionAllEmployeeTimesheetReport)))
            {
                return Forbid();
            }

            if (id == null)
                return NotFound();

            var empno = id.Split("!-!")[0];
            var yymm = id.Split("!-!")[1];
            var costcode = id.Split("!-!")[2];
            var updatetype = id.Split("!-!")[3];
            var emptype = id.Split("!-!")[4];


            try
            {

                var result = await _timesheetEmployeeStatusRepository.TimeSheetStatusUpdateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PEmpno = empno,
                            PYymm = yymm,
                            PCostcode = costcode,
                            PUpdateType = updatetype,
                            PEmpType = emptype
                        }
                    );

                if (result.PMessageType != IsOk)
                {
                    if (result.PMessageText.ToString() == "Timesheet in-use")
                    {
                        return Json(ResponseHelper.GetMessageObject(result.PMessageText, NotificationType.warning));
                    }
                    else
                    {
                        return Json(ResponseHelper.GetMessageObject(result.PMessageText, NotificationType.error));
                    }                    
                }
                else
                {
                    return Json(ResponseHelper.GetMessageObject(result.PMessageText, NotificationType.success));
                }
            }
            catch (Exception ex)
            {                
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        #endregion STATUSUPDATE

        #region STATUS DOWNLOAD

        [HttpGet]
        public async Task<IActionResult> TimesheetStatusDownload(string id)
        {
            if (id == null)
                return NotFound();

            var yymm = id.Split("!-!")[0];
            var tabname = id.Split("!-!")[1];
            var strSearch = id.Split("!-!")[2]?.ToString();

            string StrFimeName;

            var timeStamp = System.DateTime.Now.ToFileTime();
            StrFimeName = "Timesheet_" + tabname.ToUpper() + "_" + timeStamp.ToString();

            try
            {
                var strActionId = string.Empty;

                if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TimesheetHelper.ActionDeptTimesheet))
                {
                    strActionId = TimesheetHelper.ActionDeptTimesheet;
                }

                if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TimesheetHelper.ActionAllEmployeeTimesheetReport))
                {
                    strActionId = TimesheetHelper.ActionAllEmployeeTimesheetReport;
                }

                IEnumerable<TSStatusDataTableListExcel> data;

                switch (tabname.ToUpper())
                {
                    case "LOCKED":
                        data = await _timesheetStatusDataTableListExcelRepository.EmployeeLockedDataTableListExcelAsync(
                            BaseSpTcmPLGet(),
                            new ParameterSpTcmPL
                            {
                                PGenericSearch = strSearch ?? " ",
                                PActionId = strActionId ?? " ",
                                PYymm = yymm
                            }
                        );
                        break;
                    case "APPROVED":
                        data = await _timesheetStatusDataTableListExcelRepository.EmployeeApprovedDataTableListExcelAsync(
                            BaseSpTcmPLGet(),
                            new ParameterSpTcmPL
                            {
                                PGenericSearch = strSearch ?? " ",
                                PActionId = strActionId ?? " ",
                                PYymm = yymm
                            }
                        );
                        break;
                    case "POSTED":
                        data = await _timesheetStatusDataTableListExcelRepository.EmployeePostedDataTableListExcelAsync(
                            BaseSpTcmPLGet(),
                            new ParameterSpTcmPL
                            {
                                PGenericSearch = strSearch ?? " ",
                                PActionId = strActionId ?? " ",
                                PYymm = yymm
                            }
                        );
                        break;
                    case "NOTFILLED":
                        data = await _timesheetStatusDataTableListExcelRepository.EmployeeNotfilledDataTableListExcelAsync(
                            BaseSpTcmPLGet(),
                            new ParameterSpTcmPL
                            {
                                PGenericSearch = strSearch ?? " ",
                                PActionId = strActionId ?? " ",
                                PYymm = yymm
                            }
                        );
                        break;
                    default:
                        data = await _timesheetStatusDataTableListExcelRepository.EmployeeStatusDataTableListExcelAsync(
                            BaseSpTcmPLGet(),
                            new ParameterSpTcmPL
                            {
                                PGenericSearch = strSearch ?? " ",
                                PActionId = strActionId ?? " ",
                                PYymm = yymm
                            }
                        );
                        break;
                }

                if (data == null) { return NotFound(); }

                var json = JsonConvert.SerializeObject(data);

                IEnumerable<TSStatusDataTableListExcel> excelData = JsonConvert.DeserializeObject<IEnumerable<TSStatusDataTableListExcel>>(json);

                byte[] byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, "TimesheetStatus : " + tabname, tabname.ToUpper());

                var mimeType = MimeTypeMap.GetMimeType("xlsx");

                FileContentResult file = File(byteContent, mimeType, StrFimeName);

                return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        #endregion STATUS DOWNLOAD 

        #region EMPLOYEE PROJECT BREAKUP

        public async Task<IActionResult> TimeSheetProjectBreakupPartial(string id)
        {
            if (id == null)
                return NotFound();

            var empno = id.Split("!-!")[0]?.ToString();
            var yymm = id.Split("!-!")[1]?.ToString();
            var costcode = id.Split("!-!")[2]?.ToString();

            if (empno == null || yymm == null || costcode == null)
                return NotFound();

            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterTimesheetIndex
            });

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            TimesheetProjectIndexViewModel timesheetProjectViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            TSWrkHourCount wrkhoursmodel = await _timesheetWrkHourCountRepository.MonthlyWrkHourCountAsync(
                   BaseSpTcmPLGet(),
                   new ParameterSpTcmPL
                   {
                       PYymm = filterDataModel.Yyyymm
                   });

            ViewData["Yyyymm"] = yymm;
            ViewData["Empno"] = empno;
            ViewData["Costcode"] = costcode;
            ViewData["WrkHours"] = wrkhoursmodel.PWrkHours;

            return PartialView("_ModalEmployeeProjectListPartial", timesheetProjectViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsEmployeeProjectPartial(string paramJSon)
        {
            DTResult<TSProjectDataTableList> result = new();
            int totalRow = 0;

            try
            {
                DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJSon);

                IEnumerable<TSProjectDataTableList> data = await _timesheetProjectDataTableListRepository.EmployeewiseProjectTimesheetDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch ?? " ",
                        PYymm = param.yymm,
                        PEmpno = param.Empno,
                        PCostcode = param.Costcode,
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



        #endregion EMPLOYEE PROJECT BREAKUP

        #endregion Employee wise timesheet status ---------- 


        #region Department wise (bulk) timesheet status ---------- 

        public async Task<IActionResult> DepartmentIndex(string costcode)
        {
            if (!(CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TimesheetHelper.ActionDeptTimesheet) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TimesheetHelper.ActionAllEmployeeTimesheetReport)))
            {
                return Forbid();
            }

            TimesheetDepartmentIndexViewModel timesheetDepartmentViewModel = new TimesheetDepartmentIndexViewModel();

            string defaultCostcode = string.Empty;

            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterTimesheetIndex
            });

            FilterDataModel filterDataModel;

            if (string.IsNullOrEmpty(retVal.OutPFilterJson))
                return NotFound();
            else
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TimesheetHelper.ActionDeptTimesheet))
            {
                var costCodes = await _selectTcmPLRepository.TSOSCMhrsCostcodeList(BaseSpTcmPLGet(), null);
                defaultCostcode = costcode == null ? costCodes.FirstOrDefault().DataValueField?.ToString() : costcode?.ToString();
                ViewData["CostCodes"] = new SelectList(costCodes, "DataValueField", "DataTextField", defaultCostcode);
            }

            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TimesheetHelper.ActionAllEmployeeTimesheetReport))
            {
                var costCodes = await _selectTcmPLRepository.SelectCostCodeRapReportingProco(BaseSpTcmPLGet(), null);
                defaultCostcode = costcode == null ? costCodes.FirstOrDefault().DataValueField?.ToString() : costcode?.ToString();
                ViewData["CostCodes"] = new SelectList(costCodes, "DataValueField", "DataTextField", defaultCostcode);
            }

            var result = await _timesheetDepartmentStatusRepository.DepartmentStatusDetailAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PCostcode = defaultCostcode?.ToString(),
                            PYymm = filterDataModel.Yyyymm?.ToString()
                        });

            if (result.PMessageType != IsOk)
            {
                //Notify("Error", result.PMessageText.Replace("-", " "), "toaster", NotificationType.error);
                return Json(new { error = true, response = result.PMessageText });
            }

            timesheetDepartmentViewModel.PWrkHours = result.PWrkHours;
            timesheetDepartmentViewModel.PProcessMonth = result.PProcessMonth;
            timesheetDepartmentViewModel.PSubmitCount = result.PSubmitCount;
            timesheetDepartmentViewModel.POddCount = result.POddCount;
            timesheetDepartmentViewModel.POutsourceCount = result.POutsourceCount;
            timesheetDepartmentViewModel.PTotalCount = result.PTotalCount;
            timesheetDepartmentViewModel.PFilled = result.PFilled;
            timesheetDepartmentViewModel.PFilledNhr = result.PFilledNhr;
            timesheetDepartmentViewModel.PFilledOhr = result.PFilledOhr;
            timesheetDepartmentViewModel.PFilledOuthr = result.PFilledOuthr;
            timesheetDepartmentViewModel.PFilledThr = result.PFilledThr;
            timesheetDepartmentViewModel.PApproved = result.PApproved;
            timesheetDepartmentViewModel.PApprovedNhr = result.PApprovedNhr;
            timesheetDepartmentViewModel.PApprovedOhr = result.PApprovedOhr;
            timesheetDepartmentViewModel.PApprovedOuthr = result.PApprovedOuthr;
            timesheetDepartmentViewModel.PApprovedThr = result.PApprovedThr;
            timesheetDepartmentViewModel.PLocked = result.PLocked;
            timesheetDepartmentViewModel.PLockedNhr = result.PLockedNhr;
            timesheetDepartmentViewModel.PLockedOhr = result.PLockedOhr;
            timesheetDepartmentViewModel.PLockedOuthr = result.PLockedOuthr;
            timesheetDepartmentViewModel.PLockedThr = result.PLockedThr;           
            timesheetDepartmentViewModel.PPosted = result.PPosted;
            timesheetDepartmentViewModel.PPostedNhr = result.PPostedNhr;
            timesheetDepartmentViewModel.PPostedOhr = result.PPostedOhr;
            timesheetDepartmentViewModel.PPostedOuthr = result.PPostedOuthr;
            timesheetDepartmentViewModel.PPostedThr = result.PPostedThr;
            timesheetDepartmentViewModel.FilterDataModel = filterDataModel;

            TSFreezeStatus tsFreezeStatus = await _timesheetFreezeStatusRepository.FreezeStatusAsync(
                    BaseSpTcmPLGet(),
                    null);

            ViewData["IsTSFreeze"] = tsFreezeStatus.PStatus;
            ViewData["Yyyy"] = filterDataModel.Yyyy;
            ViewData["Yyyymm"] = filterDataModel.Yyyymm;
            ViewData["DefaultCostcode"] = defaultCostcode;
            ViewData["ProcMnthStatus"] = filterDataModel.Yyyymm == result.PProcessMonth ? "IsVisible" : "IsHidden";

            string monthYear = DateTime.ParseExact(filterDataModel.Yyyymm?.ToString(), "yyyyMM", CultureInfo.CurrentCulture).ToString("MMM-yyyy");

            ViewData["MonthYear"] = monthYear;

            return View(timesheetDepartmentViewModel);
        }

        public async Task<IActionResult> EmployeeCountPartialIndex(string id, string parameter)
        {
            if (id == null)
                return NotFound();

            var yymm = id.Split("!-!")[0];
            var costcode = id.Split("!-!")[1];

            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterTimesheetIndex
            });

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            TimesheetEmployeeCountIndexViewModel employeeCountPartial = new()
            {
                FilterDataModel = filterDataModel
            };

            ViewData["Costcode"] = costcode;
            ViewData["Yyyymm"] = yymm;
            ViewData["ActualHours"] = parameter;

            return PartialView("_ModalEmployeeCountIndexPartial", employeeCountPartial);
        }

        public async Task<IActionResult> FilledPartialIndex(string id, string parameter)
        {
            if (id == null)
                return NotFound();

            var yymm = id.Split("!-!")[0];
            var costcode = id.Split("!-!")[1];
            var procmnthview = id.Split("!-!")[2];

            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterTimesheetIndex
            });

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            TimesheetStatusPartialIndexViewModel timesheetStatusPartial = new()
            {
                FilterDataModel = filterDataModel
            };

            //TimesheetStatusPartialIndexViewModel timesheetStatusPartial = new TimesheetStatusPartialIndexViewModel();

            timesheetStatusPartial.FilterDataModel.StatusString = "Filled";

            TSFreezeStatus tsFreezeStatus = await _timesheetFreezeStatusRepository.FreezeStatusAsync(
                    BaseSpTcmPLGet(),
                    null);

            ViewData["IsTSFreeze"] = tsFreezeStatus.PStatus;
            ViewData["Costcode"] = costcode;
            ViewData["Yyyymm"] = yymm;
            ViewData["ActualHours"] = parameter;
            ViewData["ProcMnthStatus"] = procmnthview;

            return PartialView("_ModalFilledIndexPartial", timesheetStatusPartial);
        }

        public async Task<IActionResult> LockedPartialIndex(string id, string parameter)
        {
            if (id == null)
                return NotFound();

            var yymm = id.Split("!-!")[0];
            var costcode = id.Split("!-!")[1];
            var procmnthview = id.Split("!-!")[2];

            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterTimesheetIndex
            });

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            TimesheetStatusPartialIndexViewModel timesheetStatusPartial = new()
            {
                FilterDataModel = filterDataModel
            };

            timesheetStatusPartial.FilterDataModel.StatusString = "Locked";

            TSFreezeStatus tsFreezeStatus = await _timesheetFreezeStatusRepository.FreezeStatusAsync(
                    BaseSpTcmPLGet(),
                    null);

            ViewData["IsTSFreeze"] = tsFreezeStatus.PStatus;
            ViewData["Costcode"] = costcode;
            ViewData["Yyyymm"] = yymm;
            ViewData["ActualHours"] = parameter;
            ViewData["ProcMnthStatus"] = procmnthview;

            return PartialView("_ModalLockedIndexPartial", timesheetStatusPartial);
        }

        public async Task<IActionResult> ApprovedPartialIndex(string id, string parameter)
        {
            if (id == null)
                return NotFound();

            var yymm = id.Split("!-!")[0];
            var costcode = id.Split("!-!")[1];
            var procmnthview = id.Split("!-!")[2];

            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterTimesheetIndex
            });

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            TimesheetStatusPartialIndexViewModel timesheetStatusPartial = new()
            {
                FilterDataModel = filterDataModel
            };

            timesheetStatusPartial.FilterDataModel.StatusString = "Approved";

            var departmentStatusDetails = await _timesheetDepartmentStatusRepository.DepartmentStatusDetailAsync(
                                            BaseSpTcmPLGet(),
                                            new ParameterSpTcmPL
                                            {
                                                PCostcode = costcode.ToString(),
                                                PYymm = filterDataModel.Yyyymm?.ToString()
                                            });

            var totalCount = Convert.ToInt32("0" + departmentStatusDetails.PSubmitCount) + Convert.ToInt32("0" + departmentStatusDetails.POddCount);
            var postCount = Convert.ToInt32("0" + departmentStatusDetails.PApproved);

            if(totalCount == postCount)
            {
                ViewData["AlertMsg"] = "Do you want to POST ALL timesheet for " + costcode;
            }
            else
            {
                ViewData["AlertMsg"] = "Out of " + totalCount + " only " + postCount + " timesheets are APPROVED, still do you want to POST ALL timesheet for " + costcode;
            }

            TSFreezeStatus tsFreezeStatus = await _timesheetFreezeStatusRepository.FreezeStatusAsync(
                    BaseSpTcmPLGet(),
                    null);

            ViewData["IsTSFreeze"] = tsFreezeStatus.PStatus;
            ViewData["Costcode"] = costcode;
            ViewData["Yyyymm"] = yymm;
            ViewData["ActualHours"] = parameter;
            ViewData["ProcMnthStatus"] = procmnthview;

            return PartialView("_ModalApprovedIndexPartial", timesheetStatusPartial);
        }

        public async Task<IActionResult> PostedPartialIndex(string id, string parameter)
        {
            if (id == null)
                return NotFound();

            var yymm = id.Split("!-!")[0];
            var costcode = id.Split("!-!")[1];
            var procmnthview = id.Split("!-!")[2];

            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterTimesheetIndex
            });

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            TimesheetStatusPartialIndexViewModel timesheetStatusPartial = new()
            {
                FilterDataModel = filterDataModel
            };

            timesheetStatusPartial.FilterDataModel.StatusString = "Posted";

            TSFreezeStatus tsFreezeStatus = await _timesheetFreezeStatusRepository.FreezeStatusAsync(
                    BaseSpTcmPLGet(),
                    null);

            ViewData["IsTSFreeze"] = tsFreezeStatus.PStatus;
            ViewData["Costcode"] = costcode;
            ViewData["Yyyymm"] = yymm;
            ViewData["ActualHours"] = parameter;
            ViewData["ProcMnthStatus"] = procmnthview;

            return PartialView("_ModalPostedIndexPartial", timesheetStatusPartial);
        }

        [HttpPost]
        public async Task<IActionResult> TimesheetBulkAction(String id)
        {
            if (id == null)
                return NotFound();

            var yymm = id.Split("!-!")[0]?.ToString();
            var costcode = id.Split("!-!")[1]?.ToString();
            var statusName = id.Split("!-!")[2]?.ToString();
            var actionName = id.Split("!-!")[3]?.ToString();
            string msgText = string.Empty;

            try
            {
                var result = await _timesheetDepartmentRepository.DepartmentBulkActionAsync(
                                                                        BaseSpTcmPLGet(),
                                                                        new ParameterSpTcmPL
                                                                        {
                                                                            PYymm = yymm,
                                                                            PCostcode = costcode,
                                                                            PStatusstring = statusName,
                                                                            PActionName = actionName
                                                                        });                
                
                Notify(result.PMessageType == IsOk ? "Success" : "Warning", result.PMessageText, "", result.PMessageType == IsOk ? NotificationType.success : NotificationType.warning);

                return Json(ResponseHelper.GetMessageObject(result.PMessageText));
            }
            catch (Exception ex)
            {
                msgText = ex.Message.ToString();
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(msgText));
            }
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsPartialStatus(string paramJson)
        {
            DTResult<TSStatusPartialDataTableList> result = new();
            int totalRow = 0;
            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            IEnumerable<TSStatusPartialDataTableList> data;

            try
            {
                switch (param.Statusstring)
                {
                    case "Filled":
                        data = await _timesheetStatusPartialDataTableListRepository.FilledStatusDataTableListAsync(
                            BaseSpTcmPLGet(),
                            new ParameterSpTcmPL
                            {
                                PGenericSearch = param.GenericSearch ?? " ",
                                PYymm = param.yymm,
                                PCostcode = param.Costcode,
                                PRowNumber = param.Start,
                                PPageLength = param.Length
                            }
                        );
                        break;
                    case "Locked":
                        data = await _timesheetStatusPartialDataTableListRepository.LockedStatusDataTableListAsync(
                            BaseSpTcmPLGet(),
                            new ParameterSpTcmPL
                            {
                                PGenericSearch = param.GenericSearch ?? " ",
                                PYymm = param.yymm,
                                PCostcode = param.Costcode,
                                PRowNumber = param.Start,
                                PPageLength = param.Length
                            }
                        );
                        break;
                    case "Approved":
                        data = await _timesheetStatusPartialDataTableListRepository.ApprovedStatusDataTableListAsync(
                            BaseSpTcmPLGet(),
                            new ParameterSpTcmPL
                            {
                                PGenericSearch = param.GenericSearch ?? " ",
                                PYymm = param.yymm,
                                PCostcode = param.Costcode,
                                PRowNumber = param.Start,
                                PPageLength = param.Length
                            }
                        );
                        break;
                    case "Posted":
                        data = await _timesheetStatusPartialDataTableListRepository.PostedStatusDataTableListAsync(
                            BaseSpTcmPLGet(),
                            new ParameterSpTcmPL
                            {
                                PGenericSearch = param.GenericSearch ?? " ",
                                PYymm = param.yymm,
                                PCostcode = param.Costcode,
                                PRowNumber = param.Start,
                                PPageLength = param.Length
                            }
                        );
                        break;
                    default:
                        data = await _timesheetStatusPartialDataTableListRepository.FilledStatusDataTableListAsync(
                            BaseSpTcmPLGet(),
                            new ParameterSpTcmPL
                            {
                                PGenericSearch = param.GenericSearch ?? " ",
                                PYymm = param.yymm,
                                PCostcode = param.Costcode,
                                PRowNumber = param.Start,
                                PPageLength = param.Length
                            }
                        );
                        break;
                }

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
                return Json(new
                {
                    error = ex.Message
                });
            }
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsEmployeeCountPartial(string paramJson)
        {
            DTResult<TSEmployeeCountDataTableList> result = new();
            int totalRow = 0;
            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            try
            {

                IEnumerable<TSEmployeeCountDataTableList> data = await _timesheetStatusEmployeeCountDataTableListRepository.EmployeeCountDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch ?? " ",
                        PYymm = param.yymm,
                        PCostcode = param.Costcode,
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
                return Json(new
                {
                    error = ex.Message
                });
            }
        }

        [HttpGet]
        public async Task<IActionResult> TimesheetDepartmentDownload(string id)
        {
            if (id == null)
                return NotFound();

            var yymm = id.Split("!-!")[0]?.ToString();
            var costcode = id.Split("!-!")[1]?.ToString();
            var statusName = id.Split("!-!")[2]?.ToString();
            var strSearch = id.Split("!-!")[3]?.ToString();

            if (yymm == null || costcode == null || statusName == null)
                return NotFound();

            string StrFimeName = "Timesheet_" + statusName + "_" + costcode  + "_" + DateTime.Now.ToString("yyyyMMdd_HHmm") + ".xlsx";
            string strSheetName = costcode.ToString() + "_Timesheet_" + statusName;

            IEnumerable<TSPartialStatusDataTableListExcel> data = null;

            //TimesheetDepartmentIndexViewModel timesheetDepartmentViewModel = new TimesheetDepartmentIndexViewModel();

            try
            {
                switch (statusName)
                {
                    case "Filled":
                        data = await _timesheetPartialStatusDataTableListExcelRepository.TimesheetPartialFilledDataTableListExcelAsync(
                                            BaseSpTcmPLGet(),
                                            new ParameterSpTcmPL
                                            {
                                                PGenericSearch = strSearch ?? " ",
                                                PYymm = yymm.ToString(),
                                                PCostcode = costcode.ToString()
                                            });
                        break;
                    case "Locked":
                        StrFimeName = "Timesheet_Department_Lock_" + costcode + "_" + DateTime.Now.ToString("yyyyMMdd_HHmm") + ".xlsx";
                        strSheetName = costcode.ToString() + "_Timesheet_Lock";
                        data = await _timesheetPartialStatusDataTableListExcelRepository.TimesheetPartialLockedDataTableListExcelAsync(
                                            BaseSpTcmPLGet(),
                                            new ParameterSpTcmPL
                                            {
                                                PGenericSearch = strSearch ?? " ",
                                                PYymm = yymm.ToString(),
                                                PCostcode = costcode.ToString()
                                            });
                        break;
                    case "Approved":
                        StrFimeName = "Timesheet_Department_Approve_" + costcode + "_" + DateTime.Now.ToString("yyyyMMdd_HHmm") + ".xlsx";
                        strSheetName = costcode.ToString() + "_Timesheet_Approve";
                        data = await _timesheetPartialStatusDataTableListExcelRepository.TimesheetPartialApprovedDataTableListExcelAsync(
                                            BaseSpTcmPLGet(),
                                            new ParameterSpTcmPL
                                            {
                                                PGenericSearch = strSearch ?? " ",
                                                PYymm = yymm.ToString(),
                                                PCostcode = costcode.ToString()
                                            });
                        break;
                    case "Posted":
                        StrFimeName = "Timesheet_Department_Post_" + costcode + "_" + DateTime.Now.ToString("yyyyMMdd_HHmm") + ".xlsx";
                        strSheetName = costcode.ToString() + "_Timesheet_Post";
                        data = await _timesheetPartialStatusDataTableListExcelRepository.TimesheetPartialPostedDataTableListExcelAsync(
                                           BaseSpTcmPLGet(),
                                           new ParameterSpTcmPL
                                           {
                                               PGenericSearch = strSearch ?? " ",
                                               PYymm = yymm.ToString(),
                                               PCostcode = costcode.ToString()
                                           });
                        break;                     
                }

                if (!data.Any())
                {
                    Notify("Error", "No data exists", "toaster", notificationType: NotificationType.error);
                }

                var json = JsonConvert.SerializeObject(data);

                IEnumerable<TSPartialStatusDataTableListExcel> excelData = JsonConvert.DeserializeObject<IEnumerable<TSPartialStatusDataTableListExcel>>(json);

                byte[] byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, "Timesheet status for costcode " + costcode.ToString() + " : " + statusName, strSheetName);

                var mimeType = MimeTypeMap.GetMimeType("xlsx");

                FileContentResult file = File(byteContent, mimeType, StrFimeName);

                return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        #endregion Department wise (bulk) timesheet status


        #region Project wise timesheet details ---------- 

        public async Task<IActionResult> ProjectIndex(string costcode)
        {
            if (!(CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TimesheetHelper.ActionDeptTimesheet) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TimesheetHelper.ActionAllEmployeeTimesheetReport)))
            {
                return Forbid();
            }

            TimesheetProjectIndexViewModel timesheetProjectViewModel = new TimesheetProjectIndexViewModel();

            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterTimesheetIndex
            });

            FilterDataModel filterDataModel;

            if (string.IsNullOrEmpty(retVal.OutPFilterJson))
                return NotFound();
            else
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            //var costCodes = await _selectTcmPLRepository.SelectCostCodeRapReportingProco(BaseSpTcmPLGet(), null);

            string defaultCostcode = string.Empty;

            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TimesheetHelper.ActionDeptTimesheet))
            {
                var costCodes = await _selectTcmPLRepository.TSOSCMhrsCostcodeList(BaseSpTcmPLGet(), null);
                defaultCostcode = costcode == null ? costCodes.FirstOrDefault().DataValueField?.ToString() : costcode?.ToString();
                ViewData["CostCodes"] = new SelectList(costCodes, "DataValueField", "DataTextField", defaultCostcode);
            }

            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TimesheetHelper.ActionAllEmployeeTimesheetReport))
            {
                var costCodes = await _selectTcmPLRepository.SelectCostCodeRapReportingProco(BaseSpTcmPLGet(), null);
                defaultCostcode = costcode == null ? costCodes.FirstOrDefault().DataValueField?.ToString() : costcode?.ToString();
                ViewData["CostCodes"] = new SelectList(costCodes, "DataValueField", "DataTextField", defaultCostcode);
            }

            //var defaultCostcode = costcode == null ? costCodes.FirstOrDefault().DataValueField?.ToString() : costcode?.ToString();

            timesheetProjectViewModel.FilterDataModel = filterDataModel;

            TSWrkHourCount wrkhoursmodel = await _timesheetWrkHourCountRepository.MonthlyWrkHourCountAsync(
                   BaseSpTcmPLGet(),
                   new ParameterSpTcmPL
                   {
                       PYymm = filterDataModel.Yyyymm
                   });

            //ViewData["CostCodes"] = new SelectList(costCodes, "DataValueField", "DataTextField", defaultCostcode);
            ViewData["Yyyy"] = filterDataModel.Yyyy;
            ViewData["Yyyymm"] = filterDataModel.Yyyymm;
            ViewData["DefaultCostcode"] = defaultCostcode;
            ViewData["WrkHours"] = wrkhoursmodel.PWrkHours;

            return View(timesheetProjectViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsProjectTimesheet(string paramJSon)
        {
            DTResult<TSProjectDataTableList> result = new();
            int totalRow = 0;

            try
            {
                DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJSon);

                IEnumerable<TSProjectDataTableList> data = await _timesheetProjectDataTableListRepository.ProjectwiseTimesheetDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch ?? " ",
                        PYymm = param.yymm,
                        PCostcode= param.Costcode,
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

            //DTResult<TSProjectDataTableList> result = new DTResult<TSProjectDataTableList>();
            //int totalRow = 0;           

            //try
            //{
            //    var data = await _timesheetProjectDataTableListRepository.ProjectwiseTimesheetDataTableListAsync(
            //        BaseSpTcmPLGet(),
            //        new ParameterSpTcmPL
            //        {
            //            PGenericSearch = param.GenericSearch ?? " ",
            //            PYymm = param.yymm,
            //            PRowNumber = param.Start,
            //            PPageLength = param.Length
            //        }
            //    );     

            //    if (data.Any())
            //    {
            //        totalRow = (int)data.FirstOrDefault().TotalRow.Value;
            //    }

            //    result.draw = param.Draw;
            //    result.recordsTotal = totalRow;
            //    result.recordsFiltered = totalRow;
            //    result.data = data.ToList();

            //    return Json(result);
            //}
            //catch (Exception ex)
            //{
            //    return Json(new
            //    {
            //        error = ex.Message
            //    });
            //}
        }


        public async Task<IActionResult> ProjectTimesheetDetail(string id)
        {
            if (id == null)
                return NotFound();

            var yymm = id.Split("!-!")[0]?.ToString();
            var costcode = id.Split("!-!")[1]?.ToString();
            var projno = id.Split("!-!")[2]?.ToString();

            
            if (yymm == null || costcode == null || projno == null)
                return NotFound();

            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterTimesheetIndex
            });

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            TimesheetStatusPartialIndexViewModel timesheetStatusPartial = new()
            {
                FilterDataModel = filterDataModel
            };

            TSWrkHourCount wrkhoursmodel = await _timesheetWrkHourCountRepository.MonthlyWrkHourCountAsync(
                   BaseSpTcmPLGet(),
                   new ParameterSpTcmPL
                   {
                       PYymm = filterDataModel.Yyyymm
                   });

            ViewData["Yyyymm"] = yymm;
            ViewData["Projno"] = projno;
            ViewData["Costcode"] = costcode;
            ViewData["WrkHours"] = wrkhoursmodel.PWrkHours;

            return PartialView("_ModalProjectStatusIndexPartial", timesheetStatusPartial);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsProjectDetail(string paramJson)
        {
            DTResult<TSStatusPartialDataTableList> result = new();
            int totalRow = 0;
            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);
            
            try
            {
                IEnumerable<TSStatusPartialDataTableList> data = await _timesheetStatusPartialDataTableListRepository.ProjectTimesheetStatusDataTableListAsync(
                                                                        BaseSpTcmPLGet(),
                                                                        new ParameterSpTcmPL
                                                                        {
                                                                            PGenericSearch = param.GenericSearch ?? " ",
                                                                            PYymm = param.yymm,
                                                                            PCostcode = param.Costcode,
                                                                            PProjno = param.Projno,
                                                                            PRowNumber = param.Start,
                                                                            PPageLength = param.Length
                                                                        });
                    

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
                return Json(new
                {
                    error = ex.Message
                });
            }
        }

        [HttpGet]
        public async Task<IActionResult> TimesheetProjectDownload(string id)
        {
            if (id == null)
                return NotFound();

            var yymm = id.Split("!-!")[0]?.ToString();
            var costcode = id.Split("!-!")[1]?.ToString();
            var strSearch = id.Split("!-!")[2]?.ToString();

            if (yymm == null || costcode == null)
                return NotFound();            

            string StrFimeName = "Timesheet_Project_List_Costcode_" + costcode + DateTime.Now.ToString("yyyyMMdd_HHmm") + ".xlsx";
            string strSheetName = costcode.ToString() + "_Timesheet_Project_List";

            try
            {
                IEnumerable<TSProjectDataTableExcel> data = await _timesheetProjectDataTableExcelRepository.ProjectwiseTimesheetDataTableExcelAsync(
                                                                        BaseSpTcmPLGet(),
                                                                        new ParameterSpTcmPL
                                                                        {
                                                                            PGenericSearch = strSearch ?? " ",
                                                                            PYymm = yymm.ToString(),
                                                                            PCostcode = costcode.ToString()                                                                            
                                                                        });

                if (!data.Any())
                {
                    Notify("Error", "No data exists", "toaster", notificationType: NotificationType.error);
                }

                var json = JsonConvert.SerializeObject(data);

                IEnumerable<TSProjectDataTableExcel> excelData = JsonConvert.DeserializeObject<IEnumerable<TSProjectDataTableExcel>>(json);

                byte[] byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, "Timesheet_Project_List_Costcode_" + costcode.ToString(), strSheetName);

                var mimeType = MimeTypeMap.GetMimeType("xlsx");

                FileContentResult file = File(byteContent, mimeType, StrFimeName);

                return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        [HttpGet]
        public async Task<IActionResult> TimesheetProjectDetailsDownload(string id)
        {
            if (id == null)
                return NotFound();

            var yymm = id.Split("!-!")[0]?.ToString();            
            var projno = id.Split("!-!")[1]?.ToString();
            var costcode = id.Split("!-!")[2]?.ToString();
            var strSearch = id.Split("!-!")[3]?.ToString();

            if (yymm == null || projno == null || costcode == null )
                return NotFound();

            string StrFimeName = "Timesheet_Project_" + projno + "_Costcode_" + costcode + DateTime.Now.ToString("yyyyMMdd_HHmm") + ".xlsx";
            string strSheetName = "Timesheet_Project_Costcode_List";
            
            try
            {         
                IEnumerable<TSPartialStatusDataTableListExcel>  data = await _timesheetPartialStatusDataTableListExcelRepository.TimesheetProjectDetailPartialDataTableListExcelAsync(
                                                                        BaseSpTcmPLGet(),
                                                                        new ParameterSpTcmPL
                                                                        {
                                                                            PGenericSearch = strSearch ?? " ",
                                                                            PYymm = yymm.ToString(),
                                                                            PCostcode = costcode.ToString(),
                                                                            PProjno = projno.ToString()
                                                                        });
            
                if (!data.Any())
                {
                    Notify("Error", "No data exists", "toaster", notificationType: NotificationType.error);
                }

                var json = JsonConvert.SerializeObject(data);

                IEnumerable<TSPartialStatusDataTableListExcel> excelData = JsonConvert.DeserializeObject<IEnumerable<TSPartialStatusDataTableListExcel>>(json);

                byte[] byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, "Timesheet_Project_" + projno.ToString() + "_Costcode_" + costcode.ToString() + "_List", strSheetName);

                var mimeType = MimeTypeMap.GetMimeType("xlsx");

                FileContentResult file = File(byteContent, mimeType, StrFimeName);

                return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        #endregion Project wise timesheet details ---------- 


        #region Email reminder

        public async Task<IActionResult> ReminderEmailIndex()
        {
            if (!(CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TimesheetHelper.ActionDeptTimesheet) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TimesheetHelper.ActionAllEmployeeTimesheetReport)))
            {
                return Forbid();
            }

            TimesheetRemindeEmailIndexViewModel remindeEmailIndexViewModel = new TimesheetRemindeEmailIndexViewModel();

            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterTimesheetIndex
            });

            FilterDataModel filterDataModel;

            if (string.IsNullOrEmpty(retVal.OutPFilterJson))
                return NotFound();
            else
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            remindeEmailIndexViewModel.FilterDataModel = filterDataModel;

            TSWrkHourCount wrkhoursmodel = await _timesheetWrkHourCountRepository.MonthlyWrkHourCountAsync(
                   BaseSpTcmPLGet(),
                   new ParameterSpTcmPL
                   {
                       PYymm = filterDataModel.Yyyymm
                   });

            ViewData["Yyyy"] = filterDataModel.Yyyy;
            ViewData["Yyyymm"] = filterDataModel.Yyyymm;
            ViewData["WrkHours"] = wrkhoursmodel.PWrkHours;

            string monthYear = DateTime.ParseExact(filterDataModel.Yyyymm?.ToString(), "yyyyMM", CultureInfo.CurrentCulture).ToString("MMM-yyyy");

            ViewData["MonthYear"] = monthYear;

            return View(remindeEmailIndexViewModel);
        }

        public IActionResult EmailReminderPartialIndex(string id)
        {            
            ViewData["StatusName"] = id;            

            return PartialView("_ModalEmailReminderPartial");
        }

        [HttpGet]
        public async Task<IActionResult> SendReminder(string id)
        {
            if (id == null)
                return NotFound();

            var yymm = id.Split("!-!")[0]?.ToString();
            var costcode = id.Split("!-!")[1]?.ToString();
            var statusName = id.Split("!-!")[2]?.ToString();

            try
            {
                TSStatusReminderEmail model = await _timesheetReminderEmailRepository.RemideremailDetails(
                            BaseSpTcmPLGet(),
                            new ParameterSpTcmPL
                            {
                                PYymm = yymm,
                                PCostcode = costcode ?? " ",
                                PStatusstring = statusName
                            });

                return Json(model);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }




        #endregion Email reminder

    }
}
