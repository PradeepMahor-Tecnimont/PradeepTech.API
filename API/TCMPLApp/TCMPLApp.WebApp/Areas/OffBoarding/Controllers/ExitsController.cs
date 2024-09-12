using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Text.Json;
using TCMPLApp.DataAccess.Repositories.OffBoarding;
using TCMPLApp.DataAccess.Repositories.SWPVaccine;
using TCMPLApp.WebApp.Controllers;
using TCMPLApp.WebApp.Models;
using TCMPLApp.Domain.Models.OffBoarding;
using Microsoft.AspNetCore.Http;
using TCMPLApp.Domain.Models;
using Microsoft.Extensions.Configuration;
using System.IO;
using TCMPLApp.WebApp.CustomPolicyProvider;
using System.Net;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.Common;

namespace TCMPLApp.WebApp.Areas.OffBoarding.Controllers
{
    [Area("OffBoarding")]
    public class ExitsController : BaseController
    {
        //private readonly static string InitiatorRoleId = "R05";
        //private readonly static string OffBoardingHelper.RoleCheckerApprover = "R04";
        //private readonly static string OffBoardingHelper.RoleMakerApprover = "R03";
        //private readonly static string OffBoardingHelper.RoleOffBoardingEmployeeHoD = "R02";
        //private readonly static string OffBoardingHelper.RoleOffBoardingFinalApprover = "R06";
        //private readonly static string PayrollMaker = "A08";
        //private readonly static string OffBoardingHelper.ActionCheckerPayroll = "A14";
        private static readonly string InititatorGroupName = "INITIATOR";

        private readonly IOffBoardingExitRepository _offBoardingExitRepository;
        private readonly IEmployeeDetailsRepository _employeeDetailsRepository;
        private readonly IUtilityRepository _utilityRepository;
        private readonly IConfiguration _configuration;
        private readonly ICommonEmployeeDetailsRepository _commonEmployeeDetailsRepository;

        public ExitsController(IOffBoardingExitRepository offBoardingExitRepository, IEmployeeDetailsRepository employeeDetailsRepository,
            IConfiguration configuration,
            IUtilityRepository utilityRepository,
            ICommonEmployeeDetailsRepository commonEmployeeDetailsRepository
         )
        {
            _offBoardingExitRepository = offBoardingExitRepository;
            _employeeDetailsRepository = employeeDetailsRepository;
            _configuration = configuration;
            _utilityRepository = utilityRepository;
            _commonEmployeeDetailsRepository = commonEmployeeDetailsRepository;
        }

        #region I N I T I A T O R

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, OffBoardingHelper.RoleInitiator)]
        public IActionResult Index()
        {
            return View();
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, OffBoardingHelper.RoleInitiator)]
        public async Task<IActionResult> GetExitsList()
        {
            var result = await _offBoardingExitRepository.GetExitsListAsync();
            return PartialView("_ExitsListPartial", result);
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, OffBoardingHelper.RoleInitiator)]
        public async Task<IActionResult> GetEmpDetails(string EmpNo)
        {
            if (string.IsNullOrEmpty(EmpNo))
            {
                return PartialView("_ExitsEmployeeDetailsPartial");
            }
            //var empDetails = await _employeeDetailsRepository.GetEmployeeDetailsAsync(EmpNo);
            var empDetails = await _commonEmployeeDetailsRepository.EmployeeDetailAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PEmpno = EmpNo
                });

            return PartialView("_ExitsEmployeeDetailsPartial", empDetails);
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, OffBoardingHelper.RoleInitiator)]
        public async Task<IActionResult> Create(string EmpNo)
        {
            var empList = await _offBoardingExitRepository.GetEmployeeForExitsSelectAsync();

            ViewData["Empno"] = new SelectList(empList, "Val", "Text", EmpNo);
            //return PartialView("_ExitsCreateFormPartial");
            return View("ExitsCreateForm");
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, OffBoardingHelper.RoleInitiator)]
        public async Task<IActionResult> Create(OffBoardingExitsCreateViewModel offBoardingExitsCreateViewModel)
        {
            var empList = await _offBoardingExitRepository.GetEmployeeForExitsSelectAsync();
            if (!ModelState.IsValid)
            {
                ViewData["Empno"] = new SelectList(empList, "Val", "Text", offBoardingExitsCreateViewModel.Empno);

                return View("ExitsCreateForm", offBoardingExitsCreateViewModel);
            }

            OffBoardingExitAddNew offBoardingExitAddNew = new OffBoardingExitAddNew
            {
                PEmpno = offBoardingExitsCreateViewModel.Empno,
                PEndByDate = offBoardingExitsCreateViewModel.EndByDate,
                PEntryByEmpno = CurrentUserIdentity.EmpNo,
                PRemarks = offBoardingExitsCreateViewModel.Remarks,
                PAddress = offBoardingExitsCreateViewModel.Address,
                PAlternateMobile = offBoardingExitsCreateViewModel.AlternateNumber,
                PPrimaryMobile = offBoardingExitsCreateViewModel.MobilePrimary,
                PRelieveDate = offBoardingExitsCreateViewModel.RelievingDate,
                PEmailId = offBoardingExitsCreateViewModel.EmailId,
                PResignDate = offBoardingExitsCreateViewModel.ResignationDate
            };

            var retVal = await _offBoardingExitRepository.ExitAddNewAsync(offBoardingExitAddNew);

            if (retVal.OutPSuccess == "OK")
            {
                Notify("Success", "Procedure executed successfully", "toaster", NotificationType.success);
                return RedirectToAction("EditForm", new { Empno = offBoardingExitsCreateViewModel.Empno });
            }
            else
            {
                ViewData["Empno"] = new SelectList(empList, "Val", "Text", offBoardingExitsCreateViewModel.Empno);
                Notify("Error", retVal.OutPMessage, "toaster", NotificationType.error);
                return View("ExitsCreateForm", offBoardingExitsCreateViewModel);
            }
        }

        public async Task<IActionResult> EditForm(string Empno)
        {
            var exitsDetails = await _offBoardingExitRepository.GetEmployeeExitDetails(Empno);
            if (exitsDetails.OverallApprovalStatus == "Approved")
            {
                return RedirectToAction("GetOffBoardingDetails", "Exits", new { Empno = Empno });
            }
            else
            {
                OffBoardingExitsCreateViewModel exitsEditDetails = new OffBoardingExitsCreateViewModel
                {
                    Address = exitsDetails.Address,
                    AlternateNumber = exitsDetails.AlternateNumber,
                    EmailId = exitsDetails.EmailId,
                    EmployeeName = exitsDetails.EmployeeName,
                    Empno = exitsDetails.Empno,
                    EndByDate = exitsDetails.EndByDate,
                    MobilePrimary = exitsDetails.MobilePrimary,
                    RelievingDate = exitsDetails.RelievingDate,
                    Remarks = exitsDetails.InitiatorRemarks,
                    ResignationDate = exitsDetails.ResignationDate
                };
                return View("ExitsEditForm", exitsEditDetails);
            }
        }

        [HttpPost]
        public async Task<IActionResult> EditForm(OffBoardingExitsCreateViewModel offBoardingExitsCreateViewModel)
        {
            if (!ModelState.IsValid)
            {
                return View("ExitsEditForm", offBoardingExitsCreateViewModel);
            }

            OffBoardingExitsModExit offBoardingExitsModExit = new OffBoardingExitsModExit
            {
                PAddress = offBoardingExitsCreateViewModel.Address,
                PAlternateMobile = offBoardingExitsCreateViewModel.AlternateNumber,
                PEmailId = offBoardingExitsCreateViewModel.EmailId,
                PEmpno = offBoardingExitsCreateViewModel.Empno,
                PEndByDate = offBoardingExitsCreateViewModel.EndByDate,
                PEntryByEmpno = CurrentUserIdentity.EmpNo,
                PPrimaryMobile = offBoardingExitsCreateViewModel.MobilePrimary,
                PRelieveDate = offBoardingExitsCreateViewModel.RelievingDate,
                PResignDate = offBoardingExitsCreateViewModel.ResignationDate,
                PRemarks = offBoardingExitsCreateViewModel.Remarks
            };
            var retVal = await _offBoardingExitRepository.ExitModifyAsync(offBoardingExitsModExit);

            if (retVal.OutPSuccess == "OK")
            {
                Notify("Success", "Procedure executed successfully", "toaster", NotificationType.success);
            }
            else
            {
                Notify("Error", retVal.OutPMessage, "toaster", NotificationType.error);
            }
            return View("ExitsEditForm", offBoardingExitsCreateViewModel);
        }

        public IActionResult InitiatorExcelDownload()
        {
            return PartialView("_ModalInitiatorExcelDownload");
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult InitiatorExcelDownloadSet(OffBoardingInitReportFilter offBoardingInitReportFilter)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    //string StrFimeName;

                    //var timeStamp = DateTime.Now.ToFileTime();
                    //StrFimeName = "OffBoardingEmployeeContactDetails_" + timeStamp.ToString();

                    //var exitsContactDetails = await _offBoardingExitRepository.GetEmployeeContactDetailsList(offBoardingInitReportFilter.StartDate, offBoardingInitReportFilter.EndDate);

                    //var byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(exitsContactDetails, "OffBoarding Employee Contact Details", "EmpContactDetails");
                    //return File(byteContent,
                    //    "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                    //StrFimeName + ".xlsx");
                }
                return PartialView("_ModalInitiatorExcelDownload", offBoardingInitReportFilter);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> InitiatorExcelDownloadFile(OffBoardingInitReportFilter offBoardingInitReportFilter)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    string StrFimeName;

                    var timeStamp = DateTime.Now.ToFileTime();
                    StrFimeName = "OffBoardingEmployeeContactDetails_" + timeStamp.ToString();

                    var exitsContactDetails = await _offBoardingExitRepository.GetEmployeeContactDetailsList(offBoardingInitReportFilter.StartDate, offBoardingInitReportFilter.EndDate);

                    var byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(exitsContactDetails, "OffBoarding Employee Contact Details", "EmpContactDetails");
                    return File(byteContent,
                        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                    StrFimeName + ".xlsx");
                }
                return PartialView("_ModalInitiatorExcelDownload", offBoardingInitReportFilter);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        #endregion I N I T I A T O R

        #region M A K E R

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, OffBoardingHelper.RoleMakerApprover)]
        public async Task<IActionResult> MakerExitsPending()
        {
            var actionAttributes = await _offBoardingExitRepository.GetActionAttributesAsync(ActionId: CurrentUserIdentity.ProfileActions.FirstOrDefault(t => t.RoleId == OffBoardingHelper.RoleMakerApprover).ActionId);
            ViewData["ActionAttributes"] = actionAttributes;

            var result = await _offBoardingExitRepository.MakerGetExitsPendingListAsync(CurrentUserIdentity.EmpNo);
            return View("MakerExitsPending", result);
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, OffBoardingHelper.RoleMakerApprover)]
        public async Task<IActionResult> MakerExitsHistory()
        {
            var actionAttributes = await _offBoardingExitRepository.GetActionAttributesAsync(ActionId: CurrentUserIdentity.ProfileActions.FirstOrDefault(t => t.RoleId == OffBoardingHelper.RoleMakerApprover).ActionId);
            ViewData["ActionAttributes"] = actionAttributes;

            var result = await _offBoardingExitRepository.MakerGetExitsHistoryListAsync(CurrentUserIdentity.EmpNo);
            return View("MakerExitsHistory", result);
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, OffBoardingHelper.RoleMakerApprover)]
        public async Task<IActionResult> MakerExitsDetail(string Empno)
        {
            var actionAttributes = await _offBoardingExitRepository.GetActionAttributesAsync(ActionId: CurrentUserIdentity.ProfileActions.FirstOrDefault(t => t.RoleId == OffBoardingHelper.RoleMakerApprover).ActionId);
            ViewData["ActionAttributes"] = actionAttributes;

            var result = await _offBoardingExitRepository.GetExitsApprovalDetailAsync(EmpNo: Empno, ActionId: actionAttributes.ActionId, RoleId: OffBoardingHelper.RoleMakerApprover);
            return View("MakerExitsDetail", result);
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, OffBoardingHelper.RoleMakerApprover)]
        public async Task<IActionResult> MakerExitsApprove(string Empno)
        {
            var actionAttributes = await _offBoardingExitRepository.GetActionAttributesAsync(ActionId: CurrentUserIdentity.ProfileActions.FirstOrDefault(t => t.RoleId == OffBoardingHelper.RoleMakerApprover).ActionId);
            ViewData["ActionAttributes"] = actionAttributes;

            var result = await _offBoardingExitRepository.GetExitsApprovalDetailAsync(EmpNo: Empno, ActionId: actionAttributes.ActionId, RoleId: OffBoardingHelper.RoleMakerApprover);
            OffBoardingExitsApproveViewModel offBoardingExitsApproveViewModel = new OffBoardingExitsApproveViewModel { Empno = Empno, Remarks = result?.Remarks };

            return View("MakerExitsApprove", offBoardingExitsApproveViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, OffBoardingHelper.RoleMakerApprover)]
        public async Task<IActionResult> MakerExitsApprove(OffBoardingExitsApproveViewModel offBoardingExitsApproveViewModel)
        {
            var actionAttributes = await _offBoardingExitRepository.GetActionAttributesAsync(ActionId: CurrentUserIdentity.ProfileActions.FirstOrDefault(t => t.RoleId == OffBoardingHelper.RoleMakerApprover).ActionId);
            ViewData["ActionAttributes"] = actionAttributes;
            if (!ModelState.IsValid)
            {
                return View("MakerExitsApprove", offBoardingExitsApproveViewModel);
            }

            OffBoardingExitFirstApproval offBoardingExitMakerApproval = new OffBoardingExitFirstApproval
            {
                PApprovedByEmpno = CurrentUserIdentity.EmpNo,
                PRemarks = offBoardingExitsApproveViewModel.Remarks,
                PEmpno = offBoardingExitsApproveViewModel.Empno,
                PIsApprovalHold = offBoardingExitsApproveViewModel.ApprovalType == "HOLD" ? "OK" : "KO"
            };

            var retVal = await _offBoardingExitRepository.MakerExitsApproveAsync(offBoardingExitMakerApproval);

            if (retVal.OutPSuccess == "OK")
                Notify("Success", "Changes succesfully saved", "toaster", notificationType: NotificationType.success);
            else
                Notify("Error", retVal.OutPMessage, "toaster", notificationType: NotificationType.error);

            if (retVal.OutPSuccess != "OK" || offBoardingExitsApproveViewModel.ApprovalType == "HOLD")
                return View("MakerExitsApprove", offBoardingExitsApproveViewModel);
            else
                return RedirectToAction("MakerExitsPending");
        }

        #endregion M A K E R

        #region C H E C K E R

        //[ProfileActionAuthorize(TCMPLApp.OffBoardingHelper)]

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, OffBoardingHelper.RoleCheckerApprover)]
        public async Task<IActionResult> CheckerExitsPending()
        {
            var actionAttributes = await _offBoardingExitRepository.GetActionAttributesAsync(ActionId: CurrentUserIdentity.ProfileActions.FirstOrDefault(t => t.RoleId == OffBoardingHelper.RoleCheckerApprover).ActionId);
            ViewData["ActionAttributes"] = actionAttributes;

            var result = await _offBoardingExitRepository.CheckerGetExitsPendingListAsync(CurrentUserIdentity.EmpNo, actionAttributes.ActionId);
            return View("CheckerExitsPending", result);
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, OffBoardingHelper.RoleCheckerApprover)]
        public async Task<IActionResult> CheckerExitsHistory()
        {
            var actionAttributes = await _offBoardingExitRepository.GetActionAttributesAsync(ActionId: CurrentUserIdentity.ProfileActions.FirstOrDefault(t => t.RoleId == OffBoardingHelper.RoleCheckerApprover).ActionId);
            ViewData["ActionAttributes"] = actionAttributes;

            var result = await _offBoardingExitRepository.CheckerGetExitsHistoryListAsync(CurrentUserIdentity.EmpNo, actionAttributes.ActionId);
            return View("CheckerExitsHistory", result);
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, OffBoardingHelper.RoleCheckerApprover)]
        public async Task<IActionResult> CheckerExitsDetail(string Empno)
        {
            var actionAttributes = await _offBoardingExitRepository.GetActionAttributesAsync(ActionId: CurrentUserIdentity.ProfileActions.FirstOrDefault(t => t.RoleId == OffBoardingHelper.RoleCheckerApprover).ActionId);
            ViewData["ActionAttributes"] = actionAttributes;

            var result = await _offBoardingExitRepository.GetExitsApprovalDetailAsync(EmpNo: Empno, ActionId: actionAttributes.ActionId, RoleId: OffBoardingHelper.RoleCheckerApprover);
            return View("CheckerExitsDetail", result);
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, OffBoardingHelper.RoleCheckerApprover)]
        public async Task<IActionResult> CheckerExitsApprove(string Empno)
        {
            var actionAttributes = await _offBoardingExitRepository.GetActionAttributesAsync(ActionId: CurrentUserIdentity.ProfileActions.FirstOrDefault(t => t.RoleId == OffBoardingHelper.RoleCheckerApprover).ActionId);
            ViewData["ActionAttributes"] = actionAttributes;

            var childApprovalStatus = await _offBoardingExitRepository.GetDescendantExitApprovalsStatus(new OffBoardingChildApprovalsStatus { PActionId = actionAttributes.ActionId, POfbEmpno = Empno, PSecondApproverEmpno = CurrentUserIdentity.EmpNo });
            ViewData["DescendantApprovalStatus"] = childApprovalStatus.OutReturnValue;

            var result = await _offBoardingExitRepository.GetExitsApprovalDetailAsync(EmpNo: Empno, ActionId: actionAttributes.ActionId, RoleId: OffBoardingHelper.RoleCheckerApprover);
            OffBoardingExitsApproveViewModel offBoardingExitsApproveViewModel = new OffBoardingExitsApproveViewModel { Empno = Empno, Remarks = result?.Remarks };
            return View("CheckerExitsApprove", offBoardingExitsApproveViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, OffBoardingHelper.RoleCheckerApprover)]
        public async Task<IActionResult> CheckerExitsApprove(OffBoardingExitsApproveViewModel offBoardingExitsApproveViewModel)
        {
            var actionAttributes = await _offBoardingExitRepository.GetActionAttributesAsync(ActionId: CurrentUserIdentity.ProfileActions.FirstOrDefault(t => t.RoleId == OffBoardingHelper.RoleCheckerApprover).ActionId);
            ViewData["ActionAttributes"] = actionAttributes;
            if (!ModelState.IsValid)
            {
                return View("CheckerExitsApprove", offBoardingExitsApproveViewModel);
            }

            var childApprovalStatus = await _offBoardingExitRepository.GetDescendantExitApprovalsStatus(
                new OffBoardingChildApprovalsStatus
                {
                    PActionId = actionAttributes.ActionId,
                    POfbEmpno = offBoardingExitsApproveViewModel.Empno,
                    PSecondApproverEmpno = CurrentUserIdentity.EmpNo,
                });
            ViewData["DescendantApprovalStatus"] = childApprovalStatus.OutReturnValue;
            if (childApprovalStatus.OutReturnValue != "Approved")
            {
                Notify("Error", "Descendant approval pending. Cannot approve.", "toaster", notificationType: NotificationType.error);
                return View("CheckerExitsApprove", offBoardingExitsApproveViewModel);
            }

            OffBoardingExitSecondApproval offBoardingExitCheckerApproval = new OffBoardingExitSecondApproval
            {
                PApprovedByEmpno = CurrentUserIdentity.EmpNo,
                PRemarks = offBoardingExitsApproveViewModel.Remarks,
                PEmpno = offBoardingExitsApproveViewModel.Empno,
                PIsApprovalHold = offBoardingExitsApproveViewModel.ApprovalType == "HOLD" ? "OK" : "KO"
            };

            var retVal = await _offBoardingExitRepository.CheckerExitsApproveAsync(offBoardingExitCheckerApproval);

            if (retVal.OutPSuccess == "OK")
                Notify("Success", "Changes succesfully saved", "toaster", notificationType: NotificationType.success);
            else
                Notify("Error", retVal.OutPMessage, "toaster", notificationType: NotificationType.error);

            if (offBoardingExitsApproveViewModel.ApprovalType == "HOLD" || retVal.OutPSuccess == "KO")
                return View("CheckerExitsApprove", offBoardingExitsApproveViewModel);
            else
                return RedirectToAction("CheckerExitsPending");
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, OffBoardingHelper.RoleCheckerApprover)]
        public async Task<IActionResult> GetDescendantApprovals(string OffboardingEmpno)
        {
            var actionAttributes = await _offBoardingExitRepository.GetActionAttributesAsync(ActionId: CurrentUserIdentity.ProfileActions.FirstOrDefault(t => t.RoleId == OffBoardingHelper.RoleCheckerApprover).ActionId);
            ViewData["ActionAttributes"] = actionAttributes;

            var result = await _offBoardingExitRepository.GetDescendantExitApprovals(OFBEmpno: OffboardingEmpno, SecondApproverActionId: actionAttributes.ActionId);
            return PartialView("_ExitApprovalsPopupPartial", result);
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, OffBoardingHelper.RoleCheckerApprover)]
        public async Task<IActionResult> GetGroupApprovals(string OffboardingEmpno)
        {
            var payrollActionId = CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == OffBoardingHelper.ActionMakerPayroll || p.ActionId == OffBoardingHelper.ActionCheckerPayroll);

            ViewData["IsPayrollUser"] = payrollActionId;

            var allApprovals = await _offBoardingExitRepository.GetDepartmentExitApprovals(OFBEmpno: OffboardingEmpno);
            ViewData["IsOffBoardingApproved"] = allApprovals.Any(m => m.IsApproved == "OK" && m.RoleId == OffBoardingHelper.RoleOffBoardingFinalApprover);

            var actionAttributes = await _offBoardingExitRepository.GetActionAttributesAsync(ActionId: CurrentUserIdentity.ProfileActions.FirstOrDefault(t => t.RoleId == OffBoardingHelper.RoleCheckerApprover).ActionId);
            ViewData["ActionAttributes"] = actionAttributes;

            var result = await _offBoardingExitRepository.GetGroupApprovalsAsync(OFBEmpno: OffboardingEmpno, ActionId: actionAttributes.ActionId);
            return PartialView("_ExitApprovalsPartial", result);
        }

        #endregion C H E C K E R

        #region H o D

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, OffBoardingHelper.RoleOffBoardingEmployeeHoD)]
        public async Task<IActionResult> HoDExitsPending()
        {
            var actionAttributes = await _offBoardingExitRepository.GetActionAttributesAsync(ActionId: CurrentUserIdentity.ProfileActions.FirstOrDefault(t => t.RoleId == OffBoardingHelper.RoleOffBoardingEmployeeHoD).ActionId);
            ViewData["ActionAttributes"] = actionAttributes;

            var result = await _offBoardingExitRepository.HoDGetExitsPendingListAsync(CurrentUserIdentity.EmpNo);
            return View("HoDExitsPending", result);
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, OffBoardingHelper.RoleOffBoardingEmployeeHoD)]
        public async Task<IActionResult> HoDExitsHistory()
        {
            var actionAttributes = await _offBoardingExitRepository.GetActionAttributesAsync(ActionId: CurrentUserIdentity.ProfileActions.FirstOrDefault(t => t.RoleId == OffBoardingHelper.RoleOffBoardingEmployeeHoD).ActionId);
            ViewData["ActionAttributes"] = actionAttributes;

            var result = await _offBoardingExitRepository.HoDGetExitsHistoryListAsync(CurrentUserIdentity.EmpNo);
            return View("HoDExitsHistory", result);
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, OffBoardingHelper.RoleOffBoardingEmployeeHoD)]
        public async Task<IActionResult> HoDExitsDetail(string Empno)
        {
            var actionAttributes = await _offBoardingExitRepository.GetActionAttributesAsync(ActionId: CurrentUserIdentity.ProfileActions.FirstOrDefault(t => t.RoleId == OffBoardingHelper.RoleOffBoardingEmployeeHoD).ActionId);
            ViewData["ActionAttributes"] = actionAttributes;

            var result = await _offBoardingExitRepository.GetExitsApprovalDetailAsync(EmpNo: Empno, ActionId: actionAttributes.ActionId, RoleId: OffBoardingHelper.RoleOffBoardingEmployeeHoD);
            return View("HoDExitsDetail", result);
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, OffBoardingHelper.RoleOffBoardingEmployeeHoD)]
        public async Task<IActionResult> HoDExitsApprove(string Empno)
        {
            var actionAttributes = await _offBoardingExitRepository.GetActionAttributesAsync(ActionId: CurrentUserIdentity.ProfileActions.FirstOrDefault(t => t.RoleId == OffBoardingHelper.RoleOffBoardingEmployeeHoD).ActionId);
            ViewData["ActionAttributes"] = actionAttributes;

            var result = await _offBoardingExitRepository.GetExitsApprovalDetailAsync(EmpNo: Empno, ActionId: actionAttributes.ActionId, RoleId: OffBoardingHelper.RoleOffBoardingEmployeeHoD);
            OffBoardingExitsApproveViewModel offBoardingExitsApproveViewModel = new OffBoardingExitsApproveViewModel { Empno = Empno, Remarks = result?.Remarks };
            return View("HoDExitsApprove", offBoardingExitsApproveViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, OffBoardingHelper.RoleOffBoardingEmployeeHoD)]
        public async Task<IActionResult> HoDExitsApprove(OffBoardingExitsApproveViewModel offBoardingExitsApproveViewModel)
        {
            var actionAttributes = await _offBoardingExitRepository.GetActionAttributesAsync(ActionId: CurrentUserIdentity.ProfileActions.FirstOrDefault(t => t.RoleId == OffBoardingHelper.RoleOffBoardingEmployeeHoD).ActionId);
            ViewData["ActionAttributes"] = actionAttributes;
            if (!ModelState.IsValid)
            {
                return View("HoDExitsApprove", offBoardingExitsApproveViewModel);
            }

            OffBoardingExitHoDApproval offBoardingExitHoDApproval = new OffBoardingExitHoDApproval
            {
                PApprovedByEmpno = CurrentUserIdentity.EmpNo,
                PRemarks = offBoardingExitsApproveViewModel.Remarks,
                PEmpno = offBoardingExitsApproveViewModel.Empno,
                PIsApprovalHold = offBoardingExitsApproveViewModel.ApprovalType == "HOLD" ? "OK" : "KO"
            };

            var retVal = await _offBoardingExitRepository.HoDExitsApproveAsync(offBoardingExitHoDApproval);

            if (retVal.OutPSuccess == "OK")
                Notify("Success", "Changes succesfully saved", "toaster", notificationType: NotificationType.success);
            else
                Notify("Error", retVal.OutPMessage, "toaster", notificationType: NotificationType.error);

            if (offBoardingExitsApproveViewModel.ApprovalType == "HOLD" || retVal.OutPSuccess == "KO")
                return View("HoDExitsApprove", offBoardingExitsApproveViewModel);
            else
                return RedirectToAction("HoDExitsPending");
        }

        #endregion H o D

        #region H R   M A N A G E R

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, OffBoardingHelper.RoleOffBoardingFinalApprover)]
        public async Task<IActionResult> HRManagerExitsPending()
        {
            var actionAttributes = await _offBoardingExitRepository.GetActionAttributesAsync(ActionId: CurrentUserIdentity.ProfileActions.FirstOrDefault(t => t.RoleId == OffBoardingHelper.RoleOffBoardingFinalApprover).ActionId);
            ViewData["ActionAttributes"] = actionAttributes;

            var result = await _offBoardingExitRepository.HRManagerGetExitsPendingListAsync(CurrentUserIdentity.EmpNo);
            return View("HRManagerExitsPending", result);
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, OffBoardingHelper.RoleOffBoardingFinalApprover)]
        public async Task<IActionResult> HRManagerExitsHistory()
        {
            var actionAttributes = await _offBoardingExitRepository.GetActionAttributesAsync(ActionId: CurrentUserIdentity.ProfileActions.FirstOrDefault(t => t.RoleId == OffBoardingHelper.RoleOffBoardingFinalApprover).ActionId);
            ViewData["ActionAttributes"] = actionAttributes;

            var result = await _offBoardingExitRepository.HRManagerGetExitsHistoryListAsync(CurrentUserIdentity.EmpNo);
            return View("HRManagerExitsHistory", result);
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, OffBoardingHelper.RoleOffBoardingFinalApprover)]
        public async Task<IActionResult> HRManagerExitsDetail(string Empno)
        {
            var actionAttributes = await _offBoardingExitRepository.GetActionAttributesAsync(ActionId: CurrentUserIdentity.ProfileActions.FirstOrDefault(t => t.RoleId == OffBoardingHelper.RoleOffBoardingFinalApprover).ActionId);
            ViewData["ActionAttributes"] = actionAttributes;

            var result = await _offBoardingExitRepository.GetExitsApprovalDetailAsync(EmpNo: Empno, ActionId: actionAttributes.ActionId, RoleId: OffBoardingHelper.RoleOffBoardingFinalApprover);
            return View("HRManagerExitsDetail", result);
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, OffBoardingHelper.RoleOffBoardingFinalApprover)]
        public async Task<IActionResult> HRManagerExitsApprove(string Empno)
        {
            var actionAttributes = await _offBoardingExitRepository.GetActionAttributesAsync(ActionId: CurrentUserIdentity.ProfileActions.FirstOrDefault(t => t.RoleId == OffBoardingHelper.RoleOffBoardingFinalApprover).ActionId);
            ViewData["ActionAttributes"] = actionAttributes;

            var canHRManagerApprove = await _offBoardingExitRepository.CheckHRManagerCanApproveExit(
                new OffBoardingCheckHrManagerCanApprove
                {
                    PEmpno = Empno
                });
            ViewData["HRManagerCanApprove"] = canHRManagerApprove.OutReturnValue;
            if (canHRManagerApprove.OutReturnValue != "OK")
                Notify("Error", "Descendant approval pending. Cannot approve.", "toaster", notificationType: NotificationType.error);

            var result = await _offBoardingExitRepository.GetExitsApprovalDetailAsync(EmpNo: Empno, ActionId: actionAttributes.ActionId, RoleId: OffBoardingHelper.RoleOffBoardingFinalApprover);
            OffBoardingExitsApproveViewModel offBoardingExitsApproveViewModel = new OffBoardingExitsApproveViewModel { Empno = Empno, Remarks = result?.Remarks };
            return View("HRManagerExitsApprove", offBoardingExitsApproveViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, OffBoardingHelper.RoleOffBoardingFinalApprover)]
        public async Task<IActionResult> HRManagerExitsApprove(OffBoardingExitsApproveViewModel offBoardingExitsApproveViewModel)
        {
            var actionAttributes = await _offBoardingExitRepository.GetActionAttributesAsync(ActionId: CurrentUserIdentity.ProfileActions.FirstOrDefault(t => t.RoleId == OffBoardingHelper.RoleOffBoardingFinalApprover).ActionId);
            ViewData["ActionAttributes"] = actionAttributes;
            if (!ModelState.IsValid)
            {
                return View("HRManagerExitsApprove", offBoardingExitsApproveViewModel);
            }

            var canHRManagerApprove = await _offBoardingExitRepository.CheckHRManagerCanApproveExit(
                new OffBoardingCheckHrManagerCanApprove
                {
                    PEmpno = offBoardingExitsApproveViewModel.Empno
                });

            ViewData["HRManagerCanApprove"] = canHRManagerApprove.OutReturnValue;
            if (canHRManagerApprove.OutReturnValue != "OK")
                Notify("Error", "Descendant approval pending. Cannot approve.", "toaster", notificationType: NotificationType.error);

            OffBoardingExitHRManagerApproval offBoardingExitHRManagerApproval = new OffBoardingExitHRManagerApproval
            {
                PApprovedByEmpno = CurrentUserIdentity.EmpNo,
                PRemarks = offBoardingExitsApproveViewModel.Remarks,
                PEmpno = offBoardingExitsApproveViewModel.Empno,
                PIsApprovalHold = offBoardingExitsApproveViewModel.ApprovalType == "HOLD" ? "OK" : "KO"
            };

            var retVal = await _offBoardingExitRepository.HRManagerExitsApproveAsync(offBoardingExitHRManagerApproval);

            if (retVal.OutPSuccess == "OK")
                Notify("Success", "Changes succesfully saved", "toaster", notificationType: NotificationType.success);
            else
                Notify("Error", retVal.OutPMessage, "toaster", notificationType: NotificationType.error);

            if (offBoardingExitsApproveViewModel.ApprovalType == "HOLD" || retVal.OutPSuccess == "KO")
                return View("HRManagerExitsApprove", offBoardingExitsApproveViewModel);
            else
                return RedirectToAction("HRManagerExitsPending");
        }

        #endregion H R   M A N A G E R

        #region Employee Contact Info

        public async Task<IActionResult> EmployeeContactInfo()
        {
            var empContactInfo = await _offBoardingExitRepository.GetEmployeeContactInfo(CurrentUserIdentity.EmpNo);
            if (empContactInfo == null)
            {
                empContactInfo = new OffBoardingEmployeeContactInfo { Empno = CurrentUserIdentity.EmpNo };
            }
            return View(empContactInfo);
        }

        [HttpPost]
        public async Task<IActionResult> EmployeeContactInfo(OffBoardingEmployeeContactInfo offBoardingEmployeeContactInfo)
        {
            if (!ModelState.IsValid)
            {
                return View(offBoardingEmployeeContactInfo);
            }

            OffBoardingExitUpdateUserContactInfo offBoardingExitUpdateUserContactInfo = new OffBoardingExitUpdateUserContactInfo
            {
                PAddress = offBoardingEmployeeContactInfo.Address,
                PAlternateNumber = offBoardingEmployeeContactInfo.AlternateNumber,
                PEmpno = offBoardingEmployeeContactInfo.Empno,
                PMobilePrimary = offBoardingEmployeeContactInfo.MobilePrimary
            };

            var retVal = await _offBoardingExitRepository.UpdateEmployeeContactInfo(offBoardingExitUpdateUserContactInfo);
            if (retVal.OutPSuccess == "OK")
            {
                Notify("Success", "Contact information saved successfully.", "", NotificationType.success);
            }
            else
            {
                Notify("Error", retVal.OutPMessage, "", NotificationType.error);
            }
            return View(offBoardingEmployeeContactInfo);
        }

        public IActionResult EmployeeSelfOffBoardingInfo()
        {
            ViewData["Empno"] = CurrentUserIdentity.EmpNo;
            return View("OffBoardingDetails");
        }

        #endregion Employee Contact Info

        #region Common -- Approvals

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, OffBoardingHelper.CommonActionViewApprovals)]
        public async Task<IActionResult> GetAllApprovals(string OffboardingEmpno, bool? DialogView, string empDetails)
        {
            var payrollActionId = CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == OffBoardingHelper.ActionMakerPayroll || p.ActionId == OffBoardingHelper.ActionCheckerPayroll);

            ViewData["IsPayrollUser"] = payrollActionId;
            ViewData["EmpDetails"] = empDetails;

            var result = await _offBoardingExitRepository.GetDepartmentExitApprovals(OFBEmpno: OffboardingEmpno);
            ViewData["IsOffBoardingApproved"] = result.Any(m => m.IsApproved == "OK" && m.RoleId == OffBoardingHelper.RoleOffBoardingFinalApprover);

            var returnPopupView = DialogView ?? true;
            if (returnPopupView)
                return PartialView("_ExitApprovalsPopupPartial", result);
            else
                return PartialView("_ExitApprovalsPartial", result);
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, OffBoardingHelper.CommonActionResetApprovals)]
        public async Task<IActionResult> ResetApproval(string Empno, string ActionId)
        {
            OffBoardingResetApproval offBoardingResetApproval = new OffBoardingResetApproval { PActionId = ActionId, POfbEmpno = Empno, PResetByEmpno = CurrentUserIdentity.EmpNo };
            offBoardingResetApproval = await _offBoardingExitRepository.ResetApprovalAsync(offBoardingResetApproval);

            return Json(new { Success = offBoardingResetApproval.OutPSuccess == "OK", Message = offBoardingResetApproval.OutPMessage });
        }

        #endregion Common -- Approvals

        public async Task<IActionResult> FileUpload(string Empno)
        {
            var actionAttributes = await _offBoardingExitRepository.GetActionAttributesAsync(ActionId: CurrentUserIdentity.ProfileActions.FirstOrDefault(t => t.RoleId == OffBoardingHelper.RoleMakerApprover || t.RoleId == OffBoardingHelper.RoleCheckerApprover || t.RoleId == OffBoardingHelper.RoleInitiator).ActionId);

            OffBoardingFileUploadViewModel offBoardingFileUploadViewModel = new OffBoardingFileUploadViewModel
            {
                OfbEmpno = Empno,
                UploadByGroup = actionAttributes.GroupName,
                UploadByEmpno = CurrentUserIdentity.EmpNo
            };
            return PartialView("_ExitsFileUploadPartial", offBoardingFileUploadViewModel);
        }

        public IActionResult FileUploadInitiator(string Empno)
        {
            OffBoardingFileUploadViewModel offBoardingFileUploadViewModel = new OffBoardingFileUploadViewModel
            {
                OfbEmpno = Empno,
                UploadByGroup = InititatorGroupName,
                UploadByEmpno = CurrentUserIdentity.EmpNo
            };
            return PartialView("_ExitsFileUploadPartial", offBoardingFileUploadViewModel);
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, OffBoardingHelper.CommonActionPrintExitForm)]
        public async Task<IActionResult> PrintForm(string Empno)
        {
            //var empDetails = await _employeeDetailsRepository.GetEmployeeDetailsAsync(Empno);
            var empDetails = await _commonEmployeeDetailsRepository.EmployeeDetailAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PEmpno = Empno
                });
            ViewData["EmployeeInfo"] = empDetails;

            var empExitDetails = await _offBoardingExitRepository.GetEmployeeExitDetails(Empno);

            ViewData["EmployeeExitDetails"] = empExitDetails;

            var approvals = await _offBoardingExitRepository.GetDepartmentExitApprovals(Empno);
            return PartialView("_ExitPrintPartial", approvals);
        }

        #region Common -- F i l e   U p l o a d

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, OffBoardingHelper.CommonActionUploadFiles)]
        public async Task<IActionResult> FileUpload(OffBoardingFileUploadViewModel offBoardingFileUploadViewModel)
        {
            if (!ModelState.IsValid)
            {
                return Json(new { success = false, message = string.Join(",", ModelState.Values.SelectMany(v => v.Errors.Select(e => e.ErrorMessage))) });
            }
            try
            {
                string errorMessage = string.Empty;
                foreach (var file in offBoardingFileUploadViewModel.Files)
                {
                    var serverFileName = await SaveFileAsync(offBoardingFileUploadViewModel.OfbEmpno, offBoardingFileUploadViewModel.UploadByGroup, file);
                    var retVal = await _offBoardingExitRepository.AddFileAsync(new OffBoardingFilesAddFile
                    {
                        PClientFileName = file.FileName,
                        PEmpno = offBoardingFileUploadViewModel.OfbEmpno,
                        PServerFileName = serverFileName,
                        PUploadByEmpno = offBoardingFileUploadViewModel.UploadByEmpno,
                        PUploadByGroup = offBoardingFileUploadViewModel.UploadByGroup
                    });
                    if (retVal.OutPSuccess != "OK")
                    {
                        DeleteFile(serverFileName);

                        return Json(new { success = false, message = retVal.OutPMessage });
                    }
                }
                return Json(new { success = true, message = "File(s) uploaded successfully." });
            }
            catch (Exception e)
            {
                return Json(new { success = false, message = "Exception - " + e.Message });
            }
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, OffBoardingHelper.CommonActionUploadFiles)]
        public async Task<IActionResult> RemoveUploadedFile(string KeyId)
        {
            try
            {
                OffBoardingRemoveFile offBoardingRemoveFile = new OffBoardingRemoveFile { PKeyId = KeyId };
                offBoardingRemoveFile = await _offBoardingExitRepository.DeleteFileAsync(offBoardingRemoveFile);

                if (offBoardingRemoveFile.OutPSuccess == "OK")
                {
                    DeleteFile(offBoardingRemoveFile.OutPServerFileName);
                    return Json(new { success = true, message = "File removed successfully" });
                }
                else
                    return Json(new { success = false, message = "Exception - " + offBoardingRemoveFile.OutPMessage });
            }
            catch (Exception e)
            {
                return Json(new { success = false, message = "Exception - " + e.Message });
            }
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, OffBoardingHelper.CommonActionViewFiles)]
        public async Task<IActionResult> GetFilesUploadedList(string Empno, string GroupName, bool? ReadOnly)
        {
            ViewData["GroupName"] = GroupName;

            var viewAllFilesActionId = CurrentUserIdentity.ProfileActions.Any(
                    p => p.ActionId == OffBoardingHelper.ActionMakerPayroll ||
                    p.ActionId == OffBoardingHelper.ActionCheckerPayroll ||
                    p.ActionId == OffBoardingHelper.ActionCheckerTimeMgmt ||
                    p.ActionId == OffBoardingHelper.ActionMakerTimeMgmt
            );

            IEnumerable<OffBoardingFilesUploaded> filesUploaded;
            if (viewAllFilesActionId)
                filesUploaded = await _offBoardingExitRepository.GetAllFilesUploadedListAsync(Empno);
            else
                filesUploaded = await _offBoardingExitRepository.GetFilesUploadedListByGroupAsync(Empno, GroupName);
            bool showReadOnly = ReadOnly ?? false;
            if (showReadOnly)
                return PartialView("_ExitsFilesUploadedListViewPartial", filesUploaded);
            else
                return PartialView("_ExitsFilesUploadedListPartial", filesUploaded);
        }

        public async Task<IActionResult> DownloadFile(string KeyId)
        {
            var fileDetails = await _offBoardingExitRepository.GetFileUploadedByKeyIdAsync(KeyId);
            var baseRepository = _configuration["TCMPLAppBaseRepository"];
            var areaRepository = _configuration["AreaRepository:OffBoarding"];
            var folder = Path.Combine(baseRepository, areaRepository);
            var file = Path.Combine(folder, fileDetails.ServerFileName);

            byte[] bytes = System.IO.File.ReadAllBytes(file);

            return File(bytes, "application/octet-stream");
        }

        #endregion Common -- F i l e   U p l o a d

        //public async Task<IActionResult> GetFilesUploadedListByGroup(string Empno)
        //{
        //    var actionAttributes = await _offBoardingExitRepository.GetActionAttributesAsync(ActionId: CurrentUserIdentity.ProfileActions.FirstOrDefault(t => t.RoleId == OffBoardingHelper.RoleMakerApprover || t.RoleId == OffBoardingHelper.RoleCheckerApprover).ActionId);
        //    ViewData["ActionAttributes"] = actionAttributes;

        //    var filesList = await _offBoardingExitRepository.GetFilesUploadedListByGroupAsync(Empno, actionAttributes.GroupName);
        //    return PartialView("_ExitsFilesUploadedListPartial", filesList);
        //}

        #region Common -- O f f B o a r d i n g   D e t a i l s

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, OffBoardingHelper.CommonActionViewOffBoardingStatus)]
        public IActionResult GetOffBoardingDetails(string Empno)
        {
            ViewData["Empno"] = Empno;
            return View("OffBoardingDetails");
        }

        //[RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, OffBoardingHelper.CommonActionViewOffBoardingStatus)]
        public async Task<IActionResult> GetEmpExitDetails(string EmpNo)
        {
            if (string.IsNullOrEmpty(EmpNo))
            {
                return PartialView("_ExitsEmployeeDetailsPartial");
            }
            var empDetails = await _offBoardingExitRepository.GetEmployeeExitDetails(EmpNo);

            return PartialView("_ExitsEmployeeExitDetailsPartial", empDetails);
        }

        #endregion Common -- O f f B o a r d i n g   D e t a i l s

        private async Task<string> SaveFileAsync(string Empno, string GroupName, IFormFile File)
        {
            var baseRepository = _configuration["TCMPLAppBaseRepository"];
            var areaRepository = _configuration["AreaRepository:OffBoarding"];
            var folder = Path.Combine(baseRepository, areaRepository);

            if (!System.IO.Directory.Exists(folder))
            {
                System.IO.Directory.CreateDirectory(folder);
            }

            var fileName = Empno + "_" + GroupName + "_" + (System.IO.Path.GetRandomFileName()).Replace(".", "") + Path.GetExtension(File.FileName);

            var fileNamePath = Path.Combine(folder, fileName);

            using (Stream fileStream = new FileStream(fileNamePath, FileMode.Create))
            {
                await File.CopyToAsync(fileStream);
            }
            return fileName;
        }

        private void DeleteFile(string FileName)
        {
            var baseRepository = _configuration["TCMPLAppBaseRepository"];
            var areaRepository = _configuration["AreaRepository:OffBoarding"];
            var FileNamePath = Path.Combine(baseRepository, areaRepository, FileName);
            System.IO.File.Delete(FileNamePath);
        }
    }
}