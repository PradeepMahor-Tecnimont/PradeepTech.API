using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.Extensions.Configuration;
using System.Net;
using System.Threading.Tasks;
using System;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.Common;
using TCMPLApp.Domain.Models.Common;
using TCMPLApp.Domain.Models.JOB;
using TCMPLApp.Library.Excel.Template;
using TCMPLApp.WebApp.Classes;
using TCMPLApp.WebApp.Controllers;
using TCMPLApp.WebApp.CustomPolicyProvider;
using TCMPLApp.WebApp.Models;
using TCMPLApp.WebApp.Services;
using Newtonsoft.Json;
using TCMPLApp.DataAccess.Repositories.Timesheet;
using System.Globalization;
using TCMPLApp.DataAccess.Repositories.SWPVaccine;
using TCMPLApp.Domain.Models.Timesheet;
using static TCMPLApp.WebApp.Classes.DTModel;
using System.Linq;
using MimeTypes;
using ClosedXML.Excel;
using System.IO;
using System.Collections.Generic;
using static ClosedXML.Excel.XLPredefinedFormat;
using FastMember;
using System.Data;

namespace TCMPLApp.WebApp.Areas.Timesheet.Controllers
{
    [Authorize]    
    [Area("Timesheet")]
    public class OSCMhrsController : BaseController
    {
        private const string ConstFilterTimesheetIndex = "TimesheetCommonIndex";
        private const string ConstFilterOSCMhrsSummaryIndex = "OSCMhrsSummaryIndex";

        private readonly IConfiguration _configuration;
        private readonly IFilterRepository _filterRepository;
        private readonly IHttpClientRapReporting _httpClientRapReporting;
        private readonly IExcelTemplate _excelTemplate;
        private readonly ISelectTcmPLRepository _selectTcmPLRepository;
        private readonly IOSCMhrsRepository _oSCMhrsRepository;
        private readonly IOSCMhrsDetailRepository _oSCMhrsDetailRepository;
        private readonly IEmployeeDetailsRepository _employeeDetailsRepository;
        private readonly IOSCMhrsDetailsDataTableListRepository _oSCMhrsDetailsDataTableListRepository;
        private readonly IOSCMhrsSummaryDataTableListRepository _oSCMhrsSummaryDataTableListRepository;
        private readonly IUtilityRepository _utilityRepository;
        private readonly IOSCMhrsDetailsXLDataTableListRepository _oSCMhrsDetailsXLDataTableListRepository;
        private readonly IOpenXMLUtilityRepository _openXMLUtilityRepository;
        private readonly ICommonEmployeeDetailsRepository _commonEmployeeDetailsRepository;

        public OSCMhrsController(IConfiguration configuration,
                             IFilterRepository filterRepository,
                             IHttpClientRapReporting httpClientRapReporting,
                             IExcelTemplate excelTemplate,
                             ISelectTcmPLRepository selectTcmPLRepository,
                             IOSCMhrsRepository oSCMhrsRepository,
                             IOSCMhrsDetailRepository oSCMhrsDetailRepository,
                             IEmployeeDetailsRepository employeeDetailsRepository,
                             IOSCMhrsDetailsDataTableListRepository oSCMhrsDetailsDataTableListRepository,
                             IOSCMhrsSummaryDataTableListRepository oSCMhrsSummaryDataTableListRepository,
                             IUtilityRepository utilityRepository,
                             IOSCMhrsDetailsXLDataTableListRepository oSCMhrsDetailsXLDataTableListRepository,
                             IOpenXMLUtilityRepository openXMLUtilityRepository,
                             ICommonEmployeeDetailsRepository commonEmployeeDetailsRepository)
        {
            _configuration = configuration;
            _filterRepository = filterRepository;
            _httpClientRapReporting = httpClientRapReporting;
            _excelTemplate = excelTemplate;
            _selectTcmPLRepository = selectTcmPLRepository;
            _oSCMhrsRepository = oSCMhrsRepository;
            _oSCMhrsDetailRepository = oSCMhrsDetailRepository;
            _employeeDetailsRepository = employeeDetailsRepository;
            _oSCMhrsDetailsDataTableListRepository = oSCMhrsDetailsDataTableListRepository;
            _oSCMhrsSummaryDataTableListRepository = oSCMhrsSummaryDataTableListRepository;
            _utilityRepository = utilityRepository;
            _oSCMhrsDetailsXLDataTableListRepository = oSCMhrsDetailsXLDataTableListRepository;
            _openXMLUtilityRepository = openXMLUtilityRepository;
            _commonEmployeeDetailsRepository = commonEmployeeDetailsRepository;
        }

        //[RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, TimesheetHelper.ActionDeptEmployeeTimesheetReport)]
        public async Task<IActionResult> OSCMhrsIndex(string yymm)
        {
            OSCMhrsViewModel oSCMhrsViewModel = new OSCMhrsViewModel();

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

            DBProcMessageOutput result = await _oSCMhrsRepository.OSCMhrsIsEditableAllowed(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PYymm = filterDataModel.Yyyymm
                });

            ViewData["Yyyy"] = filterDataModel.Yyyy;
            ViewData["Yyyymm"] = filterDataModel.Yyyymm;
            ViewData["IsEditableAllowed"] = result.PMessageType;

            return View(oSCMhrsViewModel);
        }

        #region View

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, TimesheetHelper.ActionDeptEmployeeTimesheetReport)]
        public async Task<JsonResult> GetListsOSCMhrs(string paramJSon)
        {
            DTResult<OSCMhrsDetailsDataTableList> result = new();
            int totalRow = 0;

            try
            {
                DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJSon);

                System.Collections.Generic.IEnumerable<OSCMhrsDetailsDataTableList> data = await _oSCMhrsDetailsDataTableListRepository.OSCMhrsDetailsDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch ?? " ",
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

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, TimesheetHelper.ActionDeptEmployeeTimesheetReport)]
        public async Task<IActionResult> OSCMhrsSummaryIndex(string id)
        {
            if (id == null)
                return NotFound();

            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterOSCMhrsSummaryIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            OSCMhrsSummaryViewModel oSCMhrsSummaryViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return PartialView("_OSCMhrsSummaryIndexPartial", oSCMhrsSummaryViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, TimesheetHelper.ActionDeptEmployeeTimesheetReport)]
        public async Task<JsonResult> GetListsOSCMhrsSummary(string paramJSon)
        {
            DTResult<OSCMhrsSummaryDataTableList> result = new();
            int totalRow = 0;

            try
            {
                DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJSon);

                System.Collections.Generic.IEnumerable<OSCMhrsSummaryDataTableList> data = await _oSCMhrsSummaryDataTableListRepository.OSCMhrsSummaryDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch ?? " ",
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

        #endregion View

        #region CRUD

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, TimesheetHelper.ActionDeptEmployeeTimesheetReport)]
        public async Task<IActionResult> Create()
        {
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

            OSCMhrsCreateViewModel oSCMhrsCreateViewModel = new();
            oSCMhrsCreateViewModel.Yymm = filterDataModel.Yyyymm;

            var costcodeList = await _selectTcmPLRepository.TSOSCMhrsCostcodeList(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {

                });

            var wpcodeList = await _selectTcmPLRepository.TSOSCMhrsWPCodeList(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {

                });

            ViewData["Assign"] = new SelectList(costcodeList, "DataValueField", "DataTextField");
            ViewData["Wpcode"] = new SelectList(wpcodeList, "DataValueField", "DataTextField");
            oSCMhrsCreateViewModel.YymmWords = CultureInfo.CurrentCulture.DateTimeFormat.GetMonthName(int.Parse(filterDataModel.Yyyymm.Substring(4, 2))) + " " + filterDataModel.Yyyymm.Substring(0, 4);

            return PartialView("_ModalOSCMhrsCreatePartial", oSCMhrsCreateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, TimesheetHelper.ActionDeptEmployeeTimesheetReport)]
        public async Task<IActionResult> Create([FromForm] OSCMhrsCreateViewModel oSCMhrsCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    if (oSCMhrsCreateViewModel.Hours == 0)
                        throw new Exception("Hours cannot be equal to 0");
                    else
                    {
                        //TCMPLApp.Domain.Models.SWPVaccine.EmployeeDetails employeeDetail = await _employeeDetailsRepository.GetEmployeeDetailsAsync(oSCMhrsCreateViewModel.Empno);
                        var employeeDetail = await _commonEmployeeDetailsRepository.EmployeeDetailAsync(
                            BaseSpTcmPLGet(),
                            new ParameterSpTcmPL
                            {
                                PEmpno = oSCMhrsCreateViewModel.Empno
                            });


                        DBProcMessageOutput result = await _oSCMhrsRepository.OSCMhrsAddAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PYymm = oSCMhrsCreateViewModel.Yymm,
                            PEmpno = oSCMhrsCreateViewModel.Empno,
                            PParent = employeeDetail.PParent,
                            PAssign = oSCMhrsCreateViewModel.Assign,
                            PProjno = oSCMhrsCreateViewModel.Projno,
                            PWpcode = oSCMhrsCreateViewModel.Wpcode,
                            PActivity = oSCMhrsCreateViewModel.Activity,
                            PHours = oSCMhrsCreateViewModel.Hours
                        });

                        if (result.PMessageType != IsOk)
                            throw new Exception(result.PMessageText.Replace("-", " "));
                        else
                            return RedirectToAction("CreateAgain", new 
                                {
                                    costcode = oSCMhrsCreateViewModel.Assign,
                                    empno = oSCMhrsCreateViewModel.Empno,
                                    projno = oSCMhrsCreateViewModel.Projno,
                                    wpcode = oSCMhrsCreateViewModel.Wpcode
                                });

                        //return result.PMessageType != IsOk
                        //     ? throw new Exception(result.PMessageText.Replace("-", " "))
                        //     : (IActionResult)Json(new { success = true, response = result.PMessageText });
                        //return RedirectToAction("Create", new { });
                    }
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            #region select list

            var costcodeList = await _selectTcmPLRepository.TSOSCMhrsCostcodeList(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {

                });

            var empnoList = await _selectTcmPLRepository.TSOSCMhrsCostcodeEmpnoList(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PCostcode = oSCMhrsCreateViewModel.Assign
                });

            var projnoList = await _selectTcmPLRepository.TSOSCMhrsProjnoList(
               BaseSpTcmPLGet(),
               new ParameterSpTcmPL
               {
                   PCostcode = oSCMhrsCreateViewModel.Assign
               });

            var wpcodeList = await _selectTcmPLRepository.TSOSCMhrsWPCodeList(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {

                });

            var activityList = await _selectTcmPLRepository.TSOSCMhrsActivityList(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PCostcode = oSCMhrsCreateViewModel.Assign
                });

            ViewData["Assign"] = new SelectList(costcodeList, "DataValueField", "DataTextField", oSCMhrsCreateViewModel.Assign);
            ViewData["Empno"] = new SelectList(empnoList, "DataValueField", "DataTextField", oSCMhrsCreateViewModel.Empno);
            ViewData["Projno"] = new SelectList(projnoList, "DataValueField", "DataTextField", oSCMhrsCreateViewModel.Projno);
            ViewData["Wpcode"] = new SelectList(wpcodeList, "DataValueField", "DataTextField", oSCMhrsCreateViewModel.Wpcode);
            ViewData["Activity"] = new SelectList(activityList, "DataValueField", "DataTextField", oSCMhrsCreateViewModel.Activity);
            oSCMhrsCreateViewModel.YymmWords = CultureInfo.CurrentCulture.DateTimeFormat.GetMonthName(int.Parse(oSCMhrsCreateViewModel.Yymm.Substring(4, 2))) + " " + oSCMhrsCreateViewModel.Yymm.Substring(0, 4);


            #endregion select list

            return PartialView("_ModalOSCMhrsCreatePartial", oSCMhrsCreateViewModel);
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, TimesheetHelper.ActionDeptEmployeeTimesheetReport)]
        public async Task<IActionResult> CreateAgain(string costcode, string empno, string projno, string wpcode)
        {
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

            OSCMhrsCreateViewModel oSCMhrsCreateViewModel = new();
            oSCMhrsCreateViewModel.Yymm = filterDataModel.Yyyymm;

            var costcodeList = await _selectTcmPLRepository.TSOSCMhrsCostcodeList(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {

                });

            var empnoList = await _selectTcmPLRepository.TSOSCMhrsCostcodeEmpnoList(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PCostcode = costcode
                });

            var projnoList = await _selectTcmPLRepository.TSOSCMhrsProjnoList(
               BaseSpTcmPLGet(),
               new ParameterSpTcmPL
               {
                   PCostcode = costcode
               });

            var wpcodeList = await _selectTcmPLRepository.TSOSCMhrsWPCodeList(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {

                });

            var activityList = await _selectTcmPLRepository.TSOSCMhrsActivityList(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PCostcode = costcode
                });

            ViewData["Assign"] = new SelectList(costcodeList, "DataValueField", "DataTextField", costcode);
            ViewData["Empno"] = new SelectList(empnoList, "DataValueField", "DataTextField", empno);
            ViewData["Projno"] = new SelectList(projnoList, "DataValueField", "DataTextField", projno);
            ViewData["Wpcode"] = new SelectList(wpcodeList, "DataValueField", "DataTextField", wpcode);
            ViewData["Activity"] = new SelectList(activityList, "DataValueField", "DataTextField");
            oSCMhrsCreateViewModel.YymmWords = CultureInfo.CurrentCulture.DateTimeFormat.GetMonthName(int.Parse(filterDataModel.Yyyymm.Substring(4, 2))) + " " + filterDataModel.Yyyymm.Substring(0, 4);

            return PartialView("_ModalOSCMhrsCreatePartial", oSCMhrsCreateViewModel);
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, TimesheetHelper.ActionDeptEmployeeTimesheetReport)]
        public async Task<IActionResult> Edit(string id)
        {
            if (id == null)
                return NotFound();

            OSCMhrsUpdateViewModel oSCMhrsUpdateViewModel = new();

            var result = await _oSCMhrsDetailRepository.OSCMhrsDetailAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    POscdId = id
                });

            if (result.PMessageType == IsOk)
            {
                oSCMhrsUpdateViewModel.OscdId = id;
                oSCMhrsUpdateViewModel.OscmId = result.POscmId;
                oSCMhrsUpdateViewModel.Yymm = result.PYymm;
                oSCMhrsUpdateViewModel.Parent = result.PParent;
                oSCMhrsUpdateViewModel.ParentWithName = result.PAssignWithName;
                oSCMhrsUpdateViewModel.Assign = result.PAssign;
                oSCMhrsUpdateViewModel.AssignWithName = result.PAssignWithName;
                oSCMhrsUpdateViewModel.Empno = result.PEmpno;
                oSCMhrsUpdateViewModel.EmpnoWithName = result.PEmpnoWithName;
                oSCMhrsUpdateViewModel.Projno = result.PProjno;
                oSCMhrsUpdateViewModel.Wpcode = result.PWpcode;
                oSCMhrsUpdateViewModel.Activity = result.PActivity;
                oSCMhrsUpdateViewModel.Hours = result.PHours;
                oSCMhrsUpdateViewModel.YymmWords = CultureInfo.CurrentCulture.DateTimeFormat.GetMonthName(int.Parse(result.PYymm.Substring(4, 2))) + " " + result.PYymm.Substring(0, 4);

                #region select list

                var projnoList = await _selectTcmPLRepository.TSOSCMhrsProjnoList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PCostcode = result.PAssign
                    });

                var wpcodeList = await _selectTcmPLRepository.TSOSCMhrsWPCodeList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {

                    });

                var activityList = await _selectTcmPLRepository.TSOSCMhrsActivityList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PCostcode = result.PAssign
                    });

                ViewData["Projno"] = new SelectList(projnoList, "DataValueField", "DataTextField", result.PProjno);
                ViewData["Wpcode"] = new SelectList(wpcodeList, "DataValueField", "DataTextField", result.PWpcode);
                ViewData["Activity"] = new SelectList(activityList, "DataValueField", "DataTextField", result.PActivity);

                #endregion select list
            }
            return PartialView("_ModalOSCMhrsUpdatePartial", oSCMhrsUpdateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, TimesheetHelper.ActionDeptEmployeeTimesheetReport)]
        public async Task<IActionResult> Edit([FromForm] OSCMhrsUpdateViewModel oSCMhrsUpdateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    if (oSCMhrsUpdateViewModel.Hours == 0)
                        throw new Exception("Hours cannot be equal to 0");
                    else
                    {
                        DBProcMessageOutput result = await _oSCMhrsRepository.OSCMhrsUpdateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            POscmId = oSCMhrsUpdateViewModel.OscmId,
                            POscdId = oSCMhrsUpdateViewModel.OscdId,
                            PProjno = oSCMhrsUpdateViewModel.Projno,
                            PWpcode = oSCMhrsUpdateViewModel.Wpcode,
                            PActivity = oSCMhrsUpdateViewModel.Activity,
                            PHours = oSCMhrsUpdateViewModel.Hours
                        });

                        return result.PMessageType != IsOk
                             ? throw new Exception(result.PMessageText.Replace("-", " "))
                             : (IActionResult)Json(new { success = true, response = result.PMessageText });
                    }
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            #region select list

            var projnoList = await _selectTcmPLRepository.TSOSCMhrsProjnoList(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PCostcode = oSCMhrsUpdateViewModel.Assign
                });

            var wpcodeList = await _selectTcmPLRepository.TSOSCMhrsWPCodeList(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {

                });

            var activityList = await _selectTcmPLRepository.TSOSCMhrsActivityList(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PCostcode = oSCMhrsUpdateViewModel.Assign
                });

            ViewData["Projno"] = new SelectList(projnoList, "DataValueField", "DataTextField", oSCMhrsUpdateViewModel.Projno);
            ViewData["Wpcode"] = new SelectList(wpcodeList, "DataValueField", "DataTextField", oSCMhrsUpdateViewModel.Wpcode);
            ViewData["Activity"] = new SelectList(activityList, "DataValueField", "DataTextField", oSCMhrsUpdateViewModel.Activity);

            #endregion select list

            return PartialView("_ModalOSCMhrsUpdatePartial", oSCMhrsUpdateViewModel);
        }

        [HttpPost]        
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, TimesheetHelper.ActionDeptEmployeeTimesheetReport)]
        public async Task<IActionResult> Delete(string id)
        {
            try
            {
                var result = await _oSCMhrsRepository.OSCMhrsDeleteAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        POscmId = id.Split(";")[0],
                        POscdId = id.Split(";")[1]
                    }
                    );

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageType, message = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, TimesheetHelper.ActionDeptEmployeeTimesheetReport)]
        public async Task<IActionResult> Lock(string id)
        {
            try
            {
                var result = await _oSCMhrsRepository.OSCMhrsLockAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        POscmId = id
                    }
                    );

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageType, message = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, TimesheetHelper.ActionDeptEmployeeTimesheetReport)]
        public async Task<IActionResult> Unlock(string id)
        {
            try
            {
                var result = await _oSCMhrsRepository.OSCMhrsUnlockAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        POscmId = id
                    }
                    );

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageType, message = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, TimesheetHelper.ActionDeptEmployeeTimesheetReport)]
        public async Task<IActionResult> Approve(string id)
        {
            try
            {
                var result = await _oSCMhrsRepository.OSCMhrsApproveAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {                        
                        POscmId = id
                    }
                );

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageType, message = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, TimesheetHelper.ActionDeptEmployeeTimesheetReport)]
        public async Task<IActionResult> RevokeApproval(string id)
        {
            try
            {
                var result = await _oSCMhrsRepository.OSCMhrsRevokeApproveAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        POscmId = id
                    }
                 );

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageType, message = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, TimesheetHelper.ActionDeptEmployeeTimesheetReport)]
        public async Task<IActionResult> Post(string id)
        {
            try
            {
                var result = await _oSCMhrsRepository.OSCMhrsPostAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        POscmId = id
                    }
                );

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageType, message = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, TimesheetHelper.ActionDeptEmployeeTimesheetReport)]
        public async Task<IActionResult> UnPost(string id)
        {
            try
            {
                var result = await _oSCMhrsRepository.OSCMhrsUnPostAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        POscmId = id
                    }
                );

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageType, message = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        #endregion CRUD

        public async Task<IActionResult> SelectEmpno(string id)
        {
            try
            {
                var result = await _selectTcmPLRepository.TSOSCMhrsCostcodeEmpnoList(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PCostcode = id
                });
                return Json(result);
            }
            catch (Exception ex)
            {
                return NotFound(ex);
            }
        }

        public async Task<IActionResult> SelectProjno(string id)
        {
            try
            {
                var result = await _selectTcmPLRepository.TSOSCMhrsProjnoList(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PCostcode = id
                });
                return Json(result);
            }
            catch (Exception ex)
            {
                return NotFound(ex);
            }
        }

        public async Task<IActionResult> SelectActivity(string id)
        {
            try
            {
                var result = await _selectTcmPLRepository.TSOSCMhrsActivityList(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PCostcode = id
                });
                return Json(result);
            }
            catch (Exception ex)
            {
                return NotFound(ex);
            }
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, TimesheetHelper.ActionDeptEmployeeTimesheetReport)]
        public async Task<IActionResult> OSCMhrsDetailsExcelDownload(string id)
        {
            try
            {                
                string fileName = "OSC Manhours Details_" + id + ".xlsx";
                string reportTitle = "OSC Manhours Details - " + CultureInfo.CurrentCulture.DateTimeFormat.GetAbbreviatedMonthName(int.Parse(id.Substring(4, 2))) + " " + id.Substring(0, 4);
                string sheetName = reportTitle;
                var mimeType = MimeTypeMap.GetMimeType("xlsx");                

                var excelData = await _oSCMhrsDetailsXLDataTableListRepository.OSCMhrsDetailsXLDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PYymm = id,
                        PActionId = CurrentUserIdentity.ProfileActions.Where(p => p.ActionId == TimesheetHelper.Action4PrengDownloadXLReport).Select(t => t.ActionId).FirstOrDefault()
                    });

                if (excelData == null || excelData.Count() == 0) { throw new Exception("No Data Found"); }

                var byteContent = _utilityRepository.ExcelPivotDownloadFromIEnumerable(
                    excelData, reportTitle, sheetName, "Pivot", null, new string[] { "EmpnoWithName", "AssignWithName", "ProjnoWithName", "WpcodeWithName", "ActivityWithName" }, null, new string[] { "Hours" }
                    );

                FileContentResult file = File(byteContent, mimeType, fileName);

                return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));

            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, TimesheetHelper.ActionDeptEmployeeTimesheetReport)]
        public async Task<IActionResult> Test(string id)
        {
            try
            {
                string fileName = "OSC Manhours Details_" + id + ".xlsx";
                string reportTitle = "OSC Manhours Details - " + CultureInfo.CurrentCulture.DateTimeFormat.GetAbbreviatedMonthName(int.Parse(id.Substring(4, 2))) + " " + id.Substring(0, 4);
                string sheetName = "Sheet1";
                var mimeType = MimeTypeMap.GetMimeType("xlsx");

                var excelData = await _oSCMhrsDetailsXLDataTableListRepository.OSCMhrsDetailsXLDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PYymm = id,
                        PActionId = CurrentUserIdentity.ProfileActions.Where(p => p.ActionId == TimesheetHelper.Action4PrengDownloadXLReport).Select(t => t.ActionId).FirstOrDefault()
                    });

                if (excelData == null || excelData.Count() == 0) { throw new Exception("No Data Found"); }                                

                var actualFileName = "OSC Manhours Details_" + System.DateTime.Now.ToFileTime().ToString() + ".xlsx"; 

                var byteContent = _openXMLUtilityRepository.ExcelDownloadFromDataTable(excelData, 
                                                                                       reportTitle, 
                                                                                       "E:\\OpenXML\\Templates\\Test.xlsx", 
                                                                                       "E:\\OpenXML\\Download\\" + actualFileName, 
                                                                                       sheetName, 
                                                                                       new int[] { 10 }, 
                                                                                       new int[] { 9 }, 
                                                                                       new int[] { 2 },
                                                                                       new string[] { "10" },
                                                                                       new int[] { 9 },
                                                                                       new int[] { 2 });

                FileContentResult file = File(byteContent, mimeType, fileName);

                return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));

            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }
    }
}
