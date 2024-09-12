using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.Extensions.Configuration;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.Common;
using TCMPLApp.DataAccess.Repositories.ERS;
using TCMPLApp.DataAccess.Repositories.SWPVaccine;
using TCMPLApp.Domain.Models;
using TCMPLApp.Domain.Models.ERS;
using TCMPLApp.WebApp.Areas.ERS.Models;
using TCMPLApp.WebApp.Classes;
using TCMPLApp.WebApp.Controllers;
using TCMPLApp.WebApp.CustomPolicyProvider;
using TCMPLApp.WebApp.Models;
using TCMPLApp.WebApp.Services;
using static TCMPLApp.WebApp.Classes.DTModel;

namespace TCMPLApp.WebApp.Areas.ERS.Controllers
{
    [Area("ERS")]

    public class HRController : BaseController
    {
        private static readonly string _uriSharePoint = "api/SharePoint/UpdateSharePointERSList";
        private const string ConstFilterHRUploadedCVIndex = "HRUploadedCVIndex";
        private const string ConstFilterHRVacancyIndex = "HRVacancyIndex";

        private readonly IConfiguration _configuration;
        private readonly IHRVacanciesDataTableListRepository _hrVacanciesDataTableListRepository;
        private readonly IHRVacanciesDataTableExcelRepository _hrVacanciesDataTableExcelRepository;
        private readonly IHRUploadedCVDataTableListRepository _hrUploadedCVDataTableListRepository;
        private readonly IHRUploadedCVDataTableExcelRepository _hrUploadedCVDataTableExcelRepository;
        private readonly IHRVacancyDetailRepository _hrVacancyDetailRepository;
        private readonly IVacancyRepository _vacancyRepository;
        private readonly ISelectTcmPLRepository _selectTcmPLRepository;
        private readonly IHRCVActionUpdateRepository _hrCVActionUpdateRepository;
        private readonly IHRCVReferEmpDetailRepository _hrCVReferEmpDetailRepository;
        private readonly IHRCVDetailRepository _hrCVDetailRepository;
        private readonly IHttpClientRapReporting _httpClientRapReporting;
        private readonly IFilterRepository _filterRepository;
        private readonly IUtilityRepository _utilityRepository;

        public HRController(IConfiguration configuration, 
             IHRVacanciesDataTableListRepository hrVacanciesDataTableListRepository,
             IHRVacanciesDataTableExcelRepository hrVacanciesDataTableExcelRepository,
             IHRUploadedCVDataTableListRepository hrUploadedCVDataTableListRepository,
             IHRUploadedCVDataTableExcelRepository hrUploadedCVDataTableExcelRepository,
             IHRVacancyDetailRepository hrVacancyDetailRepository,
             IVacancyRepository vacancyRepository,
             ISelectTcmPLRepository selectTcmPLRepository,
             IHRCVActionUpdateRepository hrCVActionUpdateRepository,
             IHRCVReferEmpDetailRepository hrCVReferEmpDetailRepository,
             IHRCVDetailRepository hrCVDetailRepository,
             IHttpClientRapReporting httpClientRapReporting,
             IFilterRepository filterRepository,
             IUtilityRepository utilityRepository)
        {
            _configuration = configuration;
            _hrVacanciesDataTableListRepository = hrVacanciesDataTableListRepository;
            _hrVacanciesDataTableExcelRepository = hrVacanciesDataTableExcelRepository;
            _hrUploadedCVDataTableListRepository = hrUploadedCVDataTableListRepository;
            _hrUploadedCVDataTableExcelRepository = hrUploadedCVDataTableExcelRepository;
            _hrVacancyDetailRepository = hrVacancyDetailRepository;
            _vacancyRepository = vacancyRepository;
            _selectTcmPLRepository = selectTcmPLRepository;
            _hrCVActionUpdateRepository = hrCVActionUpdateRepository;
            _hrCVReferEmpDetailRepository = hrCVReferEmpDetailRepository;
            _hrCVDetailRepository = hrCVDetailRepository;
            _httpClientRapReporting = httpClientRapReporting;
            _filterRepository = filterRepository;
            _utilityRepository = utilityRepository;
        }

        #region Vacancies
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, ERSHelper.ActionHR)]
        public async Task<IActionResult> HRVacanciesIndex()
        {
            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterHRVacancyIndex
            });
            FilterDataModel filterDataModel = new FilterDataModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            HRVacanciesIndexViewModel hrVacanciesIndexViewModel = new HRVacanciesIndexViewModel();
            hrVacanciesIndexViewModel.FilterDataModel = filterDataModel;

            hrVacanciesIndexViewModel.FilterDataModel.Status = filterDataModel.Status;

            return View(hrVacanciesIndexViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetVacanciesList(DTParameters param)
        {
            int totalRow = 0;

            DTResult<HRVacanciesDataTableList> result = new DTResult<HRVacanciesDataTableList>();

            try
            {
                var data = await _hrVacanciesDataTableListRepository.VacanciesDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = param.Start,
                        PPageLength = param.Length,                                               
                        PGenericSearch = param.GenericSearch ?? " ",
                        PVacancyStatus = param.Status,
                        PJobRefCode = param.JobRefCode,
                        PJobLocation = param.Location,
                        PVacancyOpenFromDate = param.OpenFromDate,
                        PVacancyOpenToDate = param.OpenToDate
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
        public async Task<IActionResult> HRVacancyDetail(string id)
        {
            if (id == null)
                return NotFound();

            UserIdentity currentUserIdentity = CurrentUserIdentity;
            var result = await _hrVacancyDetailRepository.VacancyDetail(
                BaseSpTcmPLGet(), 
                new ParameterSpTcmPL { 
                    PJobKeyId = id
                });

            HRVacancyDetailViewModel hrVacancyDetail = new HRVacancyDetailViewModel();

            if (result.PMessageType == IsOk)
            {
                hrVacancyDetail.JobKeyId = id;
                hrVacancyDetail.Costcode = result.PCostcode;
                hrVacancyDetail.CostcodeName = result.PCostcodeName;
                hrVacancyDetail.JobReferenceCode = result.PJobRefCode;
                hrVacancyDetail.JobOpenDate = result.PJobOpenDate;
                hrVacancyDetail.JobType = result.PJobType;
                hrVacancyDetail.JobLocation = result.PJobLocation;
                hrVacancyDetail.ShortDesc = result.PShortDesc;
                hrVacancyDetail.JobDesc01 = result.PJobDesc01;
                hrVacancyDetail.JobDesc02 = result.PJobDesc02;
                hrVacancyDetail.JobDesc03 = result.PJobDesc03;
                hrVacancyDetail.JobCloseDate = result.PJobCloseDate;
            }
            ViewData["JobKeyId"] = id;

            return PartialView("_ModalHRVacancyDetailPartial", hrVacancyDetail);            
        }

        [HttpGet]
        public async Task<IActionResult> VacancyCreate()
        {
            HRVacancyCreateViewModel hrVacancyCreateViewModel = new HRVacancyCreateViewModel();

            var costCodeList = await _selectTcmPLRepository.ErsSelectCostCodeCreateList(BaseSpTcmPLGet(), null);
            ViewData["CostcodeList"] = new SelectList(costCodeList, "DataValueField", "DataTextField");

            var locationList = await _selectTcmPLRepository.SelectERSLocationList(BaseSpTcmPLGet(), null);
            ViewData["LocationList"] = new SelectList(locationList, "DataValueField", "DataTextField");

            return PartialView("_ModalHRVacancyCreatePartial", hrVacancyCreateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, ERSHelper.ActionHR)]
        public async Task<IActionResult> VacancyCreate([FromForm] HRVacancyCreateViewModel hrVacancyCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _vacancyRepository.VacancyCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PCostcode = hrVacancyCreateViewModel.Costcode,
                            PJobRefCode = hrVacancyCreateViewModel.JobReferenceCode,
                            PJobOpenDate = hrVacancyCreateViewModel.JobOpenDate,
                            PShortDesc = hrVacancyCreateViewModel.ShortDesc,
                            PJobType = hrVacancyCreateViewModel.JobType,
                            PJobLocation = hrVacancyCreateViewModel.JobLocation,                            
                            PJobDesc01 = hrVacancyCreateViewModel.JobDesc01,
                            PJobDesc02 = hrVacancyCreateViewModel.JobDesc02 ?? " ",
                            PJobDesc03 = hrVacancyCreateViewModel.JobDesc03 ?? " "
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
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
            }

            return PartialView("_ModalHRVacancyCreatePartial", hrVacancyCreateViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> VacancyEdit(string id)
        {
            HRVacancyCreateViewModel hrVacancyCreateViewModel = new HRVacancyCreateViewModel();

            var result = await _hrVacancyDetailRepository.VacancyDetail(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PJobKeyId = id
                });

            if (result.PMessageType == IsOk)
            {
                hrVacancyCreateViewModel.JobKeyId = id;
                hrVacancyCreateViewModel.Costcode = result.PCostcode;
                hrVacancyCreateViewModel.JobReferenceCode = result.PJobRefCode;
                hrVacancyCreateViewModel.JobOpenDate = result.PJobOpenDate;
                hrVacancyCreateViewModel.JobType = result.PJobType;
                hrVacancyCreateViewModel.JobLocation = result.PJobLocation;
                hrVacancyCreateViewModel.ShortDesc = result.PShortDesc;
                hrVacancyCreateViewModel.JobDesc01 = result.PJobDesc01;
                hrVacancyCreateViewModel.JobDesc02 = result.PJobDesc02;
                hrVacancyCreateViewModel.JobDesc03 = result.PJobDesc03;
            }
            
            var costCodeList = await _selectTcmPLRepository.ErsSelectCostCodeEditList(BaseSpTcmPLGet(), new ParameterSpTcmPL { PCostcode = result.PCostcode});
            ViewData["CostcodeList"] = new SelectList(costCodeList, "DataValueField", "DataTextField");

            var locationList = await _selectTcmPLRepository.SelectERSLocationList(BaseSpTcmPLGet(), null);
            ViewData["LocationList"] = new SelectList(locationList, "DataValueField", "DataTextField", result.PJobLocation);

            ViewData["JobKeyId"] = id;
            ViewData["CostcodeWithName"] = result.PCostcode + " - " + result.PCostcodeName;

            return PartialView("_ModalHRVacancyEditPartial", hrVacancyCreateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, ERSHelper.ActionHR)]
        public async Task<IActionResult> VacancyEdit([FromForm] HRVacancyCreateViewModel hrVacancyCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _vacancyRepository.VacancyUpdateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PJobKeyId = hrVacancyCreateViewModel.JobKeyId,
                            PJobRefCode = hrVacancyCreateViewModel.JobReferenceCode,
                            PJobOpenDate = hrVacancyCreateViewModel.JobOpenDate,
                            PShortDesc = hrVacancyCreateViewModel.ShortDesc,
                            PJobType = hrVacancyCreateViewModel.JobType,
                            PJobLocation = hrVacancyCreateViewModel.JobLocation,
                            PJobDesc01 = hrVacancyCreateViewModel.JobDesc01,
                            PJobDesc02 = hrVacancyCreateViewModel.JobDesc02 ?? " ",
                            PJobDesc03 = hrVacancyCreateViewModel.JobDesc03 ?? " "
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
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
            }

            return PartialView("_ModalHRVacancyEditPartial", hrVacancyCreateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, ERSHelper.ActionHR)]
        public async Task<IActionResult> VacancyClose(string id)
        {
            if (id == null)
                return NotFound();

            try
            {
                var result = await _vacancyRepository.VacancyCloseAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PJobKeyId = id                           
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
            catch (Exception ex)
            {
                return Json(new { success = false, message = ex.Message });
            }
        }

        #region Filter
        public async Task<IActionResult> VacancyFilterGet()
        {
            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterHRVacancyIndex
            });
            FilterDataModel filterDataModel = new FilterDataModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }
                        
            var jobReference = await _selectTcmPLRepository.ErsSelectJobReferenceList(BaseSpTcmPLGet(), null);
            ViewData["JobReference"] = new SelectList(jobReference, "DataValueField", "DataTextField", filterDataModel.JobRefCode);

            var location = await _selectTcmPLRepository.SelectERSLocationList(BaseSpTcmPLGet(), null);
            ViewData["Location"] = new SelectList(location, "DataValueField", "DataTextField", filterDataModel.Location);

            return PartialView("_ModalHRVacancyFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> VacancyFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                string jsonFilter;

                jsonFilter = JsonConvert.SerializeObject(new
                {
                    Status = filterDataModel.Status,
                    JobRefCode = filterDataModel.JobRefCode,
                    Location = filterDataModel.Location,
                    OpenFromDate = filterDataModel.OpenFromDate,
                    OpenToDate = filterDataModel.OpenToDate
                });

                var retVal = await _filterRepository.FilterCreateAsync(new Domain.Models.FilterCreate
                {
                    PModuleName = CurrentUserIdentity.CurrentModule,
                    PMetaId = CurrentUserIdentity.MetaId,
                    PPersonId = CurrentUserIdentity.EmployeeId,
                    PMvcActionName = ConstFilterHRVacancyIndex,
                    PFilterJson = jsonFilter
                });

                return Json(new
                {
                    success = true,
                    Status = filterDataModel.Status,
                    JobRefCode = filterDataModel.JobRefCode,
                    Location = filterDataModel.Location,
                    OpenFromDate = filterDataModel.OpenFromDate,
                    OpenToDate = filterDataModel.OpenToDate
                });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        public async Task<IActionResult> VacancyResetFilter(string ActionId)
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
        #endregion

        #region Excel Download        

        public async Task<IActionResult> VacancyExcelDownload()
        {
            try
            {
                var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
                {
                    PModuleName = CurrentUserIdentity.CurrentModule,
                    PMetaId = CurrentUserIdentity.MetaId,
                    PPersonId = CurrentUserIdentity.EmployeeId,
                    PMvcActionName = ConstFilterHRVacancyIndex
                });
                FilterDataModel filterDataModel = new FilterDataModel();
                if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                    filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

                string StrFimeName;

                var timeStamp = DateTime.Now.ToFileTime();
                StrFimeName = "FileName_" + timeStamp.ToString();

                DataTable dt = new DataTable();
                string strUser = User.Identity.Name;

                var data = await _hrVacanciesDataTableExcelRepository.VacanciesDataTableExcel(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PVacancyStatus = filterDataModel.Status,
                        PJobRefCode = filterDataModel.JobRefCode,
                        PJobLocation = filterDataModel.Location,
                        PVacancyOpenFromDate = filterDataModel.OpenFromDate,
                        PVacancyOpenToDate = filterDataModel.OpenToDate
                    });

                if (data == null) { return NotFound(); }

                var byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(data, "Report Title", "Sheet name");

                return File(byteContent,
                            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                            StrFimeName + ".xlsx");
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        #endregion Excel Download

        #endregion Vacancies


        #region Sync with SharePoint

        //SyncSharePoint

        public async Task<PostReturnModel> SyncSharePoint()
        {
            var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel{ }, _uriSharePoint);

            PostReturnModel postReturnModel = new PostReturnModel();

            if (returnResponse.IsSuccessStatusCode)
            {
                var JsonString = returnResponse.Content.ReadAsStringAsync().Result;
                postReturnModel = JsonConvert.DeserializeObject<PostReturnModel>(JsonString);
            }

            return postReturnModel;
        }


        #endregion

        #region Uploaded CVs
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, ERSHelper.ActionHR)]
        public async Task<IActionResult> HRUploadedCVIndex()
        {
            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterHRUploadedCVIndex
            });
            FilterDataModel filterDataModel = new FilterDataModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            HRUploadedCVIndexViewModel hrUploadedCVIndexViewModel = new HRUploadedCVIndexViewModel();
            hrUploadedCVIndexViewModel.FilterDataModel = filterDataModel;

            hrUploadedCVIndexViewModel.FilterDataModel.Status = filterDataModel.Status;

            return View(hrUploadedCVIndexViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetUploadedCVList(DTParameters param)
        {
            int totalRow = 0;

            DTResult<HRUploadedCVDataTableList> result = new DTResult<HRUploadedCVDataTableList>();

            try
            {                               
                var data = await _hrUploadedCVDataTableListRepository.UploadedCVDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
                        PGenericSearch = param.GenericSearch ?? " ",
                        PVacancyStatus = param.Status,
                        PJobRefCode = param.JobRefCode,
                        PJobLocation = param.Location,
                        PVacancyOpenFromDate = param.OpenFromDate,
                        PVacancyOpenToDate = param.OpenToDate
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
        public async Task<IActionResult> CVAction(string id)
        {
            if (id == null)
                return NotFound();

            var jobKeyid = id.Split("!-!")[0];
            var candidateEmail = id.Split("!-!")[1];

            HRCVActionUpdateViewModel hrCVActionUpdateViewModel = new HRCVActionUpdateViewModel();

            hrCVActionUpdateViewModel.JobKeyId = jobKeyid;
            hrCVActionUpdateViewModel.CandidateEmail = candidateEmail;

            var vacancyDetail = await _hrVacancyDetailRepository.VacancyDetail(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PJobKeyId = id.Split("!-!")[0]
                });

            ViewData["JobReferenceCode"] = vacancyDetail.PJobRefCode;
            ViewData["JobOpenDate"] = vacancyDetail.PJobOpenDate;
            ViewData["ShortDesc"] = vacancyDetail.PShortDesc;
            ViewData["JobType"] = vacancyDetail.PJobType;
            ViewData["JobLocation"] = vacancyDetail.PJobLocation;
            ViewData["JobDesc01"] = vacancyDetail.PJobDesc01;

            var result = await _hrCVDetailRepository.CVDetail(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PVacancyJobKeyId = jobKeyid,
                    PCandidateEmail = candidateEmail
                });

            HRCVDetailViewModel hrCVDetail = new HRCVDetailViewModel();

            if (result.PMessageType == IsOk)
            {
                hrCVDetail.JobKeyId = jobKeyid;
                hrCVDetail.CandidateName = result.PCandidateName;
                hrCVDetail.CandidateEmail = candidateEmail;
                hrCVDetail.CandidateMobile = result.PCandidateMobile;
                hrCVDetail.Pan = result.PPan;
                hrCVDetail.ShortDesc = result.PShortDesc;
                hrCVDetail.CvStatus = result.PCvStatus;
                hrCVDetail.CvStatusDesc = result.PCvStatusDesc;
            }
            hrCVActionUpdateViewModel.hRCVDetailViewModel = hrCVDetail;

            var statusList = await _selectTcmPLRepository.SelectERSCVStatus(BaseSpTcmPLGet(), null);       
            ViewData["StatusList"] = new SelectList(statusList, "DataValueField", "DataTextField", hrCVDetail.CvStatus.ToString());

            var changeJobReferenceList = await _selectTcmPLRepository.ErsSelectChangeJobReferenceList(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PVacancyJobKeyId = jobKeyid
                });

            ViewData["ChangeJobReferenceList"] = new SelectList(changeJobReferenceList, "DataValueField", "DataTextField");

            return PartialView("_ModalCVActionPartial", hrCVActionUpdateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, ERSHelper.ActionHR)]
        public async Task<IActionResult> CVAction([FromForm] HRCVActionUpdateViewModel hrCVActionUpdateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _hrCVActionUpdateRepository.CVActionUpdate(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PJobKeyId = hrCVActionUpdateViewModel.JobKeyId,
                            PCandidateEmail = hrCVActionUpdateViewModel.CandidateEmail,
                            PCvStatus = Convert.ToDecimal(hrCVActionUpdateViewModel.CvStatus),
                            PChangeJobReference = hrCVActionUpdateViewModel.ChangeJobReference
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
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
            }

            return PartialView("_ModalCVActionPartial", hrCVActionUpdateViewModel);
        }        

        [HttpGet]
        public async Task<IActionResult> CVReferEmpDetail(string id, string candidateEmail)
        {
            if (id == null)
                return NotFound();

            var result = await _hrCVReferEmpDetailRepository.CVReferEmpDetail(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PVacancyJobKeyId = id,
                    PCandidateEmail = candidateEmail
                });

            HRCVReferEmpDetailViewModel hrCVReferEmpDetailViewModel = new HRCVReferEmpDetailViewModel();

            if (result.PMessageType == IsOk)
            {
                hrCVReferEmpDetailViewModel.JobKeyId = id;
                hrCVReferEmpDetailViewModel.Empno = result.PEmpno;
                hrCVReferEmpDetailViewModel.EmpName = result.PEmpName;
                hrCVReferEmpDetailViewModel.EmpEmail = result.PEmpEmail;
                hrCVReferEmpDetailViewModel.EmpParent = result.PEmpParent;
                hrCVReferEmpDetailViewModel.EmpParentName = result.PEmpParentName;
                hrCVReferEmpDetailViewModel.ShortDesc = result.PShortDesc;
            }

            return PartialView("_ModalHRCVReferEmpDetailPartial", hrCVReferEmpDetailViewModel);
        }
                
        [HttpGet]
        public async Task<IActionResult> CVDetail(string id, string candidateEmail)
        {
            if (id == null)
                return NotFound();

            var result = await _hrCVDetailRepository.CVDetail(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PVacancyJobKeyId = id,
                    PCandidateEmail = candidateEmail
                });

            HRCVDetailViewModel hrCVDetail = new HRCVDetailViewModel();

            if (result.PMessageType == IsOk)
            {
                hrCVDetail.JobKeyId = id;
                hrCVDetail.CandidateName = result.PCandidateName;
                hrCVDetail.CandidateEmail = candidateEmail;
                hrCVDetail.CandidateMobile = result.PCandidateMobile;
                hrCVDetail.Pan = result.PPan;
                hrCVDetail.ShortDesc = result.PShortDesc;
            }

            return PartialView("_ModalHRCVDetailPartial", hrCVDetail);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, ERSHelper.ActionHR)]
        public IActionResult DownloadCandidateCVBulk(CvId[] cvId)
        {
            if (cvId == null)
                return NotFound();

            if (cvId.Count() == 0)
                //return NotFound();
                return Json(new { success = false, message = "Please select atleast one CV" });
            //throw new Exception("Please select atleast one CV");

            try
            {
                var baseRepository = _configuration["TCMPLAppBaseRepository"];
                var areaRepository = _configuration["AreaRepository:EmployeeReferalScheme"];
                var folder = Path.Combine(baseRepository, areaRepository);
                var currentDateTimeString = DateTime.Now.Year.ToString() + DateTime.Now.Month.ToString() + DateTime.Now.Day.ToString() + DateTime.Now.Hour.ToString() + DateTime.Now.Minute.ToString() + DateTime.Now.Second.ToString() + DateTime.Now.Millisecond.ToString();
                //var folderName = "C:\\temp\\" + currentDateTimeString.ToString();
                var folderName = Path.Combine(_configuration["TCMPLAppTempRepository"], currentDateTimeString.ToString());

                if (!Directory.Exists(folderName))
                {
                    Directory.CreateDirectory(folderName);
                }
                foreach (var item in cvId)
                {
                    var fName = item.id.Split("!-!")[1].ToString() + "_" + item.id.Split("!-!")[3].ToString() + ".pdf";
                    var file = Path.Combine(folder, item.id.Split("!-!")[0].ToString());
                    byte[] fileBytes = System.IO.File.ReadAllBytes(file);
                    System.IO.File.WriteAllBytes(folderName + "\\" + fName, fileBytes);          
                }
                ZipFile.CreateFromDirectory(folderName, folderName + ".zip");

                var files = folderName + ".zip";
                byte[] bytes = System.IO.File.ReadAllBytes(files);
                return File(bytes, "application/octet-stream", currentDateTimeString.ToString() + ".zip");
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = ex.Message });
            }
        }

        #region Filter

        public async Task<IActionResult> CvFilterGet()
        {
            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterHRUploadedCVIndex
            });
            FilterDataModel filterDataModel = new FilterDataModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            var status = await _selectTcmPLRepository.SelectERSCVStatus(BaseSpTcmPLGet(), null);            
            ViewData["Status"] = new SelectList(status, "DataValueField", "DataTextField", filterDataModel.Status);

            var jobReference = await _selectTcmPLRepository.ErsSelectJobReferenceList(BaseSpTcmPLGet(), null);
            ViewData["JobReference"] = new SelectList(jobReference, "DataValueField", "DataTextField", filterDataModel.JobRefCode);

            var location = await _selectTcmPLRepository.SelectERSLocationList(BaseSpTcmPLGet(), null);
            ViewData["Location"] = new SelectList(location, "DataValueField", "DataTextField", filterDataModel.Location);
            
            return PartialView("_ModalHRUploadedCVFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> CvFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                string jsonFilter;

                jsonFilter = JsonConvert.SerializeObject(new
                {
                    Status = filterDataModel.Status,
                    JobRefCode = filterDataModel.JobRefCode,
                    Location = filterDataModel.Location,
                    OpenFromDate = filterDataModel.OpenFromDate,
                    OpenToDate = filterDataModel.OpenToDate
                });

                var retVal = await _filterRepository.FilterCreateAsync(new Domain.Models.FilterCreate
                {
                    PModuleName = CurrentUserIdentity.CurrentModule,
                    PMetaId = CurrentUserIdentity.MetaId,
                    PPersonId = CurrentUserIdentity.EmployeeId,
                    PMvcActionName = ConstFilterHRUploadedCVIndex,
                    PFilterJson = jsonFilter
                });

                return Json(new
                {
                    success = true,
                    Status = filterDataModel.Status,
                    JobRefCode = filterDataModel.JobRefCode,
                    Location = filterDataModel.Location,
                    OpenFromDate = filterDataModel.OpenFromDate,
                    OpenToDate = filterDataModel.OpenToDate
                });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
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


        #endregion Filter


        #region Excel Download

        public async Task<IActionResult> ExcelDownload()
        {
            try
            {
                var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
                {
                    PModuleName = CurrentUserIdentity.CurrentModule,
                    PMetaId = CurrentUserIdentity.MetaId,
                    PPersonId = CurrentUserIdentity.EmployeeId,
                    PMvcActionName = ConstFilterHRUploadedCVIndex
                });
                FilterDataModel filterDataModel = new FilterDataModel();
                if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                    filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

                string StrFimeName;

                var timeStamp = DateTime.Now.ToFileTime();
                StrFimeName = "FileName_" + timeStamp.ToString();

                DataTable dt = new DataTable();
                string strUser = User.Identity.Name;

                var data = await _hrUploadedCVDataTableExcelRepository.UploadedCVDataTableExcel(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PVacancyStatus = filterDataModel.Status,
                        PJobRefCode = filterDataModel.JobRefCode,
                        PJobLocation = filterDataModel.Location,
                        PVacancyOpenFromDate = filterDataModel.OpenFromDate,
                        PVacancyOpenToDate = filterDataModel.OpenToDate
                    });
                
                if (data == null) { return NotFound(); }

                var byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(data, "Report Title", "Sheet name");

                return File(byteContent,
                            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                            StrFimeName + ".xlsx");
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        #endregion Excel Download

        #endregion Uploaded CVs
    }
}
