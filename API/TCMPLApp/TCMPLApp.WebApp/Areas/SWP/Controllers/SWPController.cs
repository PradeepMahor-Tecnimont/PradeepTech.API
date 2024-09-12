using ClosedXML.Excel;
using ClosedXML.Report;
using DocumentFormat.OpenXml.Packaging;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.Extensions.Configuration;
using MimeTypes;
using Newtonsoft.Json;
using OfficeOpenXml.FormulaParsing.Excel.Functions.DateTime;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.Attendance;
using TCMPLApp.DataAccess.Repositories.Common;
using TCMPLApp.DataAccess.Repositories.SWP;
using TCMPLApp.DataAccess.Repositories.SWPVaccine;
using TCMPLApp.Domain.Models.SWP;
using TCMPLApp.Library.Excel.Template;
using TCMPLApp.Library.Excel.Template.Models;
using TCMPLApp.Library.Excel.Writer;
using TCMPLApp.WebApp.Classes;
using TCMPLApp.WebApp.Controllers;
using TCMPLApp.WebApp.CustomPolicyProvider;
using TCMPLApp.WebApp.Models;
using static TCMPLApp.WebApp.Classes.DTModel;

namespace TCMPLApp.WebApp.Areas.SWP.Controllers
{
    [Area("SWP")]
    [Authorize]
    public class SWPController : BaseController
    {
        
        private const string ConstFilterSmartAttendancePlan = "SmartAttendancePlan";
        private const string ConstFilterOfficeWorkSpaceIndex = "OfficeWorkSpaceIndex";
        private const string ConstFilterEmployeeProjectMappingIndex = "EmployeeProjectMappingIndex";
        private const string ConstFilterPrimaryWorkSpacePlanning = "PrimaryWorkSpacePlanning";
        private const string ConstFilterAdminPWSPlanning = "AdminPWSPlanning";
        private const string ConstFilterAdminSWSPlanning = "AdminSWSPlanning";

        private const string ConstFilterAdminOWSEmpAbsentIndex = "AdminOWSEmpAbsentIndex";
        private const string ConstFilterAdminSWSEmpPresentIndex = "AdminSWSEmpPresentIndex";
        private const string ConstFilterOWSEmpAbsentIndex = "OWSEmpAbsentIndex";
        private const string ConstFilterSWSEmpPresentIndex = "SWSEmpPresentIndex";
        private const string ConstFilterExcludeEmployeeIndex = "ExcludeEmployeeIndex";
        private const string ConstFilterFutureEmpComingToOfficeIndex = "FutureEmpComingToOfficeIndex";

        private const string ConstFlagIdForPlanningAllowedDays = "F003";

        private readonly IConfiguration _configuration;
        private readonly ISWPPrimaryWorkSpaceDataTableListRepository _primaryWorkSpaceDataTableListRepository;
        private readonly ISWPSmartWorkSpaceDataTableListRepository _smartWorkSpaceDataTableListRepository;
        private readonly ISWPOfficeAtndDataTableListRepository _officeAtndDataTableListRepository;
        private readonly IEmployeeWorkSpaceDataTableListRepository _employeeWorkSpaceDataTableListRepository;
        private readonly ISWPPrimaryWorkSpaceRepository _primaryWorkSpaceRepository;
        private readonly ISWPEmployeeWorkspaceRepository _swpEmployeeWorkspaceRepository;
        private readonly ISWPEmployeeOfficeWorkspaceRepository _swpEmployeeOfficeWorkspaceRepository;
        private readonly ISelectTcmPLRepository _selectTcmPLRepository;
        private readonly IFilterRepository _filterRepository;
        private readonly IAttendanceEmployeeDetailsRepository _attendanceEmployeeDetailsRepository;
        private readonly ISWPAssignCostCodesDataTableListRepository _assignCostCodesDataTableListRepository;

        private readonly ISWPAttendanceStatusDataTableListRepository _swpAttendanceStatusDataTableListRepository;
        private readonly ISWPAttendanceStatusForDayDataTableListRepository _swpAttendanceStatusForDayDataTableListRepository;
        private readonly ISWPAttendanceStatusForMonthDataTableListRepository _swpAttendanceStatusForMonthDataTableListRepository;

        private readonly ISWPAttendanceStatusSubContractDataTableListRepository _swpAttendanceStatusSubContractDataTableListRepository;

        private readonly ISWPAttendanceStatusDatesDataTableListRepository _swpAttendanceStatusDatesDataTableListRepository;
        private readonly ISWPAttendanceStatusWeekNamesDataTableListRepository _swpAttendanceStatusWeekNamesDataTableListRepository;
        private readonly ISWPEmployeesDataTableListRepository _swpEmployeesDataTableListRepository;
        private readonly ISWPHeaderStatusForSmartWorkspaceRepository _swpHeaderStatusForSmartWorkspaceRepository;
        private readonly ISWPHeaderStatusForPrimaryWorkSpaceRepository _swpHeaderStatusForPrimaryWorkSpaceRepository;
        private readonly ISWPPlanningStatusRepository _swpPlanningStatusRepository;
        private readonly ISWPPlanningStatusDeptRepository _swpPlanningStatusDeptRepository;
        private readonly ISWPPrimaryWorkSpaceExcelDataTableListRepository _swpPrimaryWorkSpaceExcelDataTableListRepository;
        private readonly ISWPSmartWorkSpaceExcelDataTableListRepository _swpSmartWorkSpaceExcelDataTableListRepository;
        private readonly ISWPPrimaryWorkSpaceAdminDataTableListRepository _swpPPrimaryWorkSpaceAdminDataTableListRepository;
        private readonly IUtilityRepository _utilityRepository;
        private readonly ISWPEmployeeProjectMappingDataTableListRepository _swpEmployeeProjectMappingDataTableListRepository;
        private readonly IEmployeeProjectMappingDetails _employeeProjectMappingDetails;
        private readonly ISWPEmployeeProjectCreateRepository _swpEmployeeProjectCreateRepository;
        private readonly ISWPEmployeeProjectUpdateRepository _swpEmployeeProjectUpdateRepository;
        private readonly ISWPEmployeeProjectDeleteRepository _swpEmployeeProjectDeleteRepository;
        private readonly INonSWSEmpAtHomeDataTableListRepository _nonSWSEmpAtHomeDataTableListRepository;
        private readonly ISWPDMSDeskAllocationSWPDataTableListRepository _swpDMSDeskAllocationSWPDataTableListRepository;
        private readonly ISWPFlagsRepository _swpFlagsRepository;
        private readonly ISWPFlagsGenericRepository _swpFlagsGenericRepository;
        private readonly ISWPSmartWorkspaceEmpPresentDataTableListRepository _swpSmartWorkspaceEmpPresentDataTableListRepository;
        private readonly IFutureEmpComingToOfficeDataTableListRepository _futureEmpComingToOfficeDataTableListRepository;
        private readonly IFutureEmpComingToOfficeRepository _futureEmpComingToOfficeRepository;
        private readonly IFutureEmpComingToOfficeDeleteRepository _futureEmpComingToOfficeDeleteRepository;
        private readonly ISWPOfficeWorkspaceEmpAbsentDataTableListRepository _swpOfficeWorkspaceEmpAbsentDataTableListRepository;

        private readonly IExcludeEmployeeDataTableListRepository _excludeEmployeeDataTableListRepository;
        private readonly IExcludeEmployeeExcelDataTableListRepository _excludeEmployeeExcelDataTableListRepository;
        private readonly IExcludeEmployeeRepository _excludeEmployeeRepository;
        private readonly IExcludeEmployeeDetails _excludeEmployeeDetails;
        private readonly IExcelTemplate _excelTemplate;

        public SWPController(IConfiguration configuration,
            ISWPPrimaryWorkSpaceDataTableListRepository primaryWorkSpaceDataTableListRepository,
            ISWPSmartWorkSpaceDataTableListRepository smartWorkSpaceAtndDataTableListRepository,
            IEmployeeWorkSpaceDataTableListRepository employeeWorkSpaceDataTableListRepository,
            ISWPOfficeAtndDataTableListRepository officeAtndDataTableListRepository,
            ISWPPrimaryWorkSpaceRepository primaryWorkSpaceRepository,
            ISWPEmployeeWorkspaceRepository swpEmployeeWorkspaceRepository,
            ISWPEmployeeOfficeWorkspaceRepository swpEmployeeOfficeWorkspaceRepository,
            ISelectTcmPLRepository selectTcmPLRepository, IFilterRepository filterRepository,
            IAttendanceEmployeeDetailsRepository attendanceEmployeeDetailsRepository,
            ISWPAssignCostCodesDataTableListRepository assignCostCodesDataTableListRepository,
            ISWPHeaderStatusForSmartWorkspaceRepository swpHeaderStatusForSmartWorkspaceRepository,
            ISWPHeaderStatusForPrimaryWorkSpaceRepository swpHeaderStatusForPrimaryWorkSpaceRepository,
            ISWPEmployeeProjectMappingDataTableListRepository swpEmployeeProjectMappingDataTableListRepository,
            ISWPEmployeeProjectCreateRepository swpEmployeeProjectCreateRepository,
            ISWPEmployeeProjectUpdateRepository swpEmployeeProjectUpdateRepository,
            ISWPEmployeeProjectDeleteRepository swpEmployeeProjectDeleteRepository,
            ISWPPlanningStatusRepository swpPlanningStatusRepository,
            ISWPPlanningStatusDeptRepository swpPlanningStatusDeptRepository,
            ISWPPrimaryWorkSpaceExcelDataTableListRepository swpPrimaryWorkSpaceExcelDataTableListRepository,
            ISWPAttendanceStatusDataTableListRepository swpAttendanceStatusDataTableListRepository,
            ISWPAttendanceStatusForDayDataTableListRepository swpAttendanceStatusForDayDataTableListRepository,
        ISWPAttendanceStatusDatesDataTableListRepository swpAttendanceStatusDatesDataTableListRepository,
        ISWPAttendanceStatusSubContractDataTableListRepository swpAttendanceStatusSubContractDataTableListRepository,

        ISWPAttendanceStatusForMonthDataTableListRepository swpAttendanceStatusForMonthDataTableListRepository,
        ISWPAttendanceStatusWeekNamesDataTableListRepository swpAttendanceStatusWeekNamesDataTableListRepository,
        ISWPEmployeesDataTableListRepository swpEmployeesDataTableListRepository,

            ISWPSmartWorkSpaceExcelDataTableListRepository swpSmartWorkSpaceExcelDataTableListRepository,
            ISWPPrimaryWorkSpaceAdminDataTableListRepository swpPPrimaryWorkSpaceAdminDataTableListRepository,
            INonSWSEmpAtHomeDataTableListRepository nonSWSEmpAtHomeDataTableListRepository,
            ISWPDMSDeskAllocationSWPDataTableListRepository swpDMSDeskAllocationSWPDataTableListRepository,
            ISWPSmartWorkspaceEmpPresentDataTableListRepository swpSmartWorkspaceEmpPresentDataTableListRepository,
            ISWPOfficeWorkspaceEmpAbsentDataTableListRepository swpOfficeWorkspaceEmpAbsentDataTableListRepository,
            IFutureEmpComingToOfficeDataTableListRepository futureEmpComingToOfficeDataTableListRepository,
            IFutureEmpComingToOfficeRepository futureEmpComingToOfficeRepository,
            IFutureEmpComingToOfficeDeleteRepository futureEmpComingToOfficeDeleteRepository,
            IExcludeEmployeeDataTableListRepository excludeEmployeeDataTableListRepository,
            IExcludeEmployeeExcelDataTableListRepository excludeEmployeeExcelDataTableListRepository,
            IExcludeEmployeeRepository excludeEmployeeRepository,
            IExcludeEmployeeDetails excludeEmployeeDetails,
            IEmployeeProjectMappingDetails employeeProjectMappingDetails,

        ISWPFlagsRepository swpFlagsRepository, ISWPFlagsGenericRepository swpFlagsGenericRepository,
            IUtilityRepository utilityRepository, IExcelTemplate excelTemplate

            )
        {
            _configuration = configuration;
            _primaryWorkSpaceDataTableListRepository = primaryWorkSpaceDataTableListRepository;
            _smartWorkSpaceDataTableListRepository = smartWorkSpaceAtndDataTableListRepository;
            _officeAtndDataTableListRepository = officeAtndDataTableListRepository;
            _swpEmployeeWorkspaceRepository = swpEmployeeWorkspaceRepository;
            _employeeWorkSpaceDataTableListRepository = employeeWorkSpaceDataTableListRepository;
            _swpEmployeeOfficeWorkspaceRepository = swpEmployeeOfficeWorkspaceRepository;
            _primaryWorkSpaceRepository = primaryWorkSpaceRepository;
            _selectTcmPLRepository = selectTcmPLRepository;
            _filterRepository = filterRepository;
            _attendanceEmployeeDetailsRepository = attendanceEmployeeDetailsRepository;
            _assignCostCodesDataTableListRepository = assignCostCodesDataTableListRepository;

            _swpHeaderStatusForSmartWorkspaceRepository = swpHeaderStatusForSmartWorkspaceRepository;
            _swpHeaderStatusForPrimaryWorkSpaceRepository = swpHeaderStatusForPrimaryWorkSpaceRepository;
            _swpPlanningStatusRepository = swpPlanningStatusRepository;
            _swpPlanningStatusDeptRepository = swpPlanningStatusDeptRepository;
            _swpPrimaryWorkSpaceExcelDataTableListRepository = swpPrimaryWorkSpaceExcelDataTableListRepository;
            _swpSmartWorkSpaceExcelDataTableListRepository = swpSmartWorkSpaceExcelDataTableListRepository;
            _swpEmployeeProjectCreateRepository = swpEmployeeProjectCreateRepository;
            _swpEmployeeProjectUpdateRepository = swpEmployeeProjectUpdateRepository;
            _swpEmployeeProjectDeleteRepository = swpEmployeeProjectDeleteRepository;
            _swpEmployeeProjectMappingDataTableListRepository = swpEmployeeProjectMappingDataTableListRepository;
            _nonSWSEmpAtHomeDataTableListRepository = nonSWSEmpAtHomeDataTableListRepository;
            _swpDMSDeskAllocationSWPDataTableListRepository = swpDMSDeskAllocationSWPDataTableListRepository;
            _swpAttendanceStatusDataTableListRepository = swpAttendanceStatusDataTableListRepository;
            _swpAttendanceStatusForDayDataTableListRepository = swpAttendanceStatusForDayDataTableListRepository;
            _swpAttendanceStatusForMonthDataTableListRepository = swpAttendanceStatusForMonthDataTableListRepository;
            _swpAttendanceStatusWeekNamesDataTableListRepository = swpAttendanceStatusWeekNamesDataTableListRepository;
            _swpAttendanceStatusDatesDataTableListRepository = swpAttendanceStatusDatesDataTableListRepository;
            _swpEmployeesDataTableListRepository = swpEmployeesDataTableListRepository;
            _swpAttendanceStatusSubContractDataTableListRepository = swpAttendanceStatusSubContractDataTableListRepository;

            _swpPPrimaryWorkSpaceAdminDataTableListRepository = swpPPrimaryWorkSpaceAdminDataTableListRepository;

            _swpSmartWorkspaceEmpPresentDataTableListRepository = swpSmartWorkspaceEmpPresentDataTableListRepository;
            _swpOfficeWorkspaceEmpAbsentDataTableListRepository = swpOfficeWorkspaceEmpAbsentDataTableListRepository;
            _futureEmpComingToOfficeDataTableListRepository = futureEmpComingToOfficeDataTableListRepository;
            _futureEmpComingToOfficeRepository = futureEmpComingToOfficeRepository;
            _futureEmpComingToOfficeDeleteRepository = futureEmpComingToOfficeDeleteRepository;
            _swpFlagsGenericRepository = swpFlagsGenericRepository;
            _swpFlagsRepository = swpFlagsRepository;
            _utilityRepository = utilityRepository;

            _excludeEmployeeDataTableListRepository = excludeEmployeeDataTableListRepository;
            _excludeEmployeeExcelDataTableListRepository = excludeEmployeeExcelDataTableListRepository;
            _excludeEmployeeRepository = excludeEmployeeRepository;
            _excludeEmployeeDetails = excludeEmployeeDetails;
            _employeeProjectMappingDetails = employeeProjectMappingDetails;
            _excelTemplate = excelTemplate;
        }

        public IActionResult Index()
        {
            return View();
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SWPHelper.ActionPrimaryWsPlanning)]
        public IActionResult PrimaryWorkSpacePlanning()
        {
            Notify("Error", "Invalid request", "", NotificationType.error);
            return RedirectToAction("Index", "Home");

            //var swpPlanningStatus = await _swpPlanningStatusRepository.GetPlanningWeekDetails(BaseSpTcmPLGet(), null);

            //if (swpPlanningStatus.PPlanningExists != "OK")
            //{
            //    Notify("Error", "Primary Workspace planning not open.", "", NotificationType.error);
            //    return RedirectToAction("PrimaryWorkSpaceIndex", "SWP", new { Area = "SWP" });
            //}

            //ViewData["PwsPlanningOpen"] = swpPlanningStatus.PPwsOpen;

            //var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            //{
            //    PModuleName = CurrentUserIdentity.CurrentModule,
            //    PMetaId = CurrentUserIdentity.MetaId,
            //    PPersonId = CurrentUserIdentity.EmployeeId,
            //    PMvcActionName = ConstFilterPrimaryWorkSpacePlanning
            //});

            //FilterDataModel filterDataModel = new FilterDataModel();
            //if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            //    filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            //PrimaryWorkSpaceViewModel primaryWorkSpaceViewModel = new PrimaryWorkSpaceViewModel();

            //primaryWorkSpaceViewModel.FilterDataModel = filterDataModel;

            //return View(primaryWorkSpaceViewModel);
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SWPHelper.ActionPrimaryWsStatus)]
        public async Task<IActionResult> PrimaryWorkSpaceIndex()
        {
            var swpPlanningStatus = await _swpPlanningStatusRepository.GetPlanningWeekDetails(BaseSpTcmPLGet(), null);

            PrimaryWorkSpaceViewModel primaryWorkSpaceViewModel = new PrimaryWorkSpaceViewModel();

            primaryWorkSpaceViewModel.PlanningExists = swpPlanningStatus.PPlanningExists;

            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterPrimaryWorkSpacePlanning
            });

            FilterDataModel filterDataModel = new FilterDataModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            primaryWorkSpaceViewModel.FilterDataModel = filterDataModel;

            return View(primaryWorkSpaceViewModel);
        }

        #region PrimaryWorkSpace

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SWPHelper.ActionPrimaryWsStatus)]
        public async Task<JsonResult> GetListEmployeePrimaryWorkSpace(DTParameters param)
        {
            //[RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleManagerHoD)]

            DTResult<PrimaryWorkSpaceDataTableList> result = new DTResult<PrimaryWorkSpaceDataTableList>();
            int totalRow = 0;

            try
            {
                var data = await _primaryWorkSpaceDataTableListRepository.PrimaryWorkSpaceDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
                        //PEmpno = param.Empno,
                        PAssignCode = param.Assign,
                        PEmptypeCsv = param.EmployeeType,
                        PPrimaryWorkspaceCsv = param.PrimaryWorkspaceList,
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

                return Json(result);
            }
            catch (Exception ex)
            {
                return Json(new { error = ex.Message });
            }
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SWPHelper.ActionPrimaryWsPlanning)]
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
                        PPrimaryWorkspaceCsv = param.PrimaryWorkspaceList,
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

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SWPHelper.ActionPrimaryWsPlanning)]
        public async Task<IActionResult> PrimaryWorkSpace(PrimaryWorkspace[] primaryWorkspaces)
        {
            try
            {
                var resultObjArray = PrimaryWorkSpaceToArray(primaryWorkspaces);

                var result = await _primaryWorkSpaceRepository.HoDAssignPrimaryWorkSpaceAsync(
                          BaseSpTcmPLGet(),
                          new ParameterSpTcmPL
                          {
                              PEmpWorkspaceArray = resultObjArray.ToArray()
                          });

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        private string[] PrimaryWorkSpaceToArray(PrimaryWorkspace[] primaryWorkspaces)
        {
            List<string> listresultObj = new List<string>();

            string[] apprlValResult = primaryWorkspaces.Select(o => o.empNo + "," + o.workspace).ToArray();

            if (primaryWorkspaces != null)
            {
                for (int i = 0; i < primaryWorkspaces.Length; i++)
                {
                    string temp1 = "";

                    temp1 = $"{primaryWorkspaces[i].empNo}~!~{primaryWorkspaces[i].workspace}";

                    listresultObj.Add(temp1);
                }
            }

            return listresultObj.ToArray();
        }

        public async Task<IActionResult> PrimaryWorkSpaceFilterGet()
        {
            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterPrimaryWorkSpacePlanning
            });

            var assignList = await _selectTcmPLRepository.SWPCostCodeList4HodSecAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            FilterDataModel filterDataModel = new FilterDataModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            //var empList = await _selectTcmPLRepository.EmployeeListAssignForHoDSec(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            //ViewData["EmpList"] = new SelectList(empList, "DataValueField", "DataTextField", filterDataModel.Empno);

            var employeeTypeList = await _selectTcmPLRepository.EmployeeTypeListSWP(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["EmployeeTypeList"] = new SelectList(employeeTypeList, "DataValueField", "DataTextField");

            var gradeList = await _selectTcmPLRepository.GradeListSWP(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["GradeList"] = new SelectList(gradeList, "DataValueField", "DataTextField");

            ViewData["AssignList"] = new SelectList(assignList, "DataValueField", "DataTextField", filterDataModel.Assign);

            return PartialView("_ModalPrimaryWorkSpaceFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> PrimaryWorkSpaceFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                {
                    string jsonFilter;
                    jsonFilter = JsonConvert.SerializeObject(
                            new
                            {
                                //Empno = filterDataModel.Empno,
                                Assign = filterDataModel.Assign,
                                EmployeeTypeList = filterDataModel.EmployeeTypeList,
                                GradeList = filterDataModel.GradeList,
                                EligibleForSWP = filterDataModel.EligibleForSWP,
                                LaptopUser = filterDataModel.LaptopUser,
                                PrimaryWorkspaceList = filterDataModel.PrimaryWorkspaceList
                            }
                            );

                    var retVal = await _filterRepository.FilterCreateAsync(new Domain.Models.FilterCreate
                    {
                        PModuleName = CurrentUserIdentity.CurrentModule,
                        PMetaId = CurrentUserIdentity.MetaId,
                        PPersonId = CurrentUserIdentity.EmployeeId,
                        PMvcActionName = ConstFilterPrimaryWorkSpacePlanning,
                        PFilterJson = jsonFilter
                    });

                    return Json(new
                    {
                        success = true,
                        //empno = filterDataModel.Empno,
                        assign = filterDataModel.Assign,
                        employeeTypeList = filterDataModel.EmployeeTypeList == null ? string.Empty : string.Join(",", filterDataModel.EmployeeTypeList),
                        gradeList = filterDataModel.GradeList == null ? string.Empty : string.Join(",", filterDataModel.GradeList),
                        eligibleForSWP = filterDataModel.EligibleForSWP,
                        laptopUser = filterDataModel.LaptopUser,
                        primaryWorkspaceList = filterDataModel.PrimaryWorkspaceList == null ? string.Empty : string.Join(",", filterDataModel.PrimaryWorkspaceList)
                    });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        #region Hod Assign Primary Workspace to individual employee

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SWPHelper.ActionPrimaryWsPlanning)]
        public async Task<IActionResult> PWSPlanningForIndividualEmpIndex()
        {
            var swpPlanningStatus = await _swpPlanningStatusRepository.GetPlanningWeekDetails(BaseSpTcmPLGet(), null);
            ViewData["WeekDetails"] = swpPlanningStatus;

            if (swpPlanningStatus.PPlanningExists != "OK")
            {
                Notify("Error", "Primary Workspace planning not open.", "", NotificationType.error);
                return RedirectToAction("PrimaryWorkSpaceIndex", "SWP", new { Area = "SWP" });
            }

            ViewData["PwsPlanningOpen"] = swpPlanningStatus.PPwsOpen;

            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterPrimaryWorkSpacePlanning
            });

            FilterDataModel filterDataModel = new FilterDataModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            PrimaryWorkSpaceViewModel primaryWorkSpaceViewModel = new PrimaryWorkSpaceViewModel();

            primaryWorkSpaceViewModel.FilterDataModel = filterDataModel;

            return View(primaryWorkSpaceViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SWPHelper.ActionPrimaryWsPlanning)]
        public async Task<JsonResult> GetListPWSPlanningForIndividualEmp(DTParameters param)
        {
            var swpPlanningStatus = await _swpPlanningStatusDeptRepository.GetDeptPlanningWeekDetails(BaseSpTcmPLGet(),
                new ParameterSpTcmPL { PAssignCode = param.Assign }
                );

            if (swpPlanningStatus.PPlanningExists != "OK")
            {
                return Json(new { error = "Planning for next week not yet rolled over." });
            }

            DTResultExtension<PrimaryWorkSpaceDataTableList, WeekPlanningStatusDeptOutPut> result = new DTResultExtension<PrimaryWorkSpaceDataTableList, WeekPlanningStatusDeptOutPut>();

            int totalRow = 0;

            try
            {
                var data = await _primaryWorkSpaceDataTableListRepository.PrimaryWorkSpacePlanningDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
                        PAssignCode = param.Assign,
                        PEmptypeCsv = param.EmployeeType,
                        PPrimaryWorkspaceCsv = param.PrimaryWorkspaceList,
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

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SWPHelper.ActionPrimaryWsPlanning)]
        public async Task<IActionResult> PWSEmpPlanningEditForIndividualEmp(string Empno)
        {
            const string PwOnDeputation = "3";

            var swpPlanningStatus = await _swpPlanningStatusRepository.GetPlanningWeekDetails(BaseSpTcmPLGet(), null);

            if (swpPlanningStatus.PPlanningExists != "OK")
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, "Planning for next week not yet rolled over.");
            }

            try
            {
                var data = await _primaryWorkSpaceDataTableListRepository.PrimaryWorkSpacePlanningDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = 0,
                        PPageLength = 100,
                        PEmpno = Empno
                    }
                );

                if (!data.Any())
                {
                    return StatusCode((int)HttpStatusCode.InternalServerError, "Planning for next week not yet rolled over.");
                }
                var jsonData = JsonConvert.SerializeObject(data.First());

                string excludeSWS = IsOk;
                if (data.First().IsSwsAllowed == IsOk && data.First().EmpGrade != "X1")
                    excludeSWS = NotOk;

                var swpTypes = await _selectTcmPLRepository.SWPSWPTypesForHodAsync(BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PExcludeSwsType = excludeSWS,
                        PEmpno = Empno
                    });

                string CurrentPWVal = data.First().PrimaryWorkspace.ToString();

                if (CurrentPWVal == PwOnDeputation)
                {
                    return StatusCode((int)HttpStatusCode.InternalServerError, "Invalid action. Only Admin have rights to change primary workspace from Deputation to Office/Smart workspace");
                }

                ViewData["SWPTypes"] = new SelectList(swpTypes, "DataValueField", "DataTextField", CurrentPWVal);

                var primaryWorkSpaceEditViewModel = JsonConvert.DeserializeObject<PrimaryWorkSpaceEditViewModel>(jsonData);
                primaryWorkSpaceEditViewModel.NewPrimaryWorkspace = decimal.Parse(CurrentPWVal);

                return PartialView("_ModalPWSEditForIndividualEmp", primaryWorkSpaceEditViewModel);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SWPHelper.ActionPrimaryWsPlanning)]
        [HttpPost]
        public async Task<IActionResult> PWSEmpPlanningEditForIndividualEmp([FromForm] PrimaryWorkSpaceEditViewModel primaryWorkSpaceEditViewModel)
        {
            try
            {
                var result = await _primaryWorkSpaceRepository.AssignPrimaryWorkSpaceEmpAsync(
                          BaseSpTcmPLGet(),
                          new ParameterSpTcmPL
                          {
                              PEmpno = primaryWorkSpaceEditViewModel.Empno,
                              PWorkspaceCode = primaryWorkSpaceEditViewModel.NewPrimaryWorkspace,
                          });

                if (result.PMessageType == "OK")
                    return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
                else
                    return StatusCode((int)HttpStatusCode.InternalServerError, result.PMessageText);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        #endregion Hod Assign Primary Workspace to individual employee

        #endregion PrimaryWorkSpace

        #region SmartWorkSpaceAttendance

        public static IList GetWeekDays(DateTime? StartWeekDate)
        {
            var StartWeek = StartWeekDate ?? DateTime.Now;
            var currentDay = StartWeek.DayOfWeek;
            int days = (int)currentDay;
            DateTime sunday = StartWeek.AddDays(-days);
            var daysThisWeek = Enumerable.Range(1, 5)
                .Select(d => sunday.AddDays(d).ToString("dd-MMM-yyyy"))
                .ToList();
            return daysThisWeek;
        }

        public static DateTime GetNextWeekMonday()
        {
            DateTime date = DateTime.Today;

            // lastMonday is always the Monday before nextSunday. When date is a Sunday, lastMonday
            // will be tomorrow.
            int offset = date.DayOfWeek - DayOfWeek.Monday;
            DateTime lastMonday = date.AddDays(-offset);
            DateTime nextSunday = lastMonday.AddDays(6);

            return nextSunday;
        }

        public static int CheckCurrentWeek(DateTime nDate)
        {
            int returnVal = 0; // -1 = Old week , 0 = date in current week and  1 = date in upcoming week
            var dateList = GetWeekDays(nDate);

            if (DateTime.Parse(dateList[4].ToString()) < DateTime.Parse(DateTime.Now.ToShortDateString()))
            {
                returnVal = -1;
                return returnVal;
            }
            foreach (var item in dateList)
            {
                if (DateTime.Parse(item.ToString()) < DateTime.Parse(DateTime.Now.ToShortDateString()))
                {
                    returnVal = -1;
                    break;
                }

                if (DateTime.Parse(item.ToString()) == DateTime.Parse(DateTime.Now.ToShortDateString()))
                {
                    returnVal = 0;
                    break;
                }
                else
                {
                    returnVal = 1;
                }
            }
            return returnVal;
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SWPHelper.ActionSmartWsWsStatus)]
        public async Task<IActionResult> SmartAttendanceIndex()
        {
            SWPSmartWorkSpaceViewModel sWPSmartWorkSpaceViewModel = new SWPSmartWorkSpaceViewModel();
            var swpPlanningStatus = await _swpPlanningStatusRepository.GetPlanningWeekDetails(BaseSpTcmPLGet(), null);
            sWPSmartWorkSpaceViewModel.PlanningExists = swpPlanningStatus.PPlanningExists;

            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterSmartAttendancePlan
            });

            FilterDataModel filterDataModel = new FilterDataModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            sWPSmartWorkSpaceViewModel.FilterDataModel = filterDataModel;

            DateTime nDate = DateTime.Now;

            if (filterDataModel.StartDate != null)
            {
                nDate = (DateTime)filterDataModel.StartDate;
            }

            int sWpHeaderStatus = CheckCurrentWeek(nDate);

            ViewData["SWPHeader"] = "Planning of week days";

            sWPSmartWorkSpaceViewModel.WeekDays = GetWeekDays(nDate);

            return View("SmartAttendanceIndex", sWPSmartWorkSpaceViewModel);
        }

        public async Task<IActionResult> WeeklyAttendanceFilterGetAsync()
        {
            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterSmartAttendancePlan
            });

            var assignList = await _selectTcmPLRepository.SWPCostCodeList4SeatPlan4HodSecAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            FilterDataModel filterDataModel = new FilterDataModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            else
            {
                if (assignList.Any())
                    filterDataModel.Assign = assignList.First().DataValueField;
            }

            var employeeTypeList = await _selectTcmPLRepository.EmployeeTypeListSWP(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["EmployeeTypeList"] = new SelectList(employeeTypeList, "DataValueField", "DataTextField");

            var gradeList = await _selectTcmPLRepository.GradeListSWP(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["GradeList"] = new SelectList(gradeList, "DataValueField", "DataTextField");

            ViewData["AssignList"] = new SelectList(assignList, "DataValueField", "DataTextField", filterDataModel.Assign);
            return PartialView("_ModalWeeklyAttendanceFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> WeeklyAttendanceFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                if (filterDataModel.StartDate != null)
                {
                    if (filterDataModel.StartDate == null)
                        throw new Exception("Date required.");
                }

                {
                    if (string.IsNullOrEmpty(filterDataModel.Assign))
                    {
                        var assignList = await _selectTcmPLRepository.SWPCostCodeList4HodSecAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());
                        if (assignList.Any())
                        {
                            filterDataModel.Assign = assignList.First().DataValueField;
                        }
                    }

                    string jsonFilter;
                    jsonFilter = JsonConvert.SerializeObject(
                            new
                            {
                                StartDate = filterDataModel.StartDate,
                                Empno = filterDataModel.Empno,
                                Assign = filterDataModel.Assign,
                            }
                            );

                    var retVal = await _filterRepository.FilterCreateAsync(new Domain.Models.FilterCreate
                    {
                        PModuleName = CurrentUserIdentity.CurrentModule,
                        PMetaId = CurrentUserIdentity.MetaId,
                        PPersonId = CurrentUserIdentity.EmployeeId,
                        PMvcActionName = ConstFilterSmartAttendancePlan,
                        PFilterJson = jsonFilter
                    });

                    return Json(new
                    {
                        success = true,
                        startDate = filterDataModel.StartDate,
                        empno = filterDataModel.Empno,
                        Assign = filterDataModel.Assign,
                    });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
            //return PartialView("_ModalLeaveFilterSet", filterDataModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SWPHelper.ActionSmartWsWsStatus)]
        public async Task<JsonResult> GetListsForSmartWorkSpaceAttendance(DTParameters param)
        {
            DTResult<SmartWorkSpaceDataTableList> result = new DTResult<SmartWorkSpaceDataTableList>();
            int totalRow = 0;

            DateTime nDate = DateTime.Now;

            if (param.StartDate != null)
            {
                nDate = (DateTime)param.StartDate;
            }

            if (string.IsNullOrEmpty(param.Assign))
            {
                var assignList = await _selectTcmPLRepository.SWPCostCodeList4HodSecAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());
                if (assignList.Any())
                {
                    param.Assign = assignList.First().DataValueField;
                }
            }

            try
            {
                var data = await _smartWorkSpaceDataTableListRepository.SmartWorkSpaceDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PDate = nDate,
                        PAssignCode = param.Assign,
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
                    }
                );

                if (data.Any())
                {
                    totalRow = (int)data.FirstOrDefault().TotalRow.Value;

                    int editAllowed = CheckCurrentWeek(nDate);

                    if (editAllowed == 1)
                    {
                        data.FirstOrDefault().EditAllowed = 1;
                    }
                    else
                    {
                        data.FirstOrDefault().EditAllowed = 0;
                    }
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

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SWPHelper.ActionSmartWsPlanning)]
        public async Task<IActionResult> SmartAttendancePlanning()
        {
            var swpPlanningStatus = await _swpPlanningStatusRepository.GetPlanningWeekDetails(BaseSpTcmPLGet(), null);

            if (swpPlanningStatus.PPlanningExists != "OK")
            {
                Notify("Error", "Planning for next week not yet rolled over.", "", NotificationType.error);
                return RedirectToAction("SmartAttendanceIndex", "SWP", new { Area = "SWP" });
            }

            SWPSmartWorkSpaceViewModel sWPSmartWorkSpaceViewModel = new SWPSmartWorkSpaceViewModel();

            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterSmartAttendancePlan
            });

            FilterDataModel filterDataModel = new FilterDataModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            filterDataModel.StartDate = swpPlanningStatus.PPlanStartDate;
            sWPSmartWorkSpaceViewModel.FilterDataModel = filterDataModel;

            ViewData["SWPHeader"] = "Planning of week days";

            sWPSmartWorkSpaceViewModel.WeekDays = GetWeekDays(swpPlanningStatus.PPlanStartDate);

            return View("SmartAttendancePlanning", sWPSmartWorkSpaceViewModel);
        }

        public async Task<IActionResult> SmartAttendancePlanningFilterGet()
        {
            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterSmartAttendancePlan
            });

            var assignList = await _selectTcmPLRepository.SWPCostCodeList4SeatPlan4HodSecAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            FilterDataModel filterDataModel = new FilterDataModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            else
            {
                if (assignList.Any())
                    filterDataModel.Assign = assignList.First().DataValueField;
            }

            //var employeeTypeList = await _selectTcmPLRepository.EmployeeTypeListSWP(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            //ViewData["EmployeeTypeList"] = new SelectList(employeeTypeList, "DataValueField", "DataTextField");

            var gradeList = await _selectTcmPLRepository.GradeListSWP(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["GradeList"] = new SelectList(gradeList, "DataValueField", "DataTextField");

            ViewData["AssignList"] = new SelectList(assignList, "DataValueField", "DataTextField", filterDataModel.Assign);

            return PartialView("_ModalSmartAttendancePlanningFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> SmartAttendancePlanningFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                {
                    if (string.IsNullOrEmpty(filterDataModel.Assign))
                    {
                        var assignList = await _selectTcmPLRepository.SWPCostCodeList4HodSecAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());
                        if (assignList.Any())
                        {
                            filterDataModel.Assign = assignList.First().DataValueField;
                        }
                    }

                    string jsonFilter;
                    jsonFilter = JsonConvert.SerializeObject(
                            new
                            {
                                Empno = filterDataModel.Empno,
                                Assign = filterDataModel.Assign,
                                EmployeeTypeList = filterDataModel.EmployeeTypeList,
                                GradeList = filterDataModel.GradeList,
                                DeskAssigmentStatus = filterDataModel.DeskAssigmentStatus
                            }
                            );

                    var retVal = await _filterRepository.FilterCreateAsync(new Domain.Models.FilterCreate
                    {
                        PModuleName = CurrentUserIdentity.CurrentModule,
                        PMetaId = CurrentUserIdentity.MetaId,
                        PPersonId = CurrentUserIdentity.EmployeeId,
                        PMvcActionName = ConstFilterSmartAttendancePlan,
                        PFilterJson = jsonFilter
                    });

                    return Json(new
                    {
                        success = true,
                        startDate = filterDataModel.StartDate,
                        empno = filterDataModel.Empno,
                        assign = filterDataModel.Assign,
                        employeeTypeList = filterDataModel.EmployeeTypeList == null ? string.Empty : string.Join(",", filterDataModel.EmployeeTypeList),
                        gradeList = filterDataModel.GradeList == null ? string.Empty : string.Join(",", filterDataModel.GradeList),
                        deskAssigmentStatus = filterDataModel.DeskAssigmentStatus
                    });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SWPHelper.ActionSmartWsPlanning)]
        public async Task<JsonResult> GetListSmartAttendancePlanning(DTParameters param)
        {
            var swpPlanningStatus = await _swpPlanningStatusRepository.GetPlanningWeekDetails(BaseSpTcmPLGet(), null);

            if (swpPlanningStatus.PPlanningExists != "OK")
            {
                return Json(new { error = "Planning for next week not yet rolled over." });
            }

            //DTResult<SmartWorkSpaceDataTableList> result = new DTResult<SmartWorkSpaceDataTableList>();

            DTResultExtension<SmartWorkSpaceDataTableList, WeekPlanningStatusOutPut> result = new DTResultExtension<SmartWorkSpaceDataTableList, WeekPlanningStatusOutPut>();

            int totalRow = 0;

            if (string.IsNullOrEmpty(param.Assign))
            {
                var assignList = await _selectTcmPLRepository.SWPCostCodeList4SeatPlan4HodSecAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());
                if (assignList.Any())
                {
                    param.Assign = assignList.First().DataValueField;
                }
            }

            try
            {
                var data = await _smartWorkSpaceDataTableListRepository.SmartWorkSpaceDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = param.Start,
                        PPageLength = param.Length,

                        PDate = swpPlanningStatus.PPlanStartDate,

                        PAssignCode = param.Assign,
                        PEmptypeCsv = param.EmployeeType,
                        PGradeCsv = param.Grade,
                        PGenericSearch = param.GenericSearch,
                        PDeskAssignmentStatus = param.DeskAssignmentStatus
                    }
                );

                if (data.Any())
                {
                    totalRow = (int)data.FirstOrDefault().TotalRow.Value;

                    if (swpPlanningStatus.PSwsOpen == "OK")
                        data.FirstOrDefault().EditAllowed = 1;
                    else
                        data.FirstOrDefault().EditAllowed = 0;
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

        public async Task<IActionResult> ResetFilter(string ActionId)
        {
            try
            {
                var result = await _filterRepository.FilterResetAsync(new Domain.Models.FilterReset
                {
                    PModuleName = CurrentUserIdentity.CurrentModule,
                    PMetaId = CurrentUserIdentity.MetaId,
                    PPersonId = CurrentUserIdentity.EmployeeId,
                    PMvcActionName = ActionId,
                });

                return Json(new { success = result.OutPSuccess == "OK", response = result.OutPMessage });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        #region SmartWeeklyAttendance

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SWPHelper.ActionSmartWsPlanning)]
        public async Task<IActionResult> SmartWeeklyAttendanceCreate(string empno)
        {
            var swpPlanningStatus = await _swpPlanningStatusRepository.GetPlanningWeekDetails(BaseSpTcmPLGet(), null);

            var flagDetails = await _swpFlagsGenericRepository.SWPFlagDetails(BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PFlagId = ConstFlagIdForPlanningAllowedDays
                });

            if (swpPlanningStatus.PPlanningExists != "OK")
            {
                Notify("Error", "Planning for next week not yet rolled over.", "", NotificationType.error);
                return RedirectToAction("SmartAttendanceIndex", "SWP", new { Area = "SWP" });
            }

            if (flagDetails.PMessageType != "OK")
            {
                Notify("Error", flagDetails.PMessageText, "", NotificationType.error);
                return RedirectToAction("SmartAttendanceIndex", "SWP", new { Area = "SWP" });
            }

            var empdetails = await _attendanceEmployeeDetailsRepository.AttendanceEmployeeDetailsAsync(BaseSpTcmPLGet(),
                   new ParameterSpTcmPL
                   {
                       PEmpno = empno.Trim()
                   }
               );

            var model = new SmartAttendanceCreateViewModel();

            model.Empno = empdetails.Empno;
            model.EmployeeName = empdetails.Name;
            model.EmpGrade = empdetails.EmpGrade;
            model.Parent = empdetails.ParentCode;
            model.Assign = empdetails.AssignCode;
            model.Emptype = empdetails.Emptype;
            model.Projno = empdetails.Projno;
            model.ParentDesc = empdetails.ParentDesc;
            model.AssignDesc = empdetails.AssignDesc;
            model.EmpWorkArea = empdetails.WorkArea;
            model.EmpWorkArea = empdetails.WorkArea;

            DateTime startDate = (DateTime)swpPlanningStatus.PPlanStartDate;
            DateTime endDate = (DateTime)swpPlanningStatus.PPlanEndDate;

            model.WeekStartDate = startDate;
            model.WeekEndDate = endDate;

            var data = await _smartWorkSpaceDataTableListRepository.SmartWorkSpaceEmpDataTableList(
                 BaseSpTcmPLGet(),
                 new ParameterSpTcmPL
                 {
                     PEmpno = empdetails.Empno,
                     PDate = startDate
                 }
             );

            var dayDeskCount = data.Count(n => n.Deskid != null);

            model.DayDeskCount = dayDeskCount;
            model.MaxAttandanceDay = (int)flagDetails.PFlagValueNumber;
            model.Note = flagDetails.PFlagDesc + " - " + flagDetails.PFlagValueNumber;

            model.SmartWorkSpaceDataTableList = data;

            return View(model);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SWPHelper.ActionSmartWsPlanning)]
        public async Task<IActionResult> AjaxSmartWorkAreasPostDesk(string Empno, string Date, string Deskid)
        {
            try
            {
                if (string.IsNullOrEmpty(Empno) || string.IsNullOrEmpty(Date) || string.IsNullOrEmpty(Deskid))
                {
                    throw new Exception($"Something went wrong");
                }

                //List<string> listresultObj = new List<string>();
                //string temp = "";

                //temp = $"{Empno}~!~{Date}~!~{Deskid}~!~1";
                //listresultObj.Add(temp);

                DateTime attendanceDate = DateTime.ParseExact(Date, "dd-MMM-yyyy", null);

                var result = await _primaryWorkSpaceRepository.WeeklyAttendanceAddAsync(
                                            BaseSpTcmPLGet(),
                                            new ParameterSpTcmPL
                                            {
                                                PEmpno = Empno,
                                                PDeskid = Deskid,
                                                PDate = attendanceDate
                                            });

                if (result.PMessageType != IsOk)
                {
                    return Json(new { error = true, response = result.PMessageText });
                }
                else
                {
                    return Json(new { success = true, response = result.PMessageText });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            //var empdetails = await _attendanceEmployeeDetailsRepository.AttendanceEmployeeDetailsAsync(BaseSpTcmPLGet(),
            //     new ParameterSpTcmPL
            //     {
            //         PEmpno = Empno.Trim()
            //     }
            // );

            //var model = new WorkAreaCreateViewModel();
            //model.EmployeeName = empdetails.Name;
            //model.EmpGrade = empdetails.EmpGrade;
            //model.Parent = empdetails.ParentCode;
            //model.Emptype = empdetails.Emptype;

            //return PartialView("_ModalSmartWorkAreaDesksPartial", model);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SWPHelper.ActionSmartWsPlanning)]
        public async Task<IActionResult> AjaxSmartWorkAreasPostDeskDelete(string Empno, string Date, string Deskid)
        {
            try
            {
                if (string.IsNullOrEmpty(Empno) || string.IsNullOrEmpty(Date) || string.IsNullOrEmpty(Deskid))
                {
                    throw new Exception($"Something went wrong");
                }

                //List<string> listresultObj = new List<string>();
                //string temp = "";

                //temp = $"{Empno}~!~{Date}~!~{Deskid}~!~0";
                //listresultObj.Add(temp);

                DateTime attendanceDate = DateTime.ParseExact(Date, "dd-MMM-yyyy", null);

                var result = await _primaryWorkSpaceRepository.WeeklyAttendanceDeleteAsync(
                                            BaseSpTcmPLGet(),
                                            new ParameterSpTcmPL
                                            {
                                                PEmpno = Empno,
                                                PDate = attendanceDate,
                                                PDeskid = Deskid
                                            });

                if (result.PMessageType != IsOk)
                {
                    //return Json(new { error = true, response = result.PMessageText });
                    return StatusCode((int)HttpStatusCode.InternalServerError, result.PMessageText);
                }
                else
                {
                    //return RedirectToAction("SmartWeeklyAttendanceCreate", new { Empno = Empno });

                    return Json(new { success = true, response = result.PMessageText });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            //var empdetails = await _attendanceEmployeeDetailsRepository.AttendanceEmployeeDetailsAsync(BaseSpTcmPLGet(),
            //     new ParameterSpTcmPL
            //     {
            //         PEmpno = Empno.Trim()
            //     }
            // );

            //var model = new WorkAreaCreateViewModel();
            //model.EmployeeName = empdetails.Name;
            //model.EmpGrade = empdetails.EmpGrade;
            //model.Parent = empdetails.ParentCode;
            //model.Emptype = empdetails.Emptype;

            //return RedirectToAction("SmartWeeklyAttendanceCreate", new { empno = Empno });
        }

        #endregion SmartWeeklyAttendance

        #endregion SmartWorkSpaceAttendance

        #region OfficeWorkSpace

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SWPHelper.ActionOfficeWsPlanning)]
        public async Task<IActionResult> OfficeWorkSpaceIndex()
        {
            var swpPlanningStatus = await _swpPlanningStatusRepository.GetPlanningWeekDetails(BaseSpTcmPLGet(), null);

            OfficeAtndViewModel officeAtndViewModel = new OfficeAtndViewModel();

            officeAtndViewModel.PlanningExists = swpPlanningStatus.PPlanningExists;

            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterOfficeWorkSpaceIndex
            });

            FilterDataModel filterDataModel = new FilterDataModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }
            officeAtndViewModel.FilterDataModel = filterDataModel;

            DateTime nDate = DateTime.Now;

            if (filterDataModel.StartDate != null)
            {
                nDate = (DateTime)filterDataModel.StartDate;
            }

            officeAtndViewModel.WeekDays = GetWeekDays(nDate);

            return View(officeAtndViewModel);
        }

        public async Task<IActionResult> OfficeWorkSpaceFilterGet()
        {
            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterOfficeWorkSpaceIndex
            });

            var assignList = await _selectTcmPLRepository.SWPCostCodeList4SeatPlan4HodSecAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            FilterDataModel filterDataModel = new FilterDataModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            //var empList = await _selectTcmPLRepository.EmployeeListAssignForHoDSec(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            //ViewData["EmpList"] = new SelectList(empList, "DataValueField", "DataTextField", filterDataModel.Empno);

            var employeeTypeList = await _selectTcmPLRepository.EmployeeTypeListSWP(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["EmployeeTypeList"] = new SelectList(employeeTypeList, "DataValueField", "DataTextField");

            var gradeList = await _selectTcmPLRepository.GradeListSWP(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["GradeList"] = new SelectList(gradeList, "DataValueField", "DataTextField");

            ViewData["AssignList"] = new SelectList(assignList, "DataValueField", "DataTextField", filterDataModel.Assign);

            return PartialView("_ModalOfficeWorkSpaceFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> OfficeWorkSpaceFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                if (filterDataModel.StartDate != null)
                {
                    if (filterDataModel.StartDate == null)
                        throw new Exception("Date required.");
                }

                {
                    if (string.IsNullOrEmpty(filterDataModel.Assign))
                    {
                        var assignList = await _selectTcmPLRepository.SWPCostCodeList4HodSecAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());
                        if (assignList.Any())
                        {
                            filterDataModel.Assign = assignList.First().DataValueField;
                        }
                    }

                    string jsonFilter;
                    jsonFilter = JsonConvert.SerializeObject(
                            new
                            {
                                StartDate = filterDataModel.StartDate,
                                Empno = filterDataModel.Empno,
                                Assign = filterDataModel.Assign,
                                EmployeeTypeList = filterDataModel.EmployeeTypeList,
                                GradeList = filterDataModel.GradeList,
                                DeskAssigmentStatus = filterDataModel.DeskAssigmentStatus
                            }
                            );

                    var retVal = await _filterRepository.FilterCreateAsync(new Domain.Models.FilterCreate
                    {
                        PModuleName = CurrentUserIdentity.CurrentModule,
                        PMetaId = CurrentUserIdentity.MetaId,
                        PPersonId = CurrentUserIdentity.EmployeeId,
                        PMvcActionName = ConstFilterOfficeWorkSpaceIndex,
                        PFilterJson = jsonFilter
                    });

                    return Json(new
                    {
                        success = true,
                        startDate = filterDataModel.StartDate,
                        empno = filterDataModel.Empno,
                        assign = filterDataModel.Assign,
                        employeeTypeList = filterDataModel.EmployeeTypeList == null ? string.Empty : string.Join(",", filterDataModel.EmployeeTypeList),
                        gradeList = filterDataModel.GradeList == null ? string.Empty : string.Join(",", filterDataModel.GradeList),
                        deskAssigmentStatus = filterDataModel.DeskAssigmentStatus
                    });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SWPHelper.ActionOfficeWsStatus)]
        public async Task<JsonResult> GetListOfficeWorkSpaceEmployees(DTParameters param)
        {
            var swpPlanningStatus = await _swpPlanningStatusRepository.GetPlanningWeekDetails(BaseSpTcmPLGet(), null);

            DTResultExtension<OfficeAtndDataTableList, WeekPlanningStatusOutPut> result = new DTResultExtension<OfficeAtndDataTableList, WeekPlanningStatusOutPut>();

            if (swpPlanningStatus.POwsOpen != "OK")
            {
                result.error = "Office Workspace planning not open.";
                return Json(result);
            }

            //DTResult<OfficeAtndDataTableList> result = new DTResult<OfficeAtndDataTableList>();
            int totalRow = 0;

            //DateTime nDate = DateTime.Now;

            //if (param.StartDate != null)
            //{
            //    nDate = (DateTime)param.StartDate;
            //}

            try
            {
                var data = await _officeAtndDataTableListRepository.OfficeAtndDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PDate = swpPlanningStatus.PPlanStartDate,
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
                        PEmpno = param.Empno,
                        PAssignCode = param.Assign,
                        PEmptypeCsv = param.EmployeeType,
                        PPrimaryWorkspaceCsv = param.PrimaryWorkspaceList,
                        PGradeCsv = param.Grade,
                        PGenericSearch = param.GenericSearch,
                        PDeskAssignmentStatus = param.DeskAssignmentStatus
                    }
                );

                if (data.Any())
                {
                    totalRow = (int)data.FirstOrDefault().TotalRow.Value;

                    //int editAllowed = CheckCurrentWeek(nDate);

                    //if (editAllowed == 1)
                    //{
                    //    data.FirstOrDefault().EditAllowed = 1;
                    //}
                    //else
                    //{
                    //    data.FirstOrDefault().EditAllowed = 0;
                    //}
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
        public async Task<IActionResult> OfficeWorkAreas(string empno, string date)
        {
            var empdetails = await _attendanceEmployeeDetailsRepository.AttendanceEmployeeDetailsAsync(BaseSpTcmPLGet(),
                   new ParameterSpTcmPL
                   {
                       PEmpno = empno.Trim()
                   }
               );

            var model = new WorkAreaCreateViewModel();

            DateTime nDate = DateTime.Now;

            if (!string.IsNullOrEmpty(date))
            {
                nDate = DateTime.Parse(date);
            }

            model.Empno = empdetails.Empno;
            model.EmployeeName = empdetails.Name;
            model.EmpGrade = empdetails.EmpGrade;
            model.Parent = empdetails.ParentCode;
            model.Assign = empdetails.AssignCode;
            model.Emptype = empdetails.Emptype;
            model.ParentDesc = empdetails.ParentDesc;
            model.AssignDesc = empdetails.AssignDesc;
            model.EmpWorkArea = empdetails.WorkArea;

            return PartialView("_ModalOfficeWorkAreasPartial", model);
        }

        [HttpPost]
        public IActionResult OfficeWorkAreasPostBack(string Empno, string Startdate)
        {
            return RedirectToAction("OfficeWorkAreas", "SWP", new { Area = "SWP", empno = Empno, date = Startdate });
        }

        [HttpPost]
        public async Task<IActionResult> OfficeWorkAreaDesks(string Empno, string Workarea, string WorkAreaDesc, string Office, string Floor, string startDate, string Wing)
        {
            if (string.IsNullOrEmpty(Empno))
            {
                throw new Exception($"Employee required ");
            }

            var empdetails = await _attendanceEmployeeDetailsRepository.AttendanceEmployeeDetailsAsync(BaseSpTcmPLGet(),
                               new ParameterSpTcmPL
                               {
                                   PEmpno = Empno.Trim()
                               }
                           );

            try
            {
                if (string.IsNullOrEmpty(Workarea))
                {
                    throw new Exception($"Work area required ");
                }

                WorkAreaCreateViewModel workAreaCreateViewModel = new WorkAreaCreateViewModel();

                workAreaCreateViewModel.WorkArea = Workarea;
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            var weekdays = GetWeekDays(DateTime.Now);

            DateTime newdate = DateTime.Parse(weekdays[0].ToString());

            var model = new WorkAreaCreateViewModel();

            model.Empno = empdetails.Empno;
            model.EmployeeName = empdetails.Name;
            model.EmpGrade = empdetails.EmpGrade;
            model.Parent = empdetails.ParentCode;
            model.Assign = empdetails.AssignCode;
            model.Emptype = empdetails.Emptype;
            model.ParentDesc = empdetails.ParentDesc;
            model.AssignDesc = empdetails.AssignDesc;
            model.EmpWorkArea = empdetails.WorkArea;
            model.WorkAreaDesc = WorkAreaDesc;
            model.Office = Office;
            model.Floor = Floor;
            model.Wing = Wing;

            return PartialView("_ModalOfficeWorkAreaDesksPartial", model);
        }

        /*

         [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListSmartWorkAreaDesks(DTParameters param)
        {
            DTResult<OfficeAtndDataTableList> result = new DTResult<OfficeAtndDataTableList>();
            int totalRow = 0;

            DateTime nDate = DateTime.Now;

            if (param.StartDate != null) { nDate = (DateTime)param.StartDate; }

            try
            {
                var data = await _officeAtndDataTableListRepository.WorkAreaDeskDataTableList(
          BaseSpTcmPLGet(), new ParameterSpTcmPL
          {
              PDate = nDate,
              PWorkArea = param.WorkArea,
              PRowNumber = param.Start,
              PPageLength = param.Length,
              PWing = param.Wing
          });

                if (data.Any()) { totalRow = (int)data.FirstOrDefault().TotalRow.Value; }

                result.draw = param.Draw; result.recordsTotal = totalRow; result.recordsFiltered =
                totalRow; result.data = data.ToList();

                return Json(result);
            }
            catch (Exception ex)
            {
                return Json(new { error = ex.Message });
            }
        }

          [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListOfficeWorkAreaDesks(DTParameters param)
        {
            DTResult<OfficeAtndDataTableList> result = new DTResult<OfficeAtndDataTableList>();
            int totalRow = 0;

            DateTime nDate = DateTime.Now;

            if (param.StartDate != null)
            {
                nDate = (DateTime)param.StartDate;
            }

            try
            {
                var data = await _officeAtndDataTableListRepository.WorkAreaDeskDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PDate = nDate,
                        PWorkArea = param.WorkArea,
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
                        PWing = param.Wing
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
         */

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SWPHelper.ActionOfficeWsPlanning)]
        public async Task<IActionResult> OfficeWorkAreasPostDesk([FromForm] WorkAreaCreateViewModel workAreaCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    if (string.IsNullOrEmpty(workAreaCreateViewModel.Deskid))
                    {
                        throw new Exception($"Desk required ");
                    }

                    var result = await _primaryWorkSpaceRepository.OfficeWorkSpaceAsync(
                              BaseSpTcmPLGet(),
                              new ParameterSpTcmPL
                              {
                                  PEmpno = workAreaCreateViewModel.Empno,
                                  PDeskid = workAreaCreateViewModel.Deskid
                              });

                    if (result.PMessageType != IsOk)
                    {
                        throw new Exception(result.PMessageText.Replace("-", " "));
                    }
                    else
                    {
                        return Json(new { success = true, response = result.PMessageText });
                    }
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            var weekdays = GetWeekDays(DateTime.Now);

            DateTime newdate = DateTime.Parse(weekdays[0].ToString());

            var desks = await _selectTcmPLRepository.DeskListForOfficeSWP(BaseSpTcmPLGet(), new ParameterSpTcmPL { PEmpno = workAreaCreateViewModel.Empno });
            ViewData["Desks"] = new SelectList(desks, "DataValueField", "DataTextField");

            var model = new WorkAreaCreateViewModel();
            model.EmployeeName = workAreaCreateViewModel.EmployeeName;
            model.EmpGrade = workAreaCreateViewModel.EmpGrade;
            model.Parent = workAreaCreateViewModel.Parent;
            model.Emptype = workAreaCreateViewModel.Emptype;

            return PartialView("_ModalOfficeWorkAreaDesksPartial", model);
        }

        #endregion OfficeWorkSpace

        #region SmartWorkAreaDeskSelection

        [HttpGet]
        public async Task<IActionResult> SmartWorkAreas(string empno, string date)
        {
            var empdetails = await _attendanceEmployeeDetailsRepository.AttendanceEmployeeDetailsAsync(BaseSpTcmPLGet(),
                   new ParameterSpTcmPL
                   {
                       PEmpno = empno.Trim()
                   }
               );

            var flags = await _swpFlagsRepository.SWPAllFlags(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            var model = new WorkAreaCreateViewModel();

            DateTime nDate = DateTime.Now;

            if (!string.IsNullOrEmpty(date))
            {
                nDate = DateTime.Parse(date);
            }

            model.Empno = empdetails.Empno;
            model.StartDate = date;
            model.EmployeeName = empdetails.Name;
            model.EmpGrade = empdetails.EmpGrade;
            model.Parent = empdetails.ParentCode;
            model.Assign = empdetails.AssignCode;
            model.Emptype = empdetails.Emptype;
            model.ParentDesc = empdetails.ParentDesc;
            model.AssignDesc = empdetails.AssignDesc;
            model.EmpWorkArea = empdetails.WorkArea;
            model.ShowOpenDesksInSWSPlanning = flags.POpenDesksInSwsPlan == "OK";
            model.ShowRestrictedDesksInSWSPlanning = flags.PRestrictedDesksInSwsPlan == "OK";

            return PartialView("_ModalSmartWorkAreasPartial", model);
        }

        [HttpPost]
        public IActionResult SmartWorkAreasPostBack(string Empno, string Startdate)
        {
            return RedirectToAction("SmartWorkAreas", "SWP", new { Area = "SWP", empno = Empno, date = Startdate });
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SWPHelper.ActionSmartWsWsStatus)]
        public async Task<JsonResult> GetListSmartWorkAreas(DTParameters param)
        {
            //[RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleManagerHoD)]

            DTResult<OfficeAtndDataTableList> result = new DTResult<OfficeAtndDataTableList>();
            int totalRow = 0;

            DateTime nDate = DateTime.Now;

            if (param.StartDate != null)
            {
                nDate = (DateTime)param.StartDate;
            }

            try
            {
                var data = await _officeAtndDataTableListRepository.SmartWorkAreaDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PDate = nDate,
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
                    }
                );

                if (data.Any())
                {
                    totalRow = (int)data.FirstOrDefault().TotalRow.Value;

                    int editAllowed = CheckCurrentWeek(nDate);

                    if (editAllowed == 1)
                    {
                        data.FirstOrDefault().EditAllowed = 1;
                    }
                    else
                    {
                        data.FirstOrDefault().EditAllowed = 0;
                    }
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

        [HttpPost]
        public async Task<IActionResult> SmartWorkAreaDesks(string Empno, string workarea, string areacategory, string workareadesc, string startDate, string wing, string office, string floor, string areatype)
        {
            if (string.IsNullOrEmpty(Empno))
            {
                throw new Exception($"Employee required ");
            }

            var empdetails = await _attendanceEmployeeDetailsRepository.AttendanceEmployeeDetailsAsync(BaseSpTcmPLGet(),
                               new ParameterSpTcmPL
                               {
                                   PEmpno = Empno.Trim()
                               }
                           );
            var flags = await _swpFlagsRepository.SWPAllFlags(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            try
            {
                if (string.IsNullOrEmpty(workarea))
                {
                    throw new Exception($"Work area required ");
                }

                WorkAreaCreateViewModel workAreaCreateViewModel = new WorkAreaCreateViewModel();

                workAreaCreateViewModel.WorkArea = workarea;
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            var weekdays = GetWeekDays(DateTime.Now);

            DateTime newdate = DateTime.Parse(weekdays[0].ToString());

            var model = new WorkAreaCreateViewModel();

            model.Empno = empdetails.Empno;
            model.StartDate = startDate;
            model.EmployeeName = empdetails.Name;
            model.EmpGrade = empdetails.EmpGrade;
            model.Parent = empdetails.ParentCode;
            model.Assign = empdetails.AssignCode;
            model.Emptype = empdetails.Emptype;
            model.ParentDesc = empdetails.ParentDesc;
            model.AssignDesc = empdetails.AssignDesc;
            model.EmpWorkArea = empdetails.WorkArea;
            model.WorkArea = workarea;
            model.AreaCategory = areacategory;
            model.Office = office;
            model.Floor = floor;
            model.Wing = wing;
            model.WorkAreaDesc = workareadesc;
            model.AreaType = areatype;
            model.ShowOpenDesksInSWSPlanning = flags.POpenDesksInSwsPlan == "OK";
            model.ShowRestrictedDesksInSWSPlanning = flags.PRestrictedDesksInSwsPlan == "OK";

            return PartialView("_ModalSmartWorkAreaDesksPartial", model);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SWPHelper.ActionSmartWsPlanning)]
        public async Task<IActionResult> SmartWorkAreasPostDesk([FromForm] WorkAreaCreateViewModel workAreaCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    if (string.IsNullOrEmpty(workAreaCreateViewModel.Deskid))
                    {
                        throw new Exception($"Desk required ");
                    }
                    //return Json(new { error = true, response = "error" });

                    List<string> listresultObj = new List<string>();
                    string temp = "";

                    temp = $"{workAreaCreateViewModel.Empno}~!~{workAreaCreateViewModel.StartDate}~!~{workAreaCreateViewModel.Deskid}~!~1";
                    listresultObj.Add(temp);

                    var result = await _primaryWorkSpaceRepository.WeeklyAttendanceAddAsync(
                                                BaseSpTcmPLGet(),
                                                new ParameterSpTcmPL
                                                {
                                                    PEmpno = workAreaCreateViewModel.Empno,
                                                    PWeeklyAttendance = listresultObj.ToArray()
                                                });

                    if (result.PMessageType != IsOk)
                    {
                        return Json(new { error = true, response = result.PMessageText });
                    }
                    else
                    {
                        return Json(new { success = true, response = result.PMessageText });
                        //RedirectToAction("SmartWeeklyAttendanceCreate", new { empno = workAreaCreateViewModel.Empno });
                    }
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            var weekdays = GetWeekDays(DateTime.Now);

            DateTime newdate = DateTime.Parse(weekdays[0].ToString());

            var desks = await _selectTcmPLRepository.DeskListForOfficeSWP(BaseSpTcmPLGet(), new ParameterSpTcmPL { PEmpno = workAreaCreateViewModel.Empno });
            ViewData["Desks"] = new SelectList(desks, "DataValueField", "DataTextField");

            var model = new WorkAreaCreateViewModel();
            model.EmployeeName = workAreaCreateViewModel.EmployeeName;
            model.EmpGrade = workAreaCreateViewModel.EmpGrade;
            model.Parent = workAreaCreateViewModel.Parent;
            model.Emptype = workAreaCreateViewModel.Emptype;

            return PartialView("_ModalSmartWorkAreaDesksPartial", model);
        }

        #endregion SmartWorkAreaDeskSelection

        #region For Areas and Desks

        #region OfficeWorkspace

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SWPHelper.ActionOfficeWsPlanning)]
        public async Task<JsonResult> GetListGeneralWorkAreasForOfficeWorkspace(DTParameters param)
        {
            DTResult<OfficeAtndDataTableList> result = new DTResult<OfficeAtndDataTableList>();
            int totalRow = 0;

            DateTime nDate = DateTime.Now;

            if (param.StartDate != null)
            {
                nDate = (DateTime)param.StartDate;
            }

            try
            {
                var data = await _officeAtndDataTableListRepository.OfficeGeneralWorkAreaDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PDate = nDate,
                        PEmpno = param.Empno,
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
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
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SWPHelper.ActionOfficeWsPlanning)]
        public async Task<JsonResult> GetListWorkAreaDesksForOfficeWorkspace(DTParameters param)
        {
            DTResult<OfficeAtndDataTableList> result = new DTResult<OfficeAtndDataTableList>();
            int totalRow = 0;

            DateTime nDate = DateTime.Now;

            if (param.StartDate != null)
            {
                nDate = (DateTime)param.StartDate;
            }

            try
            {
                var data = await _officeAtndDataTableListRepository.OfficeGeneralWorkAreaDeskDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PDate = nDate,
                        PWorkArea = param.WorkArea,
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
                        POffice = param.Office,
                        PFloor = param.Floor,
                        PWing = param.Wing
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

        #endregion OfficeWorkspace

        #region SmartWorkspace

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SWPHelper.ActionSmartWsPlanning)]
        public async Task<JsonResult> GetListReservedWorkAreasForSmartWorkspace(DTParameters param)
        {
            DTResult<OfficeAtndDataTableList> result = new DTResult<OfficeAtndDataTableList>();
            int totalRow = 0;

            DateTime nDate = DateTime.Now;

            if (param.StartDate != null)
            {
                nDate = (DateTime)param.StartDate;
            }

            try
            {
                var data = await _officeAtndDataTableListRepository.SmartReservedWorkAreaDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PDate = nDate,
                        PEmpno = param.Empno,
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
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
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SWPHelper.ActionSmartWsPlanning)]
        public async Task<JsonResult> GetListGeneralWorkAreasForSmartWorkspace(DTParameters param)
        {
            DTResult<OfficeAtndDataTableList> result = new DTResult<OfficeAtndDataTableList>();
            int totalRow = 0;
            //if (totalRow == 0)
            //    return Json(result);

            var empdetails = await _attendanceEmployeeDetailsRepository.AttendanceEmployeeDetailsAsync(BaseSpTcmPLGet(),
                               new ParameterSpTcmPL
                               {
                                   PEmpno = param.Empno.Trim()
                               }
                           );

            var flags = await _swpFlagsRepository.SWPAllFlags(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            try
            {
                IEnumerable<OfficeAtndDataTableList> data = Enumerable.Empty<OfficeAtndDataTableList>();

                if (flags.POpenDesksInSwsPlan == "OK")
                {
                    data = await _officeAtndDataTableListRepository.SmartGeneralWorkAreaDataTableList(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PEmpno = param.Empno,
                            PDate = param.StartDate,
                            PRowNumber = param.Start,
                            PPageLength = param.Length,
                        }
                    );
                }
                else if (flags.PRestrictedDesksInSwsPlan == "OK" && !string.IsNullOrWhiteSpace(empdetails.WorkArea))
                {
                    data = await _officeAtndDataTableListRepository.SmartGeneralWorkAreaRestrictedDataTableList(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PEmpno = param.Empno,
                            PDate = param.StartDate,
                            PRowNumber = param.Start,
                            PPageLength = param.Length,
                        }
                    );
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
                return Json(new { error = ex.Message });
            }
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SWPHelper.ActionSmartWsPlanning)]
        public async Task<JsonResult> GetListRestrictedWorkAreasForSmartWorkspace(DTParameters param)
        {
            DTResult<OfficeAtndDataTableList> result = new DTResult<OfficeAtndDataTableList>();
            int totalRow = 0;

            DateTime nDate = DateTime.Now;

            if (param.StartDate != null)
            {
                nDate = (DateTime)param.StartDate;
            }

            try
            {
                var data = await _officeAtndDataTableListRepository.SmartRestrictedWorkAreaDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PDate = nDate,
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
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
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SWPHelper.ActionSmartWsPlanning)]
        public async Task<JsonResult> GetListWorkAreaDesksForSmartWorkspace(DTParameters param)
        { //For code management only
            DTResult<OfficeAtndDataTableList> result = new DTResult<OfficeAtndDataTableList>();
            int totalRow = 0;

            DateTime nDate = DateTime.Now;

            if (param.StartDate != null)
            {
                nDate = (DateTime)param.StartDate;
            }

            try
            {
                var data = await _officeAtndDataTableListRepository.SmartWorkAreaDeskDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PDate = nDate,
                        PWorkArea = param.WorkArea,
                        PAreaCategory = param.AreaCategory,
                        POffice = param.Office,
                        PFloor = param.Floor,
                        PWing = param.Wing,

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

        #endregion SmartWorkspace

        #endregion For Areas and Desks

        #region SwpHeaderStatus

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> HeaderStatusForPrimaryWorkSpace(DTParameters param)
        {
            try
            {
                var swpPlanningStatus = await _swpPlanningStatusRepository.GetPlanningWeekDetails(BaseSpTcmPLGet(), null);

                //var empdetails = await _attendanceEmployeeDetailsRepository.AttendanceEmployeeDetailsAsync(BaseSpTcmPLGet(),
                //    new ParameterSpTcmPL
                //    {
                //        PEmpno = param.Empno
                //    }
                //);

                DateTime nDate = DateTime.Now;

                if (param.StartDate != null)
                {
                    nDate = (DateTime)param.StartDate;
                }

                var result = await _swpHeaderStatusForPrimaryWorkSpaceRepository.HeaderStatusForPrimaryWorkSpaceAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL
                {
                    PAssignCode = param.Assign,
                });

                return Json(new
                {
                    TotalEmpCount = result.PTotalEmpCount,
                    EmpCountOfficeWorkspace = result.PEmpCountOfficeWorkspace,
                    EmpCountSmartWorkspace = result.PEmpCountSmartWorkspace,
                    EmpCountNotInHo = result.PEmpCountNotInHo,
                    NextWeekMonday = swpPlanningStatus.PPlanStartDate?.ToString("dd-MMM-yyyy"),
                    EmpPercentageOfficeWorkspace = result.PEmpPercOfficeWorkspace,
                    EmpPercentageSmartWorkspace = result.PEmpPercSmartWorkspace
                });
            }
            catch (Exception ex)
            {
                return Json(new { error = ex.Message });
            }
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> HeaderStatusForPrimaryWorkSpacePlanning(DTParameters param)
        {
            try
            {
                var swpPlanningStatus = await _swpPlanningStatusRepository.GetPlanningWeekDetails(BaseSpTcmPLGet(), null);

                //var empdetails = await _attendanceEmployeeDetailsRepository.AttendanceEmployeeDetailsAsync(BaseSpTcmPLGet(),
                //    new ParameterSpTcmPL
                //    {
                //        PEmpno = param.Empno
                //    }
                //);

                DateTime nDate = DateTime.Now;

                if (param.StartDate != null)
                {
                    nDate = (DateTime)param.StartDate;
                }

                var result = await _swpHeaderStatusForPrimaryWorkSpaceRepository.HeaderStatusForPrimaryWorkSpacePlanningAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL
                {
                    PAssignCode = param.Assign,
                });

                return Json(new
                {
                    TotalEmpCount = result.PTotalEmpCount,
                    EmpCountOfficeWorkspace = result.PEmpCountOfficeWorkspace,
                    EmpCountSmartWorkspace = result.PEmpCountSmartWorkspace,
                    EmpCountNotInHo = result.PEmpCountNotInHo,
                    NextWeekMonday = swpPlanningStatus.PPlanStartDate?.ToString("dd-MMM-yyyy"),
                    EmpPercentageOfficeWorkspace = result.PEmpPercOfficeWorkspace,
                    EmpPercentageSmartWorkspace = result.PEmpPercSmartWorkspace
                });
            }
            catch (Exception ex)
            {
                return Json(new { error = ex.Message });
            }
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> HeaderStatusForSmartWorkSpace(DTParameters param)
        {
            try
            {
                var empdetails = await _attendanceEmployeeDetailsRepository.AttendanceEmployeeDetailsAsync(BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PEmpno = param.Empno
                    }
                );

                DateTime nDate = DateTime.Now;

                if (param.StartDate != null)
                {
                    nDate = (DateTime)param.StartDate;
                }
                if (string.IsNullOrEmpty(param.Assign))
                {
                    var assignList = await _selectTcmPLRepository.SWPCostCodeList4SeatPlan4HodSecAsync
                        (BaseSpTcmPLGet(), new ParameterSpTcmPL()); if (assignList.Any())
                    { param.Assign = assignList.First().DataValueField; }
                }

                var result = await
                _swpHeaderStatusForSmartWorkspaceRepository.HeaderStatusForSmartWorkSpaceAsync(BaseSpTcmPLGet(),
                new ParameterSpTcmPL { PAssignCode = param.Assign, PDate = nDate });

                return Json(new
                {
                    CostcodeDesc = result.PCostcodeDesc,

                    EmpCountSmartWorkspace = result.PEmpCountSmartWorkspace,
                    MondayEmpCount = result.PEmpCountMon,
                    TuesdayEmpCount = result.PEmpCountTue,
                    WednesdayEmpCount = result.PEmpCountWed,
                    ThursdayEmpCount = result.PEmpCountThu,
                    FridayEmpCount = result.PEmpCountFri,
                    AssignCostcodeDesc = result.PCostcodeDesc
                });
            }
            catch (Exception ex)
            {
                return Json(new { error = ex.Message });
            }
        }

        #endregion SwpHeaderStatus

        #region >>>>>>>>>>> Excel Download <<<<<<<<<<<<<<

        public async Task<IActionResult> ExcelDownloadPrimaryWorkspaceCurrentGet()
        {
            var assignList = await _selectTcmPLRepository.SWPCostCodeList4HodSecAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            FilterDataModel filterDataModel = new FilterDataModel();

            var empList = await _selectTcmPLRepository.EmployeeListAssignForHoDSec(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["EmpList"] = new SelectList(empList, "DataValueField", "DataTextField");

            ViewData["AssignList"] = new SelectList(assignList, "DataValueField", "DataTextField");

            return PartialView("_ModalExcelDownloadPrimaryWorkSpace", filterDataModel);
        }

        public async Task<IActionResult> ExcelDownloadPrimaryWorkspacePlanningGet()
        {
            var assignList = await _selectTcmPLRepository.SWPCostCodeList4HodSecAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            FilterDataModel filterDataModel = new FilterDataModel();

            var empList = await _selectTcmPLRepository.EmployeeListAssignForHoDSec(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["EmpList"] = new SelectList(empList, "DataValueField", "DataTextField");

            ViewData["AssignList"] = new SelectList(assignList, "DataValueField", "DataTextField");

            return PartialView("_ModalExcelDownloadPrimaryWorkSpace", filterDataModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ExcelDownloadPrimaryWorkspacePlanning(string[] assign)
        {
            try
            {
                string StrFimeName;
                string strAssignCSV = assign.Length > 0 ? string.Join(',', assign) : string.Empty;

                var timeStamp = DateTime.Now.ToFileTime();
                StrFimeName = "PrimaryWsPlanning_" + timeStamp.ToString();

                var data = await _swpPrimaryWorkSpaceExcelDataTableListRepository.PrimaryWorkSpacePlanningExcelDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PAssignCodesCsv = strAssignCSV,
                    });

                if (data == null) { return NotFound(); }

                var json = JsonConvert.SerializeObject(data);

                IEnumerable<PrimaryWorkspaceExcelDataTableList> excelData = JsonConvert.DeserializeObject<IEnumerable<PrimaryWorkspaceExcelDataTableList>>(json);


                var byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, "Primary workspace status", "PrimaryWorkspace");

                return File(byteContent,
                            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                            StrFimeName + ".xlsx");
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        public async Task<IActionResult> ExcelDownloadPrimaryWorkspaceCurrent(string[] assign)
        {
            try
            {
                string StrFimeName;
                string strAssignCSV = assign.Length > 0 ? string.Join(',', assign) : string.Empty;

                var timeStamp = DateTime.Now.ToFileTime();
                StrFimeName = "PrimaryWsStatus_" + timeStamp.ToString();

                DataTable dt = new DataTable();
                string strUser = User.Identity.Name;

                var data = await _swpPrimaryWorkSpaceExcelDataTableListRepository.PrimaryWorkSpaceCurrentExcelDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PAssignCodesCsv = strAssignCSV
                    });

                if (data == null) { return NotFound(); }
                var json = JsonConvert.SerializeObject(data);

                IEnumerable<PrimaryWorkspaceExcelDataTableList> excelData = JsonConvert.DeserializeObject<IEnumerable<PrimaryWorkspaceExcelDataTableList>>(json);


                var byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, "Primary workspace status", "PrimaryWorkspace");

                return File(byteContent,
                            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                            StrFimeName + ".xlsx");
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        public async Task<IActionResult> ExcelDownloadSWSFilterGet()
        {
            var assignList = await _selectTcmPLRepository.SWPCostCodeList4SeatPlan4HodSecAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            FilterDataModel filterDataModel = new FilterDataModel();

            ViewData["AssignList"] = new SelectList(assignList, "DataValueField", "DataTextField");

            return PartialView("_ModalExcelDownloadSWSFilerGet", filterDataModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ExcelDownloadSWSCurrent(string assign)
        {
            try
            {
                string StrFimeName;
                //string strAssignCSV = assign.Length > 0 ? string.Join(',', assign) : string.Empty;

                var timeStamp = DateTime.Now.ToFileTime();
                StrFimeName = "SmartWorkspacePlanning_" + timeStamp.ToString();

                DataTable dt = new DataTable();
                string strUser = User.Identity.Name;

                var data = await _swpSmartWorkSpaceExcelDataTableListRepository.SmartWorkSpaceCurrentExcelDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PAssignCode = assign
                    });

                if (data == null) { return NotFound(); }

                var byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(data, "Smart workspace planning", "SmartWorkspace");

                return File(byteContent,
                            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                            StrFimeName + ".xlsx");
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ExcelDownloadSWSPlanning(string assign)
        {
            try
            {
                var swpPlanningStatus = await _swpPlanningStatusRepository.GetPlanningWeekDetails(BaseSpTcmPLGet(), null);

                string StrFileName;
                //string strAssignCSV = assign.Length > 0 ? string.Join(',', assign) : string.Empty;

                var timeStamp = DateTime.Now.ToFileTime();
                StrFileName = "SmartWorkspacePlanning_" + DateTime.Now.ToString("yyyyMMdd_HHmm");

                var data = await _swpSmartWorkSpaceExcelDataTableListRepository.SmartWorkSpacePlanningExcelDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PAssignCode = assign
                    });

                if (data == null) { return NotFound(); }

                var byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(
                    data,
                    "Smart workspace planning " + swpPlanningStatus.PPlanStartDate?.ToString("dd-MMM-yyyy") + " - " + swpPlanningStatus.PPlanEndDate?.ToString("dd-MMM-yyyy"),
                    "SmartWorkspace"
                    );

                return File(byteContent,
                            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                            StrFileName + ".xlsx");
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        public async Task<IActionResult> ExcelDownloadDeskallocationSWP()
        {
            try
            {
                string StrFileName = "DeskallocationSWP_" + DateTime.Now.ToFileTime().ToString();

                var data = await _swpDMSDeskAllocationSWPDataTableListRepository.DeskAllocationSWPList(
                            BaseSpTcmPLGet(),
                            new ParameterSpTcmPL
                            {
                            });

                if (data == null) { return NotFound(); }

                var byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(data, "Deskallocation - SWP", "Data");

                return File(byteContent,
                            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                            StrFileName + ".xlsx");
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        #endregion >>>>>>>>>>> Excel Download <<<<<<<<<<<<<<

        #region EmployeeProjectMapping

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SWPHelper.ActionPrimaryWsPlanning)]
        [Authorize]
        public async Task<IActionResult> EmployeeProjectMappingIndex()
        {
            if (!(
                    CurrentUserIdentity.ProfileActions.Any(pa => pa.ActionId == SWPHelper.ActionPrimaryWsPlanning) ||
                    CurrentUserIdentity.ProfileActions.Any(pa => pa.ActionId == SWPHelper.ActionPrimaryWsStatus)
              ))
            {
                Forbid();
            }
            var swpPlanningStatus = await _swpPlanningStatusRepository.GetPlanningWeekDetails(BaseSpTcmPLGet(), null);

            EmployeeProjectMappingViewModel employeeProjectMappingViewModel = new EmployeeProjectMappingViewModel();

            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterEmployeeProjectMappingIndex
            });

            FilterDataModel filterDataModel = new FilterDataModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }
            employeeProjectMappingViewModel.FilterDataModel = filterDataModel;

            return View(employeeProjectMappingViewModel);
        }

        public async Task<IActionResult> EmployeeProjectMappingFilterGet()
        {
            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterEmployeeProjectMappingIndex
            });

            var assignList = await _selectTcmPLRepository.SWPCostCodeList4HodSecAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            FilterDataModel filterDataModel = new FilterDataModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            else
            {
                if (assignList.Any())
                    filterDataModel.Assign = assignList.First().DataValueField;
            }
            var empList = await _selectTcmPLRepository.EmployeeListAssignForHoDSec(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["EmpList"] = new SelectList(empList, "DataValueField", "DataTextField", filterDataModel.Empno);

            ViewData["AssignList"] = new SelectList(assignList, "DataValueField", "DataTextField", filterDataModel.Assign);

            var projectList = await _selectTcmPLRepository.ProjectListSWP(BaseSpTcmPLGet(), null);
            ViewData["ProjectList"] = new SelectList(projectList, "DataValueField", "DataTextField", filterDataModel.Projno);

            return PartialView("_EmployeeProjectMappingFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> EmployeeProjectMappingFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                if (filterDataModel.StartDate != null)
                {
                    if (filterDataModel.StartDate == null)
                        throw new Exception("Date required.");
                }

                {
                    if (string.IsNullOrEmpty(filterDataModel.Assign))
                    {
                        var assignList = await _selectTcmPLRepository.SWPCostCodeList4HodSecAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());
                        if (assignList.Any())
                        {
                            filterDataModel.Assign = assignList.First().DataValueField;
                        }
                    }

                    string jsonFilter;
                    jsonFilter = JsonConvert.SerializeObject(
                            new
                            {
                                StartDate = filterDataModel.StartDate,
                                Empno = filterDataModel.Empno,
                                Assign = filterDataModel.Assign,
                                Projno = filterDataModel.Projno,
                            }
                            );

                    var retVal = await _filterRepository.FilterCreateAsync(new Domain.Models.FilterCreate
                    {
                        PModuleName = CurrentUserIdentity.CurrentModule,
                        PMetaId = CurrentUserIdentity.MetaId,
                        PPersonId = CurrentUserIdentity.EmployeeId,
                        PMvcActionName = ConstFilterEmployeeProjectMappingIndex,
                        PFilterJson = jsonFilter
                    });

                    return Json(new
                    {
                        success = true,
                        startDate = filterDataModel.StartDate,
                        empno = filterDataModel.Empno,
                        Assign = filterDataModel.Assign,
                        Projno = filterDataModel.Projno,
                    });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [Authorize]
        public async Task<JsonResult> GetListEmployeeProjectMapping(DTParameters param)
        {
            if (!(
                    CurrentUserIdentity.ProfileActions.Any(pa => pa.ActionId == SWPHelper.ActionPrimaryWsPlanning) ||
                    CurrentUserIdentity.ProfileActions.Any(pa => pa.ActionId == SWPHelper.ActionPrimaryWsStatus)
                ))
            {
                Forbid();
            }

            DTResult<EmployeeProjectMappingDataTableList> result = new DTResult<EmployeeProjectMappingDataTableList>();
            int totalRow = 0;

            DateTime nDate = DateTime.Now;

            if (param.StartDate != null)
            {
                nDate = (DateTime)param.StartDate;
            }

            try
            {
                var data = await _swpEmployeeProjectMappingDataTableListRepository.EmployeeProjectMappingDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
                        PAssignCode = param.Assign,
                        PProjno = param.Projno,
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

                return Json(result);
            }
            catch (Exception ex)
            {
                return Json(new { error = ex.Message });
            }
        }

        public async Task<IActionResult> EmployeeProjectMappingCreate()
        {
            var employeeList = await _selectTcmPLRepository.EmployeeListAssignForHoDSec(BaseSpTcmPLGet(), null);
            ViewData["EmployeeList"] = new SelectList(employeeList, "DataValueField", "DataTextField");

            var projectList = await _selectTcmPLRepository.ProjectListSWP(BaseSpTcmPLGet(), null);
            ViewData["ProjectList"] = new SelectList(projectList, "DataValueField", "DataTextField");

            var employeeProjectMappingCreateViewModel = new EmployeeProjectMappingCreateViewModel();
            return PartialView("_ModalEmployeeProjectMappingCreatePartial", employeeProjectMappingCreateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> EmployeeProjectMappingCreate([FromForm] EmployeeProjectMappingCreateViewModel employeeProjectMappingCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _swpEmployeeProjectCreateRepository.EmployeeProjectCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PEmpno = employeeProjectMappingCreateViewModel.Empno,
                            PProjno = employeeProjectMappingCreateViewModel.Projno
                        });

                    if (result.PMessageType != IsOk)
                    {
                        throw new Exception(result.PMessageText.Replace("-", " "));
                    }
                    else
                    {
                        return Json(new { success = true, response = result.PMessageText });
                    }
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            var employeeList = await _selectTcmPLRepository.EmployeeListAssignForHoDSec(BaseSpTcmPLGet(), null);
            ViewData["EmployeeList"] = new SelectList(employeeList, "DataValueField", "DataTextField", employeeProjectMappingCreateViewModel.Empno);

            var projectList = await _selectTcmPLRepository.ProjectListSWP(BaseSpTcmPLGet(), null);
            ViewData["ProjectList"] = new SelectList(projectList, "DataValueField", "DataTextField", employeeProjectMappingCreateViewModel.Projno);

            return PartialView("_ModalEmployeeProjectMappingCreatePartial", employeeProjectMappingCreateViewModel);
        }

        public async Task<IActionResult> EmployeeProjectMappingUpdate(string applicationid)
        {
            //_employeeProjectMappingDetails
            EmployeeProjectMappingDetailViewModel employeeProjectMappingDetailViewModel = new EmployeeProjectMappingDetailViewModel();
            var EmployeeProjectMappingUpdateViewModel = new EmployeeProjectMappingUpdateViewModel();

            var result = await _employeeProjectMappingDetails.EmployeeProjectMappingDetailsAsync(
                         BaseSpTcmPLGet(),
                         new ParameterSpTcmPL
                         {
                             PApplicationId = applicationid
                         });

            if (result.PMessageType != IsOk)
            {
                throw new Exception(result.PMessageText.Replace("-", " "));
            }
            else
            {
                EmployeeProjectMappingUpdateViewModel.Projno = result.PProjno;
                EmployeeProjectMappingUpdateViewModel.Empno = result.PEmpno;
                EmployeeProjectMappingUpdateViewModel.Empname = result.PEmpName;

                EmployeeProjectMappingUpdateViewModel.KeyId = applicationid;
            }

            var projectList = await _selectTcmPLRepository.ProjectListSWP(BaseSpTcmPLGet(), null);
            ViewData["ProjectList"] = new SelectList(projectList, "DataValueField", "DataTextField", employeeProjectMappingDetailViewModel.Projno);

            return PartialView("_ModalEmployeeProjectMappingUpdate", EmployeeProjectMappingUpdateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> EmployeeProjectMappingUpdate([FromForm] EmployeeProjectMappingUpdateViewModel employeeProjectMappingUpdateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _swpEmployeeProjectUpdateRepository.UpdateEmployeeProjectAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PApplicationId = employeeProjectMappingUpdateViewModel.KeyId,
                            PProjno = employeeProjectMappingUpdateViewModel.Projno
                        });

                    if (result.PMessageType != IsOk)
                    {
                        throw new Exception(result.PMessageText.Replace("-", " "));
                    }
                    else
                    {
                        return Json(new { success = true, response = result.PMessageText });
                    }
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            var employeeList = await _selectTcmPLRepository.EmployeeListAssignForHoDSec(BaseSpTcmPLGet(), null);
            ViewData["EmployeeList"] = new SelectList(employeeList, "DataValueField", "DataTextField", employeeProjectMappingUpdateViewModel.Empno);

            var projectList = await _selectTcmPLRepository.ProjectListSWP(BaseSpTcmPLGet(), null);
            ViewData["ProjectList"] = new SelectList(projectList, "DataValueField", "DataTextField", employeeProjectMappingUpdateViewModel.Projno);

            return PartialView("_ModalEmployeeProjectMappingUpdatePartial", employeeProjectMappingUpdateViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> EmployeeProjectMappingDelete(string ApplicationId)
        {
            try
            {
                var result = await _swpEmployeeProjectDeleteRepository.DeleteEmployeeProjectAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL { PApplicationId = ApplicationId }
                    );

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                //return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));

                return Json(new { success = false, response = ex.Message });
            }
        }

        #endregion EmployeeProjectMapping

        #region Swp Employee Status

        [HttpGet]
        public async Task<IActionResult> EmployeeSWPWorkStatusIndex()
        {
            EmployeeSWPWorkStatusViewModel model = new EmployeeSWPWorkStatusViewModel();

            model = await GetWorkDetails(null);

            return View(model);
        }

        [HttpPost]
        public async Task<IActionResult> EmployeeSWPWorkStatus(string employeeNo)
        {
            if (string.IsNullOrEmpty(employeeNo))
            {
                throw new Exception("Employee required.");
            }

            EmployeeSWPWorkStatusViewModel model = new EmployeeSWPWorkStatusViewModel();

            model = await GetWorkDetails(employeeNo);

            return PartialView("_EmployeeSWPWorkStatusPartial", model);
        }

        [HttpPost]
        public async Task<IActionResult> SelfSWPWorkStatusPartial()
        {
            EmployeeSWPWorkStatusViewModel model = new EmployeeSWPWorkStatusViewModel();

            model = await GetWorkDetails(null);

            return PartialView("_EmployeeSWPWorkStatusPartial", model);
        }

        public async Task<EmployeeSWPWorkStatusViewModel> GetWorkDetails(string empno)
        {
            string employeeNo;
            if (!string.IsNullOrEmpty(empno))
            {
                employeeNo = empno.Trim();
            }
            else
            {
                employeeNo = CurrentUserIdentity.EmpNo;
            }

            EmployeeSWPWorkStatusViewModel model = new EmployeeSWPWorkStatusViewModel();

            var empdetails = await _attendanceEmployeeDetailsRepository.AttendanceEmployeeDetailsAsync(BaseSpTcmPLGet(),
                  new ParameterSpTcmPL
                  {
                      PEmpno = employeeNo
                  }
              );

            var swpWeekPlanningStatus = await _swpPlanningStatusRepository.GetPlanningWeekDetails(BaseSpTcmPLGet(), null);

            var empPWSDetails = await _swpEmployeeWorkspaceRepository.GetEmployeePrimaryWorkspace(BaseSpTcmPLGet(),
                 new ParameterSpTcmPL
                 {
                     PEmpno = employeeNo
                 });

            IEnumerable<SmartWorkSpaceDataTableList> planSws = null, currSws = null;

            if (empPWSDetails.PCurrentPws == 2)
            {
                currSws = await _smartWorkSpaceDataTableListRepository.SmartWorkSpaceEmpDataTableList(BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PEmpno = employeeNo,
                        PDate = swpWeekPlanningStatus.PCurrStartDate
                    }
                    );
            }

            if (empPWSDetails.PPlanningPws.GetValueOrDefault() == 2)
            {
                planSws = await _smartWorkSpaceDataTableListRepository.SmartWorkSpaceEmpDataTableList(BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PEmpno = employeeNo,
                        PDate = swpWeekPlanningStatus.PPlanStartDate
                    }
                    );
            }

            if (swpWeekPlanningStatus.PPlanningExists == "OK" && swpWeekPlanningStatus.PSwsOpen == "KO")
            {
                model.IsShowPlanning = true;
            }
            else
            {
                model.IsShowPlanning = false;
            }

            model.Empno = empdetails.Empno;
            model.EmployeeName = empdetails.Name;
            model.EmpGrade = empdetails.EmpGrade;
            model.Parent = empdetails.ParentCode;
            model.Assign = empdetails.AssignCode;
            model.Emptype = empdetails.Emptype;
            model.Projno = empdetails.Projno;
            model.ParentDesc = empdetails.ParentDesc;
            model.AssignDesc = empdetails.AssignDesc;
            model.EmpWorkArea = empdetails.WorkArea;

            model.WeekStartDate = swpWeekPlanningStatus.PCurrStartDate;
            model.WeekEndDate = swpWeekPlanningStatus.PCurrEndDate;

            model.PlanningWeekStartDate = (DateTime)swpWeekPlanningStatus.PPlanStartDate;
            model.PlanningWeekEndDate = (DateTime)swpWeekPlanningStatus.PPlanEndDate;

            model.CurrentWorkspaceText = empPWSDetails.PCurrentPwsText;
            model.PlanningWorkspaceText = empPWSDetails.PPlanningPwsText;
            model.CurrentWorkspaceVal = ((int)empPWSDetails.PCurrentPws);
            model.PlanningWorkspaceVal = ((int)empPWSDetails.PPlanningPws);

            model.CurrentDesk = empPWSDetails.PCurrDeskId;
            model.CurrentOffice = empPWSDetails.PCurrOffice;
            model.CurrentFloor = empPWSDetails.PCurrFloor;
            model.CurrentWing = empPWSDetails.PCurrWing;

            model.PlanningDesk = empPWSDetails.PPlanDeskId;
            model.PlanningOffice = empPWSDetails.PPlanOffice;
            model.PlanningFloor = empPWSDetails.PPlanFloor;
            model.PlanningWing = empPWSDetails.PPlanWing;

            if (!(currSws == null))
            {
                var json = JsonConvert.SerializeObject(currSws);

                IEnumerable<EmployeeWorkSpaceDataTableList> currSwsData = JsonConvert.DeserializeObject<IEnumerable<EmployeeWorkSpaceDataTableList>>(json);
                model.CurrentWeekDataTableList = currSwsData;
            }
            if (!(planSws == null))
            {
                var json = JsonConvert.SerializeObject(planSws);

                IEnumerable<EmployeeWorkSpaceDataTableList> planSwsData = JsonConvert.DeserializeObject<IEnumerable<EmployeeWorkSpaceDataTableList>>(json);
                model.PlanningWeekDataTableList = planSwsData;
            }

            return model;
        }

        #endregion Swp Employee Status

        #region ADMIN PWS

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SWPHelper.ActionPrimaryWsStatusAdmin)]
        public async Task<IActionResult> AdminPWSCurrentIndex()
        {
            var swpPlanningStatus = await _swpPlanningStatusRepository.GetPlanningWeekDetails(BaseSpTcmPLGet(), null);

            ViewData["WeekDetails"] = swpPlanningStatus;

            PrimaryWorkSpaceViewModel primaryWorkSpaceViewModel = new PrimaryWorkSpaceViewModel();

            primaryWorkSpaceViewModel.PlanningExists = swpPlanningStatus.PPlanningExists;

            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterAdminPWSPlanning
            });

            FilterDataModel filterDataModel = new FilterDataModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            primaryWorkSpaceViewModel.FilterDataModel = filterDataModel;

            return View(primaryWorkSpaceViewModel);
        }

        public async Task<IActionResult> AdminPWSFilterGet()
        {
            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterAdminPWSPlanning
            });

            var assignList = await _selectTcmPLRepository.SWPCostCodeList4AdminAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            FilterDataModel filterDataModel = new FilterDataModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            //var empList = await _selectTcmPLRepository.EmployeeListAssignForHoDSec(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            //ViewData["EmpList"] = new SelectList(empList, "DataValueField", "DataTextField", filterDataModel.Empno);

            var employeeTypeList = await _selectTcmPLRepository.EmployeeTypeListSWP(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["EmployeeTypeList"] = new SelectList(employeeTypeList, "DataValueField", "DataTextField");

            var gradeList = await _selectTcmPLRepository.GradeListSWP(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["GradeList"] = new SelectList(gradeList, "DataValueField", "DataTextField");

            ViewData["AssignList"] = new SelectList(assignList, "DataValueField", "DataTextField", filterDataModel.Assign);

            return PartialView("_ModalAdminPWSFilterSet", filterDataModel);
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SWPHelper.ActionPrimaryWsStatusAdmin)]
        public async Task<JsonResult> GetListAdminEmployeePWSCurrent(DTParameters param)
        {
            DTResult<PrimaryWorkSpaceDataTableList> result = new DTResult<PrimaryWorkSpaceDataTableList>();
            int totalRow = 0;

            var swpPlanningStatus = await _swpPlanningStatusRepository.GetPlanningWeekDetails(BaseSpTcmPLGet(), null);

            try
            {
                var data = await _primaryWorkSpaceDataTableListRepository.PrimaryWorkSpace4AdminDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PStartDate = swpPlanningStatus.PCurrStartDate,
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
                        PEmpno = param.Empno,
                        PAssignCode = param.Assign,
                        PEmptypeCsv = param.EmployeeType,
                        PPrimaryWorkspaceCsv = param.PrimaryWorkspaceList,
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

                return Json(result);
            }
            catch (Exception ex)
            {
                return Json(new { error = ex.Message });
            }
        }

        public async Task<IActionResult> AdminPWSPlanningIndex()
        {
            var swpPlanningStatus = await _swpPlanningStatusRepository.GetPlanningWeekDetails(BaseSpTcmPLGet(), null);

            ViewData["WeekDetails"] = swpPlanningStatus;

            PrimaryWorkSpaceViewModel primaryWorkSpaceViewModel = new PrimaryWorkSpaceViewModel();

            primaryWorkSpaceViewModel.PlanningExists = swpPlanningStatus.PPlanningExists;

            if (swpPlanningStatus.PPlanningExists != "OK")
            {
                Notify("Error", "Planning for next week not yet rolled over.", "", NotificationType.error);
                return RedirectToAction("AdminPWSCurrentIndex");
            }

            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterAdminPWSPlanning
            });

            FilterDataModel filterDataModel = new FilterDataModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            primaryWorkSpaceViewModel.FilterDataModel = filterDataModel;

            return View(primaryWorkSpaceViewModel);
        }

        public async Task<IActionResult> AdminPWSPlanningFilterGet()
        {
            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterAdminPWSPlanning
            });

            var assignList = await _selectTcmPLRepository.SWPCostCodeList4AdminAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            FilterDataModel filterDataModel = new FilterDataModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            //var empList = await _selectTcmPLRepository.EmployeeListAssignForHoDSec(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            //ViewData["EmpList"] = new SelectList(empList, "DataValueField", "DataTextField", filterDataModel.Empno);

            var employeeTypeList = await _selectTcmPLRepository.EmployeeTypeListSWP(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["EmployeeTypeList"] = new SelectList(employeeTypeList, "DataValueField", "DataTextField");

            var gradeList = await _selectTcmPLRepository.GradeListSWP(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["GradeList"] = new SelectList(gradeList, "DataValueField", "DataTextField");

            ViewData["AssignList"] = new SelectList(assignList, "DataValueField", "DataTextField", filterDataModel.Assign);

            return PartialView("_ModalAdminPWSFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> AdminPWSPlanningFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                {
                    string jsonFilter;
                    jsonFilter = JsonConvert.SerializeObject(
                            new
                            {
                                Empno = filterDataModel.Empno,
                                Assign = filterDataModel.Assign,
                                EmployeeTypeList = filterDataModel.EmployeeTypeList,
                                GradeList = filterDataModel.GradeList,
                                EligibleForSWP = filterDataModel.EligibleForSWP,
                                LaptopUser = filterDataModel.LaptopUser,
                                PrimaryWorkspaceList = filterDataModel.PrimaryWorkspaceList
                            }
                            );

                    var retVal = await _filterRepository.FilterCreateAsync(new Domain.Models.FilterCreate
                    {
                        PModuleName = CurrentUserIdentity.CurrentModule,
                        PMetaId = CurrentUserIdentity.MetaId,
                        PPersonId = CurrentUserIdentity.EmployeeId,
                        PMvcActionName = ConstFilterAdminPWSPlanning,
                        PFilterJson = jsonFilter
                    });

                    return Json(new
                    {
                        success = true,
                        empno = filterDataModel.Empno,
                        assign = filterDataModel.Assign,
                        employeeTypeList = filterDataModel.EmployeeTypeList == null ? string.Empty : string.Join(",", filterDataModel.EmployeeTypeList),
                        gradeList = filterDataModel.GradeList == null ? string.Empty : string.Join(",", filterDataModel.GradeList),
                        eligibleForSWP = filterDataModel.EligibleForSWP,
                        laptopUser = filterDataModel.LaptopUser,
                        primaryWorkspaceList = filterDataModel.PrimaryWorkspaceList == null ? string.Empty : string.Join(",", filterDataModel.PrimaryWorkspaceList)
                    });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SWPHelper.ActionPrimaryWsStatusAdmin)]
        public async Task<JsonResult> GetListAdminEmployeePWSPlanning(DTParameters param)
        {
            DTResult<PrimaryWorkSpaceDataTableList> result = new DTResult<PrimaryWorkSpaceDataTableList>();
            int totalRow = 0;
            //if (string.IsNullOrEmpty(param.Assign))
            //{
            //    var assignList = await _selectTcmPLRepository.SWPCostCodeList4AdminAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            //    if (assignList.Any())
            //    {
            //        param.Assign = assignList.First().DataValueField;
            //    }
            //}

            var swpPlanningStatus = await _swpPlanningStatusRepository.GetPlanningWeekDetails(BaseSpTcmPLGet(), null);

            try
            {
                var data = await _primaryWorkSpaceDataTableListRepository.PrimaryWorkSpacePlanning4AdminDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PStartDate = swpPlanningStatus.PPlanStartDate,
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
                        PEmpno = param.Empno,
                        PAssignCode = param.Assign,
                        PEmptypeCsv = param.EmployeeType,
                        PPrimaryWorkspaceCsv = param.PrimaryWorkspaceList,
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

                return Json(result);
            }
            catch (Exception ex)
            {
                return Json(new { error = ex.Message });
            }
        }

        public async Task<IActionResult> ExcelDownloadAdminPWSPlanning()
        {
            try
            {
                string excelFileName = "PrimaryWsTemplate.xlsx";
                string summarySheetName = "Summary";
                string dataSheetName = "PrimaryWorkspace";
                string pwsDataDataTableName = "PWSData";
                string summaryTitle = "Primary workspace planning summary as on " + DateTime.Now.ToString("dd-MMM-yyyy HH:mm");

                string datatTitle = summaryTitle.Replace(" summary", "");

               //var template = new XLTemplate(StorageHelper.GetFilePath(Path.Combine(StorageHelper.SWP.TCMPLAppTemplatesRepository,StorageHelper.SWP.RepositorySWP), FileName: excelFileName, Configuration));
                var template = new XLTemplate(StorageHelper.GetTemplateFilePath(StorageHelper.SWP.RepositorySWP, FileName: excelFileName, Configuration));

                string strFileName;

                var timeStamp = DateTime.Now.ToFileTime();
                strFileName = "PrimaryWsPlanning_" + DateTime.Now.ToString("yyyyMMdd_HHmm") + ".xlsx";

                string strUser = User.Identity.Name;
                var swpPlanningStatus = await _swpPlanningStatusRepository.GetPlanningWeekDetails(BaseSpTcmPLGet(), null);

                var data = await _primaryWorkSpaceDataTableListRepository.PrimaryWorkSpace4AdminDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PStartDate = swpPlanningStatus.PPlanStartDate,
                        PRowNumber = 0,
                        PPageLength = 100000,
                        PEmpno = null,
                        PAssignCode = null,
                        PEmptypeCsv = null,
                        PPrimaryWorkspaceCsv = null,
                        PGradeCsv = null,
                        PLaptopUser = null,
                        PEligibleForSwp = null,
                        PGenericSearch = null
                    });

                if (data == null) { return NotFound(); }

                var json = JsonConvert.SerializeObject(data);

                IEnumerable<AdminPWSExcelModel> excelData = JsonConvert.DeserializeObject<IEnumerable<AdminPWSExcelModel>>(json);

                var assignCodeList = await _assignCostCodesDataTableListRepository.AssignCostCodesDataTableListAsync(BaseSpTcmPLGet(), null);

                var wb = template.Workbook;

                wb.Table(pwsDataDataTableName).ReplaceData(excelData);

                wb.Table(pwsDataDataTableName).SetShowAutoFilter(false);

                wb.Worksheet(summarySheetName).Cell("A5").InsertData(assignCodeList);

                var assignCodesCount = assignCodeList.Count() + 4;

                if (assignCodeList.Count() > 1)
                {
                    var rngFormulae = wb.Worksheet(summarySheetName).Range("C5:I5");

                    string rngCostcodes = "C6:C" + assignCodesCount.ToString();
                    wb.Worksheet(summarySheetName).Range(rngCostcodes).Value = rngFormulae.ToString();
                }

                wb.Worksheet(summarySheetName).Cell("A1").Value = summaryTitle;
                wb.Worksheet(dataSheetName).Cell("A1").Value = datatTitle;

                wb.Worksheet(summarySheetName).Cell(@$"B{assignCodesCount + 1}").Value = "Total";

                wb.Worksheet(summarySheetName).Cell(@$"C{assignCodesCount + 1}").FormulaA1 = @$"=SUM(C5:C{assignCodesCount})";
                wb.Worksheet(summarySheetName).Cell(@$"E{assignCodesCount + 1}").FormulaA1 = @$"=SUM(E5:E{assignCodesCount})";
                wb.Worksheet(summarySheetName).Cell(@$"G{assignCodesCount + 1}").FormulaA1 = @$"=SUM(G5:G{assignCodesCount})";
                wb.Worksheet(summarySheetName).Cell(@$"I{assignCodesCount + 1}").FormulaA1 = @$"=SUM(I5:I{assignCodesCount})";

                wb.Worksheet(summarySheetName).Cell(@$"D{assignCodesCount + 1}").FormulaA1 = @$"=(C{assignCodesCount + 1}/I{assignCodesCount + 1})";
                wb.Worksheet(summarySheetName).Cell(@$"F{assignCodesCount + 1}").FormulaA1 = @$"=(E{assignCodesCount + 1}/I{assignCodesCount + 1})";
                wb.Worksheet(summarySheetName).Cell(@$"H{assignCodesCount + 1}").FormulaA1 = @$"=(F{assignCodesCount + 1}/I{assignCodesCount + 1})";

                wb.Worksheet(summarySheetName).Cell(@$"D{assignCodesCount + 1}").Style.NumberFormat.NumberFormatId = 9;
                wb.Worksheet(summarySheetName).Cell(@$"F{assignCodesCount + 1}").Style.NumberFormat.NumberFormatId = 9;
                wb.Worksheet(summarySheetName).Cell(@$"H{assignCodesCount + 1}").Style.NumberFormat.NumberFormatId = 9;

                wb.Worksheet(summarySheetName).Range(@$"A5:I{assignCodesCount + 1}").Style.Border.InsideBorder = ClosedXML.Excel.XLBorderStyleValues.Thin;
                wb.Worksheet(summarySheetName).Range(@$"A5:I{assignCodesCount + 1}").Style.Border.OutsideBorder = ClosedXML.Excel.XLBorderStyleValues.Thin;

                wb.Worksheet(summarySheetName).Range(@$"A{assignCodesCount + 1}:I{assignCodesCount + 1}").Style.Font.Bold = true;

                byte[] byteContent = null;

                using (MemoryStream ms = new MemoryStream())
                {
                    wb.SaveAs(ms);
                    byte[] buffer = ms.GetBuffer();
                    long length = ms.Length;
                    byteContent = ms.ToArray();
                }

                return File(byteContent,
                        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                        strFileName);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            //try
            //{
            //    string StrFimeName;

            // var timeStamp = DateTime.Now.ToFileTime(); StrFimeName = "PrimaryWsPlanning_" + DateTime.Now.ToString("yyyyMMdd_HHmm");

            // DataTable dt = new DataTable(); string strUser = User.Identity.Name; var
            // swpPlanningStatus = await
            // _swpPlanningStatusRepository.GetPlanningWeekDetails(BaseSpTcmPLGet(), null);

            // var data = await
            // _primaryWorkSpaceDataTableListRepository.PrimaryWorkSpacePlanning4AdminDataTableList(
            // BaseSpTcmPLGet(), new ParameterSpTcmPL { PStartDate =
            // swpPlanningStatus.PPlanStartDate, PRowNumber = 0, PPageLength = 100000, PEmpno =
            // null, PAssignCode = null, PEmptypeCsv = null, PPrimaryWorkspaceCsv = null, PGradeCsv
            // = null, PLaptopUser = null, PEligibleForSwp = null, PGenericSearch = null });

            // if (data == null) { return NotFound(); }

            // var json = JsonConvert.SerializeObject(data);

            // IEnumerable<AdminPWSExcelModel> excelData = JsonConvert.DeserializeObject<IEnumerable<AdminPWSExcelModel>>(json);

            // var byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, "Primary
            // workspace planning as on " + DateTime.Now.ToString("dd-MMM-yyyy HH:mm"), "PrimaryWorkspace");

            //    return File(byteContent,
            //                "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
            //                StrFimeName + ".xlsx");
            //}
            //catch (Exception ex)
            //{
            //    return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            //}
        }

        public async Task<IActionResult> ExcelDownloadAdminPWSCurrent()
        {
            try
            {
                string excelFileName = "PrimaryWsTemplate.xlsx";
                string summarySheetName = "Summary";
                string dataSheetName = "PrimaryWorkspace";
                string pwsDataDataTableName = "PWSData";
                string summaryTitle = "Primary workspace summary - current week as on " + DateTime.Now.ToString("dd-MMM-yyyy HH:mm");

                string datatTitle = summaryTitle.Replace(" summary", "");

                //var template = new XLTemplate(StorageHelper.GetFilePath(Path.Combine(StorageHelper.SWP.TCMPLAppTemplatesRepository, StorageHelper.SWP.RepositorySWP), FileName: excelFileName, Configuration));
                var template = new XLTemplate(StorageHelper.GetTemplateFilePath(StorageHelper.SWP.RepositorySWP, FileName: excelFileName, Configuration));

                string strFileName;

                //var timeStamp = DateTime.Now.ToFileTime();
                strFileName = "PrimaryWsCurrent_" + DateTime.Now.ToString("yyyyMMdd_HHmm") + ".xlsx";

                string strUser = User.Identity.Name;
                var swpPlanningStatus = await _swpPlanningStatusRepository.GetPlanningWeekDetails(BaseSpTcmPLGet(), null);

                var data = await _primaryWorkSpaceDataTableListRepository.PrimaryWorkSpace4AdminDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PStartDate = swpPlanningStatus.PCurrStartDate,
                        PRowNumber = 0,
                        PPageLength = 100000,
                        PEmpno = null,
                        PAssignCode = null,
                        PEmptypeCsv = null,
                        PPrimaryWorkspaceCsv = null,
                        PGradeCsv = null,
                        PLaptopUser = null,
                        PEligibleForSwp = null,
                        PGenericSearch = null
                    });

                if (data == null) { return NotFound(); }

                var json = JsonConvert.SerializeObject(data);

                IEnumerable<AdminPWSExcelModel> excelData = JsonConvert.DeserializeObject<IEnumerable<AdminPWSExcelModel>>(json);

                var assignCodeList = await _assignCostCodesDataTableListRepository.AssignCostCodesDataTableListAsync(BaseSpTcmPLGet(), null);

                var wb = template.Workbook;

                wb.Table(pwsDataDataTableName).ReplaceData(excelData);

                wb.Table(pwsDataDataTableName).SetShowAutoFilter(false);

                wb.Worksheet(summarySheetName).Cell("A5").InsertData(assignCodeList);

                var assignCodesCount = assignCodeList.Count() + 4;

                if (assignCodeList.Count() > 1)
                {
                    var rngFormulae = wb.Worksheet(summarySheetName).Range("C5:I5");

                    string rngCostcodes = "C6:C" + assignCodesCount.ToString();
                    wb.Worksheet(summarySheetName).Range(rngCostcodes).Value = rngFormulae.ToString();
                }

                wb.Worksheet(summarySheetName).Cell("A1").Value = summaryTitle;
                wb.Worksheet(dataSheetName).Cell("A1").Value = datatTitle;

                wb.Worksheet(summarySheetName).Cell(@$"B{assignCodesCount + 1}").Value = "Total";

                wb.Worksheet(summarySheetName).Cell(@$"C{assignCodesCount + 1}").FormulaA1 = @$"=SUM(C5:C{assignCodesCount})";
                wb.Worksheet(summarySheetName).Cell(@$"E{assignCodesCount + 1}").FormulaA1 = @$"=SUM(E5:E{assignCodesCount})";
                wb.Worksheet(summarySheetName).Cell(@$"G{assignCodesCount + 1}").FormulaA1 = @$"=SUM(G5:G{assignCodesCount})";
                wb.Worksheet(summarySheetName).Cell(@$"I{assignCodesCount + 1}").FormulaA1 = @$"=SUM(I5:I{assignCodesCount})";

                wb.Worksheet(summarySheetName).Cell(@$"D{assignCodesCount + 1}").FormulaA1 = @$"=(C{assignCodesCount + 1}/I{assignCodesCount + 1})";
                wb.Worksheet(summarySheetName).Cell(@$"F{assignCodesCount + 1}").FormulaA1 = @$"=(E{assignCodesCount + 1}/I{assignCodesCount + 1})";
                wb.Worksheet(summarySheetName).Cell(@$"H{assignCodesCount + 1}").FormulaA1 = @$"=(F{assignCodesCount + 1}/I{assignCodesCount + 1})";

                wb.Worksheet(summarySheetName).Cell(@$"D{assignCodesCount + 1}").Style.NumberFormat.NumberFormatId = 9;
                wb.Worksheet(summarySheetName).Cell(@$"F{assignCodesCount + 1}").Style.NumberFormat.NumberFormatId = 9;
                wb.Worksheet(summarySheetName).Cell(@$"H{assignCodesCount + 1}").Style.NumberFormat.NumberFormatId = 9;

                wb.Worksheet(summarySheetName).Range(@$"A5:I{assignCodesCount + 1}").Style.Border.InsideBorder = ClosedXML.Excel.XLBorderStyleValues.Thin;
                wb.Worksheet(summarySheetName).Range(@$"A5:I{assignCodesCount + 1}").Style.Border.OutsideBorder = ClosedXML.Excel.XLBorderStyleValues.Thin;

                wb.Worksheet(summarySheetName).Range(@$"A{assignCodesCount + 1}:I{assignCodesCount + 1}").Style.Font.Bold = true;

                byte[] byteContent = null;

                using (MemoryStream ms = new MemoryStream())
                {
                    wb.SaveAs(ms);
                    byte[] buffer = ms.GetBuffer();
                    long length = ms.Length;
                    byteContent = ms.ToArray();
                }

                return File(byteContent,
                        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                        strFileName);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SWPHelper.ActionPrimaryWsAdminEdit)]
        public async Task<IActionResult> AdminPWSEmpPlanningEdit(string Empno)
        {
            var swpPlanningStatus = await _swpPlanningStatusRepository.GetPlanningWeekDetails(BaseSpTcmPLGet(), null);

            if (swpPlanningStatus.PPlanningExists != "OK")
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, "Planning for next week not yet rolled over.");
            }

            try
            {
                var data = await _primaryWorkSpaceDataTableListRepository.PrimaryWorkSpacePlanningDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = 0,
                        PPageLength = 100,
                        PEmpno = Empno
                    }
                );

                if (!data.Any())
                {
                    return StatusCode((int)HttpStatusCode.InternalServerError, "Planning for next week not yet rolled over.");
                }
                var jsonData = JsonConvert.SerializeObject(data.First());

                string excludeSWS = IsOk;
                if (data.First().IsSwsAllowed == IsOk)
                    excludeSWS = NotOk;

                var swpTypes = await _selectTcmPLRepository.SWPSWPTypesAsync(BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PExcludeSwsType = excludeSWS
                    });

                string CurrentPWVal = data.First().PrimaryWorkspace.ToString();
                ViewData["SWPTypes"] = new SelectList(swpTypes, "DataValueField", "DataTextField", CurrentPWVal);

                var primaryWorkSpaceEditViewModel = JsonConvert.DeserializeObject<PrimaryWorkSpaceEditViewModel>(jsonData);
                primaryWorkSpaceEditViewModel.NewPrimaryWorkspace = decimal.Parse(CurrentPWVal);

                //var primaryWorkSpaceEditViewModel = JsonConvert.DeserializeObject<PrimaryWorkSpaceEditViewModel>(jsonData);

                return PartialView("_ModalPWSEditPartial", primaryWorkSpaceEditViewModel);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        #region PrimaryWorkspace Edit New

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SWPHelper.ActionPrimaryWsAdminEdit)]
        public async Task<JsonResult> GetListAdminEmpPWSPlanningForEdit(DTParameters param)
        {
            DTResult<PrimaryWorkSpaceForAdminDataTableList> result = new DTResult<PrimaryWorkSpaceForAdminDataTableList>();
            int totalRow = 0;
            var swpPlanningStatus = await _swpPlanningStatusRepository.GetPlanningWeekDetails(BaseSpTcmPLGet(), null);

            try
            {
                var data = await _swpPPrimaryWorkSpaceAdminDataTableListRepository.PrimaryWorkSpaceForAdminDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
                        PEmpno = param.Empno
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
                return Json(new { error = ex.Message });
            }
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SWPHelper.ActionPrimaryWsAdminEdit)]
        public async Task<IActionResult> AdminPWSEmpPlanningList(string Empno)
        {
            try
            {
                var data = await _primaryWorkSpaceDataTableListRepository.PrimaryWorkSpace4AdminDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = 0,
                        PPageLength = 100,
                        PEmpno = Empno
                    }
                );

                if (!data.Any())
                {
                    return StatusCode((int)HttpStatusCode.InternalServerError, "Planning for next week not yet rolled over.");
                }
                var jsonData = JsonConvert.SerializeObject(data.First());

                string excludeSWS = IsOk;
                if (data.First().IsSwsAllowed == IsOk)
                    excludeSWS = NotOk;

                var swpTypes = await _selectTcmPLRepository.SWPSWPTypesAsync(BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PExcludeSwsType = excludeSWS
                    });

                string CurrentPWVal = data.First().PrimaryWorkspace.ToString();
                ViewData["SWPTypes"] = new SelectList(swpTypes, "DataValueField", "DataTextField", CurrentPWVal);

                var primaryWorkSpaceAdminEditViewModel = JsonConvert.DeserializeObject<PrimaryWorkSpaceAdminEditViewModel>(jsonData);
                primaryWorkSpaceAdminEditViewModel.NewPrimaryWorkspace = decimal.Parse(CurrentPWVal);

                return PartialView("_ModalAdminPWSEmpPlanningList", primaryWorkSpaceAdminEditViewModel);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SWPHelper.ActionPrimaryWsAdminEdit)]
        public async Task<IActionResult> AdminPWSEmpPlanningAssign(string Empno)
        {
            try
            {
                var data = await _primaryWorkSpaceDataTableListRepository.PrimaryWorkSpace4AdminDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = 0,
                        PPageLength = 100,
                        PEmpno = Empno
                    }
                );

                if (!data.Any())
                {
                    return StatusCode((int)HttpStatusCode.InternalServerError, "No data.");
                }
                var jsonData = JsonConvert.SerializeObject(data.First());

                string excludeSWS = IsOk;
                if (data.First().IsSwsAllowed == IsOk)
                    excludeSWS = NotOk;

                var swpTypes = await _selectTcmPLRepository.SWPSWPTypesAsync(BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PExcludeSwsType = excludeSWS
                    });

                string CurrentPWVal = data.First().PrimaryWorkspace.ToString();
                ViewData["SWPTypes"] = new SelectList(swpTypes, "DataValueField", "DataTextField", CurrentPWVal);

                var primaryWorkSpaceAdminEditViewModel = JsonConvert.DeserializeObject<PrimaryWorkSpaceAdminEditViewModel>(jsonData);
                primaryWorkSpaceAdminEditViewModel.NewPrimaryWorkspace = decimal.Parse(CurrentPWVal);

                return PartialView("_ModalAdminPWSEmpPlanningAssign", primaryWorkSpaceAdminEditViewModel);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SWPHelper.ActionPrimaryWsAdminEdit)]
        [HttpPost]
        public async Task<IActionResult> AdminPWSEmpPlanningAssign([FromForm] PrimaryWorkSpaceAdminEditViewModel primaryWorkSpaceAdminEditViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _primaryWorkSpaceRepository.AdminAssignPrimaryWorkSpaceAsync(
                          BaseSpTcmPLGet(),
                          new ParameterSpTcmPL
                          {
                              PEmpno = primaryWorkSpaceAdminEditViewModel.Empno,
                              PWorkspaceCode = primaryWorkSpaceAdminEditViewModel.NewPrimaryWorkspace,
                              PStartDate = primaryWorkSpaceAdminEditViewModel.StartDate
                          });
                    if (result.PMessageType == "OK")
                    {
                        return RedirectToAction("AdminPWSEmpPlanningAssign", new { empno = primaryWorkSpaceAdminEditViewModel.Empno });
                    }
                    else
                    {
                        return StatusCode((int)HttpStatusCode.InternalServerError, result.PMessageText);
                    }
                }
                return PartialView("_ModalAdminPWSEmpPlanningAssign", primaryWorkSpaceAdminEditViewModel);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SWPHelper.ActionPrimaryWsAdminEdit)]
        public async Task<IActionResult> AdminPWSEmpPlanningDelete(string Id, string StratDate)
        {
            try
            {
                if (string.IsNullOrEmpty(Id) || string.IsNullOrEmpty(StratDate))
                {
                    throw new Exception($"Something went wrong");
                }
                DateTime startDate = DateTime.Parse(StratDate);

                var result = await _primaryWorkSpaceRepository.AdminDeletePrimaryWorkSpaceAsync(
                                            BaseSpTcmPLGet(),
                                            new ParameterSpTcmPL
                                            {
                                                PApplicationId = Id,
                                                PStartDate = startDate
                                            });

                if (result.PMessageType != IsOk)
                {
                    return StatusCode((int)HttpStatusCode.InternalServerError, result.PMessageText);
                }
                else
                {
                    return Json(new { success = true, response = result.PMessageText });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        #endregion PrimaryWorkspace Edit New

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SWPHelper.ActionPrimaryWsAdminEdit)]
        [HttpPost]
        public async Task<IActionResult> AdminPWSEmpPlanningEdit([FromForm] PrimaryWorkSpaceEditViewModel primaryWorkSpaceEditViewModel)
        {
            try
            {
                var empPWS = new PrimaryWorkspace[] {new PrimaryWorkspace
                {
                    empNo = primaryWorkSpaceEditViewModel.Empno,
                    workspace = primaryWorkSpaceEditViewModel.NewPrimaryWorkspace.ToString()
                } };
                var resultObjArray = PrimaryWorkSpaceToArray(empPWS);

                var result = await _primaryWorkSpaceRepository.HRAssignPrimaryWorkSpaceAsync(
                          BaseSpTcmPLGet(),
                          new ParameterSpTcmPL
                          {
                              PEmpWorkspaceArray = resultObjArray.ToArray()
                          });
                if (result.PMessageType == "OK")
                    return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
                else
                    return StatusCode((int)HttpStatusCode.InternalServerError, result.PMessageText);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
                //return Json(new { success = false, response = ex.Message });
            }
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SWPHelper.ActionPrimaryWsStatusAdmin)]
        public async Task<IActionResult> ExcelDownloadAdminOWSEmpAbsent()
        {
            try
            {
                string StrFimeName;
                var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
                {
                    PModuleName = CurrentUserIdentity.CurrentModule,
                    PMetaId = CurrentUserIdentity.MetaId,
                    PPersonId = CurrentUserIdentity.EmployeeId,
                    PMvcActionName = ConstFilterAdminOWSEmpAbsentIndex
                });

                FilterDataModel filterDataModel = new FilterDataModel();
                if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                    filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

                DateTime dateTime = DateTime.Now;

                if (filterDataModel.StartDate != null)
                {
                    dateTime = (DateTime)filterDataModel.StartDate;
                }

                StrFimeName = "OfficeWsEmpAbsentList_" + dateTime.ToString("dd-MMM-yyyy");

                var data = await _swpOfficeWorkspaceEmpAbsentDataTableListRepository.OWSAdminEmpAbsentList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = 0,
                        PPageLength = 100000,
                        PDate = dateTime
                    }
                );

                if (data == null) { return NotFound(); }

                var json = JsonConvert.SerializeObject(data);

                IEnumerable<OWSEmpAbsentExcelModel> excelData = JsonConvert.DeserializeObject<IEnumerable<OWSEmpAbsentExcelModel>>(json);

                var byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, "Office workspace employee - Absent list as on " + dateTime.ToString("dd-MMM-yyyy"), "AbsentList");

                return File(byteContent,
                            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                            StrFimeName + ".xlsx");
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SWPHelper.ActionPrimaryWsStatusAdmin)]
        public async Task<IActionResult> ExcelDownloadAdminSWSEmpPresent()
        {
            try
            {
                string StrFimeName;
                var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
                {
                    PModuleName = CurrentUserIdentity.CurrentModule,
                    PMetaId = CurrentUserIdentity.MetaId,
                    PPersonId = CurrentUserIdentity.EmployeeId,
                    PMvcActionName = ConstFilterAdminSWSEmpPresentIndex
                });

                FilterDataModel filterDataModel = new FilterDataModel();
                if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                    filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

                DateTime dateTime = DateTime.Now;

                if (filterDataModel.StartDate != null)
                {
                    dateTime = (DateTime)filterDataModel.StartDate;
                }

                StrFimeName = "SmartWsEmpAttendance_" + dateTime.ToString("dd-MMM-yyyy");

                var data = await _swpSmartWorkspaceEmpPresentDataTableListRepository.SWSAdminEmpPresentList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = 0,
                        PPageLength = 100000,
                        PDate = dateTime
                    }
                );

                if (data == null) { return NotFound(); }

                var json = JsonConvert.SerializeObject(data);

                IEnumerable<SWSEmpPresentExcelModel> excelData = JsonConvert.DeserializeObject<IEnumerable<SWSEmpPresentExcelModel>>(json);

                var byteContent = _utilityRepository.ExcelPivotDownloadFromIEnumerable(
                    excelData,
                    "Smart workspace employee - Present list as on " + dateTime.ToString("dd-MMM-yyyy"),
                    "PresentList", "Pivot", null, new string[] { "AttendanceStatus" }, new string[] { "Empno" }
                    );

                return File(byteContent,
                            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                            StrFimeName + ".xlsx");
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SWPHelper.ActionPrimaryWsStatusAdmin)]
        public async Task<IActionResult> ExcelDownloadOWSEmpAbsent()
        {
            try
            {
                string StrFimeName;

                var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
                {
                    PModuleName = CurrentUserIdentity.CurrentModule,
                    PMetaId = CurrentUserIdentity.MetaId,
                    PPersonId = CurrentUserIdentity.EmployeeId,
                    PMvcActionName = ConstFilterOWSEmpAbsentIndex
                });

                FilterDataModel filterDataModel = new FilterDataModel();
                if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                    filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

                DateTime dateTime = DateTime.Now;

                if (filterDataModel.StartDate != null)
                {
                    dateTime = (DateTime)filterDataModel.StartDate;
                }

                StrFimeName = "OfficeWsEmpAbsentList_" + dateTime.ToString("dd-MMM-yyyy");

                var data = await _swpOfficeWorkspaceEmpAbsentDataTableListRepository.OWSEmpAbsentList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = 0,
                        PPageLength = 100000,
                        PDate = dateTime
                    }
                );

                if (data == null) { return NotFound(); }

                var json = JsonConvert.SerializeObject(data);

                IEnumerable<OWSEmpAbsentExcelModel> excelData = JsonConvert.DeserializeObject<IEnumerable<OWSEmpAbsentExcelModel>>(json);

                var byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, "Office workspace employee - Absent list as on " + dateTime.ToString("dd-MMM-yyyy"), "AbsentList");

                return File(byteContent,
                            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                            StrFimeName + ".xlsx");
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SWPHelper.ActionPrimaryWsStatusAdmin)]
        public async Task<IActionResult> ExcelDownloadSWSEmpPresent()
        {
            try
            {
                string StrFimeName;

                var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
                {
                    PModuleName = CurrentUserIdentity.CurrentModule,
                    PMetaId = CurrentUserIdentity.MetaId,
                    PPersonId = CurrentUserIdentity.EmployeeId,
                    PMvcActionName = ConstFilterSWSEmpPresentIndex
                });

                FilterDataModel filterDataModel = new FilterDataModel();
                if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                    filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

                DateTime dateTime = DateTime.Now;

                if (filterDataModel.StartDate != null)
                {
                    dateTime = (DateTime)filterDataModel.StartDate;
                }

                StrFimeName = "SmartWsEmpPresentList_" + dateTime.ToString("dd-MMM-yyyy");

                var data = await _swpSmartWorkspaceEmpPresentDataTableListRepository.SWSEmpPresentList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = 0,
                        PPageLength = 100000,
                        PDate = dateTime
                    }
                );

                if (data == null) { return NotFound(); }

                var json = JsonConvert.SerializeObject(data);

                IEnumerable<SWSEmpPresentExcelModel> excelData = JsonConvert.DeserializeObject<IEnumerable<SWSEmpPresentExcelModel>>(json);

                var byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, "Smart workspace employee - Present list as on " + dateTime.ToString("dd-MMM-yyyy"), "PresentList");

                return File(byteContent,
                            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                            StrFimeName + ".xlsx");
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        #endregion ADMIN PWS

        #region ADMIN DWS

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SWPHelper.ActionPrimaryWsStatusAdmin)]
        public IActionResult AdminDWSIndex()
        {
            //var swpPlanningStatus = await _swpPlanningStatusRepository.GetPlanningWeekDetails(BaseSpTcmPLGet(), null);

            PrimaryWorkSpaceViewModel primaryWorkSpaceViewModel = new PrimaryWorkSpaceViewModel();

            //primaryWorkSpaceViewModel.PlanningExists = swpPlanningStatus.PPlanningExists;

            //var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            //{
            //    PModuleName = CurrentUserIdentity.CurrentModule,
            //    PMetaId = CurrentUserIdentity.MetaId,
            //    PPersonId = CurrentUserIdentity.EmployeeId,
            //    PMvcActionName = ConstFilterAdminPWSPlanning
            //});

            //FilterDataModel filterDataModel = new FilterDataModel();
            //if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            //    filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            //primaryWorkSpaceViewModel.FilterDataModel = filterDataModel;

            return View(primaryWorkSpaceViewModel);
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SWPHelper.ActionPrimaryWsStatusAdmin)]
        public async Task<JsonResult> GetListAdminEmployeeDWS(DTParameters param)
        {
            DTResult<PrimaryWorkSpaceDataTableList> result = new DTResult<PrimaryWorkSpaceDataTableList>();

            //var headerData = new { pPwsCanEdit = (CurrentUserIdentity.ProfileActions.Any(pa => pa.ActionId == SWPHelper.ActionPrimaryWsAdminEdit)) ? "OK" : "KO" };

            //DTResult<PrimaryWorkSpaceDataTableList> result = new DTResult<PrimaryWorkSpaceDataTableList>();

            int totalRow = 0;
            //if (string.IsNullOrEmpty(param.Assign))
            //{
            //    var assignList = await _selectTcmPLRepository.SWPCostCodeList4AdminAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            //    if (assignList.Any())
            //    {
            //        param.Assign = assignList.First().DataValueField;
            //    }
            //}

            try
            {
                var data = await _primaryWorkSpaceDataTableListRepository.PrimaryWorkSpacePlanning4AdminDataTableList(BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
                        PPrimaryWorkspaceCsv = "3",
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

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SWPHelper.ActionPrimaryWsStatusAdmin)]
        public async Task<IActionResult> ExcelDownloadAdminDWS()
        {
            try
            {
                string StrFimeName;

                var timeStamp = DateTime.Now.ToFileTime();
                StrFimeName = "DeputationWsEmployees_" + DateTime.Now.ToString("yyyyMMdd_HHmm");

                DataTable dt = new DataTable();
                string strUser = User.Identity.Name;

                var data = await _primaryWorkSpaceDataTableListRepository.PrimaryWorkSpacePlanning4AdminDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = 0,
                        PPageLength = 100000,
                        PEmpno = null,
                        PAssignCode = null,
                        PEmptypeCsv = null,
                        PPrimaryWorkspaceCsv = "3",
                        PGradeCsv = null,
                        PLaptopUser = null,
                        PEligibleForSwp = null,
                        PGenericSearch = null
                    });

                if (data == null) { return NotFound(); }

                var json = JsonConvert.SerializeObject(data);

                IEnumerable<AdminPWSExcelModel> excelData = JsonConvert.DeserializeObject<IEnumerable<AdminPWSExcelModel>>(json);

                var byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, "Deputation workspace employees - as on " + DateTime.Now.ToString("dd-MMM-yyyy HH:mm"), "DeputationList");

                return File(byteContent,
                            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                            StrFimeName + ".xlsx");
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        #endregion ADMIN DWS

        #region ADMIN SWS

        public async Task<IActionResult> AdminSWSPlanningFilterGet()
        {
            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterAdminSWSPlanning
            });

            var assignList = await _selectTcmPLRepository.SWPCostCodeList4AdminAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            FilterDataModel filterDataModel = new FilterDataModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            else
            {
                if (assignList.Any())
                    filterDataModel.Assign = assignList.First().DataValueField;
            }

            //var employeeTypeList = await _selectTcmPLRepository.EmployeeTypeListSWP(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            //ViewData["EmployeeTypeList"] = new SelectList(employeeTypeList, "DataValueField", "DataTextField");

            var gradeList = await _selectTcmPLRepository.GradeListSWP(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["GradeList"] = new SelectList(gradeList, "DataValueField", "DataTextField");

            ViewData["AssignList"] = new SelectList(assignList, "DataValueField", "DataTextField", filterDataModel.Assign);

            return PartialView("_ModalAdminSWSPlanningFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> AdminSWSPlanningFilterFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                {
                    if (string.IsNullOrEmpty(filterDataModel.Assign))
                    {
                        var assignList = await _selectTcmPLRepository.SWPCostCodeList4AdminAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());
                        if (assignList.Any())
                        {
                            filterDataModel.Assign = assignList.First().DataValueField;
                        }
                    }

                    string jsonFilter;
                    jsonFilter = JsonConvert.SerializeObject(
                            new
                            {
                                Empno = filterDataModel.Empno,
                                Assign = filterDataModel.Assign,
                                EmployeeTypeList = filterDataModel.EmployeeTypeList,
                                GradeList = filterDataModel.GradeList,
                                DeskAssigmentStatus = filterDataModel.DeskAssigmentStatus
                            }
                            );

                    var retVal = await _filterRepository.FilterCreateAsync(new Domain.Models.FilterCreate
                    {
                        PModuleName = CurrentUserIdentity.CurrentModule,
                        PMetaId = CurrentUserIdentity.MetaId,
                        PPersonId = CurrentUserIdentity.EmployeeId,
                        PMvcActionName = ConstFilterAdminSWSPlanning,
                        PFilterJson = jsonFilter
                    });

                    return Json(new
                    {
                        success = true,
                        startDate = filterDataModel.StartDate,
                        empno = filterDataModel.Empno,
                        assign = filterDataModel.Assign,
                        employeeTypeList = filterDataModel.EmployeeTypeList == null ? string.Empty : string.Join(",", filterDataModel.EmployeeTypeList),
                        gradeList = filterDataModel.GradeList == null ? string.Empty : string.Join(",", filterDataModel.GradeList),
                        deskAssigmentStatus = filterDataModel.DeskAssigmentStatus
                    });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SWPHelper.ActionPrimaryWsStatusAdmin)]
        public async Task<IActionResult> AdminSWSIndex()
        {
            var swpPlanningStatus = await _swpPlanningStatusRepository.GetPlanningWeekDetails(BaseSpTcmPLGet(), null);

            ViewData["WeekDetails"] = swpPlanningStatus;

            //if (swpPlanningStatus.PPlanningExists != "OK")
            //{
            //    Notify("Error", "Planning for next week not yet rolled over.", "", NotificationType.error);
            //    //return RedirectToAction("SmartAttendanceIndex", "SWP", new { Area = "SWP" });
            //}

            SWPSmartWorkSpaceViewModel sWPSmartWorkSpaceViewModel = new SWPSmartWorkSpaceViewModel();

            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterAdminSWSPlanning
            });

            FilterDataModel filterDataModel = new FilterDataModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            filterDataModel.StartDate = swpPlanningStatus.PCurrStartDate;
            sWPSmartWorkSpaceViewModel.FilterDataModel = filterDataModel;

            ViewData["SWPHeader"] = "Planning of week days";

            sWPSmartWorkSpaceViewModel.WeekDays = GetWeekDays(swpPlanningStatus.PCurrStartDate);

            return View(sWPSmartWorkSpaceViewModel);
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SWPHelper.ActionPrimaryWsStatusAdmin)]
        public async Task<JsonResult> GetListAdminSWSCurrent(DTParameters param)
        {
            var swpPlanningStatus = await _swpPlanningStatusRepository.GetPlanningWeekDetails(BaseSpTcmPLGet(), null);

            //if (swpPlanningStatus.PPlanningExists != "OK")
            //{
            //    return Json(new { error = "Planning for next week not yet rolled over." });
            //}

            //DTResult<SmartWorkSpaceDataTableList> result = new DTResult<SmartWorkSpaceDataTableList>();

            DTResultExtension<SmartWorkSpaceDataTableList, WeekPlanningStatusOutPut> result = new DTResultExtension<SmartWorkSpaceDataTableList, WeekPlanningStatusOutPut>();

            int totalRow = 0;

            //if (string.IsNullOrEmpty(param.Assign))
            //{
            //    var assignList = await _selectTcmPLRepository.SWPCostCodeList4AdminAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            //    if (assignList.Any())
            //    {
            //        param.Assign = assignList.First().DataValueField;
            //    }
            //}

            try
            {
                var data = await _smartWorkSpaceDataTableListRepository.SmartWorkSpaceAllDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = param.Start,
                        PPageLength = param.Length,

                        PDate = swpPlanningStatus.PCurrStartDate,

                        PAssignCsv = param.Assign,
                        PEmptypeCsv = param.EmployeeType,
                        PGradeCsv = param.Grade,
                        PGenericSearch = param.GenericSearch,
                        PDeskAssignmentStatus = param.DeskAssignmentStatus
                    }
                );

                if (data.Any())
                {
                    totalRow = (int)data.FirstOrDefault().TotalRow.Value;

                    if (swpPlanningStatus.PSwsOpen == "OK")
                        data.FirstOrDefault().EditAllowed = 1;
                    else
                        data.FirstOrDefault().EditAllowed = 0;
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

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SWPHelper.ActionPrimaryWsStatusAdmin)]
        public async Task<IActionResult> ExcelDownloadAdminSWSCurrent(DTParameters param)
        {
            try
            {
                var swpPlanningStatus = await _swpPlanningStatusRepository.GetPlanningWeekDetails(BaseSpTcmPLGet(), null);

                //if (swpPlanningStatus.PPlanningExists != "OK")
                //{
                //    return Json(new { error = "Planning for next week not yet rolled over." });
                //}

                string StrFimeName;
                //string strAssignCSV = assign.Length > 0 ? string.Join(',', assign) : string.Empty;

                var timeStamp = DateTime.Now.ToFileTime();
                StrFimeName = "SmartWorkspacePlanning_" + DateTime.Now.ToString("yyyyMMdd_HHmm");

                DataTable dt = new DataTable();
                string strUser = User.Identity.Name;

                var data = await _swpSmartWorkSpaceExcelDataTableListRepository.SmartWorkSpaceAllExcelDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PDate = swpPlanningStatus.PCurrStartDate
                    });

                if (data == null) { return NotFound(); }

                var byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(data, "Smart workspace planning for period " + swpPlanningStatus.PCurrStartDate.ToString("dd-MMM-yyyy") + " - " + swpPlanningStatus.PCurrEndDate.ToString("dd-MMM-yyyy"), "SmartWorkspace");

                return File(byteContent,
                            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                            StrFimeName + ".xlsx");
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SWPHelper.ActionPrimaryWsStatusAdmin)]
        public async Task<IActionResult> AdminSWSPlanning()
        {
            var swpPlanningStatus = await _swpPlanningStatusRepository.GetPlanningWeekDetails(BaseSpTcmPLGet(), null);

            ViewData["WeekDetails"] = swpPlanningStatus;

            if (swpPlanningStatus.PPlanningExists != "OK")
            {
                Notify("Error", "Planning for next week not yet rolled over.", "", NotificationType.error);
                return RedirectToAction("AdminSWSIndex", "SWP", new { Area = "SWP" });
            }

            SWPSmartWorkSpaceViewModel sWPSmartWorkSpaceViewModel = new SWPSmartWorkSpaceViewModel();

            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterAdminSWSPlanning
            });

            FilterDataModel filterDataModel = new FilterDataModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            filterDataModel.StartDate = swpPlanningStatus.PPlanStartDate;
            sWPSmartWorkSpaceViewModel.FilterDataModel = filterDataModel;

            ViewData["SWPHeader"] = "Planning of week days";

            sWPSmartWorkSpaceViewModel.WeekDays = GetWeekDays(swpPlanningStatus.PPlanStartDate);

            return View(sWPSmartWorkSpaceViewModel);
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SWPHelper.ActionPrimaryWsStatusAdmin)]
        public async Task<JsonResult> GetListAdminSWSPlanning(DTParameters param)
        {
            var swpPlanningStatus = await _swpPlanningStatusRepository.GetPlanningWeekDetails(BaseSpTcmPLGet(), null);

            if (swpPlanningStatus.PPlanningExists != "OK")
            {
                return Json(new { error = "Planning for next week not yet rolled over." });
            }

            //DTResult<SmartWorkSpaceDataTableList> result = new DTResult<SmartWorkSpaceDataTableList>();

            DTResultExtension<SmartWorkSpaceDataTableList, WeekPlanningStatusOutPut> result = new DTResultExtension<SmartWorkSpaceDataTableList, WeekPlanningStatusOutPut>();

            int totalRow = 0;

            //if (string.IsNullOrEmpty(param.Assign))
            //{
            //    var assignList = await _selectTcmPLRepository.SWPCostCodeList4AdminAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            //    if (assignList.Any())
            //    {
            //        param.Assign = assignList.First().DataValueField;
            //    }
            //}

            try
            {
                var data = await _smartWorkSpaceDataTableListRepository.SmartWorkSpaceAllDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = param.Start,
                        PPageLength = param.Length,

                        PDate = swpPlanningStatus.PPlanStartDate,

                        PAssignCsv = param.Assign,
                        PEmptypeCsv = param.EmployeeType,
                        PGradeCsv = param.Grade,
                        PGenericSearch = param.GenericSearch,
                        PDeskAssignmentStatus = param.DeskAssignmentStatus
                    }
                );

                if (data.Any())
                {
                    totalRow = (int)data.FirstOrDefault().TotalRow.Value;

                    if (swpPlanningStatus.PSwsOpen == "OK")
                        data.FirstOrDefault().EditAllowed = 1;
                    else
                        data.FirstOrDefault().EditAllowed = 0;
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

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SWPHelper.ActionPrimaryWsStatusAdmin)]
        public async Task<IActionResult> ExcelDownloadAdminSWSPlanning(DTParameters param)
        {
            try
            {
                var swpPlanningStatus = await _swpPlanningStatusRepository.GetPlanningWeekDetails(BaseSpTcmPLGet(), null);

                if (swpPlanningStatus.PPlanningExists != "OK")
                {
                    return Json(new { error = "Planning for next week not yet rolled over." });
                }

                string StrFimeName;
                //string strAssignCSV = assign.Length > 0 ? string.Join(',', assign) : string.Empty;

                var timeStamp = DateTime.Now.ToFileTime();
                StrFimeName = "SmartWorkspacePlanning_" + DateTime.Now.ToString("yyyyMMdd_HHmm");

                DataTable dt = new DataTable();
                string strUser = User.Identity.Name;

                var data = await _swpSmartWorkSpaceExcelDataTableListRepository.SmartWorkSpaceAllExcelDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PDate = swpPlanningStatus.PPlanStartDate
                    });

                if (data == null) { return NotFound(); }

                var byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(data, "Smart workspace planning for period " + swpPlanningStatus.PPlanStartDate?.ToString("dd-MMM-yyyy") + " - " + swpPlanningStatus.PPlanEndDate?.ToString("dd-MMM-yyyy"), "SmartWorkspace");

                return File(byteContent,
                            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                            StrFimeName + ".xlsx");
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        #endregion ADMIN SWS

        public IActionResult NonSWSEmpAtHome()
        {
            return View();
        }

        #region ADMIN Attendance Exception

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SWPHelper.ActionPrimaryWsStatusAdmin)]
        public async Task<IActionResult> AdminOWSEmpAbsentIndex()
        {
            OWSEmployeeAbsentViewModel owsEmployeeAbsentViewModel = new OWSEmployeeAbsentViewModel();

            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterAdminOWSEmpAbsentIndex
            });

            FilterDataModel filterDataModel = new FilterDataModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            owsEmployeeAbsentViewModel.FilterDataModel = filterDataModel;

            return View(owsEmployeeAbsentViewModel);
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SWPHelper.ActionPrimaryWsStatusAdmin)]
        public async Task<JsonResult> GetListAdminOWSEmpAbsent(DTParameters param)
        {
            DTResult<OWSEmployeeAbsentDataTableList> result = new DTResult<OWSEmployeeAbsentDataTableList>();
            int totalRow = 0;
            DateTime dateTime = DateTime.Now;
            if (param.StartDate != null)
            {
                dateTime = (DateTime)param.StartDate;
            }

            try
            {
                var data = await _swpOfficeWorkspaceEmpAbsentDataTableListRepository.OWSAdminEmpAbsentList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
                        PDate = dateTime
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

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SWPHelper.ActionPrimaryWsStatusAdmin)]
        public async Task<IActionResult> AdminSWSEmpPresentIndex()
        {
            SWSEmployeePresentViewModel swsEmployeePresentViewModel = new SWSEmployeePresentViewModel();

            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterAdminSWSEmpPresentIndex
            });

            FilterDataModel filterDataModel = new FilterDataModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            swsEmployeePresentViewModel.FilterDataModel = filterDataModel;

            return View(swsEmployeePresentViewModel);
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SWPHelper.ActionPrimaryWsStatusAdmin)]
        public async Task<JsonResult> GetListAdminSWSEmpPresent(DTParameters param)
        {
            DTResult<SWSEmployeePresentDataTableList> result = new DTResult<SWSEmployeePresentDataTableList>();
            int totalRow = 0;
            DateTime dateTime = DateTime.Now;
            if (param.StartDate != null)
            {
                dateTime = (DateTime)param.StartDate;
            }
            try
            {
                var data = await _swpSmartWorkspaceEmpPresentDataTableListRepository.SWSAdminEmpPresentList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
                        PDate = dateTime
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

        #endregion ADMIN Attendance Exception

        [ValidateAntiForgeryToken]
        public async Task<IActionResult> GetListNonSWSEmpAtHome(DTParameters param)
        {
            DTResult<NonSWSEmpAtHomeDataTableList> result = new DTResult<NonSWSEmpAtHomeDataTableList>();
            int totalRow = 0;

            try
            {
                var data = await _nonSWSEmpAtHomeDataTableListRepository.NonSWSEmpAtHome4HodSecDataTableList(BaseSpTcmPLGet(), new ParameterSpTcmPL
                {
                    PRowNumber = param.Start,
                    PPageLength = param.Length,
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

        public async Task<IActionResult> GetExcelNonSWSEmpAtHome()
        {
            int totalRow = 5000;

            try
            {
                var var = await _nonSWSEmpAtHomeDataTableListRepository.NonSWSEmpAtHome4HodSecDataTableList(BaseSpTcmPLGet(), new ParameterSpTcmPL
                {
                    PRowNumber = 0,
                    PPageLength = totalRow,
                }
                );

                if (!var.Any())
                {
                    Notify("Error", "No data exists", "toaster", notificationType: NotificationType.error);
                }
                else
                {
                    var json = JsonConvert.SerializeObject(var);

                    IEnumerable<NonSWSEmpAtHomeExcelModel> excelData = JsonConvert.DeserializeObject<IEnumerable<NonSWSEmpAtHomeExcelModel>>(json);

                    string stringFileName = "NonEligible_Emp_WFH.xlsx";

                    var byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, "NonEligible employee - working from home", "Data");

                    return File(byteContent,
                                "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                                stringFileName + ".xlsx");
                }
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message, "toaster", notificationType: NotificationType.error);
            }
            return RedirectToAction("SWPReportsIndex");
        }

        public IActionResult NonSWSEmpAtHomeAdmin()
        {
            return View();
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SWPHelper.ActionPrimaryWsStatusAdmin)]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> GetListNonSWSEmpAtHomeAdmin(DTParameters param)
        {
            DTResult<NonSWSEmpAtHomeDataTableList> result = new DTResult<NonSWSEmpAtHomeDataTableList>();
            int totalRow = 0;

            try
            {
                var data = await _nonSWSEmpAtHomeDataTableListRepository.NonSWSEmpAtHome4AdminDataTableList(BaseSpTcmPLGet(), new ParameterSpTcmPL
                {
                    PRowNumber = param.Start,
                    PPageLength = param.Length,
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

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SWPHelper.ActionPrimaryWsStatusAdmin)]
        public async Task<IActionResult> GetExcelNonSWSEmpAtHomeAdmin()
        {
            int totalRow = 5000;

            try
            {
                var var = await _nonSWSEmpAtHomeDataTableListRepository.NonSWSEmpAtHome4AdminDataTableList(BaseSpTcmPLGet(), new ParameterSpTcmPL
                {
                    PRowNumber = 0,
                    PPageLength = totalRow,
                }
                );

                if (!var.Any())
                {
                    Notify("Error", "No data exists", "toaster", notificationType: NotificationType.error);
                }
                else
                {
                    var json = JsonConvert.SerializeObject(var);

                    IEnumerable<NonSWSEmpAtHomeExcelModel> excelData = JsonConvert.DeserializeObject<IEnumerable<NonSWSEmpAtHomeExcelModel>>(json);

                    string stringFileName = "NonEligible_Emp_WFH.xlsx";

                    var byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, "NonEligible employee - working from home", "Data");

                    return File(byteContent,
                                "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                                stringFileName + ".xlsx");
                }
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message, "toaster", notificationType: NotificationType.error);
            }
            return RedirectToAction("SWPReportsIndex");
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SWPHelper.ActionPrimaryWsStatus)]
        public async Task<IActionResult> OWSEmpAbsentIndex()
        {
            OWSEmployeeAbsentViewModel owsEmployeeAbsentViewModel = new OWSEmployeeAbsentViewModel();

            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterOWSEmpAbsentIndex
            });

            FilterDataModel filterDataModel = new FilterDataModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            owsEmployeeAbsentViewModel.FilterDataModel = filterDataModel;

            return View(owsEmployeeAbsentViewModel);
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SWPHelper.ActionPrimaryWsStatus)]
        public async Task<JsonResult> GetListOWSEmpAbsent(DTParameters param)
        {
            DTResult<OWSEmployeeAbsentDataTableList> result = new DTResult<OWSEmployeeAbsentDataTableList>();
            int totalRow = 0;

            DateTime dateTime = DateTime.Now;
            if (param.StartDate != null)
            {
                dateTime = (DateTime)param.StartDate;
            }

            try
            {
                var data = await _swpOfficeWorkspaceEmpAbsentDataTableListRepository.OWSEmpAbsentList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
                        PDate = dateTime
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

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SWPHelper.ActionPrimaryWsStatus)]
        public async Task<IActionResult> SWSEmpPresentIndex()
        {
            SWSEmployeePresentViewModel swsEmployeePresentViewModel = new SWSEmployeePresentViewModel();
            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterSWSEmpPresentIndex
            });

            FilterDataModel filterDataModel = new FilterDataModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            swsEmployeePresentViewModel.FilterDataModel = filterDataModel;

            return View(swsEmployeePresentViewModel);
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SWPHelper.ActionPrimaryWsStatus)]
        public async Task<JsonResult> GetListSWSEmpPresent(DTParameters param)
        {
            DTResult<SWSEmployeePresentDataTableList> result = new DTResult<SWSEmployeePresentDataTableList>();
            int totalRow = 0;
            DateTime dateTime = DateTime.Now;
            if (param.StartDate != null)
            {
                dateTime = (DateTime)param.StartDate;
            }

            try
            {
                var data = await _swpSmartWorkspaceEmpPresentDataTableListRepository.SWSEmpPresentList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
                        PDate = dateTime
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

        #region FiltersFor4Cards

        public async Task<IActionResult> OWSEmpAbsentFilterGet()
        {
            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterOWSEmpAbsentIndex
            });

            FilterDataModel filterDataModel = new FilterDataModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            return PartialView("_ModalOWSEmpAbsentFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> OWSEmpAbsentFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                string jsonFilter;
                jsonFilter = JsonConvert.SerializeObject(
                        new
                        {
                            StartDate = filterDataModel.StartDate
                        }
                        );

                var retVal = await _filterRepository.FilterCreateAsync(new Domain.Models.FilterCreate
                {
                    PModuleName = CurrentUserIdentity.CurrentModule,
                    PMetaId = CurrentUserIdentity.MetaId,
                    PPersonId = CurrentUserIdentity.EmployeeId,
                    PMvcActionName = ConstFilterOWSEmpAbsentIndex,
                    PFilterJson = jsonFilter
                });

                return Json(new
                {
                    success = true,
                    startDate = filterDataModel.StartDate
                });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        public async Task<IActionResult> SWSEmpPresentFilterGet()
        {
            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterSWSEmpPresentIndex
            });

            FilterDataModel filterDataModel = new FilterDataModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            return PartialView("_ModalSWSEmpPresentFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> SWSEmpPresentFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                {
                    string jsonFilter;
                    jsonFilter = JsonConvert.SerializeObject(
                            new
                            {
                                StartDate = filterDataModel.StartDate
                            }
                            );

                    var retVal = await _filterRepository.FilterCreateAsync(new Domain.Models.FilterCreate
                    {
                        PModuleName = CurrentUserIdentity.CurrentModule,
                        PMetaId = CurrentUserIdentity.MetaId,
                        PPersonId = CurrentUserIdentity.EmployeeId,
                        PMvcActionName = ConstFilterSWSEmpPresentIndex,
                        PFilterJson = jsonFilter
                    });

                    return Json(new
                    {
                        success = true,
                        startDate = filterDataModel.StartDate
                    });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        public async Task<IActionResult> AdminOWSEmpAbsentFilterGet()
        {
            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterAdminOWSEmpAbsentIndex
            });

            FilterDataModel filterDataModel = new FilterDataModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            return PartialView("_ModalAdminOWSEmpAbsentFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> AdminOWSEmpAbsentFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                {
                    string jsonFilter;
                    jsonFilter = JsonConvert.SerializeObject(
                            new
                            {
                                StartDate = filterDataModel.StartDate
                            }
                            );

                    var retVal = await _filterRepository.FilterCreateAsync(new Domain.Models.FilterCreate
                    {
                        PModuleName = CurrentUserIdentity.CurrentModule,
                        PMetaId = CurrentUserIdentity.MetaId,
                        PPersonId = CurrentUserIdentity.EmployeeId,
                        PMvcActionName = ConstFilterAdminOWSEmpAbsentIndex,
                        PFilterJson = jsonFilter
                    });

                    return Json(new
                    {
                        success = true,
                        startDate = filterDataModel.StartDate
                    });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        public async Task<IActionResult> AdminSWSEmpPresentFilterGet()
        {
            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterAdminSWSEmpPresentIndex
            });

            FilterDataModel filterDataModel = new FilterDataModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            return PartialView("_ModalAdminSWSEmpPresentFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> AdminSWSEmpPresentFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                {
                    string jsonFilter;
                    jsonFilter = JsonConvert.SerializeObject(
                            new
                            {
                                StartDate = filterDataModel.StartDate
                            }
                            );

                    var retVal = await _filterRepository.FilterCreateAsync(new Domain.Models.FilterCreate
                    {
                        PModuleName = CurrentUserIdentity.CurrentModule,
                        PMetaId = CurrentUserIdentity.MetaId,
                        PPersonId = CurrentUserIdentity.EmployeeId,
                        PMvcActionName = ConstFilterAdminSWSEmpPresentIndex,
                        PFilterJson = jsonFilter
                    });

                    return Json(new
                    {
                        success = true,
                        startDate = filterDataModel.StartDate
                    });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        #endregion FiltersFor4Cards

        #region Exclude Employee

        public async Task<IActionResult> ExcludeEmployeeFilterGet()
        {
            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterExcludeEmployeeIndex
            });

            FilterDataModel filterDataModel = new FilterDataModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            return PartialView("_ModalExcludeEmployeeFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> ExcludeEmployeeFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                string jsonFilter;
                jsonFilter = JsonConvert.SerializeObject(
                        new
                        {
                            isActive = filterDataModel.IsActive
                        }
                        );

                var retVal = await _filterRepository.FilterCreateAsync(new Domain.Models.FilterCreate
                {
                    PModuleName = CurrentUserIdentity.CurrentModule,
                    PMetaId = CurrentUserIdentity.MetaId,
                    PPersonId = CurrentUserIdentity.EmployeeId,
                    PMvcActionName = ConstFilterExcludeEmployeeIndex,
                    PFilterJson = jsonFilter
                });

                return Json(new { success = true, isActive = filterDataModel.IsActive });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
            //return PartialView("_ModalExcludeEmployeeFilterSet", filterDataModel);
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SWPHelper.ActionPrimaryWsAdminEdit)]
        public async Task<IActionResult> ExcludeEmployeeIndex()
        {
            ExcludeEmployeeViewModel excludeEmployeeViewModel = new ExcludeEmployeeViewModel();
            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterExcludeEmployeeIndex
            });

            FilterDataModel filterDataModel = new FilterDataModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            excludeEmployeeViewModel.FilterDataModel = filterDataModel;

            return View(excludeEmployeeViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SWPHelper.ActionPrimaryWsStatusAdmin)]
        public async Task<JsonResult> GetListsExcludeEmployee(DTParameters param)
        {
            DTResult<ExcludeEmployeeDataTableList> result = new DTResult<ExcludeEmployeeDataTableList>();
            int totalRow = 0;

            try
            {
                var data = await _excludeEmployeeDataTableListRepository.ExcludeEmployeeDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
                        PGenericSearch = param.GenericSearch,
                        PIsActive = param.IsActive,
                        PStartDate = param.StartDate,
                        PEndDate = param.EndDate
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

        public async Task<IActionResult> ExcludeEmployeeCreate()
        {
            ExcludeEmployeeCreateViewModel excludeEmployeeCreateViewModel = new ExcludeEmployeeCreateViewModel();
            var employees = await _selectTcmPLRepository.SWPEmployeeList4AdminAsync(BaseSpTcmPLGet(), null);
            ViewData["Employee"] = new SelectList(employees, "DataValueField", "DataTextField");

            return PartialView("_ModalExcludeEmployeeCreate", excludeEmployeeCreateViewModel);
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SWPHelper.ActionPrimaryWsAdminEdit)]
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ExcludeEmployeeCreate([FromForm] ExcludeEmployeeCreateViewModel excludeEmployeeCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _excludeEmployeeRepository.CreateExcludeEmployeeAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PEmpno = excludeEmployeeCreateViewModel.Empno,
                            PStartDate = excludeEmployeeCreateViewModel.StartDate,
                            PEndDate = excludeEmployeeCreateViewModel.EndDate,
                            PReason = excludeEmployeeCreateViewModel.Reason
                        });

                    if (result.PMessageType != IsOk)
                    {
                        throw new Exception(result.PMessageText.Replace("-", " "));
                    }
                    else
                    {
                        return Json(new { success = true, response = result.PMessageText });
                    }
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            var employees = await _selectTcmPLRepository.SWPEmployeeList4AdminAsync(BaseSpTcmPLGet(), null);
            ViewData["Employee"] = new SelectList(employees, "DataValueField", "DataTextField", excludeEmployeeCreateViewModel.Empno);

            return PartialView("_ModalExcludeEmployeeCreate", excludeEmployeeCreateViewModel);
        }

        public async Task<IActionResult> ExcludeEmployeeUpdate(string id)
        {
            var result = await _excludeEmployeeDetails.ExcludeEmployeeDetailsAsync
                                 (BaseSpTcmPLGet(), new ParameterSpTcmPL { PApplicationId = id });

            ExcludeEmployeeUpdateViewModel excludeEmployeeUpdateViewModel = new ExcludeEmployeeUpdateViewModel();

            if (result.PMessageType == "OK")
            {
                excludeEmployeeUpdateViewModel.keyid = id;
                excludeEmployeeUpdateViewModel.StartDate = DateTime.Parse(result.PStartDate);
                excludeEmployeeUpdateViewModel.EndDate = DateTime.Parse(result.PEndDate);
                excludeEmployeeUpdateViewModel.Reason = result.PReason;
                excludeEmployeeUpdateViewModel.Empno = result.PEmpno;

                excludeEmployeeUpdateViewModel.IsActive = decimal.Parse(result.PIsActive);
            }

            var employees = await _selectTcmPLRepository.SWPEmployeeList4AdminAsync(BaseSpTcmPLGet(), null);
            ViewData["Employee"] = new SelectList(employees, "DataValueField", "DataTextField");

            return PartialView("_ModalExcludeEmployeeUpdate", excludeEmployeeUpdateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ExcludeEmployeeUpdate([FromForm] ExcludeEmployeeUpdateViewModel excludeEmployeeUpdateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _excludeEmployeeRepository.UpdateExcludeEmployeeAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PApplicationId = excludeEmployeeUpdateViewModel.keyid,
                            PEmpno = excludeEmployeeUpdateViewModel.Empno,
                            PStartDate = excludeEmployeeUpdateViewModel.StartDate,
                            PEndDate = excludeEmployeeUpdateViewModel.EndDate,
                            PReason = excludeEmployeeUpdateViewModel.Reason,
                            PIsActive = excludeEmployeeUpdateViewModel.IsActive
                        });

                    if (result.PMessageType != IsOk)
                    {
                        throw new Exception(result.PMessageText.Replace("-", " "));
                    }
                    else
                    {
                        return Json(new { success = true, response = result.PMessageText });
                    }
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            var employees = await _selectTcmPLRepository.SWPEmployeeList4AdminAsync(BaseSpTcmPLGet(), null);
            ViewData["Employee"] = new SelectList(employees, "DataValueField", "DataTextField", excludeEmployeeUpdateViewModel.Empno);

            return PartialView("_ModalExcludeEmployeeUpdate", excludeEmployeeUpdateViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> ExcludeEmployeeDelete(string id)
        {
            try
            {
                var result = await _excludeEmployeeRepository.DeleteExcludeEmployeeAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL { PApplicationId = id }
                    );

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        [HttpGet]
        public async Task<IActionResult> ExcludeEmployeeDetails(string id)
        {
            var result = await _excludeEmployeeDetails.ExcludeEmployeeDetailsAsync
                                (BaseSpTcmPLGet(), new ParameterSpTcmPL { PApplicationId = id });

            ExcludeEmployeeDetailsViewModel excludeEmployeeDetailsViewModel = new ExcludeEmployeeDetailsViewModel();

            if (result.PMessageType == "OK")
            {
                excludeEmployeeDetailsViewModel.keyid = id;
                excludeEmployeeDetailsViewModel.StartDate = result.PStartDate;
                excludeEmployeeDetailsViewModel.EndDate = result.PEndDate;
                excludeEmployeeDetailsViewModel.Reason = result.PReason;
                excludeEmployeeDetailsViewModel.Empno = result.PEmpno;
                excludeEmployeeDetailsViewModel.EmployeeName = result.PEmpName;

                excludeEmployeeDetailsViewModel.IsActive = decimal.Parse(result.PIsActive);
            }

            return PartialView("_ModalExcludeEmployeeDetail", excludeEmployeeDetailsViewModel);
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SWPHelper.ActionPrimaryWsAdminEdit)]
        public async Task<IActionResult> ExcelDownloadExcludeEmployee()
        {
            try
            {
                string StrFimeName;
                var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
                {
                    PModuleName = CurrentUserIdentity.CurrentModule,
                    PMetaId = CurrentUserIdentity.MetaId,
                    PPersonId = CurrentUserIdentity.EmployeeId,
                    PMvcActionName = ConstFilterExcludeEmployeeIndex
                });

                FilterDataModel filterDataModel = new FilterDataModel();
                if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                    filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

                DateTime dateTime = DateTime.Now;

                //if (filterDataModel.StartDate != null)
                //{
                //    dateTime = (DateTime)filterDataModel.StartDate;
                //}

                StrFimeName = "ExcludeEmployee_" + dateTime.ToString("dd-MMM-yyyy");

                var data = await _excludeEmployeeExcelDataTableListRepository.ExcludeEmployeeExcelDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = 0,
                        PPageLength = 100000,
                        PIsActive = filterDataModel.IsActive
                        // PDate = dateTime
                    }
                );

                if (data == null) { return NotFound(); }

                var json = JsonConvert.SerializeObject(data);

                IEnumerable<ExcludeEmployeeExcelDataTableList> excelData = JsonConvert.DeserializeObject<IEnumerable<ExcludeEmployeeExcelDataTableList>>(json);

                var byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, "Exclude Employee list as on " + dateTime.ToString("dd-MMM-yyyy"), "ExcludeEmployeeList");

                return File(byteContent,
                            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                            StrFimeName + ".xlsx");
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        #endregion Exclude Employee

        #region AttendanceStatusExcel

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SWPHelper.ActionPrimaryWsStatusAdmin)]
        public async Task<IActionResult> AttendanceStatusExcel()
        {
            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterFutureEmpComingToOfficeIndex
            });

            FilterDataModel filterDataModel = new FilterDataModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            return PartialView("_ModalAttendanceStatusExcel", filterDataModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SWPHelper.ActionPrimaryWsStatusAdmin)]
        public async Task<IActionResult> AttendanceStatusExcelWriter(DateTime startDate, DateTime endDate, int isExcludeX1Employees, string includeEmployeeLocation)
        {
            string excelFileName = "AttendanceStatusTemplate.xlsx";
            string summarySheetName = "Summary";
            string dataSheetName = "Data";
            string attendanceDataTableName = "AttendanceData";
            string summaryTitle = "Attendance status summary for the period " + startDate.ToString("dd-MMM-yyyy") + " to " + endDate.ToString("dd-MMM-yyyy") + " as on " + DateTime.Now.ToString("dd-MMM-yyyy HH:mm");
            string datatTitle = summaryTitle.Replace(" summary", "");

            //var template = new XLTemplate(StorageHelper.GetFilePath(Path.Combine(StorageHelper.SWP.TCMPLAppTemplatesRepository, StorageHelper.SWP.RepositorySWP), FileName: excelFileName, Configuration));
            var template = new XLTemplate(StorageHelper.GetTemplateFilePath(StorageHelper.SWP.RepositorySWP, FileName: excelFileName, Configuration));

            var data = await _swpAttendanceStatusDataTableListRepository.SWPAttendanceStatusDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PStartDate = startDate,
                        PEndDate = endDate,
                        PIsExcludeX1Employees = isExcludeX1Employees,
                        PIncludeEmployeeLocation = includeEmployeeLocation
                    }
                );

            var dates = await _swpAttendanceStatusDatesDataTableListRepository.SWPAttendanceDateDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PStartDate = startDate,
                        PEndDate = endDate
                    }
                );

            if (!data.Any())
            {
                Notify("Error", "No data exists", "toaster", notificationType: NotificationType.error);
            }
            string strFileName = string.Empty;
            strFileName = "AttendanceStatus_" + DateTime.Now.ToString("yyyyMMdd_HHmm") + ".xlsx";

            //DataWorksheet
            var wb = template.Workbook;

            wb.Table(attendanceDataTableName).ReplaceData(data);

            wb.Table(attendanceDataTableName).SetShowAutoFilter(false);

            wb.Worksheet(summarySheetName).Cell("A5").InsertData(dates);

            var datesCount = dates.Count() + 4;

            if (dates.Count() > 1)
            {
                var rngData = wb.Worksheet(summarySheetName).Range("B5:R5");

                string rngDates = "B6:B" + datesCount.ToString();
                wb.Worksheet(summarySheetName).Range(rngDates).Value = rngData.ToString();
            }

            wb.Worksheet(summarySheetName).Range("A5:R" + datesCount.ToString()).Style.Border.InsideBorder = ClosedXML.Excel.XLBorderStyleValues.Thin;
            wb.Worksheet(summarySheetName).Range("A5:R" + datesCount.ToString()).Style.Border.OutsideBorder = ClosedXML.Excel.XLBorderStyleValues.Thin;

            wb.Worksheet(summarySheetName).Cell("A1").Value = summaryTitle;
            wb.Worksheet(dataSheetName).Cell("A1").Value = datatTitle;

            byte[] byteContent = null;

            using (MemoryStream ms = new MemoryStream())
            {
                wb.SaveAs(ms);
                byte[] buffer = ms.GetBuffer();
                long length = ms.Length;
                byteContent = ms.ToArray();
            }

            return File(byteContent,
                    "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                    strFileName);
        }


        public async Task<IActionResult> AttendanceStatusExcel(DateTime startDate, DateTime endDate, int isExcludeX1Employees, string includeEmployeeLocation)
        {
            string excelFileName = "AttendanceStatusTemplate.xlsx";
            string summarySheetName = "Summary";
            string dataSheetName = "Data";
            string attendanceDataTableName = "AttendanceData";
            string summaryTitle = "Attendance status summary for the period " + startDate.ToString("dd-MMM-yyyy") + " to " + endDate.ToString("dd-MMM-yyyy") + " as on " + DateTime.Now.ToString("dd-MMM-yyyy HH:mm");
            string datatTitle = summaryTitle.Replace(" summary", "");


            var data = await _swpAttendanceStatusDataTableListRepository.SWPAttendanceStatusDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PStartDate = startDate,
                        PEndDate = endDate,
                        PIsExcludeX1Employees = isExcludeX1Employees,
                        PIncludeEmployeeLocation = includeEmployeeLocation
                    }
                );

            //var dates = await _swpAttendanceStatusDatesDataTableListRepository.SWPAttendanceDateDataTableListAsync(
            //        BaseSpTcmPLGet(),
            //        new ParameterSpTcmPL
            //        {
            //            PStartDate = startDate,
            //            PEndDate = endDate
            //        }
            //    );

            if (!data.Any())
            {
                Notify("Error", "No data exists", "toaster", notificationType: NotificationType.error);
            }
            string strFileName = string.Empty;
            strFileName = "AttendanceStatus_" + DateTime.Now.ToString("yyyyMMdd_HHmm") + ".xlsx";

            byte[] byteContent1 = null;



            byte[] templateBytes = System.IO.File.ReadAllBytes((StorageHelper.GetTemplateFilePath(StorageHelper.SWP.RepositorySWP, FileName: excelFileName, Configuration)));
            using (MemoryStream templateStream = new MemoryStream())
            {
                templateStream.Write(templateBytes, 0, (int)templateBytes.Length);

                using (SpreadsheetDocument spreadsheetDocument = SpreadsheetDocument.Open(templateStream, true))
                {

                    XLBookWriter.AppendDataInExcel(spreadsheetDocument, dataSheetName, attendanceDataTableName, data);

                    XLBookWriter.SetCellValue(spreadsheetDocument, dataSheetName, "A1", datatTitle);
                    XLBookWriter.SetCellValue(spreadsheetDocument, summarySheetName, "A1", summaryTitle);

                    spreadsheetDocument.Save();


                }
                long length = templateStream.Length;
                byteContent1 = templateStream.ToArray();
            }



            return File(byteContent1,
                    "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                    strFileName);


        }



        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SWPHelper.ActionPrimaryWsStatusAdmin)]
        public async Task<IActionResult> AttendanceStatusExcelOnDate(DateTime startDate, int isExcludeX1EmployeesForDay, string includeEmployeeLocation)
        {
            string excelFileName = "AttendanceStatusForDayTemplate.xlsx";
            string summarySheetName = "Summary";
            string dataSheetName = "Data";
            string attendanceDataTableName = "AttendanceData";
            string summaryTitle = "Attendance status summary for the day " + startDate.ToString("dd-MMM-yyyy") + " as on " + DateTime.Now.ToString("dd-MMM-yyyy HH:mm");
            string datatTitle = summaryTitle.Replace(" summary", "");

            //var template = new XLTemplate(StorageHelper.GetFilePath(Path.Combine(StorageHelper.SWP.TCMPLAppTemplatesRepository, StorageHelper.SWP.RepositorySWP), FileName: excelFileName, Configuration));
            var template = new XLTemplate(StorageHelper.GetTemplateFilePath(StorageHelper.SWP.RepositorySWP, FileName: excelFileName, Configuration));

            var data = await _swpAttendanceStatusForDayDataTableListRepository.SWPAttendanceStatusForDayDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PStartDate = startDate,
                        PIsExcludeX1Employees = isExcludeX1EmployeesForDay,
                        PIncludeEmployeeLocation = includeEmployeeLocation
                    }
                );

            if (!data.Any())
            {
                Notify("Error", "No data exists", "toaster", notificationType: NotificationType.error);
            }
            string strFileName = string.Empty;
            strFileName = "AttendanceStatusForDay_" + DateTime.Now.ToString("yyyyMMdd_HHmm") + ".xlsx";

            var wb = template.Workbook;

            wb.Table(attendanceDataTableName).ReplaceData(data);

            wb.Table(attendanceDataTableName).SetShowAutoFilter(false);

            wb.Worksheet(dataSheetName).Cell("A1").Value = datatTitle;
            wb.Worksheet(summarySheetName).Cell("B2").Value = summaryTitle;

            byte[] byteContent = null;

            using (MemoryStream ms = new MemoryStream())
            {
                wb.SaveAs(ms);
                byte[] buffer = ms.GetBuffer();
                long length = ms.Length;
                byteContent = ms.ToArray();
            }

            return File(byteContent,
                    "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                    strFileName);
        }

        //[HttpPost]
        //[RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SWPHelper.ActionPrimaryWsStatusAdmin)]
        //public async Task<IActionResult> AttendanceStatusExcelForMonth(DateTime startDate, int isExcludeX1EmployeesForMonth)
        //{
        //    try
        //    {
        //        string xlFormulaRange = "G5:AD";
        //        string excelFileName = "AttendanceStatusForDayTemplate.xlsx";
        //        string summarySheetName = "Summary";
        //        string dataSheetName = "Data";
        //        string attendanceDataTableName = "AttendanceData";
        //        string summaryTitle = "Attendance status summary for the month " + startDate.ToString("MMM-yyyy") + " as on " + DateTime.Now.ToString("dd-MMM-yyyy HH:mm");
        //        string dataTitle = summaryTitle.Replace(" summary", "");

        // var template = new
        // XLTemplate(StorageHelper.GetFilePath(StorageHelper.SWP.RepositoryExcelTemplate, FileName:
        // excelFileName, Configuration));

        // var data = await
        // _swpAttendanceStatusForMonthDataTableListRepository.AttendanceStatusForMonth(
        // BaseSpTcmPLGet(), new ParameterSpTcmPL { PYyyymm = startDate.ToString("yyyyMM"),
        // PIsExcludeX1Employees = isExcludeX1EmployeesForMonth } );

        //        var weekNames = await _swpAttendanceStatusWeekNamesDataTableListRepository.WeekNamesOfMonthDataTableListAsync(
        //                BaseSpTcmPLGet(),
        //                new ParameterSpTcmPL
        //                {
        //                    PYyyymm = startDate.ToString("yyyyMM"),
        //                    PIsExcludeX1Employees = isExcludeX1EmployeesForMonth
        //                }
        //            );
        //        return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage("Ok"));
        //    }
        //    catch (Exception ex)
        //    {
        //        return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
        //    }
        //}

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SWPHelper.ActionPrimaryWsStatusAdmin)]
        public async Task<IActionResult> AttendanceStatusExcelForMonth(DateTime startDate, int isExcludeX1EmployeesForMonth, string includeEmployeeLocation)
        {

            var employeesStartRow = 6;

            string xlFormulaRange = "G" + employeesStartRow + ":AD";
            string xlDataRange = "G" + employeesStartRow + ":AD";

            string excelFileName = "AttendanceStatusForMonthTemplate_3.xlsx";
            string summarySheetName = "Summary";
            string absentSummarySheetName = "AbsentSummary";

            string dataSheetName = "Data";
            string attendanceDataTableName = "AttendanceData";
            string summaryTitle = "Attendance status summary for the month " + startDate.ToString("MMM-yyyy") + " as on " + DateTime.Now.ToString("dd-MMM-yyyy HH:mm");
            string absentSummaryTitle = "Absent status summary for the month " + startDate.ToString("MMM-yyyy") + " as on " + DateTime.Now.ToString("dd-MMM-yyyy HH:mm");

            string dataTitle = summaryTitle.Replace(" summary", "");

            //var template = new XLTemplate(StorageHelper.GetFilePath(Path.Combine(StorageHelper.SWP.TCMPLAppTemplatesRepository, StorageHelper.SWP.RepositorySWP), FileName: excelFileName, Configuration));
            var template = new XLTemplate(StorageHelper.GetTemplateFilePath(StorageHelper.SWP.RepositorySWP, FileName: excelFileName, Configuration));

            var data = await _swpAttendanceStatusForMonthDataTableListRepository.AttendanceStatusForMonth(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PYyyymm = startDate.ToString("yyyyMM"),
                        PIsExcludeX1Employees = isExcludeX1EmployeesForMonth,
                        PIncludeEmployeeLocation = includeEmployeeLocation
                    }
                );

            var weekNames = await _swpAttendanceStatusWeekNamesDataTableListRepository.WeekNamesOfMonthDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PYyyymm = startDate.ToString("yyyyMM")
                    }
                );

            var firstDayOfMonth = new DateTime(startDate.Year, startDate.Month, 1);
            var lastDayOfMonth = firstDayOfMonth.AddMonths(1);
            lastDayOfMonth = new DateTime(lastDayOfMonth.Year, lastDayOfMonth.Month, 1);
            lastDayOfMonth = lastDayOfMonth.AddDays(-1);

            var swpEmployees = await _swpEmployeesDataTableListRepository.Employees(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PIsExcludeX1Employees = isExcludeX1EmployeesForMonth,
                        PIncludeEmployeeLocation = includeEmployeeLocation,
                        PStartDate = firstDayOfMonth,
                        PEndDate = lastDayOfMonth
                    }
                );

            if (!data.Any() || !weekNames.Any() || !swpEmployees.Any())
            {
                Notify("Error", "No data exists", "toaster", notificationType: NotificationType.error);
            }

            string strFileName = "AttendanceStatusForMonth_" + startDate.ToString("yyyyMM") + ".xlsx";

            var wb = template.Workbook;

            wb.Table(attendanceDataTableName).SetShowAutoFilter(false);

            wb.Table(attendanceDataTableName).ReplaceData(data);

            wb.Worksheet(dataSheetName).Cell("A1").Value = dataTitle;

            //S u m m a r y  Sheet
            wb.Worksheet(summarySheetName).Cell("A1").Value = summaryTitle;

            wb.Worksheet(summarySheetName).Cell("A" + employeesStartRow).InsertData(swpEmployees);

            wb.Worksheet(summarySheetName).Cell("G3").Value = weekNames.ToList()[0].WeekName;
            wb.Worksheet(summarySheetName).Cell("H3").Value = weekNames.ToList()[0].StartDate.ToString("dd-MMM") + " - " + weekNames.ToList()[0].EndDate.ToString("dd-MMM");


            wb.Worksheet(summarySheetName).Cell("M3").Value = weekNames.ToList()[1].WeekName;
            wb.Worksheet(summarySheetName).Cell("N3").Value = weekNames.ToList()[1].StartDate.ToString("dd-MMM") + " - " + weekNames.ToList()[1].EndDate.ToString("dd-MMM");


            wb.Worksheet(summarySheetName).Cell("S3").Value = weekNames.ToList()[2].WeekName;
            wb.Worksheet(summarySheetName).Cell("T3").Value = weekNames.ToList()[2].StartDate.ToString("dd-MMM") + " - " + weekNames.ToList()[2].EndDate.ToString("dd-MMM");


            wb.Worksheet(summarySheetName).Cell("Y3").Value = weekNames.ToList()[3].WeekName;
            wb.Worksheet(summarySheetName).Cell("Z3").Value = weekNames.ToList()[3].StartDate.ToString("dd-MMM") + " - " + weekNames.ToList()[3].EndDate.ToString("dd-MMM");

            if (weekNames.Count() == 5)
            {
                xlFormulaRange = "G" + employeesStartRow + ":AS";
                xlDataRange = "A" + employeesStartRow + ":AS";
                wb.Worksheet(summarySheetName).Cell("AE3").Value = weekNames.ToList()[4].WeekName;
                wb.Worksheet(summarySheetName).Cell("AF3").Value = weekNames.ToList()[4].StartDate.ToString("dd-MMM") + " - " + weekNames.ToList()[4].EndDate.ToString("dd-MMM");
            }

            if (swpEmployees.Count() > 1)
            {
                var formulaRangeData = wb.Worksheet(summarySheetName).Range(xlFormulaRange + employeesStartRow);

                string employeesRange = "G" + (employeesStartRow + 1) + ":G" + (swpEmployees.Count() + employeesStartRow - 1).ToString();
                wb.Worksheet(summarySheetName).Range(employeesRange).Value = formulaRangeData.ToString();
            }
            xlDataRange = xlDataRange + (swpEmployees.Count() + employeesStartRow - 1);
            wb.Worksheet(summarySheetName).Range(xlDataRange).Style.Border.InsideBorder = ClosedXML.Excel.XLBorderStyleValues.Thin;
            wb.Worksheet(summarySheetName).Range(xlDataRange).Style.Border.OutsideBorder = ClosedXML.Excel.XLBorderStyleValues.Thin;


            //A B S E N T  Summary Sheet
            wb.Worksheet(absentSummarySheetName).Cell("A1").Value = absentSummaryTitle;

            wb.Worksheet(absentSummarySheetName).Cell("A" + employeesStartRow).InsertData(swpEmployees);

            wb.Worksheet(absentSummarySheetName).Cell("G3").Value = weekNames.ToList()[0].WeekName;
            wb.Worksheet(absentSummarySheetName).Cell("H3").Value = weekNames.ToList()[0].StartDate.ToString("dd-MMM") + " - " + weekNames.ToList()[0].EndDate.ToString("dd-MMM");


            wb.Worksheet(absentSummarySheetName).Cell("I3").Value = weekNames.ToList()[1].WeekName;
            wb.Worksheet(absentSummarySheetName).Cell("J3").Value = weekNames.ToList()[1].StartDate.ToString("dd-MMM") + " - " + weekNames.ToList()[1].EndDate.ToString("dd-MMM");


            wb.Worksheet(absentSummarySheetName).Cell("K3").Value = weekNames.ToList()[2].WeekName;
            wb.Worksheet(absentSummarySheetName).Cell("L3").Value = weekNames.ToList()[2].StartDate.ToString("dd-MMM") + " - " + weekNames.ToList()[2].EndDate.ToString("dd-MMM");


            wb.Worksheet(absentSummarySheetName).Cell("M3").Value = weekNames.ToList()[3].WeekName;
            wb.Worksheet(absentSummarySheetName).Cell("N3").Value = weekNames.ToList()[3].StartDate.ToString("dd-MMM") + " - " + weekNames.ToList()[3].EndDate.ToString("dd-MMM");

            xlFormulaRange = "G" + employeesStartRow + ":Q";
            xlDataRange = "A" + employeesStartRow + ":Q";
            if (weekNames.Count() == 5)
            {
                xlFormulaRange = "G" + employeesStartRow + ":S";
                xlDataRange = "A" + employeesStartRow + ":S";
                wb.Worksheet(absentSummarySheetName).Cell("O3").Value = weekNames.ToList()[4].WeekName;
                wb.Worksheet(absentSummarySheetName).Cell("P3").Value = weekNames.ToList()[4].StartDate.ToString("dd-MMM") + " - " + weekNames.ToList()[4].EndDate.ToString("dd-MMM");
            }

            if (swpEmployees.Count() > 1)
            {
                var formulaRangeData = wb.Worksheet(absentSummarySheetName).Range(xlFormulaRange + employeesStartRow);

                string employeesRange = "G" + (employeesStartRow + 1) + ":G" + (swpEmployees.Count() + employeesStartRow - 1).ToString();
                wb.Worksheet(absentSummarySheetName).Range(employeesRange).Value = formulaRangeData.ToString();
            }
            xlDataRange = xlDataRange + (swpEmployees.Count() + employeesStartRow - 1);
            wb.Worksheet(absentSummarySheetName).Range(xlDataRange).Style.Border.InsideBorder = ClosedXML.Excel.XLBorderStyleValues.Thin;
            wb.Worksheet(absentSummarySheetName).Range(xlDataRange).Style.Border.OutsideBorder = ClosedXML.Excel.XLBorderStyleValues.Thin;




            byte[] byteContent = null;

            using (MemoryStream ms = new MemoryStream())
            {
                wb.SaveAs(ms);
                byte[] buffer = ms.GetBuffer();
                long length = ms.Length;
                byteContent = ms.ToArray();
            }

            return File(byteContent,
                    "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                    strFileName);
        }


        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SWPHelper.ActionPrimaryWsStatusAdmin)]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> AttendanceStatusExcelSubContract()
        {
            string excelFileName = "AttendanceStatusSubContractTemplate.xlsx";

            string dataSheetName = "Data";
            string attendanceDataTableName = "AttendanceData";
            string dataTitle = "Attendance status of SubContract employees as on " + DateTime.Now.ToString("dd-MMM-yyyy HH:mm") + " for past 10 days.";


            //var template = new XLTemplate(StorageHelper.GetFilePath(Path.Combine(StorageHelper.SWP.TCMPLAppTemplatesRepository, StorageHelper.SWP.RepositorySWP), FileName: excelFileName, Configuration));
            var template = new XLTemplate(StorageHelper.GetTemplateFilePath(StorageHelper.SWP.RepositorySWP, FileName: excelFileName, Configuration));

            var data = await _swpAttendanceStatusSubContractDataTableListRepository.SWPAttendanceSubContractDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                    }
                );


            if (!data.Any())
            {
                return Json(ResponseHelper.GetMessageObject("No data exists.", NotificationType.error));
            }

            string strFileName = "AttendanceStatusSubContractEmp_" + DateTime.Now.ToString("yyyyMMdd_HHmm") + ".xlsx";

            var wb = template.Workbook;

            wb.Table(attendanceDataTableName).SetShowAutoFilter(false);

            wb.Table(attendanceDataTableName).ReplaceData(data);

            wb.Worksheet(dataSheetName).Cell("A2").Value = dataTitle;



            byte[] byteContent = null;

            using (MemoryStream ms = new MemoryStream())
            {
                wb.SaveAs(ms);
                byte[] buffer = ms.GetBuffer();
                long length = ms.Length;
                byteContent = ms.ToArray();
            }
            var mimeType = MimeTypeMap.GetMimeType("xlsx");

            FileContentResult file = File(byteContent, mimeType, strFileName);

            return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
        }



        #endregion AttendanceStatusExcel

        #region Future employee coming to office

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SWPHelper.ActionPrimaryWsStatusAdmin)]
        public async Task<IActionResult> FutureEmpComingToOfficeIndex()
        {
            FutureEmpComingToOfficeViewModel futureEmpComingToOfficeViewModel = new FutureEmpComingToOfficeViewModel();
            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterFutureEmpComingToOfficeIndex
            });

            FilterDataModel filterDataModel = new FilterDataModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            futureEmpComingToOfficeViewModel.FilterDataModel = filterDataModel;

            return View(futureEmpComingToOfficeViewModel);
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SWPHelper.ActionPrimaryWsStatusAdmin)]
        public async Task<JsonResult> GetListFutureEmpComingToOffice(DTParameters param)
        {
            DTResult<FutureEmpComingToOfficeDataTableList> result = new DTResult<FutureEmpComingToOfficeDataTableList>();
            int totalRow = 0;

            try
            {
                var data = await _futureEmpComingToOfficeDataTableListRepository.FutureEmpComingToOfficeDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
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

        public async Task<IActionResult> ExcelDownloadFutureEmpComingToOffice()
        {
            int totalRow = 5000;

            try
            {
                var var = await _futureEmpComingToOfficeDataTableListRepository.FutureEmpComingToOfficeDataTableList
                    (BaseSpTcmPLGet(), new ParameterSpTcmPL
                    {
                        PRowNumber = 0,
                        PPageLength = totalRow,
                    }
                );

                if (!var.Any())
                {
                    Notify("Error", "No data exists", "toaster", notificationType: NotificationType.error);
                }
                else
                {
                    var json = JsonConvert.SerializeObject(var);

                    IEnumerable<FutureEmpComingToOfficeExcelModel> excelData = JsonConvert.DeserializeObject<IEnumerable<FutureEmpComingToOfficeExcelModel>>(json);

                    string stringFileName = "FutureEmpComingToOffice.xlsx";

                    var byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, "Future employee coming to office", "Data");

                    return File(byteContent,
                                "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                                stringFileName + ".xlsx");
                }
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message, "toaster", notificationType: NotificationType.error);
            }
            return RedirectToAction("FutureEmpComingToOfficeIndex");
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SWPHelper.ActionPrimaryWsStatusAdmin)]
        public IActionResult FutureEmpComingToOfficeImport()
        {
            return PartialView("_ModalFutureEmpComingToOfficeImportPartial");
        }

        public async Task<IActionResult> FutureEmpComingToOfficeXLTemplate()
        {
            int totalRow = 5000;

            try
            {
                var var = await _futureEmpComingToOfficeDataTableListRepository.FutureEmpComingToOfficeDataTableList
                    (BaseSpTcmPLGet(), new ParameterSpTcmPL
                    {
                        PRowNumber = 0,
                        PPageLength = totalRow,
                        PActivefuture = 1
                    }
                );

                //if (!var.Any())
                //{
                //    var resultJsonError = new
                //    {
                //        success = false,
                //        response = "No data ",
                //    };

                //    return Json(resultJsonError);
                //}

                var dictionaryItems = new List<Library.Excel.Template.Models.DictionaryItem>();

                Stream ms = _excelTemplate.ExportEmpComingToOffice("v01",
                        new Library.Excel.Template.Models.DictionaryCollection
                        {
                            DictionaryItems = dictionaryItems
                        },
                    500);

                var fileName = "ImportEmpComingToOffice.xlsx";
                var mimeType = MimeTypeMap.GetMimeType("xlsx");

                ms.Position = 0;
                DataTable dt = new DataTable();

                var json = JsonConvert.SerializeObject(var);

                IEnumerable<FutureEmpComingToOfficeExcelImportModel> excelData = JsonConvert.DeserializeObject<IEnumerable<FutureEmpComingToOfficeExcelImportModel>>(json);

                using (XLWorkbook wb = new XLWorkbook(ms))
                {
                    if (var.Any())
                    {
                        wb.Worksheet(1).Cell(2, 1).InsertData(excelData.ToList());
                    }
                    using (MemoryStream stream = new MemoryStream())
                    {
                        wb.SaveAs(stream);
                        wb.Protect("qw8po2TY5vbJ0Gd1sa");
                        wb.Worksheet(1).Column(4).Style.Protection.SetLocked(false);
                        stream.Position = 0;
                        return File(stream.ToArray(),
                                   "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                                   fileName);
                    }
                }
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message, "toaster", notificationType: NotificationType.error);
            }
            return RedirectToAction("FutureEmpComingToOfficeIndex");
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> FutureEmpComingToOfficeXLTemplateUpload(IFormFile file)
        {
            try
            {
                if (file == null || file.Length == 0)
                    return Json(new { success = false, response = "File not uploaded due to an error" });

                FileInfo fileInfo = new FileInfo(file.FileName);

                Guid storageId = Guid.NewGuid();
                var stream = file.OpenReadStream();
                var fileName = file.FileName;
                var fileSize = file.Length;
                var mimeType = MimeTypeMap.GetMimeType(fileInfo.Extension);

                // Check file validation
                if (!fileInfo.Extension.Contains("xls"))
                    return Json(new { success = false, response = "Excel file not recognized" });

                // Try to convert stream to a class

                string json = string.Empty;

                // Call database json stored procedure

                List<EmpComingToOffice> futureEmpComingToOffice = _excelTemplate.ImportEmpComingToOffice(stream);

                string[] ary = futureEmpComingToOffice.Select(p =>
                                                            (string.IsNullOrEmpty(p.Empno) ? " " : p.Empno) + "~!~" +
                                                            (string.IsNullOrEmpty(p.DeskId) ? " " : p.DeskId) + "~!~" +
                                                            p.FuturePwsDate.Substring(0, 11)).ToArray();

                var uploadOutPut = await _futureEmpComingToOfficeRepository.FutureEmpComingToOfficeBulkCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PEmpWorkspaceArray = ary
                        }
                    );

                List<ImportFileResultViewModel> importFileResults = new List<ImportFileResultViewModel>();

                if (uploadOutPut.PErrors?.Length > 0)
                {
                    foreach (string err in uploadOutPut.PErrors)
                    {
                        string[] aryErr = err.Split("~!~");
                        importFileResults.Add(new ImportFileResultViewModel
                        {
                            ErrorType = (ImportFileValidationErrorTypeEnum)Enum.Parse(typeof(ImportFileValidationErrorTypeEnum), aryErr[5], true),
                            ExcelRowNumber = int.Parse(aryErr[2]),
                            FieldName = aryErr[3],
                            Id = int.Parse(aryErr[0]),
                            Section = aryErr[1],
                            Message = aryErr[6],
                        });
                    }
                }

                List<Library.Excel.Template.Models.ValidationItem> validationItems = new List<Library.Excel.Template.Models.ValidationItem>();

                if (importFileResults.Count > 0)
                {
                    foreach (var item in importFileResults)
                    {
                        validationItems.Add(new ValidationItem
                        {
                            ErrorType = (Library.Excel.Template.Models.ValidationItemErrorTypeEnum)Enum.Parse(typeof(Library.Excel.Template.Models.ValidationItemErrorTypeEnum), item.ErrorType.ToString(), true),
                            ExcelRowNumber = item.ExcelRowNumber.Value,
                            FieldName = item.FieldName,
                            Id = item.Id,
                            Section = item.Section,
                            Message = item.Message
                        });
                    }
                }

                if (uploadOutPut.PMessageType != "OK")
                {
                    if (importFileResults.Count > 0)
                    {
                        var streamError = _excelTemplate.ValidateImport(stream, validationItems);
                        FileContentResult fileContentResult = File(streamError.ToArray(), mimeType, fileName);

                        var resultJsonError = new
                        {
                            success = false,
                            response =
                        uploadOutPut.PMessageText,
                            data = importFileResults,
                            fileContent =
                        fileContentResult
                        };

                        return Json(resultJsonError);
                    }
                    else
                    {
                        var resultJsonError = new
                        {
                            success =
                        false,
                            response = uploadOutPut.PMessageText,
                            data = importFileResults
                        };

                        return Json(resultJsonError);
                    }
                }
                else
                {
                    var resultJson = new
                    {
                        success = true,
                        response = "Import data successfully executed"
                    };

                    return Json(resultJson);
                }
            }
            catch (Exception ex)
            {
                var resultJson = new
                {
                    success = false,
                    response = ex.Message
                };

                return Json(resultJson);
            }
        }

        public async Task<IActionResult> FutureEmpComingToOfficeDelete(string Empno)
        {
            try
            {
                if (string.IsNullOrEmpty(Empno))
                {
                    throw new Exception($"Something went wrong");
                }

                var result = await _futureEmpComingToOfficeDeleteRepository.FutureEmpComingToOfficeDeleteAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PEmpno = Empno
                        }
                    );

                if (result.PMessageType != IsOk)
                {
                    return StatusCode((int)HttpStatusCode.InternalServerError, result.PMessageText);
                }
                else
                {
                    return Json(new { success = true, response = result.PMessageText });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        #endregion Future employee coming to office

        #region Common Model for get Primary workspace employee planned history list

        public async Task<JsonResult> GetListPWSEmpPlanningPreviousList(DTParameters param)
        {
            DTResult<PrimaryWorkSpaceForAdminDataTableList> result = new DTResult<PrimaryWorkSpaceForAdminDataTableList>();
            int totalRow = 0;

            try
            {
                var data = await _swpPPrimaryWorkSpaceAdminDataTableListRepository.PrimaryWorkSpaceDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
                        PEmpno = param.Empno
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
                return Json(new { error = ex.Message });
            }
        }

        public async Task<IActionResult> PWSEmpPlanningPreviousList(string Empno)
        {
            try
            {
                var empdetails = await _attendanceEmployeeDetailsRepository.AttendanceEmployeeDetailsAsync(BaseSpTcmPLGet(),
                               new ParameterSpTcmPL
                               {
                                   PEmpno = Empno.Trim()
                               }
                           );

                PrimaryWorkSpaceAdminEditViewModel primaryWorkSpaceAdminEditViewModel = new PrimaryWorkSpaceAdminEditViewModel();

                primaryWorkSpaceAdminEditViewModel.Empno = empdetails.Empno;
                primaryWorkSpaceAdminEditViewModel.EmployeeName = empdetails.Name;
                primaryWorkSpaceAdminEditViewModel.EmpGrade = empdetails.EmpGrade;
                primaryWorkSpaceAdminEditViewModel.Assign = empdetails.AssignCode;
                primaryWorkSpaceAdminEditViewModel.Emptype = empdetails.Emptype;
                primaryWorkSpaceAdminEditViewModel.Email = empdetails.EmpEmail;
                primaryWorkSpaceAdminEditViewModel.Parent = empdetails.ParentCode;

                return PartialView("_ModalPWSEmpPlanningPreviousList", primaryWorkSpaceAdminEditViewModel);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        #endregion Common Model for get Primary workspace employee planned history list
    }
}