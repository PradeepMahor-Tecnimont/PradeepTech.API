using ClosedXML.Excel;
using ClosedXML.Report;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.CodeAnalysis;
using Microsoft.Extensions.Configuration;
using MimeTypes;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.Common;
using TCMPLApp.DataAccess.Repositories.JOB;
using TCMPLApp.Domain.Models;
using TCMPLApp.Domain.Models.Common;
using TCMPLApp.Domain.Models.JOB;
using TCMPLApp.Domain.Models.JOB.View;
using TCMPLApp.Library.Excel.Template;
using TCMPLApp.Library.Excel.Template.Models;
using TCMPLApp.WebApp.Classes;
using TCMPLApp.WebApp.Controllers;
using TCMPLApp.WebApp.CustomPolicyProvider;
using TCMPLApp.WebApp.Models;
using TCMPLApp.WebApp.Services;
using static TCMPLApp.WebApp.Classes.DTModel;

namespace TCMPLApp.WebApp.Areas.JOB.Controllers
{
    //[Authorize]
    [Area("JOB")]
    public class JOBController : BaseController
    {
        private const string ConstFilterJobsIndex = "Index";

        private readonly IConfiguration _configuration;
        private readonly IFilterRepository _filterRepository;
        private readonly IHttpClientRapReporting _httpClientRapReporting;
        private readonly IExcelTemplate _excelTemplate;
        private readonly ISelectTcmPLRepository _selectTcmPLRepository;
        private readonly IJobmasterDataTableListRepository _jobmasterDataTableListRepository;
        private readonly IJobmasterDetailRepository _jobmasterDetailRepository;
        private readonly IJobmasterBudgetApiRepository _jobmasterBudgetApiRepository;
        private readonly IJobmasterBudgetImportRepository _jobmasterBudgetImportRepository;
        private readonly IJobsMasterRepository _jobsMasterRepository;
        private readonly IJobEditRepository _jobEditRepository;
        private readonly IJobPhaseDataTableListRepository _jobPhaseDataTableListRepository;
        private readonly IJobMailListDataTableListRepository _jobMailListDataTableListRepository;
        private readonly IJobBudgetDataTableListRepository _jobBudgetDataTableListRepository;

        private readonly IJobNotesRepository _jobNotesRepository;
        private readonly IJobNotesDetailRepository _jobNotesDetailRepository;
        private readonly IJobPhaseRepository _jobPhaseRepository;
        private readonly IJobMailListRepository _jobMailListRepository;
        private readonly IJobPhaseDetailRepository _jobPhaseDetailRepository;
        private readonly IJobApproverStatusDetailRepository _jobApproverStatusDetailRepository;

        private readonly IJobErpPhasesFileDetailRepository _jobErpPhasesFileDetailRepository;
        private readonly IJobErpPhasesFileRepository _jobErpPhasesFileRepository;
        private readonly IJobPmJsRepository _jobPmJsRepository;
        private readonly IJobPmJsDetailRepository _jobPmJsDetailRepository;
        private readonly IJobResponsibleActionsListRepository _jobResponsibleActionsListRepository;
        private readonly IJobApprovalRepository _jobApprovalRepository;
        private readonly IJobResponsibleApproversDetailRepository _jobResponsibleApproversDetailRepository;
        private readonly IJobValidateStatusRepository _jobValidateStatusRepository;
        private readonly IClientRepository _clientRepository;


        public JOBController(IConfiguration configuration,
                             IFilterRepository filterRepository,
                             IHttpClientRapReporting httpClientRapReporting,
                             IExcelTemplate excelTemplate,
                             ISelectTcmPLRepository selectTcmPLRepository,
                             IJobmasterDataTableListRepository jobmasterDataTableListRepository,
                             IJobmasterDetailRepository jobmasterDetailRepository,
                             IJobmasterBudgetApiRepository jobmasterBudgetApiRepository,
                             IJobmasterBudgetImportRepository jobmasterBudgetImportRepository,
                             IJobsMasterRepository jobsMasterRepository,
                             IJobEditRepository jobEditRepository,
                             IJobPhaseDataTableListRepository jobPhaseDataTableListRepository,
                             IJobMailListDataTableListRepository jobMailListDataTableListRepository,
                             IJobNotesRepository jobNotesRepository,
                             IJobNotesDetailRepository jobNotesDetailRepository,
                             IJobPhaseRepository jobPhaseRepository,
                             IJobMailListRepository jobMailListRepository,
                             IJobPhaseDetailRepository jobPhaseDetailRepository,
                             IJobApproverStatusDetailRepository jobApproverStatusDetailRepository,
                             IJobBudgetDataTableListRepository jobBudgetDataTableListRepository,
                             IJobErpPhasesFileDetailRepository jobErpPhasesFileDetailRepository,
                             IJobErpPhasesFileRepository jobErpPhasesFileRepository,
                             IJobPmJsDetailRepository jobPmJsDetailRepository,
                             IJobPmJsRepository jobPmJsRepository,
                             IJobApprovalRepository jobApprovalRepository,
                             IJobResponsibleActionsListRepository jobResponsibleActionsListRepository,
                             IJobResponsibleApproversDetailRepository jobResponsibleApproversDetailRepository,
                             IJobValidateStatusRepository jobValidateStatusRepository,
                             IClientRepository clientRepository)
        {
            _configuration = configuration;
            _filterRepository = filterRepository;
            _httpClientRapReporting = httpClientRapReporting;
            _excelTemplate = excelTemplate;
            _selectTcmPLRepository = selectTcmPLRepository;
            _jobmasterDataTableListRepository = jobmasterDataTableListRepository;
            _jobmasterDetailRepository = jobmasterDetailRepository;
            _jobmasterBudgetApiRepository = jobmasterBudgetApiRepository;
            _jobmasterBudgetImportRepository = jobmasterBudgetImportRepository;
            _jobsMasterRepository = jobsMasterRepository;
            _jobEditRepository = jobEditRepository;
            _jobPhaseDataTableListRepository = jobPhaseDataTableListRepository;
            _jobMailListDataTableListRepository = jobMailListDataTableListRepository;
            _jobNotesRepository = jobNotesRepository;
            _jobNotesDetailRepository = jobNotesDetailRepository;
            _jobPhaseRepository = jobPhaseRepository;
            _jobMailListRepository = jobMailListRepository;
            _jobPhaseDetailRepository = jobPhaseDetailRepository;
            _jobApproverStatusDetailRepository = jobApproverStatusDetailRepository;
            _jobBudgetDataTableListRepository = jobBudgetDataTableListRepository;
            _jobErpPhasesFileDetailRepository = jobErpPhasesFileDetailRepository;
            _jobErpPhasesFileRepository = jobErpPhasesFileRepository;
            _jobPmJsRepository = jobPmJsRepository;
            _jobPmJsDetailRepository = jobPmJsDetailRepository;
            _jobApprovalRepository = jobApprovalRepository;
            _jobResponsibleActionsListRepository = jobResponsibleActionsListRepository;
            _jobResponsibleApproversDetailRepository = jobResponsibleApproversDetailRepository;
            _jobValidateStatusRepository = jobValidateStatusRepository;
            _clientRepository = clientRepository;
        }

        #region Jobs list
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionReadJob)]
        public async Task<IActionResult> Index()
        {
            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterJobsIndex
            });

            JobmasterViewModel jobmasterViewModel = new JobmasterViewModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                jobmasterViewModel.FilterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            return View(jobmasterViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionReadJob)]
        public async Task<JsonResult> GetJobsList(DTParameters param)
        {
            int totalRow = 0;

            DTResult<JobmasterDataTableList> result = new DTResult<JobmasterDataTableList>();

            try
            {
                var data = await _jobmasterDataTableListRepository.JobmasterDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
                        PIsActive = decimal.Parse(param.IsActive?.ToString() ?? "1"),
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

        private async Task<JobmasterMainDetailViewModel> JobDetailsData(string id)
        {
            JobmasterMainDetailOut result = await _jobmasterDetailRepository.JobmasterDetailMain(
                                    BaseSpTcmPLGet(),
                                    new ParameterSpTcmPL
                                    {
                                        PProjno = id
                                    });

            JobApproverStatus approverStatus = await _jobApproverStatusDetailRepository.ApproverStatusDetailAsync(
                                                BaseSpTcmPLGet(),
                                                new ParameterSpTcmPL
                                                {
                                                    PProjno = id
                                                });

            var empProjActions = await EmployeeProjActions(id);

            JobmasterMainDetailViewModel jobmasterMainDetail = new JobmasterMainDetailViewModel();

            if (result.PMessageType == IsOk)
            {
                jobmasterMainDetail.Projno = id;
                jobmasterMainDetail.JobModeStatus = result.PJobModeStatus;
                jobmasterMainDetail.FormMode = result.PFormMode;
                jobmasterMainDetail.Revision = result.PRevision;
                jobmasterMainDetail.PlantProgressNo = result.PPlantProgressNo;
                jobmasterMainDetail.ShortDesc = result.PShortDesc;
                jobmasterMainDetail.CompanyName = result.PCompanyName;
                jobmasterMainDetail.JobTypeName = result.PJobTypeName;
                jobmasterMainDetail.IsConsortium = result.PIsconsortium;
                jobmasterMainDetail.Tcmno = result.PTcmno;
                jobmasterMainDetail.Place = result.PPlace;
                jobmasterMainDetail.Country = result.PCountry;
                jobmasterMainDetail.CountryName = result.PCountryName;
                jobmasterMainDetail.ScopeOfWork = result.PScopeOfWork;
                jobmasterMainDetail.ScopeOfWorkName = result.PScopeOfWorkName;
                jobmasterMainDetail.Loc = result.PLoc;
                jobmasterMainDetail.StateName = result.PStateName;
                jobmasterMainDetail.PlantType = result.PPlantType;
                jobmasterMainDetail.PlantTypeName = result.PPlantTypeName;
                jobmasterMainDetail.BusinessLine = result.PBusinessLine;
                jobmasterMainDetail.BusinessLineName = result.PBusinessLineName;
                jobmasterMainDetail.SubBusinessLineName = result.PSubBusinessLineName;
                jobmasterMainDetail.Projtype = result.PProjtype;
                jobmasterMainDetail.ProjectTypeName = result.PProjectTypeName;
                jobmasterMainDetail.InvoiceToGrp = result.PInvoiceToGrp;
                jobmasterMainDetail.InvoiceToGrpName = result.PInvoiceToGrpName;
                jobmasterMainDetail.Client = result.PClient;
                jobmasterMainDetail.ContractNumber = result.PContractNumber;
                jobmasterMainDetail.ContractDate = result.PContractDate;
                jobmasterMainDetail.StartDate = result.PStartDate;
                jobmasterMainDetail.RevCloseDate = result.PRevCloseDate;
                jobmasterMainDetail.ExpCloseDate = result.PExpCloseDate;
                jobmasterMainDetail.ActualCloseDate = result.PActualCloseDate;
                jobmasterMainDetail.PmName = result.PPmName;
                jobmasterMainDetail.InchargeName = result.PInchargeName;
                jobmasterMainDetail.BudgetAttached = result.PBudgetAttached;
                jobmasterMainDetail.OpeningMonth = result.POpeningMonth;
                jobmasterMainDetail.JobStatus = result.PJobstatus;
                jobmasterMainDetail.IsLegacy = result.PIsLegacy;
                jobmasterMainDetail.ApprovalStatus = approverStatus;
                jobmasterMainDetail.ProjectActions = empProjActions;
                System.DateTime dt = Convert.ToDateTime(jobmasterMainDetail.OpeningMonth).AddDays(0.0);
                ViewData["YYYYMM"] = dt.ToString("yyyyMM");
                jobmasterMainDetail.ClientCode = result.PClientCode;
                jobmasterMainDetail.ClientCodeName = result.PClientCodeName;
            }
            return jobmasterMainDetail;
        }

        private async Task<IEnumerable<ProfileAction>> EmployeeProjActions(string id)
        {
            var actionsList = await _jobResponsibleActionsListRepository.JobResponsibleActionsList(BaseSpTcmPLGet(),
                                                new ParameterSpTcmPL
                                                {
                                                    PProjno = id
                                                });

            actionsList = actionsList ?? Enumerable.Empty<ProfileAction>();
            return actionsList;
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionReadJob)]
        public async Task<IActionResult> Detail(string id)
        {
            try
            {
                if (id == null)
                    return NotFound();

                var jobmasterMainDetail = await JobDetailsData(id);


                return View(jobmasterMainDetail);
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
            }

            return RedirectToAction("Index");
        }

        public async Task<IActionResult> GetStateList(string id)
        {
            IEnumerable<DataAccess.Models.DataField> itemList = Enumerable.Empty<DataAccess.Models.DataField>();

            if (id != "IN")
            {
                return Json(itemList);
            }

            itemList = await _selectTcmPLRepository.StateListAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                });

            return Json(itemList);
        }


        //[RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionJobCreate)]
        public async Task<IActionResult> Create(string id)
        {
            JobCreateViewModel jobCreateViewModel = new();

            var companies = await _selectTcmPLRepository.COListAsync(BaseSpTcmPLGet(), null);
            ViewData["COList"] = new SelectList(companies, "DataValueField", "DataTextField");

            var tmagrps = await _selectTcmPLRepository.JobTMAGroupListAsync(BaseSpTcmPLGet(), null);
            ViewData["JobTypesList"] = new SelectList(tmagrps, "DataValueField", "DataTextField");

            var countries = await _selectTcmPLRepository.CountryListAsync(BaseSpTcmPLGet(), null);
            ViewData["CountriesList"] = new SelectList(countries, "DataValueField", "DataTextField");

            var plantTypes = await _selectTcmPLRepository.PlantTypeListAsync(BaseSpTcmPLGet(), null);
            ViewData["PlantTypesList"] = new SelectList(plantTypes, "DataValueField", "DataTextField");

            var businessLines = await _selectTcmPLRepository.BusinessLineListAsync(BaseSpTcmPLGet(), null);
            ViewData["BusinessLinesList"] = new SelectList(businessLines, "DataValueField", "DataTextField");

            var subBusinessLines = await _selectTcmPLRepository.SubBusinessLineListAsync(BaseSpTcmPLGet(), null);
            ViewData["SubBusinessLinesList"] = new SelectList(subBusinessLines, "DataValueField", "DataTextField");

            var scopeOfWorks = await _selectTcmPLRepository.ScopeOfWorkListAsync(BaseSpTcmPLGet(), null);
            ViewData["ScopeOfWorksList"] = new SelectList(scopeOfWorks, "DataValueField", "DataTextField");

            if (id == "OnBehalf")
            {
                var employees = await _selectTcmPLRepository.OnBehalfPrincipalList(BaseSpTcmPLGet(), null);
                ViewData["ERPPMList"] = new SelectList(employees, "DataValueField", "DataTextField");
                jobCreateViewModel.IsOnBehalf = true;
            }
            else
                jobCreateViewModel.IsOnBehalf = false;

            return View(jobCreateViewModel);
        }

        [HttpPost]
        //[RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionJobCreate)]
        public async Task<IActionResult> Create([FromForm] JobCreateViewModel jobCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    DBProcMessageOutput result = await _jobsMasterRepository.AddJobAsync(
                    BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PProjno = jobCreateViewModel.Projno,
                            PRevision = jobCreateViewModel.Revision ?? 0,
                            PFormDate = jobCreateViewModel.FormDate,
                            PCompany = jobCreateViewModel.Company,
                            PJobType = jobCreateViewModel.JobType,
                            PIsConsortium = jobCreateViewModel.IsConsortium,
                            PTcmno = jobCreateViewModel.Tcmno ?? " ",
                            PPlantProgressNo = jobCreateViewModel.PlantProgressNo,
                            PPlace = jobCreateViewModel.Place,
                            PCountry = jobCreateViewModel.Country,
                            PState = jobCreateViewModel.State ?? " ",
                            PScopeOfWork = jobCreateViewModel.ScopeOfWork,
                            PPlantType = jobCreateViewModel.PlantType,
                            PBusinessLine = jobCreateViewModel.BusinessLine,
                            PSubBusinessLine = jobCreateViewModel.SubBusinessLine,
                            PClientName = jobCreateViewModel.ClientName,
                            PContractNumber = jobCreateViewModel.ContractNumber ?? " ",
                            PContractDate = jobCreateViewModel.ContractDate,
                            PStartDate = jobCreateViewModel.StartDate,
                            PRevCloseDate = jobCreateViewModel.RevCloseDate,
                            PExpCloseDate = jobCreateViewModel.ExpCloseDate,
                            PActualCloseDate = jobCreateViewModel.ActualCloseDate,
                            PInitiateApproval = jobCreateViewModel.InitiateApproval ?? 0,
                            PPmEmpno = jobCreateViewModel.PMEmpno
                        });

                    if (result.PMessageType != IsOk)
                    {
                        Notify("Error", result.PMessageText.Replace("-", " "), "toaster", NotificationType.error);
                    }
                    else
                    {
                        Notify("Success", result.PMessageText.Replace("-", " "), "toaster", NotificationType.success);

                        return RedirectToAction("Index");
                    }
                }
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
            }


            var companies = await _selectTcmPLRepository.COListAsync(BaseSpTcmPLGet(), null);
            ViewData["COList"] = new SelectList(companies, "DataValueField", "DataTextField", jobCreateViewModel.Company);

            var tmagrps = await _selectTcmPLRepository.JobTMAGroupListAsync(BaseSpTcmPLGet(), null);
            ViewData["JobTypesList"] = new SelectList(tmagrps, "DataValueField", "DataTextField", jobCreateViewModel.JobType);

            var countries = await _selectTcmPLRepository.CountryListAsync(BaseSpTcmPLGet(), null);
            ViewData["CountriesList"] = new SelectList(countries, "DataValueField", "DataTextField", jobCreateViewModel.Country);

            var states = await _selectTcmPLRepository.StateListAsync(BaseSpTcmPLGet(), null);
            ViewData["States"] = new SelectList(states, "DataValueField", "DataTextField", jobCreateViewModel.State);

            var plantTypes = await _selectTcmPLRepository.PlantTypeListAsync(BaseSpTcmPLGet(), null);
            ViewData["PlantTypesList"] = new SelectList(plantTypes, "DataValueField", "DataTextField", jobCreateViewModel.PlantType);

            var businessLines = await _selectTcmPLRepository.BusinessLineListAsync(BaseSpTcmPLGet(), null);
            ViewData["BusinessLinesList"] = new SelectList(businessLines, "DataValueField", "DataTextField", jobCreateViewModel.BusinessLine);

            var subBusinessLines = await _selectTcmPLRepository.SubBusinessLineListAsync(BaseSpTcmPLGet(), null);
            ViewData["SubBusinessLinesList"] = new SelectList(subBusinessLines, "DataValueField", "DataTextField", jobCreateViewModel.SubBusinessLine);

            var scopeOfWorks = await _selectTcmPLRepository.ScopeOfWorkListAsync(BaseSpTcmPLGet(), null);
            ViewData["ScopeOfWorksList"] = new SelectList(scopeOfWorks, "DataValueField", "DataTextField", jobCreateViewModel.ScopeOfWork);

            if (jobCreateViewModel.IsOnBehalf == true)
            {
                var employees = await _selectTcmPLRepository.OnBehalfPrincipalList(BaseSpTcmPLGet(), null);
                ViewData["ERPPMList"] = new SelectList(employees, "DataValueField", "DataTextField");
            }

            return View(jobCreateViewModel);
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionJobCreate)]
        public async Task<IActionResult> EditJob(string id)
        {
            if (id == null)
                return NotFound();

            JobCreateViewModel jobCreateViewModel = new();

            JobmasterMainDetailOut result = await _jobmasterDetailRepository.JobmasterDetailMain(
                                                BaseSpTcmPLGet(),
                                                new ParameterSpTcmPL
                                                {
                                                    PProjno = id
                                                });
            JobApproverStatus approverStatus = await _jobApproverStatusDetailRepository.ApproverStatusDetailAsync(
                                                BaseSpTcmPLGet(),
                                                new ParameterSpTcmPL
                                                {
                                                    PProjno = id
                                                });

            if (result.PMessageType == IsOk)
            {
                jobCreateViewModel.Projno = id;
                jobCreateViewModel.Revision = decimal.Parse(result.PRevision);
                jobCreateViewModel.PlantProgressNo = result.PPlantProgressNo;
                jobCreateViewModel.Company = result.PCompany;
                jobCreateViewModel.JobType = result.PJobType;
                jobCreateViewModel.IsConsortium = result.PIsconsortium;
                jobCreateViewModel.Tcmno = result.PTcmno;
                jobCreateViewModel.Place = result.PPlace;
                jobCreateViewModel.Country = result.PCountry;
                jobCreateViewModel.State = result.PLoc;
                jobCreateViewModel.ScopeOfWork = result.PScopeOfWork;
                jobCreateViewModel.PlantType = result.PPlantType;
                jobCreateViewModel.BusinessLine = result.PBusinessLine;
                jobCreateViewModel.ProjectType = result.PProjtype;
                jobCreateViewModel.InvoiceToGrpCompany = result.PInvoiceToGrp;
                jobCreateViewModel.ClientName = result.PClient;
                jobCreateViewModel.ContractNumber = result.PContractNumber;
                jobCreateViewModel.ClientCodeName = result.PClientCodeName;
                jobCreateViewModel.IsLegacy = result.PIsLegacy;


                System.DateTime dtForm;
                if (result.PFormDate != null && System.DateTime.TryParseExact(result.PFormDate, "dd-MMM-yy", CultureInfo.InvariantCulture, DateTimeStyles.None, out dtForm))
                {
                    jobCreateViewModel.FormDate = dtForm;
                }

                System.DateTime dtContract;
                if (result.PContractDate != null && System.DateTime.TryParseExact(result.PContractDate, "dd-MMM-yy", CultureInfo.InvariantCulture, DateTimeStyles.None, out dtContract))
                {
                    jobCreateViewModel.ContractDate = dtContract;
                }

                System.DateTime dtStart;
                if (result.PStartDate != null && System.DateTime.TryParseExact(result.PStartDate, "dd-MMM-yy", CultureInfo.InvariantCulture, DateTimeStyles.None, out dtStart))
                {
                    jobCreateViewModel.StartDate = dtStart;
                }

                System.DateTime dtRevClose;
                if (result.PRevCloseDate != null && System.DateTime.TryParseExact(result.PRevCloseDate, "dd-MMM-yy", CultureInfo.InvariantCulture, DateTimeStyles.None, out dtRevClose))
                {
                    jobCreateViewModel.RevCloseDate = dtRevClose;
                }

                System.DateTime dtExpClose;
                if (result.PExpCloseDate != null && System.DateTime.TryParseExact(result.PExpCloseDate, "dd-MMM-yy", CultureInfo.InvariantCulture, DateTimeStyles.None, out dtExpClose))
                {
                    jobCreateViewModel.ExpCloseDate = dtExpClose;
                }                

                ViewData["ProjectTypeName"] = result.PProjectTypeName;
                ViewData["InvoiceToGrpCompanyVal"] = result.PInvoiceToGrpName;
                ViewData["ShortDesc"] = result.PShortDesc;
            }

            var companies = await _selectTcmPLRepository.COListAsync(BaseSpTcmPLGet(), null);
            ViewData["COList"] = new SelectList(companies, "DataValueField", "DataTextField", result.PCompany);

            var tmagrps = await _selectTcmPLRepository.JobTMAGroupListAsync(BaseSpTcmPLGet(), null);
            ViewData["JobTypesList"] = new SelectList(tmagrps, "DataValueField", "DataTextField", result.PJobType);

            var countries = await _selectTcmPLRepository.CountryListAsync(BaseSpTcmPLGet(), null);
            ViewData["CountriesList"] = new SelectList(countries, "DataValueField", "DataTextField", result.PCountry);

            var states = await _selectTcmPLRepository.StateListAsync(BaseSpTcmPLGet(), null);
            ViewData["StatesList"] = new SelectList(states, "DataValueField", "DataTextField", result.PLoc);

            var plantTypes = await _selectTcmPLRepository.PlantTypeListAsync(BaseSpTcmPLGet(), null);
            ViewData["PlantTypesList"] = new SelectList(plantTypes, "DataValueField", "DataTextField", result.PPlantType);

            var businessLines = await _selectTcmPLRepository.BusinessLineListAsync(BaseSpTcmPLGet(), null);
            ViewData["BusinessLinesList"] = new SelectList(businessLines, "DataValueField", "DataTextField", result.PBusinessLine);

            var subBusinessLines = await _selectTcmPLRepository.SubBusinessLineListAsync(BaseSpTcmPLGet(), null);
            ViewData["SubBusinessLinesList"] = new SelectList(subBusinessLines, "DataValueField", "DataTextField", result.PSubBusinessLine);

            var scopeOfWorks = await _selectTcmPLRepository.ScopeOfWorkListAsync(BaseSpTcmPLGet(), null);
            ViewData["ScopeOfWorksList"] = new SelectList(scopeOfWorks, "DataValueField", "DataTextField", result.PScopeOfWork);

            return View(jobCreateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionJobCreate)]
        public async Task<IActionResult> EditJob([FromForm] JobCreateViewModel jobCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    DBProcMessageOutput result = await _jobsMasterRepository.EditJobAsync(
                    BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PProjno = jobCreateViewModel.Projno,
                            PRevision = jobCreateViewModel.Revision ?? 0,
                            PFormDate = jobCreateViewModel.FormDate,
                            PCompany = jobCreateViewModel.Company,
                            PJobType = jobCreateViewModel.JobType,
                            PIsConsortium = jobCreateViewModel.IsConsortium ?? 0,
                            PTcmno = jobCreateViewModel.Tcmno ?? " ",
                            PPlantProgressNo = jobCreateViewModel.PlantProgressNo ?? " ",
                            PPlace = jobCreateViewModel.Place,
                            PCountry = jobCreateViewModel.Country,
                            PState = jobCreateViewModel.State ?? " ",
                            PScopeOfWork = jobCreateViewModel.ScopeOfWork,
                            PPlantType = jobCreateViewModel.PlantType,
                            PBusinessLine = jobCreateViewModel.BusinessLine,
                            PSubBusinessLine = jobCreateViewModel.SubBusinessLine,
                            PClientName = jobCreateViewModel.ClientName,
                            PContractNumber = jobCreateViewModel.ContractNumber ?? " ",
                            PContractDate = jobCreateViewModel.ContractDate,
                            PStartDate = jobCreateViewModel.StartDate,
                            PRevCloseDate = jobCreateViewModel.RevCloseDate,
                            PExpCloseDate = jobCreateViewModel.ExpCloseDate,                            
                            PInitiateApproval = jobCreateViewModel.InitiateApproval ?? 0
                        });

                    if (result.PMessageType != IsOk)
                    {
                        Notify("Error", result.PMessageText.Replace("-", " "), "toaster", NotificationType.error);
                    }
                    else
                    {
                        Notify("Success", result.PMessageText.Replace("-", " "), "toaster", NotificationType.success);

                        return RedirectToAction("Index");
                    }
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            var companies = await _selectTcmPLRepository.COListAsync(BaseSpTcmPLGet(), null);
            ViewData["COList"] = new SelectList(companies, "DataValueField", "DataTextField", jobCreateViewModel.Company);

            var tmagrps = await _selectTcmPLRepository.JobTMAGroupListAsync(BaseSpTcmPLGet(), null);
            ViewData["JobTypesList"] = new SelectList(tmagrps, "DataValueField", "DataTextField", jobCreateViewModel.JobType);

            var countries = await _selectTcmPLRepository.CountryListAsync(BaseSpTcmPLGet(), null);
            ViewData["CountriesList"] = new SelectList(countries, "DataValueField", "DataTextField", jobCreateViewModel.Country);

            var states = await _selectTcmPLRepository.StateListAsync(BaseSpTcmPLGet(), null);
            ViewData["States"] = new SelectList(states, "DataValueField", "DataTextField", jobCreateViewModel.State);

            var plantTypes = await _selectTcmPLRepository.PlantTypeListAsync(BaseSpTcmPLGet(), null);
            ViewData["PlantTypesList"] = new SelectList(plantTypes, "DataValueField", "DataTextField", jobCreateViewModel.PlantType);

            var businessLines = await _selectTcmPLRepository.BusinessLineListAsync(BaseSpTcmPLGet(), null);
            ViewData["BusinessLinesList"] = new SelectList(businessLines, "DataValueField", "DataTextField", jobCreateViewModel.BusinessLine);

            var subBusinessLines = await _selectTcmPLRepository.SubBusinessLineListAsync(BaseSpTcmPLGet(), null);
            ViewData["SubBusinessLinesList"] = new SelectList(subBusinessLines, "DataValueField", "DataTextField", jobCreateViewModel.SubBusinessLine);

            var scopeOfWorks = await _selectTcmPLRepository.ScopeOfWorkListAsync(BaseSpTcmPLGet(), null);
            ViewData["ScopeOfWorksList"] = new SelectList(scopeOfWorks, "DataValueField", "DataTextField", jobCreateViewModel.ScopeOfWork);

            return View(jobCreateViewModel);
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionJobUpdateTcmno)]
        public async Task<IActionResult> Edit(string id)
        {
            if (id == null)
                return NotFound();

            JobEditViewModel jobEditViewModel = new();

            JobmasterMainDetailOut result = await _jobmasterDetailRepository.JobmasterDetailMain(
                                                BaseSpTcmPLGet(),
                                                new ParameterSpTcmPL
                                                {
                                                    PProjno = id
                                                });

            jobEditViewModel.Projno = id;
            jobEditViewModel.Tcmno = result.PTcmno;

            ViewData["Title"] = result.PShortDesc + " [ " + id + " ] ";

            return PartialView("_ModalEdit", jobEditViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionJobUpdateTcmno)]
        public async Task<IActionResult> Edit([FromForm] JobEditViewModel jobEditViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    DBProcMessageOutput result = await _jobEditRepository.UpdateJobAsync(
                    BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PProjno = jobEditViewModel.Projno,
                            PTcmno = jobEditViewModel.Tcmno
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

            return View(jobEditViewModel);
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionJobCreateRevision)]
        public async Task<IActionResult> ReviseJob(string id)
        {
            if (id == null)
                return NotFound();

            JobCreateViewModel jobCreateViewModel = new();

            JobmasterMainDetailOut result = await _jobmasterDetailRepository.JobmasterDetailMain(
                                                BaseSpTcmPLGet(),
                                                new ParameterSpTcmPL
                                                {
                                                    PProjno = id
                                                });

            JobApproverStatus approverStatus = await _jobApproverStatusDetailRepository.ApproverStatusDetailAsync(
                                                BaseSpTcmPLGet(),
                                                new ParameterSpTcmPL
                                                {
                                                    PProjno = id
                                                });

            if (result.PMessageType == IsOk)
            {
                jobCreateViewModel.Projno = id;
                jobCreateViewModel.Revision = decimal.Parse(result.PRevision) + 1;
                jobCreateViewModel.PlantProgressNo = result.PPlantProgressNo;
                jobCreateViewModel.Company = result.PCompany;
                jobCreateViewModel.JobType = result.PJobType;
                jobCreateViewModel.IsConsortium = result.PIsconsortium;
                jobCreateViewModel.Tcmno = result.PTcmno;
                jobCreateViewModel.Place = result.PPlace;
                jobCreateViewModel.Country = result.PCountry;
                jobCreateViewModel.ScopeOfWork = result.PScopeOfWork;
                jobCreateViewModel.State = result.PLoc;
                jobCreateViewModel.PlantType = result.PPlantType;
                jobCreateViewModel.BusinessLine = result.PBusinessLine;
                jobCreateViewModel.ProjectType = result.PProjtype;
                jobCreateViewModel.InvoiceToGrpCompany = result.PInvoiceToGrp;
                jobCreateViewModel.ClientName = result.PClient;
                jobCreateViewModel.ContractNumber = result.PContractNumber;
                jobCreateViewModel.IsLegacy = result.PIsLegacy;
                jobCreateViewModel.ClientCodeName = result.PClientCodeName;

                System.DateTime dtForm;
                if (result.PFormDate != null && System.DateTime.TryParseExact(result.PFormDate, "dd-MMM-yy", CultureInfo.InvariantCulture, DateTimeStyles.None, out dtForm))
                {
                    jobCreateViewModel.FormDate = dtForm;
                }

                System.DateTime dtContract;
                if (result.PContractDate != null && System.DateTime.TryParseExact(result.PContractDate, "dd-MMM-yy", CultureInfo.InvariantCulture, DateTimeStyles.None, out dtContract))
                {
                    jobCreateViewModel.ContractDate = dtContract;
                }

                System.DateTime dtStart;
                if (result.PStartDate != null && System.DateTime.TryParseExact(result.PStartDate, "dd-MMM-yy", CultureInfo.InvariantCulture, DateTimeStyles.None, out dtStart))
                {
                    jobCreateViewModel.StartDate = dtStart;
                }

                System.DateTime dtRevClose;
                if (result.PRevCloseDate != null && System.DateTime.TryParseExact(result.PRevCloseDate, "dd-MMM-yy", CultureInfo.InvariantCulture, DateTimeStyles.None, out dtRevClose))
                {
                    jobCreateViewModel.RevCloseDate = dtRevClose;
                }

                System.DateTime dtExpClose;
                if (result.PExpCloseDate != null && System.DateTime.TryParseExact(result.PExpCloseDate, "dd-MMM-yy", CultureInfo.InvariantCulture, DateTimeStyles.None, out dtExpClose))
                {
                    jobCreateViewModel.ExpCloseDate = dtExpClose;
                }                

                ViewData["InvoiceToGrpCompanyVal"] = result.PInvoiceToGrpName;
                ViewData["ProjectTypeName"] = result.PProjectTypeName;
                ViewData["ShortDesc"] = result.PShortDesc;
            }

            var companies = await _selectTcmPLRepository.COListAsync(BaseSpTcmPLGet(), null);
            ViewData["COList"] = new SelectList(companies, "DataValueField", "DataTextField", result.PCompany);

            var tmagrps = await _selectTcmPLRepository.JobTMAGroupListAsync(BaseSpTcmPLGet(), null);
            ViewData["JobTypesList"] = new SelectList(tmagrps, "DataValueField", "DataTextField", result.PJobType);

            var countries = await _selectTcmPLRepository.CountryListAsync(BaseSpTcmPLGet(), null);
            ViewData["CountriesList"] = new SelectList(countries, "DataValueField", "DataTextField", result.PCountry);

            var states = await _selectTcmPLRepository.StateListAsync(BaseSpTcmPLGet(), null);
            ViewData["StatesList"] = new SelectList(states, "DataValueField", "DataTextField", result.PLoc);

            var plantTypes = await _selectTcmPLRepository.PlantTypeListAsync(BaseSpTcmPLGet(), null);
            ViewData["PlantTypesList"] = new SelectList(plantTypes, "DataValueField", "DataTextField", result.PPlantType);

            var businessLines = await _selectTcmPLRepository.BusinessLineListAsync(BaseSpTcmPLGet(), null);
            ViewData["BusinessLinesList"] = new SelectList(businessLines, "DataValueField", "DataTextField", result.PBusinessLine);

            var subBusinessLines = await _selectTcmPLRepository.SubBusinessLineListAsync(BaseSpTcmPLGet(), null);
            ViewData["SubBusinessLinesList"] = new SelectList(subBusinessLines, "DataValueField", "DataTextField", result.PSubBusinessLine);

            var scopeOfWorks = await _selectTcmPLRepository.ScopeOfWorkListAsync(BaseSpTcmPLGet(), null);
            ViewData["ScopeOfWorksList"] = new SelectList(scopeOfWorks, "DataValueField", "DataTextField", result.PScopeOfWork);

            return View(jobCreateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionJobCreateRevision)]
        public async Task<IActionResult> ReviseJob([FromForm] JobCreateViewModel jobCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    DBProcMessageOutput result = await _jobsMasterRepository.ReviseJobAsync(
                    BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PProjno = jobCreateViewModel.Projno,
                            PRevision = jobCreateViewModel.Revision,
                            PCompany = jobCreateViewModel.Company,
                            PJobType = jobCreateViewModel.JobType,
                            PIsConsortium = jobCreateViewModel.IsConsortium,
                            PTcmno = jobCreateViewModel.Tcmno ?? " ",
                            //PPlantProgressNo = jobCreateViewModel.PlantProgressNo ?? " ",
                            //PPlace = jobCreateViewModel.Place,
                            //PCountry = jobCreateViewModel.Country,
                            //PState = jobCreateViewModel.State ?? " ",
                            //PScopeOfWork = jobCreateViewModel.ScopeOfWork,
                            PPlantType = jobCreateViewModel.PlantType,
                            PBusinessLine = jobCreateViewModel.BusinessLine,
                            PSubBusinessLine = jobCreateViewModel.SubBusinessLine,
                            PClientName = jobCreateViewModel.ClientName,
                            PContractNumber = jobCreateViewModel.ContractNumber ?? " ",
                            PContractDate = jobCreateViewModel.ContractDate,
                            PStartDate = jobCreateViewModel.StartDate,
                            PRevCloseDate = jobCreateViewModel.RevCloseDate,
                            PExpCloseDate = jobCreateViewModel.ExpCloseDate,                            
                            PInitiateApproval = jobCreateViewModel.InitiateApproval ?? 0
                        });

                    if (result.PMessageType != IsOk)
                    {
                        Notify("Error", result.PMessageText.Replace("-", " "), "toaster", NotificationType.error);
                    }
                    else
                    {
                        Notify("Success", result.PMessageText.Replace("-", " "), "toaster", NotificationType.success);

                        return RedirectToAction("Detail", new { id = jobCreateViewModel.Projno });
                    }
                }
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
            }

            var companies = await _selectTcmPLRepository.COListAsync(BaseSpTcmPLGet(), null);
            ViewData["COList"] = new SelectList(companies, "DataValueField", "DataTextField", jobCreateViewModel.Company);

            var tmagrps = await _selectTcmPLRepository.JobTMAGroupListAsync(BaseSpTcmPLGet(), null);
            ViewData["JobTypesList"] = new SelectList(tmagrps, "DataValueField", "DataTextField", jobCreateViewModel.JobType);

            var countries = await _selectTcmPLRepository.CountryListAsync(BaseSpTcmPLGet(), null);
            ViewData["CountriesList"] = new SelectList(countries, "DataValueField", "DataTextField", jobCreateViewModel.Country);

            var states = await _selectTcmPLRepository.StateListAsync(BaseSpTcmPLGet(), null);
            ViewData["States"] = new SelectList(states, "DataValueField", "DataTextField", jobCreateViewModel.State);

            var plantTypes = await _selectTcmPLRepository.PlantTypeListAsync(BaseSpTcmPLGet(), null);
            ViewData["PlantTypesList"] = new SelectList(plantTypes, "DataValueField", "DataTextField", jobCreateViewModel.PlantType);

            var businessLines = await _selectTcmPLRepository.BusinessLineListAsync(BaseSpTcmPLGet(), null);
            ViewData["BusinessLinesList"] = new SelectList(businessLines, "DataValueField", "DataTextField", jobCreateViewModel.BusinessLine);

            var subBusinessLines = await _selectTcmPLRepository.SubBusinessLineListAsync(BaseSpTcmPLGet(), null);
            ViewData["SubBusinessLinesList"] = new SelectList(subBusinessLines, "DataValueField", "DataTextField", jobCreateViewModel.SubBusinessLine);

            var scopeOfWorks = await _selectTcmPLRepository.ScopeOfWorkListAsync(BaseSpTcmPLGet(), null);
            ViewData["ScopeOfWorksList"] = new SelectList(scopeOfWorks, "DataValueField", "DataTextField", jobCreateViewModel.ScopeOfWork);

            return View(jobCreateViewModel);
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionJobApprovalAfc)]
        public async Task<IActionResult> EditAFC(string id, string clientName)
        {
            if (id == null)
                return NotFound();

            JobEditAFCViewModel jobEditAFCViewModel = new();

            JobmasterMainDetailOut result = await _jobmasterDetailRepository.JobmasterDetailMain(
                                                BaseSpTcmPLGet(),
                                                new ParameterSpTcmPL
                                                {
                                                    PProjno = id
                                                });

            jobEditAFCViewModel.Projno = id;
            jobEditAFCViewModel.ProjectType = result.PProjtype;
            jobEditAFCViewModel.InvoiceToGrpCompany = result.PInvoiceToGrp;

            var client = await _selectTcmPLRepository.ClientList(BaseSpTcmPLGet(), null);
            jobEditAFCViewModel.Client = clientName == null ? result.PClientCode : client.Where(m => m.DataTextField == clientName).Select(t => t.DataValueField).FirstOrDefault();
            ViewData["ClientList"] = new SelectList(client, "DataValueField", "DataTextField", jobEditAFCViewModel.Client);

            var contractTypes = await _selectTcmPLRepository.ContractTypeListAsync(BaseSpTcmPLGet(), null);
            ViewData["ProjectTypesList"] = new SelectList(contractTypes, "DataValueField", "DataTextField", jobEditAFCViewModel.ProjectType);

            var invoicingtogrpcompanies = await _selectTcmPLRepository.InvoicingGroupCompanySelectListCacheAsync(BaseSpTcmPLGet(), null);
            ViewData["InvoiceToGrpCompanyList"] = new SelectList(invoicingtogrpcompanies, "DataValueField", "DataTextField", jobEditAFCViewModel.InvoiceToGrpCompany);

            ViewData["Title"] = result.PShortDesc + " [ " + id + " ] ";

            return PartialView("_ModalAFCEdit", jobEditAFCViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionJobApprovalAfc)]
        public async Task<IActionResult> EditAFC([FromForm] JobEditAFCViewModel jobEditAFCViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    DBProcMessageOutput result = await _jobApprovalRepository.AfcApprovalAsync(
                    BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PProjno = jobEditAFCViewModel.Projno,
                            PClient = jobEditAFCViewModel.Client,
                            PProjectType = jobEditAFCViewModel.ProjectType,
                            PInvoiceToGrp = jobEditAFCViewModel.InvoiceToGrpCompany
                        });

                    if (result.PMessageType == NotOk)
                    {
                        //Notify("Error", result.PMessageText.Replace("-", " "), "toaster", NotificationType.error);
                        return Json(new { error = true, response = result.PMessageText });
                    }
                    else
                    {
                        Notify("Success", StringHelper.CleanExceptionMessage(result.PMessageText), "toaster", NotificationType.success);
                        return RedirectToAction("ApprovalAFCIndex");
                        //return Json(new { success = result.PMessageType == Success, message = result.PMessageText });
                    }

                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            var client = await _selectTcmPLRepository.ClientList(BaseSpTcmPLGet(), null);
            ViewData["ClientList"] = new SelectList(client, "DataValueField", "DataTextField", jobEditAFCViewModel.Client);

            var contractTypes = await _selectTcmPLRepository.ContractTypeListAsync(BaseSpTcmPLGet(), null);
            ViewData["ProjectTypesList"] = new SelectList(contractTypes, "DataValueField", "DataTextField", jobEditAFCViewModel.ProjectType);

            var invoicingtogrpcompanies = await _selectTcmPLRepository.InvoicingGroupCompanySelectListCacheAsync(BaseSpTcmPLGet(), null);
            ViewData["InvoiceToGrpCompanyList"] = new SelectList(invoicingtogrpcompanies, "DataValueField", "DataTextField", jobEditAFCViewModel.InvoiceToGrpCompany);

            return View("_ModalAFCEdit", jobEditAFCViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionJobEdit)]
        public async Task<IActionResult> Send4Approval(string id)
        {
            if (id == null)
                return NotFound();

            var empProjActions = await EmployeeProjActions(id);

            if (!empProjActions.Any(a => a.ActionId == JOBHelper.ActionJobEdit))
                return Forbid();

            string msgText = string.Empty;

            try
            {
                var result = await _jobApprovalRepository.JobApprovalinitiationAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PProjno = id
                        });

                if (result.PMessageType != "OK")
                {
                    Notify("Error", result.PMessageText.Replace("-", " "), "toaster", NotificationType.error);
                    //return Json(new { error = true, response = result.PMessageText });
                    return Json(new { success = result.PMessageType == IsOk, message = result.PMessageText });
                }
                else
                {
                    Notify("Success", result.PMessageText.Replace("-", " "), "toaster", NotificationType.success);
                    return Json(new { success = result.PMessageType == IsOk, message = result.PMessageText });
                }
            }
            catch (Exception ex)
            {
                msgText = ex.Message.ToString();
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(msgText));
            }

        }

        #endregion Jobs list

        #region JS/PM change

        public async Task<IActionResult> EditPmJs(string id)
        {
            if (!(CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == JOBHelper.ActionJobChangeErpPm) || CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == JOBHelper.ActionJobChangeSponsor)))
            {
                return Forbid();
            }

            if (id == null)
                return NotFound();

            string roleName = string.Empty;
            string titleName = string.Empty;

            JobEditPmJsViewModel jobEditPmJsViewModel = new();

            var empProjActions = await EmployeeProjActions(id);


            if ((CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.JOB.JOBHelper.ActionJobChangeSponsor)
                                  && empProjActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.JOB.JOBHelper.ActionJobChangeSponsor)))
            {
                roleName = "PM";
                titleName = "Update job sponsor";
            }

            if ((CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.JOB.JOBHelper.ActionJobChangeErpPm)
                                  && empProjActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.JOB.JOBHelper.ActionJobChangeErpPm)))
            {
                roleName = "JS";
                titleName = "Update project manager";
            }

            JobPmJsDetail result = await _jobPmJsDetailRepository.PmJsDetailAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PProjno = id
                });

            jobEditPmJsViewModel.Projno = id;
            jobEditPmJsViewModel.RoleName = roleName;
            jobEditPmJsViewModel.PmEmpno = result.PPmEmpno;
            jobEditPmJsViewModel.JsEmpno = result.PJsEmpno;

            var pmEmployees = await _selectTcmPLRepository.EmployeeListForHRAsync(
                    BaseSpTcmPLGet(),
                    null);

            ViewData["ERPPMList"] = new SelectList(pmEmployees, "DataValueField", "DataTextField", result.PPmEmpno);
            ViewData["JSList"] = new SelectList(pmEmployees, "DataValueField", "DataTextField", result.PJsEmpno);

            ViewData["Title"] = titleName;

            return PartialView("_ModalPmJsEdit", jobEditPmJsViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> EditPmJs([FromForm] JobEditPmJsViewModel jobEditPmJsViewModel)
        {
            if (!(CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == JOBHelper.ActionJobChangeErpPm) || CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == JOBHelper.ActionJobChangeSponsor)))
            {
                return Forbid();
            }

            try
            {
                if (ModelState.IsValid)
                {
                    DBProcMessageOutput result = await _jobPmJsRepository.UpdatePmJsAsync(
                    BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PProjno = jobEditPmJsViewModel.Projno,
                            PRoleName = jobEditPmJsViewModel.RoleName,
                            PPmEmpno = jobEditPmJsViewModel.PmEmpno ?? " ",
                            PJsEmpno = jobEditPmJsViewModel.JsEmpno ?? " "
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

            return View(jobEditPmJsViewModel);
        }


        /* Seperate tiles */

        public async Task<IActionResult> ChangePMJSIndex(string roleName)
        {
            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterJobsIndex
            });

            JobmasterViewModel jobmasterViewModel = new JobmasterViewModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                jobmasterViewModel.FilterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            ViewData["RoleName"] = roleName;

            return View(jobmasterViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetChangePMJSJobsList(DTParameters param)
        {
            int totalRow = 0;

            DTResult<JobmasterDataTableList> result = new DTResult<JobmasterDataTableList>();

            try
            {
                var data = await _jobmasterDataTableListRepository.JobmasterDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
                        PIsActive = decimal.Parse(param.IsActive?.ToString() ?? "1"),
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

        public async Task<IActionResult> ChangeERPPM(string id)
        {
            if (id == null)
                return NotFound();

            JobEditPmJsViewModel jobEditPmJsViewModel = new();

            JobPmJsDetail result = await _jobPmJsDetailRepository.PmJsDetailAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PProjno = id
                });

            jobEditPmJsViewModel.Projno = id;
            jobEditPmJsViewModel.RoleName = "JS";
            jobEditPmJsViewModel.PmEmpno = result.PPmEmpno;
            jobEditPmJsViewModel.JsEmpno = " ";

            var employees = await _selectTcmPLRepository.EmployeeListForHRAsync(
                    BaseSpTcmPLGet(),
                    null);

            ViewData["ERPPMList"] = new SelectList(employees, "DataValueField", "DataTextField", result.PPmEmpno);
            ViewData["JSList"] = new SelectList(employees, "DataValueField", "DataTextField", result.PJsEmpno);

            ViewData["Title"] = "Change project manager [ " + id + " ]";

            return PartialView("_ModalPmJsEdit", jobEditPmJsViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> ChangeERPPM([FromForm] JobEditPmJsViewModel jobEditPmJsViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    DBProcMessageOutput result = await _jobPmJsRepository.UpdatePmJsAsync(
                    BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PProjno = jobEditPmJsViewModel.Projno,
                            PRoleName = jobEditPmJsViewModel.RoleName,
                            PPmEmpno = jobEditPmJsViewModel.PmEmpno ?? " ",
                            PJsEmpno = jobEditPmJsViewModel.JsEmpno ?? " "
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

            return View(jobEditPmJsViewModel);
        }

        public async Task<IActionResult> ChangeSponsor(string id)
        {
            if (id == null)
                return NotFound();

            JobEditPmJsViewModel jobEditPmJsViewModel = new();

            JobPmJsDetail result = await _jobPmJsDetailRepository.PmJsDetailAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PProjno = id
                });

            jobEditPmJsViewModel.Projno = id;
            jobEditPmJsViewModel.RoleName = "PM";
            jobEditPmJsViewModel.PmEmpno = result.PPmEmpno;
            jobEditPmJsViewModel.JsEmpno = result.PJsEmpno;

            var employees = await _selectTcmPLRepository.EmployeeListForHRAsync(
                    BaseSpTcmPLGet(),
                    null);

            ViewData["ERPPMList"] = new SelectList(employees, "DataValueField", "DataTextField", result.PPmEmpno);
            ViewData["JSList"] = new SelectList(employees, "DataValueField", "DataTextField", result.PJsEmpno);

            ViewData["Title"] = "Change job sponsor [ " + id + " ]";

            return PartialView("_ModalPmJsEdit", jobEditPmJsViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> ChangeSponsor([FromForm] JobEditPmJsViewModel jobEditPmJsViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    DBProcMessageOutput result = await _jobPmJsRepository.UpdatePmJsAsync(
                    BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PProjno = jobEditPmJsViewModel.Projno,
                            PRoleName = jobEditPmJsViewModel.RoleName,
                            PPmEmpno = jobEditPmJsViewModel.PmEmpno ?? " ",
                            PJsEmpno = jobEditPmJsViewModel.JsEmpno ?? " "
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

            return View(jobEditPmJsViewModel);
        }

        #endregion JS/PM change

        #region ApprovalCMDIndex
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionJobApprovalMd)]
        public async Task<IActionResult> ApprovalCMDIndex()
        {
            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterJobsIndex
            });

            JobmasterViewModel jobmasterViewModel = new JobmasterViewModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                jobmasterViewModel.FilterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            return View(jobmasterViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionJobApprovalMd)]
        public async Task<JsonResult> GetPendApprovalCMDList(DTParameters param)
        {
            int totalRow = 0;

            DTResult<JobmasterDataTableList> result = new DTResult<JobmasterDataTableList>();

            try
            {
                var data = await _jobmasterDataTableListRepository.PendingApprovalsCMDDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
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
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionJobApprovalMd)]
        public async Task<IActionResult> ApprovalCMDDetail(string id)
        {
            try
            {
                if (id == null)
                    return NotFound();

                var jobmasterMainDetail = await JobDetailsData(id);
                return View(jobmasterMainDetail);
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
            }

            return RedirectToAction("ApprovalCMDIndex");
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionJobApprovalMd)]
        public async Task<IActionResult> ApprovalCMD(string id)
        {
            if (id == null)
                return NotFound();

            string msgText = string.Empty;

            try
            {
                var result = await _jobApprovalRepository.CmdApprovalAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PProjno = id
                        });

                if (result.PMessageType != "OK")
                {
                    //Notify("Error", result.PMessageText.Replace("-", " "), "toaster", NotificationType.error);
                    return Json(new { error = true, response = result.PMessageText });
                }
                else
                {
                    Notify("Success", result.PMessageText.Replace("-", " "), "toaster", NotificationType.success);
                    return Json(new { success = result.PMessageType == IsOk, message = result.PMessageText });
                }
            }
            catch (Exception ex)
            {
                msgText = ex.Message.ToString();
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(msgText));
            }

        }

        #endregion ApprovalCMDIndex

        #region ApprovalAFCIndex
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionJobApprovalAfc)]
        public async Task<IActionResult> ApprovalAFCIndex()
        {
            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterJobsIndex
            });

            JobmasterViewModel jobmasterViewModel = new JobmasterViewModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                jobmasterViewModel.FilterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            return View(jobmasterViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionJobApprovalAfc)]
        public async Task<JsonResult> GetPendApprovalAFCList(DTParameters param)
        {
            int totalRow = 0;

            DTResult<JobmasterDataTableList> result = new DTResult<JobmasterDataTableList>();

            try
            {
                var data = await _jobmasterDataTableListRepository.PendingApprovalsAFCDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
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
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionJobApprovalAfc)]
        public async Task<IActionResult> ApprovalAFCDetail(string id)
        {
            try
            {
                if (id == null)
                    return NotFound();

                var jobmasterMainDetail = await JobDetailsData(id);
                return View(jobmasterMainDetail);
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
            }

            return RedirectToAction("ApprovalAFCIndex");

        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionJobApprovalAfc)]
        public async Task<IActionResult> ApprovalAFC(string id)
        {
            if (id == null)
                return NotFound();

            string msgText = string.Empty;

            try
            {                
                var result = await _jobApprovalRepository.AfcApprovalAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PProjno = id
                        });

                if (result.PMessageType != "OK")
                {
                    return Json(new { error = true, message = result.PMessageText });
                }
                else
                {
                    Notify("Success", result.PMessageText.Replace("-", " "), "toaster", NotificationType.success);
                    return Json(new { success = result.PMessageType == IsOk, message = result.PMessageText });
                }
            }
            catch (Exception ex)
            {
                msgText = ex.Message.ToString();
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

        }

        #endregion ApprovalAFCIndex

        #region ApprovalJSIndex
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionJobApprovalSponsor)]
        public async Task<IActionResult> ApprovalJSIndex()
        {
            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterJobsIndex
            });

            JobmasterViewModel jobmasterViewModel = new JobmasterViewModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                jobmasterViewModel.FilterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            return View(jobmasterViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionJobApprovalSponsor)]
        public async Task<JsonResult> GetPendApprovalJSList(DTParameters param)
        {
            int totalRow = 0;

            DTResult<JobmasterDataTableList> result = new DTResult<JobmasterDataTableList>();

            try
            {
                var data = await _jobmasterDataTableListRepository.PendingApprovalsJSDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
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
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionJobApprovalSponsor)]
        public async Task<IActionResult> ApprovalJSDetail(string id)
        {
            try
            {
                if (id == null)
                    return NotFound();

                var jobmasterMainDetail = await JobDetailsData(id);
                return View(jobmasterMainDetail);
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
            }

            return RedirectToAction("ApprovalJSIndex");
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionJobApprovalSponsor)]
        public async Task<IActionResult> ApprovalJS(string id)
        {
            if (id == null)
                return NotFound();

            string msgText = string.Empty;

            try
            {
                var result = await _jobApprovalRepository.JsApprovalAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PProjno = id
                        });

                if (result.PMessageType != "OK")
                {
                    return Json(new { error = true, message = result.PMessageText });
                }
                else
                {
                    Notify("Success", result.PMessageText.Replace("-", " "), "toaster", NotificationType.success);
                    return Json(new { success = result.PMessageType == IsOk, message = result.PMessageText });
                }
            }
            catch (Exception ex)
            {
                msgText = ex.Message.ToString();
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionJobApprovalSponsor)]
        public async Task<IActionResult> SendBackForReviewJS(string id)
        {
            if (id == null)
                return NotFound();

            string msgText = string.Empty;

            try
            {
                var result = await _jobApprovalRepository.JsSendForReviewAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PProjno = id
                        });

                if (result.PMessageType != "OK")
                {
                    return Json(new { error = true, message = result.PMessageText });
                }
                else
                {
                    Notify("Success", result.PMessageText.Replace("-", " "), "toaster", NotificationType.success);
                    return Json(new { success = result.PMessageType == IsOk, message = result.PMessageText });
                }
            }
            catch (Exception ex)
            {
                msgText = ex.Message.ToString();
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }


        #endregion ApprovalJSIndex

        #region Notes

        [HttpGet]
        public async Task<IActionResult> NotesIndex(string id)
        {
            if (id == null)
                return NotFound();

            var projectActions = await EmployeeProjActions(id);

            JobNotesDetail jobNotesDetail = await _jobNotesDetailRepository.NotesDetailAsync(
                         BaseSpTcmPLGet(),
                         new ParameterSpTcmPL
                         {
                             PProjno = id
                         });

            JobNotesDetailViewModel jobNotesDetailViewModel = new JobNotesDetailViewModel
            {
                ProjectActions = projectActions,
                PDescription = jobNotesDetail.PDescription,
                PNotes = jobNotesDetail.PNotes
            };


            ViewData["Projno"] = id;

            return PartialView("_NotesIndexPartial", jobNotesDetailViewModel);
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionJobEditNotesDesc)]
        public async Task<IActionResult> NotesEdit(string id)
        {
            if (id == null)
                return NotFound();

            JobNotesCreateViewModel notesUpdateViewModel = new();

            JobNotesDetail notesDetail = await _jobNotesDetailRepository.NotesDetailAsync(
                         BaseSpTcmPLGet(),
                         new ParameterSpTcmPL
                         {
                             PProjno = id
                         });

            if (notesDetail.PMessageType == IsOk)
            {
                notesUpdateViewModel.Projno = id;
                notesUpdateViewModel.Description = notesDetail.PDescription;
                notesUpdateViewModel.Notes = notesDetail.PNotes;
            }

            return PartialView("_ModalNotesEdit", notesUpdateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionJobEditNotesDesc)]
        public async Task<IActionResult> NotesEdit([FromForm] JobNotesCreateViewModel notesUpdateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    DBProcMessageOutput result = await _jobNotesRepository.UpdateNotesAsync(
                    BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PProjno = notesUpdateViewModel.Projno,
                            PNotes = notesUpdateViewModel.Notes,
                            PDescription = notesUpdateViewModel.Description
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

            return PartialView("_ModalNotesEdit", notesUpdateViewModel);
        }

        #endregion Notes

        #region Phase

        [HttpGet]
        public async Task<IActionResult> PhaseIndex(string id)
        {
            if (id == null)
                return NotFound();

            ViewData["Projno"] = id;

            JobPhaseIndexViewModel jobPhaseIndexViewModel = new JobPhaseIndexViewModel();

            jobPhaseIndexViewModel.ProjectActions = await EmployeeProjActions(id);

            return PartialView("_PhaseIndexPartial", jobPhaseIndexViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetJobPhaseList(string paramJson)
        {
            int totalRow = 0;

            //DTResult<JobPhaseDataTableList> result = new DTResult<JobPhaseDataTableList>();
            DTResultExtension<JobPhaseDataTableList, JobValidateStatusOutput> result = new DTResultExtension<JobPhaseDataTableList, JobValidateStatusOutput>();

            try
            {
                var param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

                var jobValidateStatus = await _jobValidateStatusRepository.ValidateStatusAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PProjno = param.Projno
                    }
                );

                var data = await _jobPhaseDataTableListRepository.JobPhaseDataTableList(
                            BaseSpTcmPLGet(),
                            new ParameterSpTcmPL
                            {
                                PProjno = param.Projno
                            });

                if (data.Any())
                {
                    totalRow = (int)data.FirstOrDefault().TotalRow.Value;
                }

                result.draw = param.Draw;
                result.recordsTotal = totalRow;
                result.recordsFiltered = totalRow;
                result.data = data.ToList();
                result.headerData = jobValidateStatus;

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

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionJobCreate)]
        public async Task<IActionResult> PhaseCreate(string id)
        {
            if (id == null)
                return NotFound();

            PhaseCreateViewModel phaseCreateViewModel = new();

            phaseCreateViewModel.Projno = id.ToString().Trim();

            var jobPhases = await _selectTcmPLRepository.JobPhaseListAsync(BaseSpTcmPLGet(), null);
            ViewData["JobPhases"] = new SelectList(jobPhases, "DataValueField", "DataTextField");

            var tmaGroups = await _selectTcmPLRepository.JobTMAGroupListAsync(BaseSpTcmPLGet(), null);
            ViewData["TMAGroups"] = new SelectList(tmaGroups, "DataValueField", "DataTextField");

            return PartialView("_ModalPhaseCreate", phaseCreateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionJobCreate)]
        public async Task<IActionResult> PhaseCreate([FromForm] PhaseCreateViewModel phaseCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    DBProcMessageOutput result = await _jobPhaseRepository.AddPhaseAsync(
                            BaseSpTcmPLGet(),
                             new ParameterSpTcmPL
                             {
                                 PProjno = phaseCreateViewModel.Projno,
                                 PPhase = phaseCreateViewModel.Phase,
                                 PTmagrp = phaseCreateViewModel.Tmagrp,
                                 PBlockbooking = phaseCreateViewModel.Blockbooking ?? 0,
                                 PBlockot = phaseCreateViewModel.Blockot ?? 0
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

            var jobPhases = await _selectTcmPLRepository.JobPhaseListAsync(BaseSpTcmPLGet(), null);
            ViewData["JobPhases"] = new SelectList(jobPhases, "DataValueField", "DataTextField");

            var tmaGroups = await _selectTcmPLRepository.JobTMAGroupListAsync(BaseSpTcmPLGet(), null);
            ViewData["TMAGroups"] = new SelectList(tmaGroups, "DataValueField", "DataTextField");

            return PartialView("_ModalPhaseCreatePartial", phaseCreateViewModel);
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionJobCreate)]
        public async Task<IActionResult> PhaseEdit(string id)
        {
            if (id == null)
                return NotFound();

            PhaseCreateViewModel phaseUpdateViewModel = new();

            JobPhaseDetail phaseDetail = await _jobPhaseDetailRepository.PhaseDetailAsync(
                         BaseSpTcmPLGet(),
                         new ParameterSpTcmPL
                         {
                             PProjno = id.Split("!-!")[0].ToString(),
                             PPhase = id.Split("!-!")[1].ToString()
                         });

            if (phaseDetail.PMessageType == IsOk)
            {
                phaseUpdateViewModel.Projno = id.Split("!-!")[0];
                phaseUpdateViewModel.Phase = id.Split("!-!")[1];
                phaseUpdateViewModel.Description = phaseDetail.PDescription;
                phaseUpdateViewModel.Tmagrp = phaseDetail.PTmagrp;
                phaseUpdateViewModel.Blockbooking = phaseDetail.PBlockbooking;
                phaseUpdateViewModel.Blockot = phaseDetail.PBlockot;
            }

            var tmaGroups = await _selectTcmPLRepository.JobTMAGroupListAsync(BaseSpTcmPLGet(), null);
            ViewData["TMAGroups"] = new SelectList(tmaGroups, "DataValueField", "DataTextField", phaseUpdateViewModel.Tmagrp);

            return PartialView("_ModalPhaseEdit", phaseUpdateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionJobCreate)]
        public async Task<IActionResult> PhaseEdit([FromForm] PhaseCreateViewModel phaseUpdateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    DBProcMessageOutput result = await _jobPhaseRepository.UpdatePhaseAsync(
                    BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PProjno = phaseUpdateViewModel.Projno,
                            PPhase = phaseUpdateViewModel.Phase,
                            PTmagrp = phaseUpdateViewModel.Tmagrp,
                            PBlockbooking = phaseUpdateViewModel.Blockbooking ?? 0,
                            PBlockot = phaseUpdateViewModel.Blockot ?? 0
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

            var tmaGroups = await _selectTcmPLRepository.JobTMAGroupListAsync(BaseSpTcmPLGet(), null);
            ViewData["TMAGroups"] = new SelectList(tmaGroups, "DataValueField", "DataTextField", phaseUpdateViewModel.Tmagrp);

            return PartialView("_ModalPhaseEdit", phaseUpdateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionJobCreate)]
        public async Task<IActionResult> PhaseDelete(string id)
        {
            if (id == null)
                return NotFound();

            try
            {
                DBProcMessageOutput result = await _jobPhaseRepository.DeletePhaseAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PProjno = id.Split("!-!")[0],
                            PPhase = id.Split("!-!")[1]
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

        #endregion Phase

        #region Budget

        [HttpGet]
        public async Task<IActionResult> BudgetIndex(string id)
        {
            if (id == null)
                return NotFound();

            BudgetIndexViewModel budgetIndexViewModel = new BudgetIndexViewModel();

            budgetIndexViewModel.ProjectActions = await EmployeeProjActions(id);

            JobmasterMainDetailOut jobDetail = await _jobmasterDetailRepository.JobmasterDetailMain(
                                                BaseSpTcmPLGet(),
                                                new ParameterSpTcmPL
                                                {
                                                    PProjno = id
                                                });

            ViewData["Projno"] = id;
            ViewData["IsBudget"] = jobDetail.PBudgetAttached;

            return PartialView("_BudgetIndexPartial", budgetIndexViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetBudget(string paramJson)
        {
            int totalRow = 0;
            DTResultExtension<BudgetDataTableList, JobValidateStatusOutput> result = new DTResultExtension<BudgetDataTableList, JobValidateStatusOutput>();
            //DTResult<BudgetDataTableList> result = new DTResult<BudgetDataTableList>();

            try
            {
                var param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

                var jobValidateStatus = await _jobValidateStatusRepository.ValidateStatusAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PProjno = param.Projno
                    }
                );

                var data = await _jobBudgetDataTableListRepository.JobBudgetDataTableList(
                            BaseSpTcmPLGet(),
                            new ParameterSpTcmPL
                            {
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
                result.headerData = jobValidateStatus;

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

        #endregion Budget

        #region Mailinglist

        [HttpGet]
        public async Task<IActionResult> MailListIndex(string id)
        {
            if (id == null)
                return NotFound();

            JobMailListIndexViewModel jobMailListIndexViewModel = new JobMailListIndexViewModel();

            jobMailListIndexViewModel.ProjectActions = await EmployeeProjActions(id);


            ViewData["Projno"] = id;

            return PartialView("_MailListIndexPartial", jobMailListIndexViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetJobMailList(string paramJson)
        {
            int totalRow = 0;

            DTResult<JobMailListDataTableList> result = new DTResult<JobMailListDataTableList>();

            try
            {
                var param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

                var data = await _jobMailListDataTableListRepository.JobMailListDataTableList(
                            BaseSpTcmPLGet(),
                            new ParameterSpTcmPL
                            {
                                PProjno = param.Projno,
                                PRowNumber = param.Start,
                                PPageLength = param.Length,
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

        public async Task<IActionResult> MailListCreate(string projno)
        {
            MailListCreateViewModel mailListCreateViewModel = new();

            mailListCreateViewModel.Projno = projno.Trim();

            var costcodeList = await _selectTcmPLRepository.MailListCostcodesListAsync(BaseSpTcmPLGet(), null);
            ViewData["CostcodeList"] = new SelectList(costcodeList, "DataValueField", "DataTextField");

            return PartialView("_ModalMailListCreate", mailListCreateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> MailListCreate(MailListCreateViewModel mailListCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    DBProcMessageOutput result = await _jobMailListRepository.AddMailListAsync(
                            BaseSpTcmPLGet(),
                             new ParameterSpTcmPL
                             {
                                 PProjno = mailListCreateViewModel.Projno,
                                 PCostcode = mailListCreateViewModel.Costcode
                             });

                    Notify(result.PMessageType == IsOk ? "Success" : "Error", StringHelper.CleanExceptionMessage(result.PMessageText), "", notificationType: NotificationType.success);
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            mailListCreateViewModel.Costcode = null;

            var costcodeList = await _selectTcmPLRepository.MailListCostcodesListAsync(BaseSpTcmPLGet(), null);
            ViewData["CostcodeList"] = new SelectList(costcodeList, "DataValueField", "DataTextField");

            return PartialView("_ModalMailListCreate", mailListCreateViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> MailListDelete(string projno, string costcode)
        {
            if (String.IsNullOrEmpty(projno) || String.IsNullOrEmpty(costcode))
            {
                return Ok();
            }
            try
            {
                DBProcMessageOutput result = await _jobMailListRepository.DeleteMailListAsync(
                    BaseSpTcmPLGet(),
                     new ParameterSpTcmPL
                     {
                         PProjno = projno,
                         PCostcode = costcode
                     });

                return result.PMessageType != IsOk
                     ? throw new Exception(result.PMessageText.Replace("-", " "))
                     : (IActionResult)Json(new { success = true, response = StringHelper.CleanExceptionMessage(result.PMessageText) });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        #endregion Mailinglist

        #region Budget excel import

        #region Excel import

        [HttpGet]
        public async Task<IActionResult> ImportExportBudget(string id)
        {
            if (id == null)
                return NotFound();

            var jobDetail = await _jobmasterDetailRepository.JobmasterDetailMain(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PProjno = id
                    });

            System.DateTime dt = Convert.ToDateTime(jobDetail.POpeningMonth).AddDays(0.0);

            ViewData["Project"] = id;
            ViewData["ProjectName"] = jobDetail.PShortDesc;
            ViewData["BugetAttached"] = jobDetail.PBudgetAttached;
            ViewData["OpeningMonth"] = jobDetail.POpeningMonth;
            ViewData["Revision"] = jobDetail.PRevision;
            ViewData["YYYYMM"] = dt.ToString("yyyyMM");

            return PartialView("_ModalTemplateImport");
        }

        [HttpGet]
        public async Task<IActionResult> JobBudgetXLTemplateDownload(string projno, string openmonth, string isexport)
        {
            if (projno == null && openmonth == null)
                return NotFound("Opening month can not be blank");

            var costcodeList = await _selectTcmPLRepository.CostcodeAbbrListAsync(BaseSpTcmPLGet(), null);

            var dictionaryItems = new List<Library.Excel.Template.Models.DictionaryItem>();

            foreach (var item in costcodeList)
            {
                dictionaryItems.Add(new DictionaryItem { FieldName = "CostcodeList", Value = item.DataTextField });
            }

            Stream ms = _excelTemplate.ExportJobmasterBudget("v01",
                new Library.Excel.Template.Models.DictionaryCollection
                {
                    DictionaryItems = dictionaryItems
                },
                500);

            var fileName = "JobBudget_" + projno + ".xlsx";

            var mimeType = MimeTypeMap.GetMimeType("xlsx");

            ms.Position = 0;

            var result = await _jobmasterBudgetApiRepository.JobmasterBudget(
                                                        BaseSpTcmPLGet(),
                                                        new ParameterSpTcmPL
                                                        {
                                                            PProjno = projno,
                                                            POpeningmonth = openmonth,
                                                            PIsExport = isexport
                                                        }
                                                    );

            using (XLWorkbook wb = new XLWorkbook(ms))
            {
                MemoryStream stream = new MemoryStream();
                {
                    int rowsUsed = result.Count();
                    rowsUsed = rowsUsed + 2;

                    if (result.Count() > 0)
                    {
                        wb.Worksheet("Import").Cell(2, 1).InsertData(result);
                    }

                    wb.Worksheet("Import").Cell(@$"E2").FormulaA1 = @$"=IF(ISERROR(VLOOKUP(D2, Dictionary!$A:$B, 2, 0)) = TRUE, """", VLOOKUP(D2, Dictionary!$A:$B, 2, 0))";

                    var rngFormulae = wb.Worksheet("Import").Range("E2");

                    string rngCostcodes = "E3:E12000";
                    wb.Worksheet("Import").Range(rngCostcodes).Value = rngFormulae.ToString();

                    string rangeCostcode = wb.Worksheet("Import").NamedRanges.FirstOrDefault(r => r.Name == "CostcodeName_Edit").RefersTo;
                    wb.Worksheet("Import").Range(rangeCostcode).Style.Fill.BackgroundColor = XLColor.LightGreen;

                    string rangeInitial = wb.Worksheet("Import").NamedRanges.FirstOrDefault(r => r.Name == "InitialBudget_Edit").RefersTo;
                    wb.Worksheet("Import").Range(rangeInitial).Style.Fill.BackgroundColor = XLColor.LightPink;

                    string rangeNewBudget = wb.Worksheet("Import").NamedRanges.FirstOrDefault(r => r.Name == "NewBudget_Edit").RefersTo;
                    wb.Worksheet("Import").Range(rangeNewBudget).Style.Fill.BackgroundColor = XLColor.LightYellow;


                    //wb.Worksheet(1).Protect("qw8po2TY5vbJ0Gd1sa");

                    //var refersTo = wb.Worksheet(1).NamedRanges.FirstOrDefault(r => r.Name == "DataRange").RefersTo;

                    //var lastRow = wb.Worksheet(1).Range(refersTo).LastRow().RowNumber();

                    //var lastCol = wb.Worksheet(1).Range(refersTo).LastColumn().ColumnNumber();

                    //var firstCol = wb.Worksheet(1).Range(refersTo).FirstColumn().ColumnNumber();

                    //wb.Worksheet(1).Range(rowsUsed, firstCol, lastRow, lastCol).Style.Protection.SetLocked(false);

                    #region Pivot

                    if (result.Count() > 0)
                    {
                        var PivotSheetName = "Pivot";
                        var dataRange = wb.Worksheet(1).Range(1, 1, rowsUsed - 1, 7);
                        var ptSheet = wb.Worksheets.Add(PivotSheetName);
                        ptSheet.Range(1, 1, 1, 1).Value = "Project : " + projno;
                        var pt = ptSheet.PivotTables.Add(PivotSheetName, ptSheet.Cell(3, 1), dataRange);
                        string[] ColumnLabels = { "Yymm" };
                        string[] RowLabels = { "Phase", "Costcode" };
                        string[] ValuesRowLabelSum = null;
                        string[] ValuesLabelSum = { "NewBudget" };

                        foreach (var rowLabel in RowLabels.DefaultIfEmpty())
                        {
                            pt.RowLabels.Add(rowLabel);
                        }
                        if (ColumnLabels?.Length > 0)
                        {
                            foreach (var columnLabel in ColumnLabels.DefaultIfEmpty())
                            {
                                pt.ColumnLabels.Add(columnLabel);
                            }
                        }
                        if (ValuesRowLabelSum?.Length > 0)
                        {
                            foreach (var sumOfLabel in ValuesRowLabelSum.DefaultIfEmpty())
                            {
                                pt.Values.Add(sumOfLabel).SetSummaryFormula(XLPivotSummary.Sum);
                            }
                        }

                        if (ValuesLabelSum?.Length > 0)
                        {
                            foreach (var sumOfLabel in ValuesLabelSum.DefaultIfEmpty())
                            {
                                pt.Values.Add(sumOfLabel).SetSummaryFormula(XLPivotSummary.Sum);
                            }
                        }
                        //wb.Worksheet(2).Tables.FirstOrDefault().SetShowAutoFilter(false);
                        wb.Worksheet("Pivot").Columns().AdjustToContents();
                        wb.CalculateMode = XLCalculateMode.Auto;
                    }

                    #endregion

                    wb.SaveAs(stream);
                    stream.Position = 0;
                    return File(stream.ToArray(), mimeType, fileName);
                }
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> JobBudgetXLTemplateUpload(string projno, string openingmonth, IFormFile file)
        {
            try
            {
                if (projno == null || openingmonth == null || file == null || file.Length == 0)
                    return Json(new { success = false, response = "File not uploaded due to unrecongnised parameters" });

                FileInfo fileInfo = new FileInfo(file.FileName);

                Guid storageId = Guid.NewGuid();
                var stream = file.OpenReadStream();
                var fileName = file.FileName;
                var fileSize = file.Length;
                var mimeType = MimeTypeMap.GetMimeType(fileInfo.Extension);
                string fileNameErrors = string.Empty;

                // Check file validation
                if (!fileInfo.Extension.Contains("xls"))
                    return Json(new { success = false, response = "Excel file not recognized" });

                string json = string.Empty;

                List<JobmasterBudget> jobBudgetItems = _excelTemplate.ImportJobmasterBudget(stream);

                //string projno = jobBudgetItems.Select(p => p.Projno).FirstOrDefault();

                string[] aryJobBudget = jobBudgetItems.Select(p =>
                                                            p.Projno + "~!~" +
                                                            p.Phase + "~!~" +
                                                            p.Yymm + "~!~" +
                                                            p.Costcode + "~!~" +
                                                            p.InitialBudget + "~!~" +
                                                            p.NewBudget).ToArray();

                var uploadOutPut = await _jobmasterBudgetImportRepository.ImportJobBudgetAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PProjno = projno,
                            POpeningmonth = openingmonth,
                            PBudget = aryJobBudget
                        }
                    );

                List<ImportFileResultViewModel> importFileResults = new List<ImportFileResultViewModel>();

                if (uploadOutPut.PBudgetErrors?.Length > 0)
                {
                    foreach (string err in uploadOutPut.PBudgetErrors)
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

                if (uploadOutPut.PMessageType != BaseController.IsOk)
                {
                    if (importFileResults.Count > 0)
                    {
                        var streamError = _excelTemplate.ValidateImport(stream, validationItems);
                        fileNameErrors = "JobBudget_" + projno.ToString() + "_Errors.xlsx";
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

        #endregion Budget excel import

        #region Filter

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

        public async Task<IActionResult> FilterGet()
        {
            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterJobsIndex
            });

            FilterDataModel filterDataModel = new FilterDataModel();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            if (filterDataModel.IsActive == null)
                filterDataModel.IsActive = 1;

            return PartialView("_FilterSetPartial", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> FilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                string jsonFilter;

                jsonFilter = JsonConvert.SerializeObject(new { IsActive = filterDataModel.IsActive });

                var retVal = await _filterRepository.FilterCreateAsync(new Domain.Models.FilterCreate
                {
                    PModuleName = CurrentUserIdentity.CurrentModule,
                    PMetaId = CurrentUserIdentity.MetaId,
                    PPersonId = CurrentUserIdentity.EmployeeId,
                    PMvcActionName = ConstFilterJobsIndex,
                    PFilterJson = jsonFilter
                });

                return Json(new { success = true, isActive = filterDataModel.IsActive });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        #endregion Filter

        #region ErpPhasesFileUpload

        [HttpGet]
        public IActionResult JobErpPhasesFileIndex(string id)
        {
            if (id == null)
                return NotFound();

            return PartialView("_ErpPhasesIndexPartial");
        }

        [HttpPost]
        public async Task<IActionResult> JobErpPhasesFileDetailPartial([FromForm] JobErpPhasesFileDetailViewModel jobErpPhasesFileDetailViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    string serverFileName = "";
                    string ClintFileName = "";
                    JobErpPhasesFileDetails resulDtetails = await _jobErpPhasesFileDetailRepository.JobErpPhasesFileDetailAsync(
                          BaseSpTcmPLGet(), new ParameterSpTcmPL { PJobNo = jobErpPhasesFileDetailViewModel.JobNo });

                    if (resulDtetails.PMessageType == IsOk)
                    {
                        jobErpPhasesFileDetailViewModel.ClintFileName = resulDtetails.PClintFileName;
                        jobErpPhasesFileDetailViewModel.ServerFileName = resulDtetails.PServerFileName;
                        jobErpPhasesFileDetailViewModel.ModifiedBy = resulDtetails.PModifiedBy;
                        jobErpPhasesFileDetailViewModel.ModifiedOn = resulDtetails.PModifiedOn;
                    }

                    if (!string.IsNullOrEmpty(jobErpPhasesFileDetailViewModel.ServerFileName))
                    {
                        StorageHelper.DeleteFile(StorageHelper.JOB.RepositoryJobPhasesErps,
                        jobErpPhasesFileDetailViewModel.ServerFileName, Configuration);
                    }

                    if (jobErpPhasesFileDetailViewModel.file != null)
                    {
                        ClintFileName = jobErpPhasesFileDetailViewModel.file.FileName;
                        serverFileName = await StorageHelper.SaveFileAsync(Path.Combine(StorageHelper.JOB.TCMPLAppTemplatesRepository, StorageHelper.JOB.RepositoryJobForm),
                                                    jobErpPhasesFileDetailViewModel.JobNo, StorageHelper.JOB.Group,
                                                    jobErpPhasesFileDetailViewModel.file, Configuration);
                    }

                    var result = await _jobErpPhasesFileRepository.AddJobErpPhasesFileAsync(
                    BaseSpTcmPLGet(), new ParameterSpTcmPL
                    {
                        PJobNo = jobErpPhasesFileDetailViewModel.JobNo,
                        PClintFileName = ClintFileName,
                        PServerFileName = serverFileName
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
                return RedirectToAction("JobErpPhasesFileDetail", new { id = jobErpPhasesFileDetailViewModel.JobNo });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        [HttpGet]
        public async Task<IActionResult> JobErpPhasesFileDetailPartial(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            JobErpPhasesFileDetailViewModel jobErpPhasesFileDetailViewModel = new();
            jobErpPhasesFileDetailViewModel.JobNo = id;

            JobErpPhasesFileDetails result = await _jobErpPhasesFileDetailRepository.JobErpPhasesFileDetailAsync(
                         BaseSpTcmPLGet(), new ParameterSpTcmPL { PJobNo = id });

            if (result.PMessageType == IsOk)
            {
                jobErpPhasesFileDetailViewModel.ClintFileName = result.PClintFileName;
                jobErpPhasesFileDetailViewModel.ServerFileName = result.PServerFileName;
                jobErpPhasesFileDetailViewModel.ModifiedBy = result.PModifiedBy;
                jobErpPhasesFileDetailViewModel.ModifiedOn = result.PModifiedOn;
            }

            return PartialView("_JobErpPhasesFileDetailPartial", jobErpPhasesFileDetailViewModel);
        }

        [HttpGet]
        public IActionResult ExcelJobErpPhasesTemplateDownload(string projno)
        {
            if (projno == null)
                return NotFound();

            try
            {
                string excelFileName = "JobErpPhasesTemplate.xlsx";

                //var template = new XLTemplate(StorageHelper.GetFilePath(StorageHelper.JOB.RepositoryExcelTemplateJobMaster, FileName: excelFileName, Configuration));
                var template = new XLTemplate(StorageHelper.GetFilePath(Path.Combine(StorageHelper.JOB.TCMPLAppTemplatesRepository, StorageHelper.JOB.RepositoryJobForm), FileName: excelFileName, Configuration));

                string strFileName = string.Empty;
                strFileName = excelFileName;

                var wb = template.Workbook;

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
                Notify("Error", ex.Message, "toaster", notificationType: NotificationType.error);
            }
            return RedirectToAction("JobErpPhasesFileDetail", new { id = projno });
        }

        [HttpGet]
        public async Task<IActionResult> JobErpPhasesFileDetail(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            JobErpPhasesFileDetailViewModel jobErpPhasesFileDetailViewModel = new();
            jobErpPhasesFileDetailViewModel.JobNo = id;

            JobErpPhasesFileDetails result = await _jobErpPhasesFileDetailRepository.JobErpPhasesFileDetailAsync(
                         BaseSpTcmPLGet(), new ParameterSpTcmPL { PJobNo = id });

            if (result.PMessageType == IsOk)
            {
                jobErpPhasesFileDetailViewModel.ClintFileName = result.PClintFileName;
                jobErpPhasesFileDetailViewModel.ServerFileName = result.PServerFileName;
                jobErpPhasesFileDetailViewModel.ModifiedBy = result.PModifiedBy;
                jobErpPhasesFileDetailViewModel.ModifiedOn = result.PModifiedOn;
            }

            return PartialView("_ModalJobErpPhasesFileDetail", jobErpPhasesFileDetailViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> JobErpPhasesFileDetail([FromForm] JobErpPhasesFileDetailViewModel jobErpPhasesFileDetailViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    string serverFileName = "";
                    string ClintFileName = "";
                    JobErpPhasesFileDetails resulDtetails = await _jobErpPhasesFileDetailRepository.JobErpPhasesFileDetailAsync(
                          BaseSpTcmPLGet(), new ParameterSpTcmPL { PJobNo = jobErpPhasesFileDetailViewModel.JobNo });

                    if (resulDtetails.PMessageType == IsOk)
                    {
                        jobErpPhasesFileDetailViewModel.ClintFileName = resulDtetails.PClintFileName;
                        jobErpPhasesFileDetailViewModel.ServerFileName = resulDtetails.PServerFileName;
                        jobErpPhasesFileDetailViewModel.ModifiedBy = resulDtetails.PModifiedBy;
                        jobErpPhasesFileDetailViewModel.ModifiedOn = resulDtetails.PModifiedOn;
                    }

                    if (!string.IsNullOrEmpty(jobErpPhasesFileDetailViewModel.ServerFileName))
                    {
                        StorageHelper.DeleteFile(Path.Combine(StorageHelper.JOB.TCMPLAppTemplatesRepository, StorageHelper.JOB.RepositoryJobForm),
                        jobErpPhasesFileDetailViewModel.ServerFileName, Configuration);
                    }

                    if (jobErpPhasesFileDetailViewModel.file != null)
                    {
                        ClintFileName = jobErpPhasesFileDetailViewModel.file.FileName;
                        serverFileName = await StorageHelper.SaveFileAsync(Path.Combine(StorageHelper.JOB.TCMPLAppTemplatesRepository, StorageHelper.JOB.RepositoryJobForm),
                                                    jobErpPhasesFileDetailViewModel.JobNo, StorageHelper.JOB.Group,
                                                    jobErpPhasesFileDetailViewModel.file, Configuration);
                    }

                    var result = await _jobErpPhasesFileRepository.AddJobErpPhasesFileAsync(
                    BaseSpTcmPLGet(), new ParameterSpTcmPL
                    {
                        PJobNo = jobErpPhasesFileDetailViewModel.JobNo,
                        PClintFileName = ClintFileName,
                        PServerFileName = serverFileName
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
                return RedirectToAction("_ModalJobErpPhasesFileDetail", new { id = jobErpPhasesFileDetailViewModel.JobNo });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        [HttpGet]
        public async Task<IActionResult> JobErpPhasesXLFileDownload(string projno)
        {
            if (projno == null)
                return NotFound();

            try
            {
                JobErpPhasesFileDetailViewModel jobErpPhasesFileDetailViewModel = new();

                JobErpPhasesFileDetails result = await _jobErpPhasesFileDetailRepository.JobErpPhasesFileDetailAsync(
                         BaseSpTcmPLGet(), new ParameterSpTcmPL { PJobNo = projno });

                if (result.PMessageType == IsOk)
                {
                    jobErpPhasesFileDetailViewModel.ClintFileName = result.PClintFileName;
                    jobErpPhasesFileDetailViewModel.ServerFileName = result.PServerFileName;
                    jobErpPhasesFileDetailViewModel.ModifiedBy = result.PModifiedBy;
                    jobErpPhasesFileDetailViewModel.ModifiedOn = result.PModifiedOn;
                }

                string excelFileName = jobErpPhasesFileDetailViewModel.ServerFileName;

                var template = new XLTemplate(StorageHelper.GetFilePath(Path.Combine(StorageHelper.JOB.TCMPLAppTemplatesRepository, StorageHelper.JOB.RepositoryJobForm), FileName: excelFileName, Configuration));

                string strFileName = string.Empty;
                strFileName = jobErpPhasesFileDetailViewModel.ClintFileName;

                var wb = template.Workbook;

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
                Notify("Error", ex.Message, "toaster", notificationType: NotificationType.error);
            }
            return RedirectToAction("JobErpPhasesFileDetail", new { id = projno });
        }

        #endregion ErpPhasesFileUpload

        #region ValidateJobFormTabs

        [HttpGet]
        public async Task<IActionResult> GetJobValidateStatus(string projno)
        {
            if (projno == null)
            {
                return NotFound();
            }

            var jobValidateStatus = await _jobValidateStatusRepository.ValidateStatusAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PProjno = projno
                    }
                );

            return Json(jobValidateStatus);
        }

        #endregion


        #region ClientCreate

        [HttpGet]
        public IActionResult ClientCreate(string id)
        {
            ClientCreateViewModel clientCreateViewModel = new();
            clientCreateViewModel.Projno = id;

            return PartialView("_ModalClientCreatePartial", clientCreateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ClientCreate([FromForm] ClientCreateViewModel clientCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _clientRepository.ClientCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PClientName = clientCreateViewModel.ClientName
                        });

                    if (result.PMessageType != IsOk)
                        throw new Exception(result.PMessageText.Replace("-", " "));
                    else
                        return RedirectToAction("EditAFC", new { id = clientCreateViewModel.Projno, clientName = clientCreateViewModel.ClientName });

                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            return PartialView("_ModalClientCreatePartial", clientCreateViewModel);
        }

        #endregion ClientCreate

        #region JobCloseInitiate

        [HttpGet]
        public async Task<IActionResult> JobCloseInitiate(string id)
        {
            JobCloseInitiateViewModel jobCloseInitiateViewModel = new();
            
            JobNotesDetail notesDetail = await _jobNotesDetailRepository.NotesDetailAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PProjno = id
                });

            if (notesDetail.PMessageType == IsOk)
            {
                jobCloseInitiateViewModel.Projno = id;
                jobCloseInitiateViewModel.Notes = notesDetail.PNotes;
            }            

            return PartialView("_ModalJobCloseInitiatePartial", jobCloseInitiateViewModel);
        }        

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> JobCloseInitiate([FromForm] JobCloseInitiateViewModel jobCloseInitiateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    if (jobCloseInitiateViewModel.Projno == null)
                        return NotFound();

                    var empProjActions = await EmployeeProjActions(jobCloseInitiateViewModel.Projno);

                    if (!empProjActions.Any(a => a.ActionId == JOBHelper.ActionJobClose))
                        return Forbid();

                    DBProcMessageOutput result = await _jobsMasterRepository.CheckProjectionsBookingAsync(
                    BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PProjno = jobCloseInitiateViewModel.Projno,
                            PActualCloseDate = jobCloseInitiateViewModel.ActualClosingDate
                        });

                    if (result.PMessageType == NotOk)
                    {
                        jobCloseInitiateViewModel.Warning = result.PMessageText;
                        jobCloseInitiateViewModel.IsConsent = "KO";
                    }
                    else
                    {                        
                        jobCloseInitiateViewModel.IsConsent = "OK";
                    }

                    return PartialView("_ModalJobCloseInitiateConfirmPartial", jobCloseInitiateViewModel);

                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            return PartialView("_ModalJobCloseInitiatePartial", jobCloseInitiateViewModel);
        }

        [HttpPost]
        public IActionResult JobCloseInitiateEdit([FromForm] JobCloseInitiateViewModel jobCloseInitiateViewModel)
        {                     
            jobCloseInitiateViewModel.Projno = jobCloseInitiateViewModel.Projno;
            jobCloseInitiateViewModel.ActualClosingDate = jobCloseInitiateViewModel.ActualClosingDate;
            jobCloseInitiateViewModel.Notes = jobCloseInitiateViewModel.Notes;        

            return PartialView("_ModalJobCloseInitiatePartial", jobCloseInitiateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> JobCloseInitiateConfirm([FromForm] JobCloseInitiateViewModel jobCloseInitiateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    if (jobCloseInitiateViewModel.Projno == null)
                        return NotFound();

                    if (jobCloseInitiateViewModel.Warning != null && jobCloseInitiateViewModel.IsConsent == "KO")
                        return NotFound();

                    var empProjActions = await EmployeeProjActions(jobCloseInitiateViewModel.Projno);

                    if (!empProjActions.Any(a => a.ActionId == JOBHelper.ActionJobClose))
                        return Forbid();

                    var result = await _jobApprovalRepository.JobApprovalinitiationAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PProjno = jobCloseInitiateViewModel.Projno,
                            PActualCloseDate = jobCloseInitiateViewModel.ActualClosingDate,
                            PNotes = jobCloseInitiateViewModel.Notes
                        });

                    Notify(result.PMessageType == BaseController.IsOk ? "Success" : "Error", result.PMessageText, "", result.PMessageType == BaseController.IsOk ? NotificationType.success : NotificationType.error);
                    if (result.PMessageType == BaseController.IsOk)
                    {                        
                        return base.Json(new { success = true, response = result.PMessageText });                        
                    }
                    else
                    {
                        throw new Exception(result.PMessageText);
                    }
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            return PartialView("_ModalJobCloseInitiateConfirmPartial", jobCloseInitiateViewModel);
        }


        #endregion JobCloseInitiate
    }
}