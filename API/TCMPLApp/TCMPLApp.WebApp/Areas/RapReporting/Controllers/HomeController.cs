using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Net;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.Common;
using TCMPLApp.WebApp.Classes;
using TCMPLApp.WebApp.Controllers;
using TCMPLApp.WebApp.Models;
using TCMPLApp.Domain.Models.RapReporting;
using System.Linq;
using TCMPLApp.DataAccess.Repositories.SWPVaccine;

namespace TCMPLApp.WebApp.Areas.RapReporting.Controllers
{
    [Area("RapReporting")]
    public class HomeController : BaseController
    {
        private const string ConstFilterRapIndex = "RapCommonIndex";
        private const string ConstControllerName = "Home";
        private const string ConstActionName = "Index";
        private const string actionNameAnalyticalCostCenterIndex = "AnalyticalCostCenterIndex";
        private const string actionNameGeneralCostCenterIndex = "GeneralCostCenterIndex";
        private const string actionNameAnalyticalProjectIndex = "AnalyticalProjectIndex";
        private const string actionNameGeneralProjectIndex = "GeneralProjectIndex";
        private const string actionNameManhoursProjectionsCurrentJobsIndex = "ManhoursProjectionsCurrentJobsIndex";
        private const string actionNameManhoursProjectionsExpectedJobsIndex = "ManhoursProjectionsExpectedJobsIndex";
        private const string actionNameOvertimeUpdateIndex = "OvertimeUpdateIndex";

        private readonly ISelectTcmPLRepository _selectTcmPLRepository;
        private readonly IFilterRepository _filterRepository;
        private readonly IUtilityRepository _utilityRepository;


        public HomeController(
            ISelectTcmPLRepository selectTcmPLRepository,
            IFilterRepository filterRepository,
            IUtilityRepository utilityRepository

            )
        {
            _selectTcmPLRepository = selectTcmPLRepository;
            _filterRepository = filterRepository;
            _utilityRepository = utilityRepository;
        }

        public async Task<IActionResult> Index()
        {
            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterRapIndex
            });

            RapViewModel rapViewModel = new RapViewModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                rapViewModel.FilterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            return View(rapViewModel);
        }

        public async Task<IActionResult> FilterGet(string actionName, string controllerName)
        {
            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterRapIndex
            });
            FilterDataModel filterDataModel;
            if (string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = new FilterDataModel();
                filterDataModel.Yyyy = null;
                filterDataModel.YearMode = null;
                filterDataModel.Yyyymm = null;
            }
            else
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);


            var years = await _selectTcmPLRepository.SelectYearRapReporting(BaseSpTcmPLGet(), null);
            ViewData["Years"] = new SelectList(years, "DataValueField", "DataTextField", filterDataModel.Yyyy);

            var yearModes = await _selectTcmPLRepository.SelectYearModeRapReporting(BaseSpTcmPLGet(), null);
            ViewData["YearModes"] = new SelectList(yearModes, "DataValueField", "DataTextField", filterDataModel.YearMode);

            if (!string.IsNullOrEmpty(filterDataModel.Yyyy) && !string.IsNullOrEmpty(filterDataModel.YearMode))
            {
                var yyyymm = await _selectTcmPLRepository.SelectYearMonthRapReporting(BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PYyyy = filterDataModel.Yyyy,
                        PYearmode = filterDataModel.YearMode
                    });
                ViewData["Yyyymms"] = new SelectList(yyyymm, "DataValueField", "DataTextField", filterDataModel.Yyyymm);

            }

            if ((CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == RapReportingHelper.ActionProcoTrans))
               || (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == RapReportingHelper.ActionProcoProcess))
               || (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == RapReportingHelper.ActionReportsProco))
               || (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == RapReportingHelper.ActionCostCodeProcoEdit))
               || (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == RapReportingHelper.ActionRAPReports)))
            {
                var costCodes = await _selectTcmPLRepository.SelectCostCodeRapReportingProco(BaseSpTcmPLGet(), null);
                ViewData["CostCodes"] = new SelectList(costCodes, "DataValueField", "DataTextField", filterDataModel.CostCode);
            }
            else
            {
                var costCodes = await _selectTcmPLRepository.SelectCostCodeRapReporting(BaseSpTcmPLGet(), null);
                ViewData["CostCodes"] = new SelectList(costCodes, "DataValueField", "DataTextField", filterDataModel.CostCode);
            }

            if ((CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == RapReportingHelper.ActionProcoTrans))
               || (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == RapReportingHelper.ActionProcoProcess))
               || (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == RapReportingHelper.ActionReportsProco))
               || (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == RapReportingHelper.ActionReportsEnggMngr))
               || (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == RapReportingHelper.ActionRAPReports)))
            {
                var projnos = await _selectTcmPLRepository.SelectProjnoRapReportingProco(BaseSpTcmPLGet(), null);
                ViewData["Projnos"] = new SelectList(projnos, "DataValueField", "DataTextField", filterDataModel.Projno);
            }
            else
            {
                var projnos = await _selectTcmPLRepository.SelectProjnoRapReporting(BaseSpTcmPLGet(), null);
                ViewData["Projnos"] = new SelectList(projnos, "DataValueField", "DataTextField", filterDataModel.Projno);
            }

            var simulations = await _selectTcmPLRepository.SelectSimulationRapReporting(BaseSpTcmPLGet(), null);
            ViewData["Simulations"] = new SelectList(simulations, "DataValueField", "DataTextField");

            filterDataModel.ActionName = actionName == null ? ConstActionName : actionName;
            filterDataModel.ControllerName = controllerName == null ? ConstControllerName : controllerName;

            return PartialView("_ModalConfigurationFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> FilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                string jsonFilter;
                jsonFilter = JsonConvert.SerializeObject(new
                {
                    Yyyy = filterDataModel.Yyyy,
                    YearMode = filterDataModel.YearMode,
                    Yyyymm = filterDataModel.Yyyymm,
                    CostCode = string.IsNullOrEmpty(filterDataModel.CostCode) ? filterDataModel.Dummy_CostCode : filterDataModel.CostCode,
                    ProjNo = string.IsNullOrEmpty(filterDataModel.Projno) ? filterDataModel.Dummy_Projno : filterDataModel.Projno,
                    Simul = filterDataModel.Simul,
                    User = User.Identity.Name.Substring(User.Identity.Name.IndexOf("\\") + 1)
                });

                var retVal = await _filterRepository.FilterCreateAsync(new Domain.Models.FilterCreate
                {
                    PModuleName = CurrentUserIdentity.CurrentModule,
                    PMetaId = CurrentUserIdentity.MetaId,
                    PPersonId = CurrentUserIdentity.EmployeeId,
                    PMvcActionName = ConstFilterRapIndex,
                    PFilterJson = jsonFilter
                });

                return RedirectToAction(filterDataModel.ActionName, filterDataModel.ControllerName);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        public async Task<IActionResult> GetYearMonthList(string yyyy, string yearmode)
        {

            if (yyyy == null || yearmode == null)
            {
                return NotFound();
            }

            var yyyyMMList = await _selectTcmPLRepository.SelectYearMonthRapReporting(BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PYyyy = yyyy,
                    PYearmode = yearmode
                });

            return Json(yyyyMMList);

        }

        public async Task<IActionResult> RedirectPage(string actionName, string controllerName)
        {

            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterRapIndex
            });

            FilterDataModel filterDataModel;
            if (string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                var redirectUrl = new List<SelectListItem> { new SelectListItem { Text = "url", Value = "location.reload();" }
                                                           };
                return Json(redirectUrl);
            }
            else
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

                if (actionName == actionNameAnalyticalCostCenterIndex ||
                    actionName == actionNameGeneralCostCenterIndex ||
                    actionName == actionNameManhoursProjectionsCurrentJobsIndex ||
                    actionName == actionNameManhoursProjectionsExpectedJobsIndex ||
                    actionName == actionNameOvertimeUpdateIndex)
                {
                    if (filterDataModel.CostCode is null)
                    {
                        var redirectUrl = new List<SelectListItem> { new SelectListItem { Text = "url", Value = "history.go(-1);" }
                                                                   };
                        return Json(redirectUrl);
                    }
                    else
                    {
                        var redirectUrl = new List<SelectListItem> { new SelectListItem { Text = "url", Value = "location.reload();" }
                                                                   };
                        return Json(redirectUrl);
                    }
                }
                else if (actionName == actionNameAnalyticalProjectIndex || actionName == actionNameGeneralProjectIndex)
                {
                    if (filterDataModel.Projno is null)
                    {
                        var redirectUrl = new List<SelectListItem> { new SelectListItem { Text = "url", Value = "history.go(-1);" }
                                                                   };
                        return Json(redirectUrl);
                    }
                    else
                    {
                        var redirectUrl = new List<SelectListItem> { new SelectListItem { Text = "url", Value = "location.reload();" }
                                                                   };
                        return Json(redirectUrl);
                    }
                }
                else
                {
                    var redirectUrl = new List<SelectListItem> { new SelectListItem { Text = "url", Value = "location.reload();" }
                                                               };
                    return Json(redirectUrl);
                }
            }
        }

        public IActionResult ShowSitemap()
        {
            return PartialView("_ModalSitemap");
        }


        #region RapNavigation
        public async Task<IActionResult> NavIndex()
        {
            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterRapIndex
            });

            RapNavIndexViewModel rapNavIndexViewModel = new RapNavIndexViewModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                rapNavIndexViewModel.FilterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            return View(rapNavIndexViewModel);
        }
        #endregion RapNavigation

        //public IActionResult ReportDownload(string id)
        //{
        //    if (id == null)
        //    {
        //        return NotFound();
        //    }
        //    var reportFields = ReportFieldDetails(id);

        //    return PartialView("_ModelReportParameter", reportFields);
        //}

        //private IEnumerable<SiteMapFilterFieldsViewModel> ReportFieldDetails(string id)
        //{


        //    List<SiteMapFilterFieldsViewModel> FieldList = new List<SiteMapFilterFieldsViewModel>();

        //    FieldList.Add(new SiteMapFilterFieldsViewModel { FieldId = "1", FunctionalDesc = "From Date", IsRequired = "Yes" });
        //    FieldList.Add(new SiteMapFilterFieldsViewModel { FieldId = "2", FunctionalDesc = "To Date", IsRequired = "Yes" });
        //    FieldList.Add(new SiteMapFilterFieldsViewModel { FieldId = "3", FunctionalDesc = "Parent", IsRequired = "Either" });
        //    FieldList.Add(new SiteMapFilterFieldsViewModel { FieldId = "4", FunctionalDesc = "Multiple Empno", IsRequired = "No" });

        //    return FieldList;

        //}

        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult ReportExcelDownload(DateTime startdate, DateTime enddate, DateTime date1, string singleline, string multiline)
        {
            long timeStamp = DateTime.Now.ToFileTime();
            string fileName = "Prospective Employees Details_" + timeStamp.ToString();
            string reportTitle = "Prospective Employees Details ";
            string sheetName = "Prospective Employees Details";

            string strUser = User.Identity.Name;
            var data = "";

            //IEnumerable<ProspectiveEmployeesXLDataTableList> data = await _prospectiveEmployeesXLDataTableListRepository.ProspectiveEmployeesDataTableListForExcelAsync(
            //    BaseSpTcmPLGet(),
            //    new ParameterSpTcmPL
            //    {
            //        PStartdate = startdate,
            //        PEnddate = enddate,
            //        PDate1 = date1,
            //        PSingleline = singleline,
            //        Pmultiline = multiline,
            //    });

            if (data == null || data.Count() == 0) { throw new Exception("No Data Found"); }

            byte[] byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(data, reportTitle, sheetName);

            return File(byteContent, "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", fileName + ".xlsx");
        }
    }
}
