using ClosedXML.Excel;
using DocumentFormat.OpenXml.Packaging;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.Extensions.Configuration;
using MimeTypes;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.Common;
using TCMPLApp.DataAccess.Repositories.RapReporting;
using TCMPLApp.DataAccess.Repositories.SWPVaccine;
using TCMPLApp.Domain.Models.Common;
using TCMPLApp.Domain.Models.RapReporting;
using TCMPLApp.Library.Excel.Template;
using TCMPLApp.Library.Excel.Template.Models;
using TCMPLApp.Library.Excel.Writer;
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
    public class TransactionsController : BaseController
    {
        private const string ConstFilterRapIndex = "RapCommonIndex";
        private const string ConstFilterExpectedJobsIndex = "ExpectedJobsIndex";
        private const string ConstFilterOscSesIndex = "OscSesIndex";
        private const string ConstFilterOscMasterIndex = "OscMasterIndex";
        private const string ConstFilterOscDetailIndex = "OscDetailIndex";
        private const string ConstFilterOscHoursIndex = "OscHoursIndex";
        private const string ConstFilterOscActualHoursBookedIndex = "OscActualHoursBookedIndex";
        private const string ConstFilterActivityMasterIndex = "ActivityMasterIndex";
        private const string Schemaname = "TIMECURR";

        private readonly IFilterRepository _filterRepository;
        private readonly ISelectTcmPLRepository _selectTcmPLRepository;
        private readonly IConfiguration _configuration;
        private readonly IHttpClientRapReporting _httpClientRapReporting;
        private readonly IRapReportingRepository _rapReportingRepository;
        private readonly IExpectedJobsDataTableListRepository _expectedJobsDataTableListRepository;
        private readonly IExpectedJobsDetailsRepository _expectedJobsDetailsRepository;
        private readonly IExpectedJobsRepository _expectedJobsRepository;
        private readonly ISelectRepository _selectRepository;
        private readonly IExcelTemplate _excelTemplate;
        private readonly IManhoursProjectionsCurrentJobsImportRepository _manhoursProjectionsCurrentJobsImportRepository;
        private readonly IManhoursProjectionsExpectedJobsImportRepository _manhoursProjectionsExpectedJobsImportRepository;
        private readonly IProjmastDetailRepository _projmastDetailRepository;
        private readonly IManhoursProjectionsCurrentJobsCanCreateRepository _manhoursProjectionsCurrentJobsCanCreateRepository;
        private readonly IOvertimeUpdateImportRepository _overtimeUpdateImportRepository;
        private readonly IManageRepository _manageRepository;
        private readonly IUtilityRepository _utilityRepository;

        private readonly IOscSesRepository _oscSesRepository;
        private readonly IOscSesDataTableListRepository _oscSesDataTableListRepository;
        private readonly IOscSesDetailRepository _oscSesDetailRepository;
        private readonly IOscMasterRepository _oscMasterRepository;
        private readonly IOscMasterDataTableListRepository _oscMasterDataTableListRepository;
        private readonly IOscMasterDetailRepository _oscMasterDetailRepository;
        private readonly IOscDetailRepository _oscDetailRepository;
        private readonly IOscDetailDataTableListRepository _oscDetailDataTableListRepository;
        private readonly IOscDetailDetailRepository _oscDetailDetailRepository;
        private readonly IOscHoursRepository _oscHoursRepository;
        private readonly IOscHoursDataTableListRepository _oscHoursDataTableListRepository;
        private readonly IOscHoursDetailRepository _oscHoursDetailRepository;
        private readonly IOscActualHoursBookedDataTableListRepository _oscActualHoursBookedDataTableListRepository;
        private readonly IMovemastImportRepository _movemastImportRepository;
        private readonly ITSPostedHoursDataTableListRepository _tSPostedHoursDataTableListRepository;
        private readonly ITSRepostingDetailsRepository _tSRepostingDetailsRepository;
        private readonly ITSPostedHoursTotalRepository _tSPostedHoursTotalRepository;
        private readonly ITSShiftProjectManhoursDataTableListRepository _tSShiftProjectManhoursDataTableListRepository;
        private readonly ITSShiftProjectManhoursRepository _tSShiftProjectManhoursRepository;
        private readonly ITSShiftProjectManhoursReportRepository _tSShiftProjectManhoursReportRepository;
        private readonly IActivityMasterDataTableListRepository _activityMasterDataTableListRepository;
        private readonly IActivityMasterRepository _activityMasterRepository;
        private readonly IActivityDetailRepository _activityDetailRepository;
        private readonly IProjactMasterDataTableListRepository _projactMasterDataTableListRepository;
        private readonly IProjactMasterRepository _projactMasterRepository;
        private readonly IProjactDetailRepository _projactDetailRepository;
        private readonly IRapHoursDataTableListRepository _rapHoursDataTableListRepository;
        private readonly IRapHoursRepository _rapHoursRepository;
        private readonly IRapHoursDetailRepository _rapHoursDetailRepository;
        private readonly IWrkHoursDataTableListRepository _wrkHoursDataTableListRepository;
        private readonly IWrkHoursRepository _wrkHoursRepository;
        private readonly IWrkHoursDetailRepository _wrkHoursDetailRepository;
        private readonly ITLPDataTableListRepository _tLPDataTableListRepository;
        private readonly ITLPRepository _tLPRepository;
        private readonly ITLPDetailRepository _tLPDetailRepository;
        private readonly ITsConfigDataTableListRepository _tsConfigDataTableListRepository;
        private readonly IOvertimeUpdateDataTableListRepository _overtimeUpdateDataTableListRepository;
        private readonly IProcessingMonthDetailRepository _processingMonthDetailRepository;
        private readonly IOvertimeUpdateRepository _overtimeUpdateRepository;
        private readonly IOvertimeUpdateDetailRepository _overtimeUpdateDetailRepository;
        private readonly IMovemastDataTableListRepository _movemastDataTableListRepository;
        private readonly IMovemastDetailRepository _movemastDetailRepository;
        private readonly IMovemastRepository _movemastRepository;
        private readonly IExptJobsDataTableListRepository _exptJobsDataTableListRepository;
        private readonly IExptPrjcDetailRepository _exptPrjcDetailRepository;
        private readonly IExptPrjcDataTableListRepository _exptPrjcDataTableListRepository;
        private readonly IExptPrjcRepository _exptPrjcRepository;
        private readonly IManhoursPrjcMasterDataTableListRepository _manhoursPrjcMasterDataTableListRepository;
        private readonly IManhoursPrjcJobDetailsDataTableListRepository _manhoursPrjcJobDetailsDataTableListRepository;
        private readonly IManhoursProjectionsCurrentJobsProjectRepository _manhoursProjectionsCurrentJobsProjectRepository;
        private readonly IManhoursPrjcJobDetailsForExcelDataTableListRepository _manhoursPrjcJobDetailsForExcelDataTableListRepository;
        private readonly IMovemastForExcelTemplateDataTableListRepository _movemastForExcelTemplateDataTableListRepository;
        private readonly INoOfEmployeeDetailRepository _noOfEmployeeDetailRepository;
        private readonly INoOfEmployeeRepository _noOfEmployeeRepository;

        public TransactionsController(IConfiguration configuration,
                                      IFilterRepository filterRepository,
                                      ISelectTcmPLRepository selectTcmPLRepository,
                                      IHttpClientRapReporting httpClientRapReporting,
                                      IRapReportingRepository rapReportingRepository,
                                      IExpectedJobsDataTableListRepository expectedJobsDataTableListRepository,
                                      IExpectedJobsDetailsRepository expectedJobsDetailsRepository,
                                      IExpectedJobsRepository expectedJobsRepository,
                                      ISelectRepository selectRepository,
                                      IExcelTemplate excelTemplate,
                                      IManhoursProjectionsCurrentJobsImportRepository manhoursProjectionsCurrentJobsImportRepository,
                                      IManhoursProjectionsExpectedJobsImportRepository manhoursProjectionsExpectedJobsImportRepository,
                                      IProjmastDetailRepository projmastDetailRepository,
                                      IManhoursProjectionsCurrentJobsCanCreateRepository manhoursProjectionsCurrentJobsCanCreateRepository,
                                      IOvertimeUpdateImportRepository overtimeUpdateImportRepository,
                                      IManageRepository manageRepository,
                                      IUtilityRepository utilityRepository,
                                      IOscSesRepository oscSesRepository,
                                      IOscSesDataTableListRepository oscSesDataTableListRepository,
                                      IOscSesDetailRepository oscSesDetailRepository,
                                      IOscMasterRepository oscMasterRepository,
                                      IOscMasterDataTableListRepository oscMasterDataTableListRepository,
                                      IOscMasterDetailRepository oscMasterDetailRepository,
                                      IOscDetailDataTableListRepository oscDetailDataTableListRepository,
                                      IOscDetailDetailRepository oscDetailDetailRepository,
                                      IOscHoursRepository oscHoursRepository,
                                      IOscHoursDataTableListRepository oscHoursDataTableListRepository,
                                      IOscHoursDetailRepository oscHoursDetailRepository,
                                      IOscDetailRepository oscDetailRepository,
                                      IOscActualHoursBookedDataTableListRepository oscActualHoursBookedDataTableListRepository,
                                      IMovemastImportRepository movemastImportRepository,
                                      ITSPostedHoursDataTableListRepository tSPostedHoursDataTableListRepository,
                                      ITSRepostingDetailsRepository tSRepostingDetailsRepository,
                                      ITSPostedHoursTotalRepository tSPostedHoursTotalRepository,
                                      ITSShiftProjectManhoursDataTableListRepository tSShiftProjectManhoursDataTableListRepository,
                                      ITSShiftProjectManhoursRepository tSShiftProjectManhoursRepository,
                                      ITSShiftProjectManhoursReportRepository tSShiftProjectManhoursReportRepository,
                                      IActivityMasterDataTableListRepository activityMasterDataTableListRepository,
                                      IActivityMasterRepository activityMasterRepository,
                                      IActivityDetailRepository activityDetailRepository,
                                      IProjactMasterDataTableListRepository projactMasterDataTableListRepository,
                                      IProjactMasterRepository projactMasterRepository,
                                      IProjactDetailRepository projactDetailRepository,
                                      IRapHoursDataTableListRepository rapHoursDataTableListRepository,
                                      IRapHoursRepository rapHoursRepository,
                                      IRapHoursDetailRepository rapHoursDetailRepository,
                                      IWrkHoursDataTableListRepository wrkHoursDataTableListRepository,
                                      IWrkHoursRepository wrkHoursRepository,
                                      IWrkHoursDetailRepository wrkHoursDetailRepository,
                                      ITLPDataTableListRepository tLPDataTableListRepository,
                                      ITLPRepository tLPRepository,
                                      ITLPDetailRepository tLPDetailRepository,
                                      ITsConfigDataTableListRepository tsConfigDataTableListRepository,
                                      IOvertimeUpdateDataTableListRepository overtimeUpdateDataTableListRepository,
                                      IProcessingMonthDetailRepository processingMonthDetailRepository,
                                      IOvertimeUpdateRepository overtimeUpdateRepository,
                                      IOvertimeUpdateDetailRepository overtimeUpdateDetailRepository,
                                      IMovemastDataTableListRepository movemastDataTableListRepository,
                                      IMovemastDetailRepository movemastDetailRepository,
                                      IMovemastRepository movemastRepository,
                                      IExptJobsDataTableListRepository exptJobsDataTableListRepository,
                                      IExptPrjcDetailRepository exptPrjcDetailRepository,
                                      IExptPrjcDataTableListRepository exptPrjcDataTableListRepository,
                                      IExptPrjcRepository exptPrjcRepository,
                                      //IOvertimeUpdateDetailRepository overtimeUpdateDetailRepository,
                                      IManhoursPrjcMasterDataTableListRepository manhoursPrjcMasterDataTableListRepository,
                                      IManhoursPrjcJobDetailsDataTableListRepository manhoursPrjcJobDetailsDataTableListRepository,
                                      IManhoursProjectionsCurrentJobsProjectRepository manhoursProjectionsCurrentJobsProjectRepository,
                                      IManhoursPrjcJobDetailsForExcelDataTableListRepository manhoursPrjcJobDetailsForExcelDataTableListRepository,
                                      IMovemastForExcelTemplateDataTableListRepository movemastForExcelTemplateDataTableListRepository,
                                      INoOfEmployeeDetailRepository noOfEmployeeDetailRepository,
                                      INoOfEmployeeRepository noOfEmployeeRepository)
        {
            _configuration = configuration;
            _filterRepository = filterRepository;
            _selectTcmPLRepository = selectTcmPLRepository;
            _httpClientRapReporting = httpClientRapReporting;
            _rapReportingRepository = rapReportingRepository;
            _expectedJobsDataTableListRepository = expectedJobsDataTableListRepository;
            _expectedJobsDetailsRepository = expectedJobsDetailsRepository;
            _expectedJobsRepository = expectedJobsRepository;
            _selectRepository = selectRepository;
            _excelTemplate = excelTemplate;
            _manhoursProjectionsCurrentJobsImportRepository = manhoursProjectionsCurrentJobsImportRepository;
            _manhoursProjectionsExpectedJobsImportRepository = manhoursProjectionsExpectedJobsImportRepository;
            _projmastDetailRepository = projmastDetailRepository;
            _manhoursProjectionsCurrentJobsCanCreateRepository = manhoursProjectionsCurrentJobsCanCreateRepository;
            _overtimeUpdateImportRepository = overtimeUpdateImportRepository;
            _manageRepository = manageRepository;
            _utilityRepository = utilityRepository;

            _oscSesRepository = oscSesRepository;
            _oscSesDataTableListRepository = oscSesDataTableListRepository;
            _oscSesDetailRepository = oscSesDetailRepository;
            _oscMasterRepository = oscMasterRepository;
            _oscMasterDataTableListRepository = oscMasterDataTableListRepository;
            _oscMasterDetailRepository = oscMasterDetailRepository;
            _oscDetailDataTableListRepository = oscDetailDataTableListRepository;
            _oscDetailDetailRepository = oscDetailDetailRepository;
            _oscHoursRepository = oscHoursRepository;
            _oscHoursDataTableListRepository = oscHoursDataTableListRepository;
            _oscHoursDetailRepository = oscHoursDetailRepository;
            _oscDetailRepository = oscDetailRepository;
            _oscActualHoursBookedDataTableListRepository = oscActualHoursBookedDataTableListRepository;
            _movemastImportRepository = movemastImportRepository;
            _tSPostedHoursDataTableListRepository = tSPostedHoursDataTableListRepository;
            _tSRepostingDetailsRepository = tSRepostingDetailsRepository;
            _tSPostedHoursTotalRepository = tSPostedHoursTotalRepository;
            _tSShiftProjectManhoursDataTableListRepository = tSShiftProjectManhoursDataTableListRepository;
            _tSShiftProjectManhoursRepository = tSShiftProjectManhoursRepository;
            _tSShiftProjectManhoursReportRepository = tSShiftProjectManhoursReportRepository;
            _activityMasterDataTableListRepository = activityMasterDataTableListRepository;
            _activityMasterRepository = activityMasterRepository;
            _activityDetailRepository = activityDetailRepository;
            _projactMasterDataTableListRepository = projactMasterDataTableListRepository;
            _projactMasterRepository = projactMasterRepository;
            _projactDetailRepository = projactDetailRepository;
            _rapHoursDataTableListRepository = rapHoursDataTableListRepository;
            _rapHoursRepository = rapHoursRepository;
            _rapHoursDetailRepository = rapHoursDetailRepository;
            _wrkHoursDataTableListRepository = wrkHoursDataTableListRepository;
            _wrkHoursRepository = wrkHoursRepository;
            _wrkHoursDetailRepository = wrkHoursDetailRepository;
            _tLPDataTableListRepository = tLPDataTableListRepository;
            _tLPRepository = tLPRepository;
            _tLPDetailRepository = tLPDetailRepository;
            _tsConfigDataTableListRepository = tsConfigDataTableListRepository;
            _overtimeUpdateDataTableListRepository = overtimeUpdateDataTableListRepository;
            _processingMonthDetailRepository = processingMonthDetailRepository;
            _overtimeUpdateRepository = overtimeUpdateRepository;
            _overtimeUpdateDetailRepository = overtimeUpdateDetailRepository;
            _movemastDataTableListRepository = movemastDataTableListRepository;
            _movemastDetailRepository = movemastDetailRepository;
            _movemastRepository = movemastRepository;
            _exptJobsDataTableListRepository = exptJobsDataTableListRepository;
            _exptPrjcDetailRepository = exptPrjcDetailRepository;
            _exptPrjcDataTableListRepository = exptPrjcDataTableListRepository;
            _exptPrjcRepository = exptPrjcRepository;
            _manhoursPrjcMasterDataTableListRepository = manhoursPrjcMasterDataTableListRepository;
            _manhoursPrjcJobDetailsDataTableListRepository = manhoursPrjcJobDetailsDataTableListRepository;
            _manhoursProjectionsCurrentJobsProjectRepository = manhoursProjectionsCurrentJobsProjectRepository;
            _manhoursPrjcJobDetailsForExcelDataTableListRepository = manhoursPrjcJobDetailsForExcelDataTableListRepository;
            _movemastForExcelTemplateDataTableListRepository = movemastForExcelTemplateDataTableListRepository;
            _noOfEmployeeDetailRepository = noOfEmployeeDetailRepository;
            _noOfEmployeeRepository = noOfEmployeeRepository;
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

            RapViewModel rapViewModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                rapViewModel.FilterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            return View(rapViewModel);
        }

        public async Task<IActionResult> TransactionsIndex()
        {
            if (!(CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionCostCodeEdit) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionHoDFormsEdit) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionProcoMastersEdit) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionProcoTrans)))
            {
                return Forbid();
            }

            return await CommonIndex();
        }

        public async Task<IActionResult> MasterIndex()
        {
            if (!(CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionCostCodeEdit) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionHoDFormsEdit) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionProcoMastersEdit) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionProcoTrans)))
            {
                return Forbid();
            }

            return await CommonIndex();
        }

        public async Task<IActionResult> ExpectedJobsIndex()
        {
            if (!(CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionProcoMastersEdit) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionProcoTrans)))
            {
                return Forbid();
            }

            return await CommonIndex();
        }

        #region Update Movement

        public async Task<IActionResult> MovementsIndex(string costcode)
        {
            if (!(CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionCostCodeEdit) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionHoDFormsEdit) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionProcoMastersEdit) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionProcoTrans)))
            {
                return Forbid();
            }

            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == RapReportingHelper.ActionProcoTrans)
               || CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == RapReportingHelper.ActionProcoProcess)
               || CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == RapReportingHelper.ActionReportsProco)
               || CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == RapReportingHelper.ActionCostCodeProcoEdit))
            {
                var costCodes = await _selectTcmPLRepository.SelectCostCodeRapReportingProco(BaseSpTcmPLGet(), null);
                ViewData["CostCodes"] = new SelectList(costCodes, "DataValueField", "DataTextField", costcode);
            }
            else
            {
                var costCodes = await _selectTcmPLRepository.SelectCostCodeRapReporting(BaseSpTcmPLGet(), null);
                ViewData["CostCodes"] = new SelectList(costCodes, "DataValueField", "DataTextField", costcode);
            }

            ViewData["Costcode"] = costcode;
            return View();
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetMovementLists(string paramJson)
        {
            DTResult<MovemastDataTableList> result = new();
            var param = JsonConvert.DeserializeObject<DTParameters>(paramJson);
            int totalRow = 0;

            try
            {
                IEnumerable<MovemastDataTableList> data = await _movemastDataTableListRepository.MovemastDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch ?? " ",
                        PCostcode = param.Assign,
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
        public IActionResult MovementCreate(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var costcode = id;
            var resultDetails = _movemastDetailRepository.MovemastDetail(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PCostcode = costcode,
                        PYymm = null,
                    }
            );

            MovemastViewModel movemastCreateViewModel = new();

            var lockYYMM = resultDetails.Result.PLockedMonth;

            DateTime dtLockMonth = new(int.Parse(lockYYMM.Substring(0, 4)), int.Parse(lockYYMM.Substring(4, 2)), 1);

            ViewData["LockMonth"] = dtLockMonth.ToString("yyyy-MM");

            if (costcode != null)
            {
                var maxYYMM = resultDetails.Result.PLastYymm == null ? "" : resultDetails.Result.PLastYymm;
                string newYYMM;
                string strYYMM;
                if (maxYYMM != "")
                {
                    DateTime dtMaxYYMM = new(int.Parse(maxYYMM.Substring(0, 4)), int.Parse(maxYYMM.Substring(4, 2)), 1);
                    newYYMM = dtMaxYYMM.AddMonths(1).ToString("yyyy-MM");
                    strYYMM = dtMaxYYMM.AddMonths(1).ToString("yyyyMM");
                }
                else
                {
                    newYYMM = dtLockMonth.AddMonths(1).ToString("yyyy-MM");
                    strYYMM = dtLockMonth.AddMonths(1).ToString("yyyyMM");
                }

                ViewData["maxYYMM"] = newYYMM;
                ViewData["strYYMM"] = strYYMM;
            }

            ViewData["Costcode"] = costcode;

            return PartialView("_ModalMovementCreatePartial", movemastCreateViewModel);
        }

        [HttpPost]
        public IActionResult MovementCreate([FromForm] MovemastViewModel movemastCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = _movemastRepository.CreateMovemastAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PCostcode = movemastCreateViewModel.Costcode,
                        PYymm = movemastCreateViewModel.Yymm,
                        PMovement = (movemastCreateViewModel.Movetotcm ?? 0) + (movemastCreateViewModel.Movetosite ?? 0) + (movemastCreateViewModel.Movetoothers ?? 0),
                        PMovetotcm = movemastCreateViewModel.Movetotcm ?? 0,
                        PMovetosite = movemastCreateViewModel.Movetosite ?? 0,
                        PMovetoothers = movemastCreateViewModel.Movetoothers ?? 0,
                        PExtSubcontract = movemastCreateViewModel.ExtSubcontract ?? 0,
                        PFutRecruit = movemastCreateViewModel.FutRecruit ?? 0,
                        PIntDept = movemastCreateViewModel.IntDept ?? 0,
                        PHrsSubcont = movemastCreateViewModel.HrsSubcont ?? 0,
                    }
                );

                    if (result.Result.PMessageType != IsOk)
                    {
                        return StatusCode((int)HttpStatusCode.InternalServerError, result.Result.PMessageText.Replace("-", " "));
                    }
                    else
                    {
                        return Json(new { success = result.Result.PMessageType == IsOk, response = result.Result.PMessageText.Replace("-", " ") });
                    }
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }

            return Json(new { });
        }

        [HttpGet]
        public async Task<IActionResult> MovementUpdate(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var costcode = id.Split(";")[0];
            var yymm = id.Split(";")[1];

            MovemastViewModel movemastUpdateViewModel = new();

            var resultDetails = await _movemastDetailRepository.MovemastDetail(
                   BaseSpTcmPLGet(),
                   new ParameterSpTcmPL
                   {
                       PCostcode = costcode,
                       PYymm = yymm,
                   }
           );

            movemastUpdateViewModel.Costcode = costcode;
            movemastUpdateViewModel.Yymm = yymm;

            movemastUpdateViewModel.Movement = (int?)((resultDetails.PMovetotcm ?? 0) + (resultDetails.PMovetosite ?? 0) + (resultDetails.PMovetoothers ?? 0));
            movemastUpdateViewModel.Movetotcm = (int?)(resultDetails.PMovetotcm ?? 0);
            movemastUpdateViewModel.Movetosite = (int?)(resultDetails.PMovetosite ?? 0);
            movemastUpdateViewModel.Movetoothers = (int?)(resultDetails.PMovetoothers ?? 0);
            movemastUpdateViewModel.ExtSubcontract = (int?)(resultDetails.PExtSubcontract ?? 0);
            movemastUpdateViewModel.FutRecruit = (int?)(resultDetails.PFutRecruit ?? 0);
            movemastUpdateViewModel.IntDept = (int?)(resultDetails.PIntDept ?? 0);
            movemastUpdateViewModel.HrsSubcont = (int?)(resultDetails.PHrsSubcont ?? 0);

            var totMovement = (int?)((resultDetails.PMovetotcm ?? 0) + (resultDetails.PMovetosite ?? 0) + (resultDetails.PMovetoothers ?? 0)); ;

            ViewData["TotalMovement"] = totMovement;

            return PartialView("_ModalMovementUpdatePartial", movemastUpdateViewModel);
        }

        [HttpPost]
        public IActionResult MovementUpdate([FromForm] MovemastViewModel movemastUpdateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = _movemastRepository.UpdateMovemastAsync(
                   BaseSpTcmPLGet(),
                   new ParameterSpTcmPL
                   {
                       PCostcode = movemastUpdateViewModel.Costcode,
                       PYymm = movemastUpdateViewModel.Yymm,
                       PMovement = (movemastUpdateViewModel.Movetotcm ?? 0) + (movemastUpdateViewModel.Movetosite ?? 0) + (movemastUpdateViewModel.Movetoothers ?? 0),
                       PMovetotcm = movemastUpdateViewModel.Movetotcm ?? 0,
                       PMovetosite = movemastUpdateViewModel.Movetosite ?? 0,
                       PMovetoothers = movemastUpdateViewModel.Movetoothers ?? 0,
                       PExtSubcontract = movemastUpdateViewModel.ExtSubcontract ?? 0,
                       PFutRecruit = movemastUpdateViewModel.FutRecruit ?? 0,
                       PIntDept = movemastUpdateViewModel.IntDept ?? 0,
                       PHrsSubcont = movemastUpdateViewModel.HrsSubcont ?? 0,
                   });

                    if (result.Result.PMessageType != IsOk)
                    {
                        return StatusCode((int)HttpStatusCode.InternalServerError, result.Result.PMessageText.Replace("-", " "));
                    }
                    else
                    {
                        return Json(new { success = result.Result.PMessageType == IsOk, response = result.Result.PMessageText.Replace("-", " ") });
                    }
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }

            return Json(new { });
        }

        [HttpPost]
        public IActionResult MovementDelete(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            try
            {
                var costcode = id.Split(";")[0];
                var yymm = id.Split(";")[1];

                var result = _movemastRepository.DeleteMovemastAsync(
                  BaseSpTcmPLGet(),
                  new ParameterSpTcmPL
                  {
                      PCostcode = costcode,
                      PYymm = yymm
                  });

                if (result.Result.PMessageType != IsOk)
                {
                    return StatusCode((int)HttpStatusCode.InternalServerError, result.Result.PMessageText.Replace("-", " "));
                }
                else
                {
                    return Json(new { success = result.Result.PMessageType == IsOk, response = result.Result.PMessageText.Replace("-", " ") });
                }
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = ex.Message });
            }
        }

        #region Excel import

        [HttpGet]
        public async Task<IActionResult> ImportExportMovemast(string costcode)
        {
            if (costcode == null)
            {
                return NotFound();
            }

            //costcode desc
            var costCodeName = await _rapReportingRepository.CostcodeNameAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PCostcode = costcode
                    });
            ViewData["Costcode"] = costcode;
            ViewData["CostcodeName"] = costCodeName.PName;

            return PartialView("_ModalTemplateImport");
        }

        [HttpGet]
        public async Task<IActionResult> MovemastXLTemplateDownload(string costcode)
        {
            Stream ms = _excelTemplate.ExportMovemast("v01",
                new Library.Excel.Template.Models.DictionaryCollection
                {
                },
                500);

            var fileName = "RapReporting Movemast " + costcode + ".xlsx";

            var mimeType = MimeTypeMap.GetMimeType("xlsx");

            ms.Position = 0;

            var data = await _movemastForExcelTemplateDataTableListRepository.MovemastForExcelTemplateDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PCostcode = costcode,
                        PRowNumber = 0,
                        PPageLength = 999999
                    }
                );

            var result = data.ToList();

            using XLWorkbook wb = new(ms);
            MemoryStream stream = new();
            {
                int rowsUsed = result.Count();
                int rowNumberExcel = rowsUsed + 1;
                rowsUsed = rowsUsed + 2;

                if (result.Any())
                {
                    _ = wb.Worksheet("Import").Cell(2, 1).InsertData(result);
                    wb.Worksheet("Import").Range("A2", "A" + rowNumberExcel).Value = "'" + costcode;
                    wb.Worksheet("Import").Range("C2", "C" + rowNumberExcel).Delete(XLShiftDeletedCells.ShiftCellsLeft);
                }

                wb.SaveAs(stream);
                stream.Position = 0;
                return File(stream.ToArray(), mimeType, fileName);
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> MovemastXLTemplateUpload(string costcode, IFormFile file)
        {
            try
            {
                if (file == null || file.Length == 0)
                {
                    return Json(new { success = false, response = "File not uploaded due to unrecongnised parameters" });
                }

                FileInfo fileInfo = new(file.FileName);

                Guid storageId = Guid.NewGuid();
                var stream = file.OpenReadStream();
                var fileName = file.FileName;
                var fileSize = file.Length;
                var mimeType = MimeTypeMap.GetMimeType(fileInfo.Extension);
                string fileNameErrors = Path.GetFileNameWithoutExtension(fileInfo.Name) + "-Err" + fileInfo.Extension;

                // Check file validation
                if (!fileInfo.Extension.Contains("xls"))
                {
                    return Json(new { success = false, response = "Excel file not recognized" });
                }

                string json = string.Empty;

                List<Movemast> movemastItems = _excelTemplate.ImportMovemast(stream);
                string jsonString = JsonConvert.SerializeObject(movemastItems);
                byte[] byteArray = Encoding.ASCII.GetBytes(jsonString);

                var uploadOutPut = await _movemastImportRepository.ImportMovemastAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PCostcode = costcode,
                            PMovemastJson = byteArray
                        }
                    );

                var movemastErrors = JsonConvert.SerializeObject(uploadOutPut.PMovemastErrors);
                ImportFileResultViewModel importFileResult = new();
                IEnumerable<ImportFileResultViewModel> importFileResults = JsonConvert.DeserializeObject<IEnumerable<ImportFileResultViewModel>>(movemastErrors);

                List<Library.Excel.Template.Models.ValidationItem> validationItems = new();

                if (importFileResults?.Count() > 0)
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

                if (uploadOutPut.PMessageType != BaseController.IsOk)
                {
                    if (importFileResults.Any())
                    {
                        var streamError = _excelTemplate.ValidateImport(stream, validationItems);
                        FileContentResult fileContentResult = base.File(streamError.ToArray(), mimeType, fileNameErrors);

                        var resultJsonError = new
                        {
                            success = false,
                            response = uploadOutPut.PMessageText,
                            data = importFileResults,
                            fileContent = fileContentResult
                        };

                        return base.Json(resultJsonError);
                    }
                    else
                    {
                        var resultJsonError = new
                        {
                            success = false,
                            response = uploadOutPut.PMessageText,
                            data = importFileResults
                        };

                        return base.Json(resultJsonError);
                    }
                }
                else
                {
                    var resultJson = new
                    {
                        success = true,
                        response = "Import data successfully executed"
                    };

                    return base.Json(resultJson);
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

        #endregion Excel import

        #endregion Update Movement

        #region Api Function

        public async Task<PostReturnModel> PutAPI(object obj, string _uri)
        {
            var returnResponse = await _httpClientRapReporting.ExecutePutUriAsync(new Classes.HCModel { }, _uri, obj);

            PostReturnModel postReturnModel = new();

            if (returnResponse.IsSuccessStatusCode)
            {
                var JsonString = returnResponse.Content.ReadAsStringAsync().Result;
                postReturnModel = JsonConvert.DeserializeObject<PostReturnModel>(JsonString);
            }

            return postReturnModel;
        }

        public async Task<PostReturnModel> PostAPI(object obj, string _uri)
        {
            var returnResponse = await _httpClientRapReporting.ExecutePostUriAsync(new Classes.HCModel { }, _uri, obj);

            PostReturnModel postReturnModel = new();

            if (returnResponse.IsSuccessStatusCode)
            {
                var JsonString = returnResponse.Content.ReadAsStringAsync().Result;
                postReturnModel = JsonConvert.DeserializeObject<PostReturnModel>(JsonString);
            }

            return postReturnModel;
        }

        public async Task<PostReturnModel> PutStrAPI(HCModel hCModel, string str, string _uri)
        {
            var returnResponse = await _httpClientRapReporting.ExecutePutStrUriAsync(hCModel, _uri, str);

            PostReturnModel postReturnModel = new();

            if (returnResponse.IsSuccessStatusCode)
            {
                var JsonString = returnResponse.Content.ReadAsStringAsync().Result;
                postReturnModel = JsonConvert.DeserializeObject<PostReturnModel>(JsonString);
            }

            return postReturnModel;
        }

        public async Task<PostReturnModel> DeleteAPI(object obj, string _uri)
        {
            var returnResponse = await _httpClientRapReporting.ExecutePostUriAsync(new Classes.HCModel { }, _uri, obj);

            PostReturnModel postReturnModel = new();

            if (returnResponse.IsSuccessStatusCode)
            {
                var JsonString = returnResponse.Content.ReadAsStringAsync().Result;
                postReturnModel = JsonConvert.DeserializeObject<PostReturnModel>(JsonString);
            }

            return postReturnModel;
        }

        #endregion Api Function

        #region Master

        #region UpdateNumberOfEmployee

        public async Task<IActionResult> UpdateNumberOfEmployee()
        {
            UpdateNumberOfEmployeeViewModel updateNumberOfEmployeeViewModel = new();

            var costcodes = await _selectTcmPLRepository.SelectCostCodeRapReportingProco(BaseSpTcmPLGet(), null);
            ViewData["Costcodes"] = new SelectList(costcodes, "DataValueField", "DataTextField");

            return PartialView("_ModalUpdateNumberOfEmployee", updateNumberOfEmployeeViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> UpdateNumberOfEmployee([FromForm] UpdateNumberOfEmployeeViewModel updateNumberOfEmployeeViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = _noOfEmployeeRepository.UpdateNoOfEmpAsync(
                     BaseSpTcmPLGet(),
                     new ParameterSpTcmPL
                     {
                         PCostcode = updateNumberOfEmployeeViewModel.Costcode,
                         PChangedNemps = updateNumberOfEmployeeViewModel.Changednemps,
                     });

                    if (result.Result.PMessageType != IsOk)
                    {
                        return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(result.Result.PMessageText));
                    }
                    else
                    {
                        return Json(new { success = result.Result.PMessageType == IsOk, response = result.Result.PMessageText });
                    }
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            var costcodes = await _selectTcmPLRepository.SelectCostCodeRapReportingProco(BaseSpTcmPLGet(), null);
            ViewData["Costcodes"] = new SelectList(costcodes, "DataValueField", "DataTextField");

            return PartialView("_ModalUpdateNumberOfEmployee", updateNumberOfEmployeeViewModel);
        }

        public async Task<IActionResult> GetNumberOfEmployee(string costcode)
        {
            NoOfEmpVal numberOfEmployeeObj = new();
            var result = _noOfEmployeeDetailRepository.DetailAsync(
                      BaseSpTcmPLGet(),
                      new ParameterSpTcmPL
                      {
                          PCostcode = costcode
                      });

            if (result.Result.PMessageType != IsOk)
            {
                throw new Exception(result.Result.PMessageText.Replace("-", " "));
            }

            numberOfEmployeeObj.Noofemps = (int)result.Result.PNoofemps;
            numberOfEmployeeObj.Changednemps = (long)result.Result.PChangedNemps;
            numberOfEmployeeObj.Costcode = costcode;

            return Json(numberOfEmployeeObj);
        }

        #endregion UpdateNumberOfEmployee

        #region ExpectedJobs

        public async Task<IActionResult> ExpectedJobsFilterGet()
        {
            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterExpectedJobsIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }
            return PartialView("_ModalExpectedJobsFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> ExpectedJobsFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                string jsonFilter;

                jsonFilter = JsonConvert.SerializeObject(new { IsActive = filterDataModel.IsActive, IsActiveFuture = filterDataModel.IsActiveFuture });

                var retVal = await _filterRepository.FilterCreateAsync(new Domain.Models.FilterCreate
                {
                    PModuleName = CurrentUserIdentity.CurrentModule,
                    PMetaId = CurrentUserIdentity.MetaId,
                    PPersonId = CurrentUserIdentity.EmployeeId,
                    PMvcActionName = ConstFilterExpectedJobsIndex,
                    PFilterJson = jsonFilter
                });

                return Json(new
                {
                    success = true,
                    isActive = filterDataModel.IsActive,
                    isActiveFuture = filterDataModel.IsActiveFuture
                });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        public async Task<IActionResult> ExpectedJobsCreate()
        {
            ExpectedJobsViewModel expectedJobsViewModel = new();

            var newCostCodes = await _selectTcmPLRepository.RapJobTMAGroupListAsync(BaseSpTcmPLGet(), null);
            ViewData["NewCostCodes"] = new SelectList(newCostCodes, "DataValueField", "DataTextField");

            return PartialView("_ModalExpectedJobsCreate", expectedJobsViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> ExpectedJobsCreate([FromForm] ExpectedJobsViewModel expectedJobsViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _expectedJobsRepository.CreateExpectedjobsAsync(
                      BaseSpTcmPLGet(),
                      new ParameterSpTcmPL
                      {
                          PBu = expectedJobsViewModel.Bu,
                          PFinalProjno = expectedJobsViewModel.FinalProjno,
                          PTcmno = expectedJobsViewModel.Tcmno,
                          PProjno = expectedJobsViewModel.Projno,
                          PActive = (int?)expectedJobsViewModel.Active,
                          PActivefuture = (int?)expectedJobsViewModel.Activefuture,
                          PNewcostcode = expectedJobsViewModel.Newcostcode,
                          PLck = (int?)expectedJobsViewModel.Lck,
                          PName = expectedJobsViewModel.Name,
                          PProjType = expectedJobsViewModel.ProjType
                      });

                    if (result.PMessageType != IsOk)
                    {
                        throw new Exception(result.PMessageText.Replace("-", " "));
                    }
                    else
                    {
                        return Json(new { success = result.PMessageType == IsOk, response = result.PMessageText });
                    }
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            var newCostCodes = await _selectTcmPLRepository.RapJobTMAGroupListAsync(BaseSpTcmPLGet(), null);
            ViewData["NewCostCodes"] = new SelectList(newCostCodes, "DataValueField", "DataTextField", expectedJobsViewModel.Newcostcode);

            return PartialView("_ModalExpectedJobsCreate", expectedJobsViewModel);
        }

        public async Task<IActionResult> ExpectedJobsDetails(string projno)
        {
            if (string.IsNullOrEmpty(projno))
            {
                throw new Exception("Project no not found");
            }

            var result = await _expectedJobsDetailsRepository.ExpectedJobsDetailsAsync(
                          BaseSpTcmPLGet(), new ParameterSpTcmPL { PProjno = projno });

            if (result.PMessageType != IsOk)
            {
                throw new Exception(result.PMessageText.Replace("-", " "));
            }

            ExpectedJobsViewModel expectedJobsViewModel = new()
            {
                Projno = projno,
                Tcmno = result.PTcmno,
                Bu = result.PBu,
                FinalProjno = result.PFinalProjno,
                Name = result.PName,
                ProjType = result.PProjType,
                Newcostcode = result.PNewcostcode
            };
            expectedJobsViewModel.ProjType = result.PProjType;

            if (!string.IsNullOrEmpty(result.PActive))
            {
                expectedJobsViewModel.Active = decimal.Parse(result.PActive);
            }
            if (!string.IsNullOrEmpty(result.PActivefuture))
            {
                expectedJobsViewModel.Activefuture = decimal.Parse(result.PActivefuture);
            }
            if (!string.IsNullOrEmpty(result.PLck))
            {
                expectedJobsViewModel.Lck = decimal.Parse(result.PLck);
            }

            var newCostCodes = await _selectTcmPLRepository.RapJobTMAGroupListAsync(BaseSpTcmPLGet(), null);
            ViewData["NewCostCodes"] = new SelectList(newCostCodes, "DataValueField", "DataTextField", expectedJobsViewModel.Newcostcode);

            return PartialView("_ModalExpectedJobsDetails", expectedJobsViewModel);
        }

        public IActionResult ExpectedJobsSetting(string projno)
        {
            ExpectedJobsSettingViewModel expectedJobsSettingViewModel = new()
            {
                ProjectNo = projno
            };
            return PartialView("_ModalExpectedJobsSetting", expectedJobsSettingViewModel);
        }

        public async Task<IActionResult> ExpectedJobsEdit(string projno)
        {
            if (string.IsNullOrEmpty(projno))
            {
                throw new Exception("Project no not found");
            }

            var result = await _expectedJobsDetailsRepository.ExpectedJobsDetailsAsync(
                          BaseSpTcmPLGet(), new ParameterSpTcmPL { PProjno = projno });

            if (result.PMessageType != IsOk)
            {
                throw new Exception(result.PMessageText.Replace("-", " "));
            }

            ExpectedJobsViewModel expectedJobsViewModel = new()
            {
                Projno = projno,
                Tcmno = result.PTcmno,
                Bu = result.PBu,
                FinalProjno = result.PFinalProjno,
                Name = result.PName,
                ProjType = result.PProjType,
                Newcostcode = result.PNewcostcode
            };
            expectedJobsViewModel.ProjType = result.PProjType;

            if (!string.IsNullOrEmpty(result.PActive))
            {
                expectedJobsViewModel.Active = decimal.Parse(result.PActive);
            }
            if (!string.IsNullOrEmpty(result.PActivefuture))
            {
                expectedJobsViewModel.Activefuture = decimal.Parse(result.PActivefuture);
            }
            if (!string.IsNullOrEmpty(result.PLck))
            {
                expectedJobsViewModel.Lck = decimal.Parse(result.PLck);
            }

            var newCostCodes = await _selectTcmPLRepository.RapJobTMAGroupListAsync(BaseSpTcmPLGet(), null);
            ViewData["NewCostCodes"] = new SelectList(newCostCodes, "DataValueField", "DataTextField", expectedJobsViewModel.Newcostcode);

            return PartialView("_ModalExpectedJobsEdit", expectedJobsViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> ExpectedJobsEdit([FromForm] ExpectedJobsViewModel expectedJobsViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _expectedJobsRepository.UpdateExpectedjobsAsync(
                      BaseSpTcmPLGet(),
                      new ParameterSpTcmPL
                      {
                          PBu = expectedJobsViewModel.Bu,
                          PFinalProjno = expectedJobsViewModel.FinalProjno,
                          PTcmno = expectedJobsViewModel.Tcmno,
                          PProjno = expectedJobsViewModel.Projno,
                          PActive = (int?)expectedJobsViewModel.Active,
                          PActivefuture = (int?)expectedJobsViewModel.Activefuture,
                          PNewcostcode = expectedJobsViewModel.Newcostcode,
                          PLck = (int?)expectedJobsViewModel.Lck,
                          PName = expectedJobsViewModel.Name,
                          PProjType = expectedJobsViewModel.ProjType
                      });

                    if (result.PMessageType != IsOk)
                    {
                        throw new Exception(result.PMessageText.Replace("-", " "));
                    }
                    else
                    {
                        return Json(new { success = result.PMessageType == IsOk, response = result.PMessageText });
                    }
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            var newCostCodes = await _selectTcmPLRepository.RapJobTMAGroupListAsync(BaseSpTcmPLGet(), null);
            ViewData["NewCostCodes"] = new SelectList(newCostCodes, "DataValueField", "DataTextField", expectedJobsViewModel.Newcostcode);

            return PartialView("_ModalExpectedJobsEdit", expectedJobsViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> ExpectedJobsDelete(string projno)
        {
            try
            {
                var result = await _expectedJobsRepository.DeleteExpectedjobsAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL { PProjno = projno }
                    );

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsExpectedJobs(DTParameters param)
        {
            DTResult<ExpectedJobsDataTableList> result = new();
            int totalRow = 0;

            if (!string.IsNullOrEmpty(param.GenericSearch))
            {
                param.GenericSearch = param.GenericSearch.Trim();
            }

            try
            {
                var data = await _expectedJobsDataTableListRepository.ExpectedJobsDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
                        PProjno = param.GenericSearch,
                        PActive = param.IsActive,
                        PActivefuture = param.IsActiveFuture,
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

        public async Task<IActionResult> MoveProjectionByMonths(string projno, int noOfMonths)
        {
            try
            {
                var result = await _expectedJobsRepository.MoveProjectionByMonthsAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL { PProjno = projno, PNumberOfMonths = noOfMonths }
                    );

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        public async Task<IActionResult> MoveToFinalRealProject(string projno, string realProjectNo)
        {
            try
            {
                var result = await _expectedJobsRepository.MoveToFinalRealProjectAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL { PProjno = projno, PRealProjno = realProjectNo }
                    );

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        public async Task<IActionResult> MoveToFinalExpectedProject(string projno, string expectedProjectNo)
        {
            try
            {
                var result = await _expectedJobsRepository.MoveToFinalExpectedProjectAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL { PProjno = projno, PExpectedProjno = expectedProjectNo }
                    );

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        public async Task<IActionResult> MoveToFinalRealCostCodeNewProject(string projno, string NewProjectNo, string costCode)
        {
            try
            {
                var result = await _expectedJobsRepository.MoveToFinalRealProjectCostCodeAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL { PProjno = projno, PNewProjno = NewProjectNo, PCostcode = costCode }
                    );

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        #endregion ExpectedJobs

        #region Project activity

        public async Task<IActionResult> ProjectActivityIndex()
        {
            if (!(CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionCostCodeEdit) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionHoDFormsEdit) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionProcoMastersEdit) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionProcoTrans)))
            {
                return Forbid();
            }

            return await CommonIndex();
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetProjectActivityLists(DTParameters param)
        {
            DTResult<ProjactMasterDataTableList> result = new();

            int totalRow = 0;

            try
            {
                System.Collections.Generic.IEnumerable<ProjactMasterDataTableList> data = await _projactMasterDataTableListRepository.ProjactMasterDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch ?? " ",
                        PCostcode = param.Costcode,
                        PProjno = param.Projno,
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
        public async Task<IActionResult> ProjectActivityCreate(string id, string costcode)
        {
            if (id == null)
            {
                return NotFound();
            }
            ProjactCreateViewModel projactCreateViewModel = new()
            {
                Projno = id,
                Costcode = costcode
            };

            var activities = await _selectTcmPLRepository.SelectActivityRapReporting(BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PCostcode = costcode
                });
            ViewData["Activities"] = new SelectList(activities, "DataValueField", "DataTextField");

            return PartialView("_ModalProjectActivityCreatePartial", projactCreateViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> ProjectActivityCreate([FromForm] ProjactCreateViewModel projactCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _projactMasterRepository.CreateProjactAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PProjno = projactCreateViewModel.Projno,
                            PCostcode = projactCreateViewModel.Costcode,
                            PActivity = projactCreateViewModel.Activity,
                            PBudghrs = Convert.ToInt32(projactCreateViewModel.Budghrs),
                            PNoOfDocs = Convert.ToInt32(projactCreateViewModel.NoOfDocs)
                        });

                    return result.PMessageType == NotOk
                        ? throw new Exception(result.PMessageText.Replace("-", " "))
                        : (IActionResult)Json(new { success = true, response = result.PMessageText });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            var activities = await _selectTcmPLRepository.SelectActivityRapReporting(BaseSpTcmPLGet(),
                                      new ParameterSpTcmPL
                                      {
                                          PCostcode = projactCreateViewModel.Costcode
                                      });
            ViewData["Activities"] = new SelectList(activities, "DataValueField", "DataTextField");

            return PartialView("_ModalProjectActivityCreatePartial", projactCreateViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> ProjectActivityEdit(string projno, string activity, string id)
        {
            if (projno == null || activity == null || id == null)
            {
                return NotFound();
            }

            ProjactDetails result = await _projactDetailRepository.ProjactDetail(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
                PProjno = projno,
                PCostcode = id,
                PActivity = activity
            });

            ProjactUpdateViewModel projactUpdateViewModel = new();

            if (result.PMessageType == IsOk)
            {
                projactUpdateViewModel.Projno = projno;
                projactUpdateViewModel.Costcode = id;
                projactUpdateViewModel.Activity = activity;
                projactUpdateViewModel.Budghrs = result.PBudghrs;
                projactUpdateViewModel.NoOfDocs = result.PNoOfDocs;
            }

            var activities = await _selectTcmPLRepository.SelectActivityRapReporting(BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PCostcode = projactUpdateViewModel.Costcode
                });

            ViewData["ActivityName"] = activities.Where(a => a.DataValueField == activity).Select(x => x.DataTextField).FirstOrDefault();

            return PartialView("_ModalProjectActivityEditPartial", projactUpdateViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> ProjectActivityEdit([FromForm] ProjactUpdateViewModel projactUpdateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _projactMasterRepository.UpdateProjactAsync(
                         BaseSpTcmPLGet(),
                         new ParameterSpTcmPL
                         {
                             PProjno = projactUpdateViewModel.Projno,
                             PCostcode = projactUpdateViewModel.Costcode,
                             PActivity = projactUpdateViewModel.Activity,
                             PBudghrs = Convert.ToInt32(projactUpdateViewModel.Budghrs),
                             PNoOfDocs = Convert.ToInt32(projactUpdateViewModel.NoOfDocs)
                         });

                    return result.PMessageType != IsOk
                        ? throw new Exception(result.PMessageText.Replace("-", " "))
                        : (IActionResult)Json(new { success = true, response = result.PMessageText });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
            var activities = await _selectTcmPLRepository.SelectActivityRapReporting(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
                PCostcode = projactUpdateViewModel.Costcode
            });
            ViewData["ActivityName"] = activities.Where(a => a.DataValueField == projactUpdateViewModel.Activity).Select(x => x.DataTextField).FirstOrDefault();
            return PartialView("_ModalProjectActivityEditPartial", projactUpdateViewModel);
        }

        #endregion Project activity

        #region Rap hours

        public IActionResult RAPHoursIndex()
        {
            return View();
        }

        [HttpGet]
        public async Task<JsonResult> GetRAPHoursLists(DTParameters param)
        {
            DTResult<RapHoursDataTableList> result = new();
            int totalRow = 0;
            try
            {
                System.Collections.Generic.IEnumerable<RapHoursDataTableList> data = await _rapHoursDataTableListRepository.RapHoursDataTableListAsync(
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

        [HttpGet]
        public IActionResult RapHoursCreate()
        {
            RapHoursCreateViewModel rapHoursViewModel = new();

            return PartialView("_ModalRapHoursCreatePartial", rapHoursViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> RapHoursCreate([FromForm] RapHoursCreateViewModel rapHoursCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _rapHoursRepository.CreateRapHoursAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PYymm = rapHoursCreateViewModel.Yymm,
                            PWorkDays = rapHoursCreateViewModel.WorkDays,
                            PWeekend = rapHoursCreateViewModel.Weekend,
                            PHolidays = rapHoursCreateViewModel.Holidays,
                            PLeave = rapHoursCreateViewModel.Leave,
                            PTotDays = rapHoursCreateViewModel.TotDays,
                            PWorkingHr = rapHoursCreateViewModel.WorkingHr
                        });

                    return result.PMessageType == NotOk
                        ? throw new Exception(result.PMessageText.Replace("-", " "))
                        : (IActionResult)Json(new { success = true, response = result.PMessageText });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            return PartialView("_ModalRapHoursCreatePartial", rapHoursCreateViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> RapHoursUpdate(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            RapHoursDetails result = await _rapHoursDetailRepository.RapHoursDetail(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
                PYymm = id
            });

            RapHoursUpdateViewModel rapHoursUpdateViewModel = new();

            if (result.PMessageType == IsOk)
            {
                rapHoursUpdateViewModel.Yymm = id;
                rapHoursUpdateViewModel.WorkDays = result.PWorkDays;
                rapHoursUpdateViewModel.Weekend = result.PWeekend;
                rapHoursUpdateViewModel.Holidays = result.PHolidays;
                rapHoursUpdateViewModel.Leave = result.PLeave;
                rapHoursUpdateViewModel.TotDays = result.PTotDays;
                rapHoursUpdateViewModel.WorkingHr = result.PWorkingHr;
            }

            return PartialView("_ModalRapHoursUpdatePartial", rapHoursUpdateViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> RapHoursUpdate([FromForm] RapHoursUpdateViewModel rapHoursUpdateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    if (ModelState.IsValid)
                    {
                        Domain.Models.Common.DBProcMessageOutput result = await _rapHoursRepository.UpdateRapHoursAsync(
                             BaseSpTcmPLGet(),
                             new ParameterSpTcmPL
                             {
                                 PYymm = rapHoursUpdateViewModel.Yymm,
                                 PWorkDays = rapHoursUpdateViewModel.WorkDays,
                                 PWeekend = rapHoursUpdateViewModel.Weekend,
                                 PHolidays = rapHoursUpdateViewModel.Holidays,
                                 PLeave = rapHoursUpdateViewModel.Leave,
                                 PTotDays = rapHoursUpdateViewModel.TotDays,
                                 PWorkingHr = rapHoursUpdateViewModel.WorkingHr
                             });

                        return result.PMessageType != IsOk
                            ? throw new Exception(result.PMessageText.Replace("-", " "))
                            : (IActionResult)Json(new { success = true, response = result.PMessageText });
                    }
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }

            return PartialView("_ModalRapHoursUpdatePartial", rapHoursUpdateViewModel);
        }

        #endregion Rap hours

        #region Wrk hours

        public IActionResult WrkHoursIndex()
        {
            return View();
        }

        [HttpGet]
        public async Task<JsonResult> GetWrkHoursLists(DTParameters param)
        {
            DTResult<WrkHoursDataTableList> result = new();
            int totalRow = 0;
            try
            {
                System.Collections.Generic.IEnumerable<WrkHoursDataTableList> data = await _wrkHoursDataTableListRepository.WrkHoursDataTableListAsync(
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

        [HttpGet]
        public async Task<IActionResult> WrkHoursCreate()
        {
            WrkHoursCreateViewModel wrkHoursCreateViewModel = new();

            string currentDate = DateTime.Now.ToString("yyyyMM");
            DateTime nextdt = DateTime.ParseExact(currentDate.ToString(), "yyyyMM", CultureInfo.InvariantCulture);
            nextdt = nextdt.AddMonths(1);

            ViewData["NextYYMM"] = nextdt.ToString("yyyyMM");

            var officeList = await _selectRepository.OfficeSelectListCacheAsync();
            ViewData["OfficeList"] = new SelectList(officeList, "DataValueField", "DataTextField");

            return PartialView("_ModalWrkHoursCreatePartial", wrkHoursCreateViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> WrkHoursCreate([FromForm] WrkHoursCreateViewModel wrkHoursCreateViewModel)
        {
            try
            {
                DateTime dtNow = DateTime.Now;

                if (wrkHoursCreateViewModel.Apprby != null)
                {
                    DateTime dtApp = (DateTime)wrkHoursCreateViewModel.Apprby;
                    wrkHoursCreateViewModel.Apprby = new DateTime(dtApp.Year, dtApp.Month, dtApp.Day, dtNow.Hour, dtNow.Minute, dtNow.Second, dtNow.Millisecond, dtNow.Kind);
                }
                if (wrkHoursCreateViewModel.Postby != null)
                {
                    DateTime dtPost = (DateTime)wrkHoursCreateViewModel.Postby;
                    wrkHoursCreateViewModel.Postby = new DateTime(dtPost.Year, dtPost.Month, dtPost.Day, dtNow.Hour, dtNow.Minute, dtNow.Second, dtNow.Millisecond, dtNow.Kind);
                }

                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _wrkHoursRepository.CreateWrkHoursAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PYymm = wrkHoursCreateViewModel.Yymm,
                            POffice = wrkHoursCreateViewModel.Office,
                            PWorkingHr = wrkHoursCreateViewModel.WorkingHrs,
                            PApprby = wrkHoursCreateViewModel.Apprby,
                            PPostby = wrkHoursCreateViewModel.Postby,
                            PRemarks = wrkHoursCreateViewModel.Remarks,
                        });

                    return result.PMessageType == NotOk
                        ? throw new Exception(result.PMessageText.Replace("-", " "))
                        : (IActionResult)Json(new { success = true, response = result.PMessageText });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
            var officeList = await _selectRepository.OfficeSelectListCacheAsync();
            ViewData["OfficeList"] = new SelectList(officeList, "DataValueField", "DataTextField", wrkHoursCreateViewModel.Office);
            return PartialView("_ModalWrkHoursCreatePartial", wrkHoursCreateViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> WrkHoursUpdate(string id, string office)
        {
            if (id == null)
            {
                return NotFound();
            }

            WrkHoursDetails result = await _wrkHoursDetailRepository.WrkHoursDetail(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
                PYymm = id,
                POffice = office
            });

            WrkHoursUpdateViewModel wrkHoursUpdateViewModel = new();

            if (result.PMessageType == IsOk)
            {
                wrkHoursUpdateViewModel.Yymm = id;
                wrkHoursUpdateViewModel.Office = office;
                wrkHoursUpdateViewModel.WorkingHrs = result.PWorkingHrs;
                wrkHoursUpdateViewModel.Apprby = result.PApprby;
                wrkHoursUpdateViewModel.Postby = result.PPostby;
                wrkHoursUpdateViewModel.Remarks = result.PRemarks;
            }

            var officeList = await _selectRepository.OfficeSelectListCacheAsync();
            ViewData["OfficeList"] = new SelectList(officeList, "DataValueField", "DataTextField", wrkHoursUpdateViewModel.Office);

            return PartialView("_ModalWrkHoursUpdate", wrkHoursUpdateViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> WrkHoursUpdate([FromForm] WrkHoursUpdateViewModel wrkHoursUpdateViewModel)
        {
            try
            {
                DateTime dtNow = DateTime.Now;

                if (wrkHoursUpdateViewModel.Apprby != null)
                {
                    DateTime dtApp = (DateTime)wrkHoursUpdateViewModel.Apprby;
                    wrkHoursUpdateViewModel.Apprby = new DateTime(dtApp.Year, dtApp.Month, dtApp.Day, dtNow.Hour, dtNow.Minute, dtNow.Second, dtNow.Millisecond, dtNow.Kind);
                }
                if (wrkHoursUpdateViewModel.Postby != null)
                {
                    DateTime dtPost = (DateTime)wrkHoursUpdateViewModel.Postby;
                    wrkHoursUpdateViewModel.Postby = new DateTime(dtPost.Year, dtPost.Month, dtPost.Day, dtNow.Hour, dtNow.Minute, dtNow.Second, dtNow.Millisecond, dtNow.Kind);
                }

                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _wrkHoursRepository.UpdateWrkHoursAsync(
                             BaseSpTcmPLGet(),
                             new ParameterSpTcmPL
                             {
                                 PYymm = wrkHoursUpdateViewModel.Yymm,
                                 POffice = wrkHoursUpdateViewModel.Office,
                                 PWorkingHr = wrkHoursUpdateViewModel.WorkingHrs,
                                 PApprby = wrkHoursUpdateViewModel.Apprby,
                                 PPostby = wrkHoursUpdateViewModel.Postby,
                                 PRemarks = wrkHoursUpdateViewModel.Remarks,
                             });

                    return result.PMessageType != IsOk
                        ? throw new Exception(result.PMessageText.Replace("-", " "))
                        : (IActionResult)Json(new { success = true, response = result.PMessageText });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
            var officeList = await _selectRepository.OfficeSelectListCacheAsync();
            ViewData["OfficeList"] = new SelectList(officeList, "DataValueField", "DataTextField", wrkHoursUpdateViewModel.Office);

            return PartialView("_ModalWrkHoursUpdate", wrkHoursUpdateViewModel);
        }

        #endregion Wrk hours

        #region Activity

        public async Task<IActionResult> ActivityIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterActivityMasterIndex
            });

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            ActivityMasterViewModel activityMasterViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(activityMasterViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetActivityLists(string paramJson)
        {
            DTResult<ActivityMasterDataTableList> result = new();
            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            int totalRow = 0;

            try
            {
                System.Collections.Generic.IEnumerable<ActivityMasterDataTableList> data = await _activityMasterDataTableListRepository.ActivityMasterDataTableListAsync(
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

        [HttpGet]
        public async Task<IActionResult> GetTlpLists(string costcode)
        {
            var tlpcodes = await _selectTcmPLRepository.SelectTlpCodeRapReporting(BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PCostcode = costcode,
                });
            return Json(tlpcodes);
        }

        [HttpGet]
        public async Task<IActionResult> ActivityCreate()
        {
            ActivityCreateViewModel activityCreateViewModel = new();

            var costcodes = await _selectTcmPLRepository.SelectCostCodeRapReportingProco(BaseSpTcmPLGet(), null);
            ViewData["Costcodes"] = new SelectList(costcodes, "DataValueField", "DataTextField");

            var toggleList = new List<SelectListItem> { new() { Text = "Yes", Value = "1"},
                                                        new() { Text = "No", Value = "0"}
                                                      };
            ViewData["ActiveList"] = new SelectList(toggleList, "Value", "Text");

            return PartialView("_ModalActivityCreatePartial", activityCreateViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> ActivityCreate([FromForm] ActivityCreateViewModel activityCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _activityMasterRepository.CreateActivityAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PCostcode = activityCreateViewModel.Costcode,
                            PActivity = activityCreateViewModel.Activity,
                            PName = activityCreateViewModel.Name,
                            PTlpcode = activityCreateViewModel.Tlpcode,
                            PActivityType = activityCreateViewModel.ActivityType,
                            PIsActive = activityCreateViewModel.Active
                        });

                    return result.PMessageType == NotOk
                        ? throw new Exception(result.PMessageText.Replace("-", " "))
                        : (IActionResult)Json(new { success = true, response = result.PMessageText });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            return PartialView("_ModalActivityCreatePartial", activityCreateViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> ActivityUpdate(string id, string activity)
        {
            if (id == null)
            {
                return NotFound();
            }

            ActivityDetails result = await _activityDetailRepository.ActivityDetail(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
                PCostcode = id,
                PActivity = activity
            });

            ActivityUpdateViewModel activityUpdateViewModel = new();

            if (result.PMessageType == IsOk)
            {
                activityUpdateViewModel.Costcode = id;
                activityUpdateViewModel.Activity = activity;
                activityUpdateViewModel.Name = result.PName;
                activityUpdateViewModel.Tlpcode = result.PTlpcode;
                activityUpdateViewModel.ActivityType = result.PActivityType;
                activityUpdateViewModel.Active = result.PIsActive;
            }

            var costCodeName = await _rapReportingRepository.CostcodeNameAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
                PCostcode = id
            });

            ViewData["CostcodeName"] = id + " - " + costCodeName.PName;

            var tlpcodes = await _selectTcmPLRepository.SelectTlpCodeRapReporting(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
                PCostcode = id,
            });

            ViewData["Tlpcodes"] = new SelectList(tlpcodes, "DataValueField", "DataTextField", result.PTlpcode);

            var toggleList = new List<SelectListItem> { new() { Text = "Yes", Value = "1"},
                                                        new() { Text = "No", Value = "0"}
                                                      };

            ViewData["ActiveList"] = new SelectList(toggleList, "Value", "Text", result.PIsActive);

            return PartialView("_ModalActivityUpdatePartial", activityUpdateViewModel);
        }

        public async Task<IActionResult> ActivityUpdate([FromForm] ActivityUpdateViewModel activityUpdateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _activityMasterRepository.UpdateActivityAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PCostcode = activityUpdateViewModel.Costcode,
                            PActivity = activityUpdateViewModel.Activity,
                            PName = activityUpdateViewModel.Name,
                            PTlpcode = activityUpdateViewModel.Tlpcode,
                            PActivityType = activityUpdateViewModel.ActivityType,
                            PIsActive = activityUpdateViewModel.Active
                        });

                    return result.PMessageType != IsOk
                        ? throw new Exception(result.PMessageText.Replace("-", " "))
                        : (IActionResult)Json(new { success = true, response = result.PMessageText });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }

            var costCodeName = await _rapReportingRepository.CostcodeNameAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
                PCostcode = activityUpdateViewModel.Costcode
            });

            ViewData["CostcodeName"] = activityUpdateViewModel.Costcode + " - " + costCodeName.PName;

            var tlpcodes = await _selectTcmPLRepository.SelectTlpCodeRapReporting(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
                PCostcode = activityUpdateViewModel.Costcode,
            });

            ViewData["Tlpcodes"] = new SelectList(tlpcodes, "DataValueField", "DataTextField", activityUpdateViewModel.Tlpcode);

            var toggleList = new List<SelectListItem> { new() { Text = "Yes", Value = "1"},
                                                        new() { Text = "No", Value = "0"}
                                                      };

            ViewData["ActiveList"] = new SelectList(toggleList, "Value", "Text", activityUpdateViewModel.Active);

            return PartialView("_ModalActivityUpdatePartial", activityUpdateViewModel);
        }

        #endregion Activity

        #region TLP master

        public IActionResult TLPIndex()
        {
            return View();
        }

        [HttpGet]
        public async Task<JsonResult> GetTLPDataTableList(DTParameters param)
        {
            DTResult<TLPDataTableList> result = new();
            int totalRow = 0;
            try
            {
                System.Collections.Generic.IEnumerable<TLPDataTableList> data = await _tLPDataTableListRepository.TLPDataTableListAsync(
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

        [HttpGet]
        public async Task<IActionResult> TLPCreate()
        {
            TLPCreateViewModel tLPCreateViewModel = new();

            var costcodes = await _selectTcmPLRepository.SelectCostCodeRapReportingProco(BaseSpTcmPLGet(), null);
            ViewData["Costcodes"] = new SelectList(costcodes, "DataValueField", "DataTextField");

            return PartialView("_ModalTLPCreatePartial", tLPCreateViewModel);
        }

        public async Task<IActionResult> TLPCreate([FromForm] TLPCreateViewModel tLPCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _tLPRepository.CreateTLPAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PCostcode = tLPCreateViewModel.Costcode,
                            PTlpcode = tLPCreateViewModel.Tlpcode,
                            PName = tLPCreateViewModel.Name
                        });

                    return result.PMessageType == NotOk
                        ? throw new Exception(result.PMessageText.Replace("-", " "))
                        : (IActionResult)Json(new { success = true, response = result.PMessageText });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }

            var costcodes = await _selectTcmPLRepository.SelectCostCodeRapReportingProco(BaseSpTcmPLGet(), null);
            ViewData["Costcodes"] = new SelectList(costcodes, "DataValueField", "DataTextField", tLPCreateViewModel.Costcode);

            return PartialView("_ModalTLPCreatePartial", tLPCreateViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> TLPUpdate(string id, string tplcode)
        {
            if (id == null)
            {
                return NotFound();
            }

            TLPDetails result = await _tLPDetailRepository.TLPDetail(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
                PCostcode = id,
                PTlpcode = tplcode
            });

            TLPUpdateViewModel tLPUpdateViewModel = new();

            if (result.PMessageType == IsOk)
            {
                tLPUpdateViewModel.Costcode = id;
                tLPUpdateViewModel.Tlpcode = tplcode;
                tLPUpdateViewModel.Name = result.PName;
            }

            var costcodes = await _selectTcmPLRepository.SelectCostCodeRapReportingProco(BaseSpTcmPLGet(), null);
            ViewData["Costcodes"] = new SelectList(costcodes, "DataValueField", "DataTextField", tLPUpdateViewModel.Costcode);

            return PartialView("_ModalTLPUpdatePartial", tLPUpdateViewModel);
        }

        public async Task<IActionResult> TLPUpdate([FromForm] TLPUpdateViewModel tLPUpdateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _tLPRepository.UpdateTLPAsync(
                             BaseSpTcmPLGet(),
                             new ParameterSpTcmPL
                             {
                                 PCostcode = tLPUpdateViewModel.Costcode,
                                 PTlpcode = tLPUpdateViewModel.Tlpcode,
                                 PName = tLPUpdateViewModel.Name
                             });

                    return result.PMessageType != IsOk
                        ? throw new Exception(result.PMessageText.Replace("-", " "))
                        : (IActionResult)Json(new { success = true, response = result.PMessageText });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }

            var costcodes = await _selectTcmPLRepository.SelectCostCodeRapReportingProco(BaseSpTcmPLGet(), null);
            ViewData["Costcodes"] = new SelectList(costcodes, "DataValueField", "DataTextField", tLPUpdateViewModel.Costcode);

            return PartialView("_ModalTLPUpdatePartial", tLPUpdateViewModel);
        }

        #endregion TLP master

        #region ManagetIndex

        public async Task<IActionResult> ManageIndex()
        {
            if (!(CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionCostCodeEdit) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionHoDFormsEdit) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionProcoMastersEdit) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionProcoTrans)))
            {
                return Forbid();
            }

            var result = await _manageRepository.MonthStatusAsync(
                   BaseSpTcmPLGet(),
                   new ParameterSpTcmPL { }
                   );

            ViewBag.MsgType = result.PMessageType;
            ViewBag.MsgText = result.PMessageText;

            return await CommonIndex();
        }

        #endregion ManagetIndex

        #region TsConfig

        public IActionResult TsConfigIndex()
        {
            return View();
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetTsConfigLists(string paramJson)
        {
            DTResult<TsConfigDataTableList> result = new();
            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            int totalRow = 0;

            try
            {
                System.Collections.Generic.IEnumerable<TsConfigDataTableList> data = await _tsConfigDataTableListRepository.TsConfigDataTableListAsync(
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

        #endregion TsConfig

        #endregion Master

        #region Manhours projections current jobs

        #region Index

        public async Task<IActionResult> ManhoursProjectionsCurrentJobsIndex()
        {
            if (!(CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionCostCodeEdit) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionHoDFormsEdit) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionProcoMastersEdit) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionProcoTrans)))
            {
                return Forbid();
            }

            ProcessMonthDetails month = await _processingMonthDetailRepository.ProcessingMonthDetail(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
                PSchemaname = Schemaname
            });

            ViewData["ProcessingMonth"] = month.PProcMonth.Substring(0, 4) + "/" + month.PProcMonth.Substring(4, 2);
            var dat = new DateTime(Int16.Parse(month.PProcMonth.Substring(0, 4)), Int16.Parse(month.PProcMonth.Substring(4, 2)), 1);

            ViewData["PreviousMonth"] = dat.AddMonths(-1).ToString("yyyy") + "/" + dat.AddMonths(-1).ToString("MM");
            return await CommonIndex();
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsManhoursProjectionsCurrentJobs(DTParameters param)
        {
            DTResult<ManhoursProjectionsCurrentJobsDataTableList> result = new();
            int totalRow = 0;
            try
            {
                ProcessMonthDetails month = await _processingMonthDetailRepository.ProcessingMonthDetail(BaseSpTcmPLGet(), new ParameterSpTcmPL
                {
                    PSchemaname = Schemaname
                });

                //var data = await ManhoursProjectionsCurrentJobsGetListsFromAPI();
                string startmonth = getStartMonth(param.YearMode, month.PProcMonth);

                System.Collections.Generic.IEnumerable<ManhoursProjectionsCurrentJobsDataTableList> data = await _manhoursPrjcMasterDataTableListRepository.ManhoursPrjcMasterDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch ?? " ",
                        PCostcode = param.Costcode,
                        PStartmonth = startmonth,
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

        public string getStartMonth(string yearmode, string procmonth)
        {
            string startMonth = string.Empty;

            string processingMonth = procmonth.ToString();
            Int32 yyyy = Convert.ToInt32(processingMonth.Substring(0, 4));
            Int32 mm = Convert.ToInt32(processingMonth.Substring(4, 2));
            if (yearmode == "J")
            {
                startMonth = yyyy.ToString() + "01";
            }
            else
            {
                if (mm >= 1 && mm <= 3)
                {
                    startMonth = Convert.ToString(yyyy - 1) + "04";
                }
                else
                {
                    startMonth = yyyy.ToString() + "04";
                }
            }
            return startMonth;
        }

        #endregion Index

        #region Projections list

        public async Task<IActionResult> ManhoursProjectionsCurrentJobsDetailList(string costcode, string projno, string projnoname)
        {
            ViewData["Project"] = projno;
            ViewData["ProjectName"] = projnoname;

            var costCodeName = await _rapReportingRepository.CostcodeNameAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
                PCostcode = costcode
            });
            ViewData["Costcode"] = costcode;
            ViewData["CostcodeName"] = costCodeName.PName;

            return PartialView("_ModalManhoursProjectionsCurrentJobsDetailPartial");
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsManhoursProjectionsCurrentJobsDetail(DTParameters param)
        {
            DTResult<ManhoursProjectionsCurrentJobsDetailDataTableList> result = new();
            int totalRow = 0;
            try
            {
                System.Collections.Generic.IEnumerable<ManhoursProjectionsCurrentJobsDetailDataTableList> data = await _manhoursPrjcJobDetailsDataTableListRepository.ManhoursPrjcJobDetailsDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch ?? " ",
                        PCostcode = param.Costcode,
                        PProjno = param.Projno,
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

        #endregion Projections list

        #region CRUD

        public async Task<IActionResult> ManhoursProjectionsCurrentJobsProjectionsCreate(string costcode, string projno)
        {
            ManhoursProjectionsCurrentJobsCreateViewModel manhoursProjectionsCurrentJobsCreateViewModel = new();

            manhoursProjectionsCurrentJobsCreateViewModel.Costcode = costcode;
            manhoursProjectionsCurrentJobsCreateViewModel.Projno = projno;
            //manhoursProjectionsCurrentJobsViewModel.Yymm = dat.AddMonths(addMonths).ToString("yyyy") + dat.AddMonths(addMonths).ToString("MM");

            //check revcdate
            var projRecvdate = await _projmastDetailRepository.ProjmastDetailAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
                PProjno = manhoursProjectionsCurrentJobsCreateViewModel.Projno
            });

            if (projRecvdate?.PRevcdate == null)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage("Project revised closing date is blank"));
            }

            // get yymm
            var yymm = await _selectTcmPLRepository.ManhoursProjectionsCurrentJobsYymmAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
                PProjno = projno,
                PCostcode = costcode
            });

            if (yymm.Count() == 0)
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage("Cannot create as Projections have been made till Project revised closing date " + projRecvdate.PRevcdate.Value.Year.ToString() + projRecvdate.PRevcdate.Value.Month.ToString().PadLeft(2, '0')));

            ViewData["Yymm"] = new SelectList(yymm, "DataValueField", "DataTextField");

            //proj desc
            var projName = await _rapReportingRepository.ProjmastNameAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
                PProjno = projno
            });
            ViewData["Project"] = projno;
            ViewData["ProjectName"] = projName.PName;

            //costcode desc
            var costCodeName = await _rapReportingRepository.CostcodeNameAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
                PCostcode = costcode
            });
            ViewData["Costcode"] = costcode;
            ViewData["CostcodeName"] = costCodeName.PName;

            return PartialView("_ModalManhoursProjectionsCurrentJobsCreatePartial", manhoursProjectionsCurrentJobsCreateViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> ManhoursProjectionsCurrentJobsCreate([FromForm] ManhoursProjectionsCurrentJobsCreateViewModel manhoursProjectionsCurrentJobsCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    #region project recvdate check

                    var projRecvdate = await _projmastDetailRepository.ProjmastDetailAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL
                    {
                        PProjno = manhoursProjectionsCurrentJobsCreateViewModel.Projno
                    });

                    if (projRecvdate?.PRevcdate == null)
                    {
                        throw new Exception("Project revised closing date is blank");
                    }
                    else if (int.Parse(manhoursProjectionsCurrentJobsCreateViewModel.Yymm) > int.Parse(projRecvdate.PRevcdate.Value.Year.ToString() + projRecvdate.PRevcdate.Value.Month.ToString().PadLeft(2, '0')))
                    {
                        throw new Exception("Yymm " + manhoursProjectionsCurrentJobsCreateViewModel.Yymm + " is later than Project revised closing date " + projRecvdate.PRevcdate.Value.Year.ToString() + projRecvdate.PRevcdate.Value.Month.ToString().PadLeft(2, '0'));
                    }

                    #endregion project recvdate check

                    ProcessMonthDetails month = await _processingMonthDetailRepository.ProcessingMonthDetail(BaseSpTcmPLGet(), new ParameterSpTcmPL
                    {
                        PSchemaname = Schemaname
                    });

                    string dt1 = DateTime.ParseExact(manhoursProjectionsCurrentJobsCreateViewModel.Yymm, "yyyyMM", CultureInfo.InvariantCulture).ToString("yyyy-MM-dd");
                    string dt2 = DateTime.ParseExact(month.PProcMonth, "yyyyMM", CultureInfo.InvariantCulture).ToString("yyyy-MM-dd");

                    if (Convert.ToDateTime(dt1) >= Convert.ToDateTime(dt2))
                    {
                        Domain.Models.Common.DBProcMessageOutput result = await _manhoursProjectionsCurrentJobsProjectRepository.CreateManhoursProjectionsCurrentJobAsync(
                         BaseSpTcmPLGet(),
                         new ParameterSpTcmPL
                         {
                             PCostcode = manhoursProjectionsCurrentJobsCreateViewModel.Costcode,
                             PProjno = manhoursProjectionsCurrentJobsCreateViewModel.Projno,
                             PYymm = manhoursProjectionsCurrentJobsCreateViewModel.Yymm,
                             PHours = manhoursProjectionsCurrentJobsCreateViewModel.Hours
                         });

                        return result.PMessageType == NotOk
                            ? throw new Exception(result.PMessageText.Replace("-", " "))
                            : (IActionResult)Json(new { success = true, response = result.PMessageText });
                    }
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            return PartialView("_ModalManhoursProjectionsCurrentJobsCreatePartial", manhoursProjectionsCurrentJobsCreateViewModel);
        }

        public async Task<IActionResult> UpdateManhoursProjectionsCurrentJobs(string costcode, string projno, string yymm, decimal hours)
        {
            ManhoursProjectionsCurrentJobsUpdateViewModel manhoursProjectionsCurrentJobsUpdateViewModel = new ManhoursProjectionsCurrentJobsUpdateViewModel();
            manhoursProjectionsCurrentJobsUpdateViewModel.Costcode = costcode;
            manhoursProjectionsCurrentJobsUpdateViewModel.Projno = projno;
            manhoursProjectionsCurrentJobsUpdateViewModel.Yymm = yymm;
            manhoursProjectionsCurrentJobsUpdateViewModel.Hours = hours;

            var projName = await _rapReportingRepository.ProjmastNameAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
                PProjno = projno
            });
            ViewData["Project"] = projno;
            ViewData["ProjectName"] = projName.PName;

            var costCodeName = await _rapReportingRepository.CostcodeNameAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
                PCostcode = costcode
            });
            ViewData["Costcode"] = costcode;
            ViewData["CostcodeName"] = costCodeName.PName;

            return PartialView("_ModalManhoursProjectionsCurrentJobsEditPartial", manhoursProjectionsCurrentJobsUpdateViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> UpdateManhoursProjectionsCurrentJobs([FromForm] ManhoursProjectionsCurrentJobsUpdateViewModel manhoursProjectionsCurrentJobsUpdateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    ProcessMonthDetails month = await _processingMonthDetailRepository.ProcessingMonthDetail(BaseSpTcmPLGet(), new ParameterSpTcmPL
                    {
                        PSchemaname = Schemaname
                    });

                    string dt1 = DateTime.ParseExact(manhoursProjectionsCurrentJobsUpdateViewModel.Yymm, "yyyyMM", CultureInfo.InvariantCulture).ToString("yyyy-MM-dd");
                    string dt2 = DateTime.ParseExact(month.PProcMonth, "yyyyMM", CultureInfo.InvariantCulture).ToString("yyyy-MM-dd");

                    if (Convert.ToDateTime(dt1) >= Convert.ToDateTime(dt2))
                    {
                        Domain.Models.Common.DBProcMessageOutput result = await _manhoursProjectionsCurrentJobsProjectRepository.UpdateManhoursProjectionsCurrentJobAsync(
                         BaseSpTcmPLGet(),
                         new ParameterSpTcmPL
                         {
                             PCostcode = manhoursProjectionsCurrentJobsUpdateViewModel.Costcode,
                             PProjno = manhoursProjectionsCurrentJobsUpdateViewModel.Projno,
                             PYymm = manhoursProjectionsCurrentJobsUpdateViewModel.Yymm,
                             PHours = manhoursProjectionsCurrentJobsUpdateViewModel.Hours
                         });

                        return result.PMessageType == NotOk
                            ? throw new Exception(result.PMessageText.Replace("-", " "))
                            : (IActionResult)Json(new { success = true, response = result.PMessageText });
                    }
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            return PartialView("_ModalManhoursProjectionsCurrentJobsEditPartial", manhoursProjectionsCurrentJobsUpdateViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> ManhoursProjectionsCurrentJobsDelete(string costcode, string projno, string yymm, decimal hours)
        {
            try
            {
                Domain.Models.Common.DBProcMessageOutput result = await _manhoursProjectionsCurrentJobsProjectRepository.DeleteManhoursProjectionsCurrentJobAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PCostcode = costcode,
                        PProjno = projno,
                        PYymm = yymm,
                    }
                    );

                return Json(new { success = result.PMessageType == IsOk, response = result.PMessageType, message = result.PMessageText });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        public async Task<IActionResult> ManhoursProjectionsCurrentJobsProjectCreate()
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

            ManhoursProjectionsCurrentJobsProjectModel manhoursProjectionsCurrentJobsProjectModel = new()
            {
                Costcode = filterDataModel.CostCode
            };

            var projects = await _selectTcmPLRepository.SelectProjnoRapReportingProco(BaseSpTcmPLGet(), null);
            ViewData["Projects"] = new SelectList(projects, "DataValueField", "DataTextField");

            return PartialView("_ModalManhoursProjectionsCurrentJobsProjectCreatePartial", manhoursProjectionsCurrentJobsProjectModel);
        }

        [HttpPost]
        public async Task<IActionResult> ManhoursProjectionsCurrentJobsProjectCreate([FromForm] ManhoursProjectionsCurrentJobsProjectModel manhoursProjectionsCurrentJobsProjectModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    ProcessMonthDetails month = await _processingMonthDetailRepository.ProcessingMonthDetail(BaseSpTcmPLGet(), new ParameterSpTcmPL
                    {
                        PSchemaname = Schemaname
                    });

                    Domain.Models.Common.DBProcMessageOutput result = await _manhoursProjectionsCurrentJobsProjectRepository.CreateManhoursProjectionsCurrentJobsProjectAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PCostcode = manhoursProjectionsCurrentJobsProjectModel.Costcode,
                            PProjno = manhoursProjectionsCurrentJobsProjectModel.Projno,
                            PYymm = month.PProcMonth,
                            PHours = 0
                        });

                    return result.PMessageType == NotOk
                        ? throw new Exception(result.PMessageText.Replace("-", " "))
                        : (IActionResult)Json(new { success = true, response = result.PMessageText });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            var projects = await _selectTcmPLRepository.SelectProjnoRapReportingProco(BaseSpTcmPLGet(), null);
            ViewData["Projects"] = new SelectList(projects, "DataValueField", "DataTextField", manhoursProjectionsCurrentJobsProjectModel.Projno);

            return PartialView("_ModalManhoursProjectionsCurrentJobsProjectCreatePartial", manhoursProjectionsCurrentJobsProjectModel);
        }

        public async Task<IActionResult> ManhoursProjectionsCurrentJobsProjectionsCreateBulk(string costcode, string projno)
        {
            //check revcdate
            var projRecvdate = await _projmastDetailRepository.ProjmastDetailAsync(
            BaseSpTcmPLGet(),
            new ParameterSpTcmPL
            {
                PProjno = projno
            });
            if (projRecvdate?.PRevcdate == null)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage("Project revised closing date is blank"));
            }

            var canCreate = await _manhoursProjectionsCurrentJobsCanCreateRepository.ManhoursProjectionsCurrentJobsCanCreateAsync(
                   BaseSpTcmPLGet(),
                   new ParameterSpTcmPL
                   {
                       PProjno = projno,
                       PCostcode = costcode
                   });
            if (canCreate.PResult == "false")
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage("Cannot create as Projections have been made till Project revised closing date " + projRecvdate.PRevcdate.Value.Year.ToString() + projRecvdate.PRevcdate.Value.Month.ToString().PadLeft(2, '0')));
            }

            ManhoursProjectionsCurrentJobsCreateBulkModel manhoursProjectionsCurrentJobsCreateBulkModel = new()
            {
                Costcode = costcode,
                Projno = projno,
                Months = 1,
                Hours = 0
            };

            var projName = await _rapReportingRepository.ProjmastNameAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PProjno = projno
                    });
            ViewData["Project"] = projno;
            ViewData["ProjectName"] = projName.PName;

            var costCodeName = await _rapReportingRepository.CostcodeNameAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PCostcode = costcode
                    });
            ViewData["Costcode"] = costcode;
            ViewData["CostcodeName"] = costCodeName.PName;

            return PartialView("_ModalManhoursProjectionsCurrentJobsCreateBulkPartial", manhoursProjectionsCurrentJobsCreateBulkModel);
        }

        [HttpPost]
        public async Task<IActionResult> ManhoursProjectionsCurrentJobsProjectionsCreateBulk([FromForm] ManhoursProjectionsCurrentJobsCreateBulkModel manhoursProjectionsCurrentJobsCreateBulkModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    #region get first month

                    var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
                    {
                        PModuleName = CurrentUserIdentity.CurrentModule,
                        PMetaId = CurrentUserIdentity.MetaId,
                        PPersonId = CurrentUserIdentity.EmployeeId,
                        PMvcActionName = ConstFilterRapIndex
                    });
                    FilterDataModel filterDataModel;
                    filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

                    DTResult<ManhoursProjectionsCurrentJobsCreateViewModel> result = new DTResult<ManhoursProjectionsCurrentJobsCreateViewModel>();

                    int totalRow = 0;
                    var dat = new DateTime();
                    short addMonths = 0;

                    System.Collections.Generic.IEnumerable<ManhoursProjectionsCurrentJobsDetailDataTableList> data1 = await _manhoursPrjcJobDetailsDataTableListRepository.ManhoursPrjcJobDetailsDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = filterDataModel.GenericSearch ?? " ",
                        PCostcode = manhoursProjectionsCurrentJobsCreateBulkModel.Costcode,
                        PProjno = manhoursProjectionsCurrentJobsCreateBulkModel.Projno,
                        PRowNumber = 0,
                        PPageLength = 999999
                    }
                );
                    ProcessMonthDetails month = await _processingMonthDetailRepository.ProcessingMonthDetail(BaseSpTcmPLGet(), new ParameterSpTcmPL
                    {
                        PSchemaname = Schemaname
                    });
                    if (data1.Any())
                    {
                        totalRow = (int)data1.Count();
                        result.data = data1.OrderBy(x => x.Yymm)
                                            .Select(x => new Models.ManhoursProjectionsCurrentJobsCreateViewModel
                                            {
                                                Costcode = x.Costcode,
                                                Projno = x.Projno,
                                                Yymm = x.Yymm,
                                                Hours = x.Hours
                                            }).ToList();
                        dat = new DateTime(Int16.Parse(result.data.ElementAt(totalRow - 1).Yymm.Substring(0, 4)), Int16.Parse(result.data.ElementAt(totalRow - 1).Yymm.Substring(4, 2)), 1);
                        addMonths++;
                    }
                    else
                    {
                        dat = new DateTime(Int16.Parse(month.PProcMonth.Substring(0, 4)), Int16.Parse(month.PProcMonth.Substring(4, 2)), 1);
                    }

                    #endregion get first month

                    #region check Recv Date

                    var projRecvdate = await _projmastDetailRepository.ProjmastDetailAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL
                    {
                        PProjno = manhoursProjectionsCurrentJobsCreateBulkModel.Projno
                    });

                    if (projRecvdate?.PRevcdate == null)
                    {
                        throw new Exception("Project revised closing date is blank");
                    }
                    else if (int.Parse(dat.AddMonths(manhoursProjectionsCurrentJobsCreateBulkModel.Months).ToString("yyyy") + dat.AddMonths(manhoursProjectionsCurrentJobsCreateBulkModel.Months).ToString("MM")) > int.Parse(projRecvdate.PRevcdate.Value.Year.ToString() + projRecvdate.PRevcdate.Value.Month.ToString().PadLeft(2, '0')))
                    {
                        throw new Exception("Yymm " + dat.AddMonths(manhoursProjectionsCurrentJobsCreateBulkModel.Months).ToString("yyyy") + dat.AddMonths(manhoursProjectionsCurrentJobsCreateBulkModel.Months).ToString("MM") + " is later than Project revised closing date " + projRecvdate.PRevcdate.Value.Year.ToString() + projRecvdate.PRevcdate.Value.Month.ToString().PadLeft(2, '0'));
                    }

                    #endregion check Recv Date

                    Domain.Models.Common.DBProcMessageOutput result1 = null;
                    int mm = 0;
                    for (int i = 0; i < manhoursProjectionsCurrentJobsCreateBulkModel.Months; i++)
                    {
                        if (i == 0)
                        {
                            mm = addMonths;
                        }
                        else
                        {
                            mm = mm + 1;
                        }

                        result1 = await _manhoursProjectionsCurrentJobsProjectRepository.CreateManhoursProjectionsCurrentJobAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PCostcode = manhoursProjectionsCurrentJobsCreateBulkModel.Costcode,
                            PProjno = manhoursProjectionsCurrentJobsCreateBulkModel.Projno,
                            PYymm = dat.AddMonths(mm).ToString("yyyy") + dat.AddMonths(mm).ToString("MM"),
                            PHours = manhoursProjectionsCurrentJobsCreateBulkModel.Hours
                        });
                        if (result1.PMessageType == NotOk)
                        {
                            throw new Exception(result1.PMessageText.Replace("-", " "));
                        }
                    }
                    return Json(new { success = true, response = result1.PMessageText });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            return PartialView("_ModalManhoursProjectionsCurrentJobsCreateBulkPartial", manhoursProjectionsCurrentJobsCreateBulkModel);
        }

        #endregion CRUD

        #region Excel import

        [HttpGet]
        public async Task<IActionResult> ManhoursProjectionsCurrentJobsImport(string costcode, string projno)
        {
            var projName = await _rapReportingRepository.ProjmastNameAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
                PProjno = projno
            });
            ViewData["Project"] = projno;
            ViewData["ProjectName"] = projName.PName;

            var costCodeName = await _rapReportingRepository.CostcodeNameAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
                PCostcode = costcode
            });
            ViewData["Costcode"] = costcode;
            ViewData["CostcodeName"] = costCodeName.PName;

            return PartialView("_ModalManhoursProjectionsCurrentJobsEditImportPartial");
        }

        public async Task<IActionResult> ManhoursProjectionsCurrentJobsXLTemplate(string costcode, string projno)
        {
            if (costcode == null || projno == null)
            {
                return NotFound();
            }

            var dictionaryItems = new List<Library.Excel.Template.Models.DictionaryItem>();

            Stream ms = _excelTemplate.ExportProjectionsCurrentJobs("v01", new Library.Excel.Template.Models.DictionaryCollection
            {
                DictionaryItems = dictionaryItems
            },
                500);
            var fileName = "ImportProjectionsCurrentJobs.xlsx";
            var mimeType = MimeTypeMap.GetMimeType("xlsx");

            ms.Position = 0;
            //DataTable dt = new DataTable();

            ManhoursProjectionsCurrentJobsDetailModel manhoursProjectionsCurrentJobsDetailModel = new ManhoursProjectionsCurrentJobsDetailModel();

            var data = await _manhoursPrjcJobDetailsForExcelDataTableListRepository.ManhoursPrjcJobDetailsForTemplateDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PCostcode = costcode,
                        PProjno = projno,
                        PRowNumber = 0,
                        PPageLength = 999999
                    }
                );
            var result = data.OrderBy(x => x.Yymm).ToList();

            //var result = manhoursProjectionsCurrentJobsDetailModel.Data.value.OrderBy(x => x.Yymm).ToList(); ;

            using XLWorkbook wb = new(ms);
            _ = wb.Worksheet(1).Cell(2, 1).InsertData(result);
            using MemoryStream stream = new();
            wb.SaveAs(stream);
            _ = wb.Protect("qw8po2TY5vbJ0Gd1sa");
            _ = wb.Worksheet(1).Column(4).Style.Protection.SetLocked(false);
            stream.Position = 0;
            return File(stream.ToArray(),
                       "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                       fileName);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ManhoursProjectionsCurrentJobsXLTemplateUpload(string costcode, string projno, IFormFile file)
        {
            try
            {
                if (file == null || file.Length == 0)
                {
                    return Json(new { success = false, response = "File not uploaded due to an error" });
                }

                FileInfo fileInfo = new(file.FileName);

                Guid storageId = Guid.NewGuid();
                var stream = file.OpenReadStream();
                var fileName = file.FileName;
                var fileSize = file.Length;
                var mimeType = MimeTypeMap.GetMimeType(fileInfo.Extension);

                // Check file validation
                if (!fileInfo.Extension.Contains("xls"))
                {
                    return Json(new { success = false, response = "Excel file not recognized" });
                }

                // Try to convert stream to a class

                string json = string.Empty;

                // Call database json stored procedure

                List<Library.Excel.Template.Models.ManhoursProjections> manhoursProjections = _excelTemplate.ImportProjectionsCurrentJobs(stream);

                string[] aryProjections = manhoursProjections.Select(p =>
                                                            p.Costcode + "~!~" +
                                                            p.Projno + "~!~" +
                                                            p.Yymm + "~!~" +
                                                            p.Hours).ToArray();

                var uploadOutPut = await _manhoursProjectionsCurrentJobsImportRepository.ImportProjectionsAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PCostcode = costcode,
                            PProjno = projno,
                            PProjections = aryProjections
                        }
                    );

                List<ImportFileResultViewModel> importFileResults = new();

                if (uploadOutPut.PProjectionsErrors?.Length > 0)
                {
                    foreach (string err in uploadOutPut.PProjectionsErrors)
                    {
                        string[] aryErr = err.Split("~!~");
                        importFileResults.Add(new ImportFileResultViewModel
                        {
                            ErrorType = (TCMPLApp.WebApp.Models.ImportFileValidationErrorTypeEnum)Enum.Parse(typeof(TCMPLApp.WebApp.Models.ImportFileValidationErrorTypeEnum), aryErr[5], true),
                            ExcelRowNumber = int.Parse(aryErr[2]),
                            FieldName = aryErr[3],
                            Id = int.Parse(aryErr[0]),
                            Section = aryErr[1],
                            Message = aryErr[6],
                        });
                    }
                }

                List<Library.Excel.Template.Models.ValidationItem> validationItems = new();

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
                            response = uploadOutPut.PMessageText,
                            data = importFileResults,
                            fileContent = fileContentResult
                        };

                        return Json(resultJsonError);
                    }
                    else
                    {
                        var resultJsonError = new
                        {
                            success = false,
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

        #endregion Excel import

        #endregion Manhours projections current jobs

        #region Manhours projections expected jobs

        #region Index

        public async Task<IActionResult> ManhoursProjectionsExpectedJobsIndex()
        {
            if (!(CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionCostCodeEdit) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionHoDFormsEdit) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionProcoMastersEdit) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionProcoTrans)))
            {
                return Forbid();
            }

            return await CommonIndex();
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsManhoursProjectionsExpectedJobs(DTParameters param)
        {
            int totalRow = 0;

            DTResult<ExptJobsDataTableList> result = new DTResult<ExptJobsDataTableList>();

            try
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

                var data = await _exptJobsDataTableListRepository.ExptJobsDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
                        PCostcode = filterDataModel.CostCode,
                        PGenericSearch = param.GenericSearch ?? " "
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

        #endregion Index

        #region Projections list

        public async Task<IActionResult> ManhoursProjectionsExpectedJobsDetailList(string costcode, string projno, string projnoname)
        {
            ViewData["Project"] = projno;
            ViewData["ProjectName"] = projnoname;

            var costCodeName = await _rapReportingRepository.CostcodeNameAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PCostcode = costcode
                    });
            ViewData["Costcode"] = costcode;
            ViewData["CostcodeName"] = costCodeName.PName;

            //Get Expected job lock status
            var result = await _expectedJobsDetailsRepository.ExpectedJobsDetailsAsync(
                          BaseSpTcmPLGet(), new ParameterSpTcmPL { PProjno = projno });

            if (result.PMessageType != IsOk)
            {
                throw new Exception(result.PMessageText.Replace("-", " "));
            }
            ViewData["Lck"] = result.PLck;
            //Get Expected job lock status

            return PartialView("_ModalManhoursProjectionsExpectedJobsDetailPartial");
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsManhoursProjectionsExpectedJobsDetail(DTParameters param)
        {
            int totalRow = 0;

            DTResult<ExptPrjcDataTableList> result = new DTResult<ExptPrjcDataTableList>();

            try
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

                var data = await _exptPrjcDataTableListRepository.ExptPrjcDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
                        PCostcode = filterDataModel.CostCode,
                        PProjno = param.Projno
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

        #endregion Projections list

        #region CRUD

        public async Task<IActionResult> ManhoursProjectionsExpectedJobsProjectionsCreate(string costcode, string projno)
        {
            ManhoursProjectionsExpectedJobsViewModel manhoursProjectionsExpectedJobsViewModel = new()
            {
                Costcode = costcode,
                Projno = projno
            };

            // get yymm
            var yymm = await _selectTcmPLRepository.ManhoursProjectionsExpectedJobsYymmAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PProjno = projno,
                    PCostcode = costcode
                });
            ViewData["Yymm"] = new SelectList(yymm, "DataValueField", "DataTextField");

            var projName = await _rapReportingRepository.ExpectedProjmastNameAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PProjno = projno
                    });
            ViewData["Project"] = projno;
            ViewData["ProjectName"] = projName.PName;

            var costCodeName = await _rapReportingRepository.CostcodeNameAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PCostcode = costcode
                    });
            ViewData["Costcode"] = costcode;
            ViewData["CostcodeName"] = costCodeName.PName;

            return PartialView("_ModalManhoursProjectionsExpectedJobsCreatePartial", manhoursProjectionsExpectedJobsViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> ManhoursProjectionsExpectedJobsCreate([FromForm] ManhoursProjectionsExpectedJobsViewModel manhoursProjectionsExpectedJobsViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    DBProcMessageOutput result = await _exptPrjcRepository.CreateExptPrjcAsync(
                    BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PCostcode = manhoursProjectionsExpectedJobsViewModel.Costcode,
                            PProjno = manhoursProjectionsExpectedJobsViewModel.Projno,
                            PYymm = manhoursProjectionsExpectedJobsViewModel.Yymm,
                            PHours = manhoursProjectionsExpectedJobsViewModel.Hours
                        });

                    return result.PMessageType == NotOk
                         ? throw new Exception(result.PMessageText.Replace("-", " "))
                         : (IActionResult)Json(new { success = true, response = result.PMessageText });
                }
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
            }

            return PartialView("_ModalManhoursProjectionsExpectedJobsCreatePartial", manhoursProjectionsExpectedJobsViewModel);
        }

        public async Task<IActionResult> UpdateManhoursProjectionsExpectedJobs(string costcode, string projno, string yymm, decimal hours)
        {
            ManhoursProjectionsExpectedJobsViewModel manhoursProjectionsExpectedJobsViewModel = new()
            {
                Costcode = costcode,
                Projno = projno,
                Yymm = yymm,
                Hours = hours
            };

            var projName = await _rapReportingRepository.ExpectedProjmastNameAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PProjno = projno
                    });
            ViewData["Project"] = projno;
            ViewData["ProjectName"] = projName.PName;

            var costCodeName = await _rapReportingRepository.CostcodeNameAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PCostcode = costcode
                    });
            ViewData["Costcode"] = costcode;
            ViewData["CostcodeName"] = costCodeName.PName;

            return PartialView("_ModalManhoursProjectionsExpectedJobsEditPartial", manhoursProjectionsExpectedJobsViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> UpdateManhoursProjectionsExpectedJobs([FromForm] ManhoursProjectionsExpectedJobsViewModel manhoursProjectionsExpectedJobsViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    DBProcMessageOutput result = await _exptPrjcRepository.UpdateExptPrjcAsync(
                    BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PCostcode = manhoursProjectionsExpectedJobsViewModel.Costcode,
                            PProjno = manhoursProjectionsExpectedJobsViewModel.Projno,
                            PYymm = manhoursProjectionsExpectedJobsViewModel.Yymm,
                            PHours = manhoursProjectionsExpectedJobsViewModel.Hours
                        });

                    return result.PMessageType == NotOk
                         ? throw new Exception(result.PMessageText.Replace("-", " "))
                         : (IActionResult)Json(new { success = true, response = result.PMessageText });
                }
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
            }

            return PartialView("_ModalManhoursProjectionsExpectedJobsEditPartial", manhoursProjectionsExpectedJobsViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> ManhoursProjectionsExpectedJobsDelete(string costcode, string projno, string yymm, decimal hours)
        {
            try
            {
                DBProcMessageOutput result = await _exptPrjcRepository.DeleteExptPrjcAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PCostcode = costcode,
                        PProjno = projno,
                        PYymm = yymm
                    });

                if (result.PMessageType != "OK")
                {
                    throw new Exception(result.PMessageText.Replace("-", " "));
                }
                return Json(new { success = result.PMessageType == IsOk, response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        public async Task<IActionResult> ManhoursProjectionsExpectedJobsProjectCreate()
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

            ManhoursProjectionsExpectedJobsProjectModel manhoursProjectionsExpectedJobsProjectModel = new()
            {
                Costcode = filterDataModel.CostCode
            };

            var projects = await _selectTcmPLRepository.SelectExpectedProjnoRapReporting(BaseSpTcmPLGet(), null);
            ViewData["Projects"] = new SelectList(projects, "DataValueField", "DataTextField");

            return PartialView("_ModalManhoursProjectionsExpectedJobsProjectCreatePartial", manhoursProjectionsExpectedJobsProjectModel);
        }

        [HttpPost]
        public async Task<IActionResult> ManhoursProjectionsExpectedJobsProjectCreate([FromForm] ManhoursProjectionsExpectedJobsProjectModel manhoursProjectionsExpectedJobsProjectModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    DBProcMessageOutput result = await _exptPrjcRepository.CreateJobExptPrjcAsync(
                    BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PCostcode = manhoursProjectionsExpectedJobsProjectModel.Costcode,
                            PProjno = manhoursProjectionsExpectedJobsProjectModel.Projno
                        });

                    return result.PMessageType == NotOk
                         ? throw new Exception(result.PMessageText.Replace("-", " "))
                         : (IActionResult)Json(new { success = true, response = result.PMessageText });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            var projects = await _selectTcmPLRepository.SelectExpectedProjnoRapReporting(BaseSpTcmPLGet(), null);
            ViewData["Projects"] = new SelectList(projects, "DataValueField", "DataTextField");

            //return PartialView("_ModalManhoursProjectionsExpectedJobsProjectCreatePartial", manhoursProjectionsExpectedJobsProjectModel);
            return RedirectToAction("ManhoursProjectionsExpectedJobsIndex");
        }

        public async Task<IActionResult> ManhoursProjectionsExpectedJobsProjectionsCreateBulk(string costcode, string projno)
        {
            ManhoursProjectionsExpectedJobsCreateBulkModel manhoursProjectionsExpectedJobsCreateBulkModel = new()
            {
                Costcode = costcode,
                Projno = projno,
                Months = 1,
                Hours = 0
            };

            var projName = await _rapReportingRepository.ExpectedProjmastNameAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PProjno = projno
                    });
            ViewData["Project"] = projno;
            ViewData["ProjectName"] = projName.PName;

            var costCodeName = await _rapReportingRepository.CostcodeNameAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PCostcode = costcode
                    });
            ViewData["Costcode"] = costcode;
            ViewData["CostcodeName"] = costCodeName.PName;

            return PartialView("_ModalManhoursProjectionsExpectedJobsCreateBulkPartial", manhoursProjectionsExpectedJobsCreateBulkModel);
        }

        [HttpPost]
        public async Task<IActionResult> ManhoursProjectionsExpectedJobsProjectionsCreateBulk([FromForm] ManhoursProjectionsExpectedJobsCreateBulkModel manhoursProjectionsExpectedJobsCreateBulkModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    DBProcMessageOutput result = await _exptPrjcRepository.CreateExptPrjcBulkAsync(
                    BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PCostcode = manhoursProjectionsExpectedJobsCreateBulkModel.Costcode,
                            PProjno = manhoursProjectionsExpectedJobsCreateBulkModel.Projno,
                            PNumberOfMonths = manhoursProjectionsExpectedJobsCreateBulkModel.Months,
                            PHours = manhoursProjectionsExpectedJobsCreateBulkModel.Hours
                        });

                    return result.PMessageType == NotOk
                         ? throw new Exception(result.PMessageText.Replace("-", " "))
                         : (IActionResult)Json(new { success = true, response = result.PMessageText });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            return PartialView("_ModalManhoursProjectionsExpectedJobsCreateBulkPartial", manhoursProjectionsExpectedJobsCreateBulkModel);
        }

        #endregion CRUD

        #region Excel import

        [HttpGet]
        public async Task<IActionResult> ManhoursProjectionsExpectedJobsImport(string costcode, string projno)
        {
            var projName = await _rapReportingRepository.ExpectedProjmastNameAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PProjno = projno
                    });
            ViewData["Project"] = projno;
            ViewData["ProjectName"] = projName.PName;

            var costCodeName = await _rapReportingRepository.CostcodeNameAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PCostcode = costcode
                    });
            ViewData["Costcode"] = costcode;
            ViewData["CostcodeName"] = costCodeName.PName;

            return PartialView("_ModalManhoursProjectionsExpectedJobsEditImportPartial");
        }

        public async Task<IActionResult> ManhoursProjectionsExpectedJobsXLTemplate(string costcode, string projno)
        {
            if (costcode == null || projno == null)
            {
                return NotFound();
            }

            var dictionaryItems = new List<Library.Excel.Template.Models.DictionaryItem>();

            Stream ms = _excelTemplate.ExportProjectionsCurrentJobs("v01",
                    new Library.Excel.Template.Models.DictionaryCollection
                    {
                        DictionaryItems = dictionaryItems
                    },
                500);
            var fileName = "ImportProjectionsExpectedJobs.xlsx";
            var mimeType = MimeTypeMap.GetMimeType("xlsx");

            ms.Position = 0;
            DataTable dt = new();

            DTResult<ExptPrjcDataTableList> result = new DTResult<ExptPrjcDataTableList>();
            var data = await _exptPrjcDataTableListRepository.ExptPrjcDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = 0,
                        PPageLength = 100000,
                        PCostcode = costcode,
                        PProjno = projno
                    }
                );
            result.data = data.ToList();

            dt.Columns.Add("Cost code");
            dt.Columns.Add("Projno");
            dt.Columns.Add("Yymm");
            dt.Columns.Add("Hours");

            foreach (var item in data.Select(s => new { s.Costcode, s.Projno, s.Yymm, s.Hours }))
            {
                dt.Rows.Add(item.Costcode, item.Projno, item.Yymm, item.Hours);
            };

            using XLWorkbook wb = new(ms);
            _ = wb.Worksheet(1).Cell(2, 1).InsertData(dt);
            using MemoryStream stream = new();
            wb.SaveAs(stream);
            _ = wb.Protect("qw8po2TY5vbJ0Gd1sa");
            _ = wb.Worksheet(1).Column(4).Style.Protection.SetLocked(false);
            stream.Position = 0;
            return File(stream.ToArray(),
                       "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                       fileName);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ManhoursProjectionsExpectedJobsXLTemplateUpload(string costcode, string projno, IFormFile file)
        {
            try
            {
                if (file == null || file.Length == 0)
                {
                    return Json(new { success = false, response = "File not uploaded due to an error" });
                }

                FileInfo fileInfo = new(file.FileName);

                Guid storageId = Guid.NewGuid();
                var stream = file.OpenReadStream();
                var fileName = file.FileName;
                var fileSize = file.Length;
                var mimeType = MimeTypeMap.GetMimeType(fileInfo.Extension);

                // Check file validation
                if (!fileInfo.Extension.Contains("xls"))
                {
                    return Json(new { success = false, response = "Excel file not recognized" });
                }

                // Try to convert stream to a class

                string json = string.Empty;

                // Call database json stored procedure

                List<Library.Excel.Template.Models.ManhoursProjections> manhoursProjections = _excelTemplate.ImportProjectionsCurrentJobs(stream);

                string[] aryProjections = manhoursProjections.Select(p =>
                                                            p.Costcode + "~!~" +
                                                            p.Projno + "~!~" +
                                                            p.Yymm + "~!~" +
                                                            p.Hours).ToArray();

                var uploadOutPut = await _manhoursProjectionsExpectedJobsImportRepository.ImportProjectionsAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PCostcode = costcode,
                            PProjno = projno,
                            PProjections = aryProjections
                        }
                    );

                List<ImportFileResultViewModel> importFileResults = new();

                if (uploadOutPut.PProjectionsErrors?.Length > 0)
                {
                    foreach (string err in uploadOutPut.PProjectionsErrors)
                    {
                        string[] aryErr = err.Split("~!~");
                        importFileResults.Add(new ImportFileResultViewModel
                        {
                            ErrorType = (TCMPLApp.WebApp.Models.ImportFileValidationErrorTypeEnum)Enum.Parse(typeof(TCMPLApp.WebApp.Models.ImportFileValidationErrorTypeEnum), aryErr[5], true),
                            ExcelRowNumber = int.Parse(aryErr[2]),
                            FieldName = aryErr[3],
                            Id = int.Parse(aryErr[0]),
                            Section = aryErr[1],
                            Message = aryErr[6],
                        });
                    }
                }

                List<Library.Excel.Template.Models.ValidationItem> validationItems = new();

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
                            response = uploadOutPut.PMessageText,
                            data = importFileResults,
                            fileContent = fileContentResult
                        };

                        return Json(resultJsonError);
                    }
                    else
                    {
                        var resultJsonError = new
                        {
                            success = false,
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

        //PROCO - import all starts here
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, RapReportingHelper.ActionProcoTrans)]
        public IActionResult ManhoursProjectionsExpectedJobsImportAll()
        {
            return PartialView("_ModalManhoursProjectionsExpectedJobsImportAllPartial");
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, RapReportingHelper.ActionProcoTrans)]
        public async Task<IActionResult> ManhoursProjectionsExpectedJobsXLTemplateAll()
        {
            var dictionaryItems = new List<Library.Excel.Template.Models.DictionaryItem>();

            Stream ms = _excelTemplate.ExportProjectionsCurrentJobs("v01",
                    new Library.Excel.Template.Models.DictionaryCollection
                    {
                        DictionaryItems = dictionaryItems
                    },
                500);
            var fileName = "ImportProjectionsExpectedJobs.xlsx";
            var mimeType = MimeTypeMap.GetMimeType("xlsx");

            ms.Position = 0;
            DataTable dt = new();

            DTResult<ExptPrjcDataTableList> result = new DTResult<ExptPrjcDataTableList>();
            var data = await _exptPrjcDataTableListRepository.ExptPrjcAllDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = 0,
                        PPageLength = 100000
                    }
                );
            result.data = data.ToList();

            dt.Columns.Add("Cost code");
            dt.Columns.Add("Projno");
            dt.Columns.Add("Yymm");
            dt.Columns.Add("Hours");

            foreach (var item in data.Select(s => new { s.Costcode, s.Projno, s.Yymm, s.Hours }))
            {
                dt.Rows.Add(item.Costcode, item.Projno, item.Yymm, item.Hours);
            };

            using XLWorkbook wb = new(ms);
            _ = wb.Worksheet(1).Cell(2, 1).InsertData(dt);
            using MemoryStream stream = new();
            wb.SaveAs(stream);
            _ = wb.Protect("qw8po2TY5vbJ0Gd1sa");
            _ = wb.Worksheet(1).Column(4).Style.Protection.SetLocked(false);
            stream.Position = 0;
            return File(stream.ToArray(),
                       "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                       fileName);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, RapReportingHelper.ActionProcoTrans)]
        public async Task<IActionResult> ManhoursProjectionsExpectedJobsXLTemplateUploadAll(IFormFile file)
        {
            try
            {
                if (file == null || file.Length == 0)
                {
                    return Json(new { success = false, response = "File not uploaded due to an error" });
                }

                FileInfo fileInfo = new(file.FileName);

                Guid storageId = Guid.NewGuid();
                var stream = file.OpenReadStream();
                var fileName = file.FileName;
                var fileSize = file.Length;
                var mimeType = MimeTypeMap.GetMimeType(fileInfo.Extension);

                // Check file validation
                if (!fileInfo.Extension.Contains("xls"))
                {
                    return Json(new { success = false, response = "Excel file not recognized" });
                }

                // Try to convert stream to a class

                string json = string.Empty;

                // Call database json stored procedure

                List<Library.Excel.Template.Models.ManhoursProjections> manhoursProjections = _excelTemplate.ImportProjectionsCurrentJobs(stream);

                string[] aryProjections = manhoursProjections.Select(p =>
                                                            p.Costcode + "~!~" +
                                                            p.Projno + "~!~" +
                                                            p.Yymm + "~!~" +
                                                            p.Hours).ToArray();

                var uploadOutPut = await _manhoursProjectionsExpectedJobsImportRepository.ImportProjectionsAllAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PProjections = aryProjections
                        }
                    );

                List<ImportFileResultViewModel> importFileResults = new();

                if (uploadOutPut.PProjectionsErrors?.Length > 0)
                {
                    foreach (string err in uploadOutPut.PProjectionsErrors)
                    {
                        string[] aryErr = err.Split("~!~");
                        importFileResults.Add(new ImportFileResultViewModel
                        {
                            ErrorType = (TCMPLApp.WebApp.Models.ImportFileValidationErrorTypeEnum)Enum.Parse(typeof(TCMPLApp.WebApp.Models.ImportFileValidationErrorTypeEnum), aryErr[5], true),
                            ExcelRowNumber = int.Parse(aryErr[2]),
                            FieldName = aryErr[3],
                            Id = int.Parse(aryErr[0]),
                            Section = aryErr[1],
                            Message = aryErr[6],
                        });
                    }
                }

                List<Library.Excel.Template.Models.ValidationItem> validationItems = new();

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
                            response = uploadOutPut.PMessageText,
                            data = importFileResults,
                            fileContent = fileContentResult
                        };

                        return Json(resultJsonError);
                    }
                    else
                    {
                        var resultJsonError = new
                        {
                            success = false,
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

        //PROCO - import all ends here

        #endregion Excel import

        #endregion Manhours projections expected jobs

        #region Proco Activity

        public async Task<IActionResult> Repost(string yymm)
        {
            try
            {
                var result = await _manageRepository.RePostAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL { PYyyymm = yymm }
                    );

                if (result.PMessageType != IsOk)
                {
                    throw new Exception(result.PMessageText.Replace("-", " "));
                }
                else
                {
                    return Json(new { success = result.PMessageType == IsOk, response = result.PMessageText });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        public async Task<IActionResult> UpdateProcessingMonth(string yymm)
        {
            try
            {
                var result = await _manageRepository.MoveMonthAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL { PYyyymm = yymm }
                    );

                if (result.PMessageType != IsOk)
                {
                    throw new Exception(result.PMessageText.Replace("-", " "));
                }
                else
                {
                    return Json(new { success = result.PMessageType == IsOk, response = result.PMessageText });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        public async Task<IActionResult> UpdateEmployee()
        {
            try
            {
                var result = await _manageRepository.UpdateEmployeeAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL { }
                    );

                if (result.PMessageType != IsOk)
                {
                    throw new Exception(result.PMessageText.Replace("-", " "));
                }
                else
                {
                    return Json(new { success = result.PMessageType == IsOk, response = result.PMessageText });
                }
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        public async Task<IActionResult> RepostAndUpdateProcessingMonth(string yymm)
        {
            try
            {
                var RePostresult = await _manageRepository.RePostAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL { PYyyymm = yymm }
                    );

                if (RePostresult.PMessageType == IsOk)
                {
                    var result = await _manageRepository.MoveMonthAsync(
                   BaseSpTcmPLGet(),
                   new ParameterSpTcmPL { PYyyymm = yymm }
                   );

                    if (result.PMessageType != IsOk)
                    {
                        throw new Exception(result.PMessageText.Replace("-", " "));
                    }
                    else
                    {
                        return Json(new { success = result.PMessageType == IsOk, response = result.PMessageText });
                    }
                }
                else
                {
                    throw new Exception(RePostresult.PMessageText.Replace("-", " "));
                }
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        public async Task<IActionResult> LockRepostAndUpdateProcessingMonth(string yymm)
        {
            try
            {
                var result = await _manageRepository.LockRepostAndUpdateProcessingMonth(
               BaseSpTcmPLGet(),
               new ParameterSpTcmPL()
               );

                if (result.PMessageType != IsOk)
                {
                    throw new Exception(result.PMessageText.Replace("-", " "));
                }
                else
                {
                    return Json(new { success = result.PMessageType == IsOk, response = result.PMessageType, message = result.PMessageText });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        public async Task<IActionResult> UnLockRepostAndUpdateProcessingMonth(string yymm)
        {
            try
            {
                var result = await _manageRepository.UnLockRepostAndUpdateProcessingMonth(
               BaseSpTcmPLGet(),
               new ParameterSpTcmPL()
               );

                if (result.PMessageType != IsOk)
                {
                    throw new Exception(result.PMessageText.Replace("-", " "));
                }
                else
                {
                    return Json(new { success = result.PMessageType == IsOk, response = result.PMessageType, message = result.PMessageText });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        #endregion Proco Activity

        #region Overtime update

        #region Index

        public async Task<IActionResult> OvertimeUpdateIndex()
        {
            if (!(CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionCostCodeEdit) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionHoDFormsEdit) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionProcoMastersEdit) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.RapReporting.RapReportingHelper.ActionProcoTrans)))
            {
                return Forbid();
            }

            return await CommonIndex();
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsOvertimeUpdate(DTParameters param)
        {
            DTResult<OvertimeUpdateDataTableList> result = new();
            //var param = JsonConvert.DeserializeObject<DTParameters>(paramJson);
            int totalRow = 0;

            try
            {
                ProcessMonthDetails month = await _processingMonthDetailRepository.ProcessingMonthDetail(BaseSpTcmPLGet(), new ParameterSpTcmPL
                {
                    PSchemaname = Schemaname
                });

                System.Collections.Generic.IEnumerable<OvertimeUpdateDataTableList> data = await _overtimeUpdateDataTableListRepository.OvertimeUpdateDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch ?? " ",
                        PCostcode = param.Costcode,
                        PYymm = month.PProcMonth,
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

        #endregion Index

        #region CRUD

        public async Task<IActionResult> OvertimeUpdateCreate(string costcode)
        {
            OTUpdateCreateViewModel oTUpdateCreateViewModel = new()
            {
                Costcode = costcode
            };

            // get yymm
            var yymm = await _selectTcmPLRepository.OvertimeUpdateYymmAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
                PCostcode = costcode
            });

            if (!yymm.Any())
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage("Cannot create OT"));
            }

            ViewData["Yymm"] = new SelectList(yymm, "DataValueField", "DataTextField");

            //costcode desc
            var costCodeName = await _rapReportingRepository.CostcodeNameAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
                PCostcode = costcode
            });

            ViewData["Costcode"] = costcode;
            ViewData["CostcodeName"] = costCodeName.PName;

            return PartialView("_ModalOvertimeUpdateCreatePartial", oTUpdateCreateViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> OvertimeUpdateCreate([FromForm] OTUpdateCreateViewModel oTUpdateCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _overtimeUpdateRepository.CreateOvertimeUpdateAsync(
                         BaseSpTcmPLGet(),
                         new ParameterSpTcmPL
                         {
                             PYymm = oTUpdateCreateViewModel.Yymm,
                             PCostcode = oTUpdateCreateViewModel.Costcode,
                             POt = oTUpdateCreateViewModel.OT
                         });

                    return result.PMessageType == NotOk
                        ? throw new Exception(result.PMessageText.Replace("-", " "))
                        : (IActionResult)Json(new { success = true, response = result.PMessageText });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            var yymm = await _selectTcmPLRepository.OvertimeUpdateYymmAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
                PCostcode = oTUpdateCreateViewModel.Costcode
            });
            if (!yymm.Any())
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage("Cannot create OT"));
            }

            ViewData["Yymm"] = new SelectList(yymm, "DataValueField", "DataTextField");

            return PartialView("_ModalOvertimeUpdateCreatePartial", oTUpdateCreateViewModel);
        }

        public async Task<IActionResult> UpdateOvertimeUpdate(string costcode, string yymm)
        {
            var costCodeName = await _rapReportingRepository.CostcodeNameAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
                PCostcode = costcode
            });

            OTUpdateDetails result = await _overtimeUpdateDetailRepository.OvertimeUpdateDetail(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
                PCostcode = costcode,
                PYymm = yymm
            });

            OTUpdateEditViewModel oTUpdateEditViewModel = new();

            if (result.PMessageType == IsOk)
            {
                oTUpdateEditViewModel.Costcode = costcode;
                oTUpdateEditViewModel.Yymm = yymm;
                oTUpdateEditViewModel.OT = result.POt;
            }

            ViewData["Costcode"] = costcode;
            ViewData["CostcodeName"] = costCodeName.PName;

            return PartialView("_ModalOvertimeUpdateEditPartial", oTUpdateEditViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> UpdateOvertimeUpdate([FromForm] OTUpdateEditViewModel oTUpdateEditViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _overtimeUpdateRepository.UpdateOvertimeUpdateAsync(
                             BaseSpTcmPLGet(),
                             new ParameterSpTcmPL
                             {
                                 PCostcode = oTUpdateEditViewModel.Costcode,
                                 PYymm = oTUpdateEditViewModel.Yymm,
                                 POt = oTUpdateEditViewModel.OT
                             });

                    return result.PMessageType != IsOk
                        ? throw new Exception(result.PMessageText.Replace("-", " "))
                        : (IActionResult)Json(new { success = true, response = result.PMessageText });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            return PartialView("_ModalOvertimeUpdateEditPartial", oTUpdateEditViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> OvertimeUpdateDelete(string costcode, string yymm)
        {
            try
            {
                Domain.Models.Common.DBProcMessageOutput result = await _overtimeUpdateRepository.DeleteOvertimeUpdateAsync(
                    BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PCostcode = costcode,
                    PYymm = yymm
                }
                    );

                return Json(new { success = result.PMessageType == IsOk, response = result.PMessageType, message = result.PMessageText });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        public async Task<IActionResult> OvertimeUpdateCreateBulk(string costcode)
        {
            OvertimeUpdateCreateBulkModel overtimeUpdateCreateBulkModel = new()
            {
                Costcode = costcode,
                Months = 1,
                OT = 1
            };

            var costCodeName = await _rapReportingRepository.CostcodeNameAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
                PCostcode = costcode
            });

            ViewData["Costcode"] = costcode;
            ViewData["CostcodeName"] = costCodeName.PName;

            return PartialView("_ModalOvertimeUpdateCreateBulkPartial", overtimeUpdateCreateBulkModel);
        }

        [HttpPost]
        public async Task<IActionResult> OvertimeUpdateCreateBulk([FromForm] OvertimeUpdateCreateBulkModel overtimeUpdateCreateBulkModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    //#region get first month

                    var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
                    {
                        PModuleName = CurrentUserIdentity.CurrentModule,
                        PMetaId = CurrentUserIdentity.MetaId,
                        PPersonId = CurrentUserIdentity.EmployeeId,
                        PMvcActionName = ConstFilterRapIndex
                    });
                    FilterDataModel filterDataModel;
                    filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

                    OTUpdateCreateViewModel oTUpdateCreateViewModel = new();

                    DTResult<Models.OTUpdateCreateViewModel> result1 = new DTResult<Models.OTUpdateCreateViewModel>();
                    int totalRow = 0;
                    var dat = new DateTime();
                    short addMonths = 0;

                    ProcessMonthDetails month = await _processingMonthDetailRepository.ProcessingMonthDetail(BaseSpTcmPLGet(), new ParameterSpTcmPL
                    {
                        PSchemaname = Schemaname
                    });

                    System.Collections.Generic.IEnumerable<OvertimeUpdateDataTableList> data = await _overtimeUpdateDataTableListRepository.OvertimeUpdateDataTableListAsync(BaseSpTcmPLGet(),
                   new ParameterSpTcmPL
                   {
                       PCostcode = filterDataModel.CostCode,
                       PYymm = month.PProcMonth,
                       PRowNumber = 0,
                       PPageLength = 999999
                   });

                    if (data.Any())
                    {
                        totalRow = (int)data.Count();
                        result1.data = data.OrderBy(x => x.Yymm)
                                            .Select(x => new Models.OTUpdateCreateViewModel
                                            {
                                                Costcode = x.Costcode,
                                                Yymm = x.Yymm,
                                                OT = x.Ot,
                                            }).ToList();
                        dat = new DateTime(Int16.Parse(result1.data.ElementAt(totalRow - 1).Yymm.Substring(0, 4)), Int16.Parse(result1.data.ElementAt(totalRow - 1).Yymm.Substring(4, 2)), 1);
                        addMonths++;
                    }
                    else
                    {
                        dat = new DateTime(Int16.Parse(month.PProcMonth.Substring(0, 4)), Int16.Parse(month.PProcMonth.Substring(4, 2)), 1);
                    }

                    //#endregion get first month

                    int mm = 0;
                    Domain.Models.Common.DBProcMessageOutput result = null;
                    for (int i = 0; i < overtimeUpdateCreateBulkModel.Months; i++)
                    {
                        if (i == 0)
                        {
                            mm = addMonths;
                        }
                        else
                        {
                            mm = mm + 1;
                        }
                        result = await _overtimeUpdateRepository.CreateOvertimeUpdateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PYymm = dat.AddMonths(mm).ToString("yyyy") + dat.AddMonths(mm).ToString("MM"),
                            PCostcode = overtimeUpdateCreateBulkModel.Costcode,
                            POt = overtimeUpdateCreateBulkModel.OT
                        });
                        if (result.PMessageType == NotOk)
                        {
                            throw new Exception(result.PMessageText.Replace("-", " "));
                        }
                    }

                    return Json(new { success = true, response = result.PMessageText });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            return PartialView("_ModalOvertimeUpdateCreateBulkPartial", overtimeUpdateCreateBulkModel);
        }

        #endregion CRUD

        #endregion Overtime update

        #region OSC

        #region OscSesIndex

        public async Task<IActionResult> OscSesIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterOscSesIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            OscSesViewModel oscSesViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(oscSesViewModel);
        }

        public async Task<IActionResult> OscSESIndexPartial(string id)
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterOscSesIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            OscSesViewModel oscSesViewModel = new()
            {
                FilterDataModel = filterDataModel,
                OscmId = id
            };

            OscMasterDetails oscMasterDetails = await _oscMasterDetailRepository.OscMasterDetail(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        POscmId = id
                    });
            oscSesViewModel.OscmType = oscMasterDetails.POscmType;
            oscSesViewModel.LockOrigBudgetDesc = oscMasterDetails.PLockOrigBudgetDesc;

            return PartialView("_OscSESIndexPartial", oscSesViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsOscSesPartial(DTParameters param)
        {
            DTResult<OscSesDataTableList> result = new();
            int totalRow = 0;

            try
            {
                System.Collections.Generic.IEnumerable<OscSesDataTableList> data = await _oscSesDataTableListRepository.OscSesDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch ?? " ",
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
                        POscmId = param.OscmId
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
        public async Task<JsonResult> GetListsOscSes(DTParameters param)
        {
            DTResult<OscSesDataTableList> result = new();
            int totalRow = 0;

            try
            {
                System.Collections.Generic.IEnumerable<OscSesDataTableList> data = await _oscSesDataTableListRepository.OscSesDataTableListAsync(
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

        [HttpGet]
        public async Task<IActionResult> OscSesCreate(string OscmId)
        {
            OscSesCreateViewModel OscSesCreateViewModel = new();

            var rapOscdList = await _selectTcmPLRepository.RapSOCDList(BaseSpTcmPLGet(), null);
            ViewData["OscmDetails"] = new SelectList(rapOscdList, "DataValueField", "DataTextField", OscmId).First(i => i.Value == OscmId).Text.ToString();

            return PartialView("_ModalOscSesCreatePartial", OscSesCreateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> OscSesCreate([FromForm] OscSesCreateViewModel oscSesCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _oscSesRepository.OscSesCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            POscmId = oscSesCreateViewModel.OscmId,
                            PSesNo = oscSesCreateViewModel.SesNo,
                            PSesAmount = oscSesCreateViewModel.SesAmount,
                            PSesDate = oscSesCreateViewModel.SesDate,
                        });

                    return result.PMessageType != IsOk
                        ? throw new Exception(result.PMessageText.Replace("-", " "))
                        : (IActionResult)Json(new { success = true, response = result.PMessageText });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            var rapOscdList = await _selectTcmPLRepository.RapSOCDList(BaseSpTcmPLGet(), null);
            ViewData["OscmDetails"] = new SelectList(rapOscdList, "DataValueField", "DataTextField", oscSesCreateViewModel.OscmId).First(i => i.Value == oscSesCreateViewModel.OscmId).Text.ToString();

            return PartialView("_ModalOscSesCreatePartial", oscSesCreateViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> OscSesEdit(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            OscSesDetails result = await _oscSesDetailRepository.OscSesDetail(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    POscsId = id
                });

            OscSesUpdateViewModel oscSesUpdateViewModel = new();

            if (result.PMessageType == IsOk)
            {
                oscSesUpdateViewModel.OscsId = id;
                oscSesUpdateViewModel.OscmId = result.POscmId;
                oscSesUpdateViewModel.SesDate = result.PSesDate;
                oscSesUpdateViewModel.SesNo = result.PSesNo;
                oscSesUpdateViewModel.SesAmount = result.PSesAmount;
            }

            var rapOscdList = await _selectTcmPLRepository.RapSOCDList(BaseSpTcmPLGet(), null);
            ViewData["OscmDetails"] = new SelectList(rapOscdList, "DataValueField", "DataTextField", oscSesUpdateViewModel.OscmId).First(i => i.Value == oscSesUpdateViewModel.OscmId).Text.ToString();

            return PartialView("_ModalOscSesEditPartial", oscSesUpdateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> OscSesEdit([FromForm] OscSesUpdateViewModel oscSesUpdateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _oscSesRepository.OscSesEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            POscsId = oscSesUpdateViewModel.OscsId,
                            POscmId = oscSesUpdateViewModel.OscmId,
                            PSesNo = oscSesUpdateViewModel.SesNo,
                            PSesAmount = (decimal)oscSesUpdateViewModel.SesAmount,
                            PSesDate = oscSesUpdateViewModel.SesDate,
                        });

                    return result.PMessageType != IsOk
                        ? throw new Exception(result.PMessageText.Replace("-", " "))
                        : (IActionResult)Json(new { success = true, response = result.PMessageText });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            var rapOscdList = await _selectTcmPLRepository.RapSOCDList(BaseSpTcmPLGet(), null);
            ViewData["OscmDetails"] = new SelectList(rapOscdList, "DataValueField", "DataTextField", oscSesUpdateViewModel.OscmId).First(i => i.Value == oscSesUpdateViewModel.OscmId).Text.ToString();

            return PartialView("_ModalOscSesEditPartial", oscSesUpdateViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> OscSesDelete(string id)
        {
            try
            {
                var result = await _oscSesRepository.OscSesDeleteAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        POscsId = id
                    }
                    );

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        public async Task<IActionResult> OscSesExcelDownload(string id)
        {
            try
            {
                var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
                {
                    PModuleName = CurrentUserIdentity.CurrentModule,
                    PMetaId = CurrentUserIdentity.MetaId,
                    PPersonId = CurrentUserIdentity.EmployeeId,
                    PMvcActionName = ConstFilterOscSesIndex
                });
                FilterDataModel filterDataModel = new();
                if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                {
                    filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
                }

                string StrFimeName;

                var timeStamp = DateTime.Now.ToFileTime();
                StrFimeName = "OscSes_" + timeStamp.ToString();

                string strUser = User.Identity.Name;

                IEnumerable<OscSesDataTableList> data = await _oscSesDataTableListRepository.OscSesDataTableListForExcelAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        POscmId = id
                    });

                if (data == null) { return NotFound(); }

                var json = JsonConvert.SerializeObject(data);

                IEnumerable<OscSesDataTableExcel> excelData = JsonConvert.DeserializeObject<IEnumerable<OscSesDataTableExcel>>(json);

                byte[] byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, "OscSes", "OscSes");

                return File(byteContent,
                            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                            StrFimeName + ".xlsx");
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        #endregion OscSesIndex

        #region OscMaster

        public async Task<IActionResult> OscMasterIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterOscMasterIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            OscMasterViewModel oscMasterViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(oscMasterViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsOscMaster(DTParameters param)
        {
            DTResult<OscMasterDataTableList> result = new();
            int totalRow = 0;

            try
            {
                System.Collections.Generic.IEnumerable<OscMasterDataTableList> data = await _oscMasterDataTableListRepository.OscMasterDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PActionId = CurrentUserIdentity.ProfileActions.FirstOrDefault(p => p.ActionId is RapReportingHelper.ActionSubcontractPrengAdmin or
                                                                                      RapReportingHelper.ActionSubcontractProcoView or
                                                                                      RapReportingHelper.ActionSubcontractDeptMono)
                                                                      .ActionId,
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

        [HttpGet]
        public async Task<IActionResult> OscMasterDetails(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            OscMasterDetails result = await _oscMasterDetailRepository.OscMasterDetail(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    POscmId = id
                });

            OscMasterDetailViewModel oscMasterDetailViewModel = new();

            if (result.PMessageType == IsOk)
            {
                oscMasterDetailViewModel.OscmId = id;
                oscMasterDetailViewModel.OscmDate = result.POscmDate;
                oscMasterDetailViewModel.PoNumber = result.PPoNumber;
                oscMasterDetailViewModel.PoDate = result.PPoDate;
                oscMasterDetailViewModel.PoAmt = result.PPoAmt;
                oscMasterDetailViewModel.CurPoAmt = result.PCurPoAmt;
                oscMasterDetailViewModel.Projno5 = result.PProjno5;
                oscMasterDetailViewModel.Projno5Desc = result.PProjno5Desc;
                oscMasterDetailViewModel.OscmVendor = result.POscmVendor;
                oscMasterDetailViewModel.OscmVendorDesc = result.POscmVendorDesc;
                oscMasterDetailViewModel.OscmType = result.POscmType;
                oscMasterDetailViewModel.LockOrigBudgetDesc = result.PLockOrigBudgetDesc;
                oscMasterDetailViewModel.OrigEstHoursTotal = result.POrigEstHoursTotal;
                oscMasterDetailViewModel.CurEstHoursTotal = result.PCurEstHoursTotal;
                oscMasterDetailViewModel.SesAmountTotal = result.PSesAmountTotal;
                oscMasterDetailViewModel.ScopeWorkDesc = result.PScopeWorkDesc;
                oscMasterDetailViewModel.ActualHoursBookedTotal = result.PActualHoursBookedTotal;
            }

            return View("OscMasterDetail", oscMasterDetailViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> OscMasterCreate()
        {
            OscMasterCreateViewModel OscMasterCreateViewModel = new();

            var projNo5List = await _selectTcmPLRepository.SelectProjno5RapReportingProco(BaseSpTcmPLGet(), null);
            ViewData["ProjNo5List"] = new SelectList(projNo5List, "DataValueField", "DataTextField");

            var vendorList = await _selectTcmPLRepository.SelectSubcontractorRapReporting(BaseSpTcmPLGet(), null);
            ViewData["VendorList"] = new SelectList(vendorList, "DataValueField", "DataTextField");

            var scopeWorkList = await _selectTcmPLRepository.SelectScopeWorkRapReporting(BaseSpTcmPLGet(), null);
            ViewData["ScopeWorkList"] = new SelectList(scopeWorkList, "DataValueField", "DataTextField");

            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == RapReportingHelper.ActionSubcontractPrengAdmin))
            {
                var costcodeList = await _selectTcmPLRepository.SelectCostCodeRapReportingProco(BaseSpTcmPLGet(), null);
                ViewData["CostcodeList"] = new SelectList(costcodeList, "DataValueField", "DataTextField", null);
            }
            else
            {
                var costcodeList = await _selectTcmPLRepository.SelectCostCodeRapReporting(BaseSpTcmPLGet(), null);
                ViewData["CostcodeList"] = new SelectList(costcodeList, "DataValueField", "DataTextField", null);
            }

            return PartialView("_ModalOscMasterCreatePartial", OscMasterCreateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> OscMasterCreate([FromForm] OscMasterCreateViewModel oscMasterCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    string actionId = CurrentUserIdentity.ProfileActions.FirstOrDefault(p => p.ActionId is RapReportingHelper.ActionSubcontractPrengAdmin or
                                                                                             RapReportingHelper.ActionSubcontractProcoView or
                                                                                             RapReportingHelper.ActionSubcontractDeptMono)
                                                                        .ActionId;

                    IEnumerable<string> strings = oscMasterCreateViewModel.Costcode;
                    string costCodeArray = string.Join(",", strings.ToArray());

                    var result = await _oscMasterRepository.OscMasterCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PProjno5 = oscMasterCreateViewModel.Projno5,
                            POscmVendor = oscMasterCreateViewModel.OscmVendor,
                            PPoNumber = oscMasterCreateViewModel.PoNumber,
                            PPoDate = oscMasterCreateViewModel.PoDate,
                            PPoAmt = oscMasterCreateViewModel.PoAmt,
                            PCostcode = costCodeArray,
                            POscswId = oscMasterCreateViewModel.OscswId
                        });

                    return result.PMessageType != IsOk
                        ? throw new Exception(result.PMessageText.Replace("-", " "))
                        : (IActionResult)Json(new { success = true, response = result.PMessageText });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            var projNo5List = await _selectTcmPLRepository.SelectProjno5RapReportingProco(BaseSpTcmPLGet(), null);
            ViewData["ProjNo5List"] = new SelectList(projNo5List, "DataValueField", "DataTextField");

            var vendorList = await _selectTcmPLRepository.SelectSubcontractorRapReporting(BaseSpTcmPLGet(), null);
            ViewData["VendorList"] = new SelectList(vendorList, "DataValueField", "DataTextField");

            var scopeWorkList = await _selectTcmPLRepository.SelectScopeWorkRapReporting(BaseSpTcmPLGet(), null);
            ViewData["ScopeWorkList"] = new SelectList(scopeWorkList, "DataValueField", "DataTextField");

            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == RapReportingHelper.ActionSubcontractPrengAdmin))
            {
                var costcodeList = await _selectTcmPLRepository.SelectCostCodeRapReportingProco(BaseSpTcmPLGet(), null);
                ViewData["CostcodeList"] = new SelectList(costcodeList, "DataValueField", "DataTextField", null);
            }
            else
            {
                var costcodeList = await _selectTcmPLRepository.SelectCostCodeRapReporting(BaseSpTcmPLGet(), null);
                ViewData["CostcodeList"] = new SelectList(costcodeList, "DataValueField", "DataTextField", null);
            }

            return PartialView("_ModalOscMasterCreatePartial", oscMasterCreateViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> OscMasterEdit(string id)
        {
            OscMasterUpdateViewModel oscMasterUpdateViewModel = new();

            OscMasterDetails result = await _oscMasterDetailRepository.OscMasterDetail(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    POscmId = id
                });

            if (result.PMessageType == IsOk)
            {
                oscMasterUpdateViewModel.OscmId = id;
                oscMasterUpdateViewModel.Projno5 = result.PProjno5;
                oscMasterUpdateViewModel.OscmVendor = result.POscmVendor;
                oscMasterUpdateViewModel.PoNumber = result.PPoNumber;
                oscMasterUpdateViewModel.PoDate = result.PPoDate;
                oscMasterUpdateViewModel.PoAmt = result.PPoAmt;
                oscMasterUpdateViewModel.LockOrigBudget = result.PLockOrigBudget;
                oscMasterUpdateViewModel.OscmType = result.POscmType;
                oscMasterUpdateViewModel.OscswId = result.POscswId;
                ViewData["Projno5WithName"] = result.PProjno5 + " - " + result.PProjno5Desc;
                ViewData["VendorWithName"] = result.POscmVendor + " - " + result.POscmVendorDesc;
            }

            var scopeWorkList = await _selectTcmPLRepository.SelectScopeWorkRapReporting(BaseSpTcmPLGet(), null);
            ViewData["ScopeWorkList"] = new SelectList(scopeWorkList, "DataValueField", "DataTextField");

            System.Collections.Generic.IEnumerable<OscDetailDataTableList> data = await _oscDetailDataTableListRepository.OscDetailDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        POscmId = id,
                        PActionId = CurrentUserIdentity.ProfileActions.FirstOrDefault(p => p.ActionId is RapReportingHelper.ActionSubcontractPrengAdmin or
                                                                                      RapReportingHelper.ActionSubcontractProcoView or
                                                                                      RapReportingHelper.ActionSubcontractDeptMono)
                                                                      .ActionId
                    }
                );
            oscMasterUpdateViewModel.Costcode = data.Select(m => m.Costcode).ToList().ToArray();

            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == RapReportingHelper.ActionSubcontractPrengAdmin))
            {
                var costcodeList = await _selectTcmPLRepository.SelectCostCodeRapReportingProco(BaseSpTcmPLGet(), null);
                ViewData["CostcodeList"] = new SelectList(costcodeList, "DataValueField", "DataTextField", oscMasterUpdateViewModel.Costcode);
            }
            else
            {
                var costcodeList = await _selectTcmPLRepository.SelectCostCodeRapReporting(BaseSpTcmPLGet(), null);
                ViewData["CostcodeList"] = new SelectList(costcodeList, "DataValueField", "DataTextField", oscMasterUpdateViewModel.Costcode);
            }

            return PartialView("_ModalOscMasterEditPartial", oscMasterUpdateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> OscMasterEdit([FromForm] OscMasterUpdateViewModel oscMasterUpdateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    IEnumerable<string> strings = oscMasterUpdateViewModel.Costcode;
                    string costCodeArray = string.Join(",", strings.ToArray());

                    var result = await _oscMasterRepository.OscMasterEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            POscmId = oscMasterUpdateViewModel.OscmId,
                            PProjno5 = oscMasterUpdateViewModel.Projno5,
                            POscmVendor = oscMasterUpdateViewModel.OscmVendor,
                            PPoNumber = oscMasterUpdateViewModel.PoNumber,
                            PPoDate = oscMasterUpdateViewModel.PoDate,
                            PPoAmt = oscMasterUpdateViewModel.PoAmt,
                            PCurPoAmt = oscMasterUpdateViewModel.PoAmt,
                            PLockOrigBudget = oscMasterUpdateViewModel.LockOrigBudget,
                            PCostcode = costCodeArray,
                            POscswId = oscMasterUpdateViewModel.OscswId
                        });

                    return result.PMessageType != IsOk
                        ? throw new Exception(result.PMessageText.Replace("-", " "))
                        : (IActionResult)Json(new { success = true, response = result.PMessageText });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            var scopeWorkList = await _selectTcmPLRepository.SelectScopeWorkRapReporting(BaseSpTcmPLGet(), null);
            ViewData["ScopeWorkList"] = new SelectList(scopeWorkList, "DataValueField", "DataTextField");

            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == RapReportingHelper.ActionSubcontractPrengAdmin))
            {
                var costcodeList = await _selectTcmPLRepository.SelectCostCodeRapReportingProco(BaseSpTcmPLGet(), null);
                ViewData["CostcodeList"] = new SelectList(costcodeList, "DataValueField", "DataTextField", oscMasterUpdateViewModel.Costcode);
            }
            else
            {
                var costcodeList = await _selectTcmPLRepository.SelectCostCodeRapReporting(BaseSpTcmPLGet(), null);
                ViewData["CostcodeList"] = new SelectList(costcodeList, "DataValueField", "DataTextField", oscMasterUpdateViewModel.Costcode);
            }

            return PartialView("_ModalOscMasterEditPartial", oscMasterUpdateViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> OscMasterEditCur(string id)
        {
            OscMasterUpdateCurViewModel oscMasterUpdateCurViewModel = new();

            OscMasterDetails result = await _oscMasterDetailRepository.OscMasterDetail(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    POscmId = id
                });

            if (result.PMessageType == IsOk)
            {
                oscMasterUpdateCurViewModel.OscmId = id;
                oscMasterUpdateCurViewModel.Projno5 = result.PProjno5;
                oscMasterUpdateCurViewModel.OscmVendor = result.POscmVendor;
                oscMasterUpdateCurViewModel.PoNumber = result.PPoNumber;
                oscMasterUpdateCurViewModel.PoDate = Convert.ToDateTime(result.PPoDate.Value.ToString("yyyy-MM-dd"));
                oscMasterUpdateCurViewModel.PoAmt = result.PPoAmt;
                oscMasterUpdateCurViewModel.CurPoAmt = result.PCurPoAmt;
                oscMasterUpdateCurViewModel.LockOrigBudget = result.PLockOrigBudget;
                oscMasterUpdateCurViewModel.OscmType = result.POscmType;
                oscMasterUpdateCurViewModel.OscswId = result.POscswId;
                ViewData["Projno5WithName"] = result.PProjno5 + " - " + result.PProjno5Desc;
                ViewData["VendorWithName"] = result.POscmVendor + " - " + result.POscmVendorDesc;
                ViewData["ScopeWorkDesc"] = result.PScopeWorkDesc;
            }

            System.Collections.Generic.IEnumerable<OscDetailDataTableList> data = await _oscDetailDataTableListRepository.OscDetailDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        POscmId = id,
                        PActionId = CurrentUserIdentity.ProfileActions.FirstOrDefault(p => p.ActionId is RapReportingHelper.ActionSubcontractPrengAdmin or
                                                                                      RapReportingHelper.ActionSubcontractProcoView or
                                                                                      RapReportingHelper.ActionSubcontractDeptMono)
                                                                      .ActionId
                    }
                );
            oscMasterUpdateCurViewModel.Costcode = data.Select(m => m.Costcode).ToList().ToArray();

            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == RapReportingHelper.ActionSubcontractPrengAdmin))
            {
                var costcodeList = await _selectTcmPLRepository.SelectCostCodeRapReportingProco(BaseSpTcmPLGet(), null);
                ViewData["CostcodeList"] = new SelectList(costcodeList, "DataValueField", "DataTextField", oscMasterUpdateCurViewModel.Costcode);
            }
            else
            {
                var costcodeList = await _selectTcmPLRepository.SelectCostCodeRapReporting(BaseSpTcmPLGet(), null);
                ViewData["CostcodeList"] = new SelectList(costcodeList, "DataValueField", "DataTextField", oscMasterUpdateCurViewModel.Costcode);
            }

            return PartialView("_ModalOscMasterCurEditPartial", oscMasterUpdateCurViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> OscMasterEditCur([FromForm] OscMasterUpdateCurViewModel oscMasterUpdateCurViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    string costCodeArray = string.Empty;
                    if (oscMasterUpdateCurViewModel.Costcode != null)
                    {
                        IEnumerable<string> strings = oscMasterUpdateCurViewModel.Costcode;
                        costCodeArray = string.Join(",", strings.ToArray());
                    }

                    var result = await _oscMasterRepository.OscMasterEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            POscmId = oscMasterUpdateCurViewModel.OscmId,
                            PProjno5 = oscMasterUpdateCurViewModel.Projno5,
                            POscmVendor = oscMasterUpdateCurViewModel.OscmVendor,
                            PPoNumber = oscMasterUpdateCurViewModel.PoNumber,
                            PPoDate = oscMasterUpdateCurViewModel.PoDate,
                            PPoAmt = oscMasterUpdateCurViewModel.PoAmt,
                            PCurPoAmt = oscMasterUpdateCurViewModel.CurPoAmt,
                            PLockOrigBudget = oscMasterUpdateCurViewModel.LockOrigBudget,
                            PCostcode = costCodeArray,
                            POscswId = oscMasterUpdateCurViewModel.OscswId
                        });

                    return result.PMessageType != IsOk
                        ? throw new Exception(result.PMessageText.Replace("-", " "))
                        : (IActionResult)Json(new { success = true, response = result.PMessageText });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == RapReportingHelper.ActionSubcontractPrengAdmin))
            {
                var costcodeList = await _selectTcmPLRepository.SelectCostCodeRapReportingProco(BaseSpTcmPLGet(), null);
                ViewData["CostcodeList"] = new SelectList(costcodeList, "DataValueField", "DataTextField", oscMasterUpdateCurViewModel.Costcode);
            }
            else
            {
                var costcodeList = await _selectTcmPLRepository.SelectCostCodeRapReporting(BaseSpTcmPLGet(), null);
                ViewData["CostcodeList"] = new SelectList(costcodeList, "DataValueField", "DataTextField", oscMasterUpdateCurViewModel.Costcode);
            }

            return PartialView("_ModalOscMasterCurEditPartial", oscMasterUpdateCurViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> OscMasterDelete(string id)
        {
            try
            {
                var result = await _oscMasterRepository.OscMasterDeleteAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        POscmId = id
                    }
                    );

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        [HttpPost]
        public async Task<IActionResult> OscMasterLock(string id)
        {
            try
            {
                var result = await _oscMasterRepository.OscMasterLockAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        POscmId = id
                    }
                    );

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        #endregion OscMaster

        #region OscDetail

        public async Task<IActionResult> OscDetailIndex(string id)
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterOscDetailIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            OscDetailViewModel oscDetailViewModel = new()
            {
                FilterDataModel = filterDataModel,
                OscmId = id
            };

            OscMasterDetails oscMasterDetails = await _oscMasterDetailRepository.OscMasterDetail(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    POscmId = id
                });
            oscDetailViewModel.OscmType = oscMasterDetails.POscmType;
            oscDetailViewModel.LockOrigBudgetDesc = oscMasterDetails.PLockOrigBudgetDesc;

            return PartialView("_OscDetailIndexPartial", oscDetailViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsOscDetail(DTParameters param)
        {
            DTResult<OscDetailDataTableList> result = new();
            int totalRow = 0;

            try
            {
                System.Collections.Generic.IEnumerable<OscDetailDataTableList> data = await _oscDetailDataTableListRepository.OscDetailDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        POscmId = param.OscmId,
                        PActionId = CurrentUserIdentity.ProfileActions.FirstOrDefault(p => p.ActionId is RapReportingHelper.ActionSubcontractPrengAdmin or
                                                                                 RapReportingHelper.ActionSubcontractProcoView or
                                                                                 RapReportingHelper.ActionSubcontractDeptMono)
                                                                      .ActionId,
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

        [HttpGet]
        public async Task<IActionResult> OscDetailCreate(string id)
        {
            var oscmId = id.Split("!-!")[0];
            var lockOrigBudgetDesc = id.Split("!-!")[1];

            OscDetailCreateViewModel oscDetailCreateViewModel = new();

            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == RapReportingHelper.ActionSubcontractPrengAdmin))
            {
                var costcodeList = await _selectTcmPLRepository.SelectCostCodeRapReportingProcoBal(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        POscmId = oscmId
                    });
                ViewData["CostcodeList"] = new SelectList(costcodeList, "DataValueField", "DataTextField", null);
            }
            else
            {
                var costcodeList = await _selectTcmPLRepository.SelectCostCodeRapReportingBal(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        POscmId = oscmId
                    });
                ViewData["CostcodeList"] = new SelectList(costcodeList, "DataValueField", "DataTextField", null);
            }
            oscDetailCreateViewModel.OscmId = oscmId;
            oscDetailCreateViewModel.LockOrigBudgetDesc = lockOrigBudgetDesc;

            return PartialView("_ModalOscDetailCreatePartial", oscDetailCreateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> OscDetailCreate([FromForm] OscDetailCreateViewModel oscDetailCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _oscDetailRepository.OscDetailCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            POscmId = oscDetailCreateViewModel.OscmId,
                            PCostcode = oscDetailCreateViewModel.CostCode,
                            PLockOrigBudgetDesc = oscDetailCreateViewModel.LockOrigBudgetDesc
                        });

                    return RedirectToAction("OscDetailCreate", new { id = oscDetailCreateViewModel.OscmId + "!-!" + oscDetailCreateViewModel.LockOrigBudgetDesc });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == RapReportingHelper.ActionSubcontractPrengAdmin))
            {
                var costcodeList = await _selectTcmPLRepository.SelectCostCodeRapReportingProcoBal(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        POscmId = oscDetailCreateViewModel.OscmId
                    });
                ViewData["CostcodeList"] = new SelectList(costcodeList, "DataValueField", "DataTextField", null);
            }
            else
            {
                var costcodeList = await _selectTcmPLRepository.SelectCostCodeRapReportingBal(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        POscmId = oscDetailCreateViewModel.OscmId
                    });
                ViewData["CostcodeList"] = new SelectList(costcodeList, "DataValueField", "DataTextField", null);
            }

            oscDetailCreateViewModel.OscmId = oscDetailCreateViewModel.OscmId;
            oscDetailCreateViewModel.LockOrigBudgetDesc = oscDetailCreateViewModel.LockOrigBudgetDesc;

            return PartialView("_ModalOscDetailCreatePartial", oscDetailCreateViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> OscDetailDelete(string id)
        {
            try
            {
                var result = await _oscDetailRepository.OscDetailDeleteAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        POscdId = id
                    }
                    );

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        #endregion OscDetail

        #region OscHours

        [HttpGet]
        public async Task<IActionResult> OscHoursIndex(string id)
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterOscHoursIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            OscHoursViewModel oscHoursViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            OscDetailDetails oscDetailDetails = await _oscDetailDetailRepository.OscDetailDetail(
              BaseSpTcmPLGet(),
              new ParameterSpTcmPL
              {
                  POscdId = id
              });

            if (oscDetailDetails.PMessageType == IsOk)
            {
                ViewData["Costcode"] = oscDetailDetails.PCostcode + " " + oscDetailDetails.PCostcodeDesc;

                OscMasterDetails oscMasterDetails = await _oscMasterDetailRepository.OscMasterDetail(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        POscmId = oscDetailDetails.POscmId
                    });

                if (oscMasterDetails.PMessageType == IsOk)
                {
                    oscHoursViewModel.OscmType = oscMasterDetails.POscmType;
                    oscHoursViewModel.LockOrigBudgetDesc = oscMasterDetails.PLockOrigBudgetDesc;
                    ViewData["Projno5PoVendor"] = oscMasterDetails.PProjno5 + " / " + oscMasterDetails.PPoNumber + " / " + oscMasterDetails.POscmVendorDesc;
                }
            }

            oscHoursViewModel.OscdId = id;

            return PartialView("_ModalOscHoursIndexPartial", oscHoursViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsOscHours(DTParameters param)
        {
            DTResult<OscHoursDataTableList> result = new();
            int totalRow = 0;

            try
            {
                System.Collections.Generic.IEnumerable<OscHoursDataTableList> data = await _oscHoursDataTableListRepository.OscHoursDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        POscdId = param.OscdId,
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

        public async Task<IActionResult> OscHoursOrigCreate(string id)
        {
            OscHoursOrigCreateViewModel oscHoursOrigCreateViewModel = new();

            OscDetailDetails oscDetailDetails = await _oscDetailDetailRepository.OscDetailDetail(
              BaseSpTcmPLGet(),
              new ParameterSpTcmPL
              {
                  POscdId = id
              });

            if (oscDetailDetails.PMessageType == IsOk)
            {
                ViewData["Costcode"] = oscDetailDetails.PCostcode + " " + oscDetailDetails.PCostcodeDesc;

                OscMasterDetails oscMasterDetails = await _oscMasterDetailRepository.OscMasterDetail(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        POscmId = oscDetailDetails.POscmId
                    });

                if (oscMasterDetails.PMessageType == IsOk)
                {
                    ViewData["Projno5PoVendor"] = oscMasterDetails.PProjno5 + " / " + oscMasterDetails.PPoNumber + " / " + oscMasterDetails.POscmVendorDesc;

                    if (oscMasterDetails.PRevcdate == null)
                    {
                        return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage("Project revised closing date is blank"));
                    }
                }
            }

            // get yymm
            var yyyymm = await _selectTcmPLRepository.SelectOscHoursRapReporting(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    POscdId = id
                });
            if (!yyyymm.Any())
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage("Cannot create as Estimation hours have been made till Project revised closing date "));
            }

            ViewData["Yyyymm"] = new SelectList(yyyymm, "DataValueField", "DataTextField");

            oscHoursOrigCreateViewModel.OscdId = id;

            return PartialView("_ModalOscHoursOrigCreatePartial", oscHoursOrigCreateViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> OscHoursOrigCreate([FromForm] OscHoursOrigCreateViewModel oscHoursOrigCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    OscDetailDetails oscDetailDetails = await _oscDetailDetailRepository.OscDetailDetail(
                      BaseSpTcmPLGet(),
                      new ParameterSpTcmPL
                      {
                          POscdId = oscHoursOrigCreateViewModel.OscdId
                      });

                    if (oscDetailDetails.PMessageType == IsOk)
                    {
                        OscMasterDetails oscMasterDetails = await _oscMasterDetailRepository.OscMasterDetail(
                            BaseSpTcmPLGet(),
                            new ParameterSpTcmPL
                            {
                                POscmId = oscDetailDetails.POscmId
                            });

                        if (oscMasterDetails.PMessageType == IsOk)
                        {
                            if (oscMasterDetails.PRevcdate == null)
                            {
                                throw new Exception("Project revised closing date is blank");
                            }
                            else if (int.Parse(oscHoursOrigCreateViewModel.Yyyymm) > int.Parse(oscMasterDetails.PRevcdate.Value.Year.ToString() + oscMasterDetails.PRevcdate.Value.Month.ToString().PadLeft(2, '0')))
                            {
                                throw new Exception("Yyyymm " + oscHoursOrigCreateViewModel.Yyyymm + " is later than Project revised closing date " + oscMasterDetails.PRevcdate.Value.Year.ToString() + oscMasterDetails.PRevcdate.Value.Month.ToString().PadLeft(2, '0'));
                            }
                        }
                    }

                    var result = await _oscHoursRepository.OscHoursOrignalEstHrsCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            POscdId = oscHoursOrigCreateViewModel.OscdId,
                            PYyyymm = oscHoursOrigCreateViewModel.Yyyymm,
                            POrigEstHrs = oscHoursOrigCreateViewModel.OrigEstHrs,
                            PCurEstHrs = oscHoursOrigCreateViewModel.OrigEstHrs
                        });

                    return RedirectToAction("OscHoursOrigCreate", new { id = oscHoursOrigCreateViewModel.OscdId });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            return PartialView("_ModalOscHoursOrigCreatePartial", oscHoursOrigCreateViewModel);
        }

        public async Task<IActionResult> OscHoursOrigEdit(string id)
        {
            var oscdId = id.Split("!-!")[0];
            var oschId = id.Split("!-!")[1];

            OscHoursOrigEditViewModel oscHoursOrigEditViewModel = new();

            OscDetailDetails oscDetailDetails = await _oscDetailDetailRepository.OscDetailDetail(
              BaseSpTcmPLGet(),
              new ParameterSpTcmPL
              {
                  POscdId = oscdId
              });

            if (oscDetailDetails.PMessageType == IsOk)
            {
                ViewData["Costcode"] = oscDetailDetails.PCostcode + " " + oscDetailDetails.PCostcodeDesc;

                OscMasterDetails oscMasterDetails = await _oscMasterDetailRepository.OscMasterDetail(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        POscmId = oscDetailDetails.POscmId
                    });

                if (oscMasterDetails.PMessageType == IsOk)
                {
                    ViewData["Projno5PoVendor"] = oscMasterDetails.PProjno5 + " / " + oscMasterDetails.PPoNumber + " / " + oscMasterDetails.POscmVendorDesc;

                    if (oscMasterDetails.PRevcdate == null)
                    {
                        return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage("Project revised closing date is blank"));
                    }
                }
            }

            OscHoursDetails oscHoursDetails = await _oscHoursDetailRepository.OscHoursDetail(
              BaseSpTcmPLGet(),
              new ParameterSpTcmPL
              {
                  POschId = oschId
              });

            oscHoursOrigEditViewModel.OscdId = oscdId;
            oscHoursOrigEditViewModel.OschId = oschId;
            oscHoursOrigEditViewModel.Yyyymm = oscHoursDetails.PYyyymm;
            oscHoursOrigEditViewModel.OrigEstHrs = oscHoursDetails.POrigEstHrs;

            return PartialView("_ModalOscHoursOrigEditPartial", oscHoursOrigEditViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> OscHoursOrigEdit([FromForm] OscHoursOrigEditViewModel oscHoursOrigEditViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _oscHoursRepository.OscHoursOrignalEstHrsEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            POschId = oscHoursOrigEditViewModel.OschId,
                            POrigEstHrs = oscHoursOrigEditViewModel.OrigEstHrs,
                            PCurEstHrs = oscHoursOrigEditViewModel.OrigEstHrs
                        });

                    return RedirectToAction("OscHoursIndex", new { id = oscHoursOrigEditViewModel.OscdId });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            return PartialView("_ModalOscHoursOrigEditPartial", oscHoursOrigEditViewModel);
        }

        public async Task<IActionResult> OscHoursCurCreate(string id)
        {
            OscHoursCurCreateViewModel oscHoursCurCreateViewModel = new();

            OscDetailDetails oscDetailDetails = await _oscDetailDetailRepository.OscDetailDetail(
              BaseSpTcmPLGet(),
              new ParameterSpTcmPL
              {
                  POscdId = id
              });

            if (oscDetailDetails.PMessageType == IsOk)
            {
                ViewData["Costcode"] = oscDetailDetails.PCostcode + " " + oscDetailDetails.PCostcodeDesc;

                OscMasterDetails oscMasterDetails = await _oscMasterDetailRepository.OscMasterDetail(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        POscmId = oscDetailDetails.POscmId
                    });

                if (oscMasterDetails.PMessageType == IsOk)
                {
                    ViewData["Projno5PoVendor"] = oscMasterDetails.PProjno5 + " / " + oscMasterDetails.PPoNumber + " / " + oscMasterDetails.POscmVendorDesc;

                    if (oscMasterDetails.PRevcdate == null)
                    {
                        return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage("Project revised closing date is blank"));
                    }
                }
            }

            // get yymm
            var yyyymm = await _selectTcmPLRepository.SelectOscHoursRapReporting(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    POscdId = id
                });
            if (!yyyymm.Any())
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage("Cannot create as Estimation hours have been made till Project revised closing date "));
            }

            ViewData["Yyyymm"] = new SelectList(yyyymm, "DataValueField", "DataTextField");

            oscHoursCurCreateViewModel.OscdId = id;

            return PartialView("_ModalOscHoursCurCreatePartial", oscHoursCurCreateViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> OscHoursCurCreate([FromForm] OscHoursCurCreateViewModel oscHoursCurCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    OscDetailDetails oscDetailDetails = await _oscDetailDetailRepository.OscDetailDetail(
                      BaseSpTcmPLGet(),
                      new ParameterSpTcmPL
                      {
                          POscdId = oscHoursCurCreateViewModel.OscdId
                      });

                    if (oscDetailDetails.PMessageType == IsOk)
                    {
                        OscMasterDetails oscMasterDetails = await _oscMasterDetailRepository.OscMasterDetail(
                            BaseSpTcmPLGet(),
                            new ParameterSpTcmPL
                            {
                                POscmId = oscDetailDetails.POscmId
                            });

                        if (oscMasterDetails.PMessageType == IsOk)
                        {
                            if (oscMasterDetails.PRevcdate == null)
                            {
                                throw new Exception("Project revised closing date is blank");
                            }
                            else if (int.Parse(oscHoursCurCreateViewModel.Yyyymm) > int.Parse(oscMasterDetails.PRevcdate.Value.Year.ToString() + oscMasterDetails.PRevcdate.Value.Month.ToString().PadLeft(2, '0')))
                            {
                                throw new Exception("Yyyymm " + oscHoursCurCreateViewModel.Yyyymm + " is later than Project revised closing date " + oscMasterDetails.PRevcdate.Value.Year.ToString() + oscMasterDetails.PRevcdate.Value.Month.ToString().PadLeft(2, '0'));
                            }
                        }
                    }

                    var result = await _oscHoursRepository.OscHoursOrignalEstHrsCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            POscdId = oscHoursCurCreateViewModel.OscdId,
                            PYyyymm = oscHoursCurCreateViewModel.Yyyymm,
                            POrigEstHrs = 0,
                            PCurEstHrs = oscHoursCurCreateViewModel.CurEstHrs
                        });

                    return RedirectToAction("OscHoursCurCreate", new { id = oscHoursCurCreateViewModel.OscdId });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            return PartialView("_ModalOscHoursCurCreatePartial", oscHoursCurCreateViewModel);
        }

        public async Task<IActionResult> OscHoursCurEdit(string id)
        {
            var oscdId = id.Split("!-!")[0];
            var oschId = id.Split("!-!")[1];

            OscHoursCurEditViewModel oscHoursCurEditViewModel = new();

            OscDetailDetails oscDetailDetails = await _oscDetailDetailRepository.OscDetailDetail(
              BaseSpTcmPLGet(),
              new ParameterSpTcmPL
              {
                  POscdId = oscdId
              });

            if (oscDetailDetails.PMessageType == IsOk)
            {
                ViewData["Costcode"] = oscDetailDetails.PCostcode + " " + oscDetailDetails.PCostcodeDesc;

                OscMasterDetails oscMasterDetails = await _oscMasterDetailRepository.OscMasterDetail(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        POscmId = oscDetailDetails.POscmId
                    });

                if (oscMasterDetails.PMessageType == IsOk)
                {
                    ViewData["Projno5PoVendor"] = oscMasterDetails.PProjno5 + " / " + oscMasterDetails.PPoNumber + " / " + oscMasterDetails.POscmVendorDesc;

                    if (oscMasterDetails.PRevcdate == null)
                    {
                        return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage("Project revised closing date is blank"));
                    }
                }
            }

            OscHoursDetails oscHoursDetails = await _oscHoursDetailRepository.OscHoursDetail(
              BaseSpTcmPLGet(),
              new ParameterSpTcmPL
              {
                  POschId = oschId
              });

            oscHoursCurEditViewModel.OscdId = oscdId;
            oscHoursCurEditViewModel.OschId = oschId;
            oscHoursCurEditViewModel.Yyyymm = oscHoursDetails.PYyyymm;
            oscHoursCurEditViewModel.OrigEstHrs = oscHoursDetails.POrigEstHrs;
            oscHoursCurEditViewModel.CurEstHrs = oscHoursDetails.PCurEstHrs;

            return PartialView("_ModalOscHoursCurEditPartial", oscHoursCurEditViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> OscHoursCurEdit([FromForm] OscHoursCurEditViewModel oscHoursCurEditViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _oscHoursRepository.OscHoursCurrentEstHrsEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            POschId = oscHoursCurEditViewModel.OschId,
                            PCurEstHrs = oscHoursCurEditViewModel.CurEstHrs
                        });

                    return RedirectToAction("OscHoursIndex", new { id = oscHoursCurEditViewModel.OscdId });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            return PartialView("_ModalOscHoursCurEditPartial", oscHoursCurEditViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> OscHoursDelete(string id)
        {
            try
            {
                var result = await _oscHoursRepository.OscHoursDeleteAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        POschId = id
                    }
                    );

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        #endregion OscHours

        #region OscActualHoursBookedIndex

        public async Task<IActionResult> OscActualHoursBookedIndexPartial(string id)
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterOscActualHoursBookedIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            OscActualHoursBookedViewModel oscActualHoursBookedViewModel = new()
            {
                FilterDataModel = filterDataModel,
                OscmId = id
            };

            return PartialView("_OscActualHoursBookedIndexPartial", oscActualHoursBookedViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsOscActualHoursBookedPartial(DTParameters param)
        {
            DTResult<OscActualHoursBookedDataTableList> result = new();
            int totalRow = 0;

            try
            {
                System.Collections.Generic.IEnumerable<OscActualHoursBookedDataTableList> data = await _oscActualHoursBookedDataTableListRepository.OscActualHoursBookedDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch ?? " ",
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
                        POscmId = param.OscmId
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

        public async Task<IActionResult> OscActualHoursBookedExcelDownload(string id)
        {
            try
            {
                var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
                {
                    PModuleName = CurrentUserIdentity.CurrentModule,
                    PMetaId = CurrentUserIdentity.MetaId,
                    PPersonId = CurrentUserIdentity.EmployeeId,
                    PMvcActionName = ConstFilterOscActualHoursBookedIndex
                });
                FilterDataModel filterDataModel = new();
                if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                {
                    filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
                }

                string StrFimeName;

                var timeStamp = DateTime.Now.ToFileTime();
                StrFimeName = "RapReporting Outside subcontract Actual Hours Booked_" + timeStamp.ToString();

                string strUser = User.Identity.Name;

                IEnumerable<OscActualHoursBookedDataTableList> data = await _oscActualHoursBookedDataTableListRepository.OscActualHoursBookedDataTableListForExcelAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        POscmId = id
                    }
                );

                if (data == null) { return NotFound(); }

                var json = JsonConvert.SerializeObject(data);

                IEnumerable<OscActualHoursBookedDataTableExcel> excelData = JsonConvert.DeserializeObject<IEnumerable<OscActualHoursBookedDataTableExcel>>(json);

                byte[] byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, "Actual hours booked", "Actual hours booked");

                return File(byteContent,
                            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                            StrFimeName + ".xlsx");
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        #endregion OscActualHoursBookedIndex

        #endregion OSC

        #region Timesheet shift project manhours

        public async Task<IActionResult> TSShiftProjectManHoursIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterRapIndex
            });

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            ShiftingManhoursViewModel shiftingManhoursViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            var data = await _tSRepostingDetailsRepository.TSRepostingDetailsAsync(
                   BaseSpTcmPLGet(),
                   new ParameterSpTcmPL { }
                   );

            ViewData["ProcMonth"] = data.PProcMonth;
            return View(shiftingManhoursViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsTSShiftProjectManhoursHours(string paramJson)
        {
            DTResult<TSShiftProjectManhoursDataTableList> result = new();
            int totalRow = 0;
            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            try
            {
                System.Collections.Generic.IEnumerable<TSShiftProjectManhoursDataTableList> data = await _tSShiftProjectManhoursDataTableListRepository.TSShiftProjectManhoursDataTableListAsync(
                BaseSpTcmPLGet(), new ParameterSpTcmPL
                {
                    PYyyymm = param.Yyyymm,
                    PGenericSearch = param.GenericSearch ?? " ",
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
                return Json(new { error = ex.Message });
            }
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, RapReportingHelper.ActionProcoTrans)]
        public async Task<IActionResult> TSShiftProjectManhours(string yyyy, string yearMode)
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
            }
            else
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            ShiftingManhoursViewModel shiftingManhoursViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            var yyyymm = await _selectTcmPLRepository.SelectYearMonthRapReporting(BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PYyyy = yyyy,
                        PYearmode = yearMode
                    });
            ViewData["Yyyymms"] = new SelectList(yyyymm.Where(x => x.DataValueField != filterDataModel.Yyyymm), "DataValueField", "DataTextField");

            var projnos = await _selectTcmPLRepository.SelectProjnoRapReportingProco(BaseSpTcmPLGet(), null);
            ViewData["FromProject"] = new SelectList(projnos, "DataValueField", "DataTextField", shiftingManhoursViewModel.FromProject);

            return PartialView("_ModalTSShiftProjectManhoursPartial", shiftingManhoursViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, RapReportingHelper.ActionProcoTrans)]
        public async Task<IActionResult> TSShiftProjectManhours([FromForm] ShiftingManhoursViewModel shiftingManhoursViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _tSShiftProjectManhoursRepository.TSShiftProjectManhours(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PYymm = shiftingManhoursViewModel.YearMonth,
                            PProjnoFrom = shiftingManhoursViewModel.FromProject,
                            PProjnoTo = shiftingManhoursViewModel.ToProject
                        });

                    return result.PMessageType != IsOk
                        ? throw new Exception(result.PMessageText.Replace("-", " "))
                        : (IActionResult)Json(new { success = true, response = result.PMessageText });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            var yyyymm = await _selectTcmPLRepository.SelectYearMonthRapReporting(BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PYyyy = shiftingManhoursViewModel.FilterDataModel.Yyyy,
                        PYearmode = shiftingManhoursViewModel.FilterDataModel.YearMode
                    });
            ViewData["Yyyymms"] = new SelectList(yyyymm.Where(x => x.DataValueField != shiftingManhoursViewModel.FilterDataModel.Yyyymm), "DataValueField", "DataTextField", shiftingManhoursViewModel.YearMonth);

            var projnos = await _selectTcmPLRepository.SelectProjnoRapReportingProco(BaseSpTcmPLGet(), null);
            ViewData["FromProject"] = new SelectList(projnos, "DataValueField", "DataTextField", shiftingManhoursViewModel.FromProject);
            ViewData["ToProject"] = new SelectList(projnos.Where(a => a.DataValueField != shiftingManhoursViewModel.FromProject), "DataValueField", "DataTextField", shiftingManhoursViewModel.ToProject);

            return PartialView("_ModalTSShiftProjectManhoursPartial", shiftingManhoursViewModel);
        }

        public async Task<IActionResult> TSShiftProjectManhoursExcelDownload(string id)
        {
            try
            {
                string excelFileName = "ShiftProjectManhours.xlsx";
                string TimeMastDataTable = "Summary";
                string TimeDailyDataTable = "Normal";
                string TimeOTDataTable = "OT";
                string TimeMastSheetName = "Summary";
                string TimeDailySheetName = "Normal";
                string TimeOTSheetName = "OT";

                var data = await _tSShiftProjectManhoursReportRepository.TSShiftProjectManhoursReport(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PLogId = id
                    });

                if (data?.PTimeMastLog == null) { return Json(ResponseHelper.GetMessageObject("No Data Found.", NotificationType.error)); }

                string stringFileName = "ShiftProjectManhours";

                string reportTitle = "Timesheet shift project manhours";
                byte[] byteContent1 = null;

                byte[] templateBytes = System.IO.File.ReadAllBytes(StorageHelper.GetTemplateFilePath(StorageHelper.RAPTimesheet.RepositoryRAPTimesheet, FileName: excelFileName, Configuration));

                using (MemoryStream templateStream = new())
                {
                    templateStream.Write(templateBytes, 0, templateBytes.Length);

                    using (SpreadsheetDocument spreadsheetDocument = SpreadsheetDocument.Open(templateStream, true))
                    {
                        XLBookWriter.SetCellValue(spreadsheetDocument, TimeMastSheetName, "A1", reportTitle);
                        if (data.PTimeMastLog != null)
                        {
                            XLBookWriter.AppendDataInExcel(spreadsheetDocument, TimeMastSheetName, TimeMastDataTable, data.PTimeMastLog);
                        }

                        XLBookWriter.SetCellValue(spreadsheetDocument, TimeDailySheetName, "A1", reportTitle);
                        if (data.PTimeDailyLog != null)
                        {
                            XLBookWriter.AppendDataInExcel(spreadsheetDocument, TimeDailySheetName, TimeDailyDataTable, data.PTimeDailyLog);
                        }

                        XLBookWriter.SetCellValue(spreadsheetDocument, TimeOTSheetName, "A1", reportTitle);
                        if (data.PTimeOtLog != null)
                        {
                            XLBookWriter.AppendDataInExcel(spreadsheetDocument, TimeOTSheetName, TimeOTDataTable, data.PTimeOtLog);
                        }

                        spreadsheetDocument.Save();
                    }
                    long length = templateStream.Length;
                    byteContent1 = templateStream.ToArray();
                }
                var file = File(byteContent1,
                            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                            stringFileName + ".xlsx");

                return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
            }
            catch (Exception ex)
            {
                throw new CustomJsonException(ex.Message, ex);
            }
        }

        [HttpGet]
        public async Task<IActionResult> GetProjectList(string fromProject)
        {
            var projnos = await _selectTcmPLRepository.SelectProjnoRapReportingProco(BaseSpTcmPLGet(), null);

            return Json(projnos);
        }

        #endregion Timesheet shift project manhours

        #region TimesheetPostedHours

        public async Task<IActionResult> TimesheetPostedHoursIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterRapIndex
            });

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            TSPostedHoursViewModel tSPostedHoursViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            var result = await _manageRepository.MonthStatusAsync(
                   BaseSpTcmPLGet(),
                   new ParameterSpTcmPL { }
                   );

            ViewBag.MsgType = result.PMessageType;
            ViewBag.MsgText = result.PMessageText;

            var data = await _tSRepostingDetailsRepository.TSRepostingDetailsAsync(
                   BaseSpTcmPLGet(),
                   new ParameterSpTcmPL { }
                   );
            if (data.PRepost != 0)
            {
                ViewBag.PostingCount = data.PRepost;
            }
            else
            {
                ViewBag.PostingCount = 0;
            }
            ViewData["ProcMonth"] = data.PProcMonth;
            return View(tSPostedHoursViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsTSPostedHours(string paramJson)
        {
            DTResult<TSPostedHoursDataTableList> result = new();
            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            try
            {
                System.Collections.Generic.IEnumerable<TSPostedHoursDataTableList> data = await _tSPostedHoursDataTableListRepository.TSPostedHoursDataTableListAsync(
                    BaseSpTcmPLGet(), new ParameterSpTcmPL
                    {
                        PYyyymm = param.Yyyymm
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

        public async Task<IActionResult> TSPostedHoursExcelDownload(string yyyymm)
        {
            var timeStamp = DateTime.Now.ToFileTime();

            string fileName = "TS Posted Hours_" + timeStamp.ToString();
            string reportTitle = "TS Posted Hours";
            string sheetName = "TS Posted Hours";

            IEnumerable<TSPostedHoursDataTableList> data = await _tSPostedHoursDataTableListRepository.TSPostedHoursDataTableListAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PYyyymm = yyyymm
                });

            if (data == null) { return NotFound(); }

            var json = JsonConvert.SerializeObject(data);

            IEnumerable<TSPostedHoursDataTableExcel> excelData = JsonConvert.DeserializeObject<IEnumerable<TSPostedHoursDataTableExcel>>(json);

            var byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, reportTitle, sheetName);

            var mimeType = MimeTypeMap.GetMimeType("xlsx");

            FileContentResult file = File(byteContent, mimeType, fileName);

            return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetTSPostedHoursTotal(string yyyymm)
        {
            try
            {
                var data = await _tSPostedHoursTotalRepository.TSPostedHoursTotalAllAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL { PYyyymm = yyyymm });

                return Json(data);
            }
            catch (Exception ex)
            {
                return Json(new { error = ex.Message });
            }
        }

        #endregion TimesheetPostedHours
    }
}