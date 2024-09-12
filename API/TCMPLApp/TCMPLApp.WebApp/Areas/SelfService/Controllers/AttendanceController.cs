using DocumentFormat.OpenXml.Packaging;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.IO;
using MimeTypes;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.Attendance;
using TCMPLApp.DataAccess.Repositories.Common;
using TCMPLApp.DataAccess.Repositories.SWPVaccine;
using TCMPLApp.Domain.Models;
using TCMPLApp.Domain.Models.Attendance;
using TCMPLApp.Domain.Models.SelfService;
using TCMPLApp.Library.Excel.Template;
using TCMPLApp.Library.Excel.Template.Models;
using TCMPLApp.Library.Excel.Writer;
using TCMPLApp.WebApp.Classes;
using TCMPLApp.WebApp.Controllers;
using TCMPLApp.WebApp.CustomPolicyProvider;
using TCMPLApp.WebApp.Models;
using static TCMPLApp.WebApp.Classes.DTModel;

namespace TCMPLApp.WebApp.Areas.SelfService.Controllers
{
    [Authorize]
    [Area("SelfService")]
    public class AttendanceController : BaseController
    {
        private const string ConstFilterPunchDetailsIndex = "PunchDetailsIndex";
        private const string ConstFilterFlexiPunchDetailsIndex = "FlexiPunchDetailsIndex";
        private const string ConstFilterPunchDetailsForHRIndex = "PunchDetailsForHrIndex";
        private const string ConstFilterLeaveIndex = "LeaveIndex";
        private const string ConstFilterOndutyIndex = "OndutyIndex";
        private const string ConstFilterPrintLog = "PrintLogIndex";
        private const string ConstFilterLeaveLedger = "LeaveLedgerIndex";

        private const string ConstFilterLeaveCalendarHR = "LeaveCalendarHRIndex";
        private const string ConstFilterLeaveCalendarHOD = "LeaveCalendarHODIndex";
        private const string ConstFilterHRApprovalLeave = "HRApprovalLeaveIndex";
        private const string ConstFilterHRApprovalOnDuty = "HRApprovalOnDutyIndex";
        private const string ConstFilterHRApprovalForgettingCard = "HRApprovalForgettingCardIndex";
        private const string ConstFilterHRApprovalExtraHours = "HRApprovalExtraHoursIndex";

        private const string ConstFilterLeaveClaimIndex = "LeaveClaimIndex";
        private const string ConstFilterLopForExcessLeaveIndex = "LopForExcessLeaveIndex";

        private const string ConstFilterExtraHoursClaimsIndex = "ExtraHoursClaimsIndex";
        private const string ConstFilterExtraHoursFlexiClaimsIndex = "ExtraHoursFlexiClaimsIndex";
        private const string ConstFilterExtraHoursClaimCreateMain = "ExtraHoursClaimCreateMain";
        private const string ConstFilterExtraHoursFlexiClaimCreateMain = "ExtraHoursFlexiClaimCreateMain";
        private const string ConstFilterShiftMasterIndex = "ShiftMasterIndex";

        private readonly IAttendanceLeaveApplicationsDataTableListRepository _attendanceLeaveApplicationsDataTableListRepository;
        private readonly ISelectTcmPLRepository _selectTcmPLRepository;
        private readonly ISelectTcmPLPagingRepository _selectTcmPLPagingRepository;
        private readonly IAttendanceLeaveValidateRepository _attendanceLeaveValidateRepository;
        private readonly IAttendanceLeaveCreateRepository _attendanceLeaveCreateRepository;
        private readonly IAttendanceLeaveDetailsRepository _attendanceLeaveDetailsRepository;
        private readonly IAttendanceLeaveDetailsSLRepository _attendanceLeaveDetailsSLRepository;
        private readonly IAttendanceLeaveDeleteRepository _attendanceLeaveDeleteRepository;

        private readonly IAttendanceLeaveLedgerDataTableListRepository _attendanceLeaveLedgerDataTableListRepository;
        private readonly IAttendanceLeavesAvailedDataTableListRepository _attendanceLeavesAvailedDataTableListRepository;
        private readonly IAttendanceLeaveLedgerBalance _attendanceLeaveLedgerBalance;

        private readonly IAttendancePunchDetailsDataTableListRepository _attendancePunchDetailsDataTableListRepository;
        private readonly IAttendancePunchDetailsDayPunchListRepository _attendancePunchDetailsDayPunchListRepository;

        private readonly IAttendanceExtraHoursClaimCreateRepository _attendanceExtraHoursClaimCreateRepository;
        private readonly IAttendanceExtraHoursClaimDeleteRepository _attendanceExtraHoursClaimDeleteRepository;
        private readonly IAttendanceExtraHoursClaimDetailsRepository _attendanceExtraHoursClaimDetailsRepository;
        private readonly IAttendanceExtraHoursDataTableListRepository _attendanceExtraHoursDataTableListRepository;
        private readonly IAttendanceExtraHoursDetailDataTableListRepository _attendanceExtraHoursDetailDataTableListRepository;
        private readonly IAttendanceExtrahoursClaimExistsRepository _attendanceExtrahoursClaimExistsRepository;

        private readonly IAttendanceOnDutyApplicationsDataTableListRepository _attendanceOnDutyApplicationsDataTableListRepository;
        private readonly IAttendanceOnDutyApprovalDataTableListRepository _attendanceOnDutyApprovalDataTableListRepository;
        private readonly IAttendanceHolidayApprovalDataTableListRepository _attendanceHolidayApprovalDataTableListRepository;
        private readonly IAttendanceExtraHoursApprovalDataTableListRepository _attendanceExtraHoursApprovalDataTableListRepository;
        private readonly IAttendanceLeaveApprovalDataTableListRepository _attendanceLeaveApprovalDataTableListRepository;

        private readonly IAttendanceOnDutyApprovalRepository _attendanceOnDutyApprovalRepository;
        private readonly IAttendanceLeaveApprovalRepository _attendanceLeaveApprovalRepository;
        private readonly IAttendanceExtraHoursApprovalRepository _attendanceExtraHoursApprovalRepository;
        private readonly IAttendanceExtraHoursAdjustmentRepository _attendanceExtraHoursAdjustmentRepository;

        private readonly IAttendanceLeaveClaimsDataTableListRepository _attendanceLeaveClaimsDataTableListRepository;
        private readonly IAttendanceLeaveClaimCreateRepository _attendanceLeaveClaimCreateRepository;
        private readonly IAttendanceLeaveClaimImportRepository _attendanceLeaveClaimImportRepository;
        private readonly IAttendanceOnDutyCreateRepository _attendanceOnDutyCreateRepository;
        private readonly IAttendanceOnDutyDetailsRepository _attendanceOnDutyDetailsRepository;
        private readonly IAttendanceOnDutyDeleteRepository _attendanceOnDutyDeleteRepository;

        private readonly IAttendanceGuestAttendanceDataTableListRepository _attendanceGuestAttendanceDataTableListRepository;
        private readonly IAttendanceGuestAttendanceDetailsRepository _attendanceGuestAttendanceDetailsRepository;
        private readonly IAttendanceGuestAttendanceCreateRepository _attendanceGuestAttendanceCreateRepository;
        private readonly IAttendanceGuestAttendanceDeleteRepository _attendanceGuestAttendanceDeleteRepository;

        private readonly IAttendanceHolidayAttendanceDataTableListRepository _attendanceHolidayAttendanceDataTableListRepository;
        private readonly IAttendanceHolidayAttendanceDetailsRepository _attendanceHolidayAttendanceDetailsRepository;
        private readonly IAttendanceHolidayAttendanceCreateRepository _attendanceHolidayAttendanceCreateRepository;
        private readonly IAttendanceHolidayAttendanceDeleteRepository _attendanceHolidayAttendanceDeleteRepository;
        private readonly IAttendanceHolidayApprovalRepository _attendanceHolidayApprovalRepository;
        private readonly ILeaveCalendarDataTableListRepository _leaveCalendarDataTableListRepository;
        private readonly IAttendanceEmployeeDetailsRepository _attendanceEmployeeDetailsRepository;

        private readonly IAttendanceActionsExecutor _attendanceActionsExecutor;
        private readonly IAttendanceActionsExecuteReport _attendanceActionsExecuteReport;
        private readonly IAttendancePLAvailedReport _attendancePLAvailedReport;

        private readonly IFilterRepository _filterRepository;
        private readonly IAttendancePrintLogDataTableListRepository _attendancePrintLogDataTableListRepository;

        private readonly IAttendancePunchUploadRepository _attendancePunchUploadRepository;
        private readonly IAttendanceEmpCardRFIDUploadRepository _attendanceEmpCardRFIDUploadRepository;
        private readonly ILoPForExcessLeaveDataTableListRepository _loPForExcessLeaveDataTableListRepository;
        private readonly ILoPForExcessLeaveRepository _loPForExcessLeaveRepository;
        private readonly ILoPForExcessLeaveImportRepository _loPForExcessLeaveImportRepository;
        private readonly ILoPLastSalaryMonthDetailsRepository _loPLastSalaryMonthDetailsRepository;
        private readonly ILoPLastSalaryMonthStatusRepository _loPLastSalaryMonthStatusRepository;
        private readonly IAttendanceFlexiPunchDetailsDataTableListRepository _attendanceFlexiPunchDetailsDataTableListRepository;
        private readonly IShiftDataTableListRepository _shiftDataTableListRepository;
        private readonly IShiftMasterRepository _shiftMasterRepository;
        private readonly IShiftDetailRepository _shiftDetailRepository;
        private readonly IShiftConfigDetailRepository _shiftConfigDetailRepository;
        private readonly IShiftLunchConfigDetailRepository _shiftLunchConfigDetailRepository;
        private readonly IShiftHalfDayConfigDetailRepository _shiftHalfDayConfigDetailRepository;

        private readonly IExcelTemplate _excelTemplate;
        private readonly IUtilityRepository _utilityRepository;

        private readonly IExtraHoursFlexiApprovalDataTableListRepository _extraHoursFlexiApprovalDataTableListRepository;
        private readonly IExtraHoursFlexiDataTableListRepository _extraHoursFlexiDataTableListRepository;
        private readonly IExtraHoursFlexiDetailDataTableListRepository _extraHoursFlexiDetailDataTableListRepository;

        private readonly IExtraHoursFlexiAdjustmentRepository _extraHoursFlexiAdjustmentRepository;
        private readonly IExtraHoursFlexiApprovalRepository _extraHoursFlexiApprovalRepository;
        private readonly IExtraHoursFlexiClaimCreateRepository _extraHoursFlexiClaimCreateRepository;
        private readonly IExtraHoursFlexiClaimDeleteRepository _extraHoursFlexiClaimDeleteRepository;
        private readonly IExtraHoursFlexiClaimDetailsRepository _extraHoursFlexiClaimDetailsRepository;
        private readonly IExtraHoursFlexiClaimExistsRepository _extraHoursFlexiClaimExistsRepository;

        private readonly ILeaveCalendarHoDExcelDataTableListRepository _leaveCalendarHoDExcelDataTableListRepository;

        private static readonly RecyclableMemoryStreamManager recyclableMemoryStreamManager = new RecyclableMemoryStreamManager();

        public AttendanceController(
            IAttendanceLeaveApplicationsDataTableListRepository attendanceLeaveApplicationsDataTableListRepository,
            IAttendanceLeaveValidateRepository attendanceLeaveValidateRepository,
            IAttendanceLeaveCreateRepository attendanceLeaveCreateRepository,
            IAttendanceLeaveDetailsRepository attendanceLeaveDetailsRepository,
            IAttendanceLeaveDetailsSLRepository attendanceLeaveDetailsSLRepository,
            IAttendanceLeaveDeleteRepository attendanceLeaveDeleteRepository,

            IAttendanceLeaveLedgerDataTableListRepository attendanceLeaveLedgerDataTableListRepository,
            IAttendanceLeavesAvailedDataTableListRepository attendanceLeavesAvailedDataTableListRepository,
            IAttendanceLeaveLedgerBalance attendanceLeaveLedgerBalance,

            IAttendancePunchDetailsDataTableListRepository attendancePunchDetailsDataTableListRepository,
            IAttendancePunchDetailsDayPunchListRepository attendancePunchDetailsDayPunchListRepository,

            IAttendanceExtraHoursClaimCreateRepository attendanceExtraHoursClaimCreateRepository,
            IAttendanceExtraHoursClaimDeleteRepository attendanceExtraHoursClaimDeleteRepository,
            IAttendanceExtraHoursClaimDetailsRepository attendanceExtraHoursClaimDetailsRepository,
            IAttendanceExtraHoursDataTableListRepository attendanceExtraHoursDataTableListRepository,
            IAttendanceExtraHoursDetailDataTableListRepository attendanceExtraHoursDetailDataTableListRepository,
            IAttendanceExtrahoursClaimExistsRepository attendanceExtrahoursClaimExistsRepository,

            IAttendanceOnDutyApplicationsDataTableListRepository attendanceOnDutyApplicationsDataTableListRepository,
            IAttendanceOnDutyApprovalDataTableListRepository attendanceOnDutyApprovalDataTableListRepository,
            IAttendanceHolidayApprovalDataTableListRepository attendanceHolidayApprovalDataTableListRepository,
            IAttendanceExtraHoursApprovalDataTableListRepository attendanceExtraHoursApprovalDataTableListRepository,
            IAttendanceLeaveApprovalDataTableListRepository attendanceLeaveApprovalDataTableListRepository,
            ILeaveCalendarDataTableListRepository leaveCalendarDataTableListRepository,

            IAttendanceOnDutyApprovalRepository attendanceOnDutyApprovalRepository,
            IAttendanceLeaveApprovalRepository attendanceLeaveApprovalRepository,
            IAttendanceExtraHoursApprovalRepository attendanceExtraHoursApprovalRepository,
            IAttendanceExtraHoursAdjustmentRepository attendanceExtraHoursAdjustmentRepository,

            IAttendanceLeaveClaimsDataTableListRepository attendanceLeaveClaimsDataTableListRepository,
            IAttendanceLeaveClaimCreateRepository attendanceLeaveClaimCreateRepository,
            IAttendanceLeaveClaimImportRepository attendanceLeaveClaimImportRepository,

            IAttendanceOnDutyCreateRepository attendanceOnDutyCreateRepository,
            IAttendanceOnDutyDetailsRepository attendanceOnDutyDetailsRepository,
            IAttendanceOnDutyDeleteRepository attendanceOnDutyDeleteRepository,

            IAttendanceGuestAttendanceDataTableListRepository attendanceGuestAttendanceDataTableListRepository,
            IAttendanceGuestAttendanceDetailsRepository attendanceGuestAttendanceDetailsRepository,
            IAttendanceGuestAttendanceCreateRepository attendanceGuestAttendanceCreateRepository,
            IAttendanceGuestAttendanceDeleteRepository attendanceGuestAttendanceDeleteRepository,

            IAttendanceHolidayAttendanceDataTableListRepository attendanceHolidayAttendanceDataTableListRepository,
            IAttendanceHolidayAttendanceDetailsRepository attendanceHolidayAttendanceDetailsRepository,
            IAttendanceHolidayAttendanceCreateRepository attendanceHolidayAttendanceCreateRepository,
            IAttendanceHolidayAttendanceDeleteRepository attendanceHolidayAttendanceDeleteRepository,
            IAttendanceHolidayApprovalRepository attendanceHolidayApprovalRepository,

            IAttendancePunchUploadRepository attendancePunchUploadRepository,
            IAttendanceEmpCardRFIDUploadRepository attendanceEmpCardRFIDUploadRepository,

            IAttendanceEmployeeDetailsRepository attendanceEmployeeDetailsRepository,

            IAttendanceActionsExecutor attendanceActionsExecutor,
            IAttendanceActionsExecuteReport attendanceActionsExecuteReport,

            ISelectTcmPLRepository selectTcmPLRepository,
            ISelectTcmPLPagingRepository selectTcmPLPagingRepository,

            IFilterRepository filterRepository,
            IAttendancePrintLogDataTableListRepository attendancePrintLogDataTableListRepository,

            IExcelTemplate excelTemplate,

            IUtilityRepository utilityRepository,
            IAttendancePLAvailedReport attendancePLAvailedReport,
            ILoPForExcessLeaveDataTableListRepository loPForExcessLeaveDataTableListRepository,
            ILoPForExcessLeaveRepository loPForExcessLeaveRepository,
            ILoPForExcessLeaveImportRepository loPForExcessLeaveImportRepository,
            ILoPLastSalaryMonthDetailsRepository loPLastSalaryMonthDetailsRepository,
            ILoPLastSalaryMonthStatusRepository loPLastSalaryMonthStatusRepository,
            IAttendanceFlexiPunchDetailsDataTableListRepository attendanceFlexiPunchDetailsDataTableListRepository,
            IShiftDataTableListRepository shiftDataTableListRepository,
            IShiftMasterRepository shiftMasterRepository,
            IShiftDetailRepository shiftDetailRepository,
            IShiftConfigDetailRepository shiftConfigDetailRepository,

            IExtraHoursFlexiApprovalDataTableListRepository extraHoursFlexiApprovalDataTableListRepository,
            IExtraHoursFlexiDataTableListRepository extraHoursFlexiDataTableListRepository,
            IExtraHoursFlexiDetailDataTableListRepository extraHoursFlexiDetailDataTableListRepository,
            IExtraHoursFlexiAdjustmentRepository extraHoursFlexiAdjustmentRepository,
            IExtraHoursFlexiApprovalRepository extraHoursFlexiApprovalRepository,
            IExtraHoursFlexiClaimCreateRepository extraHoursFlexiClaimCreateRepository,
            IExtraHoursFlexiClaimDeleteRepository extraHoursFlexiClaimDeleteRepository,
            IExtraHoursFlexiClaimDetailsRepository extraHoursFlexiClaimDetailsRepository,
            IExtraHoursFlexiClaimExistsRepository extraHoursFlexiClaimExistsRepository,
            IShiftLunchConfigDetailRepository shiftLunchConfigDetailRepository,
            IShiftHalfDayConfigDetailRepository shiftHalfDayConfigDetailRepository,
            ILeaveCalendarHoDExcelDataTableListRepository leaveCalendarHoDExcelDataTableListRepository)
        {
            _attendanceLeaveApplicationsDataTableListRepository = attendanceLeaveApplicationsDataTableListRepository;
            _attendanceLeaveCreateRepository = attendanceLeaveCreateRepository;
            _attendanceLeaveValidateRepository = attendanceLeaveValidateRepository;
            _attendanceLeaveDetailsRepository = attendanceLeaveDetailsRepository;
            _attendanceLeaveDetailsSLRepository = attendanceLeaveDetailsSLRepository;
            _attendanceLeaveDeleteRepository = attendanceLeaveDeleteRepository;

            _attendanceLeaveLedgerDataTableListRepository = attendanceLeaveLedgerDataTableListRepository;
            _attendanceLeavesAvailedDataTableListRepository = attendanceLeavesAvailedDataTableListRepository;
            _attendanceLeaveLedgerBalance = attendanceLeaveLedgerBalance;

            _attendancePunchDetailsDataTableListRepository = attendancePunchDetailsDataTableListRepository;
            _attendancePunchDetailsDayPunchListRepository = attendancePunchDetailsDayPunchListRepository;

            _attendanceExtraHoursClaimCreateRepository = attendanceExtraHoursClaimCreateRepository;
            _attendanceExtraHoursClaimDeleteRepository = attendanceExtraHoursClaimDeleteRepository;
            _attendanceExtraHoursClaimDetailsRepository = attendanceExtraHoursClaimDetailsRepository;
            _attendanceExtraHoursDataTableListRepository = attendanceExtraHoursDataTableListRepository;
            _attendanceExtraHoursDetailDataTableListRepository = attendanceExtraHoursDetailDataTableListRepository;
            _attendanceExtrahoursClaimExistsRepository = attendanceExtrahoursClaimExistsRepository;

            _attendanceOnDutyApplicationsDataTableListRepository = attendanceOnDutyApplicationsDataTableListRepository;
            _attendanceOnDutyApprovalDataTableListRepository = attendanceOnDutyApprovalDataTableListRepository;
            _attendanceHolidayApprovalDataTableListRepository = attendanceHolidayApprovalDataTableListRepository;
            _attendanceExtraHoursApprovalDataTableListRepository = attendanceExtraHoursApprovalDataTableListRepository;
            _attendanceLeaveApprovalDataTableListRepository = attendanceLeaveApprovalDataTableListRepository;
            _leaveCalendarDataTableListRepository = leaveCalendarDataTableListRepository;

            _attendanceOnDutyApprovalRepository = attendanceOnDutyApprovalRepository;
            _attendanceLeaveApprovalRepository = attendanceLeaveApprovalRepository;
            _attendanceExtraHoursApprovalRepository = attendanceExtraHoursApprovalRepository;
            _attendanceExtraHoursAdjustmentRepository = attendanceExtraHoursAdjustmentRepository;

            _attendanceLeaveClaimsDataTableListRepository = attendanceLeaveClaimsDataTableListRepository;
            _attendanceLeaveClaimCreateRepository = attendanceLeaveClaimCreateRepository;
            _attendanceLeaveClaimImportRepository = attendanceLeaveClaimImportRepository;

            _attendanceOnDutyCreateRepository = attendanceOnDutyCreateRepository;
            _attendanceOnDutyDetailsRepository = attendanceOnDutyDetailsRepository;
            _attendanceOnDutyDeleteRepository = attendanceOnDutyDeleteRepository;

            _attendanceGuestAttendanceDataTableListRepository = attendanceGuestAttendanceDataTableListRepository;
            _attendanceGuestAttendanceDetailsRepository = attendanceGuestAttendanceDetailsRepository;
            _attendanceGuestAttendanceCreateRepository = attendanceGuestAttendanceCreateRepository;
            _attendanceGuestAttendanceDeleteRepository = attendanceGuestAttendanceDeleteRepository;

            _attendanceHolidayAttendanceDataTableListRepository = attendanceHolidayAttendanceDataTableListRepository;
            _attendanceHolidayAttendanceDetailsRepository = attendanceHolidayAttendanceDetailsRepository;
            _attendanceHolidayAttendanceCreateRepository = attendanceHolidayAttendanceCreateRepository;
            _attendanceHolidayAttendanceDeleteRepository = attendanceHolidayAttendanceDeleteRepository;
            _attendanceHolidayApprovalRepository = attendanceHolidayApprovalRepository;

            _attendancePunchUploadRepository = attendancePunchUploadRepository;
            _attendanceEmpCardRFIDUploadRepository = attendanceEmpCardRFIDUploadRepository;

            _attendanceEmployeeDetailsRepository = attendanceEmployeeDetailsRepository;

            _attendanceActionsExecutor = attendanceActionsExecutor;
            _attendanceActionsExecuteReport = attendanceActionsExecuteReport;

            _selectTcmPLRepository = selectTcmPLRepository;
            _selectTcmPLPagingRepository = selectTcmPLPagingRepository;

            _filterRepository = filterRepository;
            _attendancePrintLogDataTableListRepository = attendancePrintLogDataTableListRepository;

            _excelTemplate = excelTemplate;
            _utilityRepository = utilityRepository;
            _attendancePLAvailedReport = attendancePLAvailedReport;
            _loPForExcessLeaveDataTableListRepository = loPForExcessLeaveDataTableListRepository;
            _loPForExcessLeaveRepository = loPForExcessLeaveRepository;
            _loPForExcessLeaveImportRepository = loPForExcessLeaveImportRepository;
            _loPLastSalaryMonthDetailsRepository = loPLastSalaryMonthDetailsRepository;
            _loPLastSalaryMonthStatusRepository = loPLastSalaryMonthStatusRepository;
            _attendanceFlexiPunchDetailsDataTableListRepository = attendanceFlexiPunchDetailsDataTableListRepository;
            _shiftDataTableListRepository = shiftDataTableListRepository;
            _shiftMasterRepository = shiftMasterRepository;
            _shiftDetailRepository = shiftDetailRepository;
            _shiftConfigDetailRepository = shiftConfigDetailRepository;

            _extraHoursFlexiApprovalDataTableListRepository = extraHoursFlexiApprovalDataTableListRepository;
            _extraHoursFlexiDataTableListRepository = extraHoursFlexiDataTableListRepository;
            _extraHoursFlexiDetailDataTableListRepository = extraHoursFlexiDetailDataTableListRepository;
            _extraHoursFlexiAdjustmentRepository = extraHoursFlexiAdjustmentRepository;
            _extraHoursFlexiApprovalRepository = extraHoursFlexiApprovalRepository;
            _extraHoursFlexiClaimCreateRepository = extraHoursFlexiClaimCreateRepository;
            _extraHoursFlexiClaimDeleteRepository = extraHoursFlexiClaimDeleteRepository;
            _extraHoursFlexiClaimDetailsRepository = extraHoursFlexiClaimDetailsRepository;
            _extraHoursFlexiClaimExistsRepository = extraHoursFlexiClaimExistsRepository;
            _shiftLunchConfigDetailRepository = shiftLunchConfigDetailRepository;
            _shiftHalfDayConfigDetailRepository = shiftHalfDayConfigDetailRepository;
            _leaveCalendarHoDExcelDataTableListRepository = leaveCalendarHoDExcelDataTableListRepository;
        }

        public IActionResult Index()
        {
            return View();
        }

        //[RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleAttendanceAdmin)]
        //public async Task<IActionResult> LeaveCalendarIndex()
        //{
        //    var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
        //    {
        //        PModuleName = CurrentUserIdentity.CurrentModule,
        //        PMetaId = CurrentUserIdentity.MetaId,
        //        PPersonId = CurrentUserIdentity.EmployeeId,
        //        PMvcActionName = ConstFilterLeaveLeaveCalendar
        //    });
        //    FilterDataModel filterDataModel = new FilterDataModel();
        //    if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
        //    {
        //        filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
        //    }

        //    return View(filterDataModel);
        //}

        //[RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleAttendanceAdmin)]
        //public async Task<IActionResult> LeaveCalendarFilterGet()
        //{
        //    var costcodes = await _selectTcmPLRepository.CostCodeListAsync(BaseSpTcmPLGet(), null);
        //    ViewData["CostCodes"] = new SelectList(costcodes, "DataValueField", "DataTextField");

        //    var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
        //    {
        //        PModuleName = CurrentUserIdentity.CurrentModule,
        //        PMetaId = CurrentUserIdentity.MetaId,
        //        PPersonId = CurrentUserIdentity.EmployeeId,
        //        PMvcActionName = ConstFilterLeaveLeaveCalendar
        //    });

        //    FilterDataModel filterDataModel = new FilterDataModel();
        //    if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
        //        filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

        //    return PartialView("_ModalLeaveCalendarFilterSet", filterDataModel);
        //}

        //[HttpPost]
        //public async Task<IActionResult> LeaveCalendarFilterSet([FromForm] FilterDataModel filterDataModel)
        //{
        //    try
        //    {
        //        {
        //            string jsonFilter;
        //            jsonFilter = JsonConvert.SerializeObject(
        //                    new
        //                    {
        //                        Parent = filterDataModel.Parent
        //                    });

        //            var retVal = await _filterRepository.FilterCreateAsync(new Domain.Models.FilterCreate
        //            {
        //                PModuleName = CurrentUserIdentity.CurrentModule,
        //                PMetaId = CurrentUserIdentity.MetaId,
        //                PPersonId = CurrentUserIdentity.EmployeeId,
        //                PMvcActionName = ConstFilterLeaveLeaveCalendar,
        //                PFilterJson = jsonFilter
        //            });

        //            return Json(new
        //            {
        //                success = true,
        //                parent = filterDataModel.Parent,
        //            });
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
        //    }
        //    //return PartialView("_ModalOnDutyFilterSet", filterDataModel);
        //}

        //[HttpGet]
        //[ValidateAntiForgeryToken]
        //[RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleAttendanceAdmin)]
        //public async Task<JsonResult> GetListsLeaveCalendar(string month, string parent, string[] employees)
        //{
        //    try
        //    {
        //        System.Collections.Generic.IEnumerable<LeaveCalendarDataTableList> data = await _leaveCalendarDataTableListRepository.LeaveCalendarDataTableList(
        //       BaseSpTcmPLGet(),
        //       new ParameterSpTcmPL
        //       {
        //           PMonth = month,
        //           PParent = parent,
        //           PRowNumber = 0,
        //           PPageLength = 9999,
        //       }
        //   );
        //        var jsonObj = JsonConvert.SerializeObject(data);

        //        return Json(data);
        //    }
        //    catch (Exception)
        //    {
        //        throw;
        //    }
        //}

        #region LeaveCalendarHR

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleAttendanceAdmin)]
        public async Task<IActionResult> LeaveCalendarHRIndex()
        {
            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterLeaveCalendarHR
            });
            FilterDataModel filterDataModel = new FilterDataModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            return View(filterDataModel);
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleAttendanceAdmin)]
        public async Task<IActionResult> LeaveCalendarHRFilterGet()
        {
            var costcodes = await _selectTcmPLRepository.CostCodeListAsync(BaseSpTcmPLGet(), null);
            ViewData["CostCodes"] = new SelectList(costcodes, "DataValueField", "DataTextField");

            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterLeaveCalendarHR
            });

            FilterDataModel filterDataModel = new FilterDataModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            return PartialView("_ModalLeaveCalendarHRFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> LeaveCalendarHRFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                {
                    string jsonFilter;
                    jsonFilter = JsonConvert.SerializeObject(
                            new
                            {
                                Parent = filterDataModel.Parent
                            });

                    var retVal = await _filterRepository.FilterCreateAsync(new Domain.Models.FilterCreate
                    {
                        PModuleName = CurrentUserIdentity.CurrentModule,
                        PMetaId = CurrentUserIdentity.MetaId,
                        PPersonId = CurrentUserIdentity.EmployeeId,
                        PMvcActionName = ConstFilterLeaveCalendarHR,
                        PFilterJson = jsonFilter
                    });

                    return Json(new
                    {
                        success = true,
                        parent = filterDataModel.Parent,
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
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleAttendanceAdmin)]
        public async Task<JsonResult> GetListsLeaveCalendarHR(string month, string parent, string[] employees)
        {
            try
            {
                System.Collections.Generic.IEnumerable<LeaveCalendarDataTableList> data = await _leaveCalendarDataTableListRepository.LeaveCalendarHRDataTableList(
               BaseSpTcmPLGet(),
               new ParameterSpTcmPL
               {
                   PMonth = month,
                   PParent = parent,
                   PRowNumber = 0,
                   PPageLength = 9999,
               }
           );
                var jsonObj = JsonConvert.SerializeObject(data);

                return Json(data);
            }
            catch (Exception)
            {
                throw;
            }
        }

        #endregion LeaveCalendarHR

        #region LeaveCalendarHOD

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleManagerHoD)]
        public async Task<IActionResult> LeaveCalendarHODIndex()
        {
            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterLeaveCalendarHOD
            });
            FilterDataModel filterDataModel = new FilterDataModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            return View(filterDataModel);
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleManagerHoD)]
        public async Task<IActionResult> LeaveCalendarHODFilterGet()
        {
            var costcodes = await _selectTcmPLRepository.SWPCostCodeList4HodSecAsync(BaseSpTcmPLGet(), null);
            ViewData["CostCodes"] = new SelectList(costcodes, "DataValueField", "DataTextField");

            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterLeaveCalendarHOD
            });

            FilterDataModel filterDataModel = new FilterDataModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            return PartialView("_ModalLeaveCalendarHODFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> LeaveCalendarHODFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                {
                    string jsonFilter;
                    jsonFilter = JsonConvert.SerializeObject(
                            new
                            {
                                Parent = filterDataModel.Parent
                            });

                    var retVal = await _filterRepository.FilterCreateAsync(new Domain.Models.FilterCreate
                    {
                        PModuleName = CurrentUserIdentity.CurrentModule,
                        PMetaId = CurrentUserIdentity.MetaId,
                        PPersonId = CurrentUserIdentity.EmployeeId,
                        PMvcActionName = ConstFilterLeaveCalendarHOD,
                        PFilterJson = jsonFilter
                    });

                    return Json(new
                    {
                        success = true,
                        parent = filterDataModel.Parent,
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
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleManagerHoD)]
        public async Task<JsonResult> GetListsLeaveCalendarHOD(string month, string parent, string[] employees)
        {
            try
            {
                System.Collections.Generic.IEnumerable<LeaveCalendarDataTableList> data = await _leaveCalendarDataTableListRepository.LeaveCalendarHODDataTableList(
               BaseSpTcmPLGet(),
               new ParameterSpTcmPL
               {
                   PMonth = month,
                   PParent = parent,
                   PRowNumber = 0,
                   PPageLength = 9999,
               }
           );
                var jsonObj = JsonConvert.SerializeObject(data);

                return Json(data);
            }
            catch (Exception)
            {
                throw;
            }
        }

        public async Task<IActionResult> LeaveExcelDownload(string month, string startDate, string endDate, string viewType)
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterLeaveCalendarHOD
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            var parent = filterDataModel.Parent;
            var timeStamp = month;

            string fileName = "Leave Calendar";
            string reportTitle = "Leave Calendar";
            string sheetName = "Leave";

            System.Collections.Generic.IEnumerable<LeaveCalendarHodExcelDataTableList> data = await _leaveCalendarHoDExcelDataTableListRepository.LeaveCalendarHODExcelDataTableList(
               BaseSpTcmPLGet(),
               new ParameterSpTcmPL
               {
                   PMonth = month,
                   PParent = parent,
                   PStartDate = Convert.ToDateTime(startDate),
                   PEndDate = Convert.ToDateTime(endDate),
                   PViewType = viewType,
                   PRowNumber = 0,
                   PPageLength = 9999,
               }
           );
            if (data == null) { return NotFound(); }

            var json = JsonConvert.SerializeObject(data);

            IEnumerable<LeaveCalendarHodDataTableListExcel> excelData = JsonConvert.DeserializeObject<IEnumerable<LeaveCalendarHodDataTableListExcel>>(json);

            var byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, reportTitle, sheetName);

            var mimeType = MimeTypeMap.GetMimeType("xlsx");

            FileContentResult file = File(byteContent, mimeType, fileName);

            return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
        }

        #endregion LeaveCalendarHOD

        #region L e a v e

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> LeaveGetClosingBalance(DTParameters param)
        {
            try
            {
                //throw new Exception("Testing");
                var empdetails = await _attendanceEmployeeDetailsRepository.AttendanceEmployeeDetailsAsync(BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PEmpno = param.Empno
                    }
                );

                var result = await _attendanceLeaveLedgerBalance.LeaveBalancesAllAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL
                {
                    PEmpno = param.Empno
                });

                return Json(new
                {
                    Empno = empdetails.Empno,
                    EmployeeName = empdetails.Name,
                    OpeningBalanceAsOn = param.StartDate?.ToString("dd-MMM-yyyy"),
                    ClosingBalanceAsOn = param.EndDate?.ToString("dd-MMM-yyyy"),
                    Ocl = result.POpenCl,
                    Osl = result.POpenSl,
                    Opl = result.POpenPl,
                    Oex = result.POpenEx,
                    Oco = result.POpenCo,
                    Oho = result.POpenOh,
                    Olv = result.POpenLv,
                    Ccl = result.PCloseCl,
                    Csl = result.PCloseSl,
                    Cpl = result.PClosePl,
                    Cex = result.PCloseEx,
                    Cco = result.PCloseCo,
                    Cho = result.PCloseOh,
                    Clv = result.PCloseLv
                });
            }
            catch (Exception ex)
            {
                return Json(new { error = ex.Message });
            }
        }

        public async Task<IActionResult> LeaveIndex()
        {
            LeaveApplicationsViewModel leaveApplicationsViewModel = new LeaveApplicationsViewModel();
            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterLeaveIndex
            });
            FilterDataModel filterDataModel = new FilterDataModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }
            leaveApplicationsViewModel.FilterDataModel = filterDataModel;
            return View(leaveApplicationsViewModel);
        }

        public async Task<IActionResult> LeaveFilterGet()
        {
            var empdetails = await _attendanceEmployeeDetailsRepository.AttendanceEmployeeDetailsAsync(BaseSpTcmPLGet(),
                null
               );

            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterLeaveIndex
            });
            FilterDataModel filterDataModel = new FilterDataModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }
            if (string.IsNullOrEmpty(filterDataModel.Empno))
                filterDataModel.Empno = empdetails.Empno;

            var leaveTypes = await _selectTcmPLRepository.LeaveTypeListAsync(BaseSpTcmPLGet(), null);
            ViewData["LeaveTypes"] = new SelectList(leaveTypes, "DataValueField", "DataTextField", filterDataModel.LeaveType);

            ViewData["EmpList"] = await getEmployeeSelectList(filterDataModel.Empno);
            //This for Lead / Hod / Hr
            //if (CurrentUserIdentity.ProfileActions.Any(pa => pa.RoleId == SelfServiceHelper.RoleManagerHoDOnBeHalf))
            //{
            //    var empList = await _selectTcmPLRepository.EmployeeListForMngrHodOnBeHalfAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            //    ViewData["EmpList"] = new SelectList(empList, "DataValueField", "DataTextField", filterDataModel.Empno);
            //}
            //else if (CurrentUserIdentity.ProfileActions.Any(pa => pa.RoleId == SelfServiceHelper.RoleManagerHoD))
            //{
            //    var empList = await _selectTcmPLRepository.EmployeeListForMngrHodAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            //    ViewData["EmpList"] = new SelectList(empList, "DataValueField", "DataTextField", filterDataModel.Empno);
            //}
            //else if (CurrentUserIdentity.ProfileActions.Any(pa => pa.RoleId == SelfServiceHelper.RoleAttendanceAdmin))
            //{
            //    var empList = await _selectTcmPLRepository.EmployeeListForHRAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            //    ViewData["EmpList"] = new SelectList(empList, "DataValueField", "DataTextField", filterDataModel.Empno);
            //}

            return PartialView("_ModalLeaveFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> LeaveFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                if (filterDataModel.StartDate != null || filterDataModel.EndDate != null)
                {
                    if (filterDataModel.StartDate == null || filterDataModel.EndDate == null)
                        throw new Exception("Both the dates are reqired.");
                    else if (filterDataModel.StartDate?.ToString("yyyy") != filterDataModel.EndDate?.ToString("yyyy"))
                        throw new Exception("Date range should be with in same year.");
                    else if (filterDataModel.StartDate > filterDataModel.EndDate)
                        throw new Exception("End date should be greater than start date");
                }
                {
                    string jsonFilter;
                    jsonFilter = JsonConvert.SerializeObject(
                            new
                            {
                                StartDate = filterDataModel.StartDate,
                                EndDate = filterDataModel.EndDate,
                                Empno = filterDataModel.Empno,
                                LeaveType = filterDataModel.LeaveType
                            }
                            );

                    var retVal = await _filterRepository.FilterCreateAsync(new Domain.Models.FilterCreate
                    {
                        PModuleName = CurrentUserIdentity.CurrentModule,
                        PMetaId = CurrentUserIdentity.MetaId,
                        PPersonId = CurrentUserIdentity.EmployeeId,
                        PMvcActionName = ConstFilterLeaveIndex,
                        PFilterJson = jsonFilter
                    });

                    return Json(new
                    {
                        success = true,
                        leaveType = filterDataModel.LeaveType,
                        empno = filterDataModel.Empno,
                        startDate = filterDataModel.StartDate,
                        endDate = filterDataModel.EndDate
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
        public async Task<JsonResult> GetListsLeaveApplications(DTParameters param)
        {
            DTResult<LeaveApplicationsDataTableList> result = new DTResult<LeaveApplicationsDataTableList>();
            int totalRow = 0;

            try
            {
                var data = await _attendanceLeaveApplicationsDataTableListRepository.AttendanceLeaveApplicationsDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
                        PStartDate = param.StartDate,
                        PEndDate = param.EndDate,
                        PEmpno = param.Empno,
                        PLeaveType = param.LeaveType,
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

        public async Task<JsonResult> GetListsLeaveApplicationsHeader(DTParameters param)
        {
            var empdetails = await _attendanceEmployeeDetailsRepository.AttendanceEmployeeDetailsAsync(BaseSpTcmPLGet(),
                               new ParameterSpTcmPL
                               {
                                   PEmpno = param.Empno
                               }
                               );
            return Json(new { empno = empdetails.Empno, employeeName = empdetails.Name });
        }

        public async Task<IActionResult> LeaveCreate()
        {
            var selfDetail = await _attendanceEmployeeDetailsRepository.AttendanceEmployeeDetailsAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["EmployeeDetails"] = selfDetail;

            var leaveTypes = await _selectTcmPLRepository.LeaveTypeListAsync(BaseSpTcmPLGet(), null);
            ViewData["LeaveTypes"] = new SelectList(leaveTypes, "DataValueField", "DataTextField");

            var approvers = await _selectTcmPLRepository.ApproversListAsync(BaseSpTcmPLGet(), null);
            ViewData["Approvers"] = new SelectList(approvers, "DataValueField", "DataTextField");

            var halfDayDay = getListHalfDayDay();
            ViewData["HalfDayDay"] = new SelectList(halfDayDay, "DataValueField", "DataTextField");

            return PartialView("_ModalLeaveCreatePartial");
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> LeaveCreate([FromForm] LeaveCreateViewModel leaveCreateViewModel)
        {
            var selfDetail = await _attendanceEmployeeDetailsRepository.AttendanceEmployeeDetailsAsync(BaseSpTcmPLGet(), null);
            ViewData["EmployeeDetails"] = selfDetail;

            try
            {
                if (ModelState.IsValid)
                {
                    var validationResult = await _attendanceLeaveValidateRepository.ValidateNewLeave(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PStartDate = leaveCreateViewModel.StartDate,
                            PEndDate = leaveCreateViewModel.EndDate,
                            PLeaveType = leaveCreateViewModel.LeaveType,
                            PHalfDayOn = leaveCreateViewModel.HalfDayDay
                        });

                    var json = JsonConvert.SerializeObject(leaveCreateViewModel);
                    LeaveCreateReviewViewModel leaveCreateReviewViewModel = JsonConvert.DeserializeObject<LeaveCreateReviewViewModel>(json);

                    leaveCreateReviewViewModel.LeavePeriod = validationResult.PLeavePeriod;
                    leaveCreateReviewViewModel.Discrepancies = validationResult.PMessageText;
                    leaveCreateReviewViewModel.IsLeaveApplicationOk = validationResult.PMessageType == IsOk;
                    leaveCreateReviewViewModel.ResumingDuty = validationResult.PResuming;
                    leaveCreateReviewViewModel.LastReporting = validationResult.PLastReporting;
                    leaveCreateReviewViewModel.CalcLeavePeriod = validationResult.PLeavePeriod;
                    if (validationResult.PLeavePeriod >= 2 && (leaveCreateViewModel.LeaveType == "SL" || leaveCreateViewModel.LeaveType == "SC") && leaveCreateReviewViewModel.IsLeaveApplicationOk)
                        ViewData["MedicalCertRequired"] = true;
                    else
                        ViewData["MedicalCertRequired"] = false;

                    return PartialView("_ModalLeaveCreateReviewPartial", leaveCreateReviewViewModel);
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            var leaveTypes = await _selectTcmPLRepository.LeaveTypeListAsync(BaseSpTcmPLGet(), null);
            ViewData["LeaveTypes"] = new SelectList(leaveTypes, "DataValueField", "DataTextField", leaveCreateViewModel.LeaveType);

            var approvers = await _selectTcmPLRepository.ApproversListAsync(BaseSpTcmPLGet(), null);
            ViewData["Approvers"] = new SelectList(approvers, "DataValueField", "DataTextField", leaveCreateViewModel.Appover);

            var halfDayDay = getListHalfDayDay();
            ViewData["HalfDayDay"] = new SelectList(halfDayDay, "DataValueField", "DataTextField", leaveCreateViewModel.HalfDayDay);

            return PartialView("_ModalLeaveCreatePartial", leaveCreateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> LeaveCreateModify([FromForm] LeaveCreateReviewViewModel leaveCreateReviewViewModel)
        {
            try
            {
                var json = JsonConvert.SerializeObject(leaveCreateReviewViewModel);
                LeaveCreateViewModel leaveCreateViewModel = JsonConvert.DeserializeObject<LeaveCreateViewModel>(json);

                leaveCreateViewModel.LeavePeriod = leaveCreateReviewViewModel.CalcLeavePeriod;

                var selfDetail = await _attendanceEmployeeDetailsRepository.AttendanceEmployeeDetailsAsync(BaseSpTcmPLGet(), null);
                ViewData["EmployeeDetails"] = selfDetail;

                var leaveTypes = await _selectTcmPLRepository.LeaveTypeListAsync(BaseSpTcmPLGet(), null);
                ViewData["LeaveTypes"] = new SelectList(leaveTypes, "DataValueField", "DataTextField", leaveCreateViewModel.LeaveType);

                var approvers = await _selectTcmPLRepository.ApproversListAsync(BaseSpTcmPLGet(), null);
                ViewData["Approvers"] = new SelectList(approvers, "DataValueField", "DataTextField", leaveCreateViewModel.Appover);

                var halfDayDay = getListHalfDayDay();
                ViewData["HalfDayDay"] = new SelectList(halfDayDay, "DataValueField", "DataTextField", leaveCreateViewModel.HalfDayDay);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            return PartialView("_ModalLeaveCreatePartial", leaveCreateReviewViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> LeaveCreateReviewSave([FromForm] LeaveCreateReviewViewModel leaveCreateReviewViewModel)
        {
            string medicalCertificateFileName = "";
            bool medicalCertificateRequired = leaveCreateReviewViewModel.LeaveType == "SL" && leaveCreateReviewViewModel.LeavePeriod >= 2;

            var selfDetail = await _attendanceEmployeeDetailsRepository.AttendanceEmployeeDetailsAsync(BaseSpTcmPLGet(), null);
            ViewData["EmployeeDetails"] = selfDetail;

            if (medicalCertificateRequired && leaveCreateReviewViewModel.file != null || medicalCertificateRequired == false)
            {
                if (leaveCreateReviewViewModel.file != null)
                {
                    medicalCertificateFileName = await StorageHelper.SaveFileAsync(StorageHelper.Attendance.RepositoryMedicalCertificate, selfDetail.Empno, StorageHelper.Attendance.GroupMedicalCertificate, leaveCreateReviewViewModel.file, Configuration);
                }
            }
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _attendanceLeaveCreateRepository.CreateLeaveAsync(
                            BaseSpTcmPLGet(),
                            new ParameterSpTcmPL
                            {
                                PLeaveType = leaveCreateReviewViewModel.LeaveType,
                                PStartDate = leaveCreateReviewViewModel.StartDate,
                                PEndDate = leaveCreateReviewViewModel.EndDate,
                                PHalfDayOn = leaveCreateReviewViewModel.HalfDayDay,
                                PCareTaker = leaveCreateReviewViewModel.CareTaker ?? " ",
                                PContactAddress = leaveCreateReviewViewModel.Address ?? " ",
                                PContactPhone = leaveCreateReviewViewModel.PhoneNumber ?? " ",
                                PContactStd = leaveCreateReviewViewModel.StdNumber ?? " ",
                                PDiscrepancy = leaveCreateReviewViewModel.Discrepancies ?? " ",
                                PLeadEmpno = leaveCreateReviewViewModel.Appover,
                                PMedCertAvailable = leaveCreateReviewViewModel.MedicalCertificate ? 1 : 0,
                                POffice = leaveCreateReviewViewModel.OfficeLocation,
                                PProjno = leaveCreateReviewViewModel.Project,
                                PMedCertFileNm = medicalCertificateFileName,
                                PReason = leaveCreateReviewViewModel.Reason
                            }
                            );
                    if (result.PMessageType != IsOk)
                    {
                        if (!string.IsNullOrEmpty(medicalCertificateFileName))
                            StorageHelper.DeleteFile(StorageHelper.Attendance.RepositoryMedicalCertificate, medicalCertificateFileName, Configuration);
                        throw new Exception(result.PMessageText);
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

            return View();
        }

        [HttpGet]
        public async Task<IActionResult> LeaveDetails(string ApplicationId)
        {
            var result = await _attendanceLeaveDetailsRepository.LeaveDetailsAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL { PApplicationId = ApplicationId });

            LeaveDetailsViewModel leaveDetailsViewModel = new LeaveDetailsViewModel
            {
                ApplicationId = ApplicationId,
                ApplicationDate = result.PApplicationDate,
                Address = result.PContactAddress,
                CareTaker = result.PCareTaker,
                Discrepancies = result.PDiscrepancy?.Replace("<br />", ""),
                EmpName = result.PEmpName,
                EndDate = result.PEndDate,
                FlagCanDel = result.PFlagCanDel,
                FlagIsAdj = result.PFlagIsAdj,
                HodApproval = result.PHodApproval,
                HRApproval = result.PHrApproval,
                LastReporting = result.PLastReporting,
                LeadApproval = result.PLeadApproval,
                LeadName = result.PLeadName,
                LeavePeriod = result.PLeavePeriod,
                LeaveType = result.PLeaveType,
                LeadReason = result.PLeadReason,
                HodReason = result.PHodReason,
                HRReason = result.PHrReason,
                MedCertFileNm = result.PMedCertFileNm,
                MedicalCertificate = result.PMedCertAvailable,
                PhoneNumber = result.PContactPhone,
                POffice = result.POffice,
                Project = result.PProjno,
                Reason = result.PReason,
                ResumingDuty = result.PResuming,
                StartDate = result.PStartDate,
                StdNumber = result.PContactStd
            };

            return PartialView("_ModalLeaveDetailPartial", leaveDetailsViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> LeaveDetailsSLHoD(string ApplicationId)
        {
            var result = await _attendanceLeaveDetailsSLRepository.LeaveDetailsSLHoDAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL { PApplicationId = ApplicationId });

            SLLeaveDetailsViewModel slLeaveDetailsViewModel = new SLLeaveDetailsViewModel
            {
                ApplicationId = ApplicationId,
                ApplicationDate = result.PApplicationDate,
                Address = result.PContactAddress,
                CareTaker = result.PCareTaker,
                Discrepancies = result.PDiscrepancy?.Replace("<br />", ""),
                EmpName = result.PEmpName,
                EndDate = result.PEndDate,
                FlagCanDel = result.PFlagCanDel,
                FlagIsAdj = result.PFlagIsAdj,
                HodApproval = result.PHodApproval,
                HRApproval = result.PHrApproval,
                LastReporting = result.PLastReporting,
                LeadApproval = result.PLeadApproval,
                LeadName = result.PLeadName,
                LeavePeriod = result.PLeavePeriod,
                LeaveType = result.PLeaveType,
                LeadReason = result.PLeadReason,
                HodReason = result.PHodReason,
                HRReason = result.PHrReason,
                MedCertFileNm = result.PMedCertFileNm,
                MedicalCertificate = result.PMedCertAvailable,
                PhoneNumber = result.PContactPhone,
                POffice = result.POffice,
                Project = result.PProjno,
                Reason = result.PReason,
                ResumingDuty = result.PResuming,
                StartDate = result.PStartDate,
                StdNumber = result.PContactStd,
                SLAvailed = result.PSlAvailed.GetValueOrDefault(),
                SLApplied = result.PSlApplied.GetValueOrDefault(),
                FlagCanApprove = result.PFlagCanApprove
            };

            return PartialView("_ModalLeaveDetailSLPartial", slLeaveDetailsViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> LeaveDetailsSLHR(string ApplicationId)
        {
            var result = await _attendanceLeaveDetailsSLRepository.LeaveDetailsSLHRAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL { PApplicationId = ApplicationId });

            SLLeaveDetailsViewModel slLeaveDetailsViewModel = new SLLeaveDetailsViewModel
            {
                ApplicationId = ApplicationId,
                ApplicationDate = result.PApplicationDate,
                Address = result.PContactAddress,
                CareTaker = result.PCareTaker,
                Discrepancies = result.PDiscrepancy?.Replace("<br />", ""),
                EmpName = result.PEmpName,
                EndDate = result.PEndDate,
                FlagCanDel = result.PFlagCanDel,
                FlagIsAdj = result.PFlagIsAdj,
                HodApproval = result.PHodApproval,
                HRApproval = result.PHrApproval,
                LastReporting = result.PLastReporting,
                LeadApproval = result.PLeadApproval,
                LeadName = result.PLeadName,
                LeavePeriod = result.PLeavePeriod,
                LeaveType = result.PLeaveType,
                LeadReason = result.PLeadReason,
                HodReason = result.PHodReason,
                HRReason = result.PHrReason,
                MedCertFileNm = result.PMedCertFileNm,
                MedicalCertificate = result.PMedCertAvailable,
                PhoneNumber = result.PContactPhone,
                POffice = result.POffice,
                Project = result.PProjno,
                Reason = result.PReason,
                ResumingDuty = result.PResuming,
                StartDate = result.PStartDate,
                StdNumber = result.PContactStd,
                SLAvailed = result.PSlAvailed.GetValueOrDefault(),
                SLApplied = result.PSlApplied.GetValueOrDefault(),
                FlagCanApprove = result.PFlagCanApprove
            };

            return PartialView("_ModalLeaveDetailSLPartial", slLeaveDetailsViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> LeaveDetailsSLLead(string ApplicationId)
        {
            var result = await _attendanceLeaveDetailsSLRepository.LeaveDetailsSLLeadAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL { PApplicationId = ApplicationId });

            SLLeaveDetailsViewModel slLeaveDetailsViewModel = new SLLeaveDetailsViewModel
            {
                ApplicationId = ApplicationId,
                ApplicationDate = result.PApplicationDate,
                Address = result.PContactAddress,
                CareTaker = result.PCareTaker,
                Discrepancies = result.PDiscrepancy?.Replace("<br />", ""),
                EmpName = result.PEmpName,
                EndDate = result.PEndDate,
                FlagCanDel = result.PFlagCanDel,
                FlagIsAdj = result.PFlagIsAdj,
                HodApproval = result.PHodApproval,
                HRApproval = result.PHrApproval,
                LastReporting = result.PLastReporting,
                LeadApproval = result.PLeadApproval,
                LeadName = result.PLeadName,
                LeavePeriod = result.PLeavePeriod,
                LeaveType = result.PLeaveType,
                LeadReason = result.PLeadReason,
                HodReason = result.PHodReason,
                HRReason = result.PHrReason,
                MedCertFileNm = result.PMedCertFileNm,
                MedicalCertificate = result.PMedCertAvailable,
                PhoneNumber = result.PContactPhone,
                POffice = result.POffice,
                Project = result.PProjno,
                Reason = result.PReason,
                ResumingDuty = result.PResuming,
                StartDate = result.PStartDate,
                StdNumber = result.PContactStd,
                SLAvailed = result.PSlAvailed.GetValueOrDefault(),
                SLApplied = result.PSlApplied.GetValueOrDefault(),
                FlagCanApprove = result.PFlagCanApprove
            };

            return PartialView("_ModalLeaveDetailSLPartial", slLeaveDetailsViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> LeaveDetailsSLOnBehalf(string ApplicationId)
        {
            var result = await _attendanceLeaveDetailsSLRepository.LeaveDetailsSLOnBehalfAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL { PApplicationId = ApplicationId });

            SLLeaveDetailsViewModel slLeaveDetailsViewModel = new SLLeaveDetailsViewModel
            {
                ApplicationId = ApplicationId,
                ApplicationDate = result.PApplicationDate,
                Address = result.PContactAddress,
                CareTaker = result.PCareTaker,
                Discrepancies = result.PDiscrepancy?.Replace("<br />", ""),
                EmpName = result.PEmpName,
                EndDate = result.PEndDate,
                FlagCanDel = result.PFlagCanDel,
                FlagIsAdj = result.PFlagIsAdj,
                HodApproval = result.PHodApproval,
                HRApproval = result.PHrApproval,
                LastReporting = result.PLastReporting,
                LeadApproval = result.PLeadApproval,
                LeadName = result.PLeadName,
                LeavePeriod = result.PLeavePeriod,
                LeaveType = result.PLeaveType,
                LeadReason = result.PLeadReason,
                HodReason = result.PHodReason,
                HRReason = result.PHrReason,
                MedCertFileNm = result.PMedCertFileNm,
                MedicalCertificate = result.PMedCertAvailable,
                PhoneNumber = result.PContactPhone,
                POffice = result.POffice,
                Project = result.PProjno,
                Reason = result.PReason,
                ResumingDuty = result.PResuming,
                StartDate = result.PStartDate,
                StdNumber = result.PContactStd,
                SLAvailed = result.PSlAvailed.GetValueOrDefault(),
                SLApplied = result.PSlApplied.GetValueOrDefault(),
                FlagCanApprove = result.PFlagCanApprove
            };

            return PartialView("_ModalLeaveDetailSLPartial", slLeaveDetailsViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> LeaveDelete(string ApplicationId)
        {
            try
            {
                var result = await _attendanceLeaveDeleteRepository.DeleteLeaveAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL { PApplicationId = ApplicationId }
                    );
                if (result.PMessageType == "OK")
                {
                    if (!string.IsNullOrEmpty(result.PMedicalCertFileName))
                    {
                        StorageHelper.DeleteFile(StorageHelper.Attendance.RepositoryMedicalCertificate, result.PMedicalCertFileName, Configuration);
                    }
                }
                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleAttendanceAdmin)]
        public async Task<IActionResult> LeaveDeletionForce(string ApplicationId)
        {
            try
            {
                var result = await _attendanceLeaveDeleteRepository.LeaveDeletionForceAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL { PApplicationId = ApplicationId }
                    );
                if (result.PMessageType == "OK")
                {
                    if (!string.IsNullOrEmpty(result.PMedicalCertFileName))
                    {
                        StorageHelper.DeleteFile(StorageHelper.Attendance.RepositoryMedicalCertificate, result.PMedicalCertFileName, Configuration);
                    }
                }
                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        private List<DataField> getListHalfDayDay()
        {
            var list = new List<DataField>();
            list.Add(new DataField { DataTextField = "", DataValueField = "" });
            list.Add(new DataField { DataTextField = "END DATE - 1st half leave - 2nd half present", DataValueField = "1" });
            list.Add(new DataField { DataTextField = "BEGIN DATE - 2nd half leave - 1st half present", DataValueField = "2" });
            return list;
        }

        public async Task<IActionResult> DownloadMedicalCertificateFile(string KeyId)
        {
            var result = await _attendanceLeaveDetailsRepository.LeaveDetailsAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL { PApplicationId = KeyId });

            byte[] bytes = StorageHelper.DownloadFile(StorageHelper.Attendance.RepositoryMedicalCertificate, FileName: result.PMedCertFileNm, Configuration);
            return File(bytes, "application/octet-stream");
        }

        public async Task<IActionResult> LeavePLRevise(string ApplicationId)
        {
            var approvers = await _selectTcmPLRepository.ApproversListAsync(BaseSpTcmPLGet(), null);
            ViewData["Approvers"] = new SelectList(approvers, "DataValueField", "DataTextField");

            var halfDayDay = getListHalfDayDay();
            ViewData["HalfDayDay"] = new SelectList(halfDayDay, "DataValueField", "DataTextField");

            var applicationDetails = await _attendanceLeaveDetailsRepository.LeaveDetailsAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL { PApplicationId = ApplicationId });
            LeavePLReviseDetailCombineViewModel leavePLReviseDetailCombineViewModel = new LeavePLReviseDetailCombineViewModel();

            leavePLReviseDetailCombineViewModel.LeaveDetailsViewModel = new LeaveDetailsViewModel
            {
                ApplicationId = ApplicationId,
                Address = applicationDetails.PContactAddress,
                CareTaker = applicationDetails.PCareTaker,
                Discrepancies = applicationDetails.PDiscrepancy?.Replace("<br />", ""),
                EmpName = applicationDetails.PEmpName,
                EndDate = applicationDetails.PEndDate,
                FlagCanDel = applicationDetails.PFlagCanDel,
                FlagIsAdj = applicationDetails.PFlagIsAdj,
                HodApproval = applicationDetails.PHodApproval,
                HRApproval = applicationDetails.PHrApproval,
                LastReporting = applicationDetails.PLastReporting,
                LeadApproval = applicationDetails.PLeadApproval,
                LeadName = applicationDetails.PLeadName,
                LeavePeriod = applicationDetails.PLeavePeriod,
                LeaveType = applicationDetails.PLeaveType,
                MedCertFileNm = applicationDetails.PMedCertFileNm,
                MedicalCertificate = applicationDetails.PMedCertAvailable,
                PhoneNumber = applicationDetails.PContactPhone,
                POffice = applicationDetails.POffice,
                Project = applicationDetails.PProjno,
                Reason = applicationDetails.PReason,
                ResumingDuty = applicationDetails.PResuming,
                StartDate = applicationDetails.PStartDate,
                StdNumber = applicationDetails.PContactStd
            };
            leavePLReviseDetailCombineViewModel.LeavePLReviseViewModel = new LeavePLReviseViewModel
            {
                RevisedHalfDayDay = 0,
                ApplicationId = ApplicationId,
                LeaveType = applicationDetails.PLeaveType
            };
            return PartialView("_ModalLeavePLRevisePartial", leavePLReviseDetailCombineViewModel);
        }

        public async Task<IActionResult> LeavePLReviseReview(LeavePLReviseDetailCombineViewModel leavePLReviseDetailCombineViewModel)
        {
            var result = await _attendanceLeaveValidateRepository.ValidatePLRevision(BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PApplicationId = leavePLReviseDetailCombineViewModel.LeavePLReviseViewModel.ApplicationId,
                    PLeaveType = leavePLReviseDetailCombineViewModel.LeavePLReviseViewModel.LeaveType,
                    PStartDate = leavePLReviseDetailCombineViewModel.LeavePLReviseViewModel.RevisedStartDate,
                    PEndDate = leavePLReviseDetailCombineViewModel.LeavePLReviseViewModel.RevisedEndDate,
                    PHalfDayOn = leavePLReviseDetailCombineViewModel.LeavePLReviseViewModel.RevisedHalfDayDay
                });
            var approverDetails = await _attendanceEmployeeDetailsRepository.AttendanceEmployeeDetailsAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
                PEmpno = leavePLReviseDetailCombineViewModel.LeavePLReviseViewModel.RevisedAppover
            });
            ViewData["ApproverDetails"] = approverDetails;

            LeavePLReviseReviewViewModel leavePLReviseReviewViewModel = new LeavePLReviseReviewViewModel();

            leavePLReviseReviewViewModel.LeaveDetailsViewModel = leavePLReviseDetailCombineViewModel.LeaveDetailsViewModel;
            leavePLReviseReviewViewModel.LeavePLReviseViewModel = leavePLReviseDetailCombineViewModel.LeavePLReviseViewModel;
            leavePLReviseReviewViewModel.IsLeaveApplicationOk = result.PMessageType == "OK";
            leavePLReviseReviewViewModel.LastReporting = result.PLastReporting;
            leavePLReviseReviewViewModel.ResumingDuty = result.PResuming;
            leavePLReviseReviewViewModel.CalcLeavePeriod = result.PLeavePeriod;
            leavePLReviseReviewViewModel.Discrepancies = result.PMessageText;

            return PartialView("_ModalLeavePLReviseReviewPartial", leavePLReviseReviewViewModel);
        }

        public async Task<IActionResult> LeavePLReviseReviewModify(LeavePLReviseDetailCombineViewModel leavePLReviseDetailCombineViewModel)
        {
            var approvers = await _selectTcmPLRepository.ApproversListAsync(BaseSpTcmPLGet(), null);
            ViewData["Approvers"] = new SelectList(approvers, "DataValueField", "DataTextField", leavePLReviseDetailCombineViewModel.LeavePLReviseViewModel.RevisedAppover);
            return PartialView("_ModalLeavePLRevisePartial", leavePLReviseDetailCombineViewModel);
        }

        public async Task<IActionResult> LeavePLReviseReviewSave(LeavePLReviseDetailCombineViewModel leavePLReviseDetailCombineViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _attendanceLeaveCreateRepository.ReviseLeavePLAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL
                    {
                        PApplicationId = leavePLReviseDetailCombineViewModel.LeavePLReviseViewModel.ApplicationId,
                        PStartDate = leavePLReviseDetailCombineViewModel.LeavePLReviseViewModel.RevisedStartDate,
                        PEndDate = leavePLReviseDetailCombineViewModel.LeavePLReviseViewModel.RevisedEndDate,
                        PHalfDayOn = leavePLReviseDetailCombineViewModel.LeavePLReviseViewModel.RevisedHalfDayDay,
                        PLeadEmpno = leavePLReviseDetailCombineViewModel.LeavePLReviseViewModel.RevisedAppover
                    });

                    if (result.PMessageType != IsOk)
                        throw new Exception(result.PMessageText);
                    else
                        return Json(new { success = true, response = result.PMessageText });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            return View();
        }

        #endregion L e a v e

        #region LeaveLedger

        public async Task<IActionResult> LeaveLedgerIndex()
        {
            LeaveLedgerViewModel leaveLedgerViewModel = new LeaveLedgerViewModel();

            var retVal = await RetriveFilter(ConstFilterLeaveLedger);

            FilterDataModel filterDataModel = new FilterDataModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            leaveLedgerViewModel.FilterDataModel = filterDataModel;

            leaveLedgerViewModel.FilterDataModel.StartDate = leaveLedgerViewModel.FilterDataModel.StartDate ?? new DateTime(DateTime.Now.Year, 1, 1);
            leaveLedgerViewModel.FilterDataModel.EndDate = leaveLedgerViewModel.FilterDataModel.EndDate ?? new DateTime(DateTime.Now.Year, 12, 31);
            leaveLedgerViewModel.FilterDataModel.Empno = string.IsNullOrEmpty(leaveLedgerViewModel.FilterDataModel.Empno) ? CurrentUserIdentity.EmpNo : leaveLedgerViewModel.FilterDataModel.Empno;

            return View(leaveLedgerViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsLeaveLedger(DTParameters param)
        {
            DTResult<LeaveLedgerDataTableList> result = new DTResult<LeaveLedgerDataTableList>();
            int totalRow = 0;

            try
            {
                var data = await _attendanceLeaveLedgerDataTableListRepository.AttendanceLeaveLedgerDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
                        PStartDate = param.StartDate ?? new DateTime(DateTime.Now.Year, 1, 1),
                        PEndDate = param.EndDate ?? new DateTime(DateTime.Now.Year, 12, 31),
                        PEmpno = param.Empno
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

        public async Task<IActionResult> LeaveLedgerFilterGet()
        {
            var empdetails = await _attendanceEmployeeDetailsRepository.AttendanceEmployeeDetailsAsync(BaseSpTcmPLGet(), null);

            var retVal = await RetriveFilter(ConstFilterLeaveLedger);

            FilterDataModel filterDataModel = new FilterDataModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            ViewData["EmpList"] = await getEmployeeSelectList(filterDataModel.Empno);

            return PartialView("_ModalLeaveLedgerFilterSet", filterDataModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> LeaveLedgerGetBalance(DTParameters param)
        {
            try
            {
                //throw new Exception("Testing");
                var empdetails = await _attendanceEmployeeDetailsRepository.AttendanceEmployeeDetailsAsync(BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PEmpno = param.Empno
                    }
                );

                var result = await _attendanceLeaveLedgerBalance.LeaveBalancesAllAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL
                {
                    PStartDate = param.StartDate,
                    PEndDate = param.EndDate,
                    PEmpno = param.Empno
                });

                return Json(new
                {
                    Empno = empdetails.Empno,
                    EmployeeName = empdetails.Name,
                    OpeningBalanceAsOn = param.StartDate?.ToString("dd-MMM-yyyy"),
                    ClosingBalanceAsOn = param.EndDate?.ToString("dd-MMM-yyyy"),
                    Ocl = result.POpenCl,
                    Osl = result.POpenSl,
                    Opl = result.POpenPl,
                    Oex = result.POpenEx,
                    Oco = result.POpenCo,
                    Oho = result.POpenOh,
                    Olv = result.POpenLv,
                    Ccl = result.PCloseCl,
                    Csl = result.PCloseSl,
                    Cpl = result.PClosePl,
                    Cex = result.PCloseEx,
                    Cco = result.PCloseCo,
                    Cho = result.PCloseOh,
                    Clv = result.PCloseLv
                });
            }
            catch (Exception ex)
            {
                return Json(new { error = ex.Message });
            }
        }

        [HttpPost]
        public async Task<IActionResult> LeaveLedgerFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                if (filterDataModel.StartDate != null || filterDataModel.EndDate != null)
                {
                    if (filterDataModel.StartDate == null || filterDataModel.EndDate == null)
                        throw new Exception("Both the dates are reqired.");
                    else if (filterDataModel.StartDate?.ToString("yyyy") != filterDataModel.EndDate?.ToString("yyyy"))
                        throw new Exception("Date range should be with in same year.");
                    else if (filterDataModel.StartDate > filterDataModel.EndDate)
                        throw new Exception("End date should be greater than start date");
                }

                string jsonFilter;
                jsonFilter = JsonConvert.SerializeObject(
                        new
                        {
                            StartDate = filterDataModel.StartDate,
                            EndDate = filterDataModel.EndDate,
                            Empno = filterDataModel.Empno
                        });

                _ = await CreateFilter(jsonFilter, ConstFilterLeaveLedger);

                return Json(new { success = true, startDate = filterDataModel.StartDate, endDate = filterDataModel.EndDate, empno = filterDataModel.Empno });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        #endregion LeaveLedger

        #region OnDuty

        public async Task<IActionResult> OnDutyFilterGet()
        {
            var empdetails = await _attendanceEmployeeDetailsRepository.AttendanceEmployeeDetailsAsync(BaseSpTcmPLGet(), null);

            var onDutyTypes = await _selectTcmPLRepository.OnDutyTypeListForFilterAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["OnDutyTypes"] = new SelectList(onDutyTypes, "DataValueField", "DataTextField");

            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterOndutyIndex
            });

            FilterDataModel filterDataModel = new FilterDataModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            if (string.IsNullOrEmpty(filterDataModel.Empno))
                filterDataModel.Empno = empdetails.Empno;

            ViewData["EmpList"] = await getEmployeeSelectList(filterDataModel.Empno);

            return PartialView("_ModalOnDutyFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> OnDutyFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                if (filterDataModel.StartDate != null || filterDataModel.EndDate != null)
                {
                    if (filterDataModel.StartDate == null || filterDataModel.EndDate == null)
                        throw new Exception("Both the dates are required.");
                    else if (filterDataModel.StartDate?.ToString("yyyy") != filterDataModel.EndDate?.ToString("yyyy"))
                        throw new Exception("Date range should be with in same year.");
                    else if (filterDataModel.StartDate > filterDataModel.EndDate)
                        throw new Exception("End date should be greater than start date");
                }
                {
                    string jsonFilter;
                    if (filterDataModel.Empno == CurrentUserIdentity.EmpNo)
                        filterDataModel.Empno = "";
                    jsonFilter = JsonConvert.SerializeObject(
                            new
                            {
                                StartDate = filterDataModel.StartDate,
                                EndDate = filterDataModel.EndDate,
                                Empno = filterDataModel.Empno,
                                OndutyType = filterDataModel.OndutyType
                            });

                    var retVal = await _filterRepository.FilterCreateAsync(new Domain.Models.FilterCreate
                    {
                        PModuleName = CurrentUserIdentity.CurrentModule,
                        PMetaId = CurrentUserIdentity.MetaId,
                        PPersonId = CurrentUserIdentity.EmployeeId,
                        PMvcActionName = ConstFilterOndutyIndex,
                        PFilterJson = jsonFilter
                    });

                    return Json(new
                    {
                        success = true,
                        startDate = filterDataModel.StartDate,
                        endDate = filterDataModel.EndDate,
                        ondutyType = filterDataModel.OndutyType,
                        empno = filterDataModel.Empno
                    });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
            //return PartialView("_ModalOnDutyFilterSet", filterDataModel);
        }

        private List<DataField> getListOndutySubType()
        {
            var list = new List<DataField>();
            list.Add(new DataField { DataTextField = "", DataValueField = "" });
            list.Add(new DataField { DataTextField = "From Residence -> OnDuty -> Reporting to office", DataValueField = "1" });
            list.Add(new DataField { DataTextField = "From Office -> OnDuty -> Reporting to office", DataValueField = "2" });
            list.Add(new DataField { DataTextField = "From Office -> OnDuty -> Not reporting to office", DataValueField = "3" });
            list.Add(new DataField { DataTextField = "From Residence -> OnDuty -> Not reporting to office", DataValueField = "4" });
            return list;
        }

        public async Task<IActionResult> OnDutyIndex()
        {
            var empdetails = await _attendanceEmployeeDetailsRepository.AttendanceEmployeeDetailsAsync(BaseSpTcmPLGet(), null);
            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterOndutyIndex
            });
            FilterDataModel filterDataModel = new FilterDataModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            //if (string.IsNullOrEmpty(filterDataModel.Empno))
            //    filterDataModel.Empno = empdetails.Empno;

            LeaveOnDutyApplicationsViewModel leaveOnDutyApplicationsViewModel = new LeaveOnDutyApplicationsViewModel();
            leaveOnDutyApplicationsViewModel.FilterDataModel = filterDataModel;
            return View(leaveOnDutyApplicationsViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsOnDutyApplications(DTParameters param)
        {
            DTResult<LeaveOnDutyApplicationsDataTableList> result = new DTResult<LeaveOnDutyApplicationsDataTableList>();
            int totalRow = 0;

            try
            {
                var data = await _attendanceOnDutyApplicationsDataTableListRepository.AttendanceOnDutyApplicationsDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = param.Start,
                        PPageLength = param.Length,

                        PEmpno = param.Empno,
                        PStartDate = param.StartDate,
                        PEndDate = param.EndDate,
                        POndutyType = param.OndutyType,
                        //Search = param.GenericSearch,
                        //BusinessEntityId = param.BusinessEntityId,
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
        public async Task<JsonResult> GetListsOnDutyApplicationsHeader(DTParameters param)
        {
            var empdetails = await _attendanceEmployeeDetailsRepository.AttendanceEmployeeDetailsAsync(BaseSpTcmPLGet(),
                          new ParameterSpTcmPL
                          {
                              PEmpno = param.Empno
                          }
                          );
            return Json(new { empno = empdetails.Empno, employeeName = empdetails.Name });
        }

        [HttpGet]
        public async Task<IActionResult> OnDutyCreateTab1()
        {
            var selfDetail = await _attendanceEmployeeDetailsRepository.AttendanceEmployeeDetailsAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            LeaveOnDutyTab1ViewModel leaveOnDutyTab1ViewModel = new LeaveOnDutyTab1ViewModel();

            var empSWStatus = await _attendanceOnDutyCreateRepository.CheckEmpOndutySWAsync(
                   BaseSpTcmPLGet(),
                   new ParameterSpTcmPL
                   {
                       PEmpno = selfDetail.Empno,
                   });
            bool IsEmpInSmartWork = false;

            if (empSWStatus.PMessageType == "OK")
            {
                IsEmpInSmartWork = true;
            }

            ViewData["IsEmpInSmartWork"] = IsEmpInSmartWork;

            if (CurrentUserIdentity.ProfileActions.Any(p => p.RoleId == SelfServiceHelper.RoleAttendanceAdmin))
            {
                var employees = await _selectTcmPLRepository.EmployeeListForHRAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());
                ViewData["EmployeeList"] = new SelectList(employees, "DataValueField", "DataTextField", selfDetail.Empno);
            }
            else
                leaveOnDutyTab1ViewModel.Empno = selfDetail.Empno;

            var LeaveOnDutyTypes = await _selectTcmPLRepository.OnDutyTypeListAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL { PGroupNo = 1 });
            ViewData["LeaveOnDutyTypes"] = new SelectList(LeaveOnDutyTypes, "DataValueField", "DataTextField");

            var Approvers = await _selectTcmPLRepository.ApproversListAsync(BaseSpTcmPLGet(), null);
            ViewData["Approvers"] = new SelectList(Approvers, "DataValueField", "DataTextField");

            return PartialView("_ModalOnDutyTab1Partial", leaveOnDutyTab1ViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> OnDutyCreateTab2()
        {
            var selfDetail = await _attendanceEmployeeDetailsRepository.AttendanceEmployeeDetailsAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            LeaveOnDutyTab2ViewModel leaveOnDutyTab2ViewModel = new LeaveOnDutyTab2ViewModel();

            var empSWStatus = await _attendanceOnDutyCreateRepository.CheckEmpOndutySWAsync(
                   BaseSpTcmPLGet(),
                   new ParameterSpTcmPL
                   {
                       PEmpno = selfDetail.Empno,
                   });
            bool IsEmpInSmartWork = false;

            if (empSWStatus.PMessageType == "OK")
            {
                IsEmpInSmartWork = true;
            }

            ViewData["IsEmpInSmartWork"] = IsEmpInSmartWork;

            if (CurrentUserIdentity.ProfileActions.Any(p => p.RoleId == SelfServiceHelper.RoleAttendanceAdmin))
            {
                var employees = await _selectTcmPLRepository.EmployeeListForHRAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());
                ViewData["EmployeeList"] = new SelectList(employees, "DataValueField", "DataTextField", selfDetail.Empno);
            }
            else
                leaveOnDutyTab2ViewModel.Empno = selfDetail.Empno;

            var LeaveOnDutyTypes = await _selectTcmPLRepository.OnDutyTypeListAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL { PGroupNo = 2 });
            ViewData["LeaveOnDutyTypes"] = new SelectList(LeaveOnDutyTypes, "DataValueField", "DataTextField");

            var Approvers = await _selectTcmPLRepository.ApproversListAsync(BaseSpTcmPLGet(), null);
            ViewData["Approvers"] = new SelectList(Approvers, "DataValueField", "DataTextField");

            return PartialView("_ModalOnDutyTab2Partial", leaveOnDutyTab2ViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> OnDutyCreateTab3()
        {
            var selfDetail = await _attendanceEmployeeDetailsRepository.AttendanceEmployeeDetailsAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            LeaveOnDutyTab3ViewModel leaveOnDutyTab3ViewModel = new LeaveOnDutyTab3ViewModel();

            var empSWStatus = await _attendanceOnDutyCreateRepository.CheckEmpOndutySWAsync(
                   BaseSpTcmPLGet(),
                   new ParameterSpTcmPL
                   {
                       PEmpno = selfDetail.Empno,
                   });
            bool IsEmpInSmartWork = false;

            if (empSWStatus.PMessageType == "OK")
            {
                IsEmpInSmartWork = true;
            }

            ViewData["IsEmpInSmartWork"] = IsEmpInSmartWork;

            if (CurrentUserIdentity.ProfileActions.Any(p => p.RoleId == SelfServiceHelper.RoleAttendanceAdmin))
            {
                var employees = await _selectTcmPLRepository.EmployeeListForHRAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());
                ViewData["EmployeeList"] = new SelectList(employees, "DataValueField", "DataTextField", selfDetail.Empno);
            }
            else
                leaveOnDutyTab3ViewModel.Empno = selfDetail.Empno;

            var LeaveOnDutyTypes = await _selectTcmPLRepository.OnDutyTypeListAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL { PGroupNo = 3 });
            ViewData["LeaveOnDutyTypes"] = new SelectList(LeaveOnDutyTypes, "DataValueField", "DataTextField");

            var Approvers = await _selectTcmPLRepository.ApproversListAsync(BaseSpTcmPLGet(), null);
            ViewData["Approvers"] = new SelectList(Approvers, "DataValueField", "DataTextField");

            var type = getListOndutySubType();
            ViewData["OndutySubType"] = new SelectList(type, "DataValueField", "DataTextField");

            return PartialView("_ModalOnDutyTab3Partial", leaveOnDutyTab3ViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> OnDutyCreateTab4()
        {
            var selfDetail = await _attendanceEmployeeDetailsRepository.AttendanceEmployeeDetailsAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            LeaveOnDutyTab4ViewModel leaveOnDutyTab4ViewModel = new LeaveOnDutyTab4ViewModel();

            var empSWStatus = await _attendanceOnDutyCreateRepository.CheckEmpOndutySWAsync(
                   BaseSpTcmPLGet(),
                   new ParameterSpTcmPL
                   {
                       PEmpno = selfDetail.Empno,
                   });
            bool IsEmpInSmartWork = false;

            if (empSWStatus.PMessageType == "OK")
            {
                IsEmpInSmartWork = true;
            }

            ViewData["IsEmpInSmartWork"] = IsEmpInSmartWork;

            if (CurrentUserIdentity.ProfileActions.Any(p => p.RoleId == SelfServiceHelper.RoleAttendanceAdmin))
            {
                var employees = await _selectTcmPLRepository.EmployeeListForHRAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());
                ViewData["EmployeeList"] = new SelectList(employees, "DataValueField", "DataTextField", selfDetail.Empno);
            }
            else
                leaveOnDutyTab4ViewModel.Empno = selfDetail.Empno;

            var LeaveOnDutyTypes = await _selectTcmPLRepository.OnDutyTypeListAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL { PGroupNo = 4 });
            ViewData["LeaveOnDutyTypes"] = new SelectList(LeaveOnDutyTypes, "DataValueField", "DataTextField");

            var Approvers = await _selectTcmPLRepository.ApproversListAsync(BaseSpTcmPLGet(), null);
            ViewData["Approvers"] = new SelectList(Approvers, "DataValueField", "DataTextField");

            return PartialView("_ModalOnDutyTab4Partial", leaveOnDutyTab4ViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> OnDutyCreateTab5()
        {
            var selfDetail = await _attendanceEmployeeDetailsRepository.AttendanceEmployeeDetailsAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            LeaveOnDutyTab5ViewModel leaveOnDutyTab5ViewModel = new LeaveOnDutyTab5ViewModel();

            leaveOnDutyTab5ViewModel.Empno = selfDetail.Empno;

            var Approvers = await _selectTcmPLRepository.ApproversListAsync(BaseSpTcmPLGet(), null);
            ViewData["Approvers"] = new SelectList(Approvers, "DataValueField", "DataTextField");

            return PartialView("_ModalOnDutyTab5Partial", leaveOnDutyTab5ViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> OnDutyCreateTab6()
        {
            var selfDetail = await _attendanceEmployeeDetailsRepository.AttendanceEmployeeDetailsAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            LeaveOnDutyTab6ViewModel leaveOnDutyTab6ViewModel = new LeaveOnDutyTab6ViewModel();

            var empSWStatus = await _attendanceOnDutyCreateRepository.CheckEmpOndutySWAsync(
                   BaseSpTcmPLGet(),
                   new ParameterSpTcmPL
                   {
                       PEmpno = selfDetail.Empno,
                   });
            bool IsEmpInSmartWork = false;

            if (empSWStatus.PMessageType == "OK")
            {
                IsEmpInSmartWork = true;
            }

            ViewData["IsEmpInSmartWork"] = IsEmpInSmartWork;

            leaveOnDutyTab6ViewModel.Empno = selfDetail.Empno;

            var Approvers = await _selectTcmPLRepository.ApproversListAsync(BaseSpTcmPLGet(), null);
            ViewData["Approvers"] = new SelectList(Approvers, "DataValueField", "DataTextField");

            return PartialView("_ModalOnDutyTab6Partial", leaveOnDutyTab6ViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> OnDutyCreateTab1([FromForm] LeaveOnDutyTab1ViewModel leaveOnDutyTab1ViewModel, string submit)
        {
            try
            {
                string redirectToAction = ondutyCreateTabRedirectToAction(submit);
                if (!string.IsNullOrEmpty(redirectToAction) && redirectToAction != "Confirm")
                    return RedirectToAction(redirectToAction);

                //if (submit != "Confirm")
                //{
                //    return RedirectToAction("OnDutyCreateTab1");
                //}

                if (ModelState.IsValid)
                {
                    var result = await _attendanceOnDutyCreateRepository.CreateOnDutyPunchEntryAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PEmpno = leaveOnDutyTab1ViewModel.Empno,
                            PHh1 = leaveOnDutyTab1ViewModel.FromHRS.Split(":")[0],
                            PMi1 = leaveOnDutyTab1ViewModel.FromHRS.Split(":")[1],
                            PDate = leaveOnDutyTab1ViewModel.StartDate,
                            PType = leaveOnDutyTab1ViewModel.OndutyType,
                            PLeadApprover = leaveOnDutyTab1ViewModel.Approvers,
                            PReason = leaveOnDutyTab1ViewModel.Reason,
                        });
                    ;

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

            var approvers = await _selectTcmPLRepository.ApproversListAsync(BaseSpTcmPLGet(), null);
            ViewData["Approvers"] = new SelectList(approvers, "DataValueField", "DataTextField", leaveOnDutyTab1ViewModel.Approvers);

            return PartialView("_ModalOnDutyTab1Partial", leaveOnDutyTab1ViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> OnDutyCreateTab2([FromForm] LeaveOnDutyTab2ViewModel leaveOnDutyTab2ViewModel, string submit)
        {
            try
            {
                string redirectToAction = ondutyCreateTabRedirectToAction(submit);
                if (!string.IsNullOrEmpty(redirectToAction) && redirectToAction != "Confirm")
                    return RedirectToAction(redirectToAction);

                if (submit != "Confirm")
                {
                    return RedirectToAction("OnDutyCreateTab2");
                }

                if (ModelState.IsValid)
                {
                    var result = await _attendanceOnDutyCreateRepository.CreateOnDutyPunchEntryAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PEmpno = leaveOnDutyTab2ViewModel.Empno,
                            PHh1 = leaveOnDutyTab2ViewModel.FromHRS.Split(":")[0],
                            PMi1 = leaveOnDutyTab2ViewModel.FromHRS.Split(":")[1],
                            PHh2 = leaveOnDutyTab2ViewModel.ToHRS.Split(":")[0],
                            PMi2 = leaveOnDutyTab2ViewModel.ToHRS.Split(":")[1],
                            PDate = leaveOnDutyTab2ViewModel.StartDate,
                            PType = leaveOnDutyTab2ViewModel.OndutyType,
                            PLeadApprover = leaveOnDutyTab2ViewModel.Approvers,
                            PReason = leaveOnDutyTab2ViewModel.Reason
                        });
                    ;

                    if (result.PMessageType != IsOk)
                    {
                        throw new Exception(result.PMessageText);
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

            var approvers = await _selectTcmPLRepository.ApproversListAsync(BaseSpTcmPLGet(), null);
            ViewData["Approvers"] = new SelectList(approvers, "DataValueField", "DataTextField", leaveOnDutyTab2ViewModel.Approvers);

            var empSWStatus = await _attendanceOnDutyCreateRepository.CheckEmpOndutySWAsync(
                   BaseSpTcmPLGet(),
                   new ParameterSpTcmPL
                   {
                       PEmpno = leaveOnDutyTab2ViewModel.Empno,
                   });
            bool IsEmpInSmartWork = false;

            if (empSWStatus.PMessageType == "OK")
            {
                IsEmpInSmartWork = true;
            }

            ViewData["IsEmpInSmartWork"] = IsEmpInSmartWork;

            return PartialView("_ModalOnDutyTab2Partial", leaveOnDutyTab2ViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> OnDutyCreateTab3([FromForm] LeaveOnDutyTab3ViewModel leaveOnDutyTab3ViewModel, string submit)
        {
            try
            {
                string redirectToAction = ondutyCreateTabRedirectToAction(submit);
                if (!string.IsNullOrEmpty(redirectToAction) && redirectToAction != "Confirm")
                    return RedirectToAction(redirectToAction);

                if (submit != "Confirm")
                {
                    return RedirectToAction("OnDutyCreateTab3");
                }

                if (ModelState.IsValid)
                {
                    var result = await _attendanceOnDutyCreateRepository.CreateOnDutyPunchEntryAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PEmpno = leaveOnDutyTab3ViewModel.Empno,
                            PHh1 = leaveOnDutyTab3ViewModel.FromHRS.Split(":")[0],
                            PMi1 = leaveOnDutyTab3ViewModel.FromHRS.Split(":")[1],
                            PHh2 = leaveOnDutyTab3ViewModel.ToHRS.Split(":")[0],
                            PMi2 = leaveOnDutyTab3ViewModel.ToHRS.Split(":")[1],
                            PDate = leaveOnDutyTab3ViewModel.StartDate,
                            PType = leaveOnDutyTab3ViewModel.OndutyType,
                            PLeadApprover = leaveOnDutyTab3ViewModel.Approvers,
                            PReason = leaveOnDutyTab3ViewModel.Reason,
                            PSubType = leaveOnDutyTab3ViewModel.OndutySubType
                        });
                    ;

                    if (result.PMessageType != IsOk)
                    {
                        throw new Exception(result.PMessageText);
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

            var leaveOnDutyTypes = await _selectTcmPLRepository.OnDutyTypeListAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL { PGroupNo = 3 });
            ViewData["leaveOnDutyTypes"] = new SelectList(leaveOnDutyTypes, "DataValueField", "DataTextField", leaveOnDutyTab3ViewModel.OndutyType);

            var approvers = await _selectTcmPLRepository.ApproversListAsync(BaseSpTcmPLGet(), null);
            ViewData["Approvers"] = new SelectList(approvers, "DataValueField", "DataTextField", leaveOnDutyTab3ViewModel.Approvers);

            var type = getListOndutySubType();
            ViewData["OndutySubType"] = new SelectList(type, "DataValueField", "DataTextField");

            return PartialView("_ModalOnDutyTab3Partial", leaveOnDutyTab3ViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> OnDutyCreateTab4([FromForm] LeaveOnDutyTab4ViewModel leaveOnDutyTab4ViewModel, string submit)
        {
            try
            {
                string redirectToAction = ondutyCreateTabRedirectToAction(submit);
                if (!string.IsNullOrEmpty(redirectToAction) && redirectToAction != "Confirm")
                    return RedirectToAction(redirectToAction);

                if (submit != "Confirm")
                {
                    return RedirectToAction("OnDutyCreateTab4");
                }

                if (ModelState.IsValid)
                {
                    var result = await _attendanceOnDutyCreateRepository.CreateOnDutyDepuTourAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PEmpno = leaveOnDutyTab4ViewModel.Empno,
                            PStartDate = leaveOnDutyTab4ViewModel.StartDate,
                            PEndDate = leaveOnDutyTab4ViewModel.EndDate,
                            PType = leaveOnDutyTab4ViewModel.OndutyType,
                            PLeadApprover = leaveOnDutyTab4ViewModel.Approvers,
                            PReason = leaveOnDutyTab4ViewModel.Reason,
                        });
                    ;

                    if (result.PMessageType != IsOk)
                    {
                        throw new Exception(result.PMessageText);
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

            var approvers = await _selectTcmPLRepository.ApproversListAsync(BaseSpTcmPLGet(), null);
            ViewData["Approvers"] = new SelectList(approvers, "DataValueField", "DataTextField", leaveOnDutyTab4ViewModel.Approvers);

            return PartialView("_ModalOnDutyTab4Partial", leaveOnDutyTab4ViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> OnDutyCreateTab5([FromForm] LeaveOnDutyTab5ViewModel leaveOnDutyTab5ViewModel, string submit)
        {
            try
            {
                string redirectToAction = ondutyCreateTabRedirectToAction(submit);
                if (!string.IsNullOrEmpty(redirectToAction) && redirectToAction != "Confirm")
                    return RedirectToAction(redirectToAction);

                if (submit != "Confirm")
                {
                    return RedirectToAction("OnDutyCreateTab5");
                }

                if (ModelState.IsValid)
                {
                    var result = await _attendanceOnDutyCreateRepository.CreateOnDutyDepuTourAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PEmpno = leaveOnDutyTab5ViewModel.Empno,
                            PStartDate = leaveOnDutyTab5ViewModel.StartDate,
                            PEndDate = leaveOnDutyTab5ViewModel.StartDate,
                            PType = leaveOnDutyTab5ViewModel.OndutyType,
                            PLeadApprover = "None",
                            PReason = leaveOnDutyTab5ViewModel.Reason,
                        });
                    ;

                    if (result.PMessageType != IsOk)
                    {
                        throw new Exception(result.PMessageText);
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

            return PartialView("_ModalOnDutyTab5Partial", leaveOnDutyTab5ViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> OnDutyCreateTab6([FromForm] LeaveOnDutyTab6ViewModel leaveOnDutyTab6ViewModel, string submit)
        {
            try
            {
                string redirectToAction = ondutyCreateTabRedirectToAction(submit);
                if (!string.IsNullOrEmpty(redirectToAction) && redirectToAction != "Confirm")
                    return RedirectToAction(redirectToAction);

                if (submit != "Confirm")
                {
                    return RedirectToAction("OnDutyCreateTab6");
                }

                if (ModelState.IsValid)
                {
                    var result = await _attendanceOnDutyCreateRepository.CreateOnDutyDepuTourAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PEmpno = leaveOnDutyTab6ViewModel.Empno,
                            PStartDate = leaveOnDutyTab6ViewModel.StartDate,
                            PEndDate = leaveOnDutyTab6ViewModel.StartDate,
                            PType = leaveOnDutyTab6ViewModel.OndutyType,
                            PLeadApprover = "None",
                            PReason = leaveOnDutyTab6ViewModel.Reason,
                        });
                    ;

                    if (result.PMessageType != IsOk)
                    {
                        throw new Exception(result.PMessageText);
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

            return PartialView("_ModalOnDutyTab6Partial", leaveOnDutyTab6ViewModel);
        }

        private string ondutyCreateTabRedirectToAction(string submit)
        {
            if (submit == "Details1")
            {
                return ("OnDutyCreateTab1");
            }
            if (submit == "Details2")
            {
                return ("OnDutyCreateTab2");
            }
            if (submit == "Details3")
            {
                return ("OnDutyCreateTab3");
            }
            if (submit == "Details4")
            {
                return ("OnDutyCreateTab4");
            }
            if (submit == "Details5")
            {
                return ("OnDutyCreateTab5");
            }
            if (submit == "Details6")
            {
                return ("OnDutyCreateTab6");
            }
            return string.Empty;
        }

        [HttpPost]
        public async Task<IActionResult> OnDutyDelete(string ApplicationId)
        {
            try
            {
                var result = await _attendanceOnDutyDeleteRepository.OnDutyDeleteAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL { PApplicationId = ApplicationId }
                    );

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleAttendanceAdmin)]
        [HttpPost]
        public async Task<IActionResult> OnDutyDeleteForce(string ApplicationId, string Empno)
        {
            try
            {
                var result = await _attendanceOnDutyDeleteRepository.OnDutyDeleteAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL { PApplicationId = ApplicationId, PEmpno = Empno }
                    );

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        [HttpGet]
        public async Task<IActionResult> OnDutyDetails(string ApplicationId)
        {
            var result = await _attendanceOnDutyDetailsRepository.OnDutyDetailsAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL { PApplicationId = ApplicationId });

            OnDutyDetailsViewModel onDutyDetailsViewModel = new OnDutyDetailsViewModel
            {
                ApplicationId = ApplicationId,
                EmpName = result.PEmpName,
                EndDate = result.PEndDate,
                HodApproval = result.PHodApproval,
                HRApproval = result.PHrApproval,
                LeadApproval = result.PLeadApproval,
                LeadName = result.PLeadName,
                OnDutyType = result.POndutyType,
                OnDutySubType = result.POndutySubType,
                StartTime = result.PHh1 + ":" + result.PMi1,
                EndTime = result.PHh2 + ":" + result.PMi2,
                Reason = result.PReason,
                StartDate = result.PStartDate,
            };

            return PartialView("_ModalOnDutyDetailPartial", onDutyDetailsViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> OnDutyDeputationExtension(string ApplicationId)
        {
            var result = await _attendanceOnDutyDetailsRepository.OnDutyDetailsAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL { PApplicationId = ApplicationId });

            OnDutyDeputationExtensionViewModel onDutyDeputationExtensionViewModel = new OnDutyDeputationExtensionViewModel
            {
                ApplicationId = ApplicationId,
                EmpName = result.PEmpName,
                EndDate = result.PEndDate,
                HodApproval = result.PHodApproval,
                HRApproval = result.PHrApproval,
                LeadApproval = result.PLeadApproval,
                LeadName = result.PLeadName,
                OnDutyType = result.POndutyType,
                OnDutySubType = result.POndutySubType,
                StartTime = result.PHh1 + ":" + result.PMi1,
                EndTime = result.PHh2 + ":" + result.PMi2,
                Reason = result.PReason,
                StartDate = result.PStartDate,
            };

            return PartialView("_ModalOnDutyDeputationExtensionPartial", onDutyDeputationExtensionViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> OnDutyDeputationExtension([FromForm] OnDutyDeputationExtensionViewModel onDutyDeputationExtensionViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _attendanceOnDutyCreateRepository.ExtendDeputationAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PApplicationId = onDutyDeputationExtensionViewModel.ApplicationId,
                            PReason = onDutyDeputationExtensionViewModel.Reason,
                            PEndDate = onDutyDeputationExtensionViewModel.NewEndDate,
                        });
                    ;

                    if (result.PMessageType != IsOk)
                    {
                        throw new Exception(result.PMessageText);
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

            return PartialView("_ModalOnDutyDeputationExtensionPartial", onDutyDeputationExtensionViewModel);
        }

        #endregion OnDuty

        #region GuestAttendance

        public IActionResult GuestAttendanceFilterGet()
        {
            FilterDataModel filterDataModel = new FilterDataModel();
            return PartialView("_ModalGuestAttendanceFilterSet", filterDataModel);
        }

        [HttpPost]
        public IActionResult GuestAttendanceFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                if (filterDataModel.StartDate != null || filterDataModel.EndDate != null)
                {
                    if (filterDataModel.StartDate == null || filterDataModel.EndDate == null)
                        throw new Exception("Both the dates are reqired.");
                    else if (filterDataModel.StartDate?.ToString("yyyy") != filterDataModel.EndDate?.ToString("yyyy"))
                        throw new Exception("Date range should be with in same year.");
                    else if (filterDataModel.StartDate > filterDataModel.EndDate)
                        throw new Exception("End date should be greater than start date");
                    else
                        return Json(new { success = true, startDate = filterDataModel.StartDate, endDate = filterDataModel.EndDate });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
            return PartialView("_ModalGuestAttendanceFilterSet", filterDataModel);
        }

        public IActionResult GuestAttendanceIndex()
        {
            GuestAttendanceViewModel guestAttendanceViewModel = new GuestAttendanceViewModel();
            return View(guestAttendanceViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsGuestAttendance(DTParameters param)
        {
            DTResult<GuestAttendanceDataTableList> result = new DTResult<GuestAttendanceDataTableList>();
            int totalRow = 0;

            try
            {
                var data = await _attendanceGuestAttendanceDataTableListRepository.AttendanceGuestAttendanceDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
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

        public IActionResult GuestAttendanceCreate()
        {
            var meetingPlace = _selectTcmPLRepository.GetListOffice();
            ViewData["MeetingPlace"] = new SelectList(meetingPlace, "DataValueField", "DataTextField");

            //var guestAttendanceTypes = await _selectTcmPLRepository.GuestAttendanceTypeListAsync(BaseSpTcmPLGet(), null);
            //ViewData["GuestAttendanceTypes"] = new SelectList(guestAttendanceTypes, "DataValueField", "DataTextField");

            //var approvers = await _selectTcmPLRepository.ApproversListAsync(BaseSpTcmPLGet(), null);
            //ViewData["Approvers"] = new SelectList(approvers, "DataValueField", "DataTextField");

            GuestAttendanceCreateViewModel guestAttendanceCreateViewModel = new GuestAttendanceCreateViewModel();
            return PartialView("_ModalGuestAttendanceCreatePartial", guestAttendanceCreateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> GuestAttendanceCreate([FromForm] GuestAttendanceCreateViewModel guestAttendanceCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _attendanceGuestAttendanceCreateRepository.CreateGuestAttendanceAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PGuestName = guestAttendanceCreateViewModel.GuestName,
                            PGuestCompany = guestAttendanceCreateViewModel.GuestCompany,
                            PHh1 = guestAttendanceCreateViewModel.FromHRS.Split(":")[0],
                            PMi1 = guestAttendanceCreateViewModel.FromHRS.Split(":")[1],
                            PDate = guestAttendanceCreateViewModel.StartDate,
                            POffice = guestAttendanceCreateViewModel.MeetingPlace,
                            PReason = guestAttendanceCreateViewModel.Remarks,
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

            var meetingPlace = _selectTcmPLRepository.GetListOffice();
            ViewData["MeetingPlace"] = new SelectList(meetingPlace, "DataValueField", "DataTextField");

            return PartialView("_ModalGuestAttendanceCreatePartial", guestAttendanceCreateViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> GuestAttendanceDelete(string ApplicationId)
        {
            try
            {
                var result = await _attendanceGuestAttendanceDeleteRepository.DeleteGuestAttendanceAsync(
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

        #endregion GuestAttendance

        #region GuestAttendanceAdmin

        public IActionResult GuestAttendanceAdminFilterGet()
        {
            FilterDataModel filterDataModel = new FilterDataModel();
            return PartialView("_ModalGuestAttendanceAdminFilterSet", filterDataModel);
        }

        [HttpPost]
        public IActionResult GuestAttendanceAdminFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                if (filterDataModel.StartDate != null || filterDataModel.EndDate != null)
                {
                    if (filterDataModel.StartDate == null || filterDataModel.EndDate == null)
                        throw new Exception("Both the dates are reqired.");
                    else if (filterDataModel.StartDate?.ToString("yyyy") != filterDataModel.EndDate?.ToString("yyyy"))
                        throw new Exception("Date range should be with in same year.");
                    else if (filterDataModel.StartDate > filterDataModel.EndDate)
                        throw new Exception("End date should be greater than start date");
                    else
                        return Json(new { success = true, startDate = filterDataModel.StartDate, endDate = filterDataModel.EndDate });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
            return PartialView("_ModalGuestAttendanceAdminFilterSet", filterDataModel);
        }

        //[RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SelfServiceHelper.ActionViewGuestAttendanceAdmin)]
        public IActionResult GuestAttendanceAdminIndex()
        {
            GuestAttendanceViewModel guestAttendanceViewModel = new GuestAttendanceViewModel();
            return View(guestAttendanceViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> GetListsGuestAttendanceAdmin(DTParameters param)
        {
            DTResult<GuestAttendanceDataTableList> result = new DTResult<GuestAttendanceDataTableList>();
            int totalRow = 0;

            try
            {
                var data = await _attendanceGuestAttendanceDataTableListRepository.AttendanceGuestAttendanceAdminDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
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
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        #endregion GuestAttendanceAdmin

        #region Approval

        public string TrimString(string strVal)
        {
            string result = "";

            if (!string.IsNullOrEmpty(strVal))
            {
                result = strVal.Trim();
            }
            return result;
        }

        #region Lead

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleLead)]
        public IActionResult LeadApprovalLeaveIndex()
        {
            return View();
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleLead)]
        public IActionResult LeadApprovalLeaveSLIndex()
        {
            return View();
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleLead)]
        public IActionResult LeadApprovalExtraHoursIndex()
        {
            return View();
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleLead)]
        public IActionResult LeadApprovalOnDutyIndex()
        {
            return View();
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleLead)]
        public IActionResult LeadApprovalHolidayAttendanceIndex()
        {
            return View();
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleLead)]
        public async Task<JsonResult> GetListsLeadApprovalOnDuty(DTParameters param)
        {
            DTResult<LeaveOnDutyApprovalDataTableList> result = new DTResult<LeaveOnDutyApprovalDataTableList>();
            int totalRow = 0;

            try
            {
                var data = await _attendanceOnDutyApprovalDataTableListRepository.AttendanceOnDutyLeadApprovalDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
                        //Search = param.GenericSearch,
                        //BusinessEntityId = param.BusinessEntityId,
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
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleLead)]
        public async Task<JsonResult> GetListsLeadApprovalHoliday(DTParameters param)
        {
            DTResult<HolidayAttendanceApprovalDataTableList> result = new DTResult<HolidayAttendanceApprovalDataTableList>();
            int totalRow = 0;

            try
            {
                var data = await _attendanceHolidayApprovalDataTableListRepository.AttendanceHolidayLeadApprovalDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
                        //Search = param.GenericSearch,
                        //BusinessEntityId = param.BusinessEntityId,
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
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleLead)]
        public async Task<JsonResult> GetListsLeadApprovalExtraHours(DTParameters param)
        {
            DTResult<ExtraHoursClaimApprovalDataTableList> result = new DTResult<ExtraHoursClaimApprovalDataTableList>();
            int totalRow = 0;

            try
            {
                var data = await _attendanceExtraHoursApprovalDataTableListRepository.AttendanceExtraHoursLeadApprovalDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
                        //Search = param.GenericSearch,
                        //BusinessEntityId = param.BusinessEntityId,
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

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleLead)]
        public async Task<JsonResult> GetListsLeadApprovalLeave(DTParameters param)
        {
            DTResult<LeaveApprovalDataTableList> result = new DTResult<LeaveApprovalDataTableList>();
            int totalRow = 0;

            try
            {
                var data = await _attendanceLeaveApprovalDataTableListRepository.AttendanceLeaveLeadApprovalDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
                        //Search = param.GenericSearch,
                        //BusinessEntityId = param.BusinessEntityId,
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

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleLead)]
        public async Task<JsonResult> GetListsLeadApprovalLeaveSL(DTParameters param)
        {
            DTResult<LeaveApprovalDataTableList> result = new DTResult<LeaveApprovalDataTableList>();
            int totalRow = 0;

            try
            {
                var data = await _attendanceLeaveApprovalDataTableListRepository.AttendanceSLLeaveLeadApprovalDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
                        //Search = param.GenericSearch,
                        //BusinessEntityId = param.BusinessEntityId,
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

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleLead)]
        public async Task<IActionResult> LeadApprovalExtraHours(ApprovalApprlVals[] approvalApprlVals)
        {
            try
            {
                var resultObjArray = ApprovalsToArray(approvalApprlVals);

                var result = await _attendanceExtraHoursApprovalRepository.LeadExtraHoursApprovalAsync(
                                    BaseSpTcmPLGet(),
                                    new ParameterSpTcmPL
                                    {
                                        PClaimApprovals = resultObjArray
                                    });

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleLead)]
        public async Task<IActionResult> LeadApprovalOnDutyByAjax(ApprovalRemarks[] apprlRemarks, ApprovalApprlVals[] approvalApprlVals)
        {
            try
            {
                var resultObjArray = ApprovalsNRemarksToArray(apprlRemarks, approvalApprlVals);

                var result = await _attendanceOnDutyApprovalRepository.LeadOnDutyApprovalAsync(
                                    BaseSpTcmPLGet(),
                                    new ParameterSpTcmPL
                                    {
                                        POndutyApprovals = resultObjArray
                                    });

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleLead)]
        public async Task<IActionResult> LeadApprovalLeave(ApprovalRemarks[] apprlRemarks, ApprovalApprlVals[] approvalApprlVals)
        {
            try
            {
                var resultObjArray = ApprovalsNRemarksToArray(apprlRemarks, approvalApprlVals);

                var result = await _attendanceLeaveApprovalRepository.LeadLeaveApprovalAsync(
                                    BaseSpTcmPLGet(),
                                    new ParameterSpTcmPL
                                    {
                                        PLeaveApprovals = resultObjArray
                                    });

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleLead)]
        public async Task<IActionResult> LeadApprovalLeaveSL(string applicationId, string remarks, string approvalType)
        {
            try
            {
                string[] objArray = { applicationId + "~!~" + approvalType + "~!~" + remarks };

                var result = await _attendanceLeaveApprovalRepository.LeadLeaveApprovalAsync(
                                    BaseSpTcmPLGet(),
                                    new ParameterSpTcmPL
                                    {
                                        PLeaveApprovals = objArray
                                    });

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleLead)]
        public async Task<IActionResult> LeadApprovalHoliday(ApprovalRemarks[] apprlRemarks, ApprovalApprlVals[] approvalApprlVals)
        {
            try
            {
                List<string> listresultObj = new List<string>();
                string[] resultObjArray;

                string[] remarksResult = apprlRemarks.Select(o => o.appId + "," + o.remarkVal).ToArray();
                string[] apprlValResult = approvalApprlVals.Select(o => o.appId + "," + o.apprlVal).ToArray();

                if (approvalApprlVals != null)
                {
                    for (int i = 0; i < approvalApprlVals.Length; i++)
                    {
                        string temp1 = approvalApprlVals[i].appId;
                        string temp2 = apprlRemarks[i].appId;
                        string temp3 = "";

                        if (temp1 == temp2)
                        {
                            temp3 = $"{approvalApprlVals[i].appId}~!~{approvalApprlVals[i].apprlVal}~!~{apprlRemarks[i].remarkVal}";

                            listresultObj.Add(temp3);
                        }
                    }
                }

                resultObjArray = listresultObj.ToArray();

                var result = await _attendanceHolidayApprovalRepository.LeadHolidayApprovalAsync(
                                    BaseSpTcmPLGet(),
                                    new ParameterSpTcmPL
                                    {
                                        PHolidayApprovals = resultObjArray
                                    });

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        #endregion Lead

        #region HoD

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleManagerHoD)]
        public IActionResult HoDApprovalLeaveIndex()
        {
            return View();
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleManagerHoD)]
        public IActionResult HoDApprovalExtraHoursIndex()
        {
            return View();
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleManagerHoD)]
        public IActionResult HoDApprovalOnDutyIndex()
        {
            return View();
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleManagerHoD)]
        public async Task<JsonResult> GetListsHoDApprovalOnDuty(DTParameters param)
        {
            DTResult<LeaveOnDutyApprovalDataTableList> result = new DTResult<LeaveOnDutyApprovalDataTableList>();
            int totalRow = 0;

            try
            {
                var data = await _attendanceOnDutyApprovalDataTableListRepository.AttendanceOnDutyHoDApprovalDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
                        //Search = param.GenericSearch,
                        //BusinessEntityId = param.BusinessEntityId,
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
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleManagerHoD)]
        public async Task<JsonResult> GetListsHoDApprovalLeave(DTParameters param)
        {
            DTResult<LeaveApprovalDataTableList> result = new DTResult<LeaveApprovalDataTableList>();
            int totalRow = 0;

            try
            {
                var data = await _attendanceLeaveApprovalDataTableListRepository.AttendanceLeaveHoDApprovalDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
                        //Search = param.GenericSearch,
                        //BusinessEntityId = param.BusinessEntityId,
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

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleManagerHoD)]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsHoDApprovalLeaveSL(DTParameters param)
        {
            DTResult<LeaveApprovalDataTableList> result = new DTResult<LeaveApprovalDataTableList>();
            int totalRow = 0;

            try
            {
                var data = await _attendanceLeaveApprovalDataTableListRepository.AttendanceSLLeaveHoDApprovalDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
                        //Search = param.GenericSearch,
                        //BusinessEntityId = param.BusinessEntityId,
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
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleManagerHoD)]
        public async Task<JsonResult> GetListsHoDApprovalExtraHours(DTParameters param)
        {
            DTResult<ExtraHoursClaimApprovalDataTableList> result = new DTResult<ExtraHoursClaimApprovalDataTableList>();
            int totalRow = 0;

            try
            {
                var data = await _attendanceExtraHoursApprovalDataTableListRepository.AttendanceExtraHoursHoDApprovalDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
                        //Search = param.GenericSearch,
                        //BusinessEntityId = param.BusinessEntityId,
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

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleManagerHoD)]
        public async Task<IActionResult> HoDApprovalLeave(ApprovalRemarks[] apprlRemarks, ApprovalApprlVals[] approvalApprlVals)
        {
            try
            {
                var resultObjArray = ApprovalsNRemarksToArray(apprlRemarks, approvalApprlVals);

                var result = await _attendanceLeaveApprovalRepository.HoDLeaveApprovalAsync(
                                    BaseSpTcmPLGet(),
                                    new ParameterSpTcmPL
                                    {
                                        PLeaveApprovals = resultObjArray
                                    });

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleManagerHoD)]
        public IActionResult HoDApprovalLeaveSLIndex()
        {
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleManagerHoD)]
        public async Task<IActionResult> HoDApprovalLeaveSL(string applicationId, string remarks, string approvalType)
        {
            try
            {
                string[] objArray = { applicationId + "~!~" + approvalType + "~!~" + remarks };

                var result = await _attendanceLeaveApprovalRepository.HoDLeaveApprovalAsync(
                                    BaseSpTcmPLGet(),
                                    new ParameterSpTcmPL
                                    {
                                        PLeaveApprovals = objArray
                                    });

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleManagerHoD)]
        public async Task<IActionResult> HoDApprovalExtraHours(ApprovalApprlVals[] approvalApprlVals)
        {
            try
            {
                var resultObjArray = ApprovalsToArray(approvalApprlVals);

                var result = await _attendanceExtraHoursApprovalRepository.HoDExtraHoursApprovalAsync(
                                    BaseSpTcmPLGet(),
                                    new ParameterSpTcmPL
                                    {
                                        PClaimApprovals = resultObjArray
                                    });

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleManagerHoD)]
        public async Task<IActionResult> HoDApprovalOnDutyByAjax(ApprovalRemarks[] apprlRemarks, ApprovalApprlVals[] approvalApprlVals)
        {
            try
            {
                List<string> listresultObj = new List<string>();
                string[] resultObjArray;

                string[] remarksResult = apprlRemarks.Select(o => o.appId + "," + o.remarkVal).ToArray();
                string[] apprlValResult = approvalApprlVals.Select(o => o.appId + "," + o.apprlVal).ToArray();

                if (approvalApprlVals != null)
                {
                    for (int i = 0; i < approvalApprlVals.Length; i++)
                    {
                        string temp1 = approvalApprlVals[i].appId;
                        string temp2 = apprlRemarks[i].appId;
                        string temp3 = "";

                        if (temp1 == temp2)
                        {
                            temp3 = $"{approvalApprlVals[i].appId}~!~{approvalApprlVals[i].apprlVal}~!~{apprlRemarks[i].remarkVal}";

                            listresultObj.Add(temp3);
                        }
                    }
                }

                resultObjArray = listresultObj.ToArray();

                var result = await _attendanceOnDutyApprovalRepository.HoDOnDutyApprovalAsync(
                                    BaseSpTcmPLGet(),
                                    new ParameterSpTcmPL
                                    {
                                        POndutyApprovals = resultObjArray
                                    });

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleManagerHoD)]
        public async Task<IActionResult> HoDApprovalHoliday(ApprovalRemarks[] apprlRemarks, ApprovalApprlVals[] approvalApprlVals)
        {
            try
            {
                List<string> listresultObj = new List<string>();
                string[] resultObjArray;

                string[] remarksResult = apprlRemarks.Select(o => o.appId + "," + o.remarkVal).ToArray();
                string[] apprlValResult = approvalApprlVals.Select(o => o.appId + "," + o.apprlVal).ToArray();

                if (approvalApprlVals != null)
                {
                    for (int i = 0; i < approvalApprlVals.Length; i++)
                    {
                        string temp1 = approvalApprlVals[i].appId;
                        string temp2 = apprlRemarks[i].appId;
                        string temp3 = "";

                        if (temp1 == temp2)
                        {
                            temp3 = $"{approvalApprlVals[i].appId}~!~{approvalApprlVals[i].apprlVal}~!~{apprlRemarks[i].remarkVal}";

                            listresultObj.Add(temp3);
                        }
                    }
                }

                resultObjArray = listresultObj.ToArray();

                var result = await _attendanceHolidayApprovalRepository.HoDHolidayApprovalAsync(
                                    BaseSpTcmPLGet(),
                                    new ParameterSpTcmPL
                                    {
                                        PHolidayApprovals = resultObjArray
                                    });

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        #endregion HoD

        #region OnBeHalf

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleManagerHoDOnBeHalf)]
        public IActionResult OnBeHalfApprovalLeaveIndex()
        {
            return View();
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleManagerHoDOnBeHalf)]
        public IActionResult OnBeHalfApprovalLeaveSLIndex()
        {
            return View();
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleManagerHoDOnBeHalf)]
        public IActionResult OnBeHalfApprovalExtraHoursIndex()
        {
            return View();
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleManagerHoDOnBeHalf)]
        public IActionResult OnBeHalfApprovalOnDutyIndex()
        {
            return View();
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleManagerHoDOnBeHalf)]
        public async Task<JsonResult> GetListsOnBeHalfApprovalOnDuty(DTParameters param)
        {
            DTResult<LeaveOnDutyApprovalDataTableList> result = new DTResult<LeaveOnDutyApprovalDataTableList>();
            int totalRow = 0;

            try
            {
                var data = await _attendanceOnDutyApprovalDataTableListRepository.AttendanceOnDutyOnBehalfApprovalDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
                        //Search = param.GenericSearch,
                        //BusinessEntityId = param.BusinessEntityId,
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
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleManagerHoDOnBeHalf)]
        public async Task<JsonResult> GetListsOnBeHalfApprovalLeave(DTParameters param)
        {
            DTResult<LeaveApprovalDataTableList> result = new DTResult<LeaveApprovalDataTableList>();
            int totalRow = 0;

            try
            {
                var data = await _attendanceLeaveApprovalDataTableListRepository.AttendanceLeaveOnBehalfApprovalDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
                        //Search = param.GenericSearch,
                        //BusinessEntityId = param.BusinessEntityId,
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
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleManagerHoDOnBeHalf)]
        public async Task<JsonResult> GetListsOnBeHalfApprovalLeaveSL(DTParameters param)
        {
            DTResult<LeaveApprovalDataTableList> result = new DTResult<LeaveApprovalDataTableList>();
            int totalRow = 0;

            try
            {
                var data = await _attendanceLeaveApprovalDataTableListRepository.AttendanceSLLeaveOnBehalfApprovalDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
                        //Search = param.GenericSearch,
                        //BusinessEntityId = param.BusinessEntityId,
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
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleManagerHoDOnBeHalf)]
        public async Task<JsonResult> GetListsOnBeHalfApprovalExtraHours(DTParameters param)
        {
            DTResult<ExtraHoursClaimApprovalDataTableList> result = new DTResult<ExtraHoursClaimApprovalDataTableList>();
            int totalRow = 0;

            try
            {
                var data = await _attendanceExtraHoursApprovalDataTableListRepository.AttendanceExtraHoursHoDOnBehalfApprovalDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
                        //Search = param.GenericSearch,
                        //BusinessEntityId = param.BusinessEntityId,
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

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleManagerHoDOnBeHalf)]
        public async Task<IActionResult> OnBeHalfApprovalLeave(ApprovalRemarks[] apprlRemarks, ApprovalApprlVals[] approvalApprlVals)
        {
            try
            {
                var resultObjArray = ApprovalsNRemarksToArray(apprlRemarks, approvalApprlVals);

                var result = await _attendanceLeaveApprovalRepository.HoDLeaveApprovalAsync(
                                    BaseSpTcmPLGet(),
                                    new ParameterSpTcmPL
                                    {
                                        PLeaveApprovals = resultObjArray
                                    });

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleManagerHoDOnBeHalf)]
        public async Task<IActionResult> OnBeHalfApprovalLeaveSL(string applicationId, string remarks, string approvalType)
        {
            try
            {
                string[] objArray = { applicationId + "~!~" + approvalType + "~!~" + remarks };

                var result = await _attendanceLeaveApprovalRepository.HoDLeaveApprovalAsync(
                                    BaseSpTcmPLGet(),
                                    new ParameterSpTcmPL
                                    {
                                        PLeaveApprovals = objArray
                                    });

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleManagerHoDOnBeHalf)]
        public async Task<IActionResult> OnBeHalfApprovalExtraHours(ApprovalApprlVals[] approvalApprlVals)
        {
            try
            {
                var resultObjArray = ApprovalsToArray(approvalApprlVals);

                var result = await _attendanceExtraHoursApprovalRepository.HoDExtraHoursApprovalAsync(
                                    BaseSpTcmPLGet(),
                                    new ParameterSpTcmPL
                                    {
                                        PClaimApprovals = resultObjArray
                                    });

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleManagerHoDOnBeHalf)]
        public async Task<IActionResult> OnBeHalfApprovalOnDutyByAjax(ApprovalRemarks[] apprlRemarks, ApprovalApprlVals[] approvalApprlVals)
        {
            try
            {
                List<string> listresultObj = new List<string>();
                string[] resultObjArray;

                string[] remarksResult = apprlRemarks.Select(o => o.appId + "," + o.remarkVal).ToArray();
                string[] apprlValResult = approvalApprlVals.Select(o => o.appId + "," + o.apprlVal).ToArray();

                if (approvalApprlVals != null)
                {
                    for (int i = 0; i < approvalApprlVals.Length; i++)
                    {
                        string temp1 = approvalApprlVals[i].appId;
                        string temp2 = apprlRemarks[i].appId;
                        string temp3 = "";

                        if (temp1 == temp2)
                        {
                            temp3 = $"{approvalApprlVals[i].appId}~!~{approvalApprlVals[i].apprlVal}~!~{apprlRemarks[i].remarkVal}";

                            listresultObj.Add(temp3);
                        }
                    }
                }

                resultObjArray = listresultObj.ToArray();

                var result = await _attendanceOnDutyApprovalRepository.HoDOnDutyApprovalAsync(
                                    BaseSpTcmPLGet(),
                                    new ParameterSpTcmPL
                                    {
                                        POndutyApprovals = resultObjArray
                                    });

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleManagerHoDOnBeHalf)]
        public async Task<IActionResult> OnBeHalfExtraHoursAdjustment(string ApplicationId)
        {
            var result = await _attendanceExtraHoursApprovalDataTableListRepository.AttendanceExtraHoursHoDOnBehalfApprovalDataTableList(
                baseSpTcmPL: BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PRowNumber = 0,
                    PPageLength = 10,
                    PApplicationId = ApplicationId
                });

            var appDetails = result.First();

            ExtraHoursClaimAdjustmentHoDViewModel extraHoursClaimAdjustment = new ExtraHoursClaimAdjustmentHoDViewModel
            {
                ClaimNo = appDetails.ClaimNo,
                Empno = appDetails.Empno,
                Employee = appDetails.Employee,
                ClaimedCo = appDetails.ClaimedCo,
                ClaimedHhot = appDetails.ClaimedHhot,
                ClaimedOt = appDetails.ClaimedOt,
                LeadApprovedCo = appDetails.LeadApprovedCo,
                LeadApprovedHhot = appDetails.LeadApprovedHhot,
                LeadApprovedOt = appDetails.LeadApprovedOt
            };

            return PartialView("_ModalExtraHoursAdjustmentOnBehalfPartial", extraHoursClaimAdjustment);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleManagerHoDOnBeHalf)]
        public async Task<IActionResult> OnBeHalfExtraHoursAdjustment(ExtraHoursClaimAdjustmentHoDViewModel extraHoursClaimAdjustment)
        {
            try
            {
                string validationMessage = validateExtraHoursAdjustment(maxOT: extraHoursClaimAdjustment.LeadApprovedOt,
                    maxHHOT: extraHoursClaimAdjustment.LeadApprovedHhot,
                    maxCO: extraHoursClaimAdjustment.LeadApprovedCo,
                    adjOT: extraHoursClaimAdjustment.HoDApprovedOt,
                    adjHHOT: extraHoursClaimAdjustment.HoDApprovedHhot,
                    adjCO: extraHoursClaimAdjustment.HoDApprovedCo
                    );
                if (validationMessage != "OK")
                    throw new Exception(validationMessage);

                var result = await _attendanceExtraHoursAdjustmentRepository.HoDExtraHoursAdjustmentAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL
                {
                    PClaimNo = extraHoursClaimAdjustment.ClaimNo,
                    PApprovedCo = (extraHoursClaimAdjustment.HoDApprovedCo ?? 0) * 60,
                    PApprovedOt = (extraHoursClaimAdjustment.HoDApprovedOt ?? 0) * 60,
                    PApprovedHhot = (extraHoursClaimAdjustment.HoDApprovedHhot ?? 0) * 60
                });

                if (result.PMessageType == "OK")
                    return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
                else
                    Notify("Error", result.PMessageText, "", NotificationType.error);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
            return PartialView("_ModalExtraHoursAdjustmentOnBehalfPartial", extraHoursClaimAdjustment);
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleManagerHoDOnBeHalf)]
        public IActionResult OnBeHalfApprovalHolidayAttendanceIndex()
        {
            var holidayApprovalViewModel = new HolidayApprovalViewModel();
            return View(holidayApprovalViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleManagerHoDOnBeHalf)]
        public async Task<JsonResult> GetListsOnBeHalfApprovalHoliday(DTParameters param)
        {
            DTResult<HolidayAttendanceApprovalDataTableList> result = new DTResult<HolidayAttendanceApprovalDataTableList>();
            int totalRow = 0;

            try
            {
                var data = await _attendanceHolidayApprovalDataTableListRepository.AttendanceHolidayOnBehalfApprovalDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
                        //Search = param.GenericSearch,
                        //BusinessEntityId = param.BusinessEntityId,
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

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleManagerHoDOnBeHalf)]
        public async Task<IActionResult> OnBeHalfApprovalHoliday(ApprovalRemarks[] apprlRemarks, ApprovalApprlVals[] approvalApprlVals)
        {
            try
            {
                List<string> listresultObj = new List<string>();
                string[] resultObjArray;

                string[] remarksResult = apprlRemarks.Select(o => o.appId + "," + o.remarkVal).ToArray();
                string[] apprlValResult = approvalApprlVals.Select(o => o.appId + "," + o.apprlVal).ToArray();

                if (approvalApprlVals != null)
                {
                    for (int i = 0; i < approvalApprlVals.Length; i++)
                    {
                        string temp1 = approvalApprlVals[i].appId;
                        string temp2 = apprlRemarks[i].appId;
                        string temp3 = "";

                        if (temp1 == temp2)
                        {
                            temp3 = $"{approvalApprlVals[i].appId}~!~{approvalApprlVals[i].apprlVal}~!~{apprlRemarks[i].remarkVal}";

                            listresultObj.Add(temp3);
                        }
                    }
                }

                resultObjArray = listresultObj.ToArray();

                var result = await _attendanceHolidayApprovalRepository.HoDHolidayApprovalAsync(
                                    BaseSpTcmPLGet(),
                                    new ParameterSpTcmPL
                                    {
                                        PHolidayApprovals = resultObjArray
                                    });

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        #endregion OnBeHalf

        #region HR

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleAttendanceAdmin)]
        public async Task<IActionResult> HRApprovalLeaveIndex()
        {
            LeaveApprovalViewModel leaveApprovalViewModel = new LeaveApprovalViewModel();
            var costcodes = await _selectTcmPLRepository.CostCodeListAsync(BaseSpTcmPLGet(), null);
            ViewData["CostCodes"] = new SelectList(costcodes, "DataValueField", "DataTextField");

            var retVal = await RetriveFilter(ConstFilterHRApprovalLeave);

            FilterDataModel filterDataModel = new FilterDataModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            leaveApprovalViewModel.FilterDataModel = filterDataModel;

            return View(leaveApprovalViewModel);
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleAttendanceAdmin)]
        public IActionResult HRApprovalLeaveSLIndex()
        {
            return View();
        }

        public async Task<IActionResult> HRApprovalLeaveFilterGet()
        {
            var costcodes = await _selectTcmPLRepository.CostCodeListAsync(BaseSpTcmPLGet(), null);
            ViewData["CostCodes"] = new SelectList(costcodes, "DataValueField", "DataTextField");

            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterHRApprovalLeave
            });

            FilterDataModel filterDataModel = new FilterDataModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            return PartialView("_ModalHRLeaveApprovalFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> HRApprovalLeaveFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                {
                    string jsonFilter;
                    jsonFilter = JsonConvert.SerializeObject(
                            new
                            {
                                Parent = filterDataModel.Parent
                            });

                    var retVal = await _filterRepository.FilterCreateAsync(new Domain.Models.FilterCreate
                    {
                        PModuleName = CurrentUserIdentity.CurrentModule,
                        PMetaId = CurrentUserIdentity.MetaId,
                        PPersonId = CurrentUserIdentity.EmployeeId,
                        PMvcActionName = ConstFilterHRApprovalLeave,
                        PFilterJson = jsonFilter
                    });

                    return Json(new
                    {
                        success = true,
                        parent = filterDataModel.Parent,
                    });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
            //return PartialView("_ModalOnDutyFilterSet", filterDataModel);
        }

        public async Task<IActionResult> HRApprovalOndutyFilterGet()
        {
            var costcodes = await _selectTcmPLRepository.CostCodeListAsync(BaseSpTcmPLGet(), null);
            ViewData["CostCodes"] = new SelectList(costcodes, "DataValueField", "DataTextField");

            var retVal = await RetriveFilter(ConstFilterHRApprovalOnDuty);

            FilterDataModel filterDataModel = new FilterDataModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            return PartialView("_ModalHROndutyApprovalFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> HRApprovalOndutyFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                {
                    string jsonFilter;
                    jsonFilter = JsonConvert.SerializeObject(
                            new
                            {
                                Parent = filterDataModel.Parent
                            });

                    _ = await CreateFilter(jsonFilter, ConstFilterHRApprovalOnDuty);

                    return Json(new
                    {
                        success = true,
                        parent = filterDataModel.Parent,
                    });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
            //return PartialView("_ModalOnDutyFilterSet", filterDataModel);
        }

        public async Task<IActionResult> HRApprovalForgettingCardFilterGet()
        {
            var costcodes = await _selectTcmPLRepository.CostCodeListAsync(BaseSpTcmPLGet(), null);
            ViewData["CostCodes"] = new SelectList(costcodes, "DataValueField", "DataTextField");

            var retVal = await RetriveFilter(ConstFilterHRApprovalForgettingCard);

            FilterDataModel filterDataModel = new FilterDataModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            return PartialView("_ModalHRForgettingCardApprovalFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> HRApprovalForgettingCardFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                {
                    string jsonFilter;
                    jsonFilter = JsonConvert.SerializeObject(
                            new
                            {
                                Parent = filterDataModel.Parent
                            });

                    _ = await CreateFilter(jsonFilter, ConstFilterHRApprovalForgettingCard);

                    return Json(new
                    {
                        success = true,
                        parent = filterDataModel.Parent,
                    });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
            //return PartialView("_ModalOnDutyFilterSet", filterDataModel);
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleAttendanceAdmin)]
        public IActionResult HRApprovalExtraHoursIndex()
        {
            return View();
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleAttendanceAdmin)]
        public async Task<IActionResult> HRApprovalOnDutyIndex()
        {
            var retVal = await RetriveFilter(ConstFilterHRApprovalOnDuty);
            FilterDataModel filterDataModel = new FilterDataModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            LeaveOnDutyApprovalViewModel leaveOnDutyApprovalViewModel = new LeaveOnDutyApprovalViewModel();
            leaveOnDutyApprovalViewModel.FilterDataModel = filterDataModel;
            return View(leaveOnDutyApprovalViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleAttendanceAdmin)]
        public async Task<JsonResult> GetListsHRApprovalLeave(DTParameters param)
        {
            DTResult<LeaveApprovalDataTableList> result = new DTResult<LeaveApprovalDataTableList>();
            int totalRow = 0;

            try
            {
                var data = await _attendanceLeaveApprovalDataTableListRepository.AttendanceLeaveHRApprovalDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
                        PParent = param.Parent
                        //Search = param.GenericSearch,
                        //BusinessEntityId = param.BusinessEntityId,
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
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleAttendanceAdmin)]
        public async Task<JsonResult> GetListsHRApprovalLeaveSL(DTParameters param)
        {
            DTResult<LeaveApprovalDataTableList> result = new DTResult<LeaveApprovalDataTableList>();
            int totalRow = 0;

            try
            {
                var data = await _attendanceLeaveApprovalDataTableListRepository.AttendanceSLLeaveHRApprovalDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
                        PParent = param.Parent
                        //Search = param.GenericSearch,
                        //BusinessEntityId = param.BusinessEntityId,
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
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleAttendanceAdmin)]
        public async Task<JsonResult> GetListsHRApprovalOnDuty(DTParameters param)
        {
            DTResult<LeaveOnDutyApprovalDataTableList> result = new DTResult<LeaveOnDutyApprovalDataTableList>();
            int totalRow = 0;

            try
            {
                var data = await _attendanceOnDutyApprovalDataTableListRepository.AttendanceOnDutyHRApprovalDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
                        //Search = param.GenericSearch,
                        //BusinessEntityId = param.BusinessEntityId,
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
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleAttendanceAdmin)]
        public async Task<JsonResult> GetListsHRApprovalExtraHours(DTParameters param)
        {
            DTResult<ExtraHoursClaimApprovalDataTableList> result = new DTResult<ExtraHoursClaimApprovalDataTableList>();
            int totalRow = 0;

            try
            {
                var data = await _attendanceExtraHoursApprovalDataTableListRepository.AttendanceExtraHoursHRApprovalDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
                        //Search = param.GenericSearch,
                        //BusinessEntityId = param.BusinessEntityId,
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

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleAttendanceAdmin)]
        public async Task<IActionResult> HRApprovalLeave(ApprovalRemarks[] apprlRemarks, ApprovalApprlVals[] approvalApprlVals)
        {
            try
            {
                var resultObjArray = ApprovalsNRemarksToArray(apprlRemarks, approvalApprlVals);

                var result = await _attendanceLeaveApprovalRepository.HRLeaveApprovalAsync(
                                    BaseSpTcmPLGet(),
                                    new ParameterSpTcmPL
                                    {
                                        PLeaveApprovals = resultObjArray
                                    });

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleAttendanceAdmin)]
        public async Task<IActionResult> HRApprovalLeaveSL(string applicationId, string remarks, string approvalType)
        {
            try
            {
                string[] objArray = { applicationId + "~!~" + approvalType + "~!~" + remarks };

                var result = await _attendanceLeaveApprovalRepository.HRLeaveApprovalAsync(
                                    BaseSpTcmPLGet(),
                                    new ParameterSpTcmPL
                                    {
                                        PLeaveApprovals = objArray
                                    });

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleAttendanceAdmin)]
        public async Task<IActionResult> HRApprovalExtraHours(ApprovalApprlVals[] approvalApprlVals)
        {
            try
            {
                var resultObjArray = ApprovalsToArray(approvalApprlVals);

                var result = await _attendanceExtraHoursApprovalRepository.HRExtraHoursApprovalAsync(
                                    BaseSpTcmPLGet(),
                                    new ParameterSpTcmPL
                                    {
                                        PClaimApprovals = resultObjArray
                                    });

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleAttendanceAdmin)]
        public async Task<IActionResult> HRApprovalOnDutyByAjax(ApprovalRemarks[] apprlRemarks, ApprovalApprlVals[] approvalApprlVals)
        {
            try
            {
                List<string> listresultObj = new List<string>();
                string[] resultObjArray;

                string[] remarksResult = apprlRemarks.Select(o => o.appId + "," + o.remarkVal).ToArray();
                string[] apprlValResult = approvalApprlVals.Select(o => o.appId + "," + o.apprlVal).ToArray();

                if (approvalApprlVals != null)
                {
                    for (int i = 0; i < approvalApprlVals.Length; i++)
                    {
                        string temp1 = approvalApprlVals[i].appId;
                        string temp2 = apprlRemarks[i].appId;
                        string temp3 = "";

                        if (temp1 == temp2)
                        {
                            temp3 = $"{approvalApprlVals[i].appId}~!~{approvalApprlVals[i].apprlVal}~!~{apprlRemarks[i].remarkVal}";

                            listresultObj.Add(temp3);
                        }
                    }
                }

                resultObjArray = listresultObj.ToArray();

                var result = await _attendanceOnDutyApprovalRepository.HROnDutyApprovalAsync(
                                    BaseSpTcmPLGet(),
                                    new ParameterSpTcmPL
                                    {
                                        POndutyApprovals = resultObjArray
                                    });

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleAttendanceAdmin)]
        public async Task<IActionResult> HRApprovalHoliday(ApprovalRemarks[] apprlRemarks, ApprovalApprlVals[] approvalApprlVals)
        {
            try
            {
                List<string> listresultObj = new List<string>();
                string[] resultObjArray;

                string[] remarksResult = apprlRemarks.Select(o => o.appId + "," + o.remarkVal).ToArray();
                string[] apprlValResult = approvalApprlVals.Select(o => o.appId + "," + o.apprlVal).ToArray();

                if (approvalApprlVals != null)
                {
                    for (int i = 0; i < approvalApprlVals.Length; i++)
                    {
                        string temp1 = approvalApprlVals[i].appId;
                        string temp2 = apprlRemarks[i].appId;
                        string temp3 = "";

                        if (temp1 == temp2)
                        {
                            temp3 = $"{approvalApprlVals[i].appId}~!~{approvalApprlVals[i].apprlVal}~!~{apprlRemarks[i].remarkVal}";

                            listresultObj.Add(temp3);
                        }
                    }
                }

                resultObjArray = listresultObj.ToArray();

                var result = await _attendanceHolidayApprovalRepository.HRHolidayApprovalAsync(
                                    BaseSpTcmPLGet(),
                                    new ParameterSpTcmPL
                                    {
                                        PHolidayApprovals = resultObjArray
                                    });

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleAttendanceAdmin)]
        public async Task<IActionResult> HRApprovalForgettingCardIndex()
        {
            var retVal = await RetriveFilter(ConstFilterHRApprovalForgettingCard);

            FilterDataModel filterDataModel = new FilterDataModel();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            LeaveOnDutyApprovalViewModel leaveOnDutyApprovalViewModel = new LeaveOnDutyApprovalViewModel();

            leaveOnDutyApprovalViewModel.FilterDataModel = filterDataModel;

            return View(leaveOnDutyApprovalViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleAttendanceAdmin)]
        public async Task<JsonResult> GetListsHRApprovalForgettingCard(DTParameters param)
        {
            DTResult<LeaveOnDutyApprovalDataTableList> result = new DTResult<LeaveOnDutyApprovalDataTableList>();
            int totalRow = 0;

            try
            {
                var data = await _attendanceOnDutyApprovalDataTableListRepository.AttendanceForgettingCardHRApprovalDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
                        //Search = param.GenericSearch,
                        //BusinessEntityId = param.BusinessEntityId,
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

        #endregion HR

        #endregion Approval

        #region PunchDetails

        public async Task<IActionResult> PunchDetailsIndex()
        {
            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterPunchDetailsIndex
            });

            PunchDetailsViewModel punchDetailsViewModel = new PunchDetailsViewModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                punchDetailsViewModel.FilterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            return View(punchDetailsViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> GetPunchDetails(DTParameters param)
        {
            param.StartDate = param.StartDate ?? DateTime.Now;
            var empdetails = await _attendanceEmployeeDetailsRepository.AttendanceEmployeeDetailsAsync(BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PEmpno = param.Empno
                }
            );

            ViewData["EmployeeDetails"] = empdetails;
            ViewData["Period"] = param.StartDate?.ToString("MMM-yyyy");

            IEnumerable<PunchDetailsDataTableList> punchDetailsDataTableLists;

            punchDetailsDataTableLists = await _attendancePunchDetailsDataTableListRepository.AttendancePunchDetailsDataTableList(
               BaseSpTcmPLGet(),
               new ParameterSpTcmPL
               {
                   PYyyymm = (param.StartDate?.ToString("yyyy-MM")).Replace("-", ""),
                   PEmpno = string.IsNullOrEmpty(param.Empno) ? " " : param.Empno,
                   PForOt = "KO"
               }
           );

            return PartialView("_PunchDetailsPartial", punchDetailsDataTableLists);
        }

        public async Task<IActionResult> GetListPunchListForDay(string Empno, DateTime PunchDate)
        {
            var data = await _attendancePunchDetailsDayPunchListRepository.DayPunchList(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PDate = PunchDate,
                    PEmpno = Empno
                }
            );
            ViewData["PunchListDate"] = PunchDate;
            return PartialView("_ModalPunchDetailsDayPunchListPartial", data);
        }

        public async Task<IActionResult> PunchDetailsFilterGet()
        {
            var empdetails = await _attendanceEmployeeDetailsRepository.AttendanceEmployeeDetailsAsync(BaseSpTcmPLGet(),
               new ParameterSpTcmPL
               {
               }
           );

            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterPunchDetailsIndex
            });
            FilterDataModel filterDataModel;
            if (string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = new FilterDataModel();
                filterDataModel.StartDate = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1);
            }
            else
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            ViewData["EmployeeList"] = await getEmployeeSelectList(filterDataModel.Empno);

            //ViewData["EmployeeList"] = new SelectList(empList, "DataValueField", "DataTextField", string.IsNullOrEmpty(filterDataModel.Empno) ? empdetails.Empno : filterDataModel.Empno);

            //This for Lead / Hod / Hr
            //if (CurrentUserIdentity.ProfileActions.Any(pa => pa.RoleId == SelfServiceHelper.RoleManagerHoDOnBeHalf))
            //{
            //    var empList = await _selectTcmPLRepository.EmployeeListForMngrHodOnBeHalfAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            //    ViewData["EmployeeList"] = new SelectList(empList, "DataValueField", "DataTextField", string.IsNullOrEmpty(filterDataModel.Empno) ? empdetails.Empno : filterDataModel.Empno);
            //}
            //else if (CurrentUserIdentity.ProfileActions.Any(pa => pa.RoleId == SelfServiceHelper.RoleManagerHoD))
            //{
            //    var empList = await _selectTcmPLRepository.EmployeeListForMngrHodAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            //    ViewData["EmployeeList"] = new SelectList(empList, "DataValueField", "DataTextField", string.IsNullOrEmpty(filterDataModel.Empno) ? empdetails.Empno : filterDataModel.Empno);
            //}
            //else if (CurrentUserIdentity.ProfileActions.Any(pa => pa.RoleId == SelfServiceHelper.RoleAttendanceAdmin))
            //{
            //    var empList = await _selectTcmPLRepository.EmployeeListForHRAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            //    ViewData["EmployeeList"] = new SelectList(empList, "DataValueField", "DataTextField", string.IsNullOrEmpty(filterDataModel.Empno) ? empdetails.Empno : filterDataModel.Empno);
            //}
            return PartialView("_ModalPunchDetailsFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> PunchDetailsFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            string jsonFilter;
            if (string.IsNullOrEmpty(filterDataModel.Empno))
                jsonFilter = JsonConvert.SerializeObject(new { StartDate = filterDataModel.StartDate });
            else
                jsonFilter = JsonConvert.SerializeObject(new { StartDate = filterDataModel.StartDate, Empno = filterDataModel.Empno });

            var retVal = await _filterRepository.FilterCreateAsync(new Domain.Models.FilterCreate
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterPunchDetailsIndex,
                PFilterJson = jsonFilter
            });

            return Json(new { success = true, startDate = filterDataModel.StartDate?.ToString("dd-MMM-yyyy"), empno = filterDataModel.Empno });
        }

        public IActionResult PunchUploadData()
        {
            return PartialView("_ModalPunchUploadDataPartial");
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> PunchUploadData(IFormFile file)
        {
            try
            {
                if (file == null || file.Length == 0)
                    return StatusCode((int)HttpStatusCode.InternalServerError, "File not uploaded due to an error");

                FileInfo fileInfo = new FileInfo(file.FileName);

                Guid storageId = Guid.NewGuid();

                //byte[] fileBytes = System.IO.File.ReadAllBytes()

                //var stream = file.OpenReadStream();
                //var byteArray = stream.ReadFully();
                var fileName = file.FileName;
                var fileSize = file.Length;
                var mimeType = MimeTypeMap.GetMimeType(fileInfo.Extension);

                byte[] byteArray;
                using (var ms = new MemoryStream())
                {
                    file.CopyTo(ms);
                    byteArray = ms.ToArray();
                }

                // Check file validation
                if (!fileInfo.Extension.Contains("tas"))
                    return StatusCode((int)HttpStatusCode.InternalServerError, new { success = false, response = "Tas file not recognized" });

                // Try to convert stream to a class

                var result = await _attendancePunchUploadRepository.UploadPunchDataAsync(BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PBlob = byteArray,
                        PClintFileName = fileName
                    }
                    );
                return Ok(new { success = result.PMessageType == "OK", response = result.PMessageText });
                // Call database json stored procedure
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, new { success = false, response = ex.Message });
            }
        }

        #endregion PunchDetails

        #region FlexiPunchDetails

        public async Task<IActionResult> FlexiPunchDetailsIndex()
        {
            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterFlexiPunchDetailsIndex
            });

            PunchDetailsViewModel punchDetailsViewModel = new PunchDetailsViewModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                punchDetailsViewModel.FilterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            return View(punchDetailsViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> GetFlexiPunchDetails(DTParameters param)
        {
            param.StartDate = param.StartDate ?? DateTime.Now;
            var empdetails = await _attendanceEmployeeDetailsRepository.AttendanceEmployeeDetailsAsync(BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PEmpno = param.Empno
                }
            );

            ViewData["EmployeeDetails"] = empdetails;
            ViewData["Period"] = param.StartDate?.ToString("MMM-yyyy");

            IEnumerable<FlexiPunchDetailsDataTableList> punchDetailsDataTableLists;

            punchDetailsDataTableLists = await _attendanceFlexiPunchDetailsDataTableListRepository.AttendanceFlexiPunchDetailsDataTableList(
               BaseSpTcmPLGet(),
               new ParameterSpTcmPL
               {
                   PYyyymm = (param.StartDate?.ToString("yyyy-MM")).Replace("-", ""),
                   PEmpno = string.IsNullOrEmpty(param.Empno) ? " " : param.Empno,
                   PForOt = "KO"
               }
           );

            return PartialView("_FlexiPunchDetailsPartial", punchDetailsDataTableLists);
        }

        public async Task<IActionResult> FlexiPunchDetailsFilterGet()
        {
            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterFlexiPunchDetailsIndex
            });
            FilterDataModel filterDataModel;
            if (string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = new FilterDataModel();
                filterDataModel.StartDate = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1);
            }
            else
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            //ViewData["EmployeeList"] = await getEmployeeSelectList(filterDataModel.Empno);

            return PartialView("_ModalFlexiPunchDetailsFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> FlexiPunchDetailsFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            string jsonFilter;
            if (string.IsNullOrEmpty(filterDataModel.Empno))
                jsonFilter = JsonConvert.SerializeObject(new { StartDate = filterDataModel.StartDate });
            else
                jsonFilter = JsonConvert.SerializeObject(new { StartDate = filterDataModel.StartDate, Empno = filterDataModel.Empno });

            var retVal = await _filterRepository.FilterCreateAsync(new Domain.Models.FilterCreate
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterFlexiPunchDetailsIndex,
                PFilterJson = jsonFilter
            });

            return Json(new { success = true, startDate = filterDataModel.StartDate?.ToString("dd-MMM-yyyy"), empno = filterDataModel.Empno });
        }

        #endregion FlexiPunchDetails

        #region HRPunchDetails

        public async Task<IActionResult> PunchDetailsForHRIndex()
        {
            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterPunchDetailsForHRIndex
            });

            PunchDetailsViewModel punchDetailsViewModel = new PunchDetailsViewModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                punchDetailsViewModel.FilterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            return View(punchDetailsViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> GetPunchDetailsForHR(DTParameters param)
        {
            param.StartDate = param.StartDate ?? DateTime.Now;
            param.Empno = (param.Empno ?? "00000").PadLeft(5, '0');
            var empdetails = await _attendanceEmployeeDetailsRepository.AttendanceEmployeeDetailsAsync(BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PEmpno = param.Empno
                }
            );

            ViewData["EmployeeDetails"] = empdetails;
            ViewData["Period"] = param.StartDate?.ToString("MMM-yyyy");

            IEnumerable<PunchDetailsDataTableList> punchDetailsDataTableLists;

            punchDetailsDataTableLists = await _attendancePunchDetailsDataTableListRepository.AttendancePunchDetailsDataTableList(
               BaseSpTcmPLGet(),
               new ParameterSpTcmPL
               {
                   PYyyymm = (param.StartDate?.ToString("yyyy-MM")).Replace("-", ""),
                   PEmpno = string.IsNullOrEmpty(param.Empno) ? " " : param.Empno,
                   PForOt = "KO"
               }
           );

            return PartialView("_PunchDetailsForHRPartial", punchDetailsDataTableLists);
        }

        public async Task<IActionResult> PunchDetailsForHRFilterGet()
        {
            // var empdetails = await _attendanceEmployeeDetailsRepository.AttendanceEmployeeDetailsAsync(BaseSpTcmPLGet(),
            //    new ParameterSpTcmPL
            //    {
            //    }
            //);

            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterPunchDetailsForHRIndex
            });
            FilterDataModel filterDataModel;
            if (string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = new FilterDataModel();
                filterDataModel.StartDate = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1);
            }
            else
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            //ViewData["EmployeeList"] = await getEmployeeSelectList(filterDataModel.Empno);

            return PartialView("_ModalPunchDetailsForHRFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> PunchDetailsForHRFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            string jsonFilter;
            if (string.IsNullOrEmpty(filterDataModel.Empno))
                jsonFilter = JsonConvert.SerializeObject(new { StartDate = filterDataModel.StartDate });
            else
                jsonFilter = JsonConvert.SerializeObject(new { StartDate = filterDataModel.StartDate, Empno = filterDataModel.Empno });

            var retVal = await _filterRepository.FilterCreateAsync(new Domain.Models.FilterCreate
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterPunchDetailsForHRIndex,
                PFilterJson = jsonFilter
            });

            return Json(new { success = true, startDate = filterDataModel.StartDate?.ToString("dd-MMM-yyyy"), empno = filterDataModel.Empno });
        }

        #endregion HRPunchDetails

        #region Employee Card RFID

        public IActionResult RfidUploadData()
        {
            return PartialView("_ModalRfidUploadDataPartial");
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> RfidUploadData(IFormFile file)
        {
            try
            {
                if (file == null || file.Length == 0)
                    return StatusCode((int)HttpStatusCode.InternalServerError, "File not uploaded due to an error");

                FileInfo fileInfo = new FileInfo(file.FileName);

                Guid storageId = Guid.NewGuid();

                byte[] byteArray;
                using (var ms = new MemoryStream())
                {
                    file.CopyTo(ms);
                    byteArray = ms.ToArray();
                }
                var fileSize = file.Length;
                var mimeType = MimeTypeMap.GetMimeType(fileInfo.Extension);

                // Check file validation
                if (!fileInfo.Extension.Contains("txt"))
                    return StatusCode((int)HttpStatusCode.InternalServerError, new { success = false, response = "Text file not recognized" });

                // Try to convert stream to a class

                var result = await _attendanceEmpCardRFIDUploadRepository.UploadEmpCardRFIDDataAsync(BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PBlob = byteArray
                    }
                    );
                return Ok(new { success = result.PMessageType == "OK", response = result.PMessageText });
                // Call database json stored procedure
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, new { success = false, response = ex.Message });
            }
        }

        #endregion Employee Card RFID

        #region ExtraHours

        public async Task<IActionResult> ExtraHoursClaimsIndex()
        {
            var selfDetail = await _attendanceEmployeeDetailsRepository.AttendanceEmployeeDetailsAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            if (selfDetail.Emptype == "S" || selfDetail.EmpGrade.StartsWith("X"))
            {
                return Forbid();
            }

            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterExtraHoursClaimsIndex
            });

            ExtraHoursClaimsViewModel extraHoursClaimsViewModel = new ExtraHoursClaimsViewModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                extraHoursClaimsViewModel.FilterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            return View(extraHoursClaimsViewModel);
        }

        public async Task<JsonResult> GetListsExtraHoursClaims(DTParameters param)
        {
            var selfDetail = await _attendanceEmployeeDetailsRepository.AttendanceEmployeeDetailsAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            if (selfDetail.Emptype == "S" || selfDetail.EmpGrade.StartsWith("X"))
            {
                throw new Exception("Forbidden");
            }
            DTResult<ExtraHoursClaimsDataTableList> result = new DTResult<ExtraHoursClaimsDataTableList>();
            int totalRow = 0;

            try
            {
                var data = await _attendanceExtraHoursDataTableListRepository.AttendanceExtraHoursClaimsDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
                        PEmpno = param.Empno,
                        PStartDate = param.StartDate
                        //Search = param.GenericSearch,
                        //BusinessEntityId = param.BusinessEntityId,
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

        public async Task<JsonResult> GetListsExtraHoursClaimsHeader(DTParameters param)
        {
            var empdetails = await _attendanceEmployeeDetailsRepository.AttendanceEmployeeDetailsAsync(BaseSpTcmPLGet(),
                               new ParameterSpTcmPL
                               {
                                   PEmpno = param.Empno
                               }
                               );
            return Json(new { empno = empdetails.Empno, employeeName = empdetails.Name, period = param.StartDate?.ToString("MMM-yyyy") });
        }

        public async Task<IActionResult> ExtraHoursClaimsFilterGet()
        {
            var empdetails = await _attendanceEmployeeDetailsRepository.AttendanceEmployeeDetailsAsync(BaseSpTcmPLGet(),
                null
               );

            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterExtraHoursClaimsIndex
            });
            FilterDataModel filterDataModel = new FilterDataModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            if (string.IsNullOrEmpty(filterDataModel.Empno))
                filterDataModel.Empno = empdetails.Empno;

            ViewData["EmpList"] = await getEmployeeSelectList(filterDataModel.Empno);

            //This for Lead / Hod / Hr
            //if (CurrentUserIdentity.ProfileActions.Any(pa => pa.RoleId == SelfServiceHelper.RoleManagerHoDOnBeHalf))
            //{
            //    var empList = await _selectTcmPLRepository.EmployeeListForMngrHodOnBeHalfAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            //    ViewData["EmpList"] = new SelectList(empList, "DataValueField", "DataTextField", string.IsNullOrEmpty(filterDataModel.Empno) ? empdetails.Empno : filterDataModel.Empno);
            //}
            //else if (CurrentUserIdentity.ProfileActions.Any(pa => pa.RoleId == SelfServiceHelper.RoleManagerHoD))
            //{
            //    var empList = await _selectTcmPLRepository.EmployeeListForMngrHodAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            //    ViewData["EmpList"] = new SelectList(empList, "DataValueField", "DataTextField", string.IsNullOrEmpty(filterDataModel.Empno) ? empdetails.Empno : filterDataModel.Empno);
            //}
            //else if (CurrentUserIdentity.ProfileActions.Any(pa => pa.RoleId == SelfServiceHelper.RoleAttendanceAdmin))
            //{
            //    var empList = await _selectTcmPLRepository.EmployeeListForHRAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            //    ViewData["EmpList"] = new SelectList(empList, "DataValueField", "DataTextField", string.IsNullOrEmpty(filterDataModel.Empno) ? empdetails.Empno : filterDataModel.Empno);
            //}
            return PartialView("_ModalExtraHoursClaimsFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> ExtraHoursClaimsFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            string jsonFilter;
            if (string.IsNullOrEmpty(filterDataModel.Empno))
                jsonFilter = JsonConvert.SerializeObject(new { StartDate = filterDataModel.StartDate });
            else
                jsonFilter = JsonConvert.SerializeObject(new { StartDate = filterDataModel.StartDate, Empno = filterDataModel.Empno });

            var retVal = await _filterRepository.FilterCreateAsync(new Domain.Models.FilterCreate
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterExtraHoursClaimsIndex,
                PFilterJson = jsonFilter
            });

            return Json(new { success = true, startDate = filterDataModel.StartDate?.ToString("dd-MMM-yyyy"), empno = filterDataModel.Empno });
        }

        public async Task<IActionResult> ExtraHoursClaimCreate(DTParameters param)
        {
            var selfDetail = await _attendanceEmployeeDetailsRepository.AttendanceEmployeeDetailsAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            if (selfDetail.Emptype == "S" || selfDetail.EmpGrade.StartsWith("X"))
            {
                return Forbid();
            }
            var empdetails = await _attendanceEmployeeDetailsRepository.AttendanceEmployeeDetailsAsync(
                                BaseSpTcmPLGet(),
                                new ParameterSpTcmPL
                                {
                                    PEmpno = param.Empno
                                });

            DateTime startDate = param.StartDate ?? DateTime.Now;

            ViewData["EmployeeDetails"] = empdetails;
            ViewData["Period"] = startDate.ToString("MMM-yyyy");

            var Approvers = await _selectTcmPLRepository.ApproversListAsync(BaseSpTcmPLGet(), null);
            ViewData["Approvers"] = new SelectList(Approvers, "DataValueField", "DataTextField");

            var result = await _attendanceExtrahoursClaimExistsRepository.CheckClaimExistsAsync(BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PYyyymm = startDate.ToString("yyyy-MM").Replace("-", ""),
                    });
            IEnumerable<PunchDetailsDataTableList> punchDetailsDataTableLists = null;

            if (result.PMessageType != "OK")
            {
                Notify("Error", result.PMessageText, "", NotificationType.error);
            }
            else if (result.PClaimExists == "OK")
            {
                Notify("Error", "Extra hours claim for the period already exists.", "", NotificationType.error);
            }
            else
            {
                punchDetailsDataTableLists = await _attendancePunchDetailsDataTableListRepository.AttendancePunchDetailsDataTableList(
                   BaseSpTcmPLGet(),
                   new ParameterSpTcmPL
                   {
                       PYyyymm = startDate.ToString("yyyy-MM").Replace("-", ""),
                       PEmpno = string.IsNullOrEmpty(param.Empno) ? " " : param.Empno,
                       PForOt = "OK"
                   }
               );
            }
            return PartialView("_ExtraHoursClaimCreatePartial", punchDetailsDataTableLists);
        }

        [HttpPost]
        public async Task<IActionResult> ExtraHoursClaimCreate(string LeadApprover, string Period, ExtraHoursClaimSelectedCompOffDays[] CompOffDaySelection, ExtraHoursClaimWeekEndTotals[] WeekEndTotals, string earlysubmit)
        {
            var selfDetail = await _attendanceEmployeeDetailsRepository.AttendanceEmployeeDetailsAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            if (selfDetail.Emptype == "S" || selfDetail.EmpGrade.StartsWith("X"))
            {
                return Forbid();
            }
            if (string.IsNullOrEmpty(LeadApprover))
            {
                return Json(new { success = false, response = "Lead approver not selected. Cannot create claim." });
            }
            try
            {
                DateTime claimPeriod = DateTime.ParseExact("01-" + Period, "dd-MMM-yyyy", null);

                decimal sumCompOffHrs = 0;
                decimal sumClaimedWeekDayExtraHours = 0;
                decimal sumClaimedHoliDayExtraHours = 0;

                foreach (var item in WeekEndTotals)
                {
                    sumCompOffHrs += item.ClaimedCompoffHrs;
                    sumClaimedWeekDayExtraHours += item.ClaimedWeekDayExtraHrs;
                    sumClaimedHoliDayExtraHours += item.ClaimedHoliDayExtraHrs;
                }
                //var holiDayExtraHrsTotal = WeekEndTotals.Aggregate((total, next) => total.ClaimedHoliDayExtraHrs + next.ClaimedHoliDayExtraHrs);
                //var weekDayExtraHrsTotal = WeekEndTotals.Aggregate((total, next) => total.ClaimedWeekDayExtraHrs + next.ClaimedWeekDayExtraHrs);

                if (sumCompOffHrs == 0 && sumClaimedWeekDayExtraHours == 0 && sumClaimedHoliDayExtraHours == 0)
                {
                    return Json(new { success = false, response = "CompOff/Extrahours not claimed. Cannot create claim." });
                }

                var result = await _attendanceExtraHoursClaimCreateRepository.CreateExtraHoursClaimAsync(
                                    BaseSpTcmPLGet(),
                                    new ParameterSpTcmPL
                                    {
                                        PSelectedCompoffDays = CompOffDaySelection.Select(o => o.PDate.ToString("dd-MMM-yyyy") + "," + o.DayCompHoursSelected).ToArray(),

                                        PWeekendTotals = WeekEndTotals.Select(
                                                o => o.PDate?.ToString("dd-MMM-yyyy") + "," +
                                                o.ClaimedCompoffHrs + "," +
                                                o.ApplicableHoliDayExtraHrs + "," +
                                                o.ClaimedHoliDayExtraHrs + "," +
                                                o.ApplicableWeekDayExtraHrs + "," +
                                                o.ClaimedWeekDayExtraHrs
                                                ).ToArray(),

                                        PYyyymm = claimPeriod.ToString("yyyy-MM").Replace("-", ""),
                                        PSumCompoffHrs = sumCompOffHrs,
                                        PSumHolidayExtraHrs = sumClaimedHoliDayExtraHours,
                                        PSumWeekdayExtraHrs = sumClaimedWeekDayExtraHours,
                                        PLeadApprover = LeadApprover,
                                        PConfirmationStatus = earlysubmit
                                    });
                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        public async Task<IActionResult> ExtraHoursClaimCreateMain()
        {
            var selfDetail = await _attendanceEmployeeDetailsRepository.AttendanceEmployeeDetailsAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            if (selfDetail.Emptype == "S" || selfDetail.EmpGrade.StartsWith("X"))
            {
                return Forbid();
            }
            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterExtraHoursClaimCreateMain
            });

            FilterDataModel filterDataModel = new FilterDataModel();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            //if (string.IsNullOrEmpty(filterDataModel.Empno))
            //    filterDataModel.StartDate = DateTime.Now;

            PunchDetailsViewModel punchDetailsViewModel = new PunchDetailsViewModel();
            punchDetailsViewModel.FilterDataModel = filterDataModel;

            return View(punchDetailsViewModel);
        }

        public async Task<IActionResult> ExtraHoursClaimCreateFilterGet()
        {
            var empdetails = await _attendanceEmployeeDetailsRepository.AttendanceEmployeeDetailsAsync(BaseSpTcmPLGet(),
               new ParameterSpTcmPL()
               );

            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterExtraHoursClaimCreateMain
            });
            FilterDataModel filterDataModel = new FilterDataModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            return PartialView("_ModalExtraHoursClaimCreateFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> ExtraHoursClaimCreateFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                string jsonFilter = JsonConvert.SerializeObject(new { StartDate = filterDataModel.StartDate });
                if (filterDataModel.StartDate != null)
                {
                    if (filterDataModel.StartDate < new DateTime(DateTime.Now.AddMonths(-4).Year, DateTime.Now.AddMonths(-4).Month, 1))
                        throw new Exception("Cannot create claim for selected month.");
                    else
                    {
                        var retVal = await _filterRepository.FilterCreateAsync(new Domain.Models.FilterCreate
                        {
                            PModuleName = CurrentUserIdentity.CurrentModule,
                            PMetaId = CurrentUserIdentity.MetaId,
                            PPersonId = CurrentUserIdentity.EmployeeId,
                            PMvcActionName = ConstFilterExtraHoursClaimCreateMain,
                            PFilterJson = jsonFilter
                        });
                    }
                }
                return Json(new { success = true, startDate = filterDataModel.StartDate?.ToString("dd-MMM-yyyy") });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        [HttpPost]
        public async Task<IActionResult> ExtraHoursClaimDelete(string ClaimNo)
        {
            var selfDetail = await _attendanceEmployeeDetailsRepository.AttendanceEmployeeDetailsAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            if (selfDetail.Emptype == "S" || selfDetail.EmpGrade.StartsWith("X"))
            {
                return Forbid();
            }
            try
            {
                var result = await _attendanceExtraHoursClaimDeleteRepository.ExtraHoursClaimDeleteAsync(
                                                        BaseSpTcmPLGet(),
                                    new ParameterSpTcmPL
                                    {
                                        PClaimNo = ClaimNo
                                    });

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        [HttpGet]
        public async Task<IActionResult> ExtraHoursClaimDetail(string ClaimNo)
        {
            var claimDetails = await _attendanceExtraHoursDetailDataTableListRepository.AttendanceExtraHoursClaimDetailDataTableList(
                                 BaseSpTcmPLGet(),
                                 new ParameterSpTcmPL
                                 {
                                     PClaimNo = ClaimNo
                                 });

            string empNo = claimDetails.FirstOrDefault().Empno;
            string claimPeriod = claimDetails.FirstOrDefault().ClaimPeriod;

            var claimEmpDetails = await _attendanceEmployeeDetailsRepository.AttendanceEmployeeDetailsAsync(BaseSpTcmPLGet(),
              new ParameterSpTcmPL { PEmpno = empNo }
              );

            var claimHeaderData = await _attendanceExtraHoursDataTableListRepository.AttendanceExtraHoursClaimsDataTableList(
                   BaseSpTcmPLGet(),
                   new ParameterSpTcmPL
                   {
                       PRowNumber = 0,
                       PPageLength = 10,
                       PEmpno = empNo,
                       PStartDate = Convert.ToDateTime(claimPeriod)
                   });

            ViewData["Employee"] = claimEmpDetails.Empno + " - " + claimEmpDetails.Name;

            ViewData["ClaimPeriod"] = claimHeaderData.FirstOrDefault().ClaimPeriod;

            ViewData["LeadStatus"] = claimHeaderData.FirstOrDefault().LeadApprovalDesc;
            ViewData["HodStatus"] = claimHeaderData.FirstOrDefault().HodApprovalDesc;
            ViewData["HRStatus"] = claimHeaderData.FirstOrDefault().HrdApprovalDesc;

            ViewData["EmpWeekDayOT"] = StringHelper.MinutesToHrs(Decimal.ToInt32(claimHeaderData.FirstOrDefault().ClaimedOt));
            ViewData["EmpHoliDayOT"] = StringHelper.MinutesToHrs(Decimal.ToInt32(claimHeaderData.FirstOrDefault().ClaimedHhot));
            ViewData["EmpCompOff"] = StringHelper.MinutesToHrs(Decimal.ToInt32(claimHeaderData.FirstOrDefault().ClaimedCo));

            ViewData["LeadWeekDayOT"] = StringHelper.MinutesToHrs(Decimal.ToInt32(claimHeaderData.FirstOrDefault().LeadApprovedOt.GetValueOrDefault()));
            ViewData["LeadHoliDayOT"] = StringHelper.MinutesToHrs(Decimal.ToInt32(claimHeaderData.FirstOrDefault().LeadApprovedHhot.GetValueOrDefault()));
            ViewData["LeadCompOff"] = StringHelper.MinutesToHrs(Decimal.ToInt32(claimHeaderData.FirstOrDefault().LeadApprovedCo.GetValueOrDefault()));

            ViewData["HodWeekDayOT"] = StringHelper.MinutesToHrs(Decimal.ToInt32(claimHeaderData.FirstOrDefault().HodApprovedOt.GetValueOrDefault()));
            ViewData["HodHoliDayOT"] = StringHelper.MinutesToHrs(Decimal.ToInt32(claimHeaderData.FirstOrDefault().HodApprovedHhot.GetValueOrDefault()));
            ViewData["HodCompOff"] = StringHelper.MinutesToHrs(Decimal.ToInt32(claimHeaderData.FirstOrDefault().HodApprovedCo.GetValueOrDefault()));

            ViewData["HRWeekDayOT"] = StringHelper.MinutesToHrs(Decimal.ToInt32(claimHeaderData.FirstOrDefault().HrdApprovedOt.GetValueOrDefault()));
            ViewData["HRHoliDayOT"] = StringHelper.MinutesToHrs(Decimal.ToInt32(claimHeaderData.FirstOrDefault().HrdApprovedHhot.GetValueOrDefault()));
            ViewData["HRCompOff"] = StringHelper.MinutesToHrs(Decimal.ToInt32(claimHeaderData.FirstOrDefault().HrdApprovedCo.GetValueOrDefault()));

            return PartialView("_ModalExtraHoursClaimDetailPartial", claimDetails.ToList());
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleLead)]
        public async Task<IActionResult> LeadExtraHoursAdjustment(string ApplicationId)
        {
            var result = await _attendanceExtraHoursApprovalDataTableListRepository.AttendanceExtraHoursLeadApprovalDataTableList(
                baseSpTcmPL: BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PRowNumber = 0,
                    PPageLength = 10,
                    PApplicationId = ApplicationId
                });

            var appDetails = result.First();

            ExtraHoursClaimAdjustmentLeadViewModel extraHoursClaimAdjustmentLeadViewModel = new ExtraHoursClaimAdjustmentLeadViewModel
            {
                ClaimNo = appDetails.ClaimNo,
                Empno = appDetails.Empno,
                Employee = appDetails.Employee,
                ClaimedCo = appDetails.ClaimedCo,
                ClaimedHhot = appDetails.ClaimedHhot,
                ClaimedOt = appDetails.ClaimedOt
            };

            return PartialView("_ModalExtraHoursAdjustmentLeadPartial", extraHoursClaimAdjustmentLeadViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleLead)]
        public async Task<IActionResult> LeadExtraHoursAdjustment(ExtraHoursClaimAdjustmentLeadViewModel extraHoursClaimAdjustment)
        {
            try
            {
                string validationMessage = validateExtraHoursAdjustment(maxOT: extraHoursClaimAdjustment.ClaimedOt,
                    maxHHOT: extraHoursClaimAdjustment.ClaimedHhot,
                    maxCO: extraHoursClaimAdjustment.ClaimedCo,
                    adjOT: extraHoursClaimAdjustment.LeadApprovedOt,
                    adjHHOT: extraHoursClaimAdjustment.LeadApprovedHhot,
                    adjCO: extraHoursClaimAdjustment.LeadApprovedCo
                    );
                if (validationMessage != "OK")
                    throw new Exception(validationMessage);

                var result = await _attendanceExtraHoursAdjustmentRepository.LeadExtraHoursAdjustmentAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL
                {
                    PClaimNo = extraHoursClaimAdjustment.ClaimNo,
                    PApprovedCo = extraHoursClaimAdjustment.LeadApprovedCo * 60,
                    PApprovedOt = extraHoursClaimAdjustment.LeadApprovedOt * 60,
                    PApprovedHhot = extraHoursClaimAdjustment.LeadApprovedHhot * 60
                });

                if (result.PMessageType == "OK")
                    return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
                else
                    Notify("Error", result.PMessageText, "", NotificationType.error);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
            return PartialView("_ModalExtraHoursAdjustmentLeadPartial", extraHoursClaimAdjustment);
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleManagerHoD)]
        public async Task<IActionResult> HodExtraHoursAdjustment(string ApplicationId)
        {
            var result = await _attendanceExtraHoursApprovalDataTableListRepository.AttendanceExtraHoursHoDApprovalDataTableList(
                baseSpTcmPL: BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PRowNumber = 0,
                    PPageLength = 10,
                    PApplicationId = ApplicationId
                });

            var appDetails = result.First();

            ExtraHoursClaimAdjustmentHoDViewModel extraHoursClaimAdjustment = new ExtraHoursClaimAdjustmentHoDViewModel
            {
                ClaimNo = appDetails.ClaimNo,
                Empno = appDetails.Empno,
                Employee = appDetails.Employee,
                ClaimedCo = appDetails.ClaimedCo,
                ClaimedHhot = appDetails.ClaimedHhot,
                ClaimedOt = appDetails.ClaimedOt,
                LeadApprovedCo = appDetails.LeadApprovedCo,
                LeadApprovedHhot = appDetails.LeadApprovedHhot,
                LeadApprovedOt = appDetails.LeadApprovedOt
            };

            return PartialView("_ModalExtraHoursAdjustmentHoDPartial", extraHoursClaimAdjustment);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleManagerHoD)]
        public async Task<IActionResult> HodExtraHoursAdjustment(ExtraHoursClaimAdjustmentHoDViewModel extraHoursClaimAdjustment)
        {
            try
            {
                string validationMessage = validateExtraHoursAdjustment(maxOT: extraHoursClaimAdjustment.LeadApprovedOt,
                    maxHHOT: extraHoursClaimAdjustment.LeadApprovedHhot,
                    maxCO: extraHoursClaimAdjustment.LeadApprovedCo,
                    adjOT: extraHoursClaimAdjustment.HoDApprovedOt,
                    adjHHOT: extraHoursClaimAdjustment.HoDApprovedHhot,
                    adjCO: extraHoursClaimAdjustment.HoDApprovedCo
                    );
                if (validationMessage != "OK")
                    throw new Exception(validationMessage);

                var result = await _attendanceExtraHoursAdjustmentRepository.HoDExtraHoursAdjustmentAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL
                {
                    PClaimNo = extraHoursClaimAdjustment.ClaimNo,
                    PApprovedCo = (extraHoursClaimAdjustment.HoDApprovedCo ?? 0) * 60,
                    PApprovedOt = (extraHoursClaimAdjustment.HoDApprovedOt ?? 0) * 60,
                    PApprovedHhot = (extraHoursClaimAdjustment.HoDApprovedHhot ?? 0) * 60
                });

                if (result.PMessageType == "OK")
                    return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
                else
                    Notify("Error", result.PMessageText, "", NotificationType.error);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
            return PartialView("_ModalExtraHoursAdjustmentHoDPartial", extraHoursClaimAdjustment);
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleAttendanceAdmin)]
        public async Task<IActionResult> HrExtraHoursAdjustment(string ApplicationId)
        {
            var result = await _attendanceExtraHoursApprovalDataTableListRepository.AttendanceExtraHoursHRApprovalDataTableList(
                baseSpTcmPL: BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PRowNumber = 0,
                    PPageLength = 10,
                    PApplicationId = ApplicationId
                });

            var appDetails = result.First();

            ExtraHoursClaimAdjustmentHRViewModel extraHoursClaimAdjustment = new ExtraHoursClaimAdjustmentHRViewModel
            {
                ClaimNo = appDetails.ClaimNo,
                Empno = appDetails.Empno,
                Employee = appDetails.Employee,
                ClaimedCo = appDetails.ClaimedCo,
                ClaimedHhot = appDetails.ClaimedHhot,
                ClaimedOt = appDetails.ClaimedOt,
                LeadApprovedCo = appDetails.LeadApprovedCo,
                LeadApprovedHhot = appDetails.LeadApprovedHhot,
                LeadApprovedOt = appDetails.LeadApprovedOt,
                HoDApprovedCo = appDetails.HodApprovedCo,
                HoDApprovedHhot = appDetails.HodApprovedHhot,
                HoDApprovedOt = appDetails.HodApprovedOt,
                HRApprovedOt = appDetails.HrdApprovedOt,
                HRApprovedHhot = appDetails.HrdApprovedHhot,
                HRApprovedCo = appDetails.HrdApprovedCo
            };

            return PartialView("_ModalExtraHoursAdjustmentHRPartial", extraHoursClaimAdjustment);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleAttendanceAdmin)]
        public async Task<IActionResult> HrExtraHoursAdjustment(ExtraHoursClaimAdjustmentHRViewModel extraHoursClaimAdjustment)
        {
            try
            {
                string validationMessage = validateExtraHoursAdjustment(maxOT: extraHoursClaimAdjustment.HoDApprovedOt,
                    maxHHOT: extraHoursClaimAdjustment.HoDApprovedHhot,
                    maxCO: extraHoursClaimAdjustment.HoDApprovedCo,
                    adjOT: extraHoursClaimAdjustment.HRApprovedOt,
                    adjHHOT: extraHoursClaimAdjustment.HRApprovedHhot,
                    adjCO: extraHoursClaimAdjustment.HRApprovedCo
                    );
                if (validationMessage != "OK")
                    throw new Exception(validationMessage);

                var result = await _attendanceExtraHoursAdjustmentRepository.HRExtraHoursAdjustmentAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL
                {
                    PClaimNo = extraHoursClaimAdjustment.ClaimNo,
                    PApprovedCo = extraHoursClaimAdjustment.HRApprovedCo * 60,
                    PApprovedOt = extraHoursClaimAdjustment.HRApprovedOt * 60,
                    PApprovedHhot = extraHoursClaimAdjustment.HRApprovedHhot * 60
                });

                if (result.PMessageType == "OK")
                    return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
                else
                    Notify("Error", result.PMessageText, "", NotificationType.error);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
            return PartialView("_ModalExtraHoursAdjustmentHRPartial", extraHoursClaimAdjustment);
        }

        private string validateExtraHoursAdjustment(decimal? maxOT, decimal? maxHHOT, decimal? maxCO, decimal? adjOT, decimal? adjHHOT, decimal? adjCO)
        {
            string retVal = "OK";
            if ((adjOT + adjHHOT + adjCO) <= 0)
            {
                return "No adjustment exists.";
            }
            if (adjOT > maxOT || adjHHOT > maxHHOT || adjCO > maxCO)
            {
                return "Adjustment OT / HHOT / CO cannot be more than claimed / the approved value by previous approver.";
            }
            if (adjOT % 2 > 0)
            {
                return "Adjustment OT should be in multiples of 2.";
            }
            if (adjHHOT > 0 && (adjHHOT < 4 && adjHHOT % 1 > 0))
            {
                return "Holiday OT Hours should be in multiple of 1hrs, atleast 4hrs.";
            }
            if (adjCO > 0 && adjCO % 4 > 0)
            {
                return "Compensatory Off should be in Multiple of 4hrs";
            }

            return retVal;
        }

        #endregion ExtraHours

        #region ExtraHoursFlexi

        public async Task<IActionResult> ExtraHoursFlexiClaimsIndex()
        {
            var selfDetail = await _attendanceEmployeeDetailsRepository.AttendanceEmployeeDetailsAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            if (selfDetail.Emptype == "S" || selfDetail.EmpGrade.StartsWith("X"))
            {
                return Forbid();
            }

            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterExtraHoursFlexiClaimsIndex
            });

            ExtraHoursFlexiClaimsViewModel extraHoursFlexiClaimsViewModel = new ExtraHoursFlexiClaimsViewModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                extraHoursFlexiClaimsViewModel.FilterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            return View(extraHoursFlexiClaimsViewModel);
        }

        public async Task<JsonResult> GetListsExtraHoursFlexiClaims(DTParameters param)
        {
            var selfDetail = await _attendanceEmployeeDetailsRepository.AttendanceEmployeeDetailsAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            if (selfDetail.Emptype == "S" || selfDetail.EmpGrade.StartsWith("X"))
            {
                throw new Exception("Forbidden");
            }
            DTResult<ExtraHoursFlexiClaimsDataTableList> result = new DTResult<ExtraHoursFlexiClaimsDataTableList>();
            int totalRow = 0;

            try
            {
                var data = await _extraHoursFlexiDataTableListRepository.ExtraHoursFlexiClaimsDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
                        PEmpno = param.Empno,
                        PStartDate = param.StartDate
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

        public async Task<JsonResult> GetListsExtraHoursFlexiClaimsHeader(DTParameters param)
        {
            var empdetails = await _attendanceEmployeeDetailsRepository.AttendanceEmployeeDetailsAsync(BaseSpTcmPLGet(),
                               new ParameterSpTcmPL
                               {
                                   PEmpno = param.Empno
                               }
                               );
            return Json(new { empno = empdetails.Empno, employeeName = empdetails.Name, period = param.StartDate?.ToString("MMM-yyyy") });
        }

        public async Task<IActionResult> ExtraHoursFlexiClaimsFilterGet()
        {
            var empdetails = await _attendanceEmployeeDetailsRepository.AttendanceEmployeeDetailsAsync(BaseSpTcmPLGet(),
                null
               );

            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterExtraHoursFlexiClaimsIndex
            });
            FilterDataModel filterDataModel = new FilterDataModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            if (string.IsNullOrEmpty(filterDataModel.Empno))
                filterDataModel.Empno = empdetails.Empno;

            ViewData["EmpList"] = await getEmployeeSelectList(filterDataModel.Empno);

            //This for Lead / Hod / Hr
            if (CurrentUserIdentity.ProfileActions.Any(pa => pa.RoleId == SelfServiceHelper.RoleManagerHoDOnBeHalf))
            {
                var empList = await _selectTcmPLRepository.EmployeeListForMngrHodOnBeHalfAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());
                ViewData["EmpList"] = new SelectList(empList, "DataValueField", "DataTextField", string.IsNullOrEmpty(filterDataModel.Empno) ? empdetails.Empno : filterDataModel.Empno);
            }
            else if (CurrentUserIdentity.ProfileActions.Any(pa => pa.RoleId == SelfServiceHelper.RoleManagerHoD))
            {
                var empList = await _selectTcmPLRepository.EmployeeListForMngrHodAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());
                ViewData["EmpList"] = new SelectList(empList, "DataValueField", "DataTextField", string.IsNullOrEmpty(filterDataModel.Empno) ? empdetails.Empno : filterDataModel.Empno);
            }
            else if (CurrentUserIdentity.ProfileActions.Any(pa => pa.RoleId == SelfServiceHelper.RoleAttendanceAdmin))
            {
                var empList = await _selectTcmPLRepository.EmployeeListForHRAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());
                ViewData["EmpList"] = new SelectList(empList, "DataValueField", "DataTextField", string.IsNullOrEmpty(filterDataModel.Empno) ? empdetails.Empno : filterDataModel.Empno);
            }
            return PartialView("_ModalExtraHoursFlexiClaimsFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> ExtraHoursFlexiClaimsFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            string jsonFilter;
            if (string.IsNullOrEmpty(filterDataModel.Empno))
                jsonFilter = JsonConvert.SerializeObject(new { StartDate = filterDataModel.StartDate });
            else
                jsonFilter = JsonConvert.SerializeObject(new { StartDate = filterDataModel.StartDate, Empno = filterDataModel.Empno });

            var retVal = await _filterRepository.FilterCreateAsync(new Domain.Models.FilterCreate
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterExtraHoursFlexiClaimsIndex,
                PFilterJson = jsonFilter
            });

            return Json(new { success = true, startDate = filterDataModel.StartDate?.ToString("dd-MMM-yyyy"), empno = filterDataModel.Empno });
        }

        public async Task<IActionResult> ExtraHoursFlexiClaimCreate(DTParameters param)
        {
            var selfDetail = await _attendanceEmployeeDetailsRepository.AttendanceEmployeeDetailsAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            if (selfDetail.Emptype == "S" || selfDetail.EmpGrade.StartsWith("X"))
            {
                return Forbid();
            }
            var empdetails = await _attendanceEmployeeDetailsRepository.AttendanceEmployeeDetailsAsync(
                                BaseSpTcmPLGet(),
                                new ParameterSpTcmPL
                                {
                                    PEmpno = param.Empno
                                });

            DateTime startDate = param.StartDate ?? DateTime.Now;

            ViewData["EmployeeDetails"] = empdetails;
            ViewData["Period"] = startDate.ToString("MMM-yyyy");

            var Approvers = await _selectTcmPLRepository.ApproversListAsync(BaseSpTcmPLGet(), null);
            ViewData["Approvers"] = new SelectList(Approvers, "DataValueField", "DataTextField");
            IEnumerable<PunchDetailsDataTableList> punchDetailsDataTableLists = null;
            var result = await _extraHoursFlexiClaimExistsRepository.CheckClaimExistsAsync(BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PYyyymm = startDate.ToString("yyyy-MM").Replace("-", ""),
                    });

            if (result.PMessageType != "OK")
            {
                Notify("Error", result.PMessageText, "", NotificationType.error);
            }
            else if (result.PClaimExists == "OK")
            {
                Notify("Error", "Extra hours claim for the period already exists.", "", NotificationType.error);
            }
            else
            {
                punchDetailsDataTableLists = await _attendancePunchDetailsDataTableListRepository.AttendancePunchDetailsDataTableList(
                   BaseSpTcmPLGet(),
                   new ParameterSpTcmPL
                   {
                       PYyyymm = startDate.ToString("yyyy-MM").Replace("-", ""),
                       PEmpno = string.IsNullOrEmpty(param.Empno) ? " " : param.Empno,
                       PForOt = "OK"
                   }
               );
            }
            return PartialView("_ExtraHoursFlexiClaimCreatePartial", punchDetailsDataTableLists);
        }

        [HttpPost]
        public async Task<IActionResult> ExtraHoursFlexiClaimCreate(string LeadApprover, string Period, ExtraHoursFlexiClaimSelectedCompOffDays[] CompOffDaySelection, ExtraHoursFlexiClaimWeekEndTotals[] WeekEndTotals, string earlysubmit)
        {
            var selfDetail = await _attendanceEmployeeDetailsRepository.AttendanceEmployeeDetailsAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            if (selfDetail.Emptype == "S" || selfDetail.EmpGrade.StartsWith("X"))
            {
                return Forbid();
            }
            if (string.IsNullOrEmpty(LeadApprover))
            {
                return Json(new { success = false, response = "Lead approver not selected. Cannot create claim." });
            }
            try
            {
                DateTime claimPeriod = DateTime.ParseExact("01-" + Period, "dd-MMM-yyyy", null);

                decimal sumCompOffHrs = 0;
                decimal sumClaimedWeekDayExtraHoursFlexi = 0;
                decimal sumClaimedHoliDayExtraHoursFlexi = 0;

                foreach (var item in WeekEndTotals)
                {
                    sumCompOffHrs += item.ClaimedCompoffHrs;
                    sumClaimedWeekDayExtraHoursFlexi += item.ClaimedWeekDayExtraHrs;
                    sumClaimedHoliDayExtraHoursFlexi += item.ClaimedHoliDayExtraHrs;
                }
                //var holiDayExtraHrsTotal = WeekEndTotals.Aggregate((total, next) => total.ClaimedHoliDayExtraHrs + next.ClaimedHoliDayExtraHrs);
                //var weekDayExtraHrsTotal = WeekEndTotals.Aggregate((total, next) => total.ClaimedWeekDayExtraHrs + next.ClaimedWeekDayExtraHrs);

                if (sumCompOffHrs == 0 && sumClaimedWeekDayExtraHoursFlexi == 0 && sumClaimedHoliDayExtraHoursFlexi == 0)
                {
                    return Json(new { success = false, response = "CompOff/ExtraHoursFlexi not claimed. Cannot create claim." });
                }

                var result = await _extraHoursFlexiClaimCreateRepository.CreateExtraHoursClaimAsync(
                                    BaseSpTcmPLGet(),
                                    new ParameterSpTcmPL
                                    {
                                        PSelectedCompoffDays = CompOffDaySelection.Select(o => o.PDate.ToString("dd-MMM-yyyy") + "," + o.DayCompHoursSelected).ToArray(),

                                        PWeekendTotals = WeekEndTotals.Select(
                                                o => o.PDate?.ToString("dd-MMM-yyyy") + "," +
                                                o.ClaimedCompoffHrs + "," +
                                                o.ApplicableHoliDayExtraHrs + "," +
                                                o.ClaimedHoliDayExtraHrs + "," +
                                                o.ApplicableWeekDayExtraHrs + "," +
                                                o.ClaimedWeekDayExtraHrs
                                                ).ToArray(),

                                        PYyyymm = claimPeriod.ToString("yyyy-MM").Replace("-", ""),
                                        PSumCompoffHrs = sumCompOffHrs,
                                        PSumHolidayExtraHrs = sumClaimedHoliDayExtraHoursFlexi,
                                        PSumWeekdayExtraHrs = sumClaimedWeekDayExtraHoursFlexi,
                                        PLeadApprover = LeadApprover,
                                        PConfirmationStatus = earlysubmit
                                    });
                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        public async Task<IActionResult> ExtraHoursFlexiClaimCreateMain()
        {
            var selfDetail = await _attendanceEmployeeDetailsRepository.AttendanceEmployeeDetailsAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            if (selfDetail.Emptype == "S" || selfDetail.EmpGrade.StartsWith("X"))
            {
                return Forbid();
            }
            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterExtraHoursFlexiClaimCreateMain
            });

            FilterDataModel filterDataModel = new FilterDataModel();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            //if (string.IsNullOrEmpty(filterDataModel.Empno))
            //    filterDataModel.StartDate = DateTime.Now;

            PunchDetailsViewModel punchDetailsViewModel = new PunchDetailsViewModel();
            punchDetailsViewModel.FilterDataModel = filterDataModel;

            return View(punchDetailsViewModel);
        }

        public async Task<IActionResult> ExtraHoursFlexiClaimCreateFilterGet()
        {
            var empdetails = await _attendanceEmployeeDetailsRepository.AttendanceEmployeeDetailsAsync(BaseSpTcmPLGet(),
               new ParameterSpTcmPL()
               );

            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterExtraHoursFlexiClaimCreateMain
            });
            FilterDataModel filterDataModel = new FilterDataModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            return PartialView("_ModalExtraHoursFlexiClaimCreateFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> ExtraHoursFlexiClaimCreateFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                string jsonFilter = JsonConvert.SerializeObject(new { StartDate = filterDataModel.StartDate });
                if (filterDataModel.StartDate != null)
                {
                    if (filterDataModel.StartDate < new DateTime(DateTime.Now.AddMonths(-4).Year, DateTime.Now.AddMonths(-4).Month, 1))
                        throw new Exception("Cannot create claim for selected month.");
                    else
                    {
                        var retVal = await _filterRepository.FilterCreateAsync(new Domain.Models.FilterCreate
                        {
                            PModuleName = CurrentUserIdentity.CurrentModule,
                            PMetaId = CurrentUserIdentity.MetaId,
                            PPersonId = CurrentUserIdentity.EmployeeId,
                            PMvcActionName = ConstFilterExtraHoursFlexiClaimCreateMain,
                            PFilterJson = jsonFilter
                        });
                    }
                }
                return Json(new { success = true, startDate = filterDataModel.StartDate?.ToString("dd-MMM-yyyy") });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        [HttpPost]
        public async Task<IActionResult> ExtraHoursFlexiClaimDelete(string ClaimNo)
        {
            var selfDetail = await _attendanceEmployeeDetailsRepository.AttendanceEmployeeDetailsAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            if (selfDetail.Emptype == "S" || selfDetail.EmpGrade.StartsWith("X"))
            {
                return Forbid();
            }
            try
            {
                var result = await _extraHoursFlexiClaimDeleteRepository
                            .ExtraHoursClaimDeleteAsync(BaseSpTcmPLGet(),
                                    new ParameterSpTcmPL
                                    {
                                        PClaimNo = ClaimNo
                                    });

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        [HttpGet]
        public async Task<IActionResult> ExtraHoursFlexiClaimDetail(string ClaimNo)
        {
            var claimDetails = await _extraHoursFlexiDetailDataTableListRepository.ExtraHoursFlexiClaimDetailDataTableList(
                                 BaseSpTcmPLGet(),
                                 new ParameterSpTcmPL
                                 {
                                     PClaimNo = ClaimNo
                                 });

            string empNo = claimDetails.FirstOrDefault().Empno;
            string claimPeriod = claimDetails.FirstOrDefault().ClaimPeriod;

            var claimEmpDetails = await _attendanceEmployeeDetailsRepository.AttendanceEmployeeDetailsAsync(BaseSpTcmPLGet(),
              new ParameterSpTcmPL { PEmpno = empNo }
              );

            var claimHeaderData = await _extraHoursFlexiDataTableListRepository.ExtraHoursFlexiClaimsDataTableList(
                   BaseSpTcmPLGet(),
                   new ParameterSpTcmPL
                   {
                       PRowNumber = 0,
                       PPageLength = 10,
                       PEmpno = empNo,
                       PStartDate = Convert.ToDateTime(claimPeriod)
                   });

            ViewData["Employee"] = claimEmpDetails.Empno + " - " + claimEmpDetails.Name;

            ViewData["ClaimPeriod"] = claimHeaderData.FirstOrDefault().ClaimPeriod;

            ViewData["LeadStatus"] = claimHeaderData.FirstOrDefault().LeadApprovalDesc;
            ViewData["HodStatus"] = claimHeaderData.FirstOrDefault().HodApprovalDesc;
            ViewData["HRStatus"] = claimHeaderData.FirstOrDefault().HrdApprovalDesc;

            ViewData["EmpWeekDayOT"] = StringHelper.MinutesToHrs(Decimal.ToInt32(claimHeaderData.FirstOrDefault().ClaimedOt));
            ViewData["EmpHoliDayOT"] = StringHelper.MinutesToHrs(Decimal.ToInt32(claimHeaderData.FirstOrDefault().ClaimedHhot));
            ViewData["EmpCompOff"] = StringHelper.MinutesToHrs(Decimal.ToInt32(claimHeaderData.FirstOrDefault().ClaimedCo));

            ViewData["LeadWeekDayOT"] = StringHelper.MinutesToHrs(Decimal.ToInt32(claimHeaderData.FirstOrDefault().LeadApprovedOt.GetValueOrDefault()));
            ViewData["LeadHoliDayOT"] = StringHelper.MinutesToHrs(Decimal.ToInt32(claimHeaderData.FirstOrDefault().LeadApprovedHhot.GetValueOrDefault()));
            ViewData["LeadCompOff"] = StringHelper.MinutesToHrs(Decimal.ToInt32(claimHeaderData.FirstOrDefault().LeadApprovedCo.GetValueOrDefault()));

            ViewData["HodWeekDayOT"] = StringHelper.MinutesToHrs(Decimal.ToInt32(claimHeaderData.FirstOrDefault().HodApprovedOt.GetValueOrDefault()));
            ViewData["HodHoliDayOT"] = StringHelper.MinutesToHrs(Decimal.ToInt32(claimHeaderData.FirstOrDefault().HodApprovedHhot.GetValueOrDefault()));
            ViewData["HodCompOff"] = StringHelper.MinutesToHrs(Decimal.ToInt32(claimHeaderData.FirstOrDefault().HodApprovedCo.GetValueOrDefault()));

            ViewData["HRWeekDayOT"] = StringHelper.MinutesToHrs(Decimal.ToInt32(claimHeaderData.FirstOrDefault().HrdApprovedOt.GetValueOrDefault()));
            ViewData["HRHoliDayOT"] = StringHelper.MinutesToHrs(Decimal.ToInt32(claimHeaderData.FirstOrDefault().HrdApprovedHhot.GetValueOrDefault()));
            ViewData["HRCompOff"] = StringHelper.MinutesToHrs(Decimal.ToInt32(claimHeaderData.FirstOrDefault().HrdApprovedCo.GetValueOrDefault()));

            return PartialView("_ModalExtraHoursFlexiClaimDetailPartial", claimDetails.ToList());
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleLead)]
        public async Task<IActionResult> LeadExtraHoursFlexiAdjustment(string ApplicationId)
        {
            var result = await _extraHoursFlexiApprovalDataTableListRepository.ExtraHoursFlexiLeadApprovalDataTableList(
                baseSpTcmPL: BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PRowNumber = 0,
                    PPageLength = 10,
                    PApplicationId = ApplicationId
                });

            var appDetails = result.First();

            ExtraHoursFlexiClaimAdjustmentLeadViewModel ExtraHoursFlexiClaimAdjustmentLeadViewModel = new ExtraHoursFlexiClaimAdjustmentLeadViewModel
            {
                ClaimNo = appDetails.ClaimNo,
                Empno = appDetails.Empno,
                Employee = appDetails.Employee,
                ClaimedCo = appDetails.ClaimedCo,
                ClaimedHhot = appDetails.ClaimedHhot,
                ClaimedOt = appDetails.ClaimedOt
            };

            return PartialView("_ModalExtraHoursFlexiAdjustmentLeadPartial", ExtraHoursFlexiClaimAdjustmentLeadViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleLead)]
        public async Task<IActionResult> LeadExtraHoursFlexiAdjustment(ExtraHoursFlexiClaimAdjustmentLeadViewModel ExtraHoursFlexiClaimAdjustment)
        {
            try
            {
                string validationMessage = validateExtraHoursFlexiAdjustment(maxOT: ExtraHoursFlexiClaimAdjustment.ClaimedOt,
                    maxHHOT: ExtraHoursFlexiClaimAdjustment.ClaimedHhot,
                    maxCO: ExtraHoursFlexiClaimAdjustment.ClaimedCo,
                    adjOT: ExtraHoursFlexiClaimAdjustment.LeadApprovedOt,
                    adjHHOT: ExtraHoursFlexiClaimAdjustment.LeadApprovedHhot,
                    adjCO: ExtraHoursFlexiClaimAdjustment.LeadApprovedCo
                    );
                if (validationMessage != "OK")
                    throw new Exception(validationMessage);

                var result = await _extraHoursFlexiAdjustmentRepository.LeadExtraHoursAdjustmentAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL
                {
                    PClaimNo = ExtraHoursFlexiClaimAdjustment.ClaimNo,
                    PApprovedCo = ExtraHoursFlexiClaimAdjustment.LeadApprovedCo * 60,
                    PApprovedOt = ExtraHoursFlexiClaimAdjustment.LeadApprovedOt * 60,
                    PApprovedHhot = ExtraHoursFlexiClaimAdjustment.LeadApprovedHhot * 60
                });

                if (result.PMessageType == "OK")
                    return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
                else
                    Notify("Error", result.PMessageText, "", NotificationType.error);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
            return PartialView("_ModalExtraHoursFlexiAdjustmentLeadPartial", ExtraHoursFlexiClaimAdjustment);
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleManagerHoD)]
        public async Task<IActionResult> HodExtraHoursFlexiAdjustment(string ApplicationId)
        {
            var result = await _extraHoursFlexiApprovalDataTableListRepository.ExtraHoursFlexiHoDApprovalDataTableList(
                    baseSpTcmPL: BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = 0,
                        PPageLength = 10,
                        PApplicationId = ApplicationId
                    });

            var appDetails = result.First();

            ExtraHoursFlexiClaimAdjustmentHoDViewModel ExtraHoursFlexiClaimAdjustment = new ExtraHoursFlexiClaimAdjustmentHoDViewModel
            {
                ClaimNo = appDetails.ClaimNo,
                Empno = appDetails.Empno,
                Employee = appDetails.Employee,
                ClaimedCo = appDetails.ClaimedCo,
                ClaimedHhot = appDetails.ClaimedHhot,
                ClaimedOt = appDetails.ClaimedOt,
                LeadApprovedCo = appDetails.LeadApprovedCo,
                LeadApprovedHhot = appDetails.LeadApprovedHhot,
                LeadApprovedOt = appDetails.LeadApprovedOt
            };

            return PartialView("_ModalExtraHoursFlexiAdjustmentHoDPartial", ExtraHoursFlexiClaimAdjustment);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleManagerHoD)]
        public async Task<IActionResult> HodExtraHoursFlexiAdjustment(ExtraHoursFlexiClaimAdjustmentHoDViewModel ExtraHoursFlexiClaimAdjustment)
        {
            try
            {
                string validationMessage = validateExtraHoursFlexiAdjustment(maxOT: ExtraHoursFlexiClaimAdjustment.LeadApprovedOt,
                    maxHHOT: ExtraHoursFlexiClaimAdjustment.LeadApprovedHhot,
                    maxCO: ExtraHoursFlexiClaimAdjustment.LeadApprovedCo,
                    adjOT: ExtraHoursFlexiClaimAdjustment.HoDApprovedOt,
                    adjHHOT: ExtraHoursFlexiClaimAdjustment.HoDApprovedHhot,
                    adjCO: ExtraHoursFlexiClaimAdjustment.HoDApprovedCo
                    );
                if (validationMessage != "OK")
                    throw new Exception(validationMessage);

                var result = await _extraHoursFlexiAdjustmentRepository.HoDExtraHoursAdjustmentAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL
                {
                    PClaimNo = ExtraHoursFlexiClaimAdjustment.ClaimNo,
                    PApprovedCo = (ExtraHoursFlexiClaimAdjustment.HoDApprovedCo ?? 0) * 60,
                    PApprovedOt = (ExtraHoursFlexiClaimAdjustment.HoDApprovedOt ?? 0) * 60,
                    PApprovedHhot = (ExtraHoursFlexiClaimAdjustment.HoDApprovedHhot ?? 0) * 60
                });

                if (result.PMessageType == "OK")
                    return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
                else
                    Notify("Error", result.PMessageText, "", NotificationType.error);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
            return PartialView("_ModalExtraHoursFlexiAdjustmentHoDPartial", ExtraHoursFlexiClaimAdjustment);
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleAttendanceAdmin)]
        public async Task<IActionResult> HrExtraHoursFlexiAdjustment(string ApplicationId)
        {
            var result = await _extraHoursFlexiApprovalDataTableListRepository.ExtraHoursFlexiHRApprovalDataTableList(
                    baseSpTcmPL: BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = 0,
                        PPageLength = 10,
                        PApplicationId = ApplicationId
                    });

            var appDetails = result.First();

            ExtraHoursFlexiClaimAdjustmentHRViewModel ExtraHoursFlexiClaimAdjustment = new ExtraHoursFlexiClaimAdjustmentHRViewModel
            {
                ClaimNo = appDetails.ClaimNo,
                Empno = appDetails.Empno,
                Employee = appDetails.Employee,
                ClaimedCo = appDetails.ClaimedCo,
                ClaimedHhot = appDetails.ClaimedHhot,
                ClaimedOt = appDetails.ClaimedOt,
                LeadApprovedCo = appDetails.LeadApprovedCo,
                LeadApprovedHhot = appDetails.LeadApprovedHhot,
                LeadApprovedOt = appDetails.LeadApprovedOt,
                HoDApprovedCo = appDetails.HodApprovedCo,
                HoDApprovedHhot = appDetails.HodApprovedHhot,
                HoDApprovedOt = appDetails.HodApprovedOt,
                HRApprovedOt = appDetails.HrdApprovedOt,
                HRApprovedHhot = appDetails.HrdApprovedHhot,
                HRApprovedCo = appDetails.HrdApprovedCo
            };

            return PartialView("_ModalExtraHoursFlexiAdjustmentHRPartial", ExtraHoursFlexiClaimAdjustment);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleAttendanceAdmin)]
        public async Task<IActionResult> HrExtraHoursFlexiAdjustment(ExtraHoursFlexiClaimAdjustmentHRViewModel ExtraHoursFlexiClaimAdjustment)
        {
            try
            {
                string validationMessage = validateExtraHoursFlexiAdjustment(maxOT: ExtraHoursFlexiClaimAdjustment.HoDApprovedOt,
                    maxHHOT: ExtraHoursFlexiClaimAdjustment.HoDApprovedHhot,
                    maxCO: ExtraHoursFlexiClaimAdjustment.HoDApprovedCo,
                    adjOT: ExtraHoursFlexiClaimAdjustment.HRApprovedOt,
                    adjHHOT: ExtraHoursFlexiClaimAdjustment.HRApprovedHhot,
                    adjCO: ExtraHoursFlexiClaimAdjustment.HRApprovedCo
                    );
                if (validationMessage != "OK")
                    throw new Exception(validationMessage);

                var result = await _extraHoursFlexiAdjustmentRepository.HRExtraHoursAdjustmentAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL
                {
                    PClaimNo = ExtraHoursFlexiClaimAdjustment.ClaimNo,
                    PApprovedCo = ExtraHoursFlexiClaimAdjustment.HRApprovedCo * 60,
                    PApprovedOt = ExtraHoursFlexiClaimAdjustment.HRApprovedOt * 60,
                    PApprovedHhot = ExtraHoursFlexiClaimAdjustment.HRApprovedHhot * 60
                });

                if (result.PMessageType == "OK")
                    return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
                else
                    Notify("Error", result.PMessageText, "", NotificationType.error);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
            return PartialView("_ModalExtraHoursFlexiAdjustmentHRPartial", ExtraHoursFlexiClaimAdjustment);
        }

        private string validateExtraHoursFlexiAdjustment(decimal? maxOT, decimal? maxHHOT, decimal? maxCO, decimal? adjOT, decimal? adjHHOT, decimal? adjCO)
        {
            string retVal = "OK";
            if ((adjOT + adjHHOT + adjCO) <= 0)
            {
                return "No adjustment exists.";
            }
            if (adjOT > maxOT || adjHHOT > maxHHOT || adjCO > maxCO)
            {
                return "Adjustment OT / HHOT / CO cannot be more than claimed / the approved value by previous approver.";
            }
            if (adjOT % 2 > 0)
            {
                return "Adjustment OT should be in multiples of 2.";
            }
            if (adjHHOT > 0 && (adjHHOT < 4 && adjHHOT % 1 > 0))
            {
                return "Holiday OT Hours should be in multiple of 1hrs, at least 4hrs.";
            }
            if (adjCO > 0 && adjCO % 4 > 0)
            {
                return "Compensatory Off should be in Multiple of 4hrs";
            }

            return retVal;
        }

        #endregion ExtraHoursFlexi

        #region HolidayAttendance

        public IActionResult HolidayAttendanceFilterGet()
        {
            FilterDataModel filterDataModel = new FilterDataModel();
            return PartialView("_ModalHolidayAttendanceFilterSet", filterDataModel);
        }

        [HttpPost]
        public IActionResult HolidayAttendanceFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                if (filterDataModel.StartDate != null || filterDataModel.EndDate != null)
                {
                    if (filterDataModel.StartDate == null || filterDataModel.EndDate == null)
                        throw new Exception("Both the dates are reqired.");
                    else if (filterDataModel.StartDate?.ToString("yyyy") != filterDataModel.EndDate?.ToString("yyyy"))
                        throw new Exception("Date range should be with in same year.");
                    else if (filterDataModel.StartDate > filterDataModel.EndDate)
                        throw new Exception("End date should be greater than start date");
                    else
                        return Json(new { success = true, startDate = filterDataModel.StartDate, endDate = filterDataModel.EndDate });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
            return PartialView("_ModalHolidayAttendanceFilterSet", filterDataModel);
        }

        public IActionResult HolidayAttendanceIndex()
        {
            return View();
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsHolidayAttendance(DTParameters param)
        {
            DTResult<HolidayAttendanceDataTableList> result = new DTResult<HolidayAttendanceDataTableList>();
            int totalRow = 0;

            try
            {
                var data = await _attendanceHolidayAttendanceDataTableListRepository.AttendanceHolidayAttendanceDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
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

        public async Task<IActionResult> HolidayAttendanceCreate()
        {
            var office = _selectTcmPLRepository.GetListOffice();
            ViewData["Office"] = new SelectList(office, "DataValueField", "DataTextField");

            var approvers = await _selectTcmPLRepository.ApproversListAsync(BaseSpTcmPLGet(), null);
            ViewData["Approvers"] = new SelectList(approvers, "DataValueField", "DataTextField");

            var projects = await _selectTcmPLRepository.ProjectListAsync(BaseSpTcmPLGet(), null);
            ViewData["Projects"] = new SelectList(projects, "DataValueField", "DataTextField");

            return PartialView("_ModalHolidayAttendanceCreatePartial");
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> HolidayAttendanceCreate([FromForm] HolidayAttendanceCreateViewModel holidayAttendanceCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _attendanceHolidayAttendanceCreateRepository.CreateHolidayAttendanceAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            POffice = holidayAttendanceCreateViewModel.Office,
                            PDate = holidayAttendanceCreateViewModel.HolidayAttendanceDate,
                            PProject = holidayAttendanceCreateViewModel.Project,
                            PApprover = holidayAttendanceCreateViewModel.Approvers,
                            PHh1 = holidayAttendanceCreateViewModel.StartTime.Split(":")[0],
                            PMi1 = holidayAttendanceCreateViewModel.StartTime.Split(":")[1],
                            PHh2 = holidayAttendanceCreateViewModel.EndTime.Split(":")[0],
                            PMi2 = holidayAttendanceCreateViewModel.EndTime.Split(":")[1],
                            PReason = holidayAttendanceCreateViewModel.Remarks,
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

            var office = _selectTcmPLRepository.GetListOffice();
            ViewData["Office"] = new SelectList(office, "DataValueField", "DataTextField");

            var approvers = await _selectTcmPLRepository.ApproversListAsync(BaseSpTcmPLGet(), null);
            ViewData["Approvers"] = new SelectList(approvers, "DataValueField", "DataTextField");

            var projects = await _selectTcmPLRepository.ProjectListAsync(BaseSpTcmPLGet(), null);
            ViewData["Projects"] = new SelectList(projects, "DataValueField", "DataTextField");

            return PartialView("_ModalHolidayAttendanceCreatePartial", holidayAttendanceCreateViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> HolidayAttendanceDelete(string ApplicationId)
        {
            try
            {
                var result = await _attendanceHolidayAttendanceDeleteRepository.DeleteHolidayAttendanceAsync(
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

        [HttpGet]
        public async Task<IActionResult> HolidayAttendanceDetails(string ApplicationId)
        {
            var result = await _attendanceHolidayAttendanceDetailsRepository
                                .HolidayAttendanceDetailsAsync
                                (BaseSpTcmPLGet(), new ParameterSpTcmPL { PApplicationId = ApplicationId });

            HolidayAttendanceDetailsViewModel holidayAttendanceDetailsViewModel = new HolidayAttendanceDetailsViewModel
            {
                ApplicationId = ApplicationId,
                ApplicationDate = result.PApplicationDate,
                AttendanceDate = result.PAttendanceDate,
                Description = result.PDescription,
                Employee = result.PEmployee,
                HodApprl = result.PHodApprl,
                HodApprlDate = result.PHodApprlDate,
                HodRemarks = result.PHodRemarks,
                HrApprl = result.PHodApprl,
                HrApprlDate = result.PHrApprlDate,
                HrRemarks = result.PHrRemarks,
                LeadApprl = result.PLeadApprl,
                LeadApprlDate = result.PLeadApprlDate,
                LeadRemarks = result.PLeadRemarks,
                LeadApprlEmpno = result.PLeadApprlEmpno,
                LeadName = result.PLeadName,
                Office = result.POffice,
                Project = result.PProjno,
                PunchInTime = result.PPunchInTime,
                PunchOutTime = result.PPunchOutTime,
                Remarks = result.PRemarks
            };

            return PartialView("_ModalHolidayAttendanceDetailPartial", holidayAttendanceDetailsViewModel);
        }

        #endregion HolidayAttendance

        #region LeaveClaimsIndex

        public async Task<IActionResult> LeaveClaimsIndex()
        {
            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterLeaveClaimIndex
            });
            FilterDataModel filterDataModel = new FilterDataModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }
            LeaveClaimsViewModel leaveClaimsViewModel = new LeaveClaimsViewModel();
            leaveClaimsViewModel.FilterDataModel = filterDataModel;
            return View(leaveClaimsViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsLeaveClaims(DTParameters param)
        {
            DTResult<LeaveClaimsDataTableList> result = new DTResult<LeaveClaimsDataTableList>();
            int totalRow = 0;

            try
            {
                var data = await _attendanceLeaveClaimsDataTableListRepository.AttendanceLeaveClaimsDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
                        PStartDate = param.StartDate,
                        PEndDate = param.EndDate,
                        PEmpno = param.Empno,
                        PLeaveType = param.LeaveType,
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

        public async Task<IActionResult> LeaveClaimFilterGet()
        {
            var empdetails = await _attendanceEmployeeDetailsRepository.AttendanceEmployeeDetailsAsync(BaseSpTcmPLGet(),
                null
               );

            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterLeaveClaimIndex
            });
            FilterDataModel filterDataModel = new FilterDataModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }
            //if (string.IsNullOrEmpty(filterDataModel.Empno))
            //    filterDataModel.Empno = empdetails.Empno;

            var empList = await _selectTcmPLRepository.EmployeeListForHRAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["EmpList"] = new SelectList(empList, "DataValueField", "DataTextField", filterDataModel.Empno);

            return PartialView("_ModalHRLeaveClaimFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> LeaveClaimFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                if (filterDataModel.StartDate != null || filterDataModel.EndDate != null)
                {
                    if (filterDataModel.StartDate == null || filterDataModel.EndDate == null)
                        throw new Exception("Both the dates are reqired.");
                    else if (filterDataModel.StartDate?.ToString("yyyy") != filterDataModel.EndDate?.ToString("yyyy"))
                        throw new Exception("Date range should be with in same year.");
                    else if (filterDataModel.StartDate > filterDataModel.EndDate)
                        throw new Exception("End date should be greater than start date");
                }
                {
                    string jsonFilter;
                    jsonFilter = JsonConvert.SerializeObject(
                            new
                            {
                                StartDate = filterDataModel.StartDate,
                                EndDate = filterDataModel.EndDate,
                                Empno = filterDataModel.Empno,
                                LeaveType = filterDataModel.LeaveType
                            }
                            );

                    var retVal = await _filterRepository.FilterCreateAsync(new Domain.Models.FilterCreate
                    {
                        PModuleName = CurrentUserIdentity.CurrentModule,
                        PMetaId = CurrentUserIdentity.MetaId,
                        PPersonId = CurrentUserIdentity.EmployeeId,
                        PMvcActionName = ConstFilterLeaveClaimIndex,
                        PFilterJson = jsonFilter
                    });

                    return Json(new
                    {
                        success = true,
                        leaveType = filterDataModel.LeaveType,
                        empno = filterDataModel.Empno,
                        startDate = filterDataModel.StartDate,
                        endDate = filterDataModel.EndDate
                    });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
            //return PartialView("_ModalLeaveFilterSet", filterDataModel);
        }

        public async Task<IActionResult> LeaveClaimCreate()
        {
            var leaveTypes = await _selectTcmPLRepository.LeaveTypesForLeaveClaims(BaseSpTcmPLGet(), null);
            ViewData["LeaveTypes"] = new SelectList(leaveTypes, "DataValueField", "DataTextField");

            var employeeList = await getEmployeeSelectList(string.Empty);
            ViewData["EmployeeList"] = employeeList;

            var halfDayDay = getListHalfDayDay();
            ViewData["HalfDayDay"] = new SelectList(halfDayDay, "DataValueField", "DataTextField");

            return PartialView("_ModalLeaveClaimCreatePartial");
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> LeaveClaimCreate([FromForm] LeaveClaimCreateViewModel leaveClaimCreateViewModel)
        {
            bool dataIsValid = true;
            string medicalCertificateFileName = string.Empty;
            try
            {
                if (ModelState.IsValid)
                {
                    bool fileNotExists = (leaveClaimCreateViewModel.file?.Length ?? 0) == 0;
                    if ((leaveClaimCreateViewModel.LeaveType == "SL" || leaveClaimCreateViewModel.LeaveType == "SC") && leaveClaimCreateViewModel.LeavePeriod >= 2 && fileNotExists)
                        dataIsValid = false;

                    if (dataIsValid)
                    {
                        if (leaveClaimCreateViewModel.file?.Length > 0)
                        {
                            medicalCertificateFileName = await StorageHelper.SaveFileAsync(StorageHelper.Attendance.RepositoryMedicalCertificate, leaveClaimCreateViewModel.Empno, StorageHelper.Attendance.GroupMedicalCertificate, leaveClaimCreateViewModel.file, Configuration);
                        }
                        var result = await _attendanceLeaveClaimCreateRepository.CreateLeaveClaimAsync(BaseSpTcmPLGet(),
                            new ParameterSpTcmPL
                            {
                                PEmpno = leaveClaimCreateViewModel.Empno,
                                PLeaveType = leaveClaimCreateViewModel.LeaveType,
                                PLeavePeriod = leaveClaimCreateViewModel.LeavePeriod,
                                PStartDate = leaveClaimCreateViewModel.StartDate,
                                PEndDate = leaveClaimCreateViewModel.EndDate,
                                PHalfDayOn = leaveClaimCreateViewModel.HalfDayDay,
                                PDescription = leaveClaimCreateViewModel.Description,
                                PMedCertFileNm = medicalCertificateFileName,
                                PAdjustmentType = "LC"
                            });
                        if (result.PMessageType != IsOk)
                        {
                            if (!string.IsNullOrEmpty(medicalCertificateFileName))
                                StorageHelper.DeleteFile(StorageHelper.Attendance.RepositoryMedicalCertificate, medicalCertificateFileName, Configuration);
                            throw new Exception(result.PMessageText);
                        }
                        else
                        {
                            return Json(new { success = true, response = result.PMessageText });
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            var leaveTypes = await _selectTcmPLRepository.LeaveTypeListAsync(BaseSpTcmPLGet(), null);
            ViewData["LeaveTypes"] = new SelectList(leaveTypes, "DataValueField", "DataTextField", leaveClaimCreateViewModel.LeaveType);

            var employeeList = await getEmployeeSelectList(string.Empty);
            ViewData["EmployeeList"] = employeeList;

            var halfDayDay = getListHalfDayDay();
            ViewData["HalfDayDay"] = new SelectList(halfDayDay, "DataValueField", "DataTextField", leaveClaimCreateViewModel.HalfDayDay);

            return PartialView("_ModalLeaveClaimCreatePartial", leaveClaimCreateViewModel);
        }

        public IActionResult LeaveClaimsXLUpload()
        {
            return PartialView("_ModalLeaveClaimsUploadPartial");
        }

        public async Task<IActionResult> LeaveClaimsXLTemplate()
        {
            var leaveTypes = await _selectTcmPLRepository.LeaveTypeListAsync(BaseSpTcmPLGet(), null);

            var dictionaryItems = new List<Library.Excel.Template.Models.DictionaryItem>();

            var dictionaryAdjustType = new List<DictionaryItem> {
                new DictionaryItem
                    {
                        FieldName = "AdjustmentType",
                        Value = "SW"
                    },
                new DictionaryItem
                    {
                        FieldName = "AdjustmentType",
                        Value = "LC"
                    }
                };

            dictionaryItems.AddRange(dictionaryAdjustType);

            foreach (var item in leaveTypes)
            {
                dictionaryItems.Add(
                    new DictionaryItem { FieldName = "LeaveType", Value = item.DataValueField }
                    );
            }

            Stream ms = _excelTemplate.ExportLeaveClaims("v01",
            new Library.Excel.Template.Models.DictionaryCollection
            {
                DictionaryItems = dictionaryItems
            },
            500);
            var fileName = "ImportSiteLeaves.xlsx";
            var mimeType = MimeTypeMap.GetMimeType("xlsx");

            ms.Position = 0;
            return File(ms, mimeType, fileName);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> LeaveClaimXLUpload(IFormFile file)
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

                List<Library.Excel.Template.Models.LeaveClaim> leaveClaims = _excelTemplate.ImportLeaveClaims(stream);

                string[] aryLeaveClaims = leaveClaims.Select(p =>
                                                            p.Empno + "~!~" +
                                                            p.LeaveType + "~!~" +
                                                            p.NoOfDays.ToString() + "~!~" +
                                                            p.StartDate.ToString("yyyyMMdd") + "~!~" +
                                                            p.EndDate?.ToString("yyyyMMdd") + " ~!~" +
                                                            p.Reason + " ~!~" +
                                                            p.AdjustmentType).ToArray();

                var uploadOutPut = await _attendanceLeaveClaimImportRepository.ImportLeaveClaimAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PLeaveClaims = aryLeaveClaims
                        }
                    );

                List<ImportFileResultViewModel> importFileResults = new List<ImportFileResultViewModel>();

                if (uploadOutPut.PLeaveClaimErrors?.Length > 0)
                {
                    foreach (string err in uploadOutPut.PLeaveClaimErrors)
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

        #endregion LeaveClaimsIndex

        #region ShiftMaster

        public async Task<IActionResult> ShiftMasterIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterShiftMasterIndex
            });

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            ShiftMasterViewModel shiftMasterViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(shiftMasterViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsShiftMaster(string paramJson)
        {
            DTResult<ShiftMasterDataTableList> result = new();
            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            int totalRow = 0;

            try
            {
                System.Collections.Generic.IEnumerable<ShiftMasterDataTableList> data = await _shiftDataTableListRepository.ShiftDataTableListAsync(
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
        public IActionResult ShiftCreate()
        {
            ShiftCreateViewModel shiftCreateViewModel = new();

            return PartialView("_ModalShiftCreatePartial", shiftCreateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ShiftCreate([FromForm] ShiftCreateViewModel shiftCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _shiftMasterRepository.ShiftCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PShiftcode = shiftCreateViewModel.Shiftcode,
                            PShiftdesc = shiftCreateViewModel.Shiftdesc,
                            PTimeinHh = Convert.ToInt32(shiftCreateViewModel.TimeIn.Split(":")[0]),
                            PTimeinMn = Convert.ToInt32(shiftCreateViewModel.TimeIn.Split(":")[1]),
                            PTimeoutHh = Convert.ToInt32(shiftCreateViewModel.TimeOut.Split(":")[0]),
                            PTimeoutMn = Convert.ToInt32(shiftCreateViewModel.TimeOut.Split(":")[1]),
                            PShift4allowance = shiftCreateViewModel.Shift4allowance,
                            PLunchMn = shiftCreateViewModel.LunchMn,
                            POtApplicable = shiftCreateViewModel.OtApplicable,
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

            return PartialView("_ModalShiftCreatePartial", shiftCreateViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> ShiftDelete(string id)
        {
            try
            {
                var result = await _shiftMasterRepository.ShiftDeleteAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PShiftcode = id
                    }
                    );

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        [HttpGet]
        public async Task<IActionResult> ShiftDetailsTab1(string id)
        {
            try
            {
                if (id == null)
                {
                    return NotFound();
                }

                var result = await _shiftDetailRepository.ShiftDetail(BaseSpTcmPLGet(), new ParameterSpTcmPL
                {
                    PShiftcode = id
                });

                ShiftDetailsViewModel shiftDetailsViewModel = new();

                if (result.PMessageType == IsOk)
                {
                    shiftDetailsViewModel.Shiftcode = id;
                    shiftDetailsViewModel.Shiftdesc = result.PShiftdesc;
                    shiftDetailsViewModel.TimeinHh = result.PTimeinHh;
                    shiftDetailsViewModel.TimeinMn = result.PTimeinMn;
                    shiftDetailsViewModel.TimeoutHh = result.PTimeoutHh;
                    shiftDetailsViewModel.TimeoutMn = result.PTimeoutMn;
                    shiftDetailsViewModel.Shift4allowance = result.PShift4allowance;
                    shiftDetailsViewModel.Shift4allowanceText = result.PShift4allowanceText;
                    shiftDetailsViewModel.LunchMn = result.PLunchMn;
                    shiftDetailsViewModel.OtApplicable = result.POtApplicable;
                    shiftDetailsViewModel.OtApplicableText = result.POtApplicableText;
                }

                return PartialView("_ModalShiftDetailsTab1Partial", shiftDetailsViewModel);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [HttpGet]
        public async Task<IActionResult> ShiftDetailsTab2(string id)
        {
            try
            {
                if (id == null)
                {
                    return NotFound();
                }

                ShiftConfigDetailsViewModel shiftConfigDetailsViewModel = new();

                var data = await _shiftConfigDetailRepository.ShiftConfigDetail(BaseSpTcmPLGet(), new ParameterSpTcmPL
                {
                    PShiftcode = id
                });

                shiftConfigDetailsViewModel.Shiftcode = id;
                shiftConfigDetailsViewModel.Shiftdesc = data.PShiftDesc;

                if (data.PMessageType == IsOk)
                {

                    shiftConfigDetailsViewModel.ChFdStartMi = StringHelper.MinutesToHrs(Convert.ToInt32(data.PChFdStartMi));
                    shiftConfigDetailsViewModel.ChFdEndMi = StringHelper.MinutesToHrs(Convert.ToInt32(data.PChFdEndMi));
                    shiftConfigDetailsViewModel.ChFhStartMi = StringHelper.MinutesToHrs(Convert.ToInt32(data.PChFhStartMi));
                    shiftConfigDetailsViewModel.ChFhEndMi = StringHelper.MinutesToHrs(Convert.ToInt32(data.PChFhEndMi));
                    shiftConfigDetailsViewModel.ChShStartMi = StringHelper.MinutesToHrs(Convert.ToInt32(data.PChShStartMi));
                    shiftConfigDetailsViewModel.ChShEndMi = StringHelper.MinutesToHrs(Convert.ToInt32(data.PChShEndMi));

                    shiftConfigDetailsViewModel.FullDayWorkMi = data.PFullDayWorkMi / 60;
                    shiftConfigDetailsViewModel.HalfDayWorkMi = data.PHalfDayWorkMi / 60;
                    shiftConfigDetailsViewModel.FullWeekWorkMi = data.PFullWeekWorkMi / 60;

                    shiftConfigDetailsViewModel.WorkHrsStartMi = StringHelper.MinutesToHrs(Convert.ToInt32(data.PWorkHrsStartMi));
                    shiftConfigDetailsViewModel.WorkHrsEndMi = StringHelper.MinutesToHrs(Convert.ToInt32(data.PWorkHrsEndMi));
                    shiftConfigDetailsViewModel.FirstPunchAfterMi = StringHelper.MinutesToHrs(Convert.ToInt32(data.PFirstPunchAfterMi));
                    shiftConfigDetailsViewModel.LastPunchBeforeMi = StringHelper.MinutesToHrs(Convert.ToInt32(data.PLastPunchBeforeMi));

                }

                return PartialView("_ModalShiftDetailsTab2Partial", shiftConfigDetailsViewModel);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [HttpGet]
        public async Task<IActionResult> ShiftDetailsTab3(string id)
        {
            try
            {
                if (id == null)
                {
                    return NotFound();
                }

                ShiftHalfDayDetailsViewModel shiftHalfDayDetailsViewModel = new();

                var data = await _shiftHalfDayConfigDetailRepository.ShiftHalfDayConfigDetail(BaseSpTcmPLGet(), new ParameterSpTcmPL
                {
                    PShiftcode = id
                });

                shiftHalfDayDetailsViewModel.Shiftcode = id;
                shiftHalfDayDetailsViewModel.Shiftdesc = data.PShiftDesc;

                if (data.PMessageType == IsOk)
                {

                    shiftHalfDayDetailsViewModel.HdFhStartMi = StringHelper.MinutesToHrs(Convert.ToInt32(data.PHdFhStartMi));
                    shiftHalfDayDetailsViewModel.HdFhEndMi = StringHelper.MinutesToHrs(Convert.ToInt32(data.PHdFhEndMi));
                    shiftHalfDayDetailsViewModel.HdShStartMi = StringHelper.MinutesToHrs(Convert.ToInt32(data.PHdShStartMi));
                    shiftHalfDayDetailsViewModel.HdShEndMi = StringHelper.MinutesToHrs(Convert.ToInt32(data.PHdShEndMi));

                }

                return PartialView("_ModalShiftDetailsTab3Partial", shiftHalfDayDetailsViewModel);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [HttpGet]
        public async Task<IActionResult> ShiftDetailsTab4(string id)
        {
            try
            {
                if (id == null)
                {
                    return NotFound();
                }

                ShiftLunchDetailsViewModel shiftLunchDetailsViewModel = new();

                var data = await _shiftLunchConfigDetailRepository.ShiftLunchConfigDetail(BaseSpTcmPLGet(), new ParameterSpTcmPL
                {
                    PShiftcode = id
                });

                shiftLunchDetailsViewModel.Shiftcode = id;
                shiftLunchDetailsViewModel.Shiftdesc = data.PShiftDesc;

                if (data.PMessageType == IsOk)
                {

                    shiftLunchDetailsViewModel.LunchStartMi = StringHelper.MinutesToHrs(Convert.ToInt32(data.PLunchStartMi));
                    shiftLunchDetailsViewModel.LunchEndMi = StringHelper.MinutesToHrs(Convert.ToInt32(data.PLunchEndMi));

                }

                return PartialView("_ModalShiftDetailsTab4Partial", shiftLunchDetailsViewModel);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult ShiftDetailsTab1([FromForm] ShiftDetailsViewModel shiftDetailsViewModel, string submit)
        {
            try
            {
                string redirectToAction = ShiftDetailsTabRedirectToAction(submit);
                if (!string.IsNullOrEmpty(redirectToAction) && redirectToAction != "Confirm")
                    return RedirectToAction(redirectToAction, new { id = shiftDetailsViewModel.Shiftcode });

            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
            return PartialView("_ModalShiftDetailsTab1Partial", shiftDetailsViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult ShiftDetailsTab2([FromForm] ShiftConfigDetailsViewModel shiftConfigDetailsViewModel, string submit)
        {
            try
            {
                string redirectToAction = ShiftDetailsTabRedirectToAction(submit);
                if (!string.IsNullOrEmpty(redirectToAction) && redirectToAction != "Confirm")
                    return RedirectToAction(redirectToAction, new { id = shiftConfigDetailsViewModel.Shiftcode });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
            return PartialView("_ModalShiftDetailsTab2Partial", shiftConfigDetailsViewModel);
        }


        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult ShiftDetailsTab3([FromForm] ShiftHalfDayDetailsViewModel shiftHalfDayDetailsViewModel, string submit)
        {
            try
            {
                string redirectToAction = ShiftDetailsTabRedirectToAction(submit);
                if (!string.IsNullOrEmpty(redirectToAction) && redirectToAction != "Confirm")
                    return RedirectToAction(redirectToAction, new { id = shiftHalfDayDetailsViewModel.Shiftcode });

            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
            return PartialView("_ModalShiftDetailsTab3Partial", shiftHalfDayDetailsViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult ShiftDetailsTab4([FromForm] ShiftLunchDetailsViewModel shiftLunchDetailsViewModel, string submit)
        {
            try
            {
                string redirectToAction = ShiftDetailsTabRedirectToAction(submit);
                if (!string.IsNullOrEmpty(redirectToAction) && redirectToAction != "Confirm")
                    return RedirectToAction(redirectToAction, new { id = shiftLunchDetailsViewModel.Shiftcode });

            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
            return PartialView("_ModalShiftDetailsTab4Partial", shiftLunchDetailsViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> ShiftExcelDownload()
        {
            var timeStamp = DateTime.Now.ToFileTime();

            string fileName = "Shift_" + timeStamp.ToString();
            string reportTitle = "Shift";
            string sheetName = "Shift";

            IEnumerable<ShiftMasterDataTableList> data = await _shiftDataTableListRepository.ShiftXLDataTableListForExcelAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                });

            if (data == null) { return NotFound(); }

            var json = JsonConvert.SerializeObject(data);

            IEnumerable<ShiftDataTableListExcel> excelData = JsonConvert.DeserializeObject<IEnumerable<ShiftDataTableListExcel>>(json);

            var byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, reportTitle, sheetName);

            var mimeType = MimeTypeMap.GetMimeType("xlsx");

            FileContentResult file = File(byteContent, mimeType, fileName);

            return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
        }

        [HttpGet]
        public async Task<IActionResult> ShiftEditTab1(string id)
        {
            try
            {
                if (id == null)
                {
                    return NotFound();
                }

                var result = await _shiftDetailRepository.ShiftDetail(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PShiftcode = id
                });

                ShiftDetailsUpdateViewModel shiftUpdateViewModel = new();

                if (result.PMessageType == IsOk)
                {
                    shiftUpdateViewModel.Shiftcode = id;
                    shiftUpdateViewModel.Shiftdesc = result.PShiftdesc;
                    shiftUpdateViewModel.TimeIn = result.PTimeinHh + ":" + result.PTimeinMn;
                    shiftUpdateViewModel.TimeOut = result.PTimeoutHh + ":" + result.PTimeoutMn;
                    shiftUpdateViewModel.Shift4allowance = result.PShift4allowance;
                    shiftUpdateViewModel.LunchMn = result.PLunchMn;
                    shiftUpdateViewModel.OtApplicable = result.POtApplicable;
                }

                return PartialView("_ModalShiftUpdateTab1Partial", shiftUpdateViewModel);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [HttpGet]
        public async Task<IActionResult> ShiftEditTab2(string id)
        {
            try
            {
                if (id == null)
                {
                    return NotFound();
                }

                ShiftConfigDetailsUpdateViewModel shiftConfigDetailsUpdateViewModel = new();

                var data = await _shiftConfigDetailRepository.ShiftConfigDetail(BaseSpTcmPLGet(), new ParameterSpTcmPL
                {
                    PShiftcode = id
                });

                shiftConfigDetailsUpdateViewModel.Shiftcode = id;
                shiftConfigDetailsUpdateViewModel.Shiftdesc = data.PShiftDesc;
                if (data.PMessageType == IsOk)
                {
                    shiftConfigDetailsUpdateViewModel.ChFdStartMi = StringHelper.MinutesToHrs(Convert.ToInt32(data.PChFdStartMi));
                    shiftConfigDetailsUpdateViewModel.ChFdEndMi = StringHelper.MinutesToHrs(Convert.ToInt32(data.PChFdEndMi));
                    shiftConfigDetailsUpdateViewModel.ChFhStartMi = StringHelper.MinutesToHrs(Convert.ToInt32(data.PChFhStartMi));
                    shiftConfigDetailsUpdateViewModel.ChFhEndMi = StringHelper.MinutesToHrs(Convert.ToInt32(data.PChFhEndMi));
                    shiftConfigDetailsUpdateViewModel.ChShStartMi = StringHelper.MinutesToHrs(Convert.ToInt32(data.PChShStartMi));
                    shiftConfigDetailsUpdateViewModel.ChShEndMi = StringHelper.MinutesToHrs(Convert.ToInt32(data.PChShEndMi));

                    shiftConfigDetailsUpdateViewModel.FullDayWorkMi = data.PFullDayWorkMi / 60;
                    shiftConfigDetailsUpdateViewModel.HalfDayWorkMi = data.PHalfDayWorkMi / 60;
                    shiftConfigDetailsUpdateViewModel.FullWeekWorkMi = data.PFullWeekWorkMi / 60;

                    shiftConfigDetailsUpdateViewModel.WorkHrsStartMi = StringHelper.MinutesToHrs(Convert.ToInt32(data.PWorkHrsStartMi));
                    shiftConfigDetailsUpdateViewModel.WorkHrsEndMi = StringHelper.MinutesToHrs(Convert.ToInt32(data.PWorkHrsEndMi));
                    shiftConfigDetailsUpdateViewModel.FirstPunchAfterMi = StringHelper.MinutesToHrs(Convert.ToInt32(data.PFirstPunchAfterMi));
                    shiftConfigDetailsUpdateViewModel.LastPunchBeforeMi = StringHelper.MinutesToHrs(Convert.ToInt32(data.PLastPunchBeforeMi));
                }

                return PartialView("_ModalShiftUpdateTab2Partial", shiftConfigDetailsUpdateViewModel);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [HttpGet]
        public async Task<IActionResult> ShiftEditTab3(string id)
        {
            try
            {
                if (id == null)
                {
                    return NotFound();
                }

                ShiftHalfDayDetailsUpdateViewModel shiftHalfDayDetailsUpdateViewModel = new();

                var data = await _shiftHalfDayConfigDetailRepository.ShiftHalfDayConfigDetail(BaseSpTcmPLGet(), new ParameterSpTcmPL
                {
                    PShiftcode = id
                });

                shiftHalfDayDetailsUpdateViewModel.Shiftcode = id;
                shiftHalfDayDetailsUpdateViewModel.Shiftdesc = data.PShiftDesc;

                if (data.PMessageType == IsOk)
                {

                    shiftHalfDayDetailsUpdateViewModel.HdFhStartMi = StringHelper.MinutesToHrs(Convert.ToInt32(data.PHdFhStartMi));
                    shiftHalfDayDetailsUpdateViewModel.HdFhEndMi = StringHelper.MinutesToHrs(Convert.ToInt32(data.PHdFhEndMi));
                    shiftHalfDayDetailsUpdateViewModel.HdShStartMi = StringHelper.MinutesToHrs(Convert.ToInt32(data.PHdShStartMi));
                    shiftHalfDayDetailsUpdateViewModel.HdShEndMi = StringHelper.MinutesToHrs(Convert.ToInt32(data.PHdShEndMi));

                }

                return PartialView("_ModalShiftUpdateTab3Partial", shiftHalfDayDetailsUpdateViewModel);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [HttpGet]
        public async Task<IActionResult> ShiftEditTab4(string id)
        {
            try
            {
                if (id == null)
                {
                    return NotFound();
                }

                ShiftLunchDetailsUpdateViewModel shiftLunchDetailsUpdateViewModel = new();

                var data = await _shiftLunchConfigDetailRepository.ShiftLunchConfigDetail(BaseSpTcmPLGet(), new ParameterSpTcmPL
                {
                    PShiftcode = id
                });

                shiftLunchDetailsUpdateViewModel.Shiftcode = id;
                shiftLunchDetailsUpdateViewModel.Shiftdesc = data.PShiftDesc;

                if (data.PMessageType == IsOk)
                {

                    shiftLunchDetailsUpdateViewModel.LunchStartMi = StringHelper.MinutesToHrs(Convert.ToInt32(data.PLunchStartMi));
                    shiftLunchDetailsUpdateViewModel.LunchEndMi = StringHelper.MinutesToHrs(Convert.ToInt32(data.PLunchEndMi));

                }

                return PartialView("_ModalShiftUpdateTab4Partial", shiftLunchDetailsUpdateViewModel);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ShiftEditTab1([FromForm] ShiftDetailsUpdateViewModel shiftDetailsUpdateViewModel, string submit)
        {
            try
            {
                string redirectToAction = ShiftEditTabRedirectToAction(submit);
                if (!string.IsNullOrEmpty(redirectToAction) && redirectToAction != "Confirm")
                    return RedirectToAction(redirectToAction, new { id = shiftDetailsUpdateViewModel.Shiftcode });

                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _shiftMasterRepository.ShiftDetailsEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PShiftcode = shiftDetailsUpdateViewModel.Shiftcode,
                            PShiftdesc = shiftDetailsUpdateViewModel.Shiftdesc,
                            PTimeinHh = Convert.ToInt32(shiftDetailsUpdateViewModel.TimeIn.Split(":")[0]),
                            PTimeinMn = Convert.ToInt32(shiftDetailsUpdateViewModel.TimeIn.Split(":")[1]),
                            PTimeoutHh = Convert.ToInt32(shiftDetailsUpdateViewModel.TimeOut.Split(":")[0]),
                            PTimeoutMn = Convert.ToInt32(shiftDetailsUpdateViewModel.TimeOut.Split(":")[1]),
                            PShift4allowance = shiftDetailsUpdateViewModel.Shift4allowance,
                            PLunchMn = shiftDetailsUpdateViewModel.LunchMn,
                            POtApplicable = shiftDetailsUpdateViewModel.OtApplicable
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
            return PartialView("_ModalShiftUpdateTab1Partial", shiftDetailsUpdateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ShiftEditTab2([FromForm] ShiftConfigDetailsUpdateViewModel shiftConfigDetailsUpdateViewModel, string submit)
        {
            try
            {
                string redirectToAction = ShiftEditTabRedirectToAction(submit);
                if (!string.IsNullOrEmpty(redirectToAction) && redirectToAction != "Confirm")
                    return RedirectToAction(redirectToAction, new { id = shiftConfigDetailsUpdateViewModel.Shiftcode });

                if (ModelState.IsValid)
                {
                    if (DateTime.Parse(shiftConfigDetailsUpdateViewModel.ChFdEndMi) < DateTime.Parse(shiftConfigDetailsUpdateViewModel.ChFdStartMi))
                        throw new Exception("full day start time or end time is invalid");
                    if (DateTime.Parse(shiftConfigDetailsUpdateViewModel.ChFhEndMi) < DateTime.Parse(shiftConfigDetailsUpdateViewModel.ChFhStartMi))
                        throw new Exception("First half start time or end time is invalid");
                    if (DateTime.Parse(shiftConfigDetailsUpdateViewModel.ChShEndMi) < DateTime.Parse(shiftConfigDetailsUpdateViewModel.ChShStartMi))
                        throw new Exception("Second half start time or end time is invalid");
                    if (DateTime.Parse(shiftConfigDetailsUpdateViewModel.WorkHrsEndMi) < DateTime.Parse(shiftConfigDetailsUpdateViewModel.WorkHrsStartMi))
                        throw new Exception("Working Hours start time or end time is invalid");
                    Domain.Models.Common.DBProcMessageOutput result = await _shiftMasterRepository.ShiftConfigDetailsEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PShiftcode = shiftConfigDetailsUpdateViewModel.Shiftcode,
                            PChFdStartMi = (Convert.ToInt32(shiftConfigDetailsUpdateViewModel.ChFdStartMi.Split(":")[0]) * 60) + Convert.ToInt32(shiftConfigDetailsUpdateViewModel.ChFdStartMi.Split(":")[1]),
                            PChFdEndMi = (Convert.ToInt32(shiftConfigDetailsUpdateViewModel.ChFdEndMi.Split(":")[0]) * 60) + Convert.ToInt32(shiftConfigDetailsUpdateViewModel.ChFdEndMi.Split(":")[1]),
                            PChFhStartMi = (Convert.ToInt32(shiftConfigDetailsUpdateViewModel.ChFhStartMi.Split(":")[0]) * 60) + Convert.ToInt32(shiftConfigDetailsUpdateViewModel.ChFhStartMi.Split(":")[1]),
                            PChFhEndMi = (Convert.ToInt32(shiftConfigDetailsUpdateViewModel.ChFhEndMi.Split(":")[0]) * 60) + Convert.ToInt32(shiftConfigDetailsUpdateViewModel.ChFhEndMi.Split(":")[1]),
                            PChShStartMi = (Convert.ToInt32(shiftConfigDetailsUpdateViewModel.ChShStartMi.Split(":")[0]) * 60) + Convert.ToInt32(shiftConfigDetailsUpdateViewModel.ChShStartMi.Split(":")[1]),
                            PChShEndMi = (Convert.ToInt32(shiftConfigDetailsUpdateViewModel.ChShEndMi.Split(":")[0]) * 60) + Convert.ToInt32(shiftConfigDetailsUpdateViewModel.ChShEndMi.Split(":")[1]),
                            PFullDayWorkMi = shiftConfigDetailsUpdateViewModel.FullDayWorkMi * 60,
                            PHalfDayWorkMi = shiftConfigDetailsUpdateViewModel.HalfDayWorkMi * 60,
                            PFullWeekWorkMi = shiftConfigDetailsUpdateViewModel.FullWeekWorkMi * 60,
                            PWorkHrsStartMi = (Convert.ToInt32(shiftConfigDetailsUpdateViewModel.WorkHrsStartMi.Split(":")[0]) * 60) + Convert.ToInt32(shiftConfigDetailsUpdateViewModel.WorkHrsStartMi.Split(":")[1]),
                            PWorkHrsEndMi = (Convert.ToInt32(shiftConfigDetailsUpdateViewModel.WorkHrsEndMi.Split(":")[0]) * 60) + Convert.ToInt32(shiftConfigDetailsUpdateViewModel.WorkHrsEndMi.Split(":")[1]),
                            PFirstPunchAfterMi = (Convert.ToInt32(shiftConfigDetailsUpdateViewModel.FirstPunchAfterMi.Split(":")[0]) * 60) + Convert.ToInt32(shiftConfigDetailsUpdateViewModel.FirstPunchAfterMi.Split(":")[1]),
                            PLastPunchBeforeMi = (Convert.ToInt32(shiftConfigDetailsUpdateViewModel.LastPunchBeforeMi.Split(":")[0]) * 60) + Convert.ToInt32(shiftConfigDetailsUpdateViewModel.LastPunchBeforeMi.Split(":")[1])
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
            return PartialView("_ModalShiftUpdateTab2Partial", shiftConfigDetailsUpdateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ShiftEditTab3([FromForm] ShiftHalfDayDetailsUpdateViewModel shiftHalfDayDetailsUpdateViewModel, string submit)
        {
            try
            {
                string redirectToAction = ShiftEditTabRedirectToAction(submit);
                if (!string.IsNullOrEmpty(redirectToAction) && redirectToAction != "Confirm")
                    return RedirectToAction(redirectToAction, new { id = shiftHalfDayDetailsUpdateViewModel.Shiftcode });

                if (ModelState.IsValid)
                {
                    if (DateTime.Parse(shiftHalfDayDetailsUpdateViewModel.HdFhEndMi) < DateTime.Parse(shiftHalfDayDetailsUpdateViewModel.HdFhStartMi))
                        throw new Exception("First half start time or end time is invalid");
                    if (DateTime.Parse(shiftHalfDayDetailsUpdateViewModel.HdShEndMi) < DateTime.Parse(shiftHalfDayDetailsUpdateViewModel.HdShStartMi))
                        throw new Exception("Second half start time or end time is invalid");

                    Domain.Models.Common.DBProcMessageOutput result = await _shiftMasterRepository.ShiftHalfDayConfigDetailsEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PShiftcode = shiftHalfDayDetailsUpdateViewModel.Shiftcode,
                            PHdFhStartMi = (Convert.ToInt32(shiftHalfDayDetailsUpdateViewModel.HdFhStartMi.Split(":")[0]) * 60) + Convert.ToInt32(shiftHalfDayDetailsUpdateViewModel.HdFhStartMi.Split(":")[1]),
                            PHdFhEndMi = (Convert.ToInt32(shiftHalfDayDetailsUpdateViewModel.HdFhEndMi.Split(":")[0]) * 60) + Convert.ToInt32(shiftHalfDayDetailsUpdateViewModel.HdFhEndMi.Split(":")[1]),
                            PHdShStartMi = (Convert.ToInt32(shiftHalfDayDetailsUpdateViewModel.HdShStartMi.Split(":")[0]) * 60) + Convert.ToInt32(shiftHalfDayDetailsUpdateViewModel.HdShStartMi.Split(":")[1]),
                            PHdShEndMi = (Convert.ToInt32(shiftHalfDayDetailsUpdateViewModel.HdShEndMi.Split(":")[0]) * 60) + Convert.ToInt32(shiftHalfDayDetailsUpdateViewModel.HdShEndMi.Split(":")[1]),

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
            return PartialView("_ModalShiftUpdateTab3Partial", shiftHalfDayDetailsUpdateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ShiftEditTab4([FromForm] ShiftLunchDetailsUpdateViewModel shiftLunchDetailsUpdateViewModel, string submit)
        {
            try
            {
                string redirectToAction = ShiftEditTabRedirectToAction(submit);
                if (!string.IsNullOrEmpty(redirectToAction) && redirectToAction != "Confirm")
                    return RedirectToAction(redirectToAction, new { id = shiftLunchDetailsUpdateViewModel.Shiftcode });

                if (ModelState.IsValid)
                {
                    if (DateTime.Parse(shiftLunchDetailsUpdateViewModel.LunchEndMi) < DateTime.Parse(shiftLunchDetailsUpdateViewModel.LunchStartMi))
                        throw new Exception("Lunch end time is invalid");

                    Domain.Models.Common.DBProcMessageOutput result = await _shiftMasterRepository.ShiftLunchConfigDetailsEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PShiftcode = shiftLunchDetailsUpdateViewModel.Shiftcode,
                            PLunchStartMi = (Convert.ToInt32(shiftLunchDetailsUpdateViewModel.LunchStartMi.Split(":")[0]) * 60) + Convert.ToInt32(shiftLunchDetailsUpdateViewModel.LunchStartMi.Split(":")[1]),
                            PLunchEndMi = (Convert.ToInt32(shiftLunchDetailsUpdateViewModel.LunchEndMi.Split(":")[0]) * 60) + Convert.ToInt32(shiftLunchDetailsUpdateViewModel.LunchEndMi.Split(":")[1]),

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
            return PartialView("_ModalShiftUpdateTab4Partial", shiftLunchDetailsUpdateViewModel);
        }

        private string ShiftEditTabRedirectToAction(string submit)
        {
            if (submit == "Details1")
            {
                return ("ShiftEditTab1");
            }
            if (submit == "Details2")
            {
                return ("ShiftEditTab2");
            }
            if (submit == "Details3")
            {
                return ("ShiftEditTab3");
            }
            if (submit == "Details4")
            {
                return ("ShiftEditTab4");
            }

            return string.Empty;
        }

        private string ShiftDetailsTabRedirectToAction(string submit)
        {
            if (submit == "Details1")
            {
                return ("ShiftDetailsTab1");
            }
            if (submit == "Details2")
            {
                return ("ShiftDetailsTab2");
            }
            if (submit == "Details3")
            {
                return ("ShiftDetailsTab3");
            }
            if (submit == "Details4")
            {
                return ("ShiftDetailsTab4");
            }
            return string.Empty;
        }

        #endregion ShiftMaster

        private string[] ApprovalsNRemarksToArray(ApprovalRemarks[] apprlRemarks, ApprovalApprlVals[] approvalApprlVals)
        {
            List<string> listresultObj = new List<string>();

            string[] remarksResult = apprlRemarks.Select(o => o.appId + "," + o.remarkVal).ToArray();
            string[] apprlValResult = approvalApprlVals.Select(o => o.appId + "," + o.apprlVal).ToArray();

            if (approvalApprlVals != null)
            {
                for (int i = 0; i < approvalApprlVals.Length; i++)
                {
                    string temp1 = approvalApprlVals[i].appId;
                    string temp2 = apprlRemarks[i].appId;
                    string temp3 = "";

                    if (temp1 == temp2)
                    {
                        temp3 = $"{approvalApprlVals[i].appId}~!~{approvalApprlVals[i].apprlVal}~!~{apprlRemarks[i].remarkVal}";

                        listresultObj.Add(temp3);
                    }
                }
            }

            return listresultObj.ToArray();
        }

        private string[] ApprovalsToArray(ApprovalApprlVals[] approvalApprlVals)
        {
            List<string> listresultObj = new List<string>();

            string[] apprlValResult = approvalApprlVals.Select(o => o.appId + "," + o.apprlVal).ToArray();

            if (approvalApprlVals != null)
            {
                for (int i = 0; i < approvalApprlVals.Length; i++)
                {
                    string temp1 = approvalApprlVals[i].appId;

                    string temp3 = "";

                    temp3 = $"{approvalApprlVals[i].appId}~!~{approvalApprlVals[i].apprlVal}";

                    listresultObj.Add(temp3);
                }
            }

            return listresultObj.ToArray();
        }

        #region LoPForExcessLeaveIndex

        public async Task<IActionResult> LopForExcessLeaveIndex()
        {
            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterLopForExcessLeaveIndex
            });
            FilterDataModel filterDataModel = new FilterDataModel();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            LoPForExcessLeaveViewModel loPForExcessLeaveViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            if (filterDataModel.Yyyymm == null)
            {
                var result = await _loPLastSalaryMonthDetailsRepository.LoPLastSalaryMonthDetailsAsync(BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                    });

                filterDataModel.Yyyymm = result.PYyyymm;
            }
            var data = await _loPLastSalaryMonthStatusRepository.LoPLastSalaryMonthStatusAsync(BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PYyyymm = filterDataModel.Yyyymm
                        });

            filterDataModel.SalaryMonthStatus = data.PStatus;
            ViewData["SalaryMonthStatus"] = filterDataModel.SalaryMonthStatus;
            return View(loPForExcessLeaveViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsLoPForExcessLeave(string paramJson)
        {
            DTResult<LoPForExcessLeaveDataTableList> result = new();
            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            int totalRow = 0;

            try
            {
                var data = await _loPForExcessLeaveDataTableListRepository.LoPForExcessLeaveDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch ?? " ",
                        PYyyymm = param.Yyyymm,
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

        public async Task<IActionResult> LoPForExcessLeaveFilterGet()
        {
            var retVal = await RetriveFilter(ConstFilterLopForExcessLeaveIndex);

            FilterDataModel filterDataModel = new FilterDataModel();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }
            if (filterDataModel.Yyyymm != null)
                filterDataModel.PayslipYyyymm = DateTime.ParseExact(filterDataModel.Yyyymm, "yyyyMM", null);
            return PartialView("_ModalLoPForExcessLeaveFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> LoPForExcessLeaveFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                string jsonFilter;
                jsonFilter = JsonConvert.SerializeObject(
                        new
                        {
                            filterDataModel.Yyyymm,
                        });

                _ = await CreateFilter(jsonFilter, ConstFilterLopForExcessLeaveIndex);

                return Json(new
                {
                    success = true,
                    yyyymm = filterDataModel.Yyyymm,
                });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        public IActionResult LoPForExcessLeaveXLUpload()
        {
            LopForExcessLeaveUploadViewModel lopForExcessLeaveUploadViewModel = new();
            return PartialView("_ModalLoPForExcessLeaveUploadPartial", lopForExcessLeaveUploadViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> LoPForExcessLeaveXLUpload(LopForExcessLeaveUploadViewModel lopForExcessLeaveUploadViewModel)
        {
            try
            {
                if (lopForExcessLeaveUploadViewModel.file == null || lopForExcessLeaveUploadViewModel.file.Length == 0)
                    return Json(new { success = false, response = "File not uploaded due to an error" });

                FileInfo fileInfo = new FileInfo(lopForExcessLeaveUploadViewModel.file.FileName);

                Guid storageId = Guid.NewGuid();
                var stream = lopForExcessLeaveUploadViewModel.file.OpenReadStream();
                var fileName = lopForExcessLeaveUploadViewModel.file.FileName;
                var fileSize = lopForExcessLeaveUploadViewModel.file.Length;
                var mimeType = MimeTypeMap.GetMimeType(fileInfo.Extension);
                string fileNameErrors = Path.GetFileNameWithoutExtension(fileInfo.Name) + "-Err" + fileInfo.Extension;

                // Check file validation
                if (!fileInfo.Extension.Contains("xls"))
                    return Json(new { success = false, response = "Excel file not recognized" });

                // Try to convert stream to a class

                //string json = string.Empty;
                string jsonString = string.Empty;
                // Call database json stored procedure

                List<Library.Excel.Template.Models.LopForExcessLeave> LopExcessLeave = _excelTemplate.ImportLopForExcessLeave(stream);

                var jsondata = Newtonsoft.Json.JsonConvert.SerializeObject(LopExcessLeave);
                byte[] byteArray = Encoding.ASCII.GetBytes(jsondata);

                var uploadOutPut = await _loPForExcessLeaveImportRepository.ImportLopForExcessLeaveAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PPayslipYyyymm = lopForExcessLeaveUploadViewModel.PaySlipMonth,
                            PAdjType = lopForExcessLeaveUploadViewModel.LopType,
                            PLopJson = byteArray
                        }
                    );
                var LopErrors = JsonConvert.SerializeObject(uploadOutPut.PLopErrors);
                ImportFileResultViewModel importFileResult = new();
                IEnumerable<ImportFileResultViewModel> importFileResults = JsonConvert.DeserializeObject<IEnumerable<ImportFileResultViewModel>>(LopErrors);

                List<Library.Excel.Template.Models.ValidationItem> validationItems = new List<Library.Excel.Template.Models.ValidationItem>();

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

                if (uploadOutPut.PMessageType != IsOk)
                {
                    if (importFileResults.Count() > 0)
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

        public IActionResult LoPForExcessLeaveXLTemplate()
        {
            var dictionaryItems = new List<Library.Excel.Template.Models.DictionaryItem>();

            Stream ms = _excelTemplate.ExportLopForExcessLeave("v01",
            new Library.Excel.Template.Models.DictionaryCollection
            {
                DictionaryItems = dictionaryItems
            },
            500);
            var fileName = "ImportLoPForExcessLeave.xlsx";
            var mimeType = MimeTypeMap.GetMimeType("xlsx");

            ms.Position = 0;
            return File(ms, mimeType, fileName);
        }

        public async Task<IActionResult> LoPForExcessLeaveRollBack(string id)
        {
            try
            {
                var result = await _loPForExcessLeaveRepository.DeleteLoPForExcessLeaveAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL { PAppNo = id }
                    );

                return Json(new { success = result.PMessageType == IsOk, response = result.PMessageType, message = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        public async Task<IActionResult> RollBackLoPForExcessLeave(string id)
        {
            try
            {
                var result = await _loPForExcessLeaveRepository.RollbackLoPForExcessLeaveAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL { PYyyymm = id }
                    );

                return Json(new { success = result.PMessageType == IsOk, response = result.PMessageType, message = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        #endregion LoPForExcessLeaveIndex

        #region PrintLogs

        // [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SelfServiceHelper.RoleManagerHoD)]
        public async Task<IActionResult> PrintLogIndex()
        {
            PrintLogsViewModel printLogsViewModel = new PrintLogsViewModel();
            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterPrintLog
            });
            FilterDataModel filterDataModel = new FilterDataModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }
            printLogsViewModel.FilterDataModel = filterDataModel;
            return View(printLogsViewModel);
        }

        public async Task<IActionResult> PrintLogFilterGet()
        {
            var empdetails = await _attendanceEmployeeDetailsRepository.AttendanceEmployeeDetailsAsync(BaseSpTcmPLGet(),
               new ParameterSpTcmPL
               {
               }
           );
            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterPrintLog
            });
            FilterDataModel filterDataModel = new FilterDataModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }
            if (string.IsNullOrEmpty(filterDataModel.Empno))
                filterDataModel.Empno = empdetails.Empno;

            //This for Lead / Hod / Hr
            if (CurrentUserIdentity.ProfileActions.Any(pa => pa.RoleId == SelfServiceHelper.RoleManagerHoDOnBeHalf))
            {
                var empList = await _selectTcmPLRepository.EmployeeListForMngrHodOnBeHalfAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());
                ViewData["EmpList"] = new SelectList(empList, "DataValueField", "DataTextField", empdetails.Empno);
            }
            else if (CurrentUserIdentity.ProfileActions.Any(pa => pa.RoleId == SelfServiceHelper.RoleManagerHoD))
            {
                var empList = await _selectTcmPLRepository.EmployeeListForMngrHodAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());
                ViewData["EmpList"] = new SelectList(empList, "DataValueField", "DataTextField", empdetails.Empno);
            }

            return PartialView("_ModalPrintLogFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> PrintLogFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                if (filterDataModel.StartDate != null || filterDataModel.EndDate != null)
                {
                    if (filterDataModel.StartDate == null || filterDataModel.EndDate == null)
                        throw new Exception("Both the dates are reqired.");
                    else if (filterDataModel.StartDate?.ToString("yyyy") != filterDataModel.EndDate?.ToString("yyyy"))
                        throw new Exception("Date range should be with in same year.");
                    else if (filterDataModel.StartDate > filterDataModel.EndDate)
                        throw new Exception("End date should be greater than start date");
                }
                {
                    string jsonFilter;
                    jsonFilter = JsonConvert.SerializeObject(
                            new
                            {
                                StartDate = filterDataModel.StartDate,
                                EndDate = filterDataModel.EndDate,
                                Empno = filterDataModel.Empno
                            }
                            );

                    var retVal = await _filterRepository.FilterCreateAsync(new Domain.Models.FilterCreate
                    {
                        PModuleName = CurrentUserIdentity.CurrentModule,
                        PMetaId = CurrentUserIdentity.MetaId,
                        PPersonId = CurrentUserIdentity.EmployeeId,
                        PMvcActionName = ConstFilterPrintLog,
                        PFilterJson = jsonFilter
                    });

                    return Json(new
                    {
                        success = true,
                        leaveType = filterDataModel.LeaveType,
                        empno = filterDataModel.Empno,
                        startDate = filterDataModel.StartDate,
                        endDate = filterDataModel.EndDate
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
        public async Task<JsonResult> GetListsPrintLogs(DTParameters param)
        {
            DTResult<PrintLogDetailedListDataTableList> result = new DTResult<PrintLogDetailedListDataTableList>();
            int totalRow = 0;

            try
            {
                var data = await _attendancePrintLogDataTableListRepository.PrintLogDetailedList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
                        PStartDate = param.StartDate,
                        PEndDate = param.EndDate,
                        PEmpno = param.Empno
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

        public async Task<JsonResult> GetListsPrintLogsHeader(DTParameters param)
        {
            var empdetails = await _attendanceEmployeeDetailsRepository.AttendanceEmployeeDetailsAsync(BaseSpTcmPLGet(),
                               new ParameterSpTcmPL
                               {
                                   PEmpno = param.Empno
                               }
                               );
            return Json(new { empno = empdetails.Empno, employeeName = empdetails.Name });
        }

        #endregion PrintLogs

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

        private async Task<Domain.Models.FilterCreate> CreateFilter(string jsonFilter, string ActionName)
        {
            var retVal = await _filterRepository.FilterCreateAsync(new Domain.Models.FilterCreate
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
            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ActionName
            });
            return retVal;
        }

        private async Task<SelectList> getEmployeeSelectList(string Empno)
        {
            if (CurrentUserIdentity.ProfileActions.Any(pa => pa.RoleId == SelfServiceHelper.RoleAttendanceAdmin))
            {
                var empList = await _selectTcmPLRepository.EmployeeListForHRAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());
                return new SelectList(empList, "DataValueField", "DataTextField", Empno);
            }

            if (CurrentUserIdentity.ProfileActions.Any(pa => pa.RoleId == SelfServiceHelper.RoleManagerHoDOnBeHalf))
            {
                var empList = await _selectTcmPLRepository.EmployeeListForMngrHodOnBeHalfAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());
                return new SelectList(empList, "DataValueField", "DataTextField", Empno);
            }
            if (CurrentUserIdentity.ProfileActions.Any(pa => pa.RoleId == SelfServiceHelper.RoleManagerHoD))
            {
                var empList = await _selectTcmPLRepository.EmployeeListForMngrHodAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());
                return new SelectList(empList, "DataValueField", "DataTextField", Empno);
            }

            if (CurrentUserIdentity.ProfileActions.Any(pa => pa.RoleId == SelfServiceHelper.RoleSecretary))
            {
                var empList = await _selectTcmPLRepository.EmployeeListForSecretary(BaseSpTcmPLGet(), new ParameterSpTcmPL());
                return new SelectList(empList, "DataValueField", "DataTextField", Empno);
            }
            else
                return new SelectList(new List<DataField>());
        }

        #region XL Reports

        [HttpGet]
        public IActionResult XLReportLeavesAvailed()
        {
            FilterDataModel filterDataModel = new FilterDataModel();

            return PartialView("_ModalLeavesAvailedExcelPartial", filterDataModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> XLReportLeavesAvailed(DateTime startDate)
        {
            try
            {
                string yyyy = startDate.ToString("yyyy");
                DateTime endDate = new DateTime(startDate.Year, 12, 31);

                var result = await _attendanceLeavesAvailedDataTableListRepository.LeavesAvailed(BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PYyyy = yyyy
                    }
                );

                if (!result.Any())
                {
                    return StatusCode((int)HttpStatusCode.InternalServerError, "No data exists");
                }
                else
                {
                    //var json = JsonConvert.SerializeObject(result);

                    //IEnumerable<NonSWSEmpAtHomeExcelModel> excelData = JsonConvert.DeserializeObject<IEnumerable<NonSWSEmpAtHomeExcelModel>>(json);

                    string stringFileName = "LeavesAvailed_" + startDate.ToString("yyyy") + ".xlsx";

                    string reportTitle = "Details of leave taken from " + startDate.ToString("dd-MMM-yyyy") + " to " + endDate.ToString("dd-MMM-yyyy");

                    var byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(result, reportTitle, "Data");

                    return File(byteContent,
                                "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                                stringFileName + ".xlsx");
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> XLReportLeavesAvailedTemp(string yyyy)
        {
            try
            {
                //string yyyy = startDate.ToString("yyyy");
                //DateTime endDate = new DateTime(startDate.Year, 12, 31);

                var result = await _attendanceLeavesAvailedDataTableListRepository.LeavesAvailed(BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PYyyy = yyyy
                    }
                );

                if (!result.Any())
                {
                    return StatusCode((int)HttpStatusCode.InternalServerError, "No data exists");
                }
                else
                {
                    return Json(ResponseHelper.GetMessageObject("Successfully execute procedure"));

                    //string stringFileName = "LeavesAvailed_" + startDate.ToString("yyyy") + ".xlsx";

                    //string reportTitle = "Details of leave taken from " + startDate.ToString("dd-MMM-yyyy") + " to " + endDate.ToString("dd-MMM-yyyy");

                    //var byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(result, reportTitle, "Data");

                    //var file = File(byteContent,
                    //            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                    //            stringFileName + ".xlsx");
                    //return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> XLReportLeavesAvailedTemp1()
        {
            try
            {
                DateTime startDate = DateTime.Now;
                string yyyy = startDate.ToString("yyyy");
                DateTime endDate = new DateTime(startDate.Year, 12, 31);

                var result = await _attendanceLeavesAvailedDataTableListRepository.LeavesAvailed(BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PYyyy = yyyy
                    }
                );

                if (!result.Any())
                {
                    return StatusCode((int)HttpStatusCode.InternalServerError, "No data exists");
                }
                else
                {
                    //var json = JsonConvert.SerializeObject(result);

                    //IEnumerable<NonSWSEmpAtHomeExcelModel> excelData = JsonConvert.DeserializeObject<IEnumerable<NonSWSEmpAtHomeExcelModel>>(json);

                    string stringFileName = "LeavesAvailed_" + startDate.ToString("yyyy") + ".xlsx";

                    string reportTitle = "Details of leave taken from " + startDate.ToString("dd-MMM-yyyy") + " to " + endDate.ToString("dd-MMM-yyyy");

                    var byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(result, reportTitle, "Data");

                    var file = File(byteContent,
                                "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                                stringFileName + ".xlsx");
                    return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
                }
            }
            catch (Exception ex)
            {
                throw new CustomJsonException("Error occured while executing request", ex);
            }
        }

        #endregion XL Reports

        #region Execute Action Procedures

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SelfServiceHelper.ActionViewHRReportsGeneral)]
        public async Task<IActionResult> LeaveApprovalRollbackLead(string applicationId)
        {
            if (String.IsNullOrEmpty(applicationId))
            {
                return Json(ResponseHelper.GetMessageObject("Application Id not provided. Cannot proceed.", NotificationType.error));
            }
            try
            {
                var result = await _attendanceActionsExecutor.LeaveApprovalRollbackLead(BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PApplicationId = applicationId.Trim()
                    }
                );

                return Json(ResponseHelper.GetMessageObject(result.PMessageText, result.PMessageType == BaseController.IsOk ? NotificationType.success : NotificationType.error));
            }
            catch (Exception ex)
            {
                throw new CustomJsonException(ex.Message, ex);
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SelfServiceHelper.ActionViewHRReportsGeneral)]
        public async Task<IActionResult> LeaveRejectionRollbackLead(string applicationId)
        {
            if (String.IsNullOrEmpty(applicationId))
            {
                return Json(ResponseHelper.GetMessageObject("Application Id not provided. Cannot proceed.", NotificationType.error));
            }
            try
            {
                var result = await _attendanceActionsExecutor.LeaveRejectionRollbackLead(BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PApplicationId = applicationId.Trim()
                    }
                );

                return Json(ResponseHelper.GetMessageObject(result.PMessageText, result.PMessageType == BaseController.IsOk ? NotificationType.success : NotificationType.error));
            }
            catch (Exception ex)
            {
                throw new CustomJsonException(ex.Message, ex);
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SelfServiceHelper.ActionViewHRReportsGeneral)]
        public async Task<IActionResult> LeaveApprovalRollbackHoD(string applicationId)
        {
            if (String.IsNullOrEmpty(applicationId))
            {
                return Json(ResponseHelper.GetMessageObject("Application Id not provided. Cannot proceed.", NotificationType.error));
            }
            try
            {
                var result = await _attendanceActionsExecutor.LeaveApprovalRollbackHoD(BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PApplicationId = applicationId.Trim()
                    }
                );
                return Json(ResponseHelper.GetMessageObject(result.PMessageText, result.PMessageType == BaseController.IsOk ? NotificationType.success : NotificationType.error));
            }
            catch (Exception ex)
            {
                throw new CustomJsonException(ex.Message, ex);
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SelfServiceHelper.ActionViewHRReportsGeneral)]
        public async Task<IActionResult> LeaveRejectionRollbackHoD(string applicationId)
        {
            if (String.IsNullOrEmpty(applicationId))
            {
                return Json(ResponseHelper.GetMessageObject("Application Id not provided. Cannot proceed.", NotificationType.error));
            }
            try
            {
                var result = await _attendanceActionsExecutor.LeaveRejectionRollbackHoD(BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PApplicationId = applicationId.Trim()
                    }
                );

                return Json(ResponseHelper.GetMessageObject(result.PMessageText, result.PMessageType == BaseController.IsOk ? NotificationType.success : NotificationType.error));
            }
            catch (Exception ex)
            {
                throw new CustomJsonException(ex.Message, ex);
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SelfServiceHelper.ActionViewHRReportsGeneral)]
        public async Task<IActionResult> LeaveApprovalRollbackHR(string applicationId)
        {
            if (String.IsNullOrEmpty(applicationId))
            {
                return Json(ResponseHelper.GetMessageObject("Application Id not provided. Cannot proceed.", NotificationType.error));
            }
            try
            {
                var result = await _attendanceActionsExecutor.LeaveApprovalRollbackHR(BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PApplicationId = applicationId.Trim()
                    }
                );

                return Json(ResponseHelper.GetMessageObject(result.PMessageText, result.PMessageType == BaseController.IsOk ? NotificationType.success : NotificationType.error));
            }
            catch (Exception ex)
            {
                throw new CustomJsonException(ex.Message, ex);
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SelfServiceHelper.ActionViewHRReportsGeneral)]
        public async Task<IActionResult> OnDutyApprovalRollback(string applicationId, string approvalFrom)
        {
            if (String.IsNullOrEmpty(applicationId) || String.IsNullOrEmpty(approvalFrom))
            {
                return Json(ResponseHelper.GetMessageObject("Application Id or approval not provided. Cannot proceed.", NotificationType.error));
            }
            try
            {
                var result = await _attendanceActionsExecutor.OndutyApprovalRollback(BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PApplicationId = applicationId.Trim(),
                        PApprovalFrom = approvalFrom
                    }
                );
                return Json(ResponseHelper.GetMessageObject(result.PMessageText, result.PMessageType == BaseController.IsOk ? NotificationType.success : NotificationType.error));
            }
            catch (Exception ex)
            {
                throw new CustomJsonException(ex.Message, ex);
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SelfServiceHelper.ActionViewHRReportsGeneral)]
        public async Task<IActionResult> ExtraHoursRejectionRollbackHR(string applicationId)
        {
            if (String.IsNullOrEmpty(applicationId))
            {
                return Json(ResponseHelper.GetMessageObject("Application Id not provided. Cannot proceed.", NotificationType.error));
            }
            try
            {
                var result = await _attendanceActionsExecutor.ExtraHoursRejectionRollbackHR(BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PApplicationId = applicationId.Trim()
                    }
                );

                return Json(ResponseHelper.GetMessageObject(result.PMessageText, result.PMessageType == IsOk ? NotificationType.success : NotificationType.error));
            }
            catch (Exception ex)
            {
                throw new CustomJsonException(ex.Message, ex);
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SelfServiceHelper.ActionViewHRReportsGeneral)]
        public async Task<IActionResult> LeaveRejectionRollbackHR(string applicationId)
        {
            if (String.IsNullOrEmpty(applicationId))
            {
                return Json(ResponseHelper.GetMessageObject("Application Id not provided. Cannot proceed.", NotificationType.error));
            }
            try
            {
                var result = await _attendanceActionsExecutor.LeaveRejectionRollbackHR(BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PApplicationId = applicationId.Trim()
                    }
                );

                return Json(ResponseHelper.GetMessageObject(result.PMessageText, result.PMessageType == BaseController.IsOk ? NotificationType.success : NotificationType.error));
            }
            catch (Exception ex)
            {
                throw new CustomJsonException(ex.Message, ex);
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SelfServiceHelper.ActionViewHRReportsGeneral)]
        public async Task<IActionResult> LeaveReportPenaltyLeave(string fromMonth, string toMonth)
        {
            string fromYyyymm = fromMonth.Replace("-", "");
            string toYyyymm = toMonth.Replace("-", "");
            if (Convert.ToInt32(fromYyyymm) > Convert.ToInt32(toYyyymm))
            {
                return Json(ResponseHelper.GetMessageObject("To Month is bigger than from date", NotificationType.error));
            }
            try
            {
                var result = await _attendanceActionsExecuteReport.LeaveReportPenaltyLeave(BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PFromYyyymm = fromYyyymm,
                        PToYyyymm = toYyyymm
                    }
                );
                if (result.Rows.Count == 0)
                {
                    return Json(ResponseHelper.GetMessageObject("No Data Found.", NotificationType.error));
                }
                string stringFileName = "PenaltyLeave_" + fromMonth + ".xlsx";

                string reportTitle = "Details of Penalty Leave from " + fromMonth + " to " + toMonth;

                foreach (System.Data.DataColumn col in result.Columns)
                {
                    col.ColumnName = StringHelper.TitleCase(col.ColumnName.ToLower().Replace("_", " ")).Replace(" ", "");
                }

                var byteContent = _utilityRepository.ExcelDownloadFromDataTable(result, reportTitle, stringFileName);

                var file = File(byteContent,
                            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                            stringFileName + ".xlsx");

                return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
            }
            catch (Exception ex)
            {
                throw new CustomJsonException(ex.Message, ex);
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SelfServiceHelper.ActionViewHRReportsGeneral)]
        public async Task<IActionResult> LeaveReportLwpReport(string month)
        {
            string Yyyymm = month.Replace("-", "");
            try
            {
                var result = await _attendanceActionsExecuteReport.LeaveReportLwpReport(BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PYyyymm = Yyyymm
                    }
                );
                if (result.Rows.Count == 0)
                {
                    return Json(ResponseHelper.GetMessageObject("No Data Found.", NotificationType.error));
                }
                string stringFileName = "LwpReport_" + month + ".xlsx";

                string reportTitle = "Lwp Report of " + month;

                foreach (System.Data.DataColumn col in result.Columns)
                {
                    col.ColumnName = StringHelper.TitleCase(col.ColumnName.ToLower().Replace("_", " ")).Replace(" ", "");
                }

                var byteContent = _utilityRepository.ExcelDownloadFromDataTable(result, reportTitle, stringFileName);

                var file = File(byteContent,
                            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                            stringFileName + ".xlsx");

                return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
            }
            catch (Exception ex)
            {
                throw new CustomJsonException(ex.Message, ex);
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SelfServiceHelper.ActionViewHRReportsGeneral)]
        public async Task<IActionResult> LeaveReportExcessPLLapseReport(DateTime startDate, DateTime endDate)
        {
            try
            {
                if (startDate > endDate)
                    return Json(ResponseHelper.GetMessageObject("End date should be greater than start date", NotificationType.error));

                var result = await _attendanceActionsExecuteReport.LeaveReportExcessPLLapseReport(BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PStartDate = startDate,
                        PEndDate = endDate
                    }
                );
                if (result.Rows.Count == 0)
                {
                    return Json(ResponseHelper.GetMessageObject("No Data Found.", NotificationType.error));
                }
                string stringFileName = "ExcessPLLapseReport_.xlsx";

                string reportTitle = "Excess PL Lapse Report of " + startDate.ToString("dd-MMM-yyyy") + " to " + endDate.ToString("dd-MMM-yyyy");

                foreach (System.Data.DataColumn col in result.Columns)
                {
                    col.ColumnName = StringHelper.TitleCase(col.ColumnName.ToLower().Replace("_", " ")).Replace(" ", "");
                }

                var byteContent = _utilityRepository.ExcelDownloadFromDataTable(result, reportTitle, stringFileName);

                var file = File(byteContent,
                            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                            stringFileName + ".xlsx");

                return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
            }
            catch (Exception ex)
            {
                throw new CustomJsonException(ex.Message, ex);
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SelfServiceHelper.ActionViewHRReportsGeneral)]
        public async Task<IActionResult> LeaveReportSickLeaveReport(DateTime startDate, DateTime endDate)
        {
            try
            {
                if (startDate > endDate)
                    return Json(ResponseHelper.GetMessageObject("End date should be greater than start date", NotificationType.error));

                var result = await _attendanceActionsExecuteReport.LeaveReportSickLeaveReport(BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PStartDate = startDate,
                        PEndDate = endDate
                    }
                );
                if (result.Rows.Count == 0)
                {
                    return Json(ResponseHelper.GetMessageObject("No Data Found.", NotificationType.error));
                }
                string stringFileName = "SLReport_" + startDate.ToString("dd-MMM-yyyy") + ".xlsx";

                string reportTitle = "Sick Leave Report of " + startDate.ToString("dd-MMM-yy") + " to " + endDate.ToString("dd-MMM-yy");

                foreach (System.Data.DataColumn col in result.Columns)
                {
                    col.ColumnName = StringHelper.TitleCase(col.ColumnName.ToLower().Replace("_", " ")).Replace(" ", "");
                }

                var byteContent = _utilityRepository.ExcelDownloadFromDataTable(result, reportTitle, stringFileName);

                var file = File(byteContent,
                            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                            stringFileName + ".xlsx");

                return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
            }
            catch (Exception ex)
            {
                throw new CustomJsonException(ex.Message, ex);
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SelfServiceHelper.ActionViewHRReportsGeneral)]
        public async Task<IActionResult> HalfDayLeaveApplicationListReport(string month)
        {
            string selectedDate = month + "-01";

            DateTime startDate = DateTime.ParseExact(selectedDate, "yyyy-MM-dd", CultureInfo.InvariantCulture);
            DateTime endDate = (startDate.AddMonths(1)).AddDays(-1);
            try
            {
                var result = await _attendanceActionsExecuteReport.HalfDayLeaveApplicationReport(BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PStartDate = startDate,
                        PEndDate = endDate
                    }
                );
                if (result.Rows.Count == 0)
                {
                    return Json(ResponseHelper.GetMessageObject("No Data Found.", NotificationType.error));
                }
                string stringFileName = "HalfDayLeaveApplicationReport_" + month + ".xlsx";

                string reportTitle = "HalfDay Leave Application Report of " + month;

                foreach (System.Data.DataColumn col in result.Columns)
                {
                    col.ColumnName = StringHelper.TitleCase(col.ColumnName.ToLower().Replace("_", " ")).Replace(" ", "");
                }

                var byteContent = _utilityRepository.ExcelDownloadFromDataTable(result, reportTitle, "Data");

                var file = File(byteContent,
                            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                            stringFileName + ".xlsx");

                return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
            }
            catch (Exception ex)
            {
                throw new CustomJsonException(ex.Message, ex);
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SelfServiceHelper.ActionViewHRReportsGeneral)]
        public async Task<IActionResult> LeaveApplicationListReport(string month, int totalMonth)
        {
            if (!(totalMonth >= 1 && totalMonth <= 3))
            {
                return Json(ResponseHelper.GetMessageObject("Number of months should be between 1 and 3.", NotificationType.error));
            }
            try
            {
                string selectedDate = month + "-01";

                DateTime startDate = DateTime.ParseExact(selectedDate, "yyyy-MM-dd", CultureInfo.InvariantCulture);
                DateTime endDate = startDate.AddMonths(totalMonth).AddDays(-1);
                var leaveApplicationsPending = await _attendanceActionsExecuteReport.LeaveApplicationsPending(BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PStartDate = startDate,
                        PEndDate = endDate
                    }
                );
                var leaveApplicationsApproved = await _attendanceActionsExecuteReport.LeaveApplicationsApproved(BaseSpTcmPLGet(),
               new ParameterSpTcmPL
               {
                   PStartDate = startDate,
                   PEndDate = endDate
               }
           );
                if (leaveApplicationsPending.Rows.Count == 0 && leaveApplicationsApproved.Rows.Count == 0)
                {
                    return Json(ResponseHelper.GetMessageObject("No Data Found.", NotificationType.error));
                }
                string stringFileName = "LeaveApplicationList_" + month + ".xlsx";

                string reportTitle = "Leave Application List of " + month;

                foreach (System.Data.DataColumn col in leaveApplicationsPending.Columns)
                {
                    col.ColumnName = StringHelper.TitleCase(col.ColumnName.ToLower().Replace("_", " ")).Replace(" ", "");
                }
                List<ExcelSheetAttributes> excelSheetAttributes = new List<ExcelSheetAttributes>();
                excelSheetAttributes.Add(new ExcelSheetAttributes { SheetData = leaveApplicationsPending, SheetName = "Pending", SheetReportTitle = "Pending " + reportTitle });
                excelSheetAttributes.Add(new ExcelSheetAttributes { SheetData = leaveApplicationsApproved, SheetName = "Approved", SheetReportTitle = "Approved " + reportTitle });

                var byteContent = _utilityRepository.ExcelDownloadWithMultipleSheets(excelSheetAttributes);

                var file = File(byteContent,
                            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                            stringFileName + ".xlsx");

                return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
            }
            catch (Exception ex)
            {
                throw new CustomJsonException(ex.Message, ex);
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, SelfServiceHelper.ActionViewHRReportsGeneral)]
        public async Task<IActionResult> PLAvailedReport(string month, int totalMonth)
        {
            if (!(totalMonth >= 1 && totalMonth <= 12))
            {
                return Json(ResponseHelper.GetMessageObject("Number of months should be between 1 and 12.", NotificationType.error));
            }
            try
            {
                string excelFileName = "PLLeaveStatusReports.xlsx";
                string PLDebitsReportDataTable = "PLDebits";
                string PLCreditsReportDataTable = "PLCredits";
                string OpenBalanceReportDataTable = "TBOpenBal";
                string dataSheetName1 = "PLDebits";
                string dataSheetName2 = "PLCredits";
                string dataSheetName3 = "OpenBal";

                string selectedDate = month + "-01";

                DateTime startDate = DateTime.ParseExact(selectedDate, "yyyy-MM-dd", CultureInfo.InvariantCulture);
                DateTime endDate = startDate.AddMonths(totalMonth).AddDays(-1);

                var data = await _attendancePLAvailedReport.PLAvailedReportAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PStartDate = startDate,
                    PEndDate = endDate
                });
                if (data == null) { return Json(ResponseHelper.GetMessageObject("No Data Found.", NotificationType.error)); }

                string stringFileName = "PLAvailedReport_" + month + ".xlsx";

                string reportTitle = "PL Availed Report Of" + month;
                byte[] byteContent1 = null;

                byte[] templateBytes = System.IO.File.ReadAllBytes((StorageHelper.GetTemplateFilePath(StorageHelper.SelfService.RepositorySelfService, FileName: excelFileName, Configuration)));

                using (MemoryStream templateStream = new MemoryStream())
                {
                    templateStream.Write(templateBytes, 0, (int)templateBytes.Length);

                    using (SpreadsheetDocument spreadsheetDocument = SpreadsheetDocument.Open(templateStream, true))
                    {
                        if (data.PPlDebits != null)
                        {
                            XLBookWriter.AppendDataInExcel(spreadsheetDocument, dataSheetName1, PLDebitsReportDataTable, data.PPlDebits);
                        }
                        if (data.PPlCredits != null)
                        {
                            XLBookWriter.AppendDataInExcel(spreadsheetDocument, dataSheetName2, PLCreditsReportDataTable, data.PPlCredits);
                        }
                        if (data.POpenBal != null)
                        {
                            XLBookWriter.AppendDataInExcel(spreadsheetDocument, dataSheetName3, OpenBalanceReportDataTable, data.POpenBal);
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

        #endregion Execute Action Procedures

        public async Task<IActionResult> GetPagingEmployeeSelectList(string search, int page, string id)
        {
            ParameterSpTcmPL parameterSpTcmPL = new ParameterSpTcmPL
            {
                PGenericSearch = search,
                PRowNumber = (page - 1) * 250,
                PPageLength = 250,
                PEmpno = id
            };

            Select2ResultList<DataFieldPaging> select2ResultList = new Select2ResultList<DataFieldPaging>();
            IEnumerable<DataFieldPaging> empList = Enumerable.Empty<DataFieldPaging>();

            if (CurrentUserIdentity.ProfileActions.Any(pa => pa.RoleId == SelfServiceHelper.RoleAttendanceAdmin))
            {
                empList = await _selectTcmPLPagingRepository.EmployeeListForHRAsync(BaseSpTcmPLGet(), parameterSpTcmPL);
                //return new SelectList(empList, "DataValueField", "DataTextField", Empno);
            }
            else if (CurrentUserIdentity.ProfileActions.Any(pa => pa.RoleId == SelfServiceHelper.RoleManagerHoDOnBeHalf))
            {
                empList = await _selectTcmPLPagingRepository.EmployeeListForMngrHodOnBeHalfAsync(BaseSpTcmPLGet(), parameterSpTcmPL);
                //return new SelectList(empList, "DataValueField", "DataTextField", Empno);
            }
            else if (CurrentUserIdentity.ProfileActions.Any(pa => pa.RoleId == SelfServiceHelper.RoleManagerHoD))
            {
                empList = await _selectTcmPLPagingRepository.EmployeeListForMngrHodAsync(BaseSpTcmPLGet(), parameterSpTcmPL);
                //return new SelectList(empList, "DataValueField", "DataTextField", Empno);
            }
            else if (CurrentUserIdentity.ProfileActions.Any(pa => pa.RoleId == SelfServiceHelper.RoleSecretary))
            {
                empList = await _selectTcmPLPagingRepository.EmployeeListForSecretary(BaseSpTcmPLGet(), parameterSpTcmPL);
                //return new SelectList(empList, "DataValueField", "DataTextField", Empno);
            }

            select2ResultList.items = empList.ToList();
            if (empList.Count() > 0)
                select2ResultList.totalCount = empList.FirstOrDefault().TotalRow ?? 0;
            else
                select2ResultList.totalCount = 0;
            return Json(select2ResultList);
        }
    }
}