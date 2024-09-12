using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.Extensions.Configuration;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using OfficeOpenXml.Table.PivotTable;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.Common;
using TCMPLApp.DataAccess.Repositories.ProcessQueue;
using TCMPLApp.DataAccess.Repositories.ProcessQueue.View.Interface;
using TCMPLApp.DataAccess.Repositories.RapReporting;
using TCMPLApp.Domain.Models.RapReporting;
using TCMPLApp.WebApp.Classes;
using TCMPLApp.WebApp.Controllers;
using TCMPLApp.WebApp.CustomPolicyProvider;
using TCMPLApp.WebApp.Models;
using TCMPLApp.WebApp.Services;
using static TCMPLApp.WebApp.Classes.DTModel;

namespace TCMPLApp.WebApp.Areas.RapReporting.Controllers
{
    [Authorize]
    [Area("RapReporting")]
    public class ReportsController : BaseController
    {
        private const string ConstFilterRapIndex = "RapCommonIndex";
        private const string ModuleId = "M07";
        //private readonly string Success = "OK";
        private readonly string costcodeGroupId = "CG001";
        private readonly string costcodeGroupName = "All 02 - All costcodes starting with 02";

        private readonly IFilterRepository _filterRepository;
        private readonly ISelectTcmPLRepository _selectTcmPLRepository;
        private readonly IConfiguration _configuration;
        private readonly IRapReportingReportsRepository _rapReportingReportsRepository;
        private readonly IWebHostEnvironment _env;
        private readonly IProcessQueueDataTableListRepository _processQueueDataTableListRepository;
        private readonly IProcessQueueRepository _processQueueRepository;
        private readonly IProcessLogDataTableListRepository _processLogDataTableListRepository;

        //private readonly string _contentTypeClosedXML = "application/vnd.closedxmlformats-officedocument.spreadsheetml.sheet";
        //private readonly string _contentTypeZip = "application/zip";
        private string _contentTypeApplicationJSON = "application/json";

        #region Simple - Uri

        private static readonly string _uriAuditor = "api/rap/rpt/AuditorRptDownload";

        //private static readonly string _uriMJM = "api/rap/rpt/MJMRptDownload";
        private static readonly string _uriMJM_All = "api/rap/rpt/MJM_All_RptDownload";

        private static readonly string _uriMJM_Proj_All = "api/rap/rpt/MJM_Proj_All_RptDownload";

        private static readonly string _uriMJAM = "api/rap/rpt/MJAMRptDownload";
        private static readonly string _uriDUPLSTA6 = "api/rap/rpt/DUPLSTA6RptDownload";
        private static readonly string _uriCCPOSTDET = "api/rap/rpt/CCPOSTDETRptDownload";
        private static readonly string _uriMJEAM = "api/rap/rpt/MJEAMRptDownload";
        private static readonly string _uriMHrsExceed = "api/rap/rpt/MHrsExceedRptDownload";
        private static readonly string _uriLeave = "api/rap/rpt/LeaveRptDownload";
        private static readonly string _uriLeaveHR = "api/rap/rpt/LeaveHRRptDownload";
        private static readonly string _uriOddTimesheet = "api/rap/rpt/OddTimesheetRptDownload";
        private static readonly string _uriNotPostedTimesheet = "api/rap/rpt/NotPostedTimesheetRptDownload";
        private static readonly string _uriAfterPostAFCAuditor = "api/rap/rpt/Auditor_Download";
        private static readonly string _uriFinance_TS = "api/rap/rpt/Finance_TS_Download";
        private static readonly string _uriJOB_PROJ_PH_LIST = "api/rap/rpt/JOB_PROJ_PH_LIST_Download";
        private static readonly string _uriAuditor_Subcontractor_wise = "api/rap/rpt/Auditor_Subcontractor_wise_Download";
        private static readonly string _uriProjectwiseManhours = "api/rap/rpt/Project_Manhours_Download";
        private static readonly string _uriCostCentre_PlanRep1 = "api/rap/rpt/CostCentre_PlanRep1_Download";
        private static readonly string _uriCost_PlanRep2 = "api/rap/rpt/CostCentre_PlanRep2_Download"; // CostCentre_PlanRep2_Download
        private static readonly string _uriCostCentre_Combine = "api/rap/rpt/CostCentre_Combine_Download";
        private static readonly string _uriCostCentre_CostOT_Combine = "api/rap/rpt/CostCentre_CostOT_Combine_Download";
        private static readonly string _uriCostCentre_hrs_OtBreak = "api/rap/rpt/CostCentre_hrs_OtBreak_Download";
        private static readonly string _uriCostCentre_hrs_OtCrossTab = "api/rap/rpt/CostCentre_hrs_OtCrossTab_Download";
        private static readonly string _uriEmployee_2011onwards = "api/rap/rpt/Employee_2011onwards_Download";
        private static readonly string _uriSUBCONTRACTOR_TS = "api/rap/rpt/SUBCONTRACTOR_TS_Download";
        private static readonly string _uriPENDING_TS = "api/rap/rpt/TSPENDING";
        private static readonly string _uriRunExeFile = "api/rap/rpt/RunExeFile";
        private static readonly string _uriProj_Grade = "api/rap/rpt/Proj_Grade_Download";
        private static readonly string _uriProj_PlanRep1 = "api/rap/rpt/Proj_PlanRep1_Download";
        private static readonly string _uriProj_PlanRep2 = "api/rap/rpt/Proj_PlanRep2_Download";
        private static readonly string _uriManhourExportToSAP = "api/rap/rpt/Manhour_Export_To_SAP_Download";

        //private static readonly string _uriPRJ_ACC_ACT_BUDG = "api/rap/rpt/PRJ_ACC_ACT_BUDG_Download"; // Removed as per Anita ma'am guide
        private static readonly string _uriPRJ_CC_ACT_BUDG = "api/rap/rpt/PRJ_CC_ACT_BUDG_Download";

        //private static readonly string _uriProjCost_combine = "api/rap/rpt/ProjCost_combine_Download";  // Removed as per Anita ma'am guide
        private static readonly string _uriProjCostOT_combine = "api/rap/rpt/ProjCostOT_combine_Download";

        private static readonly string _uriProjhrs_OtBreak = "api/rap/rpt/Projhrs_OtBreak_Download";
        private static readonly string _uriProjhrs_OtCrossTab = "api/rap/rpt/Projhrs_OtCrossTab_Download";
        private static readonly string _uriWorkPosition_Combine = "api/rap/rpt/WorkPosition_Combine_Download";

        //private static readonly string _uriBeforePostProj_YY_PRJ_CC = "api/rap/rpt/BeforePostProj_YY_PRJ_CC_Download";
        private static readonly string _uriBeforePostProj_YY_PRJ_CC_ACT = "api/rap/rpt/BeforePostProj_YY_PRJ_CC_ACT_Download";

        private static readonly string _uriBeforePostProj_YY_PRJ_CC_EMP = "api/rap/rpt/BeforePostProj_YY_PRJ_CC_EMP_Download";
        private static readonly string _uriLISTACT = "api/rap/rpt/Master/LISTACT";
        private static readonly string _uriLISTEMP = "api/rap/rpt/Master/LISTEMP";
        private static readonly string _uriLISTEMP_Parent = "api/rap/rpt/Master/LISTEMP_Parent";
        private static readonly string _uriPROJACT = "api/rap/rpt/Master/PROJACT";
        private static readonly string _uriListActProj = "api/rap/rpt/Master/ListActProj";
        private static readonly string _uriTLP_Codes_Master = "api/rap/rpt/Master/TLP_Codes_Master";
        private static readonly string _uriCcpost = "api/rap/rpt/ccpost";
        private static readonly string _uriCheckposted = "api/rap/rpt/checkposted";
        private static readonly string _uriExptjobs = "api/rap/rpt/exptjobs";
        private static readonly string _uriKallodaily = "api/rap/rpt/kallodaily";
        private static readonly string _uriProjections = "api/rap/rpt/projections";
        private static readonly string _uriPlanRep4 = "api/rap/rpt/PlanRep4";
        private static readonly string _uriPlanRep5 = "api/rap/rpt/PlanRep5";
        private static readonly string _uriPROCO_TS_ACT = "api/rap/rpt/PROCO_TS_ACT";
        private static readonly string _uriDATEWISE_TS = "api/rap/rpt/DATEWISE_TS";
        private static readonly string _uriTS_ACT_COVID = "api/rap/rpt/TS_ACT_COVID";
        private static readonly string _uriEmpl_mhrs_not_posted = "api/rap/rpt/empl_mhrs_not_posted";
        private static readonly string _uriCostCenterManhours = "api/rap/rpt/CostCenterManhours";
        private static readonly string _uriProjectManhours = "api/rap/rpt/ProjectManhours";
        private static readonly string _uriProcessData = "api/rap/rpt/ProcessData";
        private static readonly string _uriGetProcessStatus = "api/rap/rpt/GetProcessStatus";
        private static readonly string _uriCovidManhrsDistribution = "api/rap/rpt/CovidManhrsDistribution";

        #endregion Simple - Uri

        #region Complex - CC - Uri

        private static readonly string _uriCHA01EData = "api/rap/rpt/cmplx/cc/GetCHA01EData";
        private static readonly string _uriCHA01ESimData = "api/rap/rpt/cmplx/cc/GetCHA01ESimData";
        private static readonly string _uriCha1Costcodes = "api/rap/rpt/cmplx/cc/getCha1Costcodes";
        private static readonly string _uriUpdateCha1Process = "api/rap/rpt/cmplx/cc/updateCha1Process";
        private static readonly string _uriCha1Sta6Tm02 = "api/rap/rpt/cmplx/cc/GetCha1Sta6Tm02";
        private static readonly string _uriRptCostcodes = "api/rap/rpt/cmplx/cc/getRptCostcodes";
        private static readonly string _uriUpdateRptProcess = "api/rap/rpt/cmplx/cc/updateRptProcess";
        private static readonly string _uriRptMailDetails = "api/rap/rpt/cmplx/cc/getRptMailDetails";
        private static readonly string _uriRptProcesslist = "api/rap/rpt/cmplx/cc/getRptProcesslist";
        private static readonly string _uriDuplTm02 = "api/rap/rpt/cmplx/cc/GetDuplTm02";
        private static readonly string _uriReportProcessStatus = "api/rap/rpt/cmplx/cc/reportProcessStatus";
        //private static readonly string _uriReportProcessKeyid = "api/rap/rpt/cmplx/cc/reportProcessKeyid";
        private static readonly string _uriDownloadFile = "api/rap/rpt/cmplx/cc/downloadZip";
        private static readonly string _uriDiscardFile = "api/rap/rpt/cmplx/cc/discardZip";

        #endregion Complex - CC - Uri

        #region CMPLX - MGMT - Uri

        private static readonly string _uriBreakupData = "api/rap/rpt/cmplx/mgmt/GetBreakupData";

        //private static readonly string _uriCHA1Engg = "api/rap/rpt/cmplx/mgmt/GetCHA1Engg";

        private static readonly string _uriCHA1NonEngg = "api/rap/rpt/cmplx/mgmt/GetCHA1NonEngg";
        private static readonly string _uriCHA1Mgmt = "api/rap/rpt/cmplx/mgmt/GetCHA1Mgmt";
        //private static readonly string _uriTMA = "api/rap/rpt/cmplx/mgmt/GetTMA";
        private static readonly string _uriPlantEngg = "api/rap/rpt/cmplx/mgmt/GetPlantEnggData";

        #endregion CMPLX - MGMT - Uri

        #region CMPLX - PROCO - Uri

        private static readonly string _uriPRJCCPORTHRSData = "api/rap/rpt/cmplx/proco/GetPRJCCPORTHRSData";
        private static readonly string _uriResourceAvlSch = "api/rap/rpt/cmplx/proco/GetResourceAvlSch";
        //private static readonly string _uriTM01All = "api/rap/rpt/cmplx/proco/GetTM01All";
        private static readonly string _uriWorkloadData = "api/rap/rpt/cmplx/proco/GetWorkloadData";
        private static readonly string _uriPRJCCTCM = "api/rap/rpt/cmplx/proco/GetPRJCCTCMData";
        private static readonly string _uriOUTSIDESUBCON = "api/rap/rpt/cmplx/proco/GetOUTSIDESUBCONData";

        #endregion CMPLX - PROCO - Uri

        #region CMPLX - ROJ - Uri

        private static readonly string _uriTM11TM01GData = "api/rap/rpt/cmplx/proj/GetTM11TM01GData";
        //private static readonly string _uriTM11AllData = "api/rap/rpt/cmplx/proj/GetTM11AllData";
        private static readonly string _uriTM11Data = "api/rap/rpt/cmplx/proj/GetTM11Data";
        private static readonly string _uriTM11BData = "api/rap/rpt/cmplx/proj/GetTM11BData";

        #endregion CMPLX - ROJ - Uri

        private static readonly string _uriTimesheetHR = "api/rap/rpt/downloadTimesheet";

        #region Process queue

        //private static readonly string _uriAddProcessQueue = "api/rap/rpt/cmplx/cc/AddProcessQueue";

        #endregion Process queue

        private readonly IHttpClientRapReporting _httpClientRapReporting;

        public ReportsController(IConfiguration configuration,
            IRapReportingReportsRepository rapReportingReportsRepository,
            IHttpClientRapReporting httpClientRapReporting,
            IFilterRepository filterRepository,
            ISelectTcmPLRepository selectTcmPLRepository,
            IWebHostEnvironment env,
            IProcessQueueDataTableListRepository processQueueDataTableListRepository,
            IProcessQueueRepository processQueueRepository,
            IProcessLogDataTableListRepository processLogDataTableListRepository)
        {
            _configuration = configuration;
            _rapReportingReportsRepository = rapReportingReportsRepository;
            _httpClientRapReporting = httpClientRapReporting;
            _filterRepository = filterRepository;
            _selectTcmPLRepository = selectTcmPLRepository;
            _env = env;
            _processQueueDataTableListRepository = processQueueDataTableListRepository;
            _processQueueRepository = processQueueRepository;
            _processLogDataTableListRepository = processLogDataTableListRepository;
        }

        public async Task<IActionResult> CommonIndex()
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

        private IActionResult ConvertResponseMessageToIActionResult(HttpResponseMessage httpResponseMessage, string defaultFileName)
        {
            string fileName = string.Empty;
            if (httpResponseMessage.IsSuccessStatusCode)
            {
                if (httpResponseMessage.Content.Headers.ContentType.ToString() == _contentTypeApplicationJSON)
                {
                    var jsonResult = httpResponseMessage.Content.ReadAsStringAsync().Result;
                    var jsonResultObj = Newtonsoft.Json.Linq.JObject.Parse(jsonResult);
                    return Json(new
                    {
                        success = jsonResultObj.Value<string>("Status") == "OK",
                        response = jsonResultObj.Value<string>("MessageCode") + " - " + jsonResultObj.Value<string>("Message")
                    });
                }
                IEnumerable<string> values;
                if (httpResponseMessage.Headers.TryGetValues("xl_file_name", out values))
                    fileName = values.First();

                fileName = fileName ?? defaultFileName;

                if (httpResponseMessage.Content.Headers.ContentType.ToString() == "application/zip")
                {
                    return File(httpResponseMessage.Content.ReadAsStreamAsync().Result, "application/zip", fileName);
                }

                return File(httpResponseMessage.Content.ReadAsStreamAsync().Result, "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", fileName);
            }
            else
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, "Internal server error");
            }
        }

        public IActionResult ReportsIndex()
        {
            return View();
        }

        public IActionResult SimpleReportsIndex()
        {
            return View();
        }

        #region >>>>> general reports

        public async Task<IActionResult> GeneralIndex()
        {
            if (!(CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionReportsCostCode) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionReportsProjectManager) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionReportsProco) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionReportsAFC) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionReportsHR) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionReportsMasters) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionRAPReports)))
            {
                return Forbid();
            }

            return await CommonIndex();
        }
                
        public async Task<IActionResult> GeneralCostcenterIndex()
        {
            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionReportsCostCode) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionRAPReports))
            {

                var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
                {
                    PModuleName = CurrentUserIdentity.CurrentModule,
                    PMetaId = CurrentUserIdentity.MetaId,
                    PPersonId = CurrentUserIdentity.EmployeeId,
                    PMvcActionName = ConstFilterRapIndex
                });
                FilterDataModel filterDataModel;
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

                string yymm = filterDataModel.Yyyymm;
                string costcode = filterDataModel.CostCode;

                if (!string.IsNullOrEmpty(costcode))
                {
                    var task1 = Task.Run(async () =>
                    {
                        var statusCostcenterMhrsReport = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
                        { Yymm = yymm, RepFor = costcode }, _uriGetProcessStatus);
                        var resultCostcenterMhrsReport = statusCostcenterMhrsReport.Content.ReadAsStringAsync().Result;
                        var dictCostcenterMhrsReport = JsonConvert.DeserializeObject<ReportStatusModel>(resultCostcenterMhrsReport);
                        ViewData["statusCostcenterMhrsReport"] = dictCostcenterMhrsReport.Data.Value.CanInitiateProcess == "OK" ? "Process" : dictCostcenterMhrsReport.Data.Value.CanDownload == "OK" ? "Download" : "Process";
                    });

                    await Task.WhenAll(task1);
                }

                return await CommonIndex();
            }
            else
                return NotFound();
        }
                
        public async Task<IActionResult> GeneralProjectIndex()
        {
            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionReportsProjectManager) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionRAPReports))
            {

                var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
                {
                    PModuleName = CurrentUserIdentity.CurrentModule,
                    PMetaId = CurrentUserIdentity.MetaId,
                    PPersonId = CurrentUserIdentity.EmployeeId,
                    PMvcActionName = ConstFilterRapIndex
                });
                FilterDataModel filterDataModel;
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

                string user = filterDataModel.User;
                string yyyy = filterDataModel.Yyyy;
                string yymm = filterDataModel.Yyyymm;
                string yearmode = filterDataModel.YearMode;
                string projno = filterDataModel.Projno;

                if (!string.IsNullOrEmpty(projno))
                {
                    var task1 = Task.Run(async () =>
                    {
                        var statusProjectMhrsReport = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
                        { Yymm = yymm, RepFor = projno.Substring(0, 5) }, _uriGetProcessStatus);
                        var resultProjectMhrsReport = statusProjectMhrsReport.Content.ReadAsStringAsync().Result;
                        var dictProjectMhrsReport = JsonConvert.DeserializeObject<ReportStatusModel>(resultProjectMhrsReport);
                        ViewData["statusProjectMhrsReport"] = dictProjectMhrsReport.Data.Value.CanInitiateProcess == "OK" ? "Process" : dictProjectMhrsReport.Data.Value.CanDownload == "OK" ? "Download" : "Process";
                    });

                    await Task.WhenAll(task1);
                }
                return await CommonIndex();
            }
            else
                return NotFound();
        }
                
        public async Task<IActionResult> GeneralProcoIndex()
        {
            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionReportsProco) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionRAPReports))
            {
                return await CommonIndex();
            }
            else
                return NotFound();
        }
                
        public async Task<IActionResult> GeneralAFCIndex()
        {
            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionReportsAFC) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionRAPReports))
            {
                return await CommonIndex();
            }
            else
                return NotFound();
        }
                
        public async Task<IActionResult> GeneralHRIndex()
        {
            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionReportsHR) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionRAPReports))
            {
                var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
                {
                    PModuleName = CurrentUserIdentity.CurrentModule,
                    PMetaId = CurrentUserIdentity.MetaId,
                    PPersonId = CurrentUserIdentity.EmployeeId,
                    PMvcActionName = ConstFilterRapIndex
                });
                FilterDataModel filterDataModel;
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

                string yymm = filterDataModel.Yyyymm.ToString();

                ViewData["NotFilledCount"] = await _rapReportingReportsRepository.GetTimesheetNotFilledCount(yymm);
                ViewData["NotPostedCount"] = await _rapReportingReportsRepository.GetTimesheetNotPostedCount(yymm);

                return await CommonIndex();
            }
            else
                return NotFound();
        }
                
        public async Task<IActionResult> GeneralMasterIndex()
        {
            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionReportsMasters) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionRAPReports))
            {
                return await CommonIndex();
            }
            else
                return NotFound();
        }

        public async Task<IActionResult> AnalyticalIndex()
        {
            if (!(CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionReportsCostCode) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionReportsProjectManager) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionReportsProco) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionReportsEnggMngr) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionReportsNonEnggMngr) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionReportsAFC)))                
            {
                return Forbid();
            }

            return await CommonIndex();
        }

        public async Task<IActionResult> ManagementIndex()
        {
            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterRapIndex
            });
            FilterDataModel filterDataModel;
            filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);                        

            return await CommonIndex();
        }

        public async Task<IActionResult> ComplexReportsIndex()
        {
            return await CommonIndex();
        }

        public async Task<IActionResult> ProcoReportsIndex()
        {
            return await CommonIndex();
        }

        #region Cost center

        #region BeforePost
                
        public async Task<IActionResult> CostCenterManhoursGenerateData(string yymm, string costcode)
        {
            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionReportsCostCode) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionRAPReports))
            {
                var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
                { Yymm = yymm, RepFor = costcode }, _uriProcessData);
                return Ok();
            }
            else
                return NotFound();

        }
                
        public async Task<IActionResult> CostCenterManhours(string yyyymm, string costcode)
        {
            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionReportsCostCode) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionRAPReports))
            {
                var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
                { Yyyymm = yyyymm, CostCenter = costcode }, _uriCostCenterManhours);
                return ConvertResponseMessageToIActionResult(returnResponse, "CostCenterManhours.xlsx");
            }
            else
                return NotFound();
        }
                
        public async Task<IActionResult> MHrsExceed(string yymm, string assign)
        {
            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionReportsCostCode) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionRAPReports))
            {
                var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
                { Yymm = yymm, Assign = assign }, _uriMHrsExceed);
                return ConvertResponseMessageToIActionResult(returnResponse, "MHrsExceed.xlsx");
            }
            else
                return NotFound();
        }
                
        public async Task<IActionResult> MJM(string yymm, string assign)
        {
            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionReportsCostCode) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionRAPReports))
            {
                var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
                { Yymm = yymm, Assign = assign }, _uriMJM_All);
                return ConvertResponseMessageToIActionResult(returnResponse, "MJM.xlsx");
            }
            else
                return NotFound();
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, RapReportingHelper.ActionReportsCostCode)]
        public async Task<IActionResult> MJEAM(string yymm, string assign)
        {
            var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
            { Yymm = yymm, Assign = assign }, _uriMJEAM);
            return ConvertResponseMessageToIActionResult(returnResponse, "MJEAM.xlsx");
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, RapReportingHelper.ActionReportsCostCode)]
        public async Task<IActionResult> MJAM(string yymm, string assign)
        {
            var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
            { Yymm = yymm, Assign = assign }, _uriMJAM);
            return ConvertResponseMessageToIActionResult(returnResponse, "MJAM.xlsx");
        }
        
        public async Task<IActionResult> DUPLSTA6(string yymm, string assign, string yearmode)
        {
            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionReportsCostCode) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionRAPReports))
            {
                var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
                { Yymm = yymm, Assign = assign, YearMode = yearmode }, _uriDUPLSTA6);
                return ConvertResponseMessageToIActionResult(returnResponse, "DUPLSTA6.xlsx");
            }
            else
                return NotFound();
        }
                
        public async Task<IActionResult> Leave(string yymm, string assign)
        {
            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionReportsCostCode) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionRAPReports))
            {
                var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
                { Yymm = yymm, Assign = assign }, _uriLeave);
                return ConvertResponseMessageToIActionResult(returnResponse, "Leave.xlsx");
            }
            else
                return NotFound();
        }
                
        public async Task<IActionResult> OddTimesheet(string yymm, string assign)
        {
            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionReportsCostCode) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionRAPReports))
            {
                var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
                { Yymm = yymm, Assign = assign }, _uriOddTimesheet);
                return ConvertResponseMessageToIActionResult(returnResponse, "OddTimesheet.xlsx");
            }
            else
                return NotFound();
        }
                
        public async Task<IActionResult> NotPostedTimesheet(string yymm, string assign)
        {
            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionReportsCostCode) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionRAPReports))
            {
                var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
                { Yymm = yymm, Assign = assign }, _uriNotPostedTimesheet);
                return ConvertResponseMessageToIActionResult(returnResponse, "NotPostedTimesheet.xlsx");
            }
            else
                return NotFound();
        }
                
        public async Task<IActionResult> CCPOSTDET(string assign)
        {
            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionReportsCostCode) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionRAPReports))
            {
                var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
                { Assign = assign }, _uriCCPOSTDET);
                return ConvertResponseMessageToIActionResult(returnResponse, "CCPOSTDET.xlsx");
            }
            else
                return NotFound();
        }

        #endregion BeforePost

        #region AfterPost

        //AfterPost        
        public async Task<IActionResult> CostCentre_PlanRep1(string costcode, string yymm)
        {
            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionReportsCostCode) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionRAPReports))
            {
                var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
                { CostCode = costcode, Yymm = yymm }, _uriCostCentre_PlanRep1);
                return ConvertResponseMessageToIActionResult(returnResponse, "CostCentre_PlanRep1.xlsx");
            }
            else
                return NotFound();
        }
                
        public async Task<IActionResult> Cost_PlanRep2(string costcode, string yymm)
        {
            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionReportsCostCode) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionRAPReports))
            {
                var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
                { CostCode = costcode, Yymm = yymm }, _uriCost_PlanRep2);
                return ConvertResponseMessageToIActionResult(returnResponse, "Cost_PlanRep2.xlsx");
            }
            else
                return NotFound();
        }
                
        public async Task<IActionResult> CostCentre_hrs_OtCrossTab(string costcode, string yymm)
        {
            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionReportsCostCode) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionRAPReports))
            {
                var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
                { CostCode = costcode, Yymm = yymm }, _uriCostCentre_hrs_OtCrossTab);
                return ConvertResponseMessageToIActionResult(returnResponse, "CostCentre_hrs_OtCrossTab.xlsx");
            }
            else
                return NotFound();
        }
                
        public async Task<IActionResult> CostCentre_hrs_OtBreak(string costcode, string yymm)
        {
            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionReportsCostCode) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionRAPReports))
            {
                var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
                { CostCode = costcode, Yymm = yymm }, _uriCostCentre_hrs_OtBreak);
                return ConvertResponseMessageToIActionResult(returnResponse, "CostCentre_hrs_OtBreak.xlsx");
            }
            else
                return NotFound();
        }
                
        public async Task<IActionResult> ListProjMhrsReport(string yymm, string costcode, string projectno)
        {
            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionReportsCostCode) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionRAPReports))
            {
                var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
                { Yymm = yymm, CostCode = costcode, Projno = projectno }, _uriProjectwiseManhours);
                return ConvertResponseMessageToIActionResult(returnResponse, "ProjectwiseManhours.xlsx");
            }
            else
                return NotFound();
        }
                
        public async Task<IActionResult> LISTPROJMHRS()
        {
            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionReportsCostCode) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionRAPReports))
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

                var projnos = await _selectTcmPLRepository.SelectProjnoRapReportingProco(BaseSpTcmPLGet(), null);
                ViewData["Projnos"] = new SelectList(projnos, "DataValueField", "DataTextField");

                return PartialView("_ModalGeneralCostCenterProjectPartial", filterDataModel);
            }
            else
                return NotFound();
        }

        #endregion AfterPost

        #endregion Cost center

        #region Project

        #region BeforePost

        //BeforePost        
        public async Task<IActionResult> ProjectManhoursGenerateData(string yymm, string projno)
        {
            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionReportsProjectManager) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionRAPReports))
            {

                var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
                { Yymm = yymm, RepFor = projno.Substring(0, 5) }, _uriProcessData);
                return Ok();
            }
            else
                return NotFound();
        }
                
        public async Task<IActionResult> ProjectManhours(string yyyymm, string projno)
        {
            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionReportsProjectManager) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionRAPReports))
            {
                var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
                { Yyyymm = yyyymm, Projno = projno.ToString().Substring(0, 5) }, _uriProjectManhours);
                return ConvertResponseMessageToIActionResult(returnResponse, "ProjectManhours.xlsx");
            }
            else
                return NotFound();
        }
                
        public async Task<IActionResult> BeforePostProj_YY_PRJ_CC(string projno, string yymm)
        {
            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionReportsProjectManager) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionRAPReports))
            {
                var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel            
                { Projno = projno, Yymm = yymm }, _uriMJM_Proj_All);
                return ConvertResponseMessageToIActionResult(returnResponse, "BeforePostProj_YY_PRJ_CC.xlsx");
            }
            else
                return NotFound();
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, RapReportingHelper.ActionReportsProjectManager)]
        public async Task<IActionResult> BeforePostProj_YY_PRJ_CC_ACT(string projno, string yymm)
        {
            var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
            { Projno = projno, Yymm = yymm }, _uriBeforePostProj_YY_PRJ_CC_ACT);
            return ConvertResponseMessageToIActionResult(returnResponse, "BeforePostProj_YY_PRJ_CC_ACT.xlsx");
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, RapReportingHelper.ActionReportsProjectManager)]
        public async Task<IActionResult> BeforePostProj_YY_PRJ_CC_EMP(string projno, string yymm)
        {
            var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
            { Projno = projno, Yymm = yymm }, _uriBeforePostProj_YY_PRJ_CC_EMP);
            return ConvertResponseMessageToIActionResult(returnResponse, "BeforePostProj_YY_PRJ_CC_EMP.xlsx");
        }

        #endregion BeforePost

        #region AfterPost

        //AfterPost        
        public async Task<IActionResult> Proj_Grade(string projno, string yymm)
        {
            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionReportsProjectManager) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionRAPReports))
            {
                var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
                { Projno = projno, Yymm = yymm }, _uriProj_Grade);
                return ConvertResponseMessageToIActionResult(returnResponse, "Proj_Grade.xlsx");
            }
            else
                return NotFound();
        }   
                
        public async Task<IActionResult> WorkPosition_Combine(string projno, string yymm)
        {
            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionReportsProjectManager) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionRAPReports))
            {
                var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
                { Projno = projno, Yymm = yymm }, _uriWorkPosition_Combine);
                return ConvertResponseMessageToIActionResult(returnResponse, "WorkPosition_Combine.xlsx");
            }
            else
                return NotFound();
        }
                
        public async Task<IActionResult> PRJ_CC_ACT_BUDG(string projno)
        {
            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionReportsProjectManager) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionRAPReports))
            {
                var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
                { Projno = projno }, _uriPRJ_CC_ACT_BUDG);
                return ConvertResponseMessageToIActionResult(returnResponse, "PRJ_CC_ACT_BUDG.xlsx");
            }
            else
                return NotFound();
        }
                
        public async Task<IActionResult> Proj_PlanRep1(string projno, string yymm)
        {
            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionReportsProjectManager) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionRAPReports))
            {
                var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
                { Projno = projno, Yymm = yymm }, _uriProj_PlanRep1);
                return ConvertResponseMessageToIActionResult(returnResponse, "Proj_PlanRep1.xlsx");
            }
            else
                return NotFound();
        }
                
        public async Task<IActionResult> Proj_PlanRep2(string projno, string yymm)
        {
            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionReportsProjectManager) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionRAPReports))
            {
                var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
                { Projno = projno, Yymm = yymm }, _uriProj_PlanRep2);
                return ConvertResponseMessageToIActionResult(returnResponse, "Proj_PlanRep2.xlsx");
            }
            else
                return NotFound();
        }        
                
        public async Task<IActionResult> ProjCostOT_combine(string projno)
        {
            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionReportsProjectManager) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionRAPReports))
            {
                var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
                { Projno = projno }, _uriProjCostOT_combine);
                return ConvertResponseMessageToIActionResult(returnResponse, "ProjCostOT_combine.xlsx");
            }
            else
                return NotFound();
        }
                
        public async Task<IActionResult> Projhrs_OtBreak(string projno, string yymm)
        {
            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionReportsProjectManager) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionRAPReports))
            {
                var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
                { Projno = projno, Yymm = yymm }, _uriProjhrs_OtBreak);
                return ConvertResponseMessageToIActionResult(returnResponse, "Projhrs_OtBreak.xlsx");
            }
            else
                return NotFound();
        }
                
        public async Task<IActionResult> Projhrs_OtCrossTab(string projno, string yymm)
        {
            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionReportsProjectManager) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionRAPReports))
            {
                var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
                { Projno = projno, Yymm = yymm }, _uriProjhrs_OtCrossTab);
                return ConvertResponseMessageToIActionResult(returnResponse, "Projhrs_OtCrossTab.xlsx");
            }
            else
                return NotFound();
        }

        #endregion AfterPost

        #endregion Project

        #region PROCO
                
        public async Task<IActionResult> PROCO_CovidManhrsDistribution(string yymm, string costCode, string projno)
        {
            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionReportsProco) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionRAPReports))
            {
                var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
                { Yymm = yymm, CostCode = costCode, Projno = projno }, _uriCovidManhrsDistribution);
                return ConvertResponseMessageToIActionResult(returnResponse, "CovidManhrsDistribution.xlsx");
            }
            else
                return NotFound();
        }
        
        public async Task<IActionResult> PlanRep4(string yymm)
        {
            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionReportsProco) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionRAPReports))
            {
                var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
                { Yymm = yymm }, _uriPlanRep4);
                return ConvertResponseMessageToIActionResult(returnResponse, "PlanRep4.xlsx");
            }
            else
                return NotFound();
        }
                
        public async Task<IActionResult> PlanRep5(string yymm)
        {
            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionReportsProco) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionRAPReports))
            {
                var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
                { Yymm = yymm }, _uriPlanRep5);
                return ConvertResponseMessageToIActionResult(returnResponse, "PlanRep5.xlsx");
            }
            else
                return NotFound();
        }
                
        public async Task<IActionResult> PROCO_TS_ACT(string yymm)
        {
            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionReportsProco) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionRAPReports))
            {
                var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
                { Yymm = yymm }, _uriPROCO_TS_ACT);
                return ConvertResponseMessageToIActionResult(returnResponse, "PROCO_TS_ACT.xlsx");
            }
            else
                return NotFound();
        }
                
        public async Task<IActionResult> GeneralProcoCCPOSTDET() // MOD Prefix "GeneralProco"
        {
            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionReportsProco) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionRAPReports))
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

                var costCodes = await _selectTcmPLRepository.SelectCostCodeRapReportingProco(BaseSpTcmPLGet(), null);
                ViewData["CostCodes"] = new SelectList(costCodes, "DataValueField", "DataTextField");

                return PartialView("_ModalGeneralProcoTimesheetStatusPartial", filterDataModel);
            }
            else
                return NotFound();
        }
                
        public async Task<IActionResult> GeneralProcoCCPOSTDETReport(string costcenter) // MOD Prefix "GeneralProco"
        {
            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionReportsProco) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionRAPReports))
            {
                var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
                { Assign = costcenter }, _uriCCPOSTDET);
                return ConvertResponseMessageToIActionResult(returnResponse, "CCPOSTDET.xlsx");
            }
            else
                return NotFound();
        }
                
        public async Task<IActionResult> Ccpost()
        {
            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionReportsProco) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionRAPReports))
            {
                var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
                { }, _uriCcpost);
                return ConvertResponseMessageToIActionResult(returnResponse, "Ccpost.xlsx");
            }
            else
                return NotFound();
        }
                
        public async Task<IActionResult> Checkposted()
        {
            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionReportsProco) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionRAPReports))
            {
                var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
                { }, _uriCheckposted);
                return ConvertResponseMessageToIActionResult(returnResponse, "Checkposted.xlsx");
            }
            else
                return NotFound();
        }
                
        public async Task<IActionResult> Exptjobs()
        {
            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionReportsProco) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionRAPReports))
            {
                var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
                { }, _uriExptjobs);
                return ConvertResponseMessageToIActionResult(returnResponse, "Exptjobs.xlsx");
            }
            else
                return NotFound();
        }
                
        public async Task<IActionResult> Kallodaily(string yymm)
        {
            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionReportsProco) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionRAPReports))
            {
                var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
                { Yymm = yymm }, _uriKallodaily);
                return ConvertResponseMessageToIActionResult(returnResponse, "Kallodaily.xlsx");
            }
            else
                return NotFound();
        }
        
        public async Task<IActionResult> Projections(string yymm)
        {
            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionReportsProco) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionRAPReports))
            {
                var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
                { Yymm = yymm }, _uriProjections);
                return ConvertResponseMessageToIActionResult(returnResponse, "Projections.xlsx");
            }
            else
                return NotFound();
        }

        #endregion PROCO

        #region AFC
                
        public async Task<IActionResult> AFC_CovidManhrsDistribution(string yymm, string costCode, string projno)
        {
            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionReportsAFC) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionRAPReports))
            {
                var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
                { Yymm = yymm, CostCode = costCode, Projno = projno }, _uriCovidManhrsDistribution);
                return ConvertResponseMessageToIActionResult(returnResponse, "CovidManhrsDistribution.xlsx");
            }
            else
                return NotFound();
        }
                
        public async Task<IActionResult> Auditor(string yymm, string yearmode, string activeyear)
        {
            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionReportsAFC) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionRAPReports))
            {
                var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
                { Yymm = yymm, YearMode = yearmode }, _uriAuditor, activeyear);
                return ConvertResponseMessageToIActionResult(returnResponse, "Auditor.xlsx");
            }
            else
                return NotFound();
        }
                
        public async Task<IActionResult> Finance_TS(string yymm, string yearmode, string activeyear)
        {
            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionReportsAFC) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionRAPReports))
            {
                var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
                { Yymm = yymm, YearMode = yearmode }, _uriFinance_TS, activeyear);

                return ConvertResponseMessageToIActionResult(returnResponse, "Finance_TS.xlsx");
            }
            else
                return NotFound();
        }
                
        public async Task<IActionResult> JOB_PROJ_PH_LIST(string yymm)
        {
            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionReportsAFC) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionRAPReports))
            {
                var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
                { Yymm = yymm }, _uriJOB_PROJ_PH_LIST);
                return ConvertResponseMessageToIActionResult(returnResponse, "JOB_PROJ_PH_LIST.xlsx");
            }
            else
                return NotFound();
        }
                
        public async Task<IActionResult> Auditor_Subcontractor_wise(string yymm, string yearmode, string activeyear)
        {
            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionReportsAFC) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionRAPReports))
            {
                var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
                { Yymm = yymm, YearMode = yearmode }, _uriAuditor_Subcontractor_wise, activeyear);
                return ConvertResponseMessageToIActionResult(returnResponse, "JOB_PROJ_PH_LIST.xlsx");
            }
            else
                return NotFound();
        }
                
        public async Task<IActionResult> ManhourExportToSAP()
        {
            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionReportsAFC) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionRAPReports))
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

                var yyyymm = await _selectTcmPLRepository.SelectYearMonthRapReporting(BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PYyyy = filterDataModel.Yyyy,
                            PYearmode = filterDataModel.YearMode
                        });
                ViewData["Yyyymm"] = new SelectList(yyyymm, "DataValueField", "DataTextField", filterDataModel.Yyyymm);

                var costcodes = await _selectTcmPLRepository.SelectCostCodeRapReportingProco(BaseSpTcmPLGet(), null);
                ViewData["Costcodes"] = new SelectList(costcodes, "DataValueField", "DataTextField");

                var projects = await _selectTcmPLRepository.SelectProjnoRapReportingProco(BaseSpTcmPLGet(), null);
                ViewData["Projects"] = new SelectList(projects, "DataValueField", "DataTextField");

                filterDataModel.ReportType = "A";
                filterDataModel.EmployeeTypeList = new string[] { "C", "F", "P", "S" };

                return PartialView("_ModalGeneralAfcExportToSapPartial", filterDataModel);
            }
            else
                return NotFound();
        }
                
        public async Task<IActionResult> ManhourExportToSAPReport(string yymm, string reporttype, string costcenter, string projno, string employeetypelist)
        {
            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionReportsAFC) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionRAPReports))
            {
                var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
                {
                    Yymm = yymm,
                    ReportType = reporttype,
                    CostCenter = costcenter,
                    Projno = projno,
                    EmployeeTypeList = employeetypelist
                }, _uriManhourExportToSAP);
                return ConvertResponseMessageToIActionResult(returnResponse, "ManhourExportToSAP.zip");
            }
            else
                return NotFound();
        }

        #endregion AFC

        #region HR
                
        public async Task<IActionResult> Employee_2011onwards()
        {
            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionReportsHR) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionRAPReports))
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

                var empnos = await _selectTcmPLRepository.SelectEmpnoRapReporting(BaseSpTcmPLGet(), null);
                ViewData["Empnos"] = new SelectList(empnos, "DataValueField", "DataTextField");

                return PartialView("_ModalGeneralHREmpnoPartial", filterDataModel);
            }
            else
                return NotFound();
        }
                
        public async Task<IActionResult> Employee_2011onwardsReport(string empno)
        {
            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionReportsHR) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionRAPReports))
            {
                var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
                { Empno = empno }, _uriEmployee_2011onwards);
                return ConvertResponseMessageToIActionResult(returnResponse, "Employee_2011onwards.xlsx");
            }
            else
                return NotFound();
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, RapReportingHelper.ActionReportsHR)]
        public async Task<IActionResult> SUBCONTRACTOR_TS(string yymm)
        {
            var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
            { Yymm = yymm }, _uriSUBCONTRACTOR_TS);
            return ConvertResponseMessageToIActionResult(returnResponse, "SUBCONTRACTOR_TS.xlsx");
        }
                
        public async Task<IActionResult> TSNOTFILLED(string yymm)
        {
            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionReportsHR) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionRAPReports))
            {
                var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
                { Yymm = yymm, ReportType = "Filled" }, _uriPENDING_TS);
                return ConvertResponseMessageToIActionResult(returnResponse, "TSNOTFILLED.xlsx");
            }
            else
                return NotFound();
        }
                
        public async Task<IActionResult> TSNOTPOSTED(string yymm)
        {
            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionReportsHR) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionRAPReports))
            {
                var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
                { Yymm = yymm, ReportType = "Posted" }, _uriPENDING_TS);
                return ConvertResponseMessageToIActionResult(returnResponse, "TSNOTPOSTED.xlsx");
            }
            else
                return NotFound();
        }
                
        public async Task<IActionResult> LeaveHR(string yymm)
        {
            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionReportsHR) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionRAPReports))
            {
                var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
                { Yymm = yymm }, _uriLeaveHR);
                return ConvertResponseMessageToIActionResult(returnResponse, "Leave.xlsx");
            }
            else
                return NotFound();
        }
                
        public async Task<IActionResult> TimesheetHR()
        {
            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionReportsHR) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionRAPReports))
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

                var empnos = await _selectTcmPLRepository.SelectEmpnoRapReporting(BaseSpTcmPLGet(), null);
                ViewData["Empnos"] = new SelectList(empnos, "DataValueField", "DataTextField");

                return PartialView("_ModalGeneralHRTimesheetPartial", filterDataModel);
            }
            else
                return NotFound();
        }
                
        public async Task<IActionResult> TimesheetHRReport(string empno, string yymm)
        {
            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionReportsHR) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionRAPReports))
            {
                var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
                { Empno = empno, Yymm = yymm }, _uriTimesheetHR);
                return ConvertResponseMessageToIActionResult(returnResponse, "Timesheet.xlsx");
            }
            else
                return NotFound();
        }

        #endregion HR

        #region Master
                
        public async Task<IActionResult> PROJACT()
        {
            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionReportsMasters) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionRAPReports))
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

                var costCodes = await _selectTcmPLRepository.SelectCostCodeRapReportingProco(BaseSpTcmPLGet(), null);
                ViewData["CostCodes"] = new SelectList(costCodes, "DataValueField", "DataTextField");

                return PartialView("_ModalGeneralMasterProjectCostCodePartial", filterDataModel);
            }
            else
                return NotFound();
        }
                
        public async Task<IActionResult> PROJACTReport(string costcenter)
        {
            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionReportsMasters) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionRAPReports))
            {
                var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
                { CostCode = costcenter }, _uriPROJACT);
                return ConvertResponseMessageToIActionResult(returnResponse, "PROJACT.xlsx");
            }
            else
                return NotFound();
        }
                
        public async Task<IActionResult> ListACT()
        {
            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionReportsMasters) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionRAPReports))
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

                var costCodes = await _selectTcmPLRepository.SelectCostCodeRapReportingProco(BaseSpTcmPLGet(), null);
                ViewData["CostCodes"] = new SelectList(costCodes, "DataValueField", "DataTextField");

                return PartialView("_ModalGeneralMasterActivityPartial", filterDataModel);
            }
            else
                return NotFound();
        }
                
        public async Task<IActionResult> ListACTReport(string costcenter)
        {
            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionReportsMasters) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionRAPReports))
            {
                var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
                { CostCode = costcenter }, _uriLISTACT);
                return ConvertResponseMessageToIActionResult(returnResponse, "LISTACT.xlsx");
            }
            else
                return NotFound();
        }
                
        public async Task<IActionResult> TLP_Codes_Master()
        {
            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionReportsMasters) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionRAPReports))
            {
                var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
                { }, _uriTLP_Codes_Master);
                return ConvertResponseMessageToIActionResult(returnResponse, "TLP_Codes_Master.xlsx");
            }
            else
                return NotFound();
        }
                
        public async Task<IActionResult> LISTEMP()
        {

            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionReportsMasters) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionRAPReports))
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

                var costCodes = await _selectTcmPLRepository.SelectCostCodeRapReportingProco(BaseSpTcmPLGet(), null);
                ViewData["CostCodes"] = new SelectList(costCodes, "DataValueField", "DataTextField");

                return PartialView("_ModalGeneralMasterEmployeeListPartial", filterDataModel);
            }
            else
                return NotFound();
        }
                
        public async Task<IActionResult> LISTEMPParent()
        {
            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionReportsMasters) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionRAPReports))
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

                var costCodes = await _selectTcmPLRepository.SelectCostCodeRapReportingProco(BaseSpTcmPLGet(), null);
                ViewData["CostCodes"] = new SelectList(costCodes, "DataValueField", "DataTextField");

                return PartialView("_ModalGeneralMasterEmployeeListParentPartial", filterDataModel);
            }
            else
                return NotFound();
        }
                    
        public async Task<IActionResult> LISTEMPReport(string costcenter)
        {
            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionReportsMasters) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionRAPReports))
            {
                var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
                { CostCode = costcenter }, _uriLISTEMP);
                return ConvertResponseMessageToIActionResult(returnResponse, "LISTEMP.xlsx");
            }
            else
                return NotFound();
        }
                
        public async Task<IActionResult> LISTEMP_ParentReport(string costcenter)
        {
            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionReportsMasters) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionRAPReports))
            {
                var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
                { CostCode = costcenter }, _uriLISTEMP_Parent);
                return ConvertResponseMessageToIActionResult(returnResponse, "LISTEMP_ParentReport.xlsx");
            }
            else
                return NotFound();
        }    
                
        public async Task<IActionResult> ListActProj()
        {
            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionReportsMasters) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionRAPReports))
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

                var projnos = await _selectTcmPLRepository.SelectProjnoRapReportingProco(BaseSpTcmPLGet(), null);
                ViewData["Projnos"] = new SelectList(projnos, "DataValueField", "DataTextField");

                return PartialView("_ModalGeneralMasterProjectActivityPartial", filterDataModel);
            }
            else
                return NotFound();
        }

        
        public async Task<IActionResult> ListActProjReport(string projectno)
        {
            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionReportsMasters) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionRAPReports))
            {
                var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
                { Projno = projectno }, _uriListActProj);
                return ConvertResponseMessageToIActionResult(returnResponse, "ListActProj.xlsx");
            }
            else
                return NotFound();
        }

        #endregion Master

        #endregion >>>>> general reports

        #region >>>>> analytical reports

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, RapReportingHelper.ActionReportsCostCode)]
        public async Task<IActionResult> AnalyticalCostcenterIndex()
        {
            return await CommonIndex();
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, RapReportingHelper.ActionReportsProjectManager)]
        public async Task<IActionResult> AnalyticalProjectIndex()
        {
            return await CommonIndex();
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, RapReportingHelper.ActionReportsProco)]
        public async Task<IActionResult> AnalyticalProcoIndex()
        {
            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterRapIndex
            });
            FilterDataModel filterDataModel;
            filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            string user = filterDataModel.User;
            string yyyy = filterDataModel.Yyyy;
            string yymm = filterDataModel.Yyyymm;
            string yearmode = filterDataModel.YearMode;           
 
            return await CommonIndex();
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, RapReportingHelper.ActionReportsEnggMngr)]
        public async Task<IActionResult> AnalyticalEnggIndex()
        {
            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterRapIndex
            });
            FilterDataModel filterDataModel;
            filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            return await CommonIndex();
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, RapReportingHelper.ActionReportsNonEnggMngr)]
        public async Task<IActionResult> AnalyticalNonEnggIndex()
        {
            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterRapIndex
            });
            FilterDataModel filterDataModel;
            filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);            

            return await CommonIndex();
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, RapReportingHelper.ActionReportsAFC)]
        public async Task<IActionResult> AnalyticalAFCIndex()
        {
            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterRapIndex
            });
            FilterDataModel filterDataModel;
            filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            string user = filterDataModel.User;
            string yyyy = filterDataModel.Yyyy;
            string yymm = filterDataModel.Yyyymm;
            string yearmode = filterDataModel.YearMode;            

            return await CommonIndex();
        }

        #region Cost center

        #region BeforPost

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, RapReportingHelper.ActionReportsCostCode)]
        public async Task<IActionResult> DuplTm02(string costcode, string yymm, string yearmode, string activeyear)
        {
            //activeYear
            var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
            { CostCode = costcode, Yymm = yymm, YearMode = yearmode }, _uriDuplTm02, activeyear);
            return ConvertResponseMessageToIActionResult(returnResponse, "DuplTm02.xlsx");
        }

        #endregion BeforPost

        #region AfterPost

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, RapReportingHelper.ActionReportsCostCode)]
        public async Task<IActionResult> Cha1Sta6Tm02(string costcode, string yymm, string yearmode, string activeyear, string reportMode)
        {
            var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
            { CostCode = costcode, Yymm = yymm, YearMode = yearmode, ReportMode  = reportMode }, _uriCha1Sta6Tm02, activeyear);
            return ConvertResponseMessageToIActionResult(returnResponse, "Cha1Sta6Tm02.xlsx");
        }

        #endregion AfterPost

        #region General

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, RapReportingHelper.ActionReportsCostCode)]
        public async Task<IActionResult> CHA01E(string costcode, string yymm, string yearmode, string activeyear, string reportMode)
        {
            var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
            { CostCode = costcode, Yymm = yymm, YearMode = yearmode, ReportMode = reportMode }, _uriCHA01EData, activeyear);
            return ConvertResponseMessageToIActionResult(returnResponse, "CHA01EData.xlsx");
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, RapReportingHelper.ActionReportsCostCode)]
        public async Task<IActionResult> CHA01ESim(string costcode, string yymm, string yearmode, string activeyear, string reportMode)
        {
            var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
            { CostCode = costcode, Yymm = yymm, YearMode = yearmode, ReportMode = reportMode }, _uriCHA01ESimData, activeyear);
            return ConvertResponseMessageToIActionResult(returnResponse, "CHA01ESimData.xlsx");
        }

        #endregion General

        #endregion Cost center

        #region Project

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, RapReportingHelper.ActionReportsProjectManager)]
        public async Task<IActionResult> TM11(string projno, string yymm, string yearmode, string yyyy)
        {
            string urlPath = _uriTM11Data;
            //if (_env.EnvironmentName.ToString() == "Development")
            //{
            //    urlPath = "api/rap/rpt/cmplx/proj/GetTM11Data_Qual";
            //}
            var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
            { Projno = projno, Yymm = yymm, YearMode = yearmode, Yyyy = yyyy }, urlPath);

            return ConvertResponseMessageToIActionResult(returnResponse, "TM11Data.xlsx");
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, RapReportingHelper.ActionReportsProjectManager)]
        public async Task<IActionResult> TM11TM01G(string projno, string yymm, string yearmode)
        {
            var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
            { Projno = projno, Yymm = yymm, YearMode = yearmode }, _uriTM11TM01GData);

            return ConvertResponseMessageToIActionResult(returnResponse, "TM11TM01GData.xlsx");
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, RapReportingHelper.ActionReportsProjectManager)]
        public async Task<IActionResult> TM11B(string projno, string yymm, string yearmode, string yyyy)
        {
            var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
            { Projno = projno, Yymm = yymm, YearMode = yearmode, Yyyy = yyyy }, _uriTM11BData);

            return ConvertResponseMessageToIActionResult(returnResponse, "TM11BData.xlsx");
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, RapReportingHelper.ActionReportsProjectManager)]
        public async Task<IActionResult> TM11ClosedJobs(string closedProjno, string yymm, string yearmode, string yyyy)
        {
            string urlPath = _uriTM11Data;
            //if (_env.EnvironmentName.ToString() == "Development")
            //{
            //    urlPath = "api/rap/rpt/cmplx/proj/GetTM11Data_Qual";
            //}
            var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
            { Projno = closedProjno, Yymm = yymm, YearMode = yearmode, Yyyy = yyyy }, urlPath);

            return ConvertResponseMessageToIActionResult(returnResponse, "TM11Data.xlsx");
        }

        #endregion Project

        #region PROCO

        #region BeforPost

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, RapReportingHelper.ActionReportsProco)]
        public async Task<IActionResult> PRJCCTCM(string yymm, string yearmode)
        {
            var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
            { Yymm = yymm, YearMode = yearmode }, _uriPRJCCTCM);
            return ConvertResponseMessageToIActionResult(returnResponse, "PRJCCTCM.xlsx");
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, RapReportingHelper.ActionReportsProco)]
        public async Task<IActionResult> PRJCCPORTHRS(string yymm, string yearmode)
        {
            var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
            { Yymm = yymm, YearMode = yearmode }, _uriPRJCCPORTHRSData);

            return ConvertResponseMessageToIActionResult(returnResponse, "PRJCCPORTHRSData.xlsx");
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, RapReportingHelper.ActionReportsProco)]
        public async Task<IActionResult> Workload(string yymm, string sim, string yearmode, string activeyear)
        {
            var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
            { Yymm = yymm, Sim = sim, YearMode = yearmode }, _uriWorkloadData, activeyear);

            return ConvertResponseMessageToIActionResult(returnResponse, "WorkloadData.xlsx");
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, RapReportingHelper.ActionReportsProco)]
        public async Task<IActionResult> AnalyticalProcoBeforPostWorkloadSimul()//MOD Prefix "AnalyticalProcoBeforPost"
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

            var simulations = await _selectTcmPLRepository.SelectSimulationRapReporting(BaseSpTcmPLGet(), null);
            ViewData["Simulations"] = new SelectList(simulations, "DataValueField", "DataTextField");

            return PartialView("_ModalAnalyticalProcoSimulationPartial", filterDataModel);
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, RapReportingHelper.ActionReportsProco)]
        public async Task<IActionResult> AnalyticalProcoBeforPostWorkloadSimulReport(string yymm, string sim, string yearmode, string activeyear)//MOD Prefix "AnalyticalProcoBeforPost"
        {
            var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
            { Yymm = yymm, Sim = sim, YearMode = yearmode }, _uriWorkloadData, activeyear);

            return ConvertResponseMessageToIActionResult(returnResponse, "WorkloadData.xlsx");
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, RapReportingHelper.ActionReportsProco)]
        public async Task<IActionResult> TM01All(string yyyy, string yymm, string yearmode, string ProcessId, string ProcessItemId)
        {
            try
            {
                if (ProcessId != "TM01DUPL")
                    return Json(ResponseHelper.GetMessageObject("Err - Process Id not matching.", NotificationType.error));

                string parameterJson;
                var settings = new JsonSerializerSettings
                {
                    NullValueHandling = NullValueHandling.Ignore
                };

                parameterJson = JsonConvert.SerializeObject(new HCModel
                {
                    Yyyy = yyyy,
                    YearMode = yearmode,
                    Yyyymm = yymm
                }, settings);

                var result = await _processQueueRepository.AddProcessQueue(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PModuleId = ModuleId,
                        PProcessId = "TM01DUPL",
                        PProcessItemId = ProcessItemId,
                        PProcessDesc = "RAP-REPORTING - TM01DUPL",
                        PParameterJson = parameterJson,
                        PMailTo = "",
                        PMailCc = ""
                    });

                return Json(ResponseHelper.GetMessageObject(result.PMessageText, result.PMessageType == IsOk ? NotificationType.success : NotificationType.error));

            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, RapReportingHelper.ActionReportsProco)]
        public async Task<IActionResult> ResourceAvlSch(string yymm, string yearmode, string activeyear)
        {
            var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
            { Yymm = yymm, YearMode = yearmode }, _uriResourceAvlSch, activeyear);

            return ConvertResponseMessageToIActionResult(returnResponse, "ResourceAvlSch.xlsx");
        }

        #endregion BeforPost

        #region AfterPost

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, RapReportingHelper.ActionReportsProco)]
        public async Task<IActionResult> TMA(string yyyy, string yearmode, string yymm, string reportType, string ProcessId, string ProcessItemId)
        {
            try
            {
                if (ProcessId != "TMAProcoDetail")
                    return Json(ResponseHelper.GetMessageObject("Err - Process Id not matching.", NotificationType.error));

                string parameterJson;
                var settings = new JsonSerializerSettings
                {
                    NullValueHandling = NullValueHandling.Ignore
                };

                parameterJson = JsonConvert.SerializeObject(new HCModel
                {
                    Yyyy = yyyy,
                    YearMode = yearmode,
                    Yyyymm = yymm,
                    ReportType = reportType
                }, settings);

                var result = await _processQueueRepository.AddProcessQueue(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PModuleId = ModuleId,
                        PProcessId = "TMAProcoDetail",
                        PProcessItemId = ProcessItemId,
                        PProcessDesc = "RAP-REPORTING - TMAProcoDetail",
                        PParameterJson = parameterJson,
                        PMailTo = "",
                        PMailCc = ""
                    });

                return Json(ResponseHelper.GetMessageObject(result.PMessageText, result.PMessageType == IsOk ? NotificationType.success : NotificationType.error));

            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, RapReportingHelper.ActionReportsProco)]
        public async Task<IActionResult> AnalyticalProcoAfterPostTMASummary(string yyyy, string yearmode, string yymm, string reportType, string ProcessId, string ProcessItemId)
        {
            try
            {
                if (ProcessId != "TMAProcoSummary")
                    return Json(ResponseHelper.GetMessageObject("Err - Process Id not matching.", NotificationType.error));

                string parameterJson;
                var settings = new JsonSerializerSettings
                {
                    NullValueHandling = NullValueHandling.Ignore
                };

                parameterJson = JsonConvert.SerializeObject(new HCModel
                {
                    Yyyy = yyyy,
                    YearMode = yearmode,
                    Yyyymm = yymm,
                    ReportType = reportType
                }, settings);

                var result = await _processQueueRepository.AddProcessQueue(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PModuleId = ModuleId,
                        PProcessId = "TMAProcoSummary",
                        PProcessItemId = ProcessItemId,
                        PProcessDesc = "RAP-REPORTING - TMAProcoSummary",
                        PParameterJson = parameterJson,
                        PMailTo = "",
                        PMailCc = ""
                    });

                return Json(ResponseHelper.GetMessageObject(result.PMessageText, result.PMessageType == IsOk ? NotificationType.success : NotificationType.error));

            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, RapReportingHelper.ActionReportsProco)]
        public async Task<IActionResult> TM11_All(string yyyy, string yearmode, string yymm, string ProcessId, string ProcessItemId)
        {
            try
            {
                if (ProcessId != "TCMJobsGrp")
                    return Json(ResponseHelper.GetMessageObject("Err - Process Id not matching.", NotificationType.error));

                string parameterJson;
                var settings = new JsonSerializerSettings
                {
                    NullValueHandling = NullValueHandling.Ignore
                };

                parameterJson = JsonConvert.SerializeObject(new HCModel
                {
                    Yyyy = yyyy,
                    YearMode = yearmode,
                    Yyyymm = yymm
                }, settings);

                var result = await _processQueueRepository.AddProcessQueue(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PModuleId = ModuleId,
                        PProcessId = "TCMJobsGrp",
                        PProcessItemId = ProcessItemId,
                        PProcessDesc = "RAP-REPORTING - TCMJobsGrp",
                        PParameterJson = parameterJson,
                        PMailTo = "",
                        PMailCc = ""
                    });

                return Json(ResponseHelper.GetMessageObject(result.PMessageText, result.PMessageType == IsOk ? NotificationType.success : NotificationType.error));

            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, RapReportingHelper.ActionReportsProco)]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Cha1Sta6Tm02_Bulk(string yyyy, string yearmode, string yymm, string ProcessId, string ProcessItemId)
        {
            try
            {
                if (ProcessId != "CHA1STA602")
                    return Json(ResponseHelper.GetMessageObject("Err - Process Id not matching.", NotificationType.error));

                string parameterJson;
                var settings = new JsonSerializerSettings
                {
                    NullValueHandling = NullValueHandling.Ignore
                };

                parameterJson = JsonConvert.SerializeObject(new HCModel
                {
                    Yyyy = yyyy,
                    YearMode = yearmode,
                    Yyyymm = yymm,
                    CostcodeGroupId = costcodeGroupId,
                    CostcodeGroupName = costcodeGroupName
                }, settings);

                var result = await _processQueueRepository.AddProcessQueue(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PModuleId = ModuleId,
                        PProcessId = "CHA1STA602",
                        PProcessItemId = ProcessItemId,
                        PProcessDesc = "RAP-REPORTING - CHA1STA6TM02",
                        PParameterJson = parameterJson,
                        PMailTo = "",
                        PMailCc = ""
                    });

                return Json(ResponseHelper.GetMessageObject(result.PMessageText, result.PMessageType == IsOk ? NotificationType.success : NotificationType.error));

            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }
                
        public async Task<IActionResult> OUTSIDESUBCON(string yyyy, string yearmode, string yymm, string costcode)
        {
            var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
            { Yyyy = yyyy, YearMode = yearmode, Yymm = yymm,  CostCode = costcode }, _uriOUTSIDESUBCON);
            return ConvertResponseMessageToIActionResult(returnResponse, "OUTSIDESUBCON.xlsx");
        }

        #endregion AfterPost

        #endregion PROCO

        #region Engineering

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, RapReportingHelper.ActionReportsEnggMngr)]        
        public async Task<IActionResult> CHA1Engg(string yyyy, string yearmode, string yymm, string category, string ProcessId, string ProcessItemId)
        {
            try
            {
                if (ProcessId == "CHA1ExptEngg" || ProcessId == "CHA1ExptEnggMumbai" || ProcessId == "CHA1ExptEnggDelhi" || ProcessId == "CHA1ExptEnggC")
                { 
                    string parameterJson;
                    var settings = new JsonSerializerSettings
                    {
                        NullValueHandling = NullValueHandling.Ignore
                    };

                    parameterJson = JsonConvert.SerializeObject(new HCModel
                    {
                        Yyyy = yyyy,
                        YearMode = yearmode,
                        Yyyymm = yymm,
                        Category = category
                    }, settings);

                    var result = await _processQueueRepository.AddProcessQueue(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PModuleId = ModuleId,
                            PProcessId = ProcessId,
                            PProcessItemId = ProcessItemId,
                            PProcessDesc = "RAP-REPORTING - " + ProcessId,
                            PParameterJson = parameterJson,
                            PMailTo = "",
                            PMailCc = ""
                        });

                    return Json(ResponseHelper.GetMessageObject(result.PMessageText, result.PMessageType == IsOk ? NotificationType.success : NotificationType.error));
                }
                else
                    return Json(ResponseHelper.GetMessageObject("Err - Process Id not matching.", NotificationType.error));
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, RapReportingHelper.ActionReportsEnggMngr)]        
        public async Task<IActionResult> CHA1EnggSim(string yyyy, string yearmode, string yymm, string category, string simul, string ProcessId, string ProcessItemId)
        {
            try
            {
                if (ProcessId == "CHA1ExptEnggS" || ProcessId == "CHA1ExptEnggMumbaiS" || ProcessId == "CHA1ExptEnggDelhiS")
                {                    
                    string parameterJson;
                    var settings = new JsonSerializerSettings
                    {
                        NullValueHandling = NullValueHandling.Ignore
                    };

                    parameterJson = JsonConvert.SerializeObject(new HCModel
                    {
                        Yyyy = yyyy,
                        YearMode = yearmode,
                        Yyyymm = yymm,
                        Category = category,
                        Simul = simul
                    }, settings);

                    var result = await _processQueueRepository.AddProcessQueue(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PModuleId = ModuleId,
                            PProcessId = ProcessId,
                            PProcessItemId = ProcessItemId,
                            PProcessDesc = "RAP-REPORTING - " + ProcessId,
                            PParameterJson = parameterJson,
                            PMailTo = "",
                            PMailCc = ""
                        });

                    return Json(ResponseHelper.GetMessageObject(result.PMessageText, result.PMessageType == IsOk ? NotificationType.success : NotificationType.error));
                }
                else
                    return Json(ResponseHelper.GetMessageObject("Err - Process Id not matching.", NotificationType.error));
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, RapReportingHelper.ActionReportsEnggMngr)]
        public async Task<IActionResult> Breakup(string yymm, string category, string yearmode)
        {
            //category = "N";//Breakup Year
            //category = "E";//Breakup Engg

            var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
            { Yymm = yymm, Category = category, YearMode = yearmode }, _uriBreakupData);

            return ConvertResponseMessageToIActionResult(returnResponse, "BreakupData.xlsx");
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, RapReportingHelper.ActionReportsEnggMngr)]
        public async Task<IActionResult> AnalyticalEngineeringBreakupEngg(string yymm, string category, string yearmode)//MOD Prefix "AnalyticalEngineering"
        {
            //category = "N";//Breakup Year
            //category = "E";//Breakup Engg

            var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
            { Yymm = yymm, Category = category, YearMode = yearmode }, _uriBreakupData);

            return ConvertResponseMessageToIActionResult(returnResponse, "BreakupData.xlsx");
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, RapReportingHelper.ActionReportsEnggMngr)]
        public async Task<IActionResult> Auditor_Subcontractor_wise_Engg(string yymm, string yearmode, string activeyear)
        {
            var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
            { Yymm = yymm, YearMode = yearmode }, _uriAuditor_Subcontractor_wise, activeyear);
            return ConvertResponseMessageToIActionResult(returnResponse, "JOB_PROJ_PH_LIST.xlsx");
        }

        #endregion Engineering

        #region Non-Engineering

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, RapReportingHelper.ActionReportsNonEnggMngr)]
        public async Task<IActionResult> AnalyticalNonEngineeringCHA1NonEngg(string yyyy, string yearmode, string yymm, string category, string ProcessId, string ProcessItemId)
        {
            try
            {
                if (ProcessId == "CHA1ExptNonEngg" || ProcessId == "CHA1ExptNonEnggMumbai" || ProcessId == "CHA1ExptNonEnggDelhi" ||
                    ProcessId == "CHA1ExptProcurement" || ProcessId == "CHA1ExptProcurementMumbai" || ProcessId == "CHA1ExptProcurementDelhi" ||
                    ProcessId == "CHA1ExptProco" || ProcessId == "CHA1ExptProcoMumbai" || ProcessId == "CHA1ExptProcoDelhi" || ProcessId == "CHA1ExptNonEnggC")
                {
                    string parameterJson;
                    var settings = new JsonSerializerSettings
                    {
                        NullValueHandling = NullValueHandling.Ignore
                    };

                    parameterJson = JsonConvert.SerializeObject(new HCModel
                    {
                        Yyyy = yyyy,
                        YearMode = yearmode,
                        Yyyymm = yymm,
                        Category = category
                    }, settings);

                    var result = await _processQueueRepository.AddProcessQueue(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PModuleId = ModuleId,
                            PProcessId = ProcessId,
                            PProcessItemId = ProcessItemId,
                            PProcessDesc = "RAP-REPORTING - " + ProcessId,
                            PParameterJson = parameterJson,
                            PMailTo = "",
                            PMailCc = ""
                        });

                    return Json(ResponseHelper.GetMessageObject(result.PMessageText, result.PMessageType == IsOk ? NotificationType.success : NotificationType.error));
                }
                else
                    return Json(ResponseHelper.GetMessageObject("Err - Process Id not matching.", NotificationType.error));
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, RapReportingHelper.ActionReportsNonEnggMngr)]
        public async Task<IActionResult> AnalyticalNonEngineeringCHA1NonEnggSim(string yyyy, string yearmode, string yymm, string category, string simul, string ProcessId, string ProcessItemId)
        {
            try
            {
                if (ProcessId == "CHA1ExptNonEnggS" || ProcessId == "CHA1ExptNonEnggMumbaiS" || ProcessId == "CHA1ExptNonEnggDelhiS")
                {
                    string parameterJson;
                    var settings = new JsonSerializerSettings
                    {
                        NullValueHandling = NullValueHandling.Ignore
                    };

                    parameterJson = JsonConvert.SerializeObject(new HCModel
                    {
                        Yyyy = yyyy,
                        YearMode = yearmode,
                        Yyyymm = yymm,
                        Category = category,
                        Simul = simul
                    }, settings);

                    var result = await _processQueueRepository.AddProcessQueue(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PModuleId = ModuleId,
                            PProcessId = ProcessId,
                            PProcessItemId = ProcessItemId,
                            PProcessDesc = "RAP-REPORTING - " + ProcessId,
                            PParameterJson = parameterJson,
                            PMailTo = "",
                            PMailCc = ""
                        });

                    return Json(ResponseHelper.GetMessageObject(result.PMessageText, result.PMessageType == IsOk ? NotificationType.success : NotificationType.error));
                }
                else
                    return Json(ResponseHelper.GetMessageObject("Err - Process Id not matching.", NotificationType.error));
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        #endregion Non-Engineering

        #region AFC

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, RapReportingHelper.ActionReportsAFC)]
        public async Task<IActionResult> AnalyticalAfcTMA(string yyyy, string yearmode, string yymm, string reportType, string ProcessId, string ProcessItemId)
        {
            try
            {
                if (ProcessId != "TMAAFCDetail")
                    return Json(ResponseHelper.GetMessageObject("Err - Process Id not matching.", NotificationType.error));

                string parameterJson;
                var settings = new JsonSerializerSettings
                {
                    NullValueHandling = NullValueHandling.Ignore
                };

                parameterJson = JsonConvert.SerializeObject(new HCModel
                {
                    Yyyy = yyyy,
                    YearMode = yearmode,
                    Yyyymm = yymm,
                    ReportType = reportType
                }, settings);

                var result = await _processQueueRepository.AddProcessQueue(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PModuleId = ModuleId,
                        PProcessId = "TMAAFCDetail",
                        PProcessItemId = ProcessItemId,
                        PProcessDesc = "RAP-REPORTING - TMAAFCDetail",
                        PParameterJson = parameterJson,
                        PMailTo = "",
                        PMailCc = ""
                    });

                return Json(ResponseHelper.GetMessageObject(result.PMessageText, result.PMessageType == IsOk ? NotificationType.success : NotificationType.error));

            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, RapReportingHelper.ActionReportsAFC)]
        public async Task<IActionResult> AnalyticalAfcTMASummary(string yyyy, string yearmode, string yymm, string reportType, string ProcessId, string ProcessItemId)
        {
            try
            {
                if (ProcessId != "TMAAFCSummary")
                    return Json(ResponseHelper.GetMessageObject("Err - Process Id not matching.", NotificationType.error));

                string parameterJson;
                var settings = new JsonSerializerSettings
                {
                    NullValueHandling = NullValueHandling.Ignore
                };

                parameterJson = JsonConvert.SerializeObject(new HCModel
                {
                    Yyyy = yyyy,
                    YearMode = yearmode,
                    Yyyymm = yymm,
                    ReportType = reportType
                }, settings);

                var result = await _processQueueRepository.AddProcessQueue(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PModuleId = ModuleId,
                        PProcessId = "TMAAFCSummary",
                        PProcessItemId = ProcessItemId,
                        PProcessDesc = "RAP-REPORTING - TMAAFCSummary",
                        PParameterJson = parameterJson,
                        PMailTo = "",
                        PMailCc = ""
                    });

                return Json(ResponseHelper.GetMessageObject(result.PMessageText, result.PMessageType == IsOk ? NotificationType.success : NotificationType.error));

            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        #endregion AFC

        public async Task<IActionResult> Cha1Sta6Tm02BulkReport()
        {
            BulkReport bulkReport = new BulkReport();

            try
            {
                var bulkReportDetail = await _rapReportingReportsRepository.BulkReportDetailAsync("CHA1STA6TM02", "2020-21", "202004", "A", "sanjay");

                bulkReport.Reportid = bulkReportDetail.Reportid;
                bulkReport.Yyyy = bulkReportDetail.Yyyy;
                bulkReport.Yymm = bulkReportDetail.Yymm;
                bulkReport.Yearmode = bulkReportDetail.Yearmode;
                bulkReport.SDate = bulkReportDetail.SDate;
                bulkReport.Filename = bulkReportDetail.Filename;
                bulkReport.Status = bulkReportDetail.Status;
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
            }

            return PartialView("_ModalBulkReportPartial", bulkReport);
        }

        #endregion >>>>> analytical reports

        #region >>>>> management reports

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, RapReportingHelper.ActionReportsTopMgmt)]
        public async Task<IActionResult> ManagementTMA(string yyyy, string yearmode, string yymm, string reportType, string ProcessId, string ProcessItemId)
        {
            try
            {
                if (ProcessId != "TMAMngtDetail")
                    return Json(ResponseHelper.GetMessageObject("Err - Process Id not matching.", NotificationType.error));

                string parameterJson;
                var settings = new JsonSerializerSettings
                {
                    NullValueHandling = NullValueHandling.Ignore
                };

                parameterJson = JsonConvert.SerializeObject(new HCModel
                {
                    Yyyy = yyyy,
                    YearMode = yearmode,
                    Yyyymm = yymm,
                    ReportType = reportType
                }, settings);

                var result = await _processQueueRepository.AddProcessQueue(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PModuleId = ModuleId,
                        PProcessId = "TMAMngtDetail",
                        PProcessItemId = ProcessItemId,
                        PProcessDesc = "RAP-REPORTING - TMAMngtDetail",
                        PParameterJson = parameterJson,
                        PMailTo = "",
                        PMailCc = ""
                    });

                return Json(ResponseHelper.GetMessageObject(result.PMessageText, result.PMessageType == IsOk ? NotificationType.success : NotificationType.error));

            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, RapReportingHelper.ActionReportsTopMgmt)]
        public async Task<IActionResult> ManagementTMASummary(string yyyy, string yearmode, string yymm, string reportType, string ProcessId, string ProcessItemId)
        {
            try
            {
                if (ProcessId != "TMAMngtSummary")
                    return Json(ResponseHelper.GetMessageObject("Err - Process Id not matching.", NotificationType.error));

                string parameterJson;
                var settings = new JsonSerializerSettings
                {
                    NullValueHandling = NullValueHandling.Ignore
                };

                parameterJson = JsonConvert.SerializeObject(new HCModel
                {
                    Yyyy = yyyy,
                    YearMode = yearmode,
                    Yyyymm = yymm,
                    ReportType = reportType
                }, settings);

                var result = await _processQueueRepository.AddProcessQueue(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PModuleId = ModuleId,
                        PProcessId = "TMAMngtSummary",
                        PProcessItemId = ProcessItemId,
                        PProcessDesc = "RAP-REPORTING - TMAMngtSummary",
                        PParameterJson = parameterJson,
                        PMailTo = "",
                        PMailCc = ""
                    });

                return Json(ResponseHelper.GetMessageObject(result.PMessageText, result.PMessageType == IsOk ? NotificationType.success : NotificationType.error));

            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, RapReportingHelper.ActionReportsTopMgmt)]
        public async Task<IActionResult> ManagementCHA1Engg(string yyyy, string yearmode, string yymm, string category, string ProcessId, string ProcessItemId)
        {
            try
            {
                if (ProcessId == "CHA1ExptEnggNonEngg" || ProcessId == "CHA1ExptEnggNonEnggMumbai" || ProcessId == "CHA1ExptEnggNonEnggDelhi" || ProcessId == "CHA1ExptEnggNonEnggC")
                { 
                    string parameterJson;
                    var settings = new JsonSerializerSettings
                    {
                        NullValueHandling = NullValueHandling.Ignore
                    };

                    parameterJson = JsonConvert.SerializeObject(new HCModel
                    {
                        Yyyy = yyyy,
                        YearMode = yearmode,
                        Yyyymm = yymm,
                        Category = category
                    }, settings);

                    var result = await _processQueueRepository.AddProcessQueue(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PModuleId = ModuleId,
                            PProcessId = ProcessId,
                            PProcessItemId = ProcessItemId,
                            PProcessDesc = "RAP-REPORTING - " + ProcessId,
                            PParameterJson = parameterJson,
                            PMailTo = "",
                            PMailCc = ""
                        });

                    return Json(ResponseHelper.GetMessageObject(result.PMessageText, result.PMessageType == IsOk ? NotificationType.success : NotificationType.error));
                }
                else
                    return Json(ResponseHelper.GetMessageObject("Err - Process Id not matching.", NotificationType.error));
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, RapReportingHelper.ActionReportsTopMgmt)]
        public async Task<IActionResult> ManagementCHA1EnggSim(string yyyy, string yearmode, string yymm, string category, string simul, string ProcessId, string ProcessItemId)
        {
            try
            {
                if (ProcessId == "CHA1ExptEnggNonEnggS" || ProcessId == "CHA1ExptEnggNonEnggMumbaiS" || ProcessId == "CHA1ExptEnggNonEnggDelhiS")
                {                    
                    string parameterJson;
                    var settings = new JsonSerializerSettings
                    {
                        NullValueHandling = NullValueHandling.Ignore
                    };

                    parameterJson = JsonConvert.SerializeObject(new HCModel
                    {
                        Yyyy = yyyy,
                        YearMode = yearmode,
                        Yyyymm = yymm,
                        Category = category,
                        Simul = simul
                    }, settings);

                    var result = await _processQueueRepository.AddProcessQueue(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PModuleId = ModuleId,
                            PProcessId = ProcessId,
                            PProcessItemId = ProcessItemId,
                            PProcessDesc = "RAP-REPORTING - " + ProcessId,
                            PParameterJson = parameterJson,
                            PMailTo = "",
                            PMailCc = ""
                        });

                    return Json(ResponseHelper.GetMessageObject(result.PMessageText, result.PMessageType == IsOk ? NotificationType.success : NotificationType.error));
                }
                else
                    return Json(ResponseHelper.GetMessageObject("Err - Process Id not matching.", NotificationType.error));
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, RapReportingHelper.ActionReportsTopMgmt)]
        public async Task<IActionResult> ManagementBreakupAll(string yymm, string category, string yearmode)//MOD Prefix "Management"
        {
            //category = "N";//Breakup Year
            //category = "E";//Breakup Engg

            var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
            { Yymm = yymm, Category = category, YearMode = yearmode }, _uriBreakupData);

            return ConvertResponseMessageToIActionResult(returnResponse, "BreakupData.xlsx");
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, RapReportingHelper.ActionReportsTopMgmt)]
        public async Task<IActionResult> ManagementBreakupPeriod(string yymm, string category, string yearmode) //MOD Prefix "Management"
        {
            //category = "N";//Breakup Year
            //category = "E";//Breakup Engg

            var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
            { Yymm = yymm, Category = category, YearMode = yearmode }, _uriBreakupData);

            return ConvertResponseMessageToIActionResult(returnResponse, "BreakupData.xlsx");
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, RapReportingHelper.ActionReportsTopMgmt)]
        public async Task<IActionResult> ManagementPlantEngg(string yymm)
        {
            var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
            { Yymm = yymm }, _uriPlantEngg);

            return ConvertResponseMessageToIActionResult(returnResponse, "PlantEnggData.xlsm");
        }

        #endregion >>>>> management reports

        #region >>>>> process reports

        //process reports

        #endregion >>>>> process reports

        public async Task<IActionResult> ReportProcessStatus(string reportid, string user, string yyyy, string yymm, string yearmode)
        {
            var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
            { Reportid = reportid, User = user, Yyyy = yyyy, Yymm = yymm, YearMode = yearmode }, _uriReportProcessStatus);
            return (IActionResult)returnResponse;
        }

        #region Simple

        #region AfterPostAFCC

        public async Task<IActionResult> AfterPostAFCAuditor(string yymm)
        {
            var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
            { Yymm = yymm }, _uriAfterPostAFCAuditor);
            return ConvertResponseMessageToIActionResult(returnResponse, "AfterPostAFCAuditor.xlsx");
        }

        #endregion AfterPostAFCC

        #region AfterPostCC

        public async Task<IActionResult> CostCentre_Combine(string costcode)
        {
            var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
            { CostCode = costcode }, _uriCostCentre_Combine);
            return ConvertResponseMessageToIActionResult(returnResponse, "CostCentre_Combine.xlsx");
        }

        public async Task<IActionResult> CostCentre_CostOT_Combine(string costcode)
        {
            var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
            { CostCode = costcode }, _uriCostCentre_CostOT_Combine);
            return ConvertResponseMessageToIActionResult(returnResponse, "CostCentre_CostOT_Combine.xlsx");
        }

        #endregion AfterPostCC

        #region AfterPostHR

        public async Task<IActionResult> RunExeFile()
        {
            var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
            { }, _uriRunExeFile);
            return ConvertResponseMessageToIActionResult(returnResponse, "RunExeFile.xlsx");
        }

        #endregion AfterPostHR

        #region Proco

        public async Task<IActionResult> DATEWISE_TS(string projno, string yymm)
        {
            var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
            { Projno = projno, Yymm = yymm }, _uriDATEWISE_TS);
            return ConvertResponseMessageToIActionResult(returnResponse, "DATEWISE_TS.xlsx");
        }

        public async Task<IActionResult> TS_ACT_COVID(string yymm)
        {
            var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
            { Yymm = yymm }, _uriTS_ACT_COVID);
            return ConvertResponseMessageToIActionResult(returnResponse, "TS_ACT_COVID.xlsx");
        }

        public async Task<IActionResult> Empl_mhrs_not_posted(string yymm)
        {
            var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
            { Yymm = yymm }, _uriEmpl_mhrs_not_posted);
            return ConvertResponseMessageToIActionResult(returnResponse, "Empl_mhrs_not_posted.xlsx");
        }

        #endregion Proco

        #region UnPivot

        //public async Task<IActionResult> Process(string yymm, string repfor)
        //{
        //    var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
        //    { Yymm = yymm, RepFor = repfor }, _uriProcessData);
        //    return ConvertResponseMessageToIActionResult(returnResponse, "ProcessData.xlsx");
        //}

        //public async Task<IActionResult> GetProcessStatus(string yymm, string repfor)
        //{
        //    var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
        //    { Yymm = yymm, RepFor = repfor }, _uriGetProcessStatus);
        //    return ConvertResponseMessageToIActionResult(returnResponse, "GetProcessStatus.xlsx");
        //}

        #endregion UnPivot

        #endregion Simple

        #region Complex - CC

        public async Task<IActionResult> Cha1Costcodes()
        {
            var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
            { }, _uriCha1Costcodes);
            return ConvertResponseMessageToIActionResult(returnResponse, "Cha1Costcodes.xlsx");
        }

        public async Task<IActionResult> UpdateCha1Process(string keyid, string user, string yyyy, string yymm, string yearmode)
        {
            var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
            { Keyid = keyid, User = user, Yyyy = yyyy, Yymm = yymm, YearMode = yearmode }, _uriUpdateCha1Process);
            return ConvertResponseMessageToIActionResult(returnResponse, "UpdateCha1Process.xlsx");
        }

        public async Task<IActionResult> RptCostcodes()
        {
            var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
            { }, _uriRptCostcodes);
            return ConvertResponseMessageToIActionResult(returnResponse, "RptCostcodes.xlsx");
        }

        public async Task<IActionResult> UpdateRptProcess(string keyid, string user, string yyyy, string yymm, string yearmode, string reportid, string runmode)
        {
            var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
            { Keyid = keyid, User = user, Yyyy = yyyy, Yymm = yymm, YearMode = yearmode, Reportid = reportid, Runmode = runmode }, _uriUpdateRptProcess);
            return ConvertResponseMessageToIActionResult(returnResponse, "UpdateRptProcess.xlsx");
        }

        public async Task<IActionResult> RptMailDetails(string keyid, string status)
        {
            var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
            { Keyid = keyid, Status = status }, _uriRptMailDetails);
            return ConvertResponseMessageToIActionResult(returnResponse, "RptMailDetails.xlsx");
        }

        public async Task<IActionResult> RptProcesslist(string user, string yyyy, string yymm, string yearmode, string reportid)
        {
            var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
            { User = user, Yyyy = yyyy, Yymm = yymm, YearMode = yearmode, Reportid = reportid }, _uriRptProcesslist);
            return ConvertResponseMessageToIActionResult(returnResponse, "RptProcesslist.xlsx");
        }

        #endregion Complex - CC

        #region CMPLX - MGMT

        public async Task<IActionResult> CHA1NonEngg(string costcode, string yymm, string yearmode)
        {
            var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
            { CostCode = costcode, Yymm = yymm, YearMode = yearmode }, _uriCHA1NonEngg);

            return ConvertResponseMessageToIActionResult(returnResponse, "CHA1NonEngg.xlsx");
        }

        public async Task<IActionResult> CHA1Mgmt(string costcode, string yymm, string yearmode)
        {
            var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
            { CostCode = costcode, Yymm = yymm, YearMode = yearmode }, _uriCHA1Mgmt);

            return ConvertResponseMessageToIActionResult(returnResponse, "CHA1Mgmt.xlsx");
        }

        #endregion CMPLX - MGMT

        public async Task<IActionResult> DownloadZip(string keyid)
        {
            string fileName = string.Empty;

            var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
            { Keyid = keyid.Trim() }, _uriDownloadFile);

            //MemoryStream ms = (MemoryStream)returnResponse.Content.ReadAsStreamAsync().Result;
            byte[] m_Bytes;
            ////using (MemoryStream ms = new MemoryStream(returnResponse.Content.ReadAsStreamAsync().Result))
            ////{
            // //using (FileStream file = new FileStream() //{ //m_Bytes = new byte[file.Length];
            // //file.Read(m_Bytes, 0, (int)file.Length); //ms.Write(m_Bytes, 0, (int)file.Length);
            // //} m_Bytes = ms.ToArray();
            ////}

            const string mimeType = "application/zip; charset=UTF-8";
            //HttpContext.Response.ContentType = contentType;
            //var result = new FileContentResult(System.IO.File.ReadAllBytes(@"{path_to_files}\file.zip"), contentType)
            //{
            //    FileDownloadName = $"{filename}.zip"
            //};

            //return result;

            //var content = await returnResponse.Content.ReadAsStringAsync();
            //JObject data = JObject.Parse(content);

            ////using (MemoryStream ms = (MemoryStream)returnResponse.Content.ReadAsStreamAsync().Result)
            ////{
            ////m_Bytes = ms.ToArray();
            //if (returnResponse.IsSuccessStatusCode)
            //    {
            //    //return ConvertResponseMessageToIActionResult(returnResponse, keyid.Trim() + ".zip");
            //    //return File(content, "application/octet-stream", keyid.Trim() + ".zip");
            //}
            //    else
            //    {
            //        return StatusCode((int)HttpStatusCode.InternalServerError, "Internal server error");
            //    }
            ////}

            //byte[] fileBytes = await GetFileBytesById(id);

            m_Bytes = returnResponse.Content.ReadAsByteArrayAsync().Result;
            //string result = null;
            //result = returnResponse.Content.ReadAsStringAsync().Result.Replace("\"", string.Empty);
            //m_Bytes = Convert.FromBase64String(result);

            if (returnResponse.IsSuccessStatusCode)
            {
                //returnResponse.Content.Headers.ContentType = mimeType;

                //return File(m_Bytes, mimeType, keyid.Trim() + ".zip");
                var result = new FileContentResult(m_Bytes, mimeType)
                {
                    FileDownloadName = keyid.Trim() + ".zip"
                };
                return result;
            }
            else
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, "Internal server error");
            }

            //string fname = keyid.Trim() + ".zip";
            //string appPath = @"C:\RAPRepository";
            //string path = Path.Combine(appPath.ToString(), "Download", fname);

            //var t = Task.Run(() =>
            //{
            //    var result = new FileContentResult(System.IO.File.ReadAllBytes(@path), "application/zip")
            //    {
            //        FileDownloadName = fname
            //    };

            //    return result;
            //});

            //return await t;
        }

        public async Task<IActionResult> DiscardZip(string keyid, string user)
        {
            var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
            { Keyid = keyid.Trim(), User = user.Trim() }, _uriDiscardFile);

            return Ok();
        }

        public async Task<IActionResult> DownloadFileZip(string processid, string processitemid)
        {
            string fileName = string.Empty;

            var result = await _processQueueDataTableListRepository.ProcessQueueDataTableList(
                                    BaseSpTcmPLGet(),
                                    new ParameterSpTcmPL
                                    {
                                        PProcessId = processid,
                                        PProcessItemId = processitemid
                                    });

            var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
            { Keyid = result.FirstOrDefault().KeyId.Trim() }, _uriDownloadFile);

            byte[] m_Bytes;

            const string mimeType = "application/zip; charset=UTF-8";

            m_Bytes = returnResponse.Content.ReadAsByteArrayAsync().Result;

            if (returnResponse.IsSuccessStatusCode)
            {
                var file = new FileContentResult(m_Bytes, mimeType)
                {
                    FileDownloadName = result.FirstOrDefault().KeyId.Trim() + ".zip"
                };

                return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
            }
            else
            {
                return Json(ResponseHelper.GetMessageObject("Internal server error.", NotificationType.error));
            }
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, RapReportingHelper.ActionReportsProjectManager)]
        public async Task<IActionResult> TM11_closed_jobs()
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

            if ((CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == RapReportingHelper.ActionProcoTrans))
               || (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == RapReportingHelper.ActionProcoProcess))
               || (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == RapReportingHelper.ActionReportsProco))
               || (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == RapReportingHelper.ActionReportsEnggMngr)))
            {
                var projnos = await _selectTcmPLRepository.SelectProjnoClosedRapReportingProco(BaseSpTcmPLGet(), null);
                ViewData["Projnos"] = new SelectList(projnos, "DataValueField", "DataTextField", filterDataModel.ClosedProjno);
            }
            else
            {
                var projnos = await _selectTcmPLRepository.SelectProjnoClosedRapReporting(BaseSpTcmPLGet(), null);
                ViewData["Projnos"] = new SelectList(projnos, "DataValueField", "DataTextField", filterDataModel.ClosedProjno);            
            }
                       

            return PartialView("_ModalAnalyticalProjectTM11Partial", filterDataModel);
        }

        #region Process queue

        [HttpGet]
        public async Task<JsonResult> GetProcessQueueList()
        {
            try
            {
                var result = await _processQueueDataTableListRepository.ProcessQueueDataTableList(
                                    BaseSpTcmPLGet(),
                                    new ParameterSpTcmPL
                                    {
                                        
                                    });
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

        #endregion Process queue

        #region ViewProcessLogs

        [HttpGet]
        public async Task<IActionResult> ViewProcessLogs(string processid, string processitemid)
        {
            ReportProcessingViewModel reportProcessingViewModel = new();

            var ProcessKeyId = await _processQueueDataTableListRepository.ProcessQueueDataTableList(
                                    BaseSpTcmPLGet(),
                                    new ParameterSpTcmPL
                                    {
                                        PProcessId = processid,
                                        PProcessItemId = processitemid
                                    });

            reportProcessingViewModel.KeyId = ProcessKeyId.FirstOrDefault().KeyId;

            return PartialView("_ModalProcessLogsViewPartial", reportProcessingViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsProcessLog(string paramJson)
        {
            DTResult<ProcessingDataDataTableList> result = new();
            DTParameters param = JsonConvert.DeserializeObject<DTParameters>(paramJson);

            try
            {
                System.Collections.Generic.IEnumerable<ProcessingDataDataTableList> data = 
                                                await _processLogDataTableListRepository.ProcessLogDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PKeyId = param.Id
                    }
                );   

                result.draw = param.Draw;
                result.data = data.ToList();

                return Json(result);
            }
            catch (Exception ex)
            {
                return Json(new { error = ex.Message });
            }
        }
        #endregion ViewProcessLogs
    }
}