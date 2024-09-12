using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using MimeTypes;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.Common;
using TCMPLApp.DataAccess.Repositories.DigiForm;
using TCMPLApp.DataAccess.Repositories.SWPVaccine;
using TCMPLApp.Domain.Models.Common;
using TCMPLApp.Domain.Models.DigiForm;
using TCMPLApp.WebApp.Classes;
using TCMPLApp.WebApp.Controllers;
using TCMPLApp.WebApp.CustomPolicyProvider;
using TCMPLApp.WebApp.Models;
using TCMPLApp.WebApp.Services;
using static TCMPLApp.WebApp.Classes.DTModel;

namespace TCMPLApp.WebApp.Areas.DigiForm.Controllers
{
    [Authorize]
    [Area("DigiForm")]
    public class HRDigiFormController : BaseController
    {
        private const int saveAsDraft = 2;
        private const int Pending = 0;
        private const int Approved = 1;
        private const int Rejected = -1;
        private const int PendingTimeBound = 3;
        private const string ActionPayRollApprover = "A213";

        private readonly IFilterRepository _filterRepository;
        private const string ConstFilterHRMidEvaluationIndex = "HRMidEvaluationIndex";
        private const string ConstFilterHODMidEvaluationIndex = "HODMidEvaluationIndex";
        private const string ConstFilterCostCodeChangeRequestIndex = "CostCodeChangeRequestIndex";
        private const string ConstFilterHodApprovalsHistoryIndex = "HodApprovalsHistoryIndex";
        private const string ConstFilterHrApprovalsHistoryIndex = "HrApprovalsHistoryIndex";
        private const string ConstFilterHrApprovedApprovalsIndex = "HrApprovedApprovalsIndex";
        private const string ConstFilterSiteMasterIndex = "SiteMasterIndex";
        private const string ConstFilterHodTransferEmployeesIndex = "HodTransferEmployeesIndex";
        private const string ConstFilterHrTransferEmployeesIndex = "HrTransferEmployeesIndex";

        private const string ConstFilterHODAnnualEvaluationPendingIndex = "HODAnnualEvaluationPendingIndex";
        private const string ConstFilterHODAnnualEvaluationHistoryIndex = "HODAnnualEvaluationHistoryIndex";
        private const string ConstFilterHRAnnualEvaluationPendingIndex = "HRAnnualEvaluationPendingIndex";
        private const string ConstFilterHRAnnualEvaluationActionPendingIndex = "HRAnnualEvaluationActionPendingIndex";
        private const string ConstFilterHRAnnualEvaluationHistoryIndex = "HRAnnualEvaluationHistoryIndex";
        private IWebHostEnvironment _environment;

        private readonly IHttpClientWebApi _httpClientWebApi;
        private readonly IMidTermEvaluationDataTableListRepository _midTermEvaluationDataTableListRepository;
        private readonly ICommonEmployeeDetailsRepository _commonEmployeeDetailsRepository;
        private readonly IMidEvaluationDetailRepository _midEvaluationDetailRepository;
        private readonly IMidTermEvaluationRepository _midTermEvaluationRepository;
        private readonly ISelectTcmPLRepository _selectTcmPLRepository;
        private readonly IMidEvaluationGetKeyIdRepository _midEvaluationGetKeyIdRepository;

        private readonly ICostcodeChangeRequestDataTableListRepository _costcodeChangeRequestDataTableListRepository;
        private readonly ICostcodeChangeRequestRepository _costcodeChangeRequestRepository;
        private readonly ICostcodeChangeRequestDetailRepository _costcodeChangeRequestDetailRepository;
        private readonly IApprovalDetailsDataTableListRepository _approvalDetailsDataTableListRepository;
        private readonly ISiteMasterDataTableListRepository _siteMasterDataTableListRepository;
        private readonly ISiteMasterRequestRepository _siteMasterRequestRepository;
        private readonly ISiteMasterDetailRepository _siteMasterDetailRepository;

        private readonly IAnnualEvaluationDataTableListRepository _annualEvaluationDataTableListRepository;
        private readonly IAnnualEvaluationRepository _annualEvaluationRepository;
        private readonly IAnnualEvaluationDetailRepository _annualEvaluationDetailRepository;
        private readonly IAnnualEvaluationGetKeyIdRepository _annualEvaluationGetKeyIdRepository;

        private readonly IUtilityRepository _utilityRepository;
        private readonly ISelectRepository _selectRepository;

        public HRDigiFormController(
            IWebHostEnvironment environment,
            IFilterRepository filterRepository,
            IHttpClientWebApi httpClientWebApi,
            IMidTermEvaluationDataTableListRepository midTermEvaluationDataTableListRepository,
            ICommonEmployeeDetailsRepository commonEmployeeDetailsRepository,
            IMidEvaluationDetailRepository midEvaluationDetailRepository,
            IMidTermEvaluationRepository midTermEvaluationRepository,
            ISelectTcmPLRepository selectTcmPLRepository,
            IMidEvaluationGetKeyIdRepository midEvaluationGetKeyIdRepository,
            ICostcodeChangeRequestDataTableListRepository costcodeChangeRequestDataTableListRepository,
            ICostcodeChangeRequestRepository costcodeChangeRequestRepository,
            ICostcodeChangeRequestDetailRepository costcodeChangeRequestDetailRepository,
            ISelectRepository selectRepository,
            IUtilityRepository utilityRepository,
            IApprovalDetailsDataTableListRepository approvalDetailsDataTableListRepository,
            ISiteMasterDataTableListRepository siteMasterDataTableListRepository,
            ISiteMasterRequestRepository siteMasterRequestRepository,
            ISiteMasterDetailRepository siteMasterDetailRepository,
            IAnnualEvaluationDataTableListRepository annualEvaluationDataTableListRepository,
            IAnnualEvaluationRepository annualEvaluationRepository,
            IAnnualEvaluationDetailRepository annualEvaluationDetailRepository,
            IAnnualEvaluationGetKeyIdRepository annualEvaluationGetKeyIdRepository
            )
        {
            _environment = environment;
            _filterRepository = filterRepository;
            _httpClientWebApi = httpClientWebApi;
            _utilityRepository = utilityRepository;
            _midTermEvaluationDataTableListRepository = midTermEvaluationDataTableListRepository;
            _commonEmployeeDetailsRepository = commonEmployeeDetailsRepository;
            _midEvaluationDetailRepository = midEvaluationDetailRepository;
            _midTermEvaluationRepository = midTermEvaluationRepository;
            _selectTcmPLRepository = selectTcmPLRepository;
            _midEvaluationGetKeyIdRepository = midEvaluationGetKeyIdRepository;
            _costcodeChangeRequestDataTableListRepository = costcodeChangeRequestDataTableListRepository;
            _costcodeChangeRequestRepository = costcodeChangeRequestRepository;
            _costcodeChangeRequestDetailRepository = costcodeChangeRequestDetailRepository;
            _selectRepository = selectRepository;
            _approvalDetailsDataTableListRepository = approvalDetailsDataTableListRepository;
            _siteMasterDataTableListRepository = siteMasterDataTableListRepository;
            _siteMasterRequestRepository = siteMasterRequestRepository;
            _siteMasterDetailRepository = siteMasterDetailRepository;
            _annualEvaluationDataTableListRepository = annualEvaluationDataTableListRepository;
            _annualEvaluationRepository = annualEvaluationRepository;
            _annualEvaluationDetailRepository = annualEvaluationDetailRepository;
            _annualEvaluationGetKeyIdRepository = annualEvaluationGetKeyIdRepository;
        }

        #region HR Mid Evaluation

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DigiFormHelper.ActionProgEvalHR)]
        public async Task<IActionResult> HRMidEvaluationPendingIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterHRMidEvaluationIndex
            });

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            MidEvaluationIndexViewModel midEvaluationIndexViewModel = new()
            {
                FilterDataModel = filterDataModel
            };
            return View(midEvaluationIndexViewModel);
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DigiFormHelper.ActionProgEvalHR)]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsHRMidTermEvaluationPendingList(string paramJson)
        {
            DTResult<MidEvaluationDataTableList> result = new();
            int totalRow = 0;
            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            try
            {
                System.Collections.Generic.IEnumerable<MidEvaluationDataTableList> data = await _midTermEvaluationDataTableListRepository.HRMidTermEvaluationPendingDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch,
                        PGrade = param.Grade,
                        PParent = param.Parent,
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

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DigiFormHelper.ActionProgEvalHR)]
        public async Task<IActionResult> HRMidEvaluationHistoryIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterHRMidEvaluationIndex
            });

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            MidEvaluationIndexViewModel midEvaluationIndexViewModel = new()
            {
                FilterDataModel = filterDataModel
            };
            return View(midEvaluationIndexViewModel);
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DigiFormHelper.ActionProgEvalHR)]
        public async Task<JsonResult> GetListsHRMidTermEvaluationHistoryList(string paramJson)
        {
            DTResult<MidEvaluationDataTableList> result = new();
            int totalRow = 0;
            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            try
            {
                System.Collections.Generic.IEnumerable<MidEvaluationDataTableList> data = await _midTermEvaluationDataTableListRepository.HRMidTermEvaluationHistoryDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch,
                        PGrade = param.Grade,
                        PParent = param.Parent,
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
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DigiFormHelper.RoleProgEvalHR)]
        public async Task<IActionResult> HRMidTermEvaluationEdit(string empno, string keyid)
        {
            if (empno == null)
            {
                return NotFound();
            }

            var employeeDetails = await _commonEmployeeDetailsRepository.EmployeeDetailAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL { PEmpno = empno });

            MidTermEvaluationEditViewModel midTermEvaluationEditViewModel = new();

            midTermEvaluationEditViewModel.Empno = empno;
            midTermEvaluationEditViewModel.EmployeeName = employeeDetails.PName;
            midTermEvaluationEditViewModel.DesgName = employeeDetails.PDesgCode + " -  " + employeeDetails.PDesgName;
            midTermEvaluationEditViewModel.Parent = employeeDetails.PParent + " - " + employeeDetails.PCostName;
            midTermEvaluationEditViewModel.Doj = employeeDetails.PDoj;
            midTermEvaluationEditViewModel.Location = employeeDetails.PCurrentOfficeLocation;
            midTermEvaluationEditViewModel.KeyId = null;

            if (keyid != null)
            {
                MidEvaluationDetail result = await _midEvaluationDetailRepository.MidEvaluationDetails(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PKeyId = keyid
                });

                midTermEvaluationEditViewModel.KeyId = keyid;
                midTermEvaluationEditViewModel.Attendance = result.PAttendance;
                midTermEvaluationEditViewModel.Skill1 = result.PSkill1;
                midTermEvaluationEditViewModel.Skill1Rating = result.PSkill1RatingVal;
                midTermEvaluationEditViewModel.Skill1Remark = result.PSkill1Remark;
                midTermEvaluationEditViewModel.Skill2 = result.PSkill2;
                midTermEvaluationEditViewModel.Skill2Rating = result.PSkill2RatingVal;
                midTermEvaluationEditViewModel.Skill2Remark = result.PSkill2Remark;
                midTermEvaluationEditViewModel.Skill3 = result.PSkill3;
                midTermEvaluationEditViewModel.Skill3Rating = result.PSkill3RatingVal;
                midTermEvaluationEditViewModel.Skill3Remark = result.PSkill3Remark;
                midTermEvaluationEditViewModel.Skill4 = result.PSkill4;
                midTermEvaluationEditViewModel.Skill4Rating = result.PSkill4RatingVal;
                midTermEvaluationEditViewModel.Skill4Remark = result.PSkill4Remark;
                midTermEvaluationEditViewModel.Skill5 = result.PSkill5;
                midTermEvaluationEditViewModel.Skill5Rating = result.PSkill5RatingVal;
                midTermEvaluationEditViewModel.Que2Rating = result.PQue2RatingVal;
                midTermEvaluationEditViewModel.Que2Remark = result.PQue2Remark;
                midTermEvaluationEditViewModel.Que3Rating = result.PQue3RatingVal;
                midTermEvaluationEditViewModel.Que3Remark = result.PQue3Remark;
                midTermEvaluationEditViewModel.Que4Rating = result.PQue4RatingVal;
                midTermEvaluationEditViewModel.Que4Remark = result.PQue4Remark;
                midTermEvaluationEditViewModel.Que5Rating = result.PQue5RatingVal;
                midTermEvaluationEditViewModel.Que5Remark = result.PQue5Remark;
                midTermEvaluationEditViewModel.Que6Rating = result.PQue6RatingVal;
                midTermEvaluationEditViewModel.Que6Remark = result.PQue6Remark;
                midTermEvaluationEditViewModel.Observations = result.PObservations;
            }

            return View("HRMidTermEvaluationEdit", midTermEvaluationEditViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DigiFormHelper.ActionProgEvalHR)]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> HRMidTermEvaluationEdit([FromForm] MidTermEvaluationEditViewModel midTermEvaluationEditViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var employeeDetails = await _commonEmployeeDetailsRepository.EmployeeDetailAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL { PEmpno = midTermEvaluationEditViewModel.Empno });

                    midTermEvaluationEditViewModel.EmployeeName = employeeDetails.PName;
                    midTermEvaluationEditViewModel.Desgcode = employeeDetails.PDesgCode;
                    midTermEvaluationEditViewModel.Parent = employeeDetails.PParent;
                    midTermEvaluationEditViewModel.Doj = employeeDetails.PDoj;
                    midTermEvaluationEditViewModel.Location = employeeDetails.PCurrentOfficeLocation;
                    midTermEvaluationEditViewModel.Isdeleted = 0;

                    Domain.Models.Common.DBProcMessageOutput result;

                    if (midTermEvaluationEditViewModel.KeyId == null || midTermEvaluationEditViewModel.KeyId == "null")
                    {
                        result = await _midTermEvaluationRepository.MidTermEvaluationEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PJsonObj = JsonConvert.SerializeObject(midTermEvaluationEditViewModel)
                        });
                    }
                    else
                    {
                        result = await _midTermEvaluationRepository.MidTermEvaluationUpdateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PKeyId = midTermEvaluationEditViewModel.KeyId,
                            PJsonObj = JsonConvert.SerializeObject(midTermEvaluationEditViewModel)
                        });
                    }

                    if (result.PMessageType == IsOk)
                    {
                        Notify("Success", "Procedure executed successfully", "", NotificationType.success);

                        return RedirectToAction("HRMidTermEvaluationEdit", new { empno = midTermEvaluationEditViewModel.Empno, keyId = midTermEvaluationEditViewModel.KeyId });
                    }
                    else
                    {
                        Notify("Error", result.PMessageText, "", NotificationType.error);
                    }
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }

            return RedirectToAction("HRMidTermEvaluationEdit", new { id = midTermEvaluationEditViewModel.Empno });
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DigiFormHelper.ActionProgEvalHR)]
        public async Task<IActionResult> HRMidTermEvaluationDetails(string id, string empno)
        {
            MidEvaluationDetailsViewModel midEvaluationDetailsViewModel = new();

            var employeeDetails = await _commonEmployeeDetailsRepository.EmployeeDetailAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL { PEmpno = empno });

            midEvaluationDetailsViewModel.Empno = empno;
            midEvaluationDetailsViewModel.EmployeeName = employeeDetails.PName;
            midEvaluationDetailsViewModel.DesgName = employeeDetails.PDesgCode + " -  " + employeeDetails.PDesgName;
            midEvaluationDetailsViewModel.CostName = employeeDetails.PParent + " - " + employeeDetails.PCostName;
            midEvaluationDetailsViewModel.Doj = employeeDetails.PDoj;
            midEvaluationDetailsViewModel.EvaluationPeriod = employeeDetails.PDoj.AddMonths(3).ToString("dd-MMM-yyyy");
            midEvaluationDetailsViewModel.Location = employeeDetails.PCurrentOfficeLocation;
            midEvaluationDetailsViewModel.KeyId = id;

            MidEvaluationDetail result = await _midEvaluationDetailRepository.MidEvaluationDetails(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PKeyId = id
                });

            midEvaluationDetailsViewModel.Attendance = result.PAttendance;
            midEvaluationDetailsViewModel.Skill1 = result.PSkill1;
            midEvaluationDetailsViewModel.Skill1RatingText = result.PSkill1RatingText;
            midEvaluationDetailsViewModel.Skill1Remark = result.PSkill1Remark;
            midEvaluationDetailsViewModel.Skill2 = result.PSkill2;
            midEvaluationDetailsViewModel.Skill2RatingText = result.PSkill2RatingText;
            midEvaluationDetailsViewModel.Skill2Remark = result.PSkill2Remark;
            midEvaluationDetailsViewModel.Skill3 = result.PSkill3;
            midEvaluationDetailsViewModel.Skill3RatingText = result.PSkill3RatingText;
            midEvaluationDetailsViewModel.Skill3Remark = result.PSkill3Remark;
            midEvaluationDetailsViewModel.Skill4 = result.PSkill4;
            midEvaluationDetailsViewModel.Skill4RatingText = result.PSkill4RatingText;
            midEvaluationDetailsViewModel.Skill4Remark = result.PSkill4Remark;
            midEvaluationDetailsViewModel.Skill5 = result.PSkill5;
            midEvaluationDetailsViewModel.Skill5RatingText = result.PSkill5RatingText;
            midEvaluationDetailsViewModel.Que2RatingText = result.PQue2RatingText;
            midEvaluationDetailsViewModel.Que2Remark = result.PQue2Remark;
            midEvaluationDetailsViewModel.Que3RatingText = result.PQue3RatingText;
            midEvaluationDetailsViewModel.Que3Remark = result.PQue3Remark;
            midEvaluationDetailsViewModel.Que4RatingText = result.PQue4RatingText;
            midEvaluationDetailsViewModel.Que4Remark = result.PQue4Remark;
            midEvaluationDetailsViewModel.Que5RatingText = result.PQue5RatingText;
            midEvaluationDetailsViewModel.Que5Remark = result.PQue5Remark;
            midEvaluationDetailsViewModel.Que6RatingText = result.PQue6RatingText;
            midEvaluationDetailsViewModel.Que6Remark = result.PQue6Remark;
            midEvaluationDetailsViewModel.Observations = result.PObservations;

            return View("HRMidTermEvaluationDetails", midEvaluationDetailsViewModel);
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DigiFormHelper.ActionProgEvalHR)]
        public async Task<IActionResult> HRMidTermEvaluationSendDetails(string id, string empno)
        {
            MidEvaluationDetailsViewModel midEvaluationDetailsViewModel = new();

            var employeeDetails = await _commonEmployeeDetailsRepository.EmployeeDetailAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL { PEmpno = empno });

            midEvaluationDetailsViewModel.Empno = empno;
            midEvaluationDetailsViewModel.EmployeeName = employeeDetails.PName;
            midEvaluationDetailsViewModel.DesgName = employeeDetails.PDesgCode + " -  " + employeeDetails.PDesgName;
            midEvaluationDetailsViewModel.CostName = employeeDetails.PParent + " - " + employeeDetails.PCostName;
            midEvaluationDetailsViewModel.Doj = employeeDetails.PDoj;
            midEvaluationDetailsViewModel.EvaluationPeriod = employeeDetails.PDoj.AddMonths(3).ToString("dd-MMM-yyyy");
            midEvaluationDetailsViewModel.Location = employeeDetails.PCurrentOfficeLocation;
            midEvaluationDetailsViewModel.KeyId = id;

            MidEvaluationDetail result = await _midEvaluationDetailRepository.MidEvaluationDetails(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PKeyId = id
                });

            midEvaluationDetailsViewModel.Attendance = result.PAttendance;
            midEvaluationDetailsViewModel.Skill1 = result.PSkill1;
            midEvaluationDetailsViewModel.Skill1RatingText = result.PSkill1RatingText;
            midEvaluationDetailsViewModel.Skill1Remark = result.PSkill1Remark;
            midEvaluationDetailsViewModel.Skill2 = result.PSkill2;
            midEvaluationDetailsViewModel.Skill2RatingText = result.PSkill2RatingText;
            midEvaluationDetailsViewModel.Skill2Remark = result.PSkill2Remark;
            midEvaluationDetailsViewModel.Skill3 = result.PSkill3;
            midEvaluationDetailsViewModel.Skill3RatingText = result.PSkill3RatingText;
            midEvaluationDetailsViewModel.Skill3Remark = result.PSkill3Remark;
            midEvaluationDetailsViewModel.Skill4 = result.PSkill4;
            midEvaluationDetailsViewModel.Skill4RatingText = result.PSkill4RatingText;
            midEvaluationDetailsViewModel.Skill4Remark = result.PSkill4Remark;
            midEvaluationDetailsViewModel.Skill5 = result.PSkill5;
            midEvaluationDetailsViewModel.Skill5RatingText = result.PSkill5RatingText;
            midEvaluationDetailsViewModel.Que2RatingText = result.PQue2RatingText;
            midEvaluationDetailsViewModel.Que2Remark = result.PQue2Remark;
            midEvaluationDetailsViewModel.Que3RatingText = result.PQue3RatingText;
            midEvaluationDetailsViewModel.Que3Remark = result.PQue3Remark;
            midEvaluationDetailsViewModel.Que4RatingText = result.PQue4RatingText;
            midEvaluationDetailsViewModel.Que4Remark = result.PQue4Remark;
            midEvaluationDetailsViewModel.Que5RatingText = result.PQue5RatingText;
            midEvaluationDetailsViewModel.Que5Remark = result.PQue5Remark;
            midEvaluationDetailsViewModel.Que6RatingText = result.PQue6RatingText;
            midEvaluationDetailsViewModel.Que6Remark = result.PQue6Remark;
            midEvaluationDetailsViewModel.Observations = result.PObservations;

            return View("HRMidTermEvaluationSendDetails", midEvaluationDetailsViewModel);
        }

        #endregion HR Mid Evaluation

        #region HOD Mid Evaluation

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DigiFormHelper.ActionProgEvalView)]
        public async Task<IActionResult> HODMidEvaluationPendingIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterHODMidEvaluationIndex
            });

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            MidEvaluationIndexViewModel midEvaluationIndexViewModel = new()
            {
                FilterDataModel = filterDataModel
            };
            return View(midEvaluationIndexViewModel);
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DigiFormHelper.ActionProgEvalView)]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsHODMidTermEvaluationPendingList(string paramJson)
        {
            DTResult<MidEvaluationDataTableList> result = new();
            int totalRow = 0;
            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            try
            {
                System.Collections.Generic.IEnumerable<MidEvaluationDataTableList> data = await _midTermEvaluationDataTableListRepository.HODMidTermEvaluationPendingDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch,
                        PGrade = param.Grade,
                        PParent = param.Parent,
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

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DigiFormHelper.ActionProgEvalView)]
        public async Task<IActionResult> HODMidEvaluationHistoryIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterHODMidEvaluationIndex
            });

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            MidEvaluationIndexViewModel midEvaluationIndexViewModel = new()
            {
                FilterDataModel = filterDataModel
            };
            return View(midEvaluationIndexViewModel);
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DigiFormHelper.ActionProgEvalView)]
        public async Task<JsonResult> GetListsHODMidTermEvaluationHistoryList(string paramJson)
        {
            DTResult<MidEvaluationDataTableList> result = new();
            int totalRow = 0;
            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            try
            {
                System.Collections.Generic.IEnumerable<MidEvaluationDataTableList> data = await _midTermEvaluationDataTableListRepository.HODMidTermEvaluationHistoryDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch,
                        PGrade = param.Grade,
                        PParent = param.Parent,
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

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DigiFormHelper.ActionProgEvalUpdate)]
        public async Task<IActionResult> HODMidTermEvaluationEdit(string empno, string keyid)
        {
            if (empno == null)
            {
                return NotFound();
            }

            var validateEmployee = await _midTermEvaluationRepository.MidTermEvaluationValidateEmployeeAsync(
                      BaseSpTcmPLGet(),
                      new ParameterSpTcmPL
                      {
                          PEmpno = empno
                      });

            if (validateEmployee.PMessageType == NotOk)
            {
                Notify("Error", validateEmployee.PMessageText, "", NotificationType.error);
                return RedirectToAction("HODMidEvaluationPendingIndex");
            }

            var employeeDetails = await _commonEmployeeDetailsRepository.EmployeeDetailAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL { PEmpno = empno });

            MidTermEvaluationEditViewModel midTermEvaluationEditViewModel = new();

            midTermEvaluationEditViewModel.Empno = empno;
            midTermEvaluationEditViewModel.EmployeeName = employeeDetails.PName;
            midTermEvaluationEditViewModel.DesgName = employeeDetails.PDesgCode + " -  " + employeeDetails.PDesgName;
            midTermEvaluationEditViewModel.Parent = employeeDetails.PParent + " - " + employeeDetails.PCostName;
            midTermEvaluationEditViewModel.Doj = employeeDetails.PDoj;
            midTermEvaluationEditViewModel.EvaluationPeriod = employeeDetails.PDoj.AddMonths(3).ToString("dd-MMM-yyyy");
            midTermEvaluationEditViewModel.Location = employeeDetails.PCurrentOfficeLocation;

            if (keyid != "null")
            {
                MidEvaluationDetail result = await _midEvaluationDetailRepository.MidEvaluationDetails(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PKeyId = keyid
                });

                midTermEvaluationEditViewModel.KeyId = keyid;
                midTermEvaluationEditViewModel.Attendance = result.PAttendance;
                midTermEvaluationEditViewModel.Skill1 = result.PSkill1;
                midTermEvaluationEditViewModel.Skill1Rating = result.PSkill1RatingVal;
                midTermEvaluationEditViewModel.Skill1Remark = result.PSkill1Remark;
                midTermEvaluationEditViewModel.Skill2 = result.PSkill2;
                midTermEvaluationEditViewModel.Skill2Rating = result.PSkill2RatingVal;
                midTermEvaluationEditViewModel.Skill2Remark = result.PSkill2Remark;
                midTermEvaluationEditViewModel.Skill3 = result.PSkill3;
                midTermEvaluationEditViewModel.Skill3Rating = result.PSkill3RatingVal;
                midTermEvaluationEditViewModel.Skill3Remark = result.PSkill3Remark;
                midTermEvaluationEditViewModel.Skill4 = result.PSkill4;
                midTermEvaluationEditViewModel.Skill4Rating = result.PSkill4RatingVal;
                midTermEvaluationEditViewModel.Skill4Remark = result.PSkill4Remark;
                midTermEvaluationEditViewModel.Skill5 = result.PSkill5;
                midTermEvaluationEditViewModel.Skill5Rating = result.PSkill5RatingVal;
                midTermEvaluationEditViewModel.Que2Rating = result.PQue2RatingVal;
                midTermEvaluationEditViewModel.Que2Remark = result.PQue2Remark;
                midTermEvaluationEditViewModel.Que3Rating = result.PQue3RatingVal;
                midTermEvaluationEditViewModel.Que3Remark = result.PQue3Remark;
                midTermEvaluationEditViewModel.Que4Rating = result.PQue4RatingVal;
                midTermEvaluationEditViewModel.Que4Remark = result.PQue4Remark;
                midTermEvaluationEditViewModel.Que5Rating = result.PQue5RatingVal;
                midTermEvaluationEditViewModel.Que5Remark = result.PQue5Remark;
                midTermEvaluationEditViewModel.Que6Rating = result.PQue6RatingVal;
                midTermEvaluationEditViewModel.Que6Remark = result.PQue6Remark;
                midTermEvaluationEditViewModel.Observations = result.PObservations;
            }

            return View("HODMidTermEvaluationEdit", midTermEvaluationEditViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DigiFormHelper.ActionProgEvalUpdate)]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> HODMidTermEvaluationEdit([FromForm] MidTermEvaluationEditViewModel midTermEvaluationEditViewModel)
        {
            if (ModelState.IsValid)
            {
                var validateEmployee = await _midTermEvaluationRepository.MidTermEvaluationValidateEmployeeAsync(
                  BaseSpTcmPLGet(),
                  new ParameterSpTcmPL
                  {
                      PEmpno = midTermEvaluationEditViewModel.Empno
                  });

                if (validateEmployee.PMessageType == NotOk)
                {
                    Notify("Error", validateEmployee.PMessageText, "", NotificationType.error);
                    return RedirectToAction("HODMidEvaluationPendingIndex");
                }
                var employeeDetails = await _commonEmployeeDetailsRepository.EmployeeDetailAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL { PEmpno = midTermEvaluationEditViewModel.Empno });

                midTermEvaluationEditViewModel.EmployeeName = employeeDetails.PName;
                midTermEvaluationEditViewModel.Desgcode = employeeDetails.PDesgCode;
                midTermEvaluationEditViewModel.Parent = employeeDetails.PParent;
                midTermEvaluationEditViewModel.Doj = employeeDetails.PDoj;
                midTermEvaluationEditViewModel.Location = employeeDetails.PCurrentOfficeLocation;
                midTermEvaluationEditViewModel.Isdeleted = 0;

                Domain.Models.Common.DBProcMessageOutput result;

                if (midTermEvaluationEditViewModel.KeyId == null || midTermEvaluationEditViewModel.KeyId == "null")
                {
                    result = await _midTermEvaluationRepository.MidTermEvaluationEditAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PJsonObj = JsonConvert.SerializeObject(midTermEvaluationEditViewModel)
                    });
                }
                else
                {
                    result = await _midTermEvaluationRepository.MidTermEvaluationUpdateAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PKeyId = midTermEvaluationEditViewModel.KeyId,
                        PJsonObj = JsonConvert.SerializeObject(midTermEvaluationEditViewModel)
                    });
                }

                if (result.PMessageType == IsOk)
                {
                    Notify("Success", "Procedure executed successfully", "", NotificationType.success);

                    MidEvaluationGetKeyId getKeyId = await _midEvaluationGetKeyIdRepository.MidEvaluationGetKeyId(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PEmpno = midTermEvaluationEditViewModel.Empno,
                    });
                    return RedirectToAction("HODMidTermEvaluationEdit", new { empno = midTermEvaluationEditViewModel.Empno, keyId = getKeyId.PKeyId });
                }
                else
                {
                    Notify("Error", result.PMessageText, "", NotificationType.error);
                }
            }

            var employeeDetails1 = await _commonEmployeeDetailsRepository.EmployeeDetailAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL { PEmpno = midTermEvaluationEditViewModel.Empno });

            midTermEvaluationEditViewModel.EmployeeName = employeeDetails1.PName;
            midTermEvaluationEditViewModel.DesgName = employeeDetails1.PDesgCode + " -  " + employeeDetails1.PDesgName;
            midTermEvaluationEditViewModel.Parent = employeeDetails1.PParent + " - " + employeeDetails1.PCostName;
            midTermEvaluationEditViewModel.Doj = employeeDetails1.PDoj;
            midTermEvaluationEditViewModel.EvaluationPeriod = employeeDetails1.PDoj.AddMonths(3).ToString("dd-MMM-yyyy");
            midTermEvaluationEditViewModel.Location = employeeDetails1.PCurrentOfficeLocation;

            return View("HODMidTermEvaluationEdit", midTermEvaluationEditViewModel);
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DigiFormHelper.ActionProgEvalUpdate)]
        public async Task<IActionResult> HODMidTermEvaluationDetails(string id, string empno)
        {
            MidEvaluationDetailsViewModel midEvaluationDetailsViewModel = new();

            var employeeDetails = await _commonEmployeeDetailsRepository.EmployeeDetailAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL { PEmpno = empno });

            midEvaluationDetailsViewModel.Empno = empno;
            midEvaluationDetailsViewModel.EmployeeName = employeeDetails.PName;
            midEvaluationDetailsViewModel.DesgName = employeeDetails.PDesgCode + " -  " + employeeDetails.PDesgName;
            midEvaluationDetailsViewModel.CostName = employeeDetails.PParent + " - " + employeeDetails.PCostName;
            midEvaluationDetailsViewModel.Doj = employeeDetails.PDoj;
            midEvaluationDetailsViewModel.EvaluationPeriod = employeeDetails.PDoj.AddMonths(3).ToString("dd-MMM-yyyy");
            midEvaluationDetailsViewModel.Location = employeeDetails.PCurrentOfficeLocation;
            midEvaluationDetailsViewModel.KeyId = id;

            MidEvaluationDetail result = await _midEvaluationDetailRepository.MidEvaluationDetails(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PKeyId = id
                });

            midEvaluationDetailsViewModel.Attendance = result.PAttendance;
            midEvaluationDetailsViewModel.Skill1 = result.PSkill1;
            midEvaluationDetailsViewModel.Skill1RatingText = result.PSkill1RatingText;
            midEvaluationDetailsViewModel.Skill1Remark = result.PSkill1Remark;
            midEvaluationDetailsViewModel.Skill2 = result.PSkill2;
            midEvaluationDetailsViewModel.Skill2RatingText = result.PSkill2RatingText;
            midEvaluationDetailsViewModel.Skill2Remark = result.PSkill2Remark;
            midEvaluationDetailsViewModel.Skill3 = result.PSkill3;
            midEvaluationDetailsViewModel.Skill3RatingText = result.PSkill3RatingText;
            midEvaluationDetailsViewModel.Skill3Remark = result.PSkill3Remark;
            midEvaluationDetailsViewModel.Skill4 = result.PSkill4;
            midEvaluationDetailsViewModel.Skill4RatingText = result.PSkill4RatingText;
            midEvaluationDetailsViewModel.Skill4Remark = result.PSkill4Remark;
            midEvaluationDetailsViewModel.Skill5 = result.PSkill5;
            midEvaluationDetailsViewModel.Skill5RatingText = result.PSkill5RatingText;
            midEvaluationDetailsViewModel.Que2RatingText = result.PQue2RatingText;
            midEvaluationDetailsViewModel.Que2Remark = result.PQue2Remark;
            midEvaluationDetailsViewModel.Que3RatingText = result.PQue3RatingText;
            midEvaluationDetailsViewModel.Que3Remark = result.PQue3Remark;
            midEvaluationDetailsViewModel.Que4RatingText = result.PQue4RatingText;
            midEvaluationDetailsViewModel.Que4Remark = result.PQue4Remark;
            midEvaluationDetailsViewModel.Que5RatingText = result.PQue5RatingText;
            midEvaluationDetailsViewModel.Que5Remark = result.PQue5Remark;
            midEvaluationDetailsViewModel.Que6RatingText = result.PQue6RatingText;
            midEvaluationDetailsViewModel.Que6Remark = result.PQue6Remark;
            midEvaluationDetailsViewModel.Observations = result.PObservations;

            return View("HODMidTermEvaluationDetails", midEvaluationDetailsViewModel);
        }

        #endregion HOD Mid Evaluation

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DigiFormHelper.ActionProgEvalSendToHr)]
        public async Task<IActionResult> MidTermEvaluationSendToHR(MidTermEvaluationEditViewModel midTermEvaluationEditViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var employeeDetails = await _commonEmployeeDetailsRepository.EmployeeDetailAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL { PEmpno = midTermEvaluationEditViewModel.Empno });

                    midTermEvaluationEditViewModel.EmployeeName = employeeDetails.PName;
                    midTermEvaluationEditViewModel.Desgcode = employeeDetails.PDesgCode;
                    midTermEvaluationEditViewModel.Parent = employeeDetails.PParent;
                    midTermEvaluationEditViewModel.Doj = employeeDetails.PDoj;
                    midTermEvaluationEditViewModel.Location = employeeDetails.PCurrentOfficeLocation;
                    midTermEvaluationEditViewModel.Isdeleted = 0;

                    Domain.Models.Common.DBProcMessageOutput result = await _midTermEvaluationRepository.MidTermEvaluationSendToHRAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PEmpno = midTermEvaluationEditViewModel.Empno,
                        PJsonObj = JsonConvert.SerializeObject(midTermEvaluationEditViewModel)
                    }
                    );
                    if (result.PMessageType == IsOk)
                    {
                        Notify("Success", "Procedure executed successfully", "", NotificationType.success);
                        return RedirectToAction("HODMidEvaluationPendingIndex");
                        //return RedirectToAction("HODMidTermEvaluationEdit", new { empno = midTermEvaluationEditViewModel.Empno, keyId = midTermEvaluationEditViewModel.KeyId });
                    }
                    else
                    {
                        Notify("Error", result.PMessageText, "", NotificationType.error);
                    }
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }

            return RedirectToAction("HODMidTermEvaluationEdit", new { empno = midTermEvaluationEditViewModel.Empno, keyId = midTermEvaluationEditViewModel.KeyId });
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DigiFormHelper.ActionProgEvalSendToHod)]
        public async Task<IActionResult> MidTermEvaluationSendToHOD(string keyId)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _midTermEvaluationRepository.MidTermEvaluationSendToHODAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PKeyId = keyId,
                    }
                    );
                    if (result.PMessageType == IsOk)
                    {
                        Notify("Success", "Procedure executed successfully", "", NotificationType.success);
                        return RedirectToAction("HRMidEvaluationPendingIndex");
                        //return RedirectToAction("HODMidTermEvaluationEdit", new { empno = midTermEvaluationEditViewModel.Empno, keyId = midTermEvaluationEditViewModel.KeyId });
                    }
                    else
                    {
                        Notify("Error", result.PMessageText, "", NotificationType.error);
                    }
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }

            return RedirectToAction("HRMidTermEvaluationEdit");
        }

        #region Cost code

        public IActionResult CostcodeChangeIndex()
        {
            return View();
        }

        #region Costcode Change Request

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DigiFormHelper.ActionTransferTargetCostCodeHoD)]
        public async Task<IActionResult> CostcodeChangeRequestIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterCostCodeChangeRequestIndex
            });

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            CostcodeChangeRequestIndexViewModel costcodeChangeRequestIndexViewModel = new()
            {
                FilterDataModel = filterDataModel
            };
            return View(costcodeChangeRequestIndexViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DigiFormHelper.ActionTransferTargetCostCodeHoD)]
        public async Task<JsonResult> GetListsCostcodeChangeRequestList(string paramJson)
        {
            DTResult<CostcodeChangeRequestDataTableList> result = new();
            int totalRow = 0;
            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            try
            {
                System.Collections.Generic.IEnumerable<CostcodeChangeRequestDataTableList> data = await _costcodeChangeRequestDataTableListRepository.CostcodeChangeRequestDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch,
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
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DigiFormHelper.ActionTransferTargetCostCodeHoD)]
        public async Task<IActionResult> CostcodeChangeRequestCreate()
        {
            CostcodeChangeRequestCreateViewModel costcodeChangeRequestCreateViewModel = new();

            //IEnumerable<DataField> costCodeList = await _selectTcmPLRepository.CostcodeDeptList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            //ViewData["CostCodeList"] = new SelectList(costCodeList, "DataValueField", "DataTextField");

            IEnumerable<DataField> employeeList = await _selectTcmPLRepository.CostcodeEmployeeList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["EmployeeList"] = new SelectList(employeeList, "DataValueField", "DataTextField");

            IEnumerable<DataField> siteList = await _selectTcmPLRepository.CostcodeSiteList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["SiteList"] = new SelectList(siteList, "DataValueField", "DataTextField");

            return PartialView("_ModalCostcodeChangeRequestCreatePartial", costcodeChangeRequestCreateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DigiFormHelper.ActionTransferTargetCostCodeHoD)]
        public async Task<IActionResult> CostcodeChangeRequestCreate([FromForm] CostcodeChangeRequestCreateViewModel costcodeChangeRequestCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    if (costcodeChangeRequestCreateViewModel.BtnName == "SubmitForApproval")
                    {
                        costcodeChangeRequestCreateViewModel.Status = Pending;
                    }
                    else
                    {
                        costcodeChangeRequestCreateViewModel.Status = saveAsDraft;
                    }
                    Domain.Models.Common.DBProcMessageOutput result = await _costcodeChangeRequestRepository.CostcodeChangeRequestCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PTransferType = costcodeChangeRequestCreateViewModel.TransferType,
                            PEmpNo = costcodeChangeRequestCreateViewModel.EmpNo,
                            PCurrentCostcode = costcodeChangeRequestCreateViewModel.CurrentCostcode,
                            PTargetCostcode = costcodeChangeRequestCreateViewModel.TargetCostcode,
                            PTransferDate = costcodeChangeRequestCreateViewModel.TransferDate,
                            PTransferEndDate = costcodeChangeRequestCreateViewModel.TransferEndDate,
                            PRemarks = costcodeChangeRequestCreateViewModel.Remarks,
                            PStatus = costcodeChangeRequestCreateViewModel.Status,
                            PSiteCode = costcodeChangeRequestCreateViewModel.SiteCode
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

            IEnumerable<DataField> costCodeList = await _selectTcmPLRepository.HRMISDeptList(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            ViewData["CostCodeList"] = new SelectList(costCodeList, "DataValueField", "DataTextField", costcodeChangeRequestCreateViewModel.TargetCostcode);

            IEnumerable<DataField> employeeList = await _selectTcmPLRepository.HRMISEmployeeList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["EmployeeList"] = new SelectList(employeeList, "DataValueField", "DataTextField", costcodeChangeRequestCreateViewModel.EmpNo);

            IEnumerable<DataField> siteList = await _selectTcmPLRepository.CostcodeSiteList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["SiteList"] = new SelectList(siteList, "DataValueField", "DataTextField", costcodeChangeRequestCreateViewModel.SiteCode);

            return PartialView("_ModalCostcodeChangeRequestCreatePartial", costcodeChangeRequestCreateViewModel);
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DigiFormHelper.ActionTransferTargetCostCodeHoD)]
        public async Task<IActionResult> CostcodeChangeRequestEdit(string id)
        {
            CostcodeChangeRequestEditViewModel costcodeChangeRequestEditViewModel = new();

            if (id == null)
            {
                return NotFound();
            }

            var result = await _costcodeChangeRequestDetailRepository.CostcodeChangeRequestDetail(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PKeyId = id
                });

            if (result.PMessageType == IsOk)
            {
                costcodeChangeRequestEditViewModel.KeyId = id;
                costcodeChangeRequestEditViewModel.TransferType = result.PTransferTypeVal;
                costcodeChangeRequestEditViewModel.EmpNo = result.PEmpNo;
                costcodeChangeRequestEditViewModel.CurrentCostcode = result.PCurrentCostcodeVal;
                costcodeChangeRequestEditViewModel.CurrentCostcodeName = result.PCurrentCostcodeVal + " - " + result.PCurrentCostcodeText;
                costcodeChangeRequestEditViewModel.TargetCostcode = result.PTargetCostcodeVal;
                costcodeChangeRequestEditViewModel.TransferDate = result.PTransferDate;
                costcodeChangeRequestEditViewModel.TransferEndDate = result.PTransferEndDate;
                costcodeChangeRequestEditViewModel.Remarks = result.PRemarks;
                costcodeChangeRequestEditViewModel.SiteCode = result.PSiteCode;
            }

            IEnumerable<DataField> costCodeList = await _selectTcmPLRepository.HRMISDeptList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["CostCodeList"] = new SelectList(costCodeList, "DataValueField", "DataTextField", costcodeChangeRequestEditViewModel.CurrentCostcode);

            IEnumerable<DataField> employeeList = await _selectTcmPLRepository.HRMISEmployeeList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["EmployeeList"] = new SelectList(employeeList, "DataValueField", "DataTextField", costcodeChangeRequestEditViewModel.EmpNo);

            IEnumerable<DataField> siteList = await _selectTcmPLRepository.CostcodeSiteList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["SiteList"] = new SelectList(siteList, "DataValueField", "DataTextField", costcodeChangeRequestEditViewModel.SiteCode);

            return PartialView("_ModalCostcodeChangeRequestUpdatePartial", costcodeChangeRequestEditViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DigiFormHelper.ActionTransferTargetCostCodeHoD)]
        public async Task<IActionResult> CostcodeChangeRequestEdit([FromForm] CostcodeChangeRequestEditViewModel costcodeChangeRequestEditViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    if (costcodeChangeRequestEditViewModel.BtnName == "SubmitForApproval")
                    {
                        costcodeChangeRequestEditViewModel.Status = Pending;
                    }
                    else
                    {
                        costcodeChangeRequestEditViewModel.Status = saveAsDraft;
                    }
                    Domain.Models.Common.DBProcMessageOutput result = await _costcodeChangeRequestRepository.CostcodeChangeRequestEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PKeyId = costcodeChangeRequestEditViewModel.KeyId,
                            PTransferType = costcodeChangeRequestEditViewModel.TransferType,
                            PEmpNo = costcodeChangeRequestEditViewModel.EmpNo,
                            PCurrentCostcode = costcodeChangeRequestEditViewModel.CurrentCostcode,
                            PTargetCostcode = costcodeChangeRequestEditViewModel.TargetCostcode,
                            PTransferDate = costcodeChangeRequestEditViewModel.TransferDate,
                            PTransferEndDate = costcodeChangeRequestEditViewModel.TransferEndDate,
                            PRemarks = costcodeChangeRequestEditViewModel.Remarks,
                            PStatus = costcodeChangeRequestEditViewModel.Status,
                            PSiteCode = costcodeChangeRequestEditViewModel.SiteCode,
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

            IEnumerable<DataField> costCodeList = await _selectTcmPLRepository.HRMISDeptList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["CostCodeList"] = new SelectList(costCodeList, "DataValueField", "DataTextField", costcodeChangeRequestEditViewModel.TargetCostcode);

            IEnumerable<DataField> employeeList = await _selectTcmPLRepository.HRMISEmployeeList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["EmployeeList"] = new SelectList(employeeList, "DataValueField", "DataTextField", costcodeChangeRequestEditViewModel.EmpNo);

            IEnumerable<DataField> siteList = await _selectTcmPLRepository.CostcodeSiteList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["SiteList"] = new SelectList(siteList, "DataValueField", "DataTextField", costcodeChangeRequestEditViewModel.SiteCode);

            return PartialView("_ModalCostcodeChangeRequestEditPartial", costcodeChangeRequestEditViewModel);
        }

        #endregion Costcode Change Request

        #region HOD Approvals Requests

        [Authorize]
        public async Task<IActionResult> CostcodeChangeRequestHODApprovalIndex()
        {
            if (!(
                    CurrentUserIdentity.ProfileActions.Any(pa => pa.ActionId == DigiFormHelper.ActionTransferTargetCostCodeHoD) ||
                    CurrentUserIdentity.ProfileActions.Any(pa => pa.ActionId == DigiFormHelper.ActionTransferCostCodeHR)
                ))
            {
                Forbid();
            }

            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterCostCodeChangeRequestIndex
            });

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            CostcodeChangeRequestIndexViewModel costcodeChangeRequestIndexViewModel = new()
            {
                FilterDataModel = filterDataModel
            };
            return View(costcodeChangeRequestIndexViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [Authorize]
        public async Task<JsonResult> GetListsHodApprovalsRequestsList(string paramJson)
        {
            if (!(
                    CurrentUserIdentity.ProfileActions.Any(pa => pa.ActionId == DigiFormHelper.ActionTransferTargetCostCodeHoD) ||
                    CurrentUserIdentity.ProfileActions.Any(pa => pa.ActionId == DigiFormHelper.ActionTransferCostCodeHR)
                ))
            {
                Forbid();
            }

            DTResult<CostcodeChangeRequestDataTableList> result = new();
            int totalRow = 0;
            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            try
            {
                System.Collections.Generic.IEnumerable<CostcodeChangeRequestDataTableList> data = await _costcodeChangeRequestDataTableListRepository.HodApprovalsRequestsDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch,
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
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DigiFormHelper.ActionTransferTargetCostCodeHoD)]
        public async Task<IActionResult> CostcodeChangeRequestHODApproval(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var result = await _costcodeChangeRequestDetailRepository.CostcodeChangeRequestDetail(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PKeyId = id
                });
            EmployeeDetails employeeDetails = new();
            CostcodeChangeRequestDetailsViewModel costcodeChangeRequestDetailsViewModel = new();

            if (result.PMessageType == IsOk)
            {
                costcodeChangeRequestDetailsViewModel.KeyId = id;
                costcodeChangeRequestDetailsViewModel.TransferVal = result.PTransferTypeVal;
                costcodeChangeRequestDetailsViewModel.TransferType = result.PTransferTypeText;
                costcodeChangeRequestDetailsViewModel.Employee = result.PEmpNo + "-" + result.PEmpName;
                costcodeChangeRequestDetailsViewModel.CurrentCostCode = result.PCurrentCostcodeVal + " - " + result.PCurrentCostcodeText;

                costcodeChangeRequestDetailsViewModel.TransferDate = result.PTransferDate;
                costcodeChangeRequestDetailsViewModel.TransferEndDate = result.PTransferEndDate;
                costcodeChangeRequestDetailsViewModel.Remarks = result.PRemarks;

                costcodeChangeRequestDetailsViewModel.JobdisciplineCode = result.PJobdisciplineCode;
                costcodeChangeRequestDetailsViewModel.Jobdiscipline = result.PJobdiscipline;
                costcodeChangeRequestDetailsViewModel.JobGroup = result.PJobGroup;
                costcodeChangeRequestDetailsViewModel.JobGroupCode = result.PJobGroupCode;
                costcodeChangeRequestDetailsViewModel.Jobtitle = result.PJobtitle;
                costcodeChangeRequestDetailsViewModel.JobtitleCode = result.PJobtitleCode;
                costcodeChangeRequestDetailsViewModel.SiteCode = result.PSiteCode;
                costcodeChangeRequestDetailsViewModel.SiteName = result.PSiteName;
                costcodeChangeRequestDetailsViewModel.SiteLocation = result.PSiteLocation;

                employeeDetails = await _commonEmployeeDetailsRepository.EmployeeDetailAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL { PEmpno = result.PEmpNo });
                if (employeeDetails != null)
                {
                    costcodeChangeRequestDetailsViewModel.Grade = employeeDetails.PGrade;
                    costcodeChangeRequestDetailsViewModel.CurrentDesignation = employeeDetails.PDesgCode + " - " + employeeDetails.PDesgName;
                    costcodeChangeRequestDetailsViewModel.CurrentJobTitle = employeeDetails.PJobTitle;
                }
            }

            if (result.PTransferTypeVal == 1)
            {
                IEnumerable<DataField> costCodeList = await _selectTcmPLRepository.HRMISDeptDeputationList(BaseSpTcmPLGet(), new ParameterSpTcmPL { PCostcode = result.PTargetCostcodeVal });
                ViewData["CostCodeList"] = new SelectList(costCodeList, "DataValueField", "DataTextField", result.PTargetCostcodeVal);
                if (costCodeList.Count() > 0)
                    ViewData["DeputationDept"] = "YES";
                else
                {
                    costcodeChangeRequestDetailsViewModel.TargetCostCode = result.PTargetCostcodeVal + " - " + result.PTargetCostcodeText;
                    ViewData["DeputationDept"] = "NO";
                }
            }
            else
                costcodeChangeRequestDetailsViewModel.TargetCostCode = result.PTargetCostcodeVal + " - " + result.PTargetCostcodeText;

            IEnumerable<DataField> siteList = await _selectTcmPLRepository.CostcodeSiteList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["SiteList"] = new SelectList(siteList, "DataValueField", "DataTextField", costcodeChangeRequestDetailsViewModel.SiteCode);

            return PartialView("_ModalCostcodeChangeRequestHODApprovalPartial", costcodeChangeRequestDetailsViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DigiFormHelper.ActionTransferTargetCostCodeHoD)]
        public async Task<IActionResult> CostcodeChangeRequestHODApproval(CostcodeChangeRequestDetailsViewModel costcodeChangeRequestDetailsViewModel)
        {
            try
            {
                int status;
                string ApprlActionId = DigiFormHelper.ActionTransferTargetCostCodeHoD;
                string ApprovalAction;
                if (costcodeChangeRequestDetailsViewModel.KeyId == null)
                {
                    return NotFound();
                }
                if (costcodeChangeRequestDetailsViewModel.BtnName == "RejectApproval")
                {
                    status = Rejected;
                    ApprovalAction = "KO";
                }
                else
                {
                    status = Pending;
                    ApprovalAction = "OK";
                }

                Domain.Models.Common.DBProcMessageOutput result = await _costcodeChangeRequestRepository.CostcodeChangeRequestHoDApprovalAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PKeyId = costcodeChangeRequestDetailsViewModel.KeyId,
                        PApprlActionId = ApprlActionId,
                        PApprovalAction = ApprovalAction,
                        PStatus = status,
                        PTargetCostcode = costcodeChangeRequestDetailsViewModel.TargetCostCode,
                        PApprovalRemarks = costcodeChangeRequestDetailsViewModel.ApprovalRemarks,
                        PTransferDate = costcodeChangeRequestDetailsViewModel.TransferDate,
                        PTransferEndDate = costcodeChangeRequestDetailsViewModel.TransferEndDate,
                        PSiteCode = costcodeChangeRequestDetailsViewModel.SiteCode
                    });
                return result.PMessageType == NotOk
                         ? throw new Exception(result.PMessageText.Replace("-", " "))
                         : (IActionResult)Json(new { success = true, response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        public async Task<IActionResult> CostcodeChangeRequestHodApprovalsHistoryIndex()
        {
            if (!(
                    CurrentUserIdentity.ProfileActions.Any(pa => pa.ActionId == DigiFormHelper.ActionTransferTargetCostCodeHoD) ||
                    CurrentUserIdentity.ProfileActions.Any(pa => pa.ActionId == DigiFormHelper.ActionTransferCostCodeHR) ||
                    CurrentUserIdentity.ProfileActions.Any(pa => pa.ActionId == DigiFormHelper.ActionTransferCostCodeHRHoD)
                ))
            {
                Forbid();
            }

            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterHodApprovalsHistoryIndex
            });

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            CostcodeChangeRequestIndexViewModel costcodeChangeRequestIndexViewModel = new()
            {
                FilterDataModel = filterDataModel
            };
            return View(costcodeChangeRequestIndexViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsHodHistoryApprovalsRequestsList(string paramJson)
        {
            if (!(
                    CurrentUserIdentity.ProfileActions.Any(pa => pa.ActionId == DigiFormHelper.ActionTransferTargetCostCodeHoD) ||
                    CurrentUserIdentity.ProfileActions.Any(pa => pa.ActionId == DigiFormHelper.ActionTransferCostCodeHR) ||
                    CurrentUserIdentity.ProfileActions.Any(pa => pa.ActionId == DigiFormHelper.ActionTransferCostCodeHRHoD)
                ))
            {
                Forbid();
            }


            DTResult<CostcodeChangeRequestDataTableList> result = new();
            int totalRow = 0;
            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            try
            {
                System.Collections.Generic.IEnumerable<CostcodeChangeRequestDataTableList> data = await _costcodeChangeRequestDataTableListRepository.HodHistoryApprovalsRequestsDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch,
                        PCurrentCostcode = param.CurrentCostcode,
                        PTargetCostcode = param.TargetCostcode,
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

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DigiFormHelper.ActionTransferTargetCostCodeHoD)]
        public async Task<IActionResult> HodTransferEmployeesIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterHodTransferEmployeesIndex
            });

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            CostcodeChangeRequestIndexViewModel costcodeChangeRequestIndexViewModel = new()
            {
                FilterDataModel = filterDataModel
            };
            return View(costcodeChangeRequestIndexViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DigiFormHelper.ActionTransferTargetCostCodeHoD)]
        public async Task<JsonResult> GetListsHodTransferEmployeesList(string paramJson)
        {
            DTResult<CostcodeChangeRequestDataTableList> result = new();
            int totalRow = 0;
            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            try
            {
                System.Collections.Generic.IEnumerable<CostcodeChangeRequestDataTableList> data = await _costcodeChangeRequestDataTableListRepository.HodTransferEmployeesDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch,
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
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DigiFormHelper.ActionTransferTargetCostCodeHoD)]
        public async Task<IActionResult> CostcodeChangeRequestHODPostApproval(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var result = await _costcodeChangeRequestDetailRepository.CostcodeChangeRequestDetail(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PKeyId = id
                });

            var data = await _approvalDetailsDataTableListRepository.ExtensionDetailsDataTableListAsync(
                   BaseSpTcmPLGet(),
                   new ParameterSpTcmPL
                   {
                       PKeyId = id
                   }
               );

            EmployeeDetails employeeDetails = new();

            CostcodeChangeRequestDetailsViewModel costcodeChangeRequestDetailsViewModel = new();

            if (result.PMessageType == IsOk)
            {
                costcodeChangeRequestDetailsViewModel.KeyId = id;
                costcodeChangeRequestDetailsViewModel.TransferVal = result.PTransferTypeVal;
                costcodeChangeRequestDetailsViewModel.TransferType = result.PTransferTypeText;
                costcodeChangeRequestDetailsViewModel.Employee = result.PEmpNo + "-" + result.PEmpName;
                costcodeChangeRequestDetailsViewModel.CurrentCostCode = result.PCurrentCostcodeVal + " - " + result.PCurrentCostcodeText;
                costcodeChangeRequestDetailsViewModel.TargetCostCode = result.PTargetCostcodeVal + " - " + result.PTargetCostcodeText;
                costcodeChangeRequestDetailsViewModel.TransferDate = result.PTransferDate;
                costcodeChangeRequestDetailsViewModel.TransferEndDate = result.PTransferEndDate;
                costcodeChangeRequestDetailsViewModel.Remarks = result.PRemarks;

                costcodeChangeRequestDetailsViewModel.JobdisciplineCode = result.PJobdisciplineCode;
                costcodeChangeRequestDetailsViewModel.Jobdiscipline = result.PJobdiscipline;
                costcodeChangeRequestDetailsViewModel.JobGroup = result.PJobGroup;
                costcodeChangeRequestDetailsViewModel.JobGroupCode = result.PJobGroupCode;
                costcodeChangeRequestDetailsViewModel.Jobtitle = result.PJobtitle;
                costcodeChangeRequestDetailsViewModel.JobtitleCode = result.PJobtitleCode;
                costcodeChangeRequestDetailsViewModel.TargetHodRemarks = result.PTargetHodRemarks;
                costcodeChangeRequestDetailsViewModel.HrRemarks = result.PHrRemarks;
                costcodeChangeRequestDetailsViewModel.SiteName = result.PSiteName;
                costcodeChangeRequestDetailsViewModel.SiteLocation = result.PSiteLocation;

                employeeDetails = await _commonEmployeeDetailsRepository.EmployeeDetailAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL { PEmpno = result.PEmpNo });
                if (employeeDetails != null)
                {
                    costcodeChangeRequestDetailsViewModel.Grade = employeeDetails.PGrade;
                    costcodeChangeRequestDetailsViewModel.CurrentDesignation = employeeDetails.PDesgCode + " - " + employeeDetails.PDesgName;
                    costcodeChangeRequestDetailsViewModel.CurrentJobTitle = employeeDetails.PJobTitle;
                }

                foreach (var item in data.Select(s => new { s.TransferEndDate, s.Remarks, s.ModifiedOn, s.ModifiedByName, s.ModifiedBy }))
                {
                    costcodeChangeRequestDetailsViewModel.ExtensionDetailsList.Add(
                       new ExtensionDetails
                       {
                           TransferEndDate = item.TransferEndDate,
                           Remarks = item.Remarks,
                           ModifiedOn = item.ModifiedOn,
                           ModifiedByName = item.ModifiedByName,
                           ModifiedBy = item.ModifiedBy
                       });
                };
            }

            return PartialView("_ModalCostcodeChangeRequestHODPostApprovalPartial", costcodeChangeRequestDetailsViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DigiFormHelper.ActionTransferTargetCostCodeHoD)]
        public async Task<IActionResult> CostcodeChangeRequestHODPostApproval(CostcodeChangeRequestDetailsViewModel costcodeChangeRequestDetailsViewModel)
        {
            try
            {
                if (costcodeChangeRequestDetailsViewModel.KeyId == null)
                {
                    return NotFound();
                }

                Domain.Models.Common.DBProcMessageOutput result = await _costcodeChangeRequestRepository.CostcodeChangeRequestHODPostApprovalAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PKeyId = costcodeChangeRequestDetailsViewModel.KeyId,
                        PApprovalRemarks = costcodeChangeRequestDetailsViewModel.ApprovalRemarks,
                        PTransferEndDate = costcodeChangeRequestDetailsViewModel.TransferEndDate
                    });
                return result.PMessageType == NotOk
                         ? throw new Exception(result.PMessageText.Replace("-", " "))
                         : (IActionResult)Json(new { success = true, response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }
        #endregion HOD Approvals Requests

        #region HR Approvals Requests

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DigiFormHelper.ActionTransferCostCodeHR)]
        public async Task<IActionResult> CostcodeChangeRequestHRApprovalIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterCostCodeChangeRequestIndex
            });

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            CostcodeChangeRequestIndexViewModel costcodeChangeRequestIndexViewModel = new()
            {
                FilterDataModel = filterDataModel
            };
            return View(costcodeChangeRequestIndexViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DigiFormHelper.ActionTransferCostCodeHR)]
        public async Task<JsonResult> GetListsHRApprovalsRequestsList(string paramJson)
        {
            DTResult<CostcodeChangeRequestDataTableList> result = new();
            int totalRow = 0;
            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            try
            {
                System.Collections.Generic.IEnumerable<CostcodeChangeRequestDataTableList> data = await _costcodeChangeRequestDataTableListRepository.HRApprovalsRequestsDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch,
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
        public async Task<IActionResult> CostcodeChangeRequestHRApproval(string id)
        {
            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.DigiForm.DigiFormHelper.ActionTransferCostCodeHR) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.DigiForm.DigiFormHelper.ActionTransferCostCodeHRHoD))
            {

                if (id == null)
                {
                    return NotFound();
                }

                var keyId = id.Split("!-!")[0];
                var actionId = id.Split("!-!")[1];

                var result = await _costcodeChangeRequestDetailRepository.CostcodeChangeRequestDetail(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PKeyId = keyId
                    });

                CostcodeChangeRequestDetailsViewModel costcodeChangeRequestDetailsViewModel = new();
                EmployeeDetails employeeDetails = new();
                if (result.PMessageType == IsOk)
                {
                    costcodeChangeRequestDetailsViewModel.KeyId = keyId;
                    costcodeChangeRequestDetailsViewModel.ActionId = actionId;
                    costcodeChangeRequestDetailsViewModel.TransferType = result.PTransferTypeText;
                    costcodeChangeRequestDetailsViewModel.TransferVal = result.PTransferTypeVal;
                    costcodeChangeRequestDetailsViewModel.Employee = result.PEmpNo + " - " + result.PEmpName;
                    costcodeChangeRequestDetailsViewModel.CurrentCostCode = result.PCurrentCostcodeVal + " - " + result.PCurrentCostcodeText;
                    costcodeChangeRequestDetailsViewModel.CurrentCostCodeVal = result.PCurrentCostcodeVal;
                    costcodeChangeRequestDetailsViewModel.TargetCostCodeVal = result.PTargetCostcodeVal;
                    costcodeChangeRequestDetailsViewModel.TargetCostCode = result.PTargetCostcodeVal + " - " + result.PTargetCostcodeText;
                    costcodeChangeRequestDetailsViewModel.TransferDate = result.PTransferDate;
                    costcodeChangeRequestDetailsViewModel.TransferEndDate = result.PTransferEndDate;
                    costcodeChangeRequestDetailsViewModel.Remarks = result.PRemarks;
                    costcodeChangeRequestDetailsViewModel.SiteCode = result.PSiteCode;
                    costcodeChangeRequestDetailsViewModel.DesgCode = result.PDesgcodeVal;
                    costcodeChangeRequestDetailsViewModel.JobdisciplineCode = result.PJobdisciplineCode;
                    costcodeChangeRequestDetailsViewModel.Jobdiscipline = result.PJobdiscipline;
                    costcodeChangeRequestDetailsViewModel.JobGroup = result.PJobGroup;
                    costcodeChangeRequestDetailsViewModel.JobGroupCode = result.PJobGroupCode;
                    costcodeChangeRequestDetailsViewModel.Jobtitle = result.PJobtitle;
                    costcodeChangeRequestDetailsViewModel.JobtitleCode = result.PJobtitleCode;
                    costcodeChangeRequestDetailsViewModel.EffectiveTransferDate = result.PEffectiveTransferDate ?? result.PTransferDate;
                    costcodeChangeRequestDetailsViewModel.TargetHodRemarks = result.PTargetHodRemarks;
                    costcodeChangeRequestDetailsViewModel.HrRemarks = result.PHrRemarks;
                    costcodeChangeRequestDetailsViewModel.DesgcodeNew = result.PDesgcodeNew;
                    costcodeChangeRequestDetailsViewModel.JobGroupCodeNew = result.PJobGroupCodeNew;
                    costcodeChangeRequestDetailsViewModel.JobdisciplineCodeNew = result.PJobdisciplineCodeNew;
                    costcodeChangeRequestDetailsViewModel.JobtitleCodeNew = result.PJobtitleCodeNew;
                    costcodeChangeRequestDetailsViewModel.DesgNew = result.PDesgNew;
                    costcodeChangeRequestDetailsViewModel.JobGroupNew = result.PJobGroupNew;
                    costcodeChangeRequestDetailsViewModel.JobdisciplineNew = result.PJobdisciplineNew;
                    costcodeChangeRequestDetailsViewModel.JobtitleNew = result.PJobtitleNew;
                    costcodeChangeRequestDetailsViewModel.SiteName = result.PSiteName;
                    costcodeChangeRequestDetailsViewModel.SiteLocation = result.PSiteLocation;

                    employeeDetails = await _commonEmployeeDetailsRepository.EmployeeDetailAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL { PEmpno = result.PEmpNo });
                    if (employeeDetails != null)
                    {
                        costcodeChangeRequestDetailsViewModel.Grade = employeeDetails.PGrade;
                        costcodeChangeRequestDetailsViewModel.CurrentDesignation = employeeDetails.PDesgCode + " - " + employeeDetails.PDesgName;
                        costcodeChangeRequestDetailsViewModel.CurrentJobTitle = employeeDetails.PJobTitle;
                    }
                }
                IEnumerable<DataField> costCodeList = await _selectTcmPLRepository.HRMISDeptList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
                ViewData["CostCodeList"] = new SelectList(costCodeList, "DataValueField", "DataTextField", costcodeChangeRequestDetailsViewModel.TargetCostCode);

                var designationList = await _selectRepository.DesignationSelectListCacheAsync();
                ViewData["DesgList"] = new SelectList(designationList, "DataValueField", "DataTextField", costcodeChangeRequestDetailsViewModel.DesgCode);

                IEnumerable<DataField> siteList = await _selectTcmPLRepository.CostcodeSiteList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
                ViewData["SiteList"] = new SelectList(siteList, "DataValueField", "DataTextField", costcodeChangeRequestDetailsViewModel.SiteCode);

                IEnumerable<DataField> jobGroupList = await _selectTcmPLRepository.JobGroupListAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());
                ViewData["JobGroupList"] = new SelectList(jobGroupList, "DataValueField", "DataTextField", costcodeChangeRequestDetailsViewModel.JobGroupCode);

                IEnumerable<DataField> jobDisciplineList = await _selectTcmPLRepository.JobDisciplineListAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());
                ViewData["JobDisciplineList"] = new SelectList(jobDisciplineList, "DataValueField", "DataTextField", costcodeChangeRequestDetailsViewModel.JobdisciplineCode);

                IEnumerable<DataField> jobTitleList = await _selectTcmPLRepository.JobTitleListAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());
                ViewData["JobTitleList"] = new SelectList(jobTitleList, "DataValueField", "DataTextField", costcodeChangeRequestDetailsViewModel.JobtitleCode);

                return PartialView("_ModalCostcodeChangeRequestHRApprovalPartial", costcodeChangeRequestDetailsViewModel);
            }
            else
                return NotFound();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> CostcodeChangeRequestHRApproval(CostcodeChangeRequestDetailsViewModel costcodeChangeRequestDetailsViewModel)
        {
            try
            {
                if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.DigiForm.DigiFormHelper.ActionTransferCostCodeHR) ||
                    CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.DigiForm.DigiFormHelper.ActionTransferCostCodeHRHoD))
                {
                    int status;
                    string ApprovalAction;
                    string ApprlActionId = costcodeChangeRequestDetailsViewModel.ActionId;
                    if (costcodeChangeRequestDetailsViewModel.BtnName == "RejectApproval")
                    {
                        status = Rejected;
                        ApprovalAction = "KO";
                    }
                    else
                    {
                        if (costcodeChangeRequestDetailsViewModel.TransferVal == 0 && (costcodeChangeRequestDetailsViewModel.EffectiveTransferDate == null))
                        {
                            throw new Exception("Please Enter All Data.");
                        }
                        else if (costcodeChangeRequestDetailsViewModel.TransferVal == 1 && (costcodeChangeRequestDetailsViewModel.EffectiveTransferDate == null || costcodeChangeRequestDetailsViewModel.SiteCode == null))
                        {
                            throw new Exception("Please Enter All Data.");
                        }
                        status = costcodeChangeRequestDetailsViewModel.ActionId == ActionPayRollApprover && costcodeChangeRequestDetailsViewModel.TransferVal == 0 ? Pending : Approved;
                        ApprovalAction = "OK";
                    }
                    //if (costcodeChangeRequestDetailsViewModel.TransferVal == 2)
                    //{
                    //    costcodeChangeRequestDetailsViewModel.TargetCostCodeVal = costcodeChangeRequestDetailsViewModel.CurrentCostCodeVal;
                    //}
                    Domain.Models.Common.DBProcMessageOutput result = await _costcodeChangeRequestRepository.CostcodeChangeRequestHRApprovalAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PKeyId = costcodeChangeRequestDetailsViewModel.KeyId,
                            PStatus = status,
                            PTargetCostcode = costcodeChangeRequestDetailsViewModel.TargetCostCodeVal,
                            PEffectiveTransferDate = costcodeChangeRequestDetailsViewModel.EffectiveTransferDate,
                            PDesgcode = costcodeChangeRequestDetailsViewModel.DesgcodeNew ?? costcodeChangeRequestDetailsViewModel.DesgCode,
                            PApprlActionId = ApprlActionId,
                            PApprovalAction = ApprovalAction,
                            PSiteCode = costcodeChangeRequestDetailsViewModel.SiteCode,
                            PApprovalRemarks = costcodeChangeRequestDetailsViewModel.ApprovalRemarks,
                            PTransferEndDate = costcodeChangeRequestDetailsViewModel.TransferEndDate,
                            PJobGroupCode = costcodeChangeRequestDetailsViewModel.JobGroupCodeNew ?? costcodeChangeRequestDetailsViewModel.JobGroupCode,
                            PJobdisciplineCode = costcodeChangeRequestDetailsViewModel.JobdisciplineCodeNew ?? costcodeChangeRequestDetailsViewModel.JobdisciplineCode,
                            PJobtitleCode = costcodeChangeRequestDetailsViewModel.JobtitleCodeNew ?? costcodeChangeRequestDetailsViewModel.JobtitleCode
                        });
                    return result.PMessageType == NotOk
                             ? throw new Exception(result.PMessageText.Replace("-", " "))
                             : (IActionResult)Json(new { success = true, response = result.PMessageText });
                }
                else
                    return NotFound();
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DigiFormHelper.ActionTransferCostCodeHR)]
        public async Task<IActionResult> CostcodeChangeRequestHrApprovalsHistoryIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterHrApprovalsHistoryIndex
            });

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            CostcodeChangeRequestIndexViewModel costcodeChangeRequestIndexViewModel = new()
            {
                FilterDataModel = filterDataModel
            };
            return View(costcodeChangeRequestIndexViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DigiFormHelper.ActionTransferCostCodeHR)]
        public async Task<JsonResult> GetListsHrHistoryApprovalsRequestsList(string paramJson)
        {
            DTResult<CostcodeChangeRequestDataTableList> result = new();
            int totalRow = 0;
            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            try
            {
                System.Collections.Generic.IEnumerable<CostcodeChangeRequestDataTableList> data = await _costcodeChangeRequestDataTableListRepository.HrHistoryApprovalsRequestsDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch,
                        PCurrentCostcode = param.CurrentCostcode,
                        PTargetCostcode = param.TargetCostcode,
                        PStatus = param.Status,
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

        public async Task<IActionResult> HRApprovedApprovalsIndex()
        {
            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.DigiForm.DigiFormHelper.ActionTransferCostCodeHR) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.DigiForm.DigiFormHelper.ActionTransferCostCodeHRHoD) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.DigiForm.DigiFormHelper.ActionTransferCostCodeView))
            {
                Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
                {
                    PModuleName = CurrentUserIdentity.CurrentModule,
                    PMetaId = CurrentUserIdentity.MetaId,
                    PPersonId = CurrentUserIdentity.EmployeeId,
                    PMvcActionName = ConstFilterHrApprovedApprovalsIndex
                });

                FilterDataModel filterDataModel = new();

                if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                {
                    filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
                }

                CostcodeChangeRequestIndexViewModel costcodeChangeRequestIndexViewModel = new()
                {
                    FilterDataModel = filterDataModel
                };
                return View(costcodeChangeRequestIndexViewModel);
            }
            else
                return NotFound();
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsHrApprovedApprovalsList(string paramJson)
        {
            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.DigiForm.DigiFormHelper.ActionTransferCostCodeHR) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.DigiForm.DigiFormHelper.ActionTransferCostCodeHRHoD) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.DigiForm.DigiFormHelper.ActionTransferCostCodeView))
            {
                DTResult<CostcodeChangeRequestDataTableList> result = new();
                int totalRow = 0;
                DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

                try
                {
                    System.Collections.Generic.IEnumerable<CostcodeChangeRequestDataTableList> data = await _costcodeChangeRequestDataTableListRepository.HrApprovedApprovalsRequestsDataTableListAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PGenericSearch = param.GenericSearch,
                            PCurrentCostcode = param.CurrentCostcode,
                            PTargetCostcode = param.TargetCostcode,
                            PStatus = param.Status,
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
            else
                return Json(null);
        }

        public async Task<IActionResult> HrTransferCostcodeExcelDownload()
        {
            var timeStamp = DateTime.Now.ToFileTime();

            string fileName = "Transfer Costcode Approvals_" + timeStamp.ToString();
            string reportTitle = "Transfer Costcode Approvals";
            string sheetName = "Transfer Costcode Approvals";

            IEnumerable<CostcodeChangeRequestDataTableList> data = await _costcodeChangeRequestDataTableListRepository.HrTransferCostcodeExcelDataTableListForExcelAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                });

            if (data == null) { return NotFound(); }

            var json = JsonConvert.SerializeObject(data);

            IEnumerable<HrTransferCostcodeDataTableListExcel> excelData = JsonConvert.DeserializeObject<IEnumerable<HrTransferCostcodeDataTableListExcel>>(json);

            var byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, reportTitle, sheetName);

            var mimeType = MimeTypeMap.GetMimeType("xlsx");

            FileContentResult file = File(byteContent, mimeType, fileName);

            return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
        }

        public async Task<IActionResult> HrTransferEmployeesIndex()
        {
            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.DigiForm.DigiFormHelper.ActionTransferCostCodeHR) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.DigiForm.DigiFormHelper.ActionTransferCostCodeHRHoD) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.DigiForm.DigiFormHelper.ActionTransferCostCodeView))
            {
                Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
                {
                    PModuleName = CurrentUserIdentity.CurrentModule,
                    PMetaId = CurrentUserIdentity.MetaId,
                    PPersonId = CurrentUserIdentity.EmployeeId,
                    PMvcActionName = ConstFilterHrTransferEmployeesIndex
                });

                FilterDataModel filterDataModel = new();

                if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                {
                    filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
                }

                CostcodeChangeRequestIndexViewModel costcodeChangeRequestIndexViewModel = new()
                {
                    FilterDataModel = filterDataModel
                };
                return View(costcodeChangeRequestIndexViewModel);
            }
            else
                return NotFound();
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsHrTransferEmployeesList(string paramJson)
        {
            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.DigiForm.DigiFormHelper.ActionTransferCostCodeHR) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.DigiForm.DigiFormHelper.ActionTransferCostCodeHRHoD) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.DigiForm.DigiFormHelper.ActionTransferCostCodeView))
            {
                DTResult<CostcodeChangeRequestDataTableList> result = new();
                int totalRow = 0;
                DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

                try
                {
                    System.Collections.Generic.IEnumerable<CostcodeChangeRequestDataTableList> data = await _costcodeChangeRequestDataTableListRepository.HrTransferEmployeesDataTableListAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PGenericSearch = param.GenericSearch,
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
            else
                return Json(null);
        }

        #endregion HR Approvals Requests

        #region Temporary Employees

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DigiFormHelper.ActionTransferTargetCostCodeHoD)]
        public async Task<IActionResult> TemporaryEmployeesIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterCostCodeChangeRequestIndex
            });

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            CostcodeChangeRequestIndexViewModel costcodeChangeRequestIndexViewModel = new()
            {
                FilterDataModel = filterDataModel
            };
            return View(costcodeChangeRequestIndexViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DigiFormHelper.ActionTransferTargetCostCodeHoD)]
        public async Task<JsonResult> GetListsTemporaryEmployeesList(string paramJson)
        {
            DTResult<CostcodeChangeRequestDataTableList> result = new();
            int totalRow = 0;
            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            try
            {
                System.Collections.Generic.IEnumerable<CostcodeChangeRequestDataTableList> data = await _costcodeChangeRequestDataTableListRepository.TemporaryEmployeesDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch,
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
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DigiFormHelper.ActionTransferTargetCostCodeHoD)]
        public async Task<IActionResult> CostcodeChangeRequestReturn(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var result = await _costcodeChangeRequestDetailRepository.CostcodeChangeRequestDetail(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PKeyId = id
                });

            var data = await _approvalDetailsDataTableListRepository.ExtensionDetailsDataTableListAsync(
                   BaseSpTcmPLGet(),
                   new ParameterSpTcmPL
                   {
                       PKeyId = id
                   }
               );
            EmployeeDetails employeeDetails = new();
            CostcodeChangeRequestDetailsViewModel costcodeChangeRequestDetailsViewModel = new();

            if (result.PMessageType == IsOk)
            {
                costcodeChangeRequestDetailsViewModel.KeyId = id;
                costcodeChangeRequestDetailsViewModel.TransferType = result.PTransferTypeText;
                costcodeChangeRequestDetailsViewModel.Employee = result.PEmpNo + "-" + result.PEmpName;
                costcodeChangeRequestDetailsViewModel.Empno = result.PEmpNo;
                costcodeChangeRequestDetailsViewModel.TargetCostCode = result.PCurrentCostcodeVal + " - " + result.PCurrentCostcodeText;
                costcodeChangeRequestDetailsViewModel.TargetCostCodeVal = result.PCurrentCostcodeVal;
                costcodeChangeRequestDetailsViewModel.CurrentCostCode = result.PTargetCostcodeVal + " - " + result.PTargetCostcodeText;
                costcodeChangeRequestDetailsViewModel.CurrentCostCodeVal = result.PTargetCostcodeVal;
                costcodeChangeRequestDetailsViewModel.TransferDate = result.PTransferDate;
                costcodeChangeRequestDetailsViewModel.TransferEndDate = result.PTransferEndDate;
                costcodeChangeRequestDetailsViewModel.EffectiveTransferDate = result.PEffectiveTransferDate;
                costcodeChangeRequestDetailsViewModel.Remarks = result.PRemarks;
                costcodeChangeRequestDetailsViewModel.TargetHodRemarks = result.PTargetHodRemarks;
                costcodeChangeRequestDetailsViewModel.HrRemarks = result.PHrRemarks;
                costcodeChangeRequestDetailsViewModel.JobdisciplineCode = result.PJobdisciplineCode;
                costcodeChangeRequestDetailsViewModel.Jobdiscipline = result.PJobdiscipline;
                costcodeChangeRequestDetailsViewModel.JobGroup = result.PJobGroup;
                costcodeChangeRequestDetailsViewModel.JobGroupCode = result.PJobGroupCode;
                costcodeChangeRequestDetailsViewModel.Jobtitle = result.PJobtitle;
                costcodeChangeRequestDetailsViewModel.JobtitleCode = result.PJobtitleCode;
                costcodeChangeRequestDetailsViewModel.SiteName = result.PSiteName;
                costcodeChangeRequestDetailsViewModel.SiteLocation = result.PSiteLocation;

                employeeDetails = await _commonEmployeeDetailsRepository.EmployeeDetailAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL { PEmpno = result.PEmpNo });
                if (employeeDetails != null)
                {
                    costcodeChangeRequestDetailsViewModel.Grade = employeeDetails.PGrade;
                    costcodeChangeRequestDetailsViewModel.CurrentDesignation = employeeDetails.PDesgCode + " - " + employeeDetails.PDesgName;
                    costcodeChangeRequestDetailsViewModel.CurrentJobTitle = employeeDetails.PJobTitle;
                }

                foreach (var item in data.Select(s => new { s.TransferEndDate, s.Remarks, s.ModifiedOn, s.ModifiedByName, s.ModifiedBy }))
                {
                    costcodeChangeRequestDetailsViewModel.ExtensionDetailsList.Add(
                       new ExtensionDetails
                       {
                           TransferEndDate = item.TransferEndDate,
                           Remarks = item.Remarks,
                           ModifiedOn = item.ModifiedOn,
                           ModifiedByName = item.ModifiedByName,
                           ModifiedBy = item.ModifiedBy
                       });
                };

            }

            return PartialView("_ModalCostcodeChangeRequestReturnPartial", costcodeChangeRequestDetailsViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DigiFormHelper.ActionTransferTargetCostCodeHoD)]
        public async Task<IActionResult> CostcodeChangeRequestReturn(CostcodeChangeRequestDetailsViewModel costcodeChangeRequestDetailsViewModel)
        {
            try
            {
                costcodeChangeRequestDetailsViewModel.StatusVal = 0;
                costcodeChangeRequestDetailsViewModel.TransferVal = 2;

                Domain.Models.Common.DBProcMessageOutput result = await _costcodeChangeRequestRepository.CostcodeChangeRequestReturnAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PKeyId = costcodeChangeRequestDetailsViewModel.KeyId,
                        PTransferType = costcodeChangeRequestDetailsViewModel.TransferVal,
                        PEmpNo = costcodeChangeRequestDetailsViewModel.Empno,
                        PCurrentCostcode = costcodeChangeRequestDetailsViewModel.CurrentCostCodeVal,
                        PTargetCostcode = costcodeChangeRequestDetailsViewModel.TargetCostCodeVal,
                        PTransferDate = costcodeChangeRequestDetailsViewModel.TransferDate,
                        PRemarks = costcodeChangeRequestDetailsViewModel.ApprovalRemarks,
                        PStatus = costcodeChangeRequestDetailsViewModel.StatusVal
                    }
                    );

                return result.PMessageType == NotOk
                        ? throw new Exception(result.PMessageText.Replace("-", " "))
                        : (IActionResult)Json(new { success = true, response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        #endregion Temporary Employees

        #region Details

        [HttpGet]
        public async Task<IActionResult> GetAllApprovalsStatus(string id)
        {
            ApprovalDetailsViewModel approvalDetailsViewModel = new();
            EmployeeDetails employeeDetails = new();
            var result = await _costcodeChangeRequestDetailRepository.CostcodeChangeRequestDetail(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PKeyId = id
                });
            if (result.PMessageType == IsOk)
            {
                approvalDetailsViewModel.KeyId = id;
                approvalDetailsViewModel.Empno = result.PEmpNo + "-" + result.PEmpName;
                approvalDetailsViewModel.TransferType = result.PTransferTypeText;
                approvalDetailsViewModel.CurrentCostCode = result.PCurrentCostcodeVal + " - " + result.PCurrentCostcodeText;
                approvalDetailsViewModel.TargetCostCode = result.PTargetCostcodeVal + " - " + result.PTargetCostcodeText;
                approvalDetailsViewModel.TransferDate = result.PTransferDate;
                approvalDetailsViewModel.TransferEndDate = result.PTransferEndDate;
                approvalDetailsViewModel.EffectiveTransferDate = result.PEffectiveTransferDate;

                employeeDetails = await _commonEmployeeDetailsRepository.EmployeeDetailAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL { PEmpno = result.PEmpNo });
                if (employeeDetails != null)
                {
                    approvalDetailsViewModel.Grade = employeeDetails.PGrade;
                    approvalDetailsViewModel.CurrentDesignation = employeeDetails.PDesgCode + " - " + employeeDetails.PDesgName;
                    approvalDetailsViewModel.CurrentJobTitle = employeeDetails.PJobTitle;
                }
            }

            return PartialView("_ModalApprovalDetailsPartial", approvalDetailsViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsApprovalsDetails(string paramJSon)
        {
            DTResult<ApprovalDetailsDataTableList> result = new();

            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJSon);

            int totalRow = 0;
            System.Collections.Generic.IEnumerable<ApprovalDetailsDataTableList> data =
                                            await _approvalDetailsDataTableListRepository.ApprovalDetailsDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PKeyId = param.KeyId
                    }
                );

            if (data.Any())
            {
                totalRow = (int)data.Count();
            }

            result.draw = param.Draw;
            result.recordsTotal = totalRow;
            result.recordsFiltered = totalRow;
            result.data = data.ToList();

            return Json(result);
        }

        [HttpPost]
        public async Task<IActionResult> GetEmployeeInfo(string empno)
        {
            try
            {
                if (string.IsNullOrEmpty(empno))
                {
                    return NotFound();
                }
                var result = await _commonEmployeeDetailsRepository.EmployeeDetailAsync(
                       BaseSpTcmPLGet(),
                       new ParameterSpTcmPL
                       {
                           PEmpno = empno
                       });

                return Json(new
                {
                    Success = result.PMessageType == IsOk,
                    Response = result.PMessageText,
                    CurrentCostcode = result.PParent,
                    CurrentCostcodeName = result.PCostName,
                });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        [HttpPost]
        public async Task<IActionResult> GetCostcodeTarget(string currentCostcode)
        {
            try
            {
                if (string.IsNullOrEmpty(currentCostcode))
                {
                    return NotFound();
                }

                var result = await _selectTcmPLRepository.CostcodeDeptList(
                       BaseSpTcmPLGet(),
                       new ParameterSpTcmPL
                       {
                           PCostcode = currentCostcode
                       });

                return Json(result);
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        [HttpGet]
        public async Task<IActionResult> CostcodeChangeRequestDetails(string id)
        {
            if (id == null)
            {
                return NotFound();
            }
            EmployeeDetails employeeDetails = new();
            var result = await _costcodeChangeRequestDetailRepository.CostcodeChangeRequestDetail(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PKeyId = id
                });

            var data = await _approvalDetailsDataTableListRepository.ExtensionDetailsDataTableListAsync(
                   BaseSpTcmPLGet(),
                   new ParameterSpTcmPL
                   {
                       PKeyId = id
                   }
               );

            CostcodeChangeRequestDetailsViewModel costcodeChangeRequestDetailsViewModel = new();

            if (result.PMessageType == IsOk)
            {
                costcodeChangeRequestDetailsViewModel.KeyId = id;
                costcodeChangeRequestDetailsViewModel.TransferType = result.PTransferTypeText;
                costcodeChangeRequestDetailsViewModel.TransferVal = result.PTransferTypeVal;
                costcodeChangeRequestDetailsViewModel.Employee = result.PEmpNo + "-" + result.PEmpName;
                costcodeChangeRequestDetailsViewModel.CurrentCostCode = result.PCurrentCostcodeVal + " - " + result.PCurrentCostcodeText;
                costcodeChangeRequestDetailsViewModel.TargetCostCode = result.PTargetCostcodeVal + " - " + result.PTargetCostcodeText;
                costcodeChangeRequestDetailsViewModel.TransferDate = result.PTransferDate;
                costcodeChangeRequestDetailsViewModel.TransferEndDate = result.PTransferEndDate;
                costcodeChangeRequestDetailsViewModel.Remarks = result.PRemarks;
                costcodeChangeRequestDetailsViewModel.Status = result.PStatusText;

                costcodeChangeRequestDetailsViewModel.JobdisciplineCode = result.PJobdisciplineCode;
                costcodeChangeRequestDetailsViewModel.Jobdiscipline = result.PJobdiscipline;
                costcodeChangeRequestDetailsViewModel.JobGroup = result.PJobGroup;
                costcodeChangeRequestDetailsViewModel.JobGroupCode = result.PJobGroupCode;
                costcodeChangeRequestDetailsViewModel.Jobtitle = result.PJobtitle;
                costcodeChangeRequestDetailsViewModel.JobtitleCode = result.PJobtitleCode;
                costcodeChangeRequestDetailsViewModel.TargetHodRemarks = result.PTargetHodRemarks;
                costcodeChangeRequestDetailsViewModel.HrRemarks = result.PHrRemarks;
                costcodeChangeRequestDetailsViewModel.HrHoDRemarks = result.PHrHodRemarks;
                costcodeChangeRequestDetailsViewModel.SiteName = result.PSiteName;
                costcodeChangeRequestDetailsViewModel.SiteLocation = result.PSiteLocation;

                employeeDetails = await _commonEmployeeDetailsRepository.EmployeeDetailAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL { PEmpno = result.PEmpNo });
                if (employeeDetails != null)
                {
                    costcodeChangeRequestDetailsViewModel.Grade = employeeDetails.PGrade;
                    costcodeChangeRequestDetailsViewModel.CurrentDesignation = employeeDetails.PDesgCode + " - " + employeeDetails.PDesgName;
                    costcodeChangeRequestDetailsViewModel.CurrentJobTitle = employeeDetails.PJobTitle;
                }

                foreach (var item in data.Select(s => new { s.TransferEndDate, s.Remarks, s.ModifiedOn, s.ModifiedByName, s.ModifiedBy }))
                {
                    costcodeChangeRequestDetailsViewModel.ExtensionDetailsList.Add(
                       new ExtensionDetails
                       {
                           TransferEndDate = item.TransferEndDate,
                           Remarks = item.Remarks,
                           ModifiedOn = item.ModifiedOn,
                           ModifiedByName = item.ModifiedByName,
                           ModifiedBy = item.ModifiedBy
                       });
                };
            }

            return PartialView("_ModalCostcodeChangeRequestDetailsPartial", costcodeChangeRequestDetailsViewModel);
        }

        #endregion Details

        #region SiteMaster

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DigiFormHelper.ActionTransferCostCodeHR)]
        public async Task<IActionResult> SiteMasterIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterSiteMasterIndex
            });

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            SiteMasterIndexViewModel siteMasterIndexViewModel = new()
            {
                FilterDataModel = filterDataModel
            };
            return View(siteMasterIndexViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DigiFormHelper.ActionTransferCostCodeHR)]
        public async Task<JsonResult> GetListsSiteMasterList(string paramJson)
        {
            DTResult<SiteMasterDataTableList> result = new();
            int totalRow = 0;
            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            try
            {
                System.Collections.Generic.IEnumerable<SiteMasterDataTableList> data = await _siteMasterDataTableListRepository.SiteMasterDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch,
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
        public IActionResult SiteMasterCreate()
        {
            SiteMasterCreateViewModel siteMasterCreateViewModel = new();

            return PartialView("_ModalSiteMasterCreatePartial", siteMasterCreateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DigiFormHelper.ActionTransferCostCodeHR)]
        public async Task<IActionResult> SiteMasterCreate([FromForm] SiteMasterCreateViewModel siteMasterCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _siteMasterRequestRepository.SiteMasterCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PSiteName = siteMasterCreateViewModel.SiteName,
                            PSiteLocation = siteMasterCreateViewModel.SiteLocation,
                            PIsActive = siteMasterCreateViewModel.IsActive,
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

            return PartialView("_ModalSiteMasterCreatePartial", siteMasterCreateViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> SiteMasterEdit(string id)
        {
            SiteMasterEditViewModel siteMasterEditViewModel = new();

            if (id == null)
            {
                return NotFound();
            }

            var result = await _siteMasterDetailRepository.SiteMasterDetail(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PKeyId = id
                });

            if (result.PMessageType == IsOk)
            {
                siteMasterEditViewModel.KeyId = id;
                siteMasterEditViewModel.SiteName = result.PSiteName;
                siteMasterEditViewModel.SiteLocation = result.PSiteLocation;
                siteMasterEditViewModel.IsActive = result.PIsActiveVal;
            }

            return PartialView("_ModalSiteMasterUpdatePartial", siteMasterEditViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DigiFormHelper.ActionTransferCostCodeHR)]
        public async Task<IActionResult> SiteMasterEdit([FromForm] SiteMasterEditViewModel siteMasterEditViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _siteMasterRequestRepository.SiteMasterEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PKeyId = siteMasterEditViewModel.KeyId,
                            PSiteName = siteMasterEditViewModel.SiteName,
                            PSiteLocation = siteMasterEditViewModel.SiteLocation,
                            PIsActive = siteMasterEditViewModel.IsActive,
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

            return PartialView("_ModalSiteMasterUpdatePartial", siteMasterEditViewModel);
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DigiFormHelper.ActionTransferCostCodeHR)]
        public async Task<IActionResult> SiteMasterExcelDownload()
        {
            var timeStamp = DateTime.Now.ToFileTime();

            string fileName = "Site List_" + timeStamp.ToString();
            string reportTitle = "Site List";
            string sheetName = "Site List";

            IEnumerable<SiteMasterDataTableList> data = await _siteMasterDataTableListRepository.SiteMasterDataTableListForExcelAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                });

            if (data == null) { return NotFound(); }

            var json = JsonConvert.SerializeObject(data);

            IEnumerable<SiteMasterDataTableListExcel> excelData = JsonConvert.DeserializeObject<IEnumerable<SiteMasterDataTableListExcel>>(json);

            var byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, reportTitle, sheetName);

            var mimeType = MimeTypeMap.GetMimeType("xlsx");

            FileContentResult file = File(byteContent, mimeType, fileName);

            return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
        }

        #endregion SiteMaster

        #region Filter

        public async Task<IActionResult> HrApprovalHistoryFilterGet()
        {
            Domain.Models.FilterRetrieve retVal = await RetriveFilter(ConstFilterHodApprovalsHistoryIndex);

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            IEnumerable<DataField> costCodeList = await _selectTcmPLRepository.HRMISDeptList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["CostCodeList"] = new SelectList(costCodeList, "DataValueField", "DataTextField");

            return PartialView("_ModalHrApprovalHistoryFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> HrApprovalHistoryFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                string jsonFilter;
                jsonFilter = JsonConvert.SerializeObject(
                        new
                        {
                            CurrentCostcode = filterDataModel.CurrentCostcode,
                            TargetCostcode = filterDataModel.CurrentCostcode
                        });

                Domain.Models.FilterCreate retVal = await CreateFilter(jsonFilter, ConstFilterHodApprovalsHistoryIndex);

                return Json(new
                {
                    success = true,
                    currentCostcode = filterDataModel.CurrentCostcode,
                    targetCostcode = filterDataModel.TargetCostcode
                });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        #endregion Filter

        #endregion Cost code

        #region Print PDF / WORD

        private async Task<ActionResult> ConvertResponseMessageToIActionResult(HttpResponseMessage httpResponseMessage, string defaultFileName)
        {
            string fileName = string.Empty;
            if (httpResponseMessage.IsSuccessStatusCode)
            {
                byte[] buffer = null;
                Stream stream = await httpResponseMessage.Content.ReadAsStreamAsync();
                string contentType = httpResponseMessage.Content.Headers.ContentType.ToString();
                using (MemoryStream ms = new MemoryStream())
                {
                    await stream.CopyToAsync(ms);
                    buffer = ms.ToArray();
                }
                var oFile = File(buffer, contentType, defaultFileName);
                return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", oFile, NotificationType.success));
            }
            else
            {
                return Json(ResponseHelper.GetMessageObject("Internal server error.", NotificationType.error));
            }
        }

        #region Mid term evaluation

        // PUPPETEER PDF - OBSOLETE (Not in use)
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DigiFormHelper.ActionProgEvalPrint)]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> MidTermEvaluationPrint(string keyid)
        {
            try
            {
                if (keyid == null)
                {
                    return NotFound();
                }

                var result = await _midEvaluationDetailRepository.MidEvaluationDetails(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PKeyId = keyid
                    });

                if (result == null)
                {
                    return NotFound();
                }

                var employeeDetails = await _commonEmployeeDetailsRepository.EmployeeDetailAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL { PEmpno = result.PEmpno });

                string htmlString = string.Empty;

                string _uriGetPdf = "PDFGenerator/ConvertHtmlToPdf";

                string filePath = Path.Combine(_environment.WebRootPath, @"asset\MidTermEvaluationPrint.txt");

                using (StreamReader r = new StreamReader(filePath))
                {
                    htmlString = r.ReadToEnd();
                }

                if (!String.IsNullOrEmpty(htmlString))
                {
                    DateTime currDate = DateTime.Now;

                    htmlString = htmlString.Replace("!~!EmployeeName", (!String.IsNullOrEmpty(employeeDetails.PName) ? employeeDetails.PName.ToString() : string.Empty));
                    htmlString = htmlString.Replace("!~!EmployeeNo", (!String.IsNullOrEmpty(result.PEmpno) ? result.PEmpno.ToString() : string.Empty));
                    htmlString = htmlString.Replace("!~!Designation", (!String.IsNullOrEmpty(employeeDetails.PDesgName) ? employeeDetails.PDesgCode.ToString() + " -  " + employeeDetails.PDesgName : string.Empty));
                    htmlString = htmlString.Replace("!~!Department", (!String.IsNullOrEmpty(employeeDetails.PParent) ? employeeDetails.PParent.ToString() + " - " + employeeDetails.PCostName : string.Empty));
                    htmlString = htmlString.Replace("!~!Doj", employeeDetails.PDoj.ToString("dd-MMM-yyyy") ?? string.Empty);
                    htmlString = htmlString.Replace("!~!Attendance", (!String.IsNullOrEmpty(result.PAttendance) ? result.PAttendance.ToString() : string.Empty));
                    htmlString = htmlString.Replace("!~!Location", (!String.IsNullOrEmpty(employeeDetails.PCurrentOfficeLocation) ? employeeDetails.PCurrentOfficeLocation.ToString() : string.Empty));

                    htmlString = htmlString.Replace("!~!SkillText1", result.PSkill1?.ToString() ?? ".....");
                    htmlString = htmlString.Replace("!~!Skill1_VG", result.PSkill1RatingVal?.ToString() == "4" ? "&#x2713;" : "");
                    htmlString = htmlString.Replace("!~!Skill1_G", result.PSkill1RatingVal?.ToString() == "3" ? "&#x2713;" : "");
                    htmlString = htmlString.Replace("!~!Skill1_A", result.PSkill1RatingVal?.ToString() == "2" ? "&#x2713;" : "");
                    htmlString = htmlString.Replace("!~!Skill1_BA", result.PSkill1RatingVal?.ToString() == "1" ? "&#x2713;" : "");
                    htmlString = htmlString.Replace("!~!Skill1_Remarks", (!String.IsNullOrEmpty(result.PSkill1Remark) ? result.PSkill1Remark?.ToString() : ""));

                    htmlString = htmlString.Replace("!~!SkillText2", result.PSkill2?.ToString() ?? ".....");
                    htmlString = htmlString.Replace("!~!Skill2_VG", result.PSkill2RatingVal?.ToString() == "4" ? "&#x2713;" : "");
                    htmlString = htmlString.Replace("!~!Skill2_G", result.PSkill2RatingVal?.ToString() == "3" ? "&#x2713;" : "");
                    htmlString = htmlString.Replace("!~!Skill2_A", result.PSkill2RatingVal?.ToString() == "2" ? "&#x2713;" : "");
                    htmlString = htmlString.Replace("!~!Skill2_BA", result.PSkill2RatingVal?.ToString() == "1" ? "&#x2713;" : "");
                    htmlString = htmlString.Replace("!~!Skill2_Remarks", (!String.IsNullOrEmpty(result.PSkill2Remark) ? result.PSkill2Remark?.ToString() : ""));

                    htmlString = htmlString.Replace("!~!SkillText3", result.PSkill3?.ToString() ?? ".....");
                    htmlString = htmlString.Replace("!~!Skill3_VG", result.PSkill3RatingVal?.ToString() == "4" ? "&#x2713;" : "");
                    htmlString = htmlString.Replace("!~!Skill3_G", result.PSkill3RatingVal?.ToString() == "3" ? "&#x2713;" : "");
                    htmlString = htmlString.Replace("!~!Skill3_A", result.PSkill3RatingVal?.ToString() == "2" ? "&#x2713;" : "");
                    htmlString = htmlString.Replace("!~!Skill3_BA", result.PSkill3RatingVal?.ToString() == "1" ? "&#x2713;" : "");
                    htmlString = htmlString.Replace("!~!Skill3_Remarks", (!String.IsNullOrEmpty(result.PSkill3Remark) ? result.PSkill3Remark?.ToString() : ""));

                    htmlString = htmlString.Replace("!~!SkillText4", result.PSkill4?.ToString() ?? ".....");
                    htmlString = htmlString.Replace("!~!Skill4_VG", result.PSkill4RatingVal?.ToString() == "4" ? "&#x2713;" : "");
                    htmlString = htmlString.Replace("!~!Skill4_G", result.PSkill4RatingVal?.ToString() == "3" ? "&#x2713;" : "");
                    htmlString = htmlString.Replace("!~!Skill4_A", result.PSkill4RatingVal?.ToString() == "2" ? "&#x2713;" : "");
                    htmlString = htmlString.Replace("!~!Skill4_BA", result.PSkill4RatingVal?.ToString() == "1" ? "&#x2713;" : "");
                    htmlString = htmlString.Replace("!~!Skill4_Remarks", (!String.IsNullOrEmpty(result.PSkill4Remark) ? result.PSkill4Remark?.ToString() : ""));

                    htmlString = htmlString.Replace("!~!SkillText5", result.PSkill5?.ToString() ?? ".....");
                    htmlString = htmlString.Replace("!~!Skill5_VG", result.PSkill5RatingVal?.ToString() == "4" ? "&#x2713;" : "");
                    htmlString = htmlString.Replace("!~!Skill5_G", result.PSkill5RatingVal?.ToString() == "3" ? "&#x2713;" : "");
                    htmlString = htmlString.Replace("!~!Skill5_A", result.PSkill5RatingVal?.ToString() == "2" ? "&#x2713;" : "");
                    htmlString = htmlString.Replace("!~!Skill5_BA", result.PSkill5RatingVal?.ToString() == "1" ? "&#x2713;" : "");
                    htmlString = htmlString.Replace("!~!Skill5_Remarks", (!String.IsNullOrEmpty(result.PSkill5Remark) ? result.PSkill5Remark?.ToString() : ""));

                    htmlString = htmlString.Replace("!~!Que2_VG", result.PQue2RatingVal?.ToString() == "4" ? "&#x2713;" : "");
                    htmlString = htmlString.Replace("!~!Que2_G", result.PQue2RatingVal?.ToString() == "3" ? "&#x2713;" : "");
                    htmlString = htmlString.Replace("!~!Que2_A", result.PQue2RatingVal?.ToString() == "2" ? "&#x2713;" : "");
                    htmlString = htmlString.Replace("!~!Que2_BA", result.PQue2RatingVal?.ToString() == "1" ? "&#x2713;" : "");
                    htmlString = htmlString.Replace("!~!Que2_Remarks", (!String.IsNullOrEmpty(result.PQue2Remark) ? result.PQue2Remark?.ToString() : ""));

                    htmlString = htmlString.Replace("!~!Que3_VG", result.PQue3RatingVal?.ToString() == "4" ? "&#x2713;" : "");
                    htmlString = htmlString.Replace("!~!Que3_G", result.PQue3RatingVal?.ToString() == "3" ? "&#x2713;" : "");
                    htmlString = htmlString.Replace("!~!Que3_A", result.PQue3RatingVal?.ToString() == "2" ? "&#x2713;" : "");
                    htmlString = htmlString.Replace("!~!Que3_BA", result.PQue3RatingVal?.ToString() == "1" ? "&#x2713;" : "");
                    htmlString = htmlString.Replace("!~!Que3_Remarks", (!String.IsNullOrEmpty(result.PQue3Remark) ? result.PQue3Remark?.ToString() : ""));

                    htmlString = htmlString.Replace("!~!Que4_VG", result.PQue4RatingVal?.ToString() == "4" ? "&#x2713;" : "");
                    htmlString = htmlString.Replace("!~!Que4_G", result.PQue4RatingVal?.ToString() == "3" ? "&#x2713;" : "");
                    htmlString = htmlString.Replace("!~!Que4_A", result.PQue4RatingVal?.ToString() == "2" ? "&#x2713;" : "");
                    htmlString = htmlString.Replace("!~!Que4_BA", result.PQue4RatingVal?.ToString() == "1" ? "&#x2713;" : "");
                    htmlString = htmlString.Replace("!~!Que4_Remarks", (!String.IsNullOrEmpty(result.PQue4Remark) ? result.PQue4Remark?.ToString() : ""));

                    htmlString = htmlString.Replace("!~!Que5_VG", result.PQue5RatingVal?.ToString() == "4" ? "&#x2713;" : "");
                    htmlString = htmlString.Replace("!~!Que5_G", result.PQue5RatingVal?.ToString() == "3" ? "&#x2713;" : "");
                    htmlString = htmlString.Replace("!~!Que5_A", result.PQue5RatingVal?.ToString() == "2" ? "&#x2713;" : "");
                    htmlString = htmlString.Replace("!~!Que5_BA", result.PQue5RatingVal?.ToString() == "1" ? "&#x2713;" : "");
                    htmlString = htmlString.Replace("!~!Que5_Remarks", (!String.IsNullOrEmpty(result.PQue5Remark) ? result.PQue5Remark?.ToString() : ""));

                    htmlString = htmlString.Replace("!~!Que6_VG", result.PQue6RatingVal?.ToString() == "4" ? "&#x2713;" : "");
                    htmlString = htmlString.Replace("!~!Que6_G", result.PQue6RatingVal?.ToString() == "3" ? "&#x2713;" : "");
                    htmlString = htmlString.Replace("!~!Que6_A", result.PQue6RatingVal?.ToString() == "2" ? "&#x2713;" : "");
                    htmlString = htmlString.Replace("!~!Que6_BA", result.PQue6RatingVal?.ToString() == "1" ? "&#x2713;" : "");
                    htmlString = htmlString.Replace("!~!Que6_Remarks", (!String.IsNullOrEmpty(result.PQue6Remark) ? result.PQue6Remark?.ToString() : ""));

                    htmlString = htmlString.Replace("!~!Observations", (!String.IsNullOrEmpty(result.PObservations) ? result.PObservations?.ToString() : ""));

                    htmlString = htmlString.Replace("!~!FormDate", currDate.ToString("dd-MMM-yyyy"));
                }
                else
                {
                    htmlString = "<br/> <br/>";
                    htmlString = filePath + "-Template not found, contact system administrator !!!";
                }

                string strFileNameOut = String.Format("Digiform_0181-040-01_{0}_{1}.{2}", result.PEmpno.ToString(), DateTime.Now.ToString("yyyyMMdd_HHmm"), "pdf");

                var returnResponse = await _httpClientWebApi.ExecutePostUriAsync(new HCModel(), _uriGetPdf, new Classes.HCModel { Htmlcontent = htmlString, Fname = strFileNameOut });

                return await ConvertResponseMessageToIActionResult(returnResponse, strFileNameOut);
            }
            catch (Exception ex)
            {
                throw new CustomJsonException(ex.Message, ex);
            }
        }

        // XML / DOC
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DigiFormHelper.ActionProgEvalPrint)]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> MidTermEvaluationXmlPrint(string keyid)
        {
            try
            {
                if (keyid == null)
                {
                    return NotFound();
                }

                var result = await _midEvaluationDetailRepository.MidEvaluationDetails(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PKeyId = keyid
                    });

                if (result == null)
                {
                    return NotFound();
                }

                var employeeDetails = await _commonEmployeeDetailsRepository.EmployeeDetailAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL { PEmpno = result.PEmpno });

                string htmlString = string.Empty;

                string _uriGetXmlDoc = "HtmlToOpenXml/ConvertHtmlToWord";

                string fileName = "MidTermEvaluationXmlPrint.txt";

                string filePath = StorageHelper.GetTemplateFilePath(StorageHelper.DigiForm.RepositoryDigiForm, FileName: fileName, Configuration);

                string logoPath = Path.Combine(_environment.WebRootPath, @"img\maire_logo_large.png");

                using (StreamReader r = new StreamReader(filePath))
                {
                    htmlString = r.ReadToEnd();
                }

                if (!String.IsNullOrEmpty(htmlString))
                {
                    DateTime currDate = DateTime.Now;

                    byte[] bytes = System.IO.File.ReadAllBytes(logoPath);
                    string base64String = Convert.ToBase64String(bytes);

                    //using (Image image = Image.FromFile(logoPath))
                    //{
                    //    using (MemoryStream m = new MemoryStream())
                    //    {
                    //        image.Save(m, image.RawFormat);
                    //        byte[] imageBytes = m.ToArray();
                    //        string base64String = Convert.ToBase64String(imageBytes);

                    //        htmlString = htmlString.Replace("!~!Company_logo", (!String.IsNullOrEmpty(base64String) ? base64String.ToString().Trim() : string.Empty));
                    //    }
                    //}

                    htmlString = htmlString.Replace("!~!Company_logo", (!String.IsNullOrEmpty(base64String) ? base64String.ToString().Trim() : string.Empty));
                    htmlString = htmlString.Replace("!~!EmployeeName", (!String.IsNullOrEmpty(employeeDetails.PName) ? employeeDetails.PName.ToString() : string.Empty));
                    htmlString = htmlString.Replace("!~!EmployeeNo", (!String.IsNullOrEmpty(result.PEmpno) ? result.PEmpno.ToString() : string.Empty));
                    htmlString = htmlString.Replace("!~!Designation", (!String.IsNullOrEmpty(employeeDetails.PDesgName) ? employeeDetails.PDesgCode.ToString() + " -  " + employeeDetails.PDesgName : string.Empty));
                    htmlString = htmlString.Replace("!~!Department", (!String.IsNullOrEmpty(employeeDetails.PParent) ? employeeDetails.PParent.ToString() + " - " + employeeDetails.PCostName : string.Empty));
                    htmlString = htmlString.Replace("!~!Doj", employeeDetails.PDoj.ToString("dd-MMM-yyyy") ?? string.Empty);
                    htmlString = htmlString.Replace("!~!Attendance", (!String.IsNullOrEmpty(result.PAttendance) ? result.PAttendance.ToString() : string.Empty));
                    htmlString = htmlString.Replace("!~!Location", (!String.IsNullOrEmpty(employeeDetails.PCurrentOfficeLocation) ? employeeDetails.PCurrentOfficeLocation.ToString() : string.Empty));

                    htmlString = htmlString.Replace("!~!SkillText1", result.PSkill1?.ToString() ?? ".....");
                    htmlString = htmlString.Replace("!~!Skill1_VG", result.PSkill1RatingVal?.ToString() == "4" ? "&#x2713;" : "");
                    htmlString = htmlString.Replace("!~!Skill1_G", result.PSkill1RatingVal?.ToString() == "3" ? "&#x2713;" : "");
                    htmlString = htmlString.Replace("!~!Skill1_A", result.PSkill1RatingVal?.ToString() == "2" ? "&#x2713;" : "");
                    htmlString = htmlString.Replace("!~!Skill1_BA", result.PSkill1RatingVal?.ToString() == "1" ? "&#x2713;" : "");
                    htmlString = htmlString.Replace("!~!Skill1_Remarks", (!String.IsNullOrEmpty(result.PSkill1Remark) ? result.PSkill1Remark?.ToString() : ""));

                    htmlString = htmlString.Replace("!~!SkillText2", result.PSkill2?.ToString() ?? ".....");
                    htmlString = htmlString.Replace("!~!Skill2_VG", result.PSkill2RatingVal?.ToString() == "4" ? "&#x2713;" : "");
                    htmlString = htmlString.Replace("!~!Skill2_G", result.PSkill2RatingVal?.ToString() == "3" ? "&#x2713;" : "");
                    htmlString = htmlString.Replace("!~!Skill2_A", result.PSkill2RatingVal?.ToString() == "2" ? "&#x2713;" : "");
                    htmlString = htmlString.Replace("!~!Skill2_BA", result.PSkill2RatingVal?.ToString() == "1" ? "&#x2713;" : "");
                    htmlString = htmlString.Replace("!~!Skill2_Remarks", (!String.IsNullOrEmpty(result.PSkill2Remark) ? result.PSkill2Remark?.ToString() : ""));

                    htmlString = htmlString.Replace("!~!SkillText3", result.PSkill3?.ToString() ?? ".....");
                    htmlString = htmlString.Replace("!~!Skill3_VG", result.PSkill3RatingVal?.ToString() == "4" ? "&#x2713;" : "");
                    htmlString = htmlString.Replace("!~!Skill3_G", result.PSkill3RatingVal?.ToString() == "3" ? "&#x2713;" : "");
                    htmlString = htmlString.Replace("!~!Skill3_A", result.PSkill3RatingVal?.ToString() == "2" ? "&#x2713;" : "");
                    htmlString = htmlString.Replace("!~!Skill3_BA", result.PSkill3RatingVal?.ToString() == "1" ? "&#x2713;" : "");
                    htmlString = htmlString.Replace("!~!Skill3_Remarks", (!String.IsNullOrEmpty(result.PSkill3Remark) ? result.PSkill3Remark?.ToString() : ""));

                    htmlString = htmlString.Replace("!~!SkillText4", result.PSkill4?.ToString() ?? ".....");
                    htmlString = htmlString.Replace("!~!Skill4_VG", result.PSkill4RatingVal?.ToString() == "4" ? "&#x2713;" : "");
                    htmlString = htmlString.Replace("!~!Skill4_G", result.PSkill4RatingVal?.ToString() == "3" ? "&#x2713;" : "");
                    htmlString = htmlString.Replace("!~!Skill4_A", result.PSkill4RatingVal?.ToString() == "2" ? "&#x2713;" : "");
                    htmlString = htmlString.Replace("!~!Skill4_BA", result.PSkill4RatingVal?.ToString() == "1" ? "&#x2713;" : "");
                    htmlString = htmlString.Replace("!~!Skill4_Remarks", (!String.IsNullOrEmpty(result.PSkill4Remark) ? result.PSkill4Remark?.ToString() : ""));

                    htmlString = htmlString.Replace("!~!SkillText5", result.PSkill5?.ToString() ?? ".....");
                    htmlString = htmlString.Replace("!~!Skill5_VG", result.PSkill5RatingVal?.ToString() == "4" ? "&#x2713;" : "");
                    htmlString = htmlString.Replace("!~!Skill5_G", result.PSkill5RatingVal?.ToString() == "3" ? "&#x2713;" : "");
                    htmlString = htmlString.Replace("!~!Skill5_A", result.PSkill5RatingVal?.ToString() == "2" ? "&#x2713;" : "");
                    htmlString = htmlString.Replace("!~!Skill5_BA", result.PSkill5RatingVal?.ToString() == "1" ? "&#x2713;" : "");
                    htmlString = htmlString.Replace("!~!Skill5_Remarks", (!String.IsNullOrEmpty(result.PSkill5Remark) ? result.PSkill5Remark?.ToString() : ""));

                    htmlString = htmlString.Replace("!~!Que2_VG", result.PQue2RatingVal?.ToString() == "4" ? "&#x2713;" : "");
                    htmlString = htmlString.Replace("!~!Que2_G", result.PQue2RatingVal?.ToString() == "3" ? "&#x2713;" : "");
                    htmlString = htmlString.Replace("!~!Que2_A", result.PQue2RatingVal?.ToString() == "2" ? "&#x2713;" : "");
                    htmlString = htmlString.Replace("!~!Que2_BA", result.PQue2RatingVal?.ToString() == "1" ? "&#x2713;" : "");
                    htmlString = htmlString.Replace("!~!Que2_Remarks", (!String.IsNullOrEmpty(result.PQue2Remark) ? result.PQue2Remark?.ToString() : ""));

                    htmlString = htmlString.Replace("!~!Que3_VG", result.PQue3RatingVal?.ToString() == "4" ? "&#x2713;" : "");
                    htmlString = htmlString.Replace("!~!Que3_G", result.PQue3RatingVal?.ToString() == "3" ? "&#x2713;" : "");
                    htmlString = htmlString.Replace("!~!Que3_A", result.PQue3RatingVal?.ToString() == "2" ? "&#x2713;" : "");
                    htmlString = htmlString.Replace("!~!Que3_BA", result.PQue3RatingVal?.ToString() == "1" ? "&#x2713;" : "");
                    htmlString = htmlString.Replace("!~!Que3_Remarks", (!String.IsNullOrEmpty(result.PQue3Remark) ? result.PQue3Remark?.ToString() : ""));

                    htmlString = htmlString.Replace("!~!Que4_VG", result.PQue4RatingVal?.ToString() == "4" ? "&#x2713;" : "");
                    htmlString = htmlString.Replace("!~!Que4_G", result.PQue4RatingVal?.ToString() == "3" ? "&#x2713;" : "");
                    htmlString = htmlString.Replace("!~!Que4_A", result.PQue4RatingVal?.ToString() == "2" ? "&#x2713;" : "");
                    htmlString = htmlString.Replace("!~!Que4_BA", result.PQue4RatingVal?.ToString() == "1" ? "&#x2713;" : "");
                    htmlString = htmlString.Replace("!~!Que4_Remarks", (!String.IsNullOrEmpty(result.PQue4Remark) ? result.PQue4Remark?.ToString() : ""));

                    htmlString = htmlString.Replace("!~!Que5_VG", result.PQue5RatingVal?.ToString() == "4" ? "&#x2713;" : "");
                    htmlString = htmlString.Replace("!~!Que5_G", result.PQue5RatingVal?.ToString() == "3" ? "&#x2713;" : "");
                    htmlString = htmlString.Replace("!~!Que5_A", result.PQue5RatingVal?.ToString() == "2" ? "&#x2713;" : "");
                    htmlString = htmlString.Replace("!~!Que5_BA", result.PQue5RatingVal?.ToString() == "1" ? "&#x2713;" : "");
                    htmlString = htmlString.Replace("!~!Que5_Remarks", (!String.IsNullOrEmpty(result.PQue5Remark) ? result.PQue5Remark?.ToString() : ""));

                    htmlString = htmlString.Replace("!~!Que6_VG", result.PQue6RatingVal?.ToString() == "4" ? "&#x2713;" : "");
                    htmlString = htmlString.Replace("!~!Que6_G", result.PQue6RatingVal?.ToString() == "3" ? "&#x2713;" : "");
                    htmlString = htmlString.Replace("!~!Que6_A", result.PQue6RatingVal?.ToString() == "2" ? "&#x2713;" : "");
                    htmlString = htmlString.Replace("!~!Que6_BA", result.PQue6RatingVal?.ToString() == "1" ? "&#x2713;" : "");
                    htmlString = htmlString.Replace("!~!Que6_Remarks", (!String.IsNullOrEmpty(result.PQue6Remark) ? result.PQue6Remark?.ToString() : ""));

                    htmlString = htmlString.Replace("!~!Observations", (!String.IsNullOrEmpty(result.PObservations) ? result.PObservations?.ToString() : ""));

                    htmlString = htmlString.Replace("!~!FormDate", currDate.ToString("dd-MMM-yyyy"));
                }
                else
                {
                    htmlString = "<br/> <br/>";
                    htmlString = filePath + "-Template not found, contact system administrator !!!";
                }

                string strFileNameOut = String.Format("Digiform_0181-040-01_{0}_{1}.{2}", result.PEmpno.ToString(), DateTime.Now.ToString("yyyyMMdd_HHmm"), "doc");

                var returnResponse = await _httpClientWebApi.ExecutePostUriAsync(new HCModel(), _uriGetXmlDoc, new Classes.HCModel { Htmlcontent = htmlString, Fname = strFileNameOut });

                return await ConvertResponseMessageToIActionResult(returnResponse, strFileNameOut);
            }
            catch (Exception ex)
            {
                throw new CustomJsonException(ex.Message, ex);
            }
        }

        #endregion Mid term evaluation

        #region Change cost code for temporary assignment

        // PUPPETEER PDF - OBSOLETE (Not in use)
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DigiFormHelper.ActionProgEvalPrint)]
        public async Task<IActionResult> ChangeCostCodeForTemporaryAssignmentPrint(string id)
        {
            try
            {
                if (id == null)
                {
                    return NotFound();
                }

                var result = await _costcodeChangeRequestDetailRepository.CostcodeChangeRequestDetail(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PKeyId = id
                    });

                if (result == null)
                {
                    return NotFound();
                }
                if (result.PMessageType == IsOk)
                {
                    //costcodeChangeRequestEditViewModel.KeyId = id;
                    //costcodeChangeRequestEditViewModel.TransferType = result.PTransferTypeVal;
                    //costcodeChangeRequestEditViewModel.EmpNo = result.PEmpNo;
                    //costcodeChangeRequestEditViewModel.CurrentCostcode = result.PCurrentCostcodeVal;
                    //costcodeChangeRequestEditViewModel.CurrentCostcodeName = result.PCurrentCostcodeVal + " - " + result.PCurrentCostcodeText;
                    //costcodeChangeRequestEditViewModel.TargetCostcode = result.PTargetCostcodeVal;
                    //costcodeChangeRequestEditViewModel.TransferDate = result.PTransferDate;
                    //costcodeChangeRequestEditViewModel.Remarks = result.PRemarks;
                    //costcodeChangeRequestEditViewModel.SiteCode = result.PSiteCode;
                }
                var employeeDetails = await _commonEmployeeDetailsRepository.EmployeeDetailAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL { PEmpno = result.PEmpNo });

                string htmlString = string.Empty;

                string _uriGetPdf = "PDFGenerator/ConvertHtmlToPdf";

                string fileName = "ChangeCostCodeForTemporaryAssignmentPrint.txt";

                string filePath = StorageHelper.GetTemplateFilePath(StorageHelper.DigiForm.RepositoryDigiForm, FileName: fileName, Configuration);

                using (StreamReader r = new StreamReader(filePath))
                {
                    htmlString = r.ReadToEnd();
                }

                if (!String.IsNullOrEmpty(htmlString))
                {
                    DateTime currDate = DateTime.Now;

                    //htmlString = htmlString.Replace("PDate", (!String.IsNullOrEmpty(result.PTransferDate.ToString()) ? result.PTransferDate.Value.ToString("dd-MMM-yyyy") : string.Empty));
                    //htmlString = htmlString.Replace("PFromNameOfEmp", (!String.IsNullOrEmpty(employeeDetails.PName) ? employeeDetails.PName.ToString() : string.Empty));

                    htmlString = htmlString.Replace("PDate", "PDateXXXX");
                    htmlString = htmlString.Replace("PFromNameOfEmp", "PFromNameOfEmpXXXX");
                    htmlString = htmlString.Replace("PNameOfEmp", "PNameOfEmpXXXX");
                    htmlString = htmlString.Replace("PEmpNo", "PEmpNoXXXX");
                    htmlString = htmlString.Replace("PParentCode", "PParentCodeXXXX");
                    htmlString = htmlString.Replace("PAssignCode", "PAssignCodeXXXX");
                    htmlString = htmlString.Replace("PTransferDate", "PTransferDateXXXX");
                    htmlString = htmlString.Replace("PRemarks", "PRemarksXXXX");
                    htmlString = htmlString.Replace("PHodOfParentCostCode", "PHodOfParentCostCodeXXXX");
                    htmlString = htmlString.Replace("PHodOfAssignCostCode", "PHodOfAssignCostCodeXXXX");
                    htmlString = htmlString.Replace("PAssignedHodDate", "PAssignedHodDateXXXX");
                    htmlString = htmlString.Replace("PHrDate", "PHrDateXXXX");
                    htmlString = htmlString.Replace("PHodOfParentCostCode", "PHodOfParentCostCodeXXXX");
                    htmlString = htmlString.Replace("PHodOfTransferCostCode", "PHodOfTransferCostCodeXXXX");
                    htmlString = htmlString.Replace("PNameOfEmp", "PNameOfEmp XXXX");
                    htmlString = htmlString.Replace("PEffectiveDate", "PEffectiveDateXXXX");
                    htmlString = htmlString.Replace("PHodOfTransferredCostCentre", "PHodOfTransferredCostCentreXXXX");
                    htmlString = htmlString.Replace("PHodDate", "PHodDateXXXX");
                    htmlString = htmlString.Replace("PNameOfEmp  ", "PNameOfEmpXXXX");
                    htmlString = htmlString.Replace("PRedesigned ", "PRedesigned XXXX");
                }
                else
                {
                    htmlString = "<br/> <br/>";
                    htmlString = filePath + "-Template not found, contact system administrator !!!";
                }
                string strFileNameOut = String.Format("CostCodeForPermanentTransfer_0181-027-07_{0}_{1}.{2}", employeeDetails.PName.ToString(), DateTime.Now.ToString("yyyyMMdd_HHmm"), "pdf");

                var returnResponse = await _httpClientWebApi.ExecutePostUriAsync(new HCModel(), _uriGetPdf, new Classes.HCModel { Htmlcontent = htmlString, Fname = strFileNameOut });

                return await ConvertResponseMessageToIActionResult(returnResponse, strFileNameOut);
            }
            catch (Exception ex)
            {
                throw new CustomJsonException(ex.Message, ex);
            }
        }

        // XML / DOC
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DigiFormHelper.ActionProgEvalPrint)]
        public async Task<IActionResult> ChangeCostCodeForTemporaryAssignmentXmlPrint(string id)
        {
            try
            {
                if (id == null)
                {
                    return NotFound();
                }

                var result = await _costcodeChangeRequestDetailRepository.CostcodeChangeRequestDetail(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PKeyId = id
                    });

                if (result == null)
                {
                    return NotFound();
                }
                if (result.PMessageType == IsOk)
                {
                    //costcodeChangeRequestEditViewModel.KeyId = id;
                    //costcodeChangeRequestEditViewModel.TransferType = result.PTransferTypeVal;
                    //costcodeChangeRequestEditViewModel.EmpNo = result.PEmpNo;
                    //costcodeChangeRequestEditViewModel.CurrentCostcode = result.PCurrentCostcodeVal;
                    //costcodeChangeRequestEditViewModel.CurrentCostcodeName = result.PCurrentCostcodeVal + " - " + result.PCurrentCostcodeText;
                    //costcodeChangeRequestEditViewModel.TargetCostcode = result.PTargetCostcodeVal;
                    //costcodeChangeRequestEditViewModel.TransferDate = result.PTransferDate;
                    //costcodeChangeRequestEditViewModel.Remarks = result.PRemarks;
                    //costcodeChangeRequestEditViewModel.SiteCode = result.PSiteCode;
                }
                var employeeDetails = await _commonEmployeeDetailsRepository.EmployeeDetailAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL { PEmpno = result.PEmpNo });

                string htmlString = string.Empty;

                string _uriGetXmlDoc = "HtmlToOpenXml/ConvertHtmlToWord";

                string fileName = "ChangeCostCodeForTemporaryAssignmentXmlPrint.txt";

                string filePath = StorageHelper.GetTemplateFilePath(StorageHelper.DigiForm.RepositoryDigiForm, FileName: fileName, Configuration);

                using (StreamReader r = new StreamReader(filePath))
                {
                    htmlString = r.ReadToEnd();
                }

                if (!String.IsNullOrEmpty(htmlString))
                {
                    DateTime currDate = DateTime.Now;

                    //htmlString = htmlString.Replace("PDate", (!String.IsNullOrEmpty(result.PTransferDate.ToString()) ? result.PTransferDate.Value.ToString("dd-MMM-yyyy") : string.Empty));
                    //htmlString = htmlString.Replace("PFromNameOfEmp", (!String.IsNullOrEmpty(employeeDetails.PName) ? employeeDetails.PName.ToString() : string.Empty));

                    htmlString = htmlString.Replace("PDate", "PDateXXXX");
                    htmlString = htmlString.Replace("PFromNameOfEmp", "PFromNameOfEmpXXXX");
                    htmlString = htmlString.Replace("PNameOfEmp", "PNameOfEmpXXXX");
                    htmlString = htmlString.Replace("PEmpNo", "PEmpNoXXXX");
                    htmlString = htmlString.Replace("PParentCode", "PParentCodeXXXX");
                    htmlString = htmlString.Replace("PAssignCode", "PAssignCodeXXXX");
                    htmlString = htmlString.Replace("PTransferDate", "PTransferDateXXXX");
                    htmlString = htmlString.Replace("PRemarks", "PRemarksXXXX");
                    htmlString = htmlString.Replace("PHodOfParentCostCode", "PHodOfParentCostCodeXXXX");
                    htmlString = htmlString.Replace("PHodOfAssignCostCode", "PHodOfAssignCostCodeXXXX");
                    htmlString = htmlString.Replace("PAssignedHodDate", "PAssignedHodDateXXXX");
                    htmlString = htmlString.Replace("PHrDate", "PHrDateXXXX");
                    htmlString = htmlString.Replace("PHodOfParentCostCode", "PHodOfParentCostCodeXXXX");
                    htmlString = htmlString.Replace("PHodOfTransferCostCode", "PHodOfTransferCostCodeXXXX");
                    htmlString = htmlString.Replace("PNameOfEmp", "PNameOfEmp XXXX");
                    htmlString = htmlString.Replace("PEffectiveDate", "PEffectiveDateXXXX");
                    htmlString = htmlString.Replace("PHodOfTransferredCostCentre", "PHodOfTransferredCostCentreXXXX");
                    htmlString = htmlString.Replace("PHodDate", "PHodDateXXXX");
                    htmlString = htmlString.Replace("PNameOfEmp  ", "PNameOfEmpXXXX");
                    htmlString = htmlString.Replace("PRedesigned ", "PRedesigned XXXX");
                }
                else
                {
                    htmlString = "<br/> <br/>";
                    htmlString = filePath + "-Template not found, contact system administrator !!!";
                }
                string strFileNameOut = String.Format("CostCodeForPermanentTransfer_0181-027-07_{0}_{1}.{2}", employeeDetails.PName.ToString(), DateTime.Now.ToString("yyyyMMdd_HHmm"), "doc");

                var returnResponse = await _httpClientWebApi.ExecutePostUriAsync(new HCModel(), _uriGetXmlDoc, new Classes.HCModel { Htmlcontent = htmlString, Fname = strFileNameOut });

                return await ConvertResponseMessageToIActionResult(returnResponse, strFileNameOut);
            }
            catch (Exception ex)
            {
                throw new CustomJsonException(ex.Message, ex);
            }
        }

        #endregion Change cost code for temporary assignment

        #region Change cost code for permanent transfer

        // PUPPETEER PDF - OBSOLETE (Not in use)
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DigiFormHelper.ActionProgEvalPrint)]
        public async Task<IActionResult> ChangeCostCodeForPermanentTransferPrint(string id)
        {
            try
            {
                if (id == null)
                {
                    return NotFound();
                }

                var result = await _costcodeChangeRequestDetailRepository.CostcodeChangeRequestDetail(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PKeyId = id
                    });

                if (result == null)
                {
                    return NotFound();
                }
                if (result.PMessageType == IsOk)
                {
                    //costcodeChangeRequestEditViewModel.KeyId = id;
                    //costcodeChangeRequestEditViewModel.TransferType = result.PTransferTypeVal;
                    //costcodeChangeRequestEditViewModel.EmpNo = result.PEmpNo;
                    //costcodeChangeRequestEditViewModel.CurrentCostcode = result.PCurrentCostcodeVal;
                    //costcodeChangeRequestEditViewModel.CurrentCostcodeName = result.PCurrentCostcodeVal + " - " + result.PCurrentCostcodeText;
                    //costcodeChangeRequestEditViewModel.TargetCostcode = result.PTargetCostcodeVal;
                    //costcodeChangeRequestEditViewModel.TransferDate = result.PTransferDate;
                    //costcodeChangeRequestEditViewModel.Remarks = result.PRemarks;
                    //costcodeChangeRequestEditViewModel.SiteCode = result.PSiteCode;
                }
                var employeeDetails = await _commonEmployeeDetailsRepository.EmployeeDetailAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL { PEmpno = result.PEmpNo });

                string htmlString = string.Empty;

                string _uriGetPdf = "PDFGenerator/ConvertHtmlToPdf";
                string fileName = "ChangeCostCodeForPermanentTransferPrint.txt";

                string filePath = StorageHelper.GetTemplateFilePath(StorageHelper.DigiForm.RepositoryDigiForm, FileName: fileName, Configuration);

                using (StreamReader r = new StreamReader(filePath))
                {
                    htmlString = r.ReadToEnd();
                }

                if (!String.IsNullOrEmpty(htmlString))
                {
                    DateTime currDate = DateTime.Now;

                    //htmlString = htmlString.Replace("PDate", (!String.IsNullOrEmpty(result.PTransferDate.ToString()) ? result.PTransferDate.Value.ToString("dd-MMM-yyyy") : string.Empty));
                    //htmlString = htmlString.Replace("PFromNameOfEmp", (!String.IsNullOrEmpty(employeeDetails.PName) ? employeeDetails.PName.ToString() : string.Empty));

                    htmlString = htmlString.Replace("PDate", "PDateXXXX");
                    htmlString = htmlString.Replace("PFromNameOfEmp", "PFromNameOfEmpXXXX");
                    htmlString = htmlString.Replace("PNameOfEmp", "PNameOfEmpXXXX");
                    htmlString = htmlString.Replace("PEmpNo", "PEmpNoXXXX");
                    htmlString = htmlString.Replace("PParentCode", "PParentCodeXXXX");
                    htmlString = htmlString.Replace("PAssignCode", "PAssignCodeXXXX");
                    htmlString = htmlString.Replace("PTransferDate", "PTransferDateXXXX");
                    htmlString = htmlString.Replace("PRemarks", "PRemarksXXXX");
                    htmlString = htmlString.Replace("PHodOfParentCostCode", "PHodOfParentCostCodeXXXX");
                    htmlString = htmlString.Replace("PHodOfAssignCostCode", "PHodOfAssignCostCodeXXXX");
                    htmlString = htmlString.Replace("PAssignedHodDate", "PAssignedHodDateXXXX");
                    htmlString = htmlString.Replace("PHrDate", "PHrDateXXXX");
                    htmlString = htmlString.Replace("PHodOfParentCostCode", "PHodOfParentCostCodeXXXX");
                    htmlString = htmlString.Replace("PHodOfTransferCostCode", "PHodOfTransferCostCodeXXXX");
                    htmlString = htmlString.Replace("PNameOfEmp", "PNameOfEmp XXXX");
                    htmlString = htmlString.Replace("PEffectiveDate", "PEffectiveDateXXXX");
                    htmlString = htmlString.Replace("PHodOfTransferredCostCentre", "PHodOfTransferredCostCentreXXXX");
                    htmlString = htmlString.Replace("PHodDate", "PHodDateXXXX");
                    htmlString = htmlString.Replace("PNameOfEmp  ", "PNameOfEmpXXXX");
                    htmlString = htmlString.Replace("PRedesigned ", "PRedesigned XXXX");
                }
                else
                {
                    htmlString = "<br/> <br/>";
                    htmlString = filePath + "-Template not found, contact system administrator !!!";
                }
                string strFileNameOut = String.Format("CostCodeForPermanentTransfer_0181-030-08_{0}_{1}.{2}", employeeDetails.PName.ToString(), DateTime.Now.ToString("yyyyMMdd_HHmm"), "pdf");

                var returnResponse = await _httpClientWebApi.ExecutePostUriAsync(new HCModel(), _uriGetPdf, new Classes.HCModel { Htmlcontent = htmlString, Fname = strFileNameOut });

                return await ConvertResponseMessageToIActionResult(returnResponse, strFileNameOut);
            }
            catch (Exception ex)
            {
                throw new CustomJsonException(ex.Message, ex);
            }
        }

        // XML / DOC
        public async Task<IActionResult> ChangeCostCodeForPermanentTransferXmlPrint(string id)
        {
            try
            {
                if (id == null)
                {
                    return NotFound();
                }

                var result = await _costcodeChangeRequestDetailRepository.CostcodeChangeRequestDetail(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PKeyId = id
                    });

                if (result == null)
                {
                    return NotFound();
                }
                if (result.PMessageType == IsOk)
                {
                    //costcodeChangeRequestEditViewModel.KeyId = id;
                    //costcodeChangeRequestEditViewModel.TransferType = result.PTransferTypeVal;
                    //costcodeChangeRequestEditViewModel.EmpNo = result.PEmpNo;
                    //costcodeChangeRequestEditViewModel.CurrentCostcode = result.PCurrentCostcodeVal;
                    //costcodeChangeRequestEditViewModel.CurrentCostcodeName = result.PCurrentCostcodeVal + " - " + result.PCurrentCostcodeText;
                    //costcodeChangeRequestEditViewModel.TargetCostcode = result.PTargetCostcodeVal;
                    //costcodeChangeRequestEditViewModel.TransferDate = result.PTransferDate;
                    //costcodeChangeRequestEditViewModel.Remarks = result.PRemarks;
                    //costcodeChangeRequestEditViewModel.SiteCode = result.PSiteCode;
                }
                var employeeDetails = await _commonEmployeeDetailsRepository.EmployeeDetailAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL { PEmpno = result.PEmpNo });

                string htmlString = string.Empty;

                string _uriGetXmlDoc = "HtmlToOpenXml/ConvertHtmlToWord";
                string fileName = "ChangeCostCodeForPermanentTransferXmlPrint.txt";

                string filePath = StorageHelper.GetTemplateFilePath(StorageHelper.DigiForm.RepositoryDigiForm, FileName: fileName, Configuration);

                using (StreamReader r = new StreamReader(filePath))
                {
                    htmlString = r.ReadToEnd();
                }

                if (!String.IsNullOrEmpty(htmlString))
                {
                    DateTime currDate = DateTime.Now;

                    //htmlString = htmlString.Replace("PDate", (!String.IsNullOrEmpty(result.PTransferDate.ToString()) ? result.PTransferDate.Value.ToString("dd-MMM-yyyy") : string.Empty));
                    //htmlString = htmlString.Replace("PFromNameOfEmp", (!String.IsNullOrEmpty(employeeDetails.PName) ? employeeDetails.PName.ToString() : string.Empty));

                    htmlString = htmlString.Replace("PDate", "PDateXXXX");
                    htmlString = htmlString.Replace("PFromNameOfEmp", "PFromNameOfEmpXXXX");
                    htmlString = htmlString.Replace("PNameOfEmp", "PNameOfEmpXXXX");
                    htmlString = htmlString.Replace("PEmpNo", "PEmpNoXXXX");
                    htmlString = htmlString.Replace("PParentCode", "PParentCodeXXXX");
                    htmlString = htmlString.Replace("PAssignCode", "PAssignCodeXXXX");
                    htmlString = htmlString.Replace("PTransferDate", "PTransferDateXXXX");
                    htmlString = htmlString.Replace("PRemarks", "PRemarksXXXX");
                    htmlString = htmlString.Replace("PHodOfParentCostCode", "PHodOfParentCostCodeXXXX");
                    htmlString = htmlString.Replace("PHodOfAssignCostCode", "PHodOfAssignCostCodeXXXX");
                    htmlString = htmlString.Replace("PAssignedHodDate", "PAssignedHodDateXXXX");
                    htmlString = htmlString.Replace("PHrDate", "PHrDateXXXX");
                    htmlString = htmlString.Replace("PHodOfParentCostCode", "PHodOfParentCostCodeXXXX");
                    htmlString = htmlString.Replace("PHodOfTransferCostCode", "PHodOfTransferCostCodeXXXX");
                    htmlString = htmlString.Replace("PNameOfEmp", "PNameOfEmp XXXX");
                    htmlString = htmlString.Replace("PEffectiveDate", "PEffectiveDateXXXX");
                    htmlString = htmlString.Replace("PHodOfTransferredCostCentre", "PHodOfTransferredCostCentreXXXX");
                    htmlString = htmlString.Replace("PHodDate", "PHodDateXXXX");
                    htmlString = htmlString.Replace("PNameOfEmp  ", "PNameOfEmpXXXX");
                    htmlString = htmlString.Replace("PRedesigned ", "PRedesigned XXXX");
                }
                else
                {
                    htmlString = "<br/> <br/>";
                    htmlString = filePath + "-Template not found, contact system administrator !!!";
                }
                string strFileNameOut = String.Format("CostCodeForPermanentTransfer_0181-030-08_{0}_{1}.{2}", employeeDetails.PName.ToString(), DateTime.Now.ToString("yyyyMMdd_HHmm"), "doc");

                var returnResponse = await _httpClientWebApi.ExecutePostUriAsync(new HCModel(), _uriGetXmlDoc, new Classes.HCModel { Htmlcontent = htmlString, Fname = strFileNameOut });

                return await ConvertResponseMessageToIActionResult(returnResponse, strFileNameOut);
            }
            catch (Exception ex)
            {
                throw new CustomJsonException(ex.Message, ex);
            }
        }

        #endregion Change cost code for permanent transfer

        #region Change cost code form

        // PUPPETEER PDF - OBSOLETE (Not in use)
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DigiFormHelper.ActionProgEvalPrint)]
        public async Task<IActionResult> ChangeCostCodeForm(string id)
        {
            try
            {
                if (id == null)
                {
                    return NotFound();
                }

                var result = await _costcodeChangeRequestDetailRepository.CostcodeChangeRequestDetail(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PKeyId = id
                    });

                if (result == null)
                {
                    return NotFound();
                }
                if (result.PMessageType == IsOk)
                {
                    //costcodeChangeRequestEditViewModel.KeyId = id;
                    //costcodeChangeRequestEditViewModel.TransferType = result.PTransferTypeVal;
                    //costcodeChangeRequestEditViewModel.EmpNo = result.PEmpNo;
                    //costcodeChangeRequestEditViewModel.CurrentCostcode = result.PCurrentCostcodeVal;
                    //costcodeChangeRequestEditViewModel.CurrentCostcodeName = result.PCurrentCostcodeVal + " - " + result.PCurrentCostcodeText;
                    //costcodeChangeRequestEditViewModel.TargetCostcode = result.PTargetCostcodeVal;
                    //costcodeChangeRequestEditViewModel.TransferDate = result.PTransferDate;
                    //costcodeChangeRequestEditViewModel.Remarks = result.PRemarks;
                    //costcodeChangeRequestEditViewModel.SiteCode = result.PSiteCode;
                }
                var employeeDetails = await _commonEmployeeDetailsRepository.EmployeeDetailAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL { PEmpno = result.PEmpNo });

                string htmlString = string.Empty;

                string _uriGetPdf = "PDFGenerator/ConvertHtmlToPdf";
                string fileName = "ChangeCostCodeForm.txt";

                string filePath = StorageHelper.GetTemplateFilePath(StorageHelper.DigiForm.RepositoryDigiForm, FileName: fileName, Configuration);

                using (StreamReader r = new StreamReader(filePath))
                {
                    htmlString = r.ReadToEnd();
                }

                if (!String.IsNullOrEmpty(htmlString))
                {
                    DateTime currDate = DateTime.Now;

                    //htmlString = htmlString.Replace("PDate", (!String.IsNullOrEmpty(result.PTransferDate.ToString()) ? result.PTransferDate.Value.ToString("dd-MMM-yyyy") : string.Empty));
                    //htmlString = htmlString.Replace("PFromNameOfEmp", (!String.IsNullOrEmpty(employeeDetails.PName) ? employeeDetails.PName.ToString() : string.Empty));

                    htmlString = htmlString.Replace("PDate", "PDateXXXX");
                    htmlString = htmlString.Replace("PFromNameOfEmp", "PFromNameOfEmpXXXX");
                    htmlString = htmlString.Replace("PNameOfEmp", "PNameOfEmpXXXX");
                    htmlString = htmlString.Replace("PEmpNo", "PEmpNoXXXX");
                    htmlString = htmlString.Replace("PParentCode", "PParentCodeXXXX");
                    htmlString = htmlString.Replace("PAssignCode", "PAssignCodeXXXX");
                    htmlString = htmlString.Replace("PTransferDate", "PTransferDateXXXX");
                    htmlString = htmlString.Replace("PRemarks", "PRemarksXXXX");
                    htmlString = htmlString.Replace("PHodOfParentCostCode", "PHodOfParentCostCodeXXXX");
                    htmlString = htmlString.Replace("PHodOfAssignCostCode", "PHodOfAssignCostCodeXXXX");
                    htmlString = htmlString.Replace("PAssignedHodDate", "PAssignedHodDateXXXX");
                    htmlString = htmlString.Replace("PHrDate", "PHrDateXXXX");
                    htmlString = htmlString.Replace("PHodOfParentCostCode", "PHodOfParentCostCodeXXXX");
                    htmlString = htmlString.Replace("PHodOfTransferCostCode", "PHodOfTransferCostCodeXXXX");
                    htmlString = htmlString.Replace("PNameOfEmp", "PNameOfEmp XXXX");
                    htmlString = htmlString.Replace("PEffectiveDate", "PEffectiveDateXXXX");
                    htmlString = htmlString.Replace("PHodOfTransferredCostCentre", "PHodOfTransferredCostCentreXXXX");
                    htmlString = htmlString.Replace("PHodDate", "PHodDateXXXX");
                    htmlString = htmlString.Replace("PNameOfEmp  ", "PNameOfEmpXXXX");
                    htmlString = htmlString.Replace("PRedesigned ", "PRedesigned XXXX");
                }
                else
                {
                    htmlString = "<br/> <br/>";
                    htmlString = filePath + "-Template not found, contact system administrator !!!";
                }
                string strFileNameOut = String.Format("ChangeCostCodeForm-030-08_{0}_{1}.{2}", employeeDetails.PName.ToString(), DateTime.Now.ToString("yyyyMMdd_HHmm"), "pdf");

                var returnResponse = await _httpClientWebApi.ExecutePostUriAsync(new HCModel(), _uriGetPdf, new Classes.HCModel { Htmlcontent = htmlString, Fname = strFileNameOut });

                return await ConvertResponseMessageToIActionResult(returnResponse, strFileNameOut);
            }
            catch (Exception ex)
            {
                throw new CustomJsonException(ex.Message, ex);
            }
        }

        // XML / DOC
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DigiFormHelper.ActionProgEvalPrint)]
        public async Task<IActionResult> ChangeCostCodeFormXmlPrint(string id)
        {
            try
            {
                if (id == null)
                {
                    return NotFound();
                }

                var result = await _costcodeChangeRequestDetailRepository.CostcodeChangeRequestDetail(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PKeyId = id
                    });

                if (result == null)
                {
                    return NotFound();
                }
                if (result.PMessageType == IsOk)
                {
                    //costcodeChangeRequestEditViewModel.KeyId = id;
                    //costcodeChangeRequestEditViewModel.TransferType = result.PTransferTypeVal;
                    //costcodeChangeRequestEditViewModel.EmpNo = result.PEmpNo;
                    //costcodeChangeRequestEditViewModel.CurrentCostcode = result.PCurrentCostcodeVal;
                    //costcodeChangeRequestEditViewModel.CurrentCostcodeName = result.PCurrentCostcodeVal + " - " + result.PCurrentCostcodeText;
                    //costcodeChangeRequestEditViewModel.TargetCostcode = result.PTargetCostcodeVal;
                    //costcodeChangeRequestEditViewModel.TransferDate = result.PTransferDate;
                    //costcodeChangeRequestEditViewModel.Remarks = result.PRemarks;
                    //costcodeChangeRequestEditViewModel.SiteCode = result.PSiteCode;
                }
                var employeeDetails = await _commonEmployeeDetailsRepository.EmployeeDetailAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL { PEmpno = result.PEmpNo });

                string htmlString = string.Empty;

                string _uriGetXmlDoc = "HtmlToOpenXml/ConvertHtmlToWord";
                string fileName = "ChangeCostCodeFormXmlPrint.txt";

                string filePath = StorageHelper.GetTemplateFilePath(StorageHelper.DigiForm.RepositoryDigiForm, FileName: fileName, Configuration);

                using (StreamReader r = new StreamReader(filePath))
                {
                    htmlString = r.ReadToEnd();
                }

                if (!String.IsNullOrEmpty(htmlString))
                {
                    DateTime currDate = DateTime.Now;

                    //htmlString = htmlString.Replace("PDate", (!String.IsNullOrEmpty(result.PTransferDate.ToString()) ? result.PTransferDate.Value.ToString("dd-MMM-yyyy") : string.Empty));
                    //htmlString = htmlString.Replace("PFromNameOfEmp", (!String.IsNullOrEmpty(employeeDetails.PName) ? employeeDetails.PName.ToString() : string.Empty));

                    htmlString = htmlString.Replace("PDate", "PDateXXXX");
                    htmlString = htmlString.Replace("PFromNameOfEmp", "PFromNameOfEmpXXXX");
                    htmlString = htmlString.Replace("PNameOfEmp", "PNameOfEmpXXXX");
                    htmlString = htmlString.Replace("PEmpNo", "PEmpNoXXXX");
                    htmlString = htmlString.Replace("PParentCode", "PParentCodeXXXX");
                    htmlString = htmlString.Replace("PAssignCode", "PAssignCodeXXXX");
                    htmlString = htmlString.Replace("PTransferDate", "PTransferDateXXXX");
                    htmlString = htmlString.Replace("PRemarks", "PRemarksXXXX");
                    htmlString = htmlString.Replace("PHodOfParentCostCode", "PHodOfParentCostCodeXXXX");
                    htmlString = htmlString.Replace("PHodOfAssignCostCode", "PHodOfAssignCostCodeXXXX");
                    htmlString = htmlString.Replace("PAssignedHodDate", "PAssignedHodDateXXXX");
                    htmlString = htmlString.Replace("PHrDate", "PHrDateXXXX");
                    htmlString = htmlString.Replace("PHodOfParentCostCode", "PHodOfParentCostCodeXXXX");
                    htmlString = htmlString.Replace("PHodOfTransferCostCode", "PHodOfTransferCostCodeXXXX");
                    htmlString = htmlString.Replace("PNameOfEmp", "PNameOfEmp XXXX");
                    htmlString = htmlString.Replace("PEffectiveDate", "PEffectiveDateXXXX");
                    htmlString = htmlString.Replace("PHodOfTransferredCostCentre", "PHodOfTransferredCostCentreXXXX");
                    htmlString = htmlString.Replace("PHodDate", "PHodDateXXXX");
                    htmlString = htmlString.Replace("PNameOfEmp  ", "PNameOfEmpXXXX");
                    htmlString = htmlString.Replace("PRedesigned ", "PRedesigned XXXX");
                }
                else
                {
                    htmlString = "<br/> <br/>";
                    htmlString = filePath + "-Template not found, contact system administrator !!!";
                }
                string strFileNameOut = String.Format("ChangeCostCodeFormXmlPrint-030-08_{0}_{1}.{2}", employeeDetails.PName.ToString(), DateTime.Now.ToString("yyyyMMdd_HHmm"), "doc");

                var returnResponse = await _httpClientWebApi.ExecutePostUriAsync(new HCModel(), _uriGetXmlDoc, new Classes.HCModel { Htmlcontent = htmlString, Fname = strFileNameOut });

                return await ConvertResponseMessageToIActionResult(returnResponse, strFileNameOut);
            }
            catch (Exception ex)
            {
                throw new CustomJsonException(ex.Message, ex);
            }
        }

        #endregion Change cost code form

        #region Annual term evaluation

        // PUPPETEER PDF - OBSOLETE (Not in use)
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DigiFormHelper.ActionProgEvalPrint)]
        public async Task<IActionResult> AnnualTermEvaluationPrint(string id)
        {
            try
            {
                if (id == null)
                {
                    return NotFound();
                }

                var result = await _annualEvaluationDetailRepository.AnnualEvaluationDetails(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PKeyId = id
                    });

                if (result == null)
                {
                    return NotFound();
                }
                if (result.PMessageType == IsOk)
                {
                    //costcodeChangeRequestEditViewModel.KeyId = id;
                    //costcodeChangeRequestEditViewModel.TransferType = result.PTransferTypeVal;
                    //costcodeChangeRequestEditViewModel.EmpNo = result.PEmpNo;
                    //costcodeChangeRequestEditViewModel.CurrentCostcode = result.PCurrentCostcodeVal;
                    //costcodeChangeRequestEditViewModel.CurrentCostcodeName = result.PCurrentCostcodeVal + " - " + result.PCurrentCostcodeText;
                    //costcodeChangeRequestEditViewModel.TargetCostcode = result.PTargetCostcodeVal;
                    //costcodeChangeRequestEditViewModel.TransferDate = result.PTransferDate;
                    //costcodeChangeRequestEditViewModel.Remarks = result.PRemarks;
                    //costcodeChangeRequestEditViewModel.SiteCode = result.PSiteCode;
                }
                var employeeDetails = await _commonEmployeeDetailsRepository.EmployeeDetailAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL { PEmpno = result.PEmpno });

                string htmlString = string.Empty;

                string _uriGetPdf = "PDFGenerator/ConvertHtmlToPdf";
                string fileName = "DGAnnualEvaluationFormPrint.txt";

                string filePath = StorageHelper.GetTemplateFilePath(StorageHelper.DigiForm.RepositoryDigiForm, FileName: fileName, Configuration);

                using (StreamReader r = new StreamReader(filePath))
                {
                    htmlString = r.ReadToEnd();
                }

                if (!String.IsNullOrEmpty(htmlString))
                {
                    DateTime currDate = DateTime.Now;

                    //htmlString = htmlString.Replace("PDate", (!String.IsNullOrEmpty(result.PTransferDate.ToString()) ? result.PTransferDate.Value.ToString("dd-MMM-yyyy") : string.Empty));
                    //htmlString = htmlString.Replace("PFromNameOfEmp", (!String.IsNullOrEmpty(employeeDetails.PName) ? employeeDetails.PName.ToString() : string.Empty));

                    htmlString = htmlString.Replace("PName", employeeDetails.PName);
                    htmlString = htmlString.Replace("PEmpNo", employeeDetails.PForEmpno);
                    htmlString = htmlString.Replace("PDepartment", employeeDetails.PCostName);
                    htmlString = htmlString.Replace("PDesignation", employeeDetails.PDesgCode + "-" + employeeDetails.PDesgName);
                    htmlString = htmlString.Replace("PDateOfJoining", employeeDetails.PDoj.ToString("dd-MM-yyyy"));
                    htmlString = htmlString.Replace("PDateOfCompletionTrainingPeriod", employeeDetails.PDoj.AddYears(1).ToString("dd-MMM-yyyy"));
                    htmlString = htmlString.Replace("PLocation", employeeDetails.PCurrentOfficeLocation);
                    htmlString = htmlString.Replace("PTrainingPeriod", "Annual");
                    htmlString = htmlString.Replace("PAttendance", result.PAttendance);

                    htmlString = htmlString.Replace("PTraining1", result.PTraining1);
                    htmlString = htmlString.Replace("PTraining2", result.PTraining2);
                    htmlString = htmlString.Replace("PTraining3", result.PTraining3);
                    htmlString = htmlString.Replace("PTraining4", result.PTraining4);
                    htmlString = htmlString.Replace("PTraining5", result.PTraining5);

                    htmlString = htmlString.Replace("PFeedback1", result.PFeedback1);
                    htmlString = htmlString.Replace("PFeedback2", result.PFeedback2);
                    htmlString = htmlString.Replace("PFeedback3", result.PFeedback3);
                    htmlString = htmlString.Replace("PFeedback4", result.PFeedback4);
                    htmlString = htmlString.Replace("PFeedback5", result.PFeedback5);
                    htmlString = htmlString.Replace("PFeedback6", result.PFeedback6);

                    htmlString = htmlString.Replace("PHodDate", result.PHodApprovalDate);
                    htmlString = htmlString.Replace("PCommentsOfHr", result.PCommentsOfHr);
                }
                else
                {
                    htmlString = "<br/> <br/>";
                    htmlString = filePath + "-Template not found, contact system administrator !!!";
                }
                string strFileNameOut = String.Format("ChangeCostCodeForm-030-08_{0}_{1}.{2}", employeeDetails.PName.ToString(), DateTime.Now.ToString("yyyyMMdd_HHmm"), "pdf");

                var returnResponse = await _httpClientWebApi.ExecutePostUriAsync(new HCModel(), _uriGetPdf, new Classes.HCModel { Htmlcontent = htmlString, Fname = strFileNameOut });

                return await ConvertResponseMessageToIActionResult(returnResponse, strFileNameOut);
            }
            catch (Exception ex)
            {
                throw new CustomJsonException(ex.Message, ex);
            }
        }

        // XML / DOC
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DigiFormHelper.ActionProgEvalPrint)]
        public async Task<IActionResult> AnnualTermEvaluationXmlPrint(string id)
        {
            try
            {
                if (id == null)
                {
                    return NotFound();
                }

                var result = await _annualEvaluationDetailRepository.AnnualEvaluationDetails(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PKeyId = id
                    });

                if (result == null)
                {
                    return NotFound();
                }
                if (result.PMessageType == IsOk)
                {
                    //costcodeChangeRequestEditViewModel.KeyId = id;
                    //costcodeChangeRequestEditViewModel.TransferType = result.PTransferTypeVal;
                    //costcodeChangeRequestEditViewModel.EmpNo = result.PEmpNo;
                    //costcodeChangeRequestEditViewModel.CurrentCostcode = result.PCurrentCostcodeVal;
                    //costcodeChangeRequestEditViewModel.CurrentCostcodeName = result.PCurrentCostcodeVal + " - " + result.PCurrentCostcodeText;
                    //costcodeChangeRequestEditViewModel.TargetCostcode = result.PTargetCostcodeVal;
                    //costcodeChangeRequestEditViewModel.TransferDate = result.PTransferDate;
                    //costcodeChangeRequestEditViewModel.Remarks = result.PRemarks;
                    //costcodeChangeRequestEditViewModel.SiteCode = result.PSiteCode;
                }
                var employeeDetails = await _commonEmployeeDetailsRepository.EmployeeDetailAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL { PEmpno = result.PEmpno });

                string htmlString = string.Empty;

                string _uriGetXmlDoc = "HtmlToOpenXml/ConvertHtmlToWord";

                string fileName = "DGAnnualEvaluationFormXmlPrint.txt";

                string filePath = StorageHelper.GetTemplateFilePath(StorageHelper.DigiForm.RepositoryDigiForm, FileName: fileName, Configuration);

                string logoPath = Path.Combine(_environment.WebRootPath, @"img\maire_logo_large.png");

                using (StreamReader r = new StreamReader(filePath))
                {
                    htmlString = r.ReadToEnd();
                }

                if (!String.IsNullOrEmpty(htmlString))
                {
                    DateTime currDate = DateTime.Now;

                    byte[] bytes = System.IO.File.ReadAllBytes(logoPath);
                    string base64String = Convert.ToBase64String(bytes);

                    //using (Image image = Image.FromFile(logoPath))
                    //{
                    //    using (MemoryStream m = new MemoryStream())
                    //    {
                    //        image.Save(m, image.RawFormat);
                    //        byte[] imageBytes = m.ToArray();
                    //        string base64String = Convert.ToBase64String(imageBytes);

                    //        htmlString = htmlString.Replace("!~!Company_logo", (!String.IsNullOrEmpty(base64String) ? base64String.ToString().Trim() : string.Empty));
                    //    }
                    //}

                    htmlString = htmlString.Replace("!~!Company_logo", (!String.IsNullOrEmpty(base64String) ? base64String.ToString().Trim() : string.Empty));

                    //htmlString = htmlString.Replace("PDate", (!String.IsNullOrEmpty(result.PTransferDate.ToString()) ? result.PTransferDate.Value.ToString("dd-MMM-yyyy") : string.Empty));
                    //htmlString = htmlString.Replace("PFromNameOfEmp", (!String.IsNullOrEmpty(employeeDetails.PName) ? employeeDetails.PName.ToString() : string.Empty));

                    htmlString = htmlString.Replace("PName", employeeDetails.PName);
                    htmlString = htmlString.Replace("PEmpNo", employeeDetails.PForEmpno);
                    htmlString = htmlString.Replace("PDepartment", employeeDetails.PCostName);
                    htmlString = htmlString.Replace("PDesignation", employeeDetails.PDesgCode + "-" + employeeDetails.PDesgName);
                    htmlString = htmlString.Replace("PDateOfJoining", employeeDetails.PDoj.ToString("dd-MM-yyyy"));
                    htmlString = htmlString.Replace("PDateOfCompletionTrainingPeriod", employeeDetails.PDoj.AddYears(1).ToString("dd-MMM-yyyy"));
                    htmlString = htmlString.Replace("PLocation", employeeDetails.PCurrentOfficeLocation);
                    htmlString = htmlString.Replace("PTrainingPeriod", "Annual");
                    htmlString = htmlString.Replace("PAttendance", result.PAttendance);

                    htmlString = htmlString.Replace("PTraining1", result.PTraining1);
                    htmlString = htmlString.Replace("PTraining2", result.PTraining2);
                    htmlString = htmlString.Replace("PTraining3", result.PTraining3);
                    htmlString = htmlString.Replace("PTraining4", result.PTraining4);
                    htmlString = htmlString.Replace("PTraining5", result.PTraining5);

                    htmlString = htmlString.Replace("PFeedback1", result.PFeedback1);
                    htmlString = htmlString.Replace("PFeedback2", result.PFeedback2);
                    htmlString = htmlString.Replace("PFeedback3", result.PFeedback3);
                    htmlString = htmlString.Replace("PFeedback4", result.PFeedback4);
                    htmlString = htmlString.Replace("PFeedback5", result.PFeedback5);
                    htmlString = htmlString.Replace("PFeedback6", result.PFeedback6);

                    htmlString = htmlString.Replace("PHodDate", result.PHodApprovalDate);
                    htmlString = htmlString.Replace("PCommentsOfHr", result.PCommentsOfHr);
                }
                else
                {
                    htmlString = "<br/> <br/>";
                    htmlString = filePath + "-Template not found, contact system administrator !!!";
                }
                string strFileNameOut = String.Format("ChangeCostCodeForm-030-08_{0}_{1}.{2}", employeeDetails.PName.ToString(), DateTime.Now.ToString("yyyyMMdd_HHmm"), "doc");

                var returnResponse = await _httpClientWebApi.ExecutePostUriAsync(new HCModel(), _uriGetXmlDoc, new Classes.HCModel { Htmlcontent = htmlString, Fname = strFileNameOut });

                return await ConvertResponseMessageToIActionResult(returnResponse, strFileNameOut);
            }
            catch (Exception ex)
            {
                throw new CustomJsonException(ex.Message, ex);
            }
        }

        #endregion Annual term evaluation

        #endregion Print PDF / WORD

        #region Filter

        public async Task<IActionResult> ResetFilter(string ActionId)
        {
            try
            {
                Domain.Models.FilterReset result = await _filterRepository.FilterResetAsync(new Domain.Models.FilterReset
                {
                    PModuleName = CurrentUserIdentity.CurrentModule,
                    PMetaId = CurrentUserIdentity.MetaId,
                    PPersonId = CurrentUserIdentity.EmployeeId,
                    PMvcActionName = ActionId,
                });

                return Json(new { success = result.OutPSuccess == IsOk, response = result.OutPMessage });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        private async Task<Domain.Models.FilterCreate> CreateFilter(string jsonFilter, string ActionName)
        {
            Domain.Models.FilterCreate retVal = await _filterRepository.FilterCreateAsync(new Domain.Models.FilterCreate
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ActionName,
                PFilterJson = jsonFilter
            });
            return retVal;
        }

        private async Task<Domain.Models.FilterRetrieve> RetriveFilter(string ActionName)
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ActionName
            });
            return retVal;
        }

        public async Task<IActionResult> HRMidTermEvaluationFilterGet()
        {
            Domain.Models.FilterRetrieve retVal = await RetriveFilter(ConstFilterHRMidEvaluationIndex);

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            IEnumerable<DataField> gradeList = await _selectTcmPLRepository.HrMisGradeList(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            ViewData["GradeList"] = new SelectList(gradeList, "DataValueField", "DataTextField");

            IEnumerable<DataField> costCodeList = await _selectTcmPLRepository.HRMISDeptList(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            ViewData["CostCodeList"] = new SelectList(costCodeList, "DataValueField", "DataTextField");

            return PartialView("_ModalHRMidTermEvaluationFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> HRMidTermEvaluationFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                string jsonFilter;
                jsonFilter = JsonConvert.SerializeObject(
                        new
                        {
                            Grade = filterDataModel.Grade,
                            Parent = filterDataModel.Parent
                        });

                Domain.Models.FilterCreate retVal = await CreateFilter(jsonFilter, ConstFilterHRMidEvaluationIndex);

                return Json(new
                {
                    success = true,
                    grade = filterDataModel.Grade,
                    parent = filterDataModel.Parent
                });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        public async Task<IActionResult> HODMidTermEvaluationFilterGet()
        {
            Domain.Models.FilterRetrieve retVal = await RetriveFilter(ConstFilterHODMidEvaluationIndex);

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            IEnumerable<DataField> gradeList = await _selectTcmPLRepository.HrMisGradeList(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            ViewData["GradeList"] = new SelectList(gradeList, "DataValueField", "DataTextField");

            IEnumerable<DataField> costCodeList = await _selectTcmPLRepository.HRMISDeptList(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            ViewData["CostCodeList"] = new SelectList(costCodeList, "DataValueField", "DataTextField");

            return PartialView("_ModalHODMidTermEvaluationFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> HODMidTermEvaluationFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                string jsonFilter;
                jsonFilter = JsonConvert.SerializeObject(
                        new
                        {
                            Grade = filterDataModel.Grade,
                            Parent = filterDataModel.Parent
                        });

                Domain.Models.FilterCreate retVal = await CreateFilter(jsonFilter, ConstFilterHODMidEvaluationIndex);

                return Json(new
                {
                    success = true,
                    grade = filterDataModel.Grade,
                    parent = filterDataModel.Parent
                });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        #region AnnualEvaluation

        public async Task<IActionResult> HODAnnualEvaluationPendingFilterGet()
        {
            Domain.Models.FilterRetrieve retVal = await RetriveFilter(ConstFilterHODAnnualEvaluationPendingIndex);

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            IEnumerable<DataField> gradeList = await _selectTcmPLRepository.HrMisGradeList(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            ViewData["GradeList"] = new SelectList(gradeList, "DataValueField", "DataTextField");

            IEnumerable<DataField> costCodeList = await _selectTcmPLRepository.HRMISDeptList(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            ViewData["CostCodeList"] = new SelectList(costCodeList, "DataValueField", "DataTextField");

            return PartialView("_ModalHODAnnualEvaluationPendingFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> HODAnnualEvaluationPendingFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                string jsonFilter;
                jsonFilter = JsonConvert.SerializeObject(
                        new
                        {
                            Grade = filterDataModel.Grade,
                            Parent = filterDataModel.Parent
                        });

                Domain.Models.FilterCreate retVal = await CreateFilter(jsonFilter, ConstFilterHODAnnualEvaluationPendingIndex);

                return Json(new
                {
                    success = true,
                    grade = filterDataModel.Grade,
                    parent = filterDataModel.Parent
                });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        public async Task<IActionResult> HODAnnualEvaluationHistoryFilterGet()
        {
            Domain.Models.FilterRetrieve retVal = await RetriveFilter(ConstFilterHODAnnualEvaluationHistoryIndex);

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            IEnumerable<DataField> gradeList = await _selectTcmPLRepository.HrMisGradeList(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            ViewData["GradeList"] = new SelectList(gradeList, "DataValueField", "DataTextField");

            IEnumerable<DataField> costCodeList = await _selectTcmPLRepository.HRMISDeptList(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            ViewData["CostCodeList"] = new SelectList(costCodeList, "DataValueField", "DataTextField");

            return PartialView("_ModalHODAnnualEvaluationHistoryFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> HODAnnualEvaluationHistoryFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                string jsonFilter;
                jsonFilter = JsonConvert.SerializeObject(
                        new
                        {
                            Grade = filterDataModel.Grade,
                            Parent = filterDataModel.Parent
                        });

                Domain.Models.FilterCreate retVal = await CreateFilter(jsonFilter, ConstFilterHODAnnualEvaluationHistoryIndex);

                return Json(new
                {
                    success = true,
                    grade = filterDataModel.Grade,
                    parent = filterDataModel.Parent
                });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        public async Task<IActionResult> HRAnnualEvaluationPendingFilterGet()
        {
            Domain.Models.FilterRetrieve retVal = await RetriveFilter(ConstFilterHRAnnualEvaluationPendingIndex);

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            IEnumerable<DataField> gradeList = await _selectTcmPLRepository.HrMisGradeList(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            ViewData["GradeList"] = new SelectList(gradeList, "DataValueField", "DataTextField");

            IEnumerable<DataField> costCodeList = await _selectTcmPLRepository.HRAnnualEvalPendingList(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            ViewData["CostCodeList"] = new SelectList(costCodeList, "DataValueField", "DataTextField");

            return PartialView("_ModalHRAnnualEvaluationPendingFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> HRAnnualEvaluationPendingFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                string jsonFilter;
                jsonFilter = JsonConvert.SerializeObject(
                        new
                        {
                            Grade = filterDataModel.Grade,
                            Parent = filterDataModel.Parent
                        });

                Domain.Models.FilterCreate retVal = await CreateFilter(jsonFilter, ConstFilterHRAnnualEvaluationPendingIndex);

                return Json(new
                {
                    success = true,
                    grade = filterDataModel.Grade,
                    parent = filterDataModel.Parent
                });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        public async Task<IActionResult> HRAnnualEvaluationHistoryFilterGet()
        {
            Domain.Models.FilterRetrieve retVal = await RetriveFilter(ConstFilterHRAnnualEvaluationHistoryIndex);

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            IEnumerable<DataField> gradeList = await _selectTcmPLRepository.HrMisGradeList(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            ViewData["GradeList"] = new SelectList(gradeList, "DataValueField", "DataTextField");

            IEnumerable<DataField> costCodeList = await _selectTcmPLRepository.HRMISDeptList(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            ViewData["CostCodeList"] = new SelectList(costCodeList, "DataValueField", "DataTextField");

            return PartialView("_ModalHRAnnualEvaluationHistoryFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> HRAnnualEvaluationHistoryFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                string jsonFilter;
                jsonFilter = JsonConvert.SerializeObject(
                        new
                        {
                            Grade = filterDataModel.Grade,
                            Parent = filterDataModel.Parent
                        });

                Domain.Models.FilterCreate retVal = await CreateFilter(jsonFilter, ConstFilterHRAnnualEvaluationHistoryIndex);

                return Json(new
                {
                    success = true,
                    grade = filterDataModel.Grade,
                    parent = filterDataModel.Parent
                });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        #endregion AnnualEvaluation

        #endregion Filter

        #region HOD Annual Evaluation

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DigiFormHelper.ActionProgEvalView)]
        public async Task<IActionResult> HODAnnualEvaluationPendingIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterHODAnnualEvaluationPendingIndex
            });

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            AnnualEvaluationIndexViewModel annualEvaluationIndexViewModel = new()
            {
                FilterDataModel = filterDataModel
            };
            return View(annualEvaluationIndexViewModel);
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DigiFormHelper.ActionProgEvalView)]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsHODAnnualEvaluationPendingList(string paramJson)
        {
            DTResult<AnnualEvaluationDataTableList> result = new();
            int totalRow = 0;
            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            try
            {
                System.Collections.Generic.IEnumerable<AnnualEvaluationDataTableList> data = await _annualEvaluationDataTableListRepository.HODAnnualEvaluationPendingDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch,
                        PGrade = param.Grade,
                        PParent = param.Parent,
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

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DigiFormHelper.ActionProgEvalView)]
        public async Task<IActionResult> HODAnnualEvaluationHistoryIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterHODAnnualEvaluationHistoryIndex
            });

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            AnnualEvaluationIndexViewModel annualEvaluationIndexViewModel = new()
            {
                FilterDataModel = filterDataModel
            };
            return View(annualEvaluationIndexViewModel);
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DigiFormHelper.ActionProgEvalView)]
        public async Task<JsonResult> GetListsHODAnnualEvaluationHistoryList(string paramJson)
        {
            DTResult<AnnualEvaluationDataTableList> result = new();
            int totalRow = 0;
            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            try
            {
                System.Collections.Generic.IEnumerable<AnnualEvaluationDataTableList> data = await _annualEvaluationDataTableListRepository.HODAnnualEvaluationHistoryDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch,
                        PGrade = param.Grade,
                        PParent = param.Parent,
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

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DigiFormHelper.ActionProgEvalUpdate)]
        public async Task<IActionResult> HODAnnualEvaluationEdit(string empno, string keyid)
        {
            if (empno == null)
            {
                return NotFound();
            }

            var validateEmployee = await _annualEvaluationRepository.AnnualEvaluationValidateEmployeeAsync(
                      BaseSpTcmPLGet(),
                      new ParameterSpTcmPL
                      {
                          PEmpno = empno
                      });

            if (validateEmployee.PMessageType == NotOk)
            {
                Notify("Error", validateEmployee.PMessageText, "", NotificationType.error);
                return RedirectToAction("HODAnnualEvaluationPendingIndex");
            }

            var employeeDetails = await _commonEmployeeDetailsRepository.EmployeeDetailAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL { PEmpno = empno });

            AnnualEvaluationEditViewModel annualEvaluationEditViewModel = new();

            annualEvaluationEditViewModel.Empno = empno;
            annualEvaluationEditViewModel.EmployeeName = employeeDetails.PName;
            annualEvaluationEditViewModel.DesgName = employeeDetails.PDesgCode + " -  " + employeeDetails.PDesgName;
            annualEvaluationEditViewModel.Parent = employeeDetails.PParent + " - " + employeeDetails.PCostName;
            annualEvaluationEditViewModel.Doj = employeeDetails.PDoj;
            annualEvaluationEditViewModel.EvaluationPeriod = employeeDetails.PDoj.AddYears(1).ToString("dd-MMM-yyyy");
            annualEvaluationEditViewModel.Location = employeeDetails.PCurrentOfficeLocation;

            if (keyid != "null")
            {
                AnnualEvaluationDetail result = await _annualEvaluationDetailRepository.AnnualEvaluationDetails(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PKeyId = keyid
                });

                annualEvaluationEditViewModel.KeyId = keyid;
                annualEvaluationEditViewModel.Attendance = result.PAttendance;
                annualEvaluationEditViewModel.Training1 = result.PTraining1;
                annualEvaluationEditViewModel.Training2 = result.PTraining2;
                annualEvaluationEditViewModel.Training3 = result.PTraining3;
                annualEvaluationEditViewModel.Training4 = result.PTraining4;
                annualEvaluationEditViewModel.Training5 = result.PTraining5;
                annualEvaluationEditViewModel.Feedback1 = result.PFeedback1;
                annualEvaluationEditViewModel.Feedback2 = result.PFeedback2;
                annualEvaluationEditViewModel.Feedback3 = result.PFeedback3;
                annualEvaluationEditViewModel.Feedback4 = result.PFeedback4;
                annualEvaluationEditViewModel.Feedback5 = result.PFeedback5;
                annualEvaluationEditViewModel.Feedback6 = result.PFeedback6;
                annualEvaluationEditViewModel.CommentsOfHr = result.PCommentsOfHr;
            }

            return View("HODAnnualEvaluationEdit", annualEvaluationEditViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DigiFormHelper.ActionProgEvalUpdate)]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> HODAnnualEvaluationEdit([FromForm] AnnualEvaluationEditViewModel annualEvaluationEditViewModel)
        {
            if (ModelState.IsValid)
            {
                var validateEmployee = await _annualEvaluationRepository.AnnualEvaluationValidateEmployeeAsync(
                      BaseSpTcmPLGet(),
                      new ParameterSpTcmPL
                      {
                          PEmpno = annualEvaluationEditViewModel.Empno
                      });

                if (validateEmployee.PMessageType == NotOk)
                {
                    Notify("Error", validateEmployee.PMessageText, "", NotificationType.error);
                    return RedirectToAction("HODAnnualEvaluationPendingIndex");
                }
                var employeeDetails = await _commonEmployeeDetailsRepository.EmployeeDetailAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL { PEmpno = annualEvaluationEditViewModel.Empno });

                annualEvaluationEditViewModel.EmployeeName = employeeDetails.PName;
                annualEvaluationEditViewModel.Desgcode = employeeDetails.PDesgCode;
                annualEvaluationEditViewModel.Parent = employeeDetails.PParent;
                annualEvaluationEditViewModel.Doj = employeeDetails.PDoj;
                annualEvaluationEditViewModel.Location = employeeDetails.PCurrentOfficeLocation;
                annualEvaluationEditViewModel.Isdeleted = 0;
                //annualEvaluationEditViewModel.CommentsOfHr = "NA";
                Domain.Models.Common.DBProcMessageOutput result;

                if (annualEvaluationEditViewModel.KeyId == null || annualEvaluationEditViewModel.KeyId == "null")
                {
                    result = await _annualEvaluationRepository.AnnualEvaluationEditAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PJsonObj = JsonConvert.SerializeObject(annualEvaluationEditViewModel)
                    });
                }
                else
                {
                    result = await _annualEvaluationRepository.AnnualEvaluationUpdateAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PKeyId = annualEvaluationEditViewModel.KeyId,
                        PJsonObj = JsonConvert.SerializeObject(annualEvaluationEditViewModel)
                    });
                }

                if (result.PMessageType == IsOk)
                {
                    Notify("Success", "Procedure executed successfully", "", NotificationType.success);

                    AnnualEvaluationGetKeyId getKeyId = await _annualEvaluationGetKeyIdRepository.AnnualEvaluationGetKeyId(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PEmpno = annualEvaluationEditViewModel.Empno,
                    });
                    return RedirectToAction("HODAnnualEvaluationEdit", new { empno = annualEvaluationEditViewModel.Empno, keyId = getKeyId.PKeyId });
                }
                else
                {
                    Notify("Error", result.PMessageText, "", NotificationType.error);
                }
            }

            var employeeDetails1 = await _commonEmployeeDetailsRepository.EmployeeDetailAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL { PEmpno = annualEvaluationEditViewModel.Empno });

            annualEvaluationEditViewModel.EmployeeName = employeeDetails1.PName;
            annualEvaluationEditViewModel.DesgName = employeeDetails1.PDesgCode + " -  " + employeeDetails1.PDesgName;
            annualEvaluationEditViewModel.Parent = employeeDetails1.PParent + " - " + employeeDetails1.PCostName;
            annualEvaluationEditViewModel.Doj = employeeDetails1.PDoj;
            annualEvaluationEditViewModel.EvaluationPeriod = employeeDetails1.PDoj.AddMonths(3).ToString("dd-MMM-yyyy");
            annualEvaluationEditViewModel.Location = employeeDetails1.PCurrentOfficeLocation;

            return View("HODAnnualEvaluationEdit", annualEvaluationEditViewModel);
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DigiFormHelper.ActionProgEvalUpdate)]
        public async Task<IActionResult> HODAnnualEvaluationDetails(string id, string empno)
        {
            AnnualEvaluationDetailsViewModel annualEvaluationDetailsViewModel = new();

            var employeeDetails = await _commonEmployeeDetailsRepository.EmployeeDetailAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL { PEmpno = empno });

            annualEvaluationDetailsViewModel.Empno = empno;
            annualEvaluationDetailsViewModel.EmployeeName = employeeDetails.PName;
            annualEvaluationDetailsViewModel.DesgName = employeeDetails.PDesgCode + " -  " + employeeDetails.PDesgName;
            annualEvaluationDetailsViewModel.CostName = employeeDetails.PParent + " - " + employeeDetails.PCostName;
            annualEvaluationDetailsViewModel.Doj = employeeDetails.PDoj;
            annualEvaluationDetailsViewModel.EvaluationPeriod = employeeDetails.PDoj.AddYears(1).ToString("dd-MMM-yyyy");
            annualEvaluationDetailsViewModel.Location = employeeDetails.PCurrentOfficeLocation;
            annualEvaluationDetailsViewModel.KeyId = id;

            var result = await _annualEvaluationDetailRepository.AnnualEvaluationDetails(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PKeyId = id
                });

            annualEvaluationDetailsViewModel.Attendance = result.PAttendance;
            annualEvaluationDetailsViewModel.Training1 = result.PTraining1;
            annualEvaluationDetailsViewModel.Training2 = result.PTraining2;
            annualEvaluationDetailsViewModel.Training3 = result.PTraining3;
            annualEvaluationDetailsViewModel.Training4 = result.PTraining4;
            annualEvaluationDetailsViewModel.Training5 = result.PTraining5;
            annualEvaluationDetailsViewModel.Feedback1 = result.PFeedback1;
            annualEvaluationDetailsViewModel.Feedback2 = result.PFeedback2;
            annualEvaluationDetailsViewModel.Feedback3 = result.PFeedback3;
            annualEvaluationDetailsViewModel.Feedback4 = result.PFeedback4;
            annualEvaluationDetailsViewModel.Feedback5 = result.PFeedback5;
            annualEvaluationDetailsViewModel.Feedback6 = result.PFeedback6;
            annualEvaluationDetailsViewModel.CommentOfHr = result.PCommentsOfHr;

            annualEvaluationDetailsViewModel.HodApproval = result.PHodApproval;

            annualEvaluationDetailsViewModel.HrApproval = result.PHrApproval;
            annualEvaluationDetailsViewModel.HrApproveBy = result.PHrApproveBy;
            annualEvaluationDetailsViewModel.HrApprovalDate = result.PHrApprovalDate;

            return View("HODAnnualEvaluationDetails", annualEvaluationDetailsViewModel);
        }

        #endregion HOD Annual Evaluation

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DigiFormHelper.ActionProgEvalSendToHr)]
        public async Task<IActionResult> AnnualEvaluationSendToHR(AnnualEvaluationEditViewModel annualEvaluationEditViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var employeeDetails = await _commonEmployeeDetailsRepository.EmployeeDetailAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL { PEmpno = annualEvaluationEditViewModel.Empno });

                    annualEvaluationEditViewModel.EmployeeName = employeeDetails.PName;
                    annualEvaluationEditViewModel.Desgcode = employeeDetails.PDesgCode;
                    annualEvaluationEditViewModel.Parent = employeeDetails.PParent;
                    annualEvaluationEditViewModel.Doj = employeeDetails.PDoj;
                    annualEvaluationEditViewModel.Location = employeeDetails.PCurrentOfficeLocation;
                    annualEvaluationEditViewModel.Isdeleted = 0;

                    Domain.Models.Common.DBProcMessageOutput result = await _annualEvaluationRepository.AnnualEvaluationSendToHRAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PEmpno = annualEvaluationEditViewModel.Empno,
                        PJsonObj = JsonConvert.SerializeObject(annualEvaluationEditViewModel)
                    }
                    );
                    if (result.PMessageType == IsOk)
                    {
                        Notify("Success", "Procedure executed successfully", "", NotificationType.success);
                        return RedirectToAction("HODAnnualEvaluationPendingIndex");
                    }
                    else
                    {
                        Notify("Error", result.PMessageText, "", NotificationType.error);
                    }
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }

            return RedirectToAction("HODAnnualEvaluationEdit", new { empno = annualEvaluationEditViewModel.Empno, keyId = annualEvaluationEditViewModel.KeyId });
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DigiFormHelper.ActionProgEvalSendToHod)]
        public async Task<IActionResult> AnnualEvaluationSendToHOD(string keyId)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _annualEvaluationRepository.AnnualEvaluationSendToHODAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PKeyId = keyId,
                    }
                    );
                    if (result.PMessageType == IsOk)
                    {
                        Notify("Success", "Procedure executed successfully", "", NotificationType.success);
                        return RedirectToAction("HRAnnualEvaluationPendingIndex");
                    }
                    else
                    {
                        Notify("Error", result.PMessageText, "", NotificationType.error);
                    }
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }

            return RedirectToAction("HRAnnualTermEvaluationEdit");
        }

        #region HR Annual Evaluation

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DigiFormHelper.ActionAnnualProgEvalActionHR)]
        public async Task<IActionResult> HRAnnualEvaluationPendingIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterHRAnnualEvaluationPendingIndex
            });

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            AnnualEvaluationIndexViewModel annualEvaluationIndexViewModel = new()
            {
                FilterDataModel = filterDataModel
            };
            return View(annualEvaluationIndexViewModel);
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DigiFormHelper.ActionAnnualProgEvalActionHR)]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsHRAnnualEvaluationPendingList(string paramJson)
        {
            DTResult<AnnualEvaluationDataTableList> result = new();
            int totalRow = 0;
            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            try
            {
                System.Collections.Generic.IEnumerable<AnnualEvaluationDataTableList> data = await _annualEvaluationDataTableListRepository.HRAnnualEvaluationPendingDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch,
                        PGrade = param.Grade,
                        PParent = param.Parent,
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

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DigiFormHelper.ActionAnnualProgEvalActionHR)]
        public async Task<IActionResult> HRAnnualEvaluationActionPendingIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterHRAnnualEvaluationActionPendingIndex
            });

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            AnnualEvaluationIndexViewModel annualEvaluationIndexViewModel = new()
            {
                FilterDataModel = filterDataModel
            };
            return View(annualEvaluationIndexViewModel);
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DigiFormHelper.ActionAnnualProgEvalActionHR)]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsHRAnnualEvaluationActionPendingList(string paramJson)
        {
            DTResult<AnnualEvaluationDataTableList> result = new();
            int totalRow = 0;
            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            try
            {
                System.Collections.Generic.IEnumerable<AnnualEvaluationDataTableList> data = await _annualEvaluationDataTableListRepository.HRAnnualEvaluationActionPendingDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch,
                        PGrade = param.Grade,
                        PParent = param.Parent,
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


        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DigiFormHelper.ActionAnnualProgEvalActionHR)]
        public async Task<IActionResult> HRAnnualEvaluationHistoryIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterHRMidEvaluationIndex
            });

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            AnnualEvaluationIndexViewModel annualEvaluationIndexViewModel = new()
            {
                FilterDataModel = filterDataModel
            };
            return View(annualEvaluationIndexViewModel);
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DigiFormHelper.ActionAnnualProgEvalActionHR)]
        public async Task<JsonResult> GetListsHRAnnualEvaluationHistoryList(string paramJson)
        {
            DTResult<AnnualEvaluationDataTableList> result = new();
            int totalRow = 0;
            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            try
            {
                System.Collections.Generic.IEnumerable<AnnualEvaluationDataTableList> data = await _annualEvaluationDataTableListRepository.HRAnnualEvaluationHistoryDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch,
                        PGrade = param.Grade,
                        PParent = param.Parent,
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

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DigiFormHelper.ActionAnnualProgEvalActionHR)]
        public async Task<IActionResult> HRAnnualEvaluationDetails(string id, string empno)
        {
            AnnualEvaluationDetailsViewModel annualEvaluationDetailsViewModel = new();

            var employeeDetails = await _commonEmployeeDetailsRepository.EmployeeDetailAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL { PEmpno = empno });

            annualEvaluationDetailsViewModel.Empno = empno;
            annualEvaluationDetailsViewModel.EmployeeName = employeeDetails.PName;
            annualEvaluationDetailsViewModel.DesgName = employeeDetails.PDesgCode + " -  " + employeeDetails.PDesgName;
            annualEvaluationDetailsViewModel.CostName = employeeDetails.PParent + " - " + employeeDetails.PCostName;
            annualEvaluationDetailsViewModel.Doj = employeeDetails.PDoj;
            annualEvaluationDetailsViewModel.EvaluationPeriod = employeeDetails.PDoj.AddYears(1).ToString("dd-MMM-yyyy");
            annualEvaluationDetailsViewModel.Location = employeeDetails.PCurrentOfficeLocation;
            annualEvaluationDetailsViewModel.KeyId = id;

            var result = await _annualEvaluationDetailRepository.AnnualEvaluationDetails(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PKeyId = id
                });

            annualEvaluationDetailsViewModel.Attendance = result.PAttendance;
            annualEvaluationDetailsViewModel.Training1 = result.PTraining1;
            annualEvaluationDetailsViewModel.Training2 = result.PTraining2;
            annualEvaluationDetailsViewModel.Training3 = result.PTraining3;
            annualEvaluationDetailsViewModel.Training4 = result.PTraining4;
            annualEvaluationDetailsViewModel.Training5 = result.PTraining5;
            annualEvaluationDetailsViewModel.Feedback1 = result.PFeedback1;
            annualEvaluationDetailsViewModel.Feedback2 = result.PFeedback2;
            annualEvaluationDetailsViewModel.Feedback3 = result.PFeedback3;
            annualEvaluationDetailsViewModel.Feedback4 = result.PFeedback4;
            annualEvaluationDetailsViewModel.Feedback5 = result.PFeedback5;
            annualEvaluationDetailsViewModel.Feedback6 = result.PFeedback6;
            annualEvaluationDetailsViewModel.CommentOfHr = result.PCommentsOfHr;

            annualEvaluationDetailsViewModel.HodApproval = result.PHodApproval;

            annualEvaluationDetailsViewModel.HrApproval = result.PHrApproval;
            annualEvaluationDetailsViewModel.HrApproveBy = result.PHrApproveBy;
            annualEvaluationDetailsViewModel.HrApprovalDate = result.PHrApprovalDate;

            return View("HRAnnualEvaluationDetails", annualEvaluationDetailsViewModel);
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DigiFormHelper.ActionAnnualProgEvalActionHR)]
        public async Task<IActionResult> HRAnnualEvaluationSendDetails(string id, string empno)
        {
            AnnualEvaluationDetailsViewModel annualEvaluationDetailsViewModel = new();

            var employeeDetails = await _commonEmployeeDetailsRepository.EmployeeDetailAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL { PEmpno = empno });

            annualEvaluationDetailsViewModel.Empno = empno;
            annualEvaluationDetailsViewModel.EmployeeName = employeeDetails.PName;
            annualEvaluationDetailsViewModel.DesgName = employeeDetails.PDesgCode + " -  " + employeeDetails.PDesgName;
            annualEvaluationDetailsViewModel.CostName = employeeDetails.PParent + " - " + employeeDetails.PCostName;
            annualEvaluationDetailsViewModel.Doj = employeeDetails.PDoj;
            annualEvaluationDetailsViewModel.EvaluationPeriod = employeeDetails.PDoj.AddYears(1).ToString("dd-MMM-yyyy");
            annualEvaluationDetailsViewModel.Location = employeeDetails.PCurrentOfficeLocation;
            annualEvaluationDetailsViewModel.KeyId = id;

            AnnualEvaluationDetail result = await _annualEvaluationDetailRepository.AnnualEvaluationDetails(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PKeyId = id
                });

            annualEvaluationDetailsViewModel.Attendance = result.PAttendance;
            annualEvaluationDetailsViewModel.Training1 = result.PTraining1;
            annualEvaluationDetailsViewModel.Training2 = result.PTraining2;
            annualEvaluationDetailsViewModel.Training3 = result.PTraining3;
            annualEvaluationDetailsViewModel.Training4 = result.PTraining4;
            annualEvaluationDetailsViewModel.Training5 = result.PTraining5;
            annualEvaluationDetailsViewModel.Feedback1 = result.PFeedback1;
            annualEvaluationDetailsViewModel.Feedback2 = result.PFeedback2;
            annualEvaluationDetailsViewModel.Feedback3 = result.PFeedback3;
            annualEvaluationDetailsViewModel.Feedback4 = result.PFeedback4;
            annualEvaluationDetailsViewModel.Feedback5 = result.PFeedback5;
            annualEvaluationDetailsViewModel.Feedback6 = result.PFeedback6;
            annualEvaluationDetailsViewModel.CommentOfHr = result.PCommentsOfHr;

            annualEvaluationDetailsViewModel.HodApproval = result.PHodApproval;

            annualEvaluationDetailsViewModel.HrApproval = result.PHrApproval;
            annualEvaluationDetailsViewModel.HrApproveBy = result.PHrApproveBy;
            annualEvaluationDetailsViewModel.HrApprovalDate = result.PHrApprovalDate;

            return View("HRAnnualEvaluationSendDetails", annualEvaluationDetailsViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DigiFormHelper.ActionAnnualProgEvalActionHR)]
        public async Task<IActionResult> AnnualEvaluationSaveHrComment(AnnualEvaluationDetailsViewModel annualEvaluationDetailsViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _annualEvaluationRepository.AnnualEvaluationSaveHrCommentAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    //PEmpno = annualEvaluationDetailsViewModel.Empno,
                    PKeyId = annualEvaluationDetailsViewModel.KeyId,
                    PHrComments = annualEvaluationDetailsViewModel.CommentOfHr
                }
                );
                    if (result.PMessageType == IsOk)
                    {
                        Notify("Success", "Procedure executed successfully", "", NotificationType.success);
                        return RedirectToAction("HRAnnualEvaluationSendDetails", new { empno = annualEvaluationDetailsViewModel.Empno, id = annualEvaluationDetailsViewModel.KeyId });
                    }
                    else
                    {
                        Notify("Error", result.PMessageText, "", NotificationType.error);
                    }


                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }

            return RedirectToAction("HRAnnualEvaluationSendDetails", new { empno = annualEvaluationDetailsViewModel.Empno, id = annualEvaluationDetailsViewModel.KeyId });
        }


        public async Task<IActionResult> HRAnnualEvaluationPendingExcelDownload()
        {

            var retVal = await RetriveFilter(ConstFilterHRAnnualEvaluationPendingIndex);

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            var timeStamp = DateTime.Now.ToFileTime();

            string fileName = "Annual Eval Pending List_" + timeStamp.ToString();
            string reportTitle = "HR Annual Evaluation Pending List";
            string sheetName = "Annual Evaluation Pending List";

            IEnumerable<AnnualEvaluationDataTableList> data = await _annualEvaluationDataTableListRepository.HRAnnualEvaluationPendingDataTableListForExcelAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PParent = filterDataModel.Parent
                });

            if (data == null) { return NotFound(); }

            var json = JsonConvert.SerializeObject(data);

            IEnumerable<HRAnnualEvaluationPendingDataTableListExcel> excelData = JsonConvert.DeserializeObject<IEnumerable<HRAnnualEvaluationPendingDataTableListExcel>>(json);

            var byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, reportTitle, sheetName);

            var mimeType = MimeTypeMap.GetMimeType("xlsx");

            FileContentResult file = File(byteContent, mimeType, fileName);

            return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
        }
        #endregion HR Annual Evaluation
    }
}