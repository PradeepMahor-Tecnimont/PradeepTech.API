using DocumentFormat.OpenXml.Packaging;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using MimeTypes;
using MoreLinq;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.Attendance;
using TCMPLApp.DataAccess.Repositories.Common;
using TCMPLApp.DataAccess.Repositories.DeskBooking;
using TCMPLApp.DataAccess.Repositories.DMS;
using TCMPLApp.DataAccess.Repositories.SWPVaccine;
using TCMPLApp.Domain.Models.DeskBooking;
using TCMPLApp.Domain.Models.HRMasters;
using TCMPLApp.Domain.Models.SWP;
using TCMPLApp.Library.Excel.Template.Models;
using TCMPLApp.Library.Excel.Writer;
using TCMPLApp.WebApp.Classes;
using TCMPLApp.WebApp.Controllers;
using TCMPLApp.WebApp.CustomPolicyProvider;
using TCMPLApp.WebApp.Models;
using static TCMPLApp.WebApp.Classes.DTModel;

namespace TCMPLApp.WebApp.Areas.DeskBooking.Controllers
{
    [Area("DeskBooking")]
    [Authorize]
    public class BookingsController : BaseController
    {
        private const string ConstFilterEmployeeProjectMappingIndex = "EmployeeProjectMappingIndex";
        private const string ConstFilterDeskBookHistoryIndex = "DeskBookHistoryIndex";
        private const string ConstFilterDeskAreaUserMapHodIndex = "DeskAreaUserMapHodIndex";
        private const string ConstFilterDeskBookAttendanceHodIndex = "DeskBookAttendanceHodIndex";
        private const string ConstFilterDeskBookAttendanceHodHistoryIndex = "DeskBookAttendanceHodHistoryIndex";
        private const string ConstFilterAreaWiseDeskBookingIndex = "AreaWiseDeskBookingIndex";
        private const string ConstFilterSummaryIndex = "SummaryIndex";
        private const string ConstFilterBookingSummaryIndex = "BookingSummaryIndex";
        private const string ConstFilterAdminBookingSummaryIndex = "AdminBookingSummaryIndex";
        private const string ConstFilterDeskListDetailsIndex = "DeskListDetailsIndex";
        private const string ConstFilterAdminDeskListDetailsIndex = "AdminDeskListDetailsIndex";
        private const string ConstFilterEmpBookedDeskListDetailsIndex = "EmpBookedDeskListDetailsIndex";
        private const string ConstFilterAdminEmpBookedDeskListDetailsIndex = "AdminEmpBookedDeskListDetailsIndex";
        private const string ConstFilterDeskBookAttendanceDmsHistoryIndex = "DeskBookAttendanceDmsHistoryIndex";
        private const string ConstFilterDeskBookAttendanceDmsIndex = "DeskBookAttendanceDmsIndex";
        private const string ConstFilterDeskBookAttendanceStatusIndex = "DeskBookAttendanceStatusIndex";
        private const string ConstFilterDeskBookAttendanceStatusHistoryIndex = "DeskBookAttendanceStatusHistoryIndex";
        private const string ConstFilterEmpLocationMappingIndex = "EmpLocationMappingIndex";
        private const string ConstFilterFloorPlanIndex = "FloorPlanIndex";
        private const string ConstFilterAiroliCabinBookingIndex = "DeskBookCabinBookingIndex";
        private const string ConstFilterMyCabinBookingIndex = "MyCabinBookingIndex";
        private const string ConstFilterAllCabinBookingIndex = "AllCabinBookingIndex";

        private const string ConstAreaCatgCode = "A005";
        private const string ConstFilterByLocationAiroli = "02";
        private const string ConstFilterByOffice = "MOC4";
        private const int ConstFilterIsDeskBooked_Yes = 1;

        private readonly IAttendanceEmployeeDetailsRepository _attendanceEmployeeDetailsRepository;
        private readonly IDeskBookingCreateRepository _deskBookingCreateRepository;
        private readonly IAttendanceDateDataTableListRepository _attendanceDateDataTableListRepository;
        private readonly IUtilityRepository _utilityRepository;
        private readonly ICommonEmployeeDetailsRepository _commonEmployeeDetailsRepository;
        private readonly ISelectTcmPLRepository _selectTcmPLRepository;
        private readonly IFilterRepository _filterRepository;
        private readonly IDeskBookPlanningStatusRepository _dBPlanningStatusRepository;
        private readonly IDeskBookEmployeeProjectMappingDataTableListRepository _deskBookEmployeeProjectMappingDataTableListRepository;
        private readonly IDeskBookEmployeeProjectMappingRepository _deskBookEmployeeProjectMappingRepository;
        private readonly IDeskBookEmployeeProjectMappingDetails _deskBookEmployeeProjectMappingDetails;
        private readonly IDeskBookingPreferencesDetails _deskBookingPreferencesDetails;
        private readonly IDeskBookingPreferencesRepository _deskBookingPreferencesRepository;
        private readonly IDeskBookingStatusRepository _deskBookingStatusRepository;
        private readonly IDeskBookHistoryDataTableListRepository _deskBookHistoryDataTableListRepository;
        private readonly IDeskBookAttendanceDmsDataTableListRepository _deskBookAttendanceDmsDataTableListRepository;

        private readonly IAreaWiseDeskBookingDataTableListRepository _areaWiseDeskBookingDataTableListRepository;
        private readonly IDeskBookingDetailsRepository _deskBookingDetailsRepository;

        private readonly IDeskAreaUserMapHodDataTableListRepository _deskAreaUserMapHodDataTableListRepository;
        private readonly IDeskBookAttendanceHodDataTableListRepository _deskBookAttendanceHodDataTableListRepository;
        private readonly ICrossBookingSummaryXLListRepository _crossBookingSummaryXLListRepository;
        private readonly IDeskAreaUserMapRequestRepository _deskAreaUserMapRequestRepository;
        private readonly IDeskAreaUserMapHodDetailRepository _deskAreaUserMapHodDetailRepository;
        private readonly ISummaryDataTableListRepository _summaryDataTableListRepository;
        private readonly IDeskBookingRepository _deskBookingRepository;
        private readonly IBookingSummaryDataTableListRepository _bookingSummaryDataTableListRepository;
        private readonly IBookingSummaryDetailRepository _bookingSummaryDetailRepository;
        private readonly IDeskListDataTableListRepository _deskListDataTableListRepository;

        private readonly IEmpBookedDeskListDataTableListRepository _empBookedDeskListDataTableListRepository;
        private readonly IBookingSummaryXLReport _bookingSummaryXLReport;
        private readonly IBookingSummaryDeptXLReport _bookingSummaryDeptXLReport;
        private readonly IDeskBookingAttendanceStatusDataTableListRepository _deskBookingAttendanceStatusDataTableListRepository;
        private readonly IDeskBookingAttendanceRepository _deskBookingAttendanceRepository;
        private readonly IEmpLocationMappingDataTableListRepository _empLocationMappingDataTableListRepository;
        private readonly IEmpLocationMapRequestRepository _empLocationMapRequestRepository;
        private readonly IBookedDeskDataTableListRepository _bookedDeskDataTableListRepository;
        private readonly IDeskBookCabinBookingsDataTableListRepository _deskBookCabinBookingsDataTableListRepository;
        private readonly ICabinBookingRepository _cabinBookingRepository;
        private readonly ICabinBookingsDataTableListRepository _cabinBookingsDataTableListRepository;
        private readonly ISelectTcmPLPagingRepository _selectTcmPLPagingRepository;
        private readonly IImportDeskBookingsRepository _importDeskBookingsRepository;

        public BookingsController(
            IAttendanceEmployeeDetailsRepository attendanceEmployeeDetailsRepository,
            IDeskBookingCreateRepository deskBookingCreateRepository,
            ISelectTcmPLRepository selectTcmPLRepository,
            IDeskBookPlanningStatusRepository dBPlanningStatusRepository,
            IFilterRepository filterRepository,
            ICommonEmployeeDetailsRepository commonEmployeeDetailsRepository,
            IDeskBookEmployeeProjectMappingDataTableListRepository deskBookEmployeeProjectMappingDataTableListRepository,
            IDeskBookEmployeeProjectMappingRepository deskBookEmployeeProjectMappingRepository,
            IDeskBookEmployeeProjectMappingDetails deskBookEmployeeProjectMappingDetails,
            IDeskBookingPreferencesDetails deskBookingPreferencesDetails,
            IDeskBookingPreferencesRepository deskBookingPreferencesRepository,
            IAttendanceDateDataTableListRepository attendanceDateDataTableListRepository,
            IDeskBookingStatusRepository deskBookingStatusRepository,
            IDeskBookHistoryDataTableListRepository deskBookHistoryDataTableListRepository,
            IDeskBookAttendanceDmsDataTableListRepository deskBookAttendanceDmsDataTableListRepository,
            IDeskBookingDetailsRepository deskBookingDetailsRepository,

            IUtilityRepository utilityRepository,

            IDeskAreaUserMapHodDataTableListRepository deskAreaUserMapHodDataTableListRepository,
            IDeskBookAttendanceHodDataTableListRepository deskBookAttendanceHodDataTableListRepository,
            ICrossBookingSummaryXLListRepository crossBookingSummaryXLListRepository,
            IDeskAreaUserMapRequestRepository deskAreaUserMapRequestRepository,
            IDeskAreaUserMapHodDetailRepository deskAreaUserMapHodDetailRepository,
            IAreaWiseDeskBookingDataTableListRepository areaWiseDeskBookingDataTableListRepository,
            ISummaryDataTableListRepository summaryDataTableListRepository,
             IDeskBookingRepository deskBookingRepository,
             IBookingSummaryDataTableListRepository bookingSummaryDataTableListRepository,
             IBookingSummaryDetailRepository bookingSummaryDetailRepository,
             IDeskListDataTableListRepository deskListDataTableListRepository,

             IEmpBookedDeskListDataTableListRepository empBookedDeskListDataTableListRepository,
             IBookingSummaryXLReport bookingSummaryXLReport,
             IBookingSummaryDeptXLReport bookingSummaryDeptXLReport,
             IDeskBookingAttendanceStatusDataTableListRepository deskBookingAttendanceStatusDataTableListRepository,
             IDeskBookingAttendanceRepository deskBookingAttendanceRepository,
             IEmpLocationMappingDataTableListRepository empLocationMappingDataTableListRepository,
             IEmpLocationMapRequestRepository empLocationMapRequestRepository,
             IBookedDeskDataTableListRepository bookedDeskDataTableListRepository,
             IDeskBookCabinBookingsDataTableListRepository deskBookCabinBookingsDataTableListRepository,
             ICabinBookingRepository cabinBookingRepository,
             ICabinBookingsDataTableListRepository cabinBookingsDataTableListRepository,
            ISelectTcmPLPagingRepository selectTcmPLPagingRepository,
            IImportDeskBookingsRepository importDeskBookingsRepository
            )
        {
            _attendanceEmployeeDetailsRepository = attendanceEmployeeDetailsRepository;
            _deskBookingCreateRepository = deskBookingCreateRepository;
            _selectTcmPLRepository = selectTcmPLRepository;
            _filterRepository = filterRepository;
            _dBPlanningStatusRepository = dBPlanningStatusRepository;
            _deskBookEmployeeProjectMappingDataTableListRepository = deskBookEmployeeProjectMappingDataTableListRepository;
            _deskBookEmployeeProjectMappingRepository = deskBookEmployeeProjectMappingRepository;
            _deskBookEmployeeProjectMappingDetails = deskBookEmployeeProjectMappingDetails;
            _deskBookingPreferencesDetails = deskBookingPreferencesDetails;
            _deskBookingPreferencesRepository = deskBookingPreferencesRepository;
            _attendanceDateDataTableListRepository = attendanceDateDataTableListRepository;
            _deskBookingStatusRepository = deskBookingStatusRepository;
            _deskBookHistoryDataTableListRepository = deskBookHistoryDataTableListRepository;
            _commonEmployeeDetailsRepository = commonEmployeeDetailsRepository;
            _deskBookingDetailsRepository = deskBookingDetailsRepository;

            _utilityRepository = utilityRepository;

            _deskAreaUserMapHodDataTableListRepository = deskAreaUserMapHodDataTableListRepository;
            _deskBookAttendanceHodDataTableListRepository = deskBookAttendanceHodDataTableListRepository;
            _crossBookingSummaryXLListRepository = crossBookingSummaryXLListRepository;
            _deskAreaUserMapRequestRepository = deskAreaUserMapRequestRepository;
            _deskAreaUserMapHodDetailRepository = deskAreaUserMapHodDetailRepository;
            _areaWiseDeskBookingDataTableListRepository = areaWiseDeskBookingDataTableListRepository;
            _summaryDataTableListRepository = summaryDataTableListRepository;
            _deskBookingRepository = deskBookingRepository;
            _bookingSummaryDataTableListRepository = bookingSummaryDataTableListRepository;
            _bookingSummaryDetailRepository = bookingSummaryDetailRepository;
            _deskListDataTableListRepository = deskListDataTableListRepository;

            _empBookedDeskListDataTableListRepository = empBookedDeskListDataTableListRepository;
            _bookingSummaryXLReport = bookingSummaryXLReport;
            _deskBookAttendanceDmsDataTableListRepository = deskBookAttendanceDmsDataTableListRepository;
            _bookingSummaryDeptXLReport = bookingSummaryDeptXLReport;
            _deskBookingAttendanceStatusDataTableListRepository = deskBookingAttendanceStatusDataTableListRepository;
            _deskBookingAttendanceRepository = deskBookingAttendanceRepository;
            _empLocationMappingDataTableListRepository = empLocationMappingDataTableListRepository;
            _empLocationMapRequestRepository = empLocationMapRequestRepository;
            _bookedDeskDataTableListRepository = bookedDeskDataTableListRepository;
            _deskBookCabinBookingsDataTableListRepository = deskBookCabinBookingsDataTableListRepository;
            _cabinBookingRepository = cabinBookingRepository;
            _cabinBookingsDataTableListRepository = cabinBookingsDataTableListRepository;
            _selectTcmPLPagingRepository = selectTcmPLPagingRepository;
            _importDeskBookingsRepository = importDeskBookingsRepository;
        }

        public IActionResult Index()
        {
            return View();
        }

        #region Create Booking

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionDeskBookingCreate)]
        public async Task<IActionResult> CreateDeskBooking(DateTime? quickBookDate)
        {
            var empdetails = await _commonEmployeeDetailsRepository.EmployeeDetailAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            var bookingDatesList = await _selectTcmPLRepository.DeskBookDatesList(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            var strSelectedDate = quickBookDate?.ToString("yyyyMMdd") ?? bookingDatesList.FirstOrDefault().DataValueField;

            var lastBookedInfo = await _deskBookingDetailsRepository.DeskBookingDetailsAsync(
                    BaseSpTcmPLGet(), new ParameterSpTcmPL());

            ViewData["BookingDatesList"] = new SelectList(bookingDatesList, "DataValueField", "DataTextField", strSelectedDate);

            // O F F I C E   L I S T
            var bookingOfficeList = await _selectTcmPLRepository.DeskBookEmpOfficeList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["BookingOfficeList"] = bookingOfficeList.Any()
                ? new SelectList(bookingOfficeList, "DataValueField", "DataTextField", bookingOfficeList.FirstOrDefault().DataValueField)
                : (object)new SelectList(bookingOfficeList, "DataValueField", "DataTextField");

            if (bookingOfficeList.Any())
            {
                // S H I F T   L I S T
                var shiftList = await _selectTcmPLRepository.DeskBookOfficeShiftList(BaseSpTcmPLGet(), new ParameterSpTcmPL
                {
                    POffice = bookingOfficeList.FirstOrDefault().DataValueField
                });

                string shiftCode = "!-!";

                if (shiftList.Any())
                {
                    shiftCode = "GS";
                    ViewData["ShiftList"] = new SelectList(shiftList, "DataValueField", "DataTextField", shiftCode);
                }
                else
                {
                    ViewData["ShiftList"] = new SelectList(shiftList, "DataValueField", "DataTextField");
                }

                var selectedDate = DateTime.ParseExact(strSelectedDate, "yyyyMMdd", CultureInfo.InvariantCulture);

                // D E S K   L I S T
                var deskList = await _selectTcmPLRepository.DeskBookAvailableDesks(BaseSpTcmPLGet(), new ParameterSpTcmPL
                {
                    POffice = bookingOfficeList.FirstOrDefault().DataValueField,
                    PDate = selectedDate,
                    PShift = shiftCode
                });

                ViewData["DeskList"] = new SelectList(deskList, "DataValueField", "DataTextField", lastBookedInfo.PDeskid, "DataGroupField");
            }

            DeskBookingCreateViewModel viewModel = new()
            {
                AssignDesc = empdetails.PAssignName,
                Assign = empdetails.PAssign,
                ParentDesc = empdetails.PCostName,
                Parent = empdetails.PParent,
                EmpGrade = empdetails.PGrade,
                Emptype = empdetails.PEmpType,
                Empno = empdetails.PForEmpno,
                EmployeeName = empdetails.PName,
                CurrentOfficeLocation = empdetails.PCurrentOfficeLocation,
                Desk = lastBookedInfo.PDeskid
            };

            return PartialView("_ModalDeskBookCreatePartial", viewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionDeskBookingCreate)]
        public async Task<IActionResult> CreateDeskBooking(DeskBookingCreateViewModel deskBookingCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _deskBookingCreateRepository.CreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            POffice = deskBookingCreateViewModel.DeskOffice,
                            PShift = deskBookingCreateViewModel.Shift,
                            PAttendanceDate = DateTime.ParseExact(deskBookingCreateViewModel.BookingDate, "yyyyMMdd", CultureInfo.InvariantCulture),
                            PDeskid = deskBookingCreateViewModel.Desk
                        });

                    Notify(result.PMessageType == IsOk ? "Success" : "Error", result.PMessageText, "", result.PMessageType == IsOk ? NotificationType.success : NotificationType.error);

                    if (result.PMessageType == IsOk)
                    {
                        return Json(ResponseHelper.GetMessageObject(result.PMessageText));
                    }
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            var bookingDatesList = await _selectTcmPLRepository.DeskBookDatesList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["BookingDatesList"] = new SelectList(bookingDatesList, "DataValueField", "DataTextField", deskBookingCreateViewModel.BookingDate);

            // O F F I C E   L I S T
            var bookingOfficeList = await _selectTcmPLRepository.DeskBookEmpOfficeList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["BookingOfficeList"] = new SelectList(bookingOfficeList, "DataValueField", "DataTextField", deskBookingCreateViewModel.DeskOffice);

            if (bookingOfficeList.Count() == 1)
            {
                // S H I F T   L I S T
                var shiftList = await _selectTcmPLRepository.DeskBookOfficeShiftList(BaseSpTcmPLGet(), new ParameterSpTcmPL
                {
                    POffice = bookingOfficeList.FirstOrDefault().DataValueField
                });
                ViewData["ShiftList"] = new SelectList(shiftList, "DataValueField", "DataTextField", deskBookingCreateViewModel.Shift);

                //Desk Filter

                var selectedDateStr = bookingDatesList.FirstOrDefault().DataValueField;

                var selectedDate = DateTime.ParseExact(selectedDateStr, "yyyyMMdd", CultureInfo.InvariantCulture);

                // D E S K   L I S T
                var deskList = await _selectTcmPLRepository.DeskBookAvailableDesks(BaseSpTcmPLGet(), new ParameterSpTcmPL
                {
                    POffice = deskBookingCreateViewModel.DeskOffice,
                    PDate = selectedDate,
                    PShift = deskBookingCreateViewModel.Shift
                });

                ViewData["DeskList"] = new SelectList(deskList, "DataValueField", "DataTextField", deskBookingCreateViewModel.Desk, "DataGroupField");
            }

            return PartialView("_ModalDeskBookCreatePartial", deskBookingCreateViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> GetOfficeList()
        {
            var bookingOfficeList = await _selectTcmPLRepository.DeskBookEmpOfficeList(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            return Json(bookingOfficeList);
        }

        [HttpGet]
        public async Task<IActionResult> GetShiftList(string office)
        {
            var shiftList = await _selectTcmPLRepository.DeskBookOfficeShiftList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
                POffice = office
            });

            return Json(shiftList);
        }

        [HttpGet]
        public async Task<IActionResult> GetDeskAreaLists(string office, string employee)
        {
            var deskAreaList = await _selectTcmPLRepository.DeskBookAreaForAssignmentList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
                POffice = office,
                PEmpno = employee
            });

            return Json(deskAreaList);
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionDeskBookingCreate)]
        public async Task<IActionResult> DBHistoryIndex()
        {
            DeskBookHistoryViewModel deskBookHistoryViewModel = new();

            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterDeskBookHistoryIndex
            });

            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }
            deskBookHistoryViewModel.FilterDataModel = filterDataModel;

            return View(deskBookHistoryViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionDeskBookingCreate)]
        public async Task<JsonResult> GetListsDeskBookHistoryList(string paramJson)
        {
            DTResult<DeskBookHistoryDataTableList> result = new();
            int totalRow = 0;
            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            try
            {
                System.Collections.Generic.IEnumerable<DeskBookHistoryDataTableList> data = await _deskBookHistoryDataTableListRepository.DeskBookHistoryDataTableList(
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
        public async Task<IActionResult> ChangeDeskBooking()
        {
            var empdetails = await _commonEmployeeDetailsRepository.EmployeeDetailAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            // O F F I C E   L I S T
            var bookingOfficeList = await _selectTcmPLRepository.DeskBookEmpOfficeList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["BookingOfficeList"] = bookingOfficeList.Any()
                ? new SelectList(bookingOfficeList, "DataValueField", "DataTextField", bookingOfficeList.FirstOrDefault().DataValueField)
                : (object)new SelectList(bookingOfficeList, "DataValueField", "DataTextField");

            if (bookingOfficeList.Any())
            {
                // S H I F T   L I S T
                var shiftList = await _selectTcmPLRepository.DeskBookOfficeShiftList(BaseSpTcmPLGet(), new ParameterSpTcmPL
                {
                    POffice = bookingOfficeList.FirstOrDefault().DataValueField
                });

                string shiftCode = "!-!";

                if (shiftList.Any())
                {
                    ViewData["ShiftList"] = new SelectList(shiftList, "DataValueField", "DataTextField", shiftList.FirstOrDefault().DataValueField);
                    shiftCode = shiftList.FirstOrDefault().DataValueField;
                }
                else
                {
                    ViewData["ShiftList"] = new SelectList(shiftList, "DataValueField", "DataTextField");
                }

                //Desk Filter

                var selectedDate = DateTime.Now.Date;

                // D E S K   L I S T
                var deskList = await _selectTcmPLRepository.DeskBookAvailableDesks(BaseSpTcmPLGet(), new ParameterSpTcmPL
                {
                    POffice = bookingOfficeList.FirstOrDefault().DataValueField,
                    PDate = selectedDate,
                    PShift = shiftCode
                });

                ViewData["DeskList"] = new SelectList(deskList, "DataValueField", "DataTextField", null, "DataGroupField");
            }

            DeskBookingCreateViewModel viewModel = new()
            {
                BookingDate = DateTime.Now.ToString("dd-MMM-yyyy"),
                AssignDesc = empdetails.PAssignName,
                Assign = empdetails.PAssign,
                ParentDesc = empdetails.PCostName,
                Parent = empdetails.PParent,
                EmpGrade = empdetails.PGrade,
                Emptype = empdetails.PEmpType,
                Empno = empdetails.PForEmpno,
                EmployeeName = empdetails.PName,
                CurrentOfficeLocation = empdetails.PCurrentOfficeLocation
            };

            return PartialView("_ModalDeskBookChangePartial", viewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionDeskBookingCreate)]
        public async Task<IActionResult> ChangeDeskBooking(DeskBookingCreateViewModel deskBookingCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _deskBookingCreateRepository.ChangeAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            POffice = deskBookingCreateViewModel.DeskOffice,
                            PShift = deskBookingCreateViewModel.Shift,

                            PDeskid = deskBookingCreateViewModel.Desk
                        });

                    Notify(result.PMessageType == IsOk ? "Success" : "Error", result.PMessageText, "", result.PMessageType == IsOk ? NotificationType.success : NotificationType.error);

                    if (result.PMessageType == IsOk)
                    {
                        return Json(ResponseHelper.GetMessageObject(result.PMessageText));
                    }
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            // O F F I C E   L I S T
            var bookingOfficeList = await _selectTcmPLRepository.DeskBookEmpOfficeList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["BookingOfficeList"] = new SelectList(bookingOfficeList, "DataValueField", "DataTextField", deskBookingCreateViewModel.DeskOffice);

            if (bookingOfficeList.Count() == 1)
            {
                // S H I F T   L I S T
                var shiftList = await _selectTcmPLRepository.DeskBookOfficeShiftList(BaseSpTcmPLGet(), new ParameterSpTcmPL
                {
                    POffice = bookingOfficeList.FirstOrDefault().DataValueField
                });
                ViewData["ShiftList"] = new SelectList(shiftList, "DataValueField", "DataTextField", deskBookingCreateViewModel.Shift);

                // D E S K   L I S T
                var deskList = await _selectTcmPLRepository.DeskBookAvailableDesks(BaseSpTcmPLGet(), new ParameterSpTcmPL
                {
                    POffice = deskBookingCreateViewModel.DeskOffice,
                    PDate = DateTime.Now.Date,
                    PShift = deskBookingCreateViewModel.Shift
                });
                ViewData["DeskList"] = new SelectList(deskList, "DataValueField", "DataTextField", deskBookingCreateViewModel.Desk, "DataGroupField");
            }

            return PartialView("_ModalDeskBookChangePartial", deskBookingCreateViewModel);
        }

        #endregion Create Booking

        #region EmployeeProjectMappingIndex

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionDeskBookDept)]
        public async Task<IActionResult> EmployeeProjectMappingIndex()
        {
            DeskBookEmployeeProjectMappingViewModel deskBookEmployeeProjectMappingViewModel = new();

            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterEmployeeProjectMappingIndex
            });

            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }
            deskBookEmployeeProjectMappingViewModel.FilterDataModel = filterDataModel;

            return View(deskBookEmployeeProjectMappingViewModel);
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

            var dbAssignList = await _selectTcmPLRepository.DeskBookCostCodeList4HodSecAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }
            else
            {
                if (dbAssignList.Any())
                {
                    filterDataModel.Assign = dbAssignList.First().DataValueField;
                }
            }
            var empList = await _selectTcmPLRepository.EmployeeListAssignForHoDSec(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["EmpList"] = new SelectList(empList, "DataValueField", "DataTextField", filterDataModel.Empno);

            ViewData["AssignList"] = new SelectList(dbAssignList, "DataValueField", "DataTextField", filterDataModel.Assign);

            var projectList = await _selectTcmPLRepository.ProjectListSWP(BaseSpTcmPLGet(), null);
            ViewData["ProjectList"] = new SelectList(projectList, "DataValueField", "DataTextField", filterDataModel.Projno);

            return PartialView("_DeskBookEmployeeProjectMappingFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> EmployeeProjectMappingFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                if (filterDataModel.StartDate != null)
                {
                    if (filterDataModel.StartDate == null)
                    {
                        throw new Exception("Date required.");
                    }
                }

                {
                    if (string.IsNullOrEmpty(filterDataModel.Assign))
                    {
                        var dbassignList = await _selectTcmPLRepository.DeskBookCostCodeList4HodSecAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());
                        if (dbassignList.Any())
                        {
                            filterDataModel.Assign = dbassignList.First().DataValueField;
                        }
                    }

                    string jsonFilter;
                    jsonFilter = JsonConvert.SerializeObject(
                            new
                            {
                                filterDataModel.StartDate,
                                filterDataModel.Empno,
                                filterDataModel.Assign,
                                filterDataModel.Projno,
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
                        assign = filterDataModel.Assign,
                        projno = filterDataModel.Projno,
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
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionDeskBookDept)]
        public async Task<JsonResult> GetListEmployeeProjectMapping(DTParameters param)
        {
            if (!(
                    CurrentUserIdentity.ProfileActions.Any(pa => pa.ActionId == SWPHelper.ActionPrimaryWsPlanning) ||
                    CurrentUserIdentity.ProfileActions.Any(pa => pa.ActionId == SWPHelper.ActionPrimaryWsStatus)
                ))
            {
                _ = Forbid();
            }

            DTResult<DeskBookEmployeeProjectMappingDataTableList> result = new();
            int totalRow = 0;

            DateTime nDate = DateTime.Now;

            if (param.StartDate != null)
            {
                nDate = (DateTime)param.StartDate;
            }

            try
            {
                var data = await _deskBookEmployeeProjectMappingDataTableListRepository.DeskBookEmployeeProjectMappingDataTableList(
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

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionDeskBookDept)]
        public async Task<IActionResult> EmployeeProjectMappingCreate()
        {
            var employeeList = await _selectTcmPLRepository.EmployeeListAssignForHoDSec(BaseSpTcmPLGet(), null);
            ViewData["EmployeeList"] = new SelectList(employeeList, "DataValueField", "DataTextField");

            var projectList = await _selectTcmPLRepository.DeskBookProjectList(BaseSpTcmPLGet(), null);
            ViewData["ProjectList"] = new SelectList(projectList, "DataValueField", "DataTextField");

            var deskBookEmployeeProjectMappingCreateViewModel = new DeskBookEmployeeProjectMappingCreateViewModel();

            return PartialView("_ModalDeskBookEmployeeProjectMappingCreatePartial", deskBookEmployeeProjectMappingCreateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionDeskBookDept)]
        public async Task<IActionResult> EmployeeProjectMappingCreate([FromForm] DeskBookEmployeeProjectMappingCreateViewModel deskBookEmployeeProjectMappingCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _deskBookEmployeeProjectMappingRepository.EmployeeProjectCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PEmpno = deskBookEmployeeProjectMappingCreateViewModel.Empno,
                            PProjno = deskBookEmployeeProjectMappingCreateViewModel.Projno
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

            var employeeList = await _selectTcmPLRepository.EmployeeListAssignForHoDSec(BaseSpTcmPLGet(), null);
            ViewData["EmployeeList"] = new SelectList(employeeList, "DataValueField", "DataTextField", deskBookEmployeeProjectMappingCreateViewModel.Empno);

            var projectList = await _selectTcmPLRepository.ProjectListSWP(BaseSpTcmPLGet(), null);
            ViewData["ProjectList"] = new SelectList(projectList, "DataValueField", "DataTextField", deskBookEmployeeProjectMappingCreateViewModel.Projno);

            return PartialView("_ModalDeskBookEmployeeProjectMappingCreatePartial", deskBookEmployeeProjectMappingCreateViewModel);
        }

        public async Task<IActionResult> EmployeeProjectMappingUpdate(string applicationid)
        {
            DeskBookEmployeeProjectMappingDetailViewModel deskBookEmployeeProjectMappingDetailViewModel = new();

            var deskBookEmployeeProjectMappingUpdateViewModel = new DeskBookEmployeeProjectMappingUpdateViewModel();

            var result = await _deskBookEmployeeProjectMappingDetails.DeskBookEmployeeProjectMappingDetailsAsync(
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
                deskBookEmployeeProjectMappingUpdateViewModel.Projno = result.PProjno;
                deskBookEmployeeProjectMappingUpdateViewModel.Empno = result.PEmpno;
                deskBookEmployeeProjectMappingUpdateViewModel.Empname = result.PEmpName;

                deskBookEmployeeProjectMappingUpdateViewModel.KeyId = applicationid;
            }

            var projectList = await _selectTcmPLRepository.ProjectListSWP(BaseSpTcmPLGet(), null);
            ViewData["ProjectList"] = new SelectList(projectList, "DataValueField", "DataTextField", deskBookEmployeeProjectMappingDetailViewModel.Projno);

            return PartialView("_ModalDeskBookEmployeeProjectMappingUpdatePartial", deskBookEmployeeProjectMappingUpdateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionDeskBookDept)]
        public async Task<IActionResult> EmployeeProjectMappingUpdate([FromForm] DeskBookEmployeeProjectMappingUpdateViewModel deskBookEmployeeProjectMappingUpdateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _deskBookEmployeeProjectMappingRepository.EmployeeProjectEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PApplicationId = deskBookEmployeeProjectMappingUpdateViewModel.KeyId,
                            PProjno = deskBookEmployeeProjectMappingUpdateViewModel.Projno
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

            var employeeList = await _selectTcmPLRepository.EmployeeListAssignForHoDSec(BaseSpTcmPLGet(), null);
            ViewData["EmployeeList"] = new SelectList(employeeList, "DataValueField", "DataTextField", deskBookEmployeeProjectMappingUpdateViewModel.Empno);

            var projectList = await _selectTcmPLRepository.ProjectListSWP(BaseSpTcmPLGet(), null);
            ViewData["ProjectList"] = new SelectList(projectList, "DataValueField", "DataTextField", deskBookEmployeeProjectMappingUpdateViewModel.Projno);

            return PartialView("_ModalDeskBookEmployeeProjectMappingUpdatePartial", deskBookEmployeeProjectMappingUpdateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionDeskBookDept)]
        public async Task<IActionResult> EmployeeProjectMappingDelete(string ApplicationId)
        {
            try
            {
                var result = await _deskBookEmployeeProjectMappingRepository.EmployeeProjectDeleteAsync(
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

        #endregion EmployeeProjectMappingIndex

        #region Employee Preference

        public async Task<IActionResult> EmployeePreference(DeskBookingPreferencesDetailViewModel employeePreference)
        {
            var empdetails = await _commonEmployeeDetailsRepository.EmployeeDetailAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            var result = await _deskBookingPreferencesDetails.DeskBookingPreferencesDetailsAsync(
                         BaseSpTcmPLGet(),
                         new ParameterSpTcmPL
                         {
                         });
            employeePreference.AssignDesc = empdetails.PAssignName;
            employeePreference.Assign = empdetails.PAssign;
            employeePreference.ParentDesc = empdetails.PAssignName;
            employeePreference.Parent = empdetails.PParent;
            employeePreference.EmpGrade = empdetails.PGrade;
            employeePreference.Emptype = empdetails.PEmpType;
            employeePreference.Empno = empdetails.PForEmpno;
            employeePreference.EmployeeName = empdetails.PName;
            employeePreference.CurrentOfficeLocation = empdetails.PCurrentOfficeLocation;

            employeePreference.BookingDate = DateTime.Now.ToString("yyyyMMdd");
            employeePreference.Desk = "NONE";

            employeePreference.DeskOffice = result.POffice;
            employeePreference.DeskArea = result.PDeskArea;
            employeePreference.DeskAreaDesc = result.PDeskAreaDesc;
            employeePreference.Shift = result.PShift;
            employeePreference.ShiftDesc = result.PShiftDesc;
            employeePreference.KeyId = result.PKeyId;

            return View(employeePreference);
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionDeskBookDept)]
        public async Task<IActionResult> DeskBookingPreferencesCreate()
        {
            var empdetails = await _attendanceEmployeeDetailsRepository.AttendanceEmployeeDetailsAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            IEnumerable<DataField> baseOfficeList = await _selectTcmPLRepository.DeskBookingOfficeLocationList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
                PEmpno = empdetails.Empno
            });

            ViewData["BookingOfficeList"] = new SelectList(baseOfficeList, "DataValueField", "DataTextField", baseOfficeList.FirstOrDefault().DataValueField);

            if (baseOfficeList.Any())
            {
                // S H I F T   L I S T
                var shiftList = await _selectTcmPLRepository.DeskBookOfficeShiftList(BaseSpTcmPLGet(), new ParameterSpTcmPL
                {
                    POffice = baseOfficeList.FirstOrDefault().DataValueField
                });

                if (shiftList.Any())
                {
                    ViewData["ShiftList"] = new SelectList(shiftList, "DataValueField", "DataTextField", shiftList.FirstOrDefault().DataValueField);
                    _ = shiftList.FirstOrDefault().DataValueField;
                }
                else
                {
                    ViewData["ShiftList"] = new SelectList(shiftList, "DataValueField", "DataTextField");
                }

                IEnumerable<DataField> areaList = await _selectTcmPLRepository.DeskBookAreaForAssignmentList(BaseSpTcmPLGet(), new ParameterSpTcmPL
                {
                    POffice = baseOfficeList.FirstOrDefault().DataValueField,
                    PEmpno = empdetails.Empno
                });
                ViewData["DeskAreas"] = new SelectList(areaList, "DataValueField", "DataTextField", areaList.FirstOrDefault().DataValueField);

                if (areaList.Any())
                {
                    _ = areaList.FirstOrDefault().DataValueField;
                }
            }

            DeskBookingPreferencesCreateViewModel deskBookingPreferencesCreateViewModel = new()
            {
                AssignDesc = empdetails.AssignDesc,
                Assign = empdetails.AssignCode,
                ParentDesc = empdetails.ParentDesc,
                Parent = empdetails.ParentCode,
                EmpGrade = empdetails.EmpGrade,
                Emptype = empdetails.Emptype,
                Empno = empdetails.Empno,
                EmployeeName = empdetails.Name,
                CurrentOfficeLocation = empdetails.CurrentOfficeLocation
            };

            return PartialView("_ModalDeskBookPreferencesCreatePartial", deskBookingPreferencesCreateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionDeskBookDept)]
        public async Task<IActionResult> DeskBookingPreferencesCreate([FromForm] DeskBookingPreferencesCreateViewModel deskBookingPreferencesCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _deskBookingPreferencesRepository.DeskBookingPreferencesCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            POffice = deskBookingPreferencesCreateViewModel.Office,
                            PShift = deskBookingPreferencesCreateViewModel.Shift,
                            PDeskArea = deskBookingPreferencesCreateViewModel.DeskArea
                        });

                    Notify(result.PMessageType == IsOk ? "Success" : "Error", result.PMessageText, "", result.PMessageType == IsOk ? NotificationType.success : NotificationType.error);

                    if (result.PMessageType == IsOk)
                    {
                        return Json(ResponseHelper.GetMessageObject(result.PMessageText));
                    }
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            IEnumerable<DataField> baseOfficeList = await _selectTcmPLRepository.DeskBookingOfficeLocationList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
                PEmpno = deskBookingPreferencesCreateViewModel.Empno
            });

            ViewData["BookingOfficeList"] = new SelectList(baseOfficeList, "DataValueField", "DataTextField", deskBookingPreferencesCreateViewModel.Office);

            if (baseOfficeList.Any())
            {
                // S H I F T   L I S T
                var shiftList = await _selectTcmPLRepository.DeskBookOfficeShiftList(BaseSpTcmPLGet(), new ParameterSpTcmPL
                {
                    POffice = baseOfficeList.FirstOrDefault().DataValueField
                });

                if (shiftList.Any())
                {
                    ViewData["ShiftList"] = new SelectList(shiftList, "DataValueField", "DataTextField", shiftList.FirstOrDefault().DataValueField);
                    _ = shiftList.FirstOrDefault().DataValueField;
                }
                else
                {
                    ViewData["ShiftList"] = new SelectList(shiftList, "DataValueField", "DataTextField");
                }

                IEnumerable<DataField> areaList = await _selectTcmPLRepository.DeskBookAreaForAssignmentList(BaseSpTcmPLGet(), new ParameterSpTcmPL
                {
                    POffice = baseOfficeList.FirstOrDefault().DataValueField,
                    PEmpno = deskBookingPreferencesCreateViewModel.Empno
                });
                ViewData["DeskAreas"] = new SelectList(areaList, "DataValueField", "DataTextField", areaList.FirstOrDefault().DataValueField);

                if (areaList.Any())
                {
                    _ = areaList.FirstOrDefault().DataValueField;
                }
            }

            return PartialView("_ModalDeskBookPreferencesCreatePartial", deskBookingPreferencesCreateViewModel);
        }

        public async Task<IActionResult> DeskBookingPreferencesEdit()
        {
            var deskBookingPreferencesUpdateViewModel = new DeskBookingPreferencesUpdateViewModel();

            var empdetails = await _attendanceEmployeeDetailsRepository.AttendanceEmployeeDetailsAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            var result = await _deskBookingPreferencesDetails.DeskBookingPreferencesDetailsAsync(
                         BaseSpTcmPLGet(),
                         new ParameterSpTcmPL
                         {
                         });

            if (result.PMessageType != IsOk)
            {
                throw new Exception(result.PMessageText.Replace("-", " "));
            }
            else
            {
                deskBookingPreferencesUpdateViewModel.Office = result.POffice;
                deskBookingPreferencesUpdateViewModel.DeskArea = result.PDeskArea;
                deskBookingPreferencesUpdateViewModel.Shift = result.PShift;
                deskBookingPreferencesUpdateViewModel.KeyId = result.PKeyId;
                deskBookingPreferencesUpdateViewModel.CurrentOfficeLocation = empdetails.CurrentOfficeLocation;
            }

            IEnumerable<DataField> baseOfficeList = await _selectTcmPLRepository.DeskBookingOfficeLocationList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
                PEmpno = empdetails.Empno
            });

            ViewData["BookingOfficeList"] = new SelectList(baseOfficeList, "DataValueField", "DataTextField", deskBookingPreferencesUpdateViewModel.Office);

            if (baseOfficeList.Any())
            {
                // S H I F T   L I S T
                var shiftList = await _selectTcmPLRepository.DeskBookOfficeShiftList(BaseSpTcmPLGet(), new ParameterSpTcmPL
                {
                    POffice = deskBookingPreferencesUpdateViewModel.Office
                });

                if (shiftList.Any())
                {
                    ViewData["ShiftList"] = new SelectList(shiftList, "DataValueField", "DataTextField", deskBookingPreferencesUpdateViewModel.Shift);
                    _ = shiftList.FirstOrDefault().DataValueField;
                }
                else
                {
                    ViewData["ShiftList"] = new SelectList(shiftList, "DataValueField", "DataTextField", deskBookingPreferencesUpdateViewModel.Shift);
                }

                IEnumerable<DataField> areaList = await _selectTcmPLRepository.DeskBookAreaForAssignmentList(BaseSpTcmPLGet(), new ParameterSpTcmPL
                {
                    POffice = deskBookingPreferencesUpdateViewModel.Office,
                    PEmpno = empdetails.Empno
                });

                ViewData["DeskAreas"] = new SelectList(areaList, "DataValueField", "DataTextField", deskBookingPreferencesUpdateViewModel.DeskArea);
            }

            deskBookingPreferencesUpdateViewModel.AssignDesc = empdetails.AssignDesc;
            deskBookingPreferencesUpdateViewModel.Assign = empdetails.AssignCode;
            deskBookingPreferencesUpdateViewModel.ParentDesc = empdetails.ParentDesc;
            deskBookingPreferencesUpdateViewModel.Parent = empdetails.ParentCode;
            deskBookingPreferencesUpdateViewModel.EmpGrade = empdetails.EmpGrade;
            deskBookingPreferencesUpdateViewModel.Emptype = empdetails.Emptype;
            deskBookingPreferencesUpdateViewModel.Empno = empdetails.Empno;
            deskBookingPreferencesUpdateViewModel.EmployeeName = empdetails.Name;

            return PartialView("_ModalDeskBookPreferencesUpdatePartial", deskBookingPreferencesUpdateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionDeskBookDept)]
        public async Task<IActionResult> DeskBookingPreferencesEdit([FromForm] DeskBookingPreferencesUpdateViewModel deskBookingPreferencesUpdateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _deskBookingPreferencesRepository.DeskBookingPreferencesEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PKeyId = deskBookingPreferencesUpdateViewModel.KeyId,
                            POffice = deskBookingPreferencesUpdateViewModel.Office,
                            PShift = deskBookingPreferencesUpdateViewModel.Shift,
                            PDeskArea = deskBookingPreferencesUpdateViewModel.DeskArea
                        });

                    Notify(result.PMessageType == IsOk ? "Success" : "Error", result.PMessageText, "", result.PMessageType == IsOk ? NotificationType.success : NotificationType.error);

                    if (result.PMessageType == IsOk)
                    {
                        return Json(ResponseHelper.GetMessageObject(result.PMessageText));
                    }
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            IEnumerable<DataField> baseOfficeList = await _selectTcmPLRepository.DeskBookingOfficeLocationList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
                PEmpno = deskBookingPreferencesUpdateViewModel.Empno
            });

            ViewData["BookingOfficeList"] = new SelectList(baseOfficeList, "DataValueField", "DataTextField", deskBookingPreferencesUpdateViewModel.Office);
            if (baseOfficeList.Any())
            {
                // S H I F T   L I S T
                var shiftList = await _selectTcmPLRepository.DeskBookOfficeShiftList(BaseSpTcmPLGet(), new ParameterSpTcmPL
                {
                    POffice = deskBookingPreferencesUpdateViewModel.Office
                });

                if (shiftList.Any())
                {
                    ViewData["ShiftList"] = new SelectList(shiftList, "DataValueField", "DataTextField", deskBookingPreferencesUpdateViewModel.Shift);
                    _ = shiftList.FirstOrDefault().DataValueField;
                }
                else
                {
                    ViewData["ShiftList"] = new SelectList(shiftList, "DataValueField", "DataTextField", deskBookingPreferencesUpdateViewModel.Shift);
                }

                IEnumerable<DataField> areaList = await _selectTcmPLRepository.DeskBookAreaForAssignmentList(BaseSpTcmPLGet(), new ParameterSpTcmPL
                {
                    POffice = deskBookingPreferencesUpdateViewModel.Office,
                    PEmpno = deskBookingPreferencesUpdateViewModel.Empno
                });
                ViewData["DeskAreas"] = new SelectList(areaList, "DataValueField", "DataTextField", deskBookingPreferencesUpdateViewModel.DeskArea);
            }

            return PartialView("_ModalDeskBookPreferencesUpdatePartial", deskBookingPreferencesUpdateViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [Authorize]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionDeskBookDept)]
        public async Task<JsonResult> GetListsAttendanceDate(string month, string parent, string[] employees)
        {
            try
            {
                var data = await _attendanceDateDataTableListRepository.AttendanceDateDataTableList(BaseSpTcmPLGet(), new ParameterSpTcmPL());

                return Json(data);
            }
            catch (Exception ex)
            {
                return Json(new { error = ex.Message });
            }
        }

        #endregion Employee Preference

        #region DeskAreaUserHodMapping

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionDeskBookDept)]
        public async Task<IActionResult> DeskAreaUserMapHodIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterDeskAreaUserMapHodIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            if (string.IsNullOrEmpty(filterDataModel.OfficeLocationCode))
            {
                filterDataModel.OfficeLocationCode = ConstFilterByLocationAiroli;
            }

            filterDataModel.IsDeskBooked ??= ConstFilterIsDeskBooked_Yes;

            DeskAreaUserMapHodViewModel DeskAreaUserMapHodViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(DeskAreaUserMapHodViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionDeskBookDept)]
        public async Task<IActionResult> GetListsDeskAreaUserMapHod(string paramJson)
        {
            DTResult<DeskAreaUserMapHodDataTableList> result = new();
            int totalRow = 0;
            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            System.Collections.Generic.IEnumerable<DeskAreaUserMapHodDataTableList> data = await _deskAreaUserMapHodDataTableListRepository.DeskAreaUserMapDataTableListAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PGenericSearch = param.GenericSearch ?? " ",
                    PAreaId = param.AreaId,
                    PCostCode = param.Costcode,
                    POfficeLocationCode = param.OfficeLocationCode,
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

            var retVal = Json(result);

            return retVal;
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionDeskBookDept)]
        public async Task<IActionResult> DeskAreaUserMapHodCreate()
        {
            DeskAreaUserMapHodCreateViewModel DeskAreaUserMapHodCreateViewModel = new();

            IEnumerable<DataField> departmentList = await _selectTcmPLRepository.DeskBookDepartmentListForHod(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["DepartmentList"] = new SelectList(departmentList, "DataValueField", "DataTextField");

            return PartialView("_ModalDeskAreaUserMapHodCreate", DeskAreaUserMapHodCreateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionDeskBookDept)]
        public async Task<IActionResult> DeskAreaUserMapHodCreate([FromForm] DeskAreaUserMapHodCreateViewModel deskAreaUserMapHodCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _deskAreaUserMapRequestRepository.SetDeskAreaUserMapAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PKeyId = null,
                            PAreaId = deskAreaUserMapHodCreateViewModel.AreaId,
                            PEmpno = deskAreaUserMapHodCreateViewModel.Employee,
                            PStartDate = deskAreaUserMapHodCreateViewModel.FromDate,
                            POfficeCode = deskAreaUserMapHodCreateViewModel.OfficeCode,
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

            IEnumerable<DataField> employeeList = await _selectTcmPLRepository.DeskBookEmployeeList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["EmployeeList"] = new SelectList(employeeList, "DataValueField", "DataTextField", deskAreaUserMapHodCreateViewModel.Employee);

            IEnumerable<DataField> baseOfficeList = await _selectTcmPLRepository.DeskBookingOfficeLocationList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
                PEmpno = deskAreaUserMapHodCreateViewModel.Employee
            });
            ViewData["BaseOfficeList"] = new SelectList(baseOfficeList, "DataValueField", "DataTextField");

            IEnumerable<DataField> areaList = await _selectTcmPLRepository.DeskBookAreaForAssignmentList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
                POffice = deskAreaUserMapHodCreateViewModel.OfficeCode,
                PEmpno = deskAreaUserMapHodCreateViewModel.Employee
            });
            ViewData["AreaList"] = new SelectList(areaList, "DataValueField", "DataTextField", deskAreaUserMapHodCreateViewModel.AreaId);

            return PartialView("_ModalDeskAreaUserMapHodCreate", deskAreaUserMapHodCreateViewModel);
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionDeskBookDept)]
        public async Task<IActionResult> DeskAreaUserMapHodEdit(string id, string empno)
        {
            try
            {
                DeskAreaUserMapHodUpdateViewModel deskAreaUserMapHodUpdateViewModel = new();

                if (id == null && empno == null)
                {
                    return NotFound();
                }

                var empdetails = await _commonEmployeeDetailsRepository.EmployeeDetailAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL
                {
                    PEmpno = empno
                });

                if (empdetails.PMessageType == IsOk)
                {
                    deskAreaUserMapHodUpdateViewModel.Employee = empdetails.PForEmpno;
                    deskAreaUserMapHodUpdateViewModel.BaseOffice = empdetails.PBaseOffice;
                    deskAreaUserMapHodUpdateViewModel.DeptCode = empdetails.PParent;
                    deskAreaUserMapHodUpdateViewModel.DeptName = empdetails.PCostName;
                    deskAreaUserMapHodUpdateViewModel.EmployeeName = empdetails.PName;
                }

                if (id != null)
                {
                    var result = await _deskAreaUserMapHodDetailRepository.DeskAreaUserMapDetail(
                                   BaseSpTcmPLGet(),
                                   new ParameterSpTcmPL
                                   {
                                       PKeyId = id
                                   });

                    if (result.PMessageType == IsOk)
                    {
                        deskAreaUserMapHodUpdateViewModel.KeyId = id;
                        deskAreaUserMapHodUpdateViewModel.AreaId = result.PAreaId;
                        deskAreaUserMapHodUpdateViewModel.FromDate = result.PFromDate;
                        deskAreaUserMapHodUpdateViewModel.OfficeCode = result.POfficeCode;
                    }
                }

                IEnumerable<DataField> baseOfficeList = await _selectTcmPLRepository.DeskBookingOfficeLocationList(BaseSpTcmPLGet(), new ParameterSpTcmPL
                {
                    PEmpno = empdetails.PForEmpno
                });

                ViewData["BaseOfficeList"] = new SelectList(baseOfficeList, "DataValueField", "DataTextField", deskAreaUserMapHodUpdateViewModel.OfficeCode);

                IEnumerable<DataField> areaList = await _selectTcmPLRepository.DeskBookAreaForAssignmentList(BaseSpTcmPLGet(), new ParameterSpTcmPL
                {
                    POffice = deskAreaUserMapHodUpdateViewModel.OfficeCode,
                    PEmpno = deskAreaUserMapHodUpdateViewModel.Employee
                });
                ViewData["AreaList"] = new SelectList(areaList, "DataValueField", "DataTextField", deskAreaUserMapHodUpdateViewModel.AreaId);

                return PartialView("_ModalDeskAreaUserMapHodUpdate", deskAreaUserMapHodUpdateViewModel);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionDeskBookDept)]
        public async Task<IActionResult> DeskAreaUserMapHodEdit([FromForm] DeskAreaUserMapHodUpdateViewModel deskAreaUserMapHodUpdateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput resultCreate = await _deskAreaUserMapRequestRepository.SetDeskAreaUserMapAsync(
                   BaseSpTcmPLGet(),
                   new ParameterSpTcmPL
                   {
                       PKeyId = deskAreaUserMapHodUpdateViewModel.KeyId,
                       PAreaId = deskAreaUserMapHodUpdateViewModel.AreaId,
                       PEmpno = deskAreaUserMapHodUpdateViewModel.Employee,
                       PStartDate = deskAreaUserMapHodUpdateViewModel.FromDate,
                       POfficeCode = deskAreaUserMapHodUpdateViewModel.OfficeCode,
                   });

                    return resultCreate.PMessageType == NotOk
                        ? throw new Exception(resultCreate.PMessageText.Replace("-", " "))
                        : (IActionResult)Json(new { success = true, response = resultCreate.PMessageText });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }

            IEnumerable<DataField> employeeList = await _selectTcmPLRepository.DeskBookEmployeeList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["EmployeeList"] = new SelectList(employeeList, "DataValueField", "DataTextField", deskAreaUserMapHodUpdateViewModel.Employee);

            IEnumerable<DataField> baseOfficeList = await _selectTcmPLRepository.DeskBookingOfficeLocationList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
                PEmpno = deskAreaUserMapHodUpdateViewModel.Employee
            });

            ViewData["BaseOfficeList"] = new SelectList(baseOfficeList, "DataValueField", "DataTextField", deskAreaUserMapHodUpdateViewModel.OfficeCode);

            IEnumerable<DataField> areaList = await _selectTcmPLRepository.DeskBookAreaForAssignmentList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
                POffice = deskAreaUserMapHodUpdateViewModel.OfficeCode,
                PEmpno = deskAreaUserMapHodUpdateViewModel.Employee
            });
            ViewData["AreaList"] = new SelectList(areaList, "DataValueField", "DataTextField", deskAreaUserMapHodUpdateViewModel.AreaId);

            return PartialView("_ModalDeskAreaUserMapHodUpdate", deskAreaUserMapHodUpdateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionDeskBookDept)]
        public async Task<IActionResult> DeskAreaUserMapHodDelete(string id)
        {
            try
            {
                var result = await _deskAreaUserMapRequestRepository.DeskAreaUserMapDeleteAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PKeyId = id
                    }
                    );

                return Json(new { success = result.PMessageType == IsOk, response = result.PMessageType, message = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionDeskBookDept)]
        public async Task<IActionResult> DeskAreaUserMapHodDetails(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var result = await _deskAreaUserMapHodDetailRepository.DeskAreaUserMapDetail(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PKeyId = id
                });

            DeskAreaUserMapHodDetailsViewModel DeskAreaUserMapHodDetailsViewModel = new();

            if (result.PMessageType == IsOk)
            {
                DeskAreaUserMapHodDetailsViewModel.KeyId = id;
                DeskAreaUserMapHodDetailsViewModel.AreaCatgCode = result.PAreaCatgCode;
                DeskAreaUserMapHodDetailsViewModel.AreaCatgDesc = result.PAreaCatgDesc;
                DeskAreaUserMapHodDetailsViewModel.AreaId = result.PAreaId;
                DeskAreaUserMapHodDetailsViewModel.AreaDesc = result.PAreaDesc;
                DeskAreaUserMapHodDetailsViewModel.EmpName = result.PEmpName;
                DeskAreaUserMapHodDetailsViewModel.EmpNo = result.PEmpNo;
                DeskAreaUserMapHodDetailsViewModel.ModifiedBy = result.PModifiedBy;
                DeskAreaUserMapHodDetailsViewModel.ModifiedOn = result.PModifiedOn;
                DeskAreaUserMapHodDetailsViewModel.OfficeCode = result.POfficeCode;
                DeskAreaUserMapHodDetailsViewModel.Office = result.POfficeCode;
            }

            return PartialView("_ModalDeskAreaUserMapHodDetails", DeskAreaUserMapHodDetailsViewModel);
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionDeskBookDept)]
        public async Task<IActionResult> DeskAreaUserMapHodExcelDownload()
        {
            var timeStamp = DateTime.Now.ToFileTime();

            string fileName = "Desk Area User Map List_" + timeStamp.ToString();
            string reportTitle = "Desk Area User Map List";
            string sheetName = "Desk Area User Map List";

            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterDeskAreaUserMapHodIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            if (string.IsNullOrEmpty(filterDataModel.OfficeLocationCode))
            {
                filterDataModel.OfficeLocationCode = ConstFilterByLocationAiroli;
            }

            IEnumerable<DeskAreaUserMapHodDataTableList> data = await _deskAreaUserMapHodDataTableListRepository.DeskAreaUserMapDataTableListForExcelAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PGenericSearch = filterDataModel.GenericSearch ?? " ",
                    PAreaId = filterDataModel.AreaId,
                    PCostCode = filterDataModel.Costcode,
                    POfficeLocationCode = filterDataModel.OfficeLocationCode
                });

            if (data == null) { return NotFound(); }

            var json = JsonConvert.SerializeObject(data);

            IEnumerable<DeskAreaUserMapHodDataTableExcel> excelData = JsonConvert.DeserializeObject<IEnumerable<DeskAreaUserMapHodDataTableExcel>>(json);

            var byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, reportTitle, sheetName);

            var mimeType = MimeTypeMap.GetMimeType("xlsx");

            FileContentResult file = File(byteContent, mimeType, fileName);

            return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
        }

        public async Task<IActionResult> DeskAreaUserMapHodFilterGet()
        {
            var retVal = await RetriveFilter(ConstFilterDeskAreaUserMapHodIndex);

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            IEnumerable<DataField> officeLocationList = await _selectTcmPLRepository.HRMISOfficeLocationList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["officeLocationList"] = new SelectList(officeLocationList, "DataValueField", "DataTextField");

            IEnumerable<DataField> areaList = await _selectTcmPLRepository.DeskBookDeskAreasForHod(BaseSpTcmPLGet(), new ParameterSpTcmPL { });
            ViewData["AreaList"] = new SelectList(areaList, "DataValueField", "DataTextField");

            IEnumerable<DataField> costCodeList = await _selectTcmPLRepository.DeskBookDepartmentListForHod(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["CostCodeList"] = new SelectList(costCodeList, "DataValueField", "DataTextField");

            return PartialView("_ModalDeskAreaUserMapHodFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> DeskAreaUserMapHodFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                string jsonFilter;
                jsonFilter = JsonConvert.SerializeObject(
                        new
                        {
                            filterDataModel.AreaId,
                            filterDataModel.CostCode,
                            filterDataModel.OfficeLocationCode,
                            filterDataModel.BookingDate,
                            filterDataModel.IsPresent,
                            filterDataModel.IsDeskBooked,
                        });

                _ = await CreateFilter(jsonFilter, ConstFilterDeskAreaUserMapHodIndex);

                return Json(new
                {
                    success = true,
                    areaId = filterDataModel.AreaId,
                    costCode = filterDataModel.CostCode,
                    officeLocationCode = filterDataModel.OfficeLocationCode,
                    bookingDate = filterDataModel.BookingDate,
                    isPresent = filterDataModel.IsPresent,
                    isDeskBooked = filterDataModel.IsDeskBooked,
                });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        #endregion DeskAreaUserHodMapping

        #region Create_Retrive__Reset_Filter

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

        #endregion Create_Retrive__Reset_Filter

        #region SelectListFunctions

        [HttpGet]
        public async Task<IActionResult> GetObjIdList(string objTypeId)
        {
            var objIdList = await _selectTcmPLRepository.DeskBookObjIdList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
                PObjId = objTypeId
            });

            return Json(objIdList);
        }

        [HttpGet]
        public async Task<IActionResult> GetDeskAreaList()
        {
            var deskAreaList = await _selectTcmPLRepository.DeskBookDeskAreasForHod(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            return Json(deskAreaList);
        }

        [HttpGet]
        public async Task<IActionResult> GetDeskList()
        {
            _ = await _deskBookingDetailsRepository.DeskBookingDetailsAsync(
                   BaseSpTcmPLGet(), new ParameterSpTcmPL());

            var deskList = await _selectTcmPLRepository.DeskBookDeskList(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            return Json(deskList);
        }

        [HttpGet]
        public async Task<IActionResult> GetDeskListForBooking(string office, DateTime? selectedDate, string shift)
        {
            if (office == null || selectedDate == null || shift == null)
            {
                return Json(null);
            }

            var deskList = await _selectTcmPLRepository.DeskBookAvailableDesks(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
                POffice = office,
                PDate = selectedDate,
                PShift = shift
            });

            return Json(deskList);
        }

        [HttpGet]
        public async Task<IActionResult> GetEmployeeList(string costcode)
        {
            var employeeList = await _selectTcmPLRepository.DeskBookEmployeeListForHod(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
                PCostCode = costcode
            });

            return Json(employeeList);
        }

        [HttpGet]
        public async Task<IActionResult> GetOfficeListForHod(string employee)
        {
            var empdetails = await _commonEmployeeDetailsRepository.EmployeeDetailAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
                PEmpno = employee
            });

            var TagList = await _selectTcmPLRepository.DeskBookingTagForEmpList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
                PEmpno = empdetails.PForEmpno
            });

            var OfficeList = await _selectTcmPLRepository.DeskBookingOfficeLocationList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
                PEmpno = empdetails.PForEmpno
            });
            return Json(new { OfficeList, TagList, BaseOfficeLocation = empdetails.PCurrentOfficeLocation });
        }

        [HttpGet]
        public async Task<IActionResult> GetDeskAreaListForHod(string office, string employee)
        {
            var empdetails = await _commonEmployeeDetailsRepository.EmployeeDetailAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
                PEmpno = employee
            });

            var deskAreaList = await _selectTcmPLRepository.DeskBookAreaForAssignmentList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
                POffice = office,
                PEmpno = empdetails.PForEmpno
            });

            return Json(deskAreaList);
        }

        #endregion SelectListFunctions

        #region AreaWiseDeskBooking

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionDeskBookDept)]
        public async Task<IActionResult> AreaWiseDeskBookingIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterAreaWiseDeskBookingIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            AreaWiseDeskBookingViewModel areaWiseDeskBookingViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(areaWiseDeskBookingViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionDeskBookDept)]
        public async Task<JsonResult> GetListsAreaWiseDeskBooking(string paramJson)
        {
            DTResult<AreaWiseDeskBookingDataTableList> result = new();
            int totalRow = 0;
            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            try
            {
                System.Collections.Generic.IEnumerable<AreaWiseDeskBookingDataTableList> data = await _areaWiseDeskBookingDataTableListRepository.AreaWiseDeskBookingDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch ?? " ",
                        PAreaCatgCode = ConstAreaCatgCode,
                        PAreaId = param.AreaId,
                        POffice = param.Office,
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

        public async Task<IActionResult> AreaWiseDeskBookingFilterGet()
        {
            var retVal = await RetriveFilter(ConstFilterAreaWiseDeskBookingIndex);

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            IEnumerable<DataField> areaList = await _selectTcmPLRepository.AreaList4AreaCatgCodeWise(BaseSpTcmPLGet(), new ParameterSpTcmPL { PAreaCatgCode = ConstAreaCatgCode });
            ViewData["AreaList"] = new SelectList(areaList, "DataValueField", "DataTextField");

            var officeList = await _selectTcmPLRepository.DmsOfficeList(BaseSpTcmPLGet(), null);
            ViewData["OfficeList"] = new SelectList(officeList, "DataValueField", "DataTextField");

            return PartialView("_ModalAreaWiseDeskBookingFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> AreaWiseDeskBookingFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                string jsonFilter;
                jsonFilter = JsonConvert.SerializeObject(
                        new
                        {
                            filterDataModel.AreaId,
                            filterDataModel.Office
                        });

                _ = await CreateFilter(jsonFilter, ConstFilterAreaWiseDeskBookingIndex);

                return Json(new
                {
                    success = true,
                    areaId = filterDataModel.AreaId,
                    office = filterDataModel.Office
                });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionDeskBookDept)]
        public async Task<IActionResult> AreaWiseDeskBookingExcelDownload()
        {
            var timeStamp = DateTime.Now.ToFileTime();

            string fileName = "Area Wise Desk Booking List_" + timeStamp.ToString();
            string reportTitle = "Area Wise Desk Booking List";
            string sheetName = "Area Wise Desk Booking List";

            IEnumerable<AreaWiseDeskBookingDataTableList> data = await _areaWiseDeskBookingDataTableListRepository.AreaWiseDeskBookingDataTableListForExcelAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                });

            if (data == null) { return NotFound(); }

            var json = JsonConvert.SerializeObject(data);

            IEnumerable<AreaWiseDeskBookingDataTableExcel> excelData = JsonConvert.DeserializeObject<IEnumerable<AreaWiseDeskBookingDataTableExcel>>(json);

            var byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, reportTitle, sheetName);

            var mimeType = MimeTypeMap.GetMimeType("xlsx");

            FileContentResult file = File(byteContent, mimeType, fileName);

            return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
        }

        #endregion AreaWiseDeskBooking

        #region SummaryIndex

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionDeskBookDept)]
        public async Task<IActionResult> SummaryIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterSummaryIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            SummaryViewModel summaryViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(summaryViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionDeskBookDept)]
        public async Task<JsonResult> GetListsSummary(string paramJson)
        {
            DTResult<SummaryDataTableList> result = new();
            int totalRow = 0;
            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            try
            {
                System.Collections.Generic.IEnumerable<SummaryDataTableList> data = await _summaryDataTableListRepository.SummaryDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch ?? " ",
                        PAreaId = param.AreaId,
                        POffice = param.Office,
                        POfficeLocationCode = param.OfficeLocationCode,
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

        public async Task<IActionResult> SummaryFilterGet()
        {
            var retVal = await RetriveFilter(ConstFilterSummaryIndex);

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            IEnumerable<DataField> areaList = await _selectTcmPLRepository.DmsAreaList(BaseSpTcmPLGet(), new ParameterSpTcmPL { });
            ViewData["AreaList"] = new SelectList(areaList, "DataValueField", "DataTextField");

            IEnumerable<DataField> officeList = await _selectTcmPLRepository.DmsOfficeList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["OfficeList"] = new SelectList(officeList, "DataValueField", "DataTextField");

            IEnumerable<DataField> baseOfficeList = await _selectTcmPLRepository.HRMISOfficeLocationList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["BaseOfficeList"] = new SelectList(baseOfficeList, "DataValueField", "DataTextField");

            return PartialView("_ModalSummaryFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> SummaryFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                string jsonFilter;
                jsonFilter = JsonConvert.SerializeObject(
                        new
                        {
                            filterDataModel.AreaId,
                            filterDataModel.Office,
                            filterDataModel.OfficeLocationCode,
                        });

                _ = await CreateFilter(jsonFilter, ConstFilterSummaryIndex);

                return Json(new
                {
                    success = true,
                    areaId = filterDataModel.AreaId,
                    office = filterDataModel.Office,
                    officeLocationCode = filterDataModel.OfficeLocationCode,
                });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        #endregion SummaryIndex

        #region DeskBookAttendanceHod

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionDeskBookDept)]
        public async Task<IActionResult> DeskBookAttendanceHodIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterDeskBookAttendanceHodIndex
            });

            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            DeskBookAttendanceHodViewModel DeskBookAttendanceHodViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            if (filterDataModel.BookingDate == null)
            {
                var bookingDatesList = await _selectTcmPLRepository.DeskBookDatesList(BaseSpTcmPLGet(), new ParameterSpTcmPL());

                filterDataModel.BookingDate = bookingDatesList.Reverse().FirstOrDefault().DataValueField;
            }

            return View(DeskBookAttendanceHodViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionDeskBookDept)]
        public async Task<IActionResult> GetListsDeskBookAttendanceHod(string paramJson)
        {
            DTResult<DeskBookAttendanceHodDataTableList> result = new();
            int totalRow = 0;
            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            System.Collections.Generic.IEnumerable<DeskBookAttendanceHodDataTableList> data = await _deskBookAttendanceHodDataTableListRepository.DeskBookAttendanceDataTableListAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PGenericSearch = param.GenericSearch ?? " ",
                    PAreaId = param.AreaId,
                    PCostCode = param.Costcode,
                    PAttendanceDate = DateTime.ParseExact(param.BookingDate, "yyyyMMdd", CultureInfo.InvariantCulture),
                    PIsPresent = param.IsPresent,
                    PIsDeskBooked = param.IsDeskBooked,
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

            var retVal = Json(result);

            return retVal;
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionDeskBookDept)]
        public async Task<IActionResult> DeskBookAttendanceHodHistoryIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterDeskBookAttendanceHodHistoryIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            DeskBookAttendanceHodHistoryViewModel DeskBookAttendanceHodHistoryViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(DeskBookAttendanceHodHistoryViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionDeskBookDept)]
        public async Task<IActionResult> GetListsDeskBookAttendanceHodHistory(string paramJson)
        {
            DTResult<DeskBookAttendanceHodDataTableList> result = new();
            int totalRow = 0;
            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            System.Collections.Generic.IEnumerable<DeskBookAttendanceHodDataTableList> data = await _deskBookAttendanceHodDataTableListRepository.DeskBookAttendanceHistoryDataTableListAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PGenericSearch = param.GenericSearch ?? " ",
                    PAreaId = param.AreaId,
                    PCostCode = param.Costcode,
                    PIsPresent = param.IsPresent,
                    PIsDeskBooked = param.IsDeskBooked,
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

            var retVal = Json(result);

            return retVal;
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionDeskBookDept)]
        public async Task<IActionResult> DeskBookAttendanceHodExcelDownload()
        {
            var timeStamp = DateTime.Now.ToFileTime();

            string fileName = "Desk Book List_" + timeStamp.ToString();
            string reportTitle = "Desk Book List";
            string sheetName = "Desk Book Attendance List";

            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterDeskBookAttendanceHodIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            if (string.IsNullOrEmpty(filterDataModel.OfficeLocationCode))
            {
                filterDataModel.OfficeLocationCode = ConstFilterByLocationAiroli;
            }

            IEnumerable<DeskBookAttendanceHodDataTableList> data = await _deskBookAttendanceHodDataTableListRepository.DeskBookAttendanceXLDataTableListAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PGenericSearch = filterDataModel.GenericSearch ?? " ",
                    PAreaId = filterDataModel.AreaId,
                    PCostCode = filterDataModel.Costcode,
                    PAttendanceDate = null
                });

            if (data == null) { return NotFound(); }

            var json = JsonConvert.SerializeObject(data);

            IEnumerable<DeskBookAttendanceHodDataTableExcel> excelData = JsonConvert.DeserializeObject<IEnumerable<DeskBookAttendanceHodDataTableExcel>>(json);

            var byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, reportTitle, sheetName);

            var mimeType = MimeTypeMap.GetMimeType("xlsx");

            FileContentResult file = File(byteContent, mimeType, fileName);

            return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
        }

        public async Task<IActionResult> DeskBookAttendanceHodFilterGet()
        {
            var retVal = await RetriveFilter(ConstFilterDeskBookAttendanceHodIndex);

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            IEnumerable<DataField> officeList = await _selectTcmPLRepository.HRMISOfficeLocationList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["OfficeList"] = new SelectList(officeList, "DataValueField", "DataTextField");

            IEnumerable<DataField> areaList = await _selectTcmPLRepository.DeskBookDeskAreasForHod(BaseSpTcmPLGet(), new ParameterSpTcmPL { });
            ViewData["AreaList"] = new SelectList(areaList, "DataValueField", "DataTextField");

            IEnumerable<DataField> costCodeList = await _selectTcmPLRepository.DeskBookDepartmentListForHod(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["CostCodeList"] = new SelectList(costCodeList, "DataValueField", "DataTextField");

            var bookingDatesList = await _selectTcmPLRepository.DeskBookDatesList(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            var strSelectedDate = bookingDatesList.Reverse().FirstOrDefault().DataValueField;

            ViewData["BookingDatesList"] = new SelectList(bookingDatesList.Reverse(), "DataValueField", "DataTextField", strSelectedDate);

            return PartialView("_ModalDeskBookAttendanceHodFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> DeskBookAttendanceHodFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                string jsonFilter;
                jsonFilter = JsonConvert.SerializeObject(
                        new
                        {
                            filterDataModel.AreaId,
                            filterDataModel.CostCode,
                            filterDataModel.OfficeLocationCode,
                            filterDataModel.BookingDate,
                            filterDataModel.IsPresent,
                            filterDataModel.IsDeskBooked,
                        });

                _ = await CreateFilter(jsonFilter, ConstFilterDeskBookAttendanceHodIndex);

                return Json(new
                {
                    success = true,
                    areaId = filterDataModel.AreaId,
                    costCode = filterDataModel.CostCode,
                    officeLocationCode = filterDataModel.OfficeLocationCode,
                    bookingDate = filterDataModel.BookingDate,
                    isPresent = filterDataModel.IsPresent,
                    isDeskBooked = filterDataModel.IsDeskBooked,
                });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        public async Task<IActionResult> DeskBookAttendanceHodHistoryFilterGet()
        {
            var retVal = await RetriveFilter(ConstFilterDeskBookAttendanceHodHistoryIndex);

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            IEnumerable<DataField> officeList = await _selectTcmPLRepository.HRMISOfficeLocationList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["OfficeList"] = new SelectList(officeList, "DataValueField", "DataTextField");

            IEnumerable<DataField> areaList = await _selectTcmPLRepository.DeskBookDeskAreasForHod(BaseSpTcmPLGet(), new ParameterSpTcmPL { });
            ViewData["AreaList"] = new SelectList(areaList, "DataValueField", "DataTextField");

            IEnumerable<DataField> costCodeList = await _selectTcmPLRepository.DeskBookDepartmentListForHod(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["CostCodeList"] = new SelectList(costCodeList, "DataValueField", "DataTextField");

            return PartialView("_ModalDeskBookAttendanceHodHistoryFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> DeskBookAttendanceHodHistoryFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                string jsonFilter;
                jsonFilter = JsonConvert.SerializeObject(
                        new
                        {
                            filterDataModel.AreaId,
                            filterDataModel.CostCode,
                            filterDataModel.OfficeLocationCode,
                            filterDataModel.IsPresent,
                            filterDataModel.IsDeskBooked,
                        });

                _ = await CreateFilter(jsonFilter, ConstFilterDeskBookAttendanceHodHistoryIndex);

                return Json(new
                {
                    success = true,
                    areaId = filterDataModel.AreaId,
                    costCode = filterDataModel.CostCode,
                    officeLocationCode = filterDataModel.OfficeLocationCode,
                    isPresent = filterDataModel.IsPresent,
                    isDeskBooked = filterDataModel.IsDeskBooked,
                });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionDeskBookDept)]
        public async Task<IActionResult> DeskBookAttendanceHodDelete(string id)
        {
            try
            {
                var result = await _deskBookingRepository.ReleaseDeskAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL { PKeyId = id }
                    );

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionDeskBookDept)]
        public async Task<IActionResult> DeskBookAttendanceHodHistoryExcelDownload()
        {
            var timeStamp = DateTime.Now.ToFileTime();

            string fileName = "Desk Book List_" + timeStamp.ToString();
            string reportTitle = "Desk Book List";
            string sheetName = "Desk Book List";

            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterDeskBookAttendanceHodHistoryIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            if (string.IsNullOrEmpty(filterDataModel.OfficeLocationCode))
            {
                filterDataModel.OfficeLocationCode = ConstFilterByLocationAiroli;
            }

            IEnumerable<DeskBookAttendanceHodDataTableList> data = await _deskBookAttendanceHodDataTableListRepository.DeskBookAttendanceHistoryXLDataTableListAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PGenericSearch = filterDataModel.GenericSearch ?? " ",
                    PAreaId = filterDataModel.AreaId,
                    PCostCode = filterDataModel.Costcode,
                    PAttendanceDate = null
                });

            if (data == null) { return NotFound(); }

            var json = JsonConvert.SerializeObject(data);

            IEnumerable<DeskBookAttendanceHodDataTableExcel> excelData = JsonConvert.DeserializeObject<IEnumerable<DeskBookAttendanceHodDataTableExcel>>(json);

            var byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, reportTitle, sheetName);

            var mimeType = MimeTypeMap.GetMimeType("xlsx");

            FileContentResult file = File(byteContent, mimeType, fileName);

            return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
        }

        #endregion DeskBookAttendanceHod

        #region CrossBookingSummary

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionDeskBookDept)]
        public async Task<IActionResult> CrossBookingSummaryHodExcelDownload()
        {
            var timeStamp = DateTime.Now.ToFileTime();

            string fileName = "Cross Desk Book List_" + timeStamp.ToString();
            string reportTitle = "Cross Desk BookList";
            string sheetName = "Cross Desk Book List";

            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterDeskBookAttendanceHodIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            if (string.IsNullOrEmpty(filterDataModel.OfficeLocationCode))
            {
                filterDataModel.OfficeLocationCode = ConstFilterByLocationAiroli;
            }

            IEnumerable<CrossBookingSummaryDataTableListXL> data = await _crossBookingSummaryXLListRepository.CrossBookingSummaryXLForHodListAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                });

            if (data == null) { return NotFound(); }

            var byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(data, reportTitle, sheetName);

            var mimeType = MimeTypeMap.GetMimeType("xlsx");

            FileContentResult file = File(byteContent, mimeType, fileName);

            return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionDeskBookAdmin)]
        public async Task<IActionResult> CrossBookingSummaryDmsExcelDownload()
        {
            var timeStamp = DateTime.Now.ToFileTime();

            string fileName = "Cross Desk Book List_" + timeStamp.ToString();
            string reportTitle = "Cross Desk Book List";
            string sheetName = "Cross Desk Book List";

            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterDeskBookAttendanceHodIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            if (string.IsNullOrEmpty(filterDataModel.OfficeLocationCode))
            {
                filterDataModel.OfficeLocationCode = ConstFilterByLocationAiroli;
            }

            IEnumerable<CrossBookingSummaryDataTableListXL> data = await _crossBookingSummaryXLListRepository.CrossBookingSummaryXLForDmsListAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                });

            if (data == null) { return NotFound(); }

            var byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(data, reportTitle, sheetName);

            var mimeType = MimeTypeMap.GetMimeType("xlsx");

            FileContentResult file = File(byteContent, mimeType, fileName);

            return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
        }

        #endregion CrossBookingSummary

        #region BookingSummary

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionDeskBookDept)]
        public async Task<IActionResult> BookingSummaryIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterBookingSummaryIndex
            });
            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            if (string.IsNullOrEmpty(filterDataModel.Office))
            {
                filterDataModel.Office = ConstFilterByOffice;
            }

            if (filterDataModel.BookingDate == null)
            {
                var bookingDatesList = await _selectTcmPLRepository.DeskBookDatesList(BaseSpTcmPLGet(), new ParameterSpTcmPL());

                filterDataModel.BookingDate = bookingDatesList.Reverse().FirstOrDefault().DataValueField;
            }

            BookingSummaryViewModel bookingSummaryViewModel = new()
            {
                FilterDataModel = filterDataModel,
                ActionId = DeskBookingHelper.ActionDeskBookDept
            };

            return View(bookingSummaryViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionDeskBookDept)]
        public async Task<JsonResult> GetListsBookingSummary(string paramJson)
        {
            DTResult<BookingSummaryDataTableList> result = new();
            int totalRow = 0;
            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            try
            {
                var dd = DateTime.ParseExact(param.BookingDate, "yyyyMMdd", CultureInfo.InvariantCulture);
                System.Collections.Generic.IEnumerable<BookingSummaryDataTableList> data = await _bookingSummaryDataTableListRepository.BookingSummaryDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch ?? " ",
                        POffice = param.Office,
                        PDate = DateTime.ParseExact(param.BookingDate, "yyyyMMdd", CultureInfo.InvariantCulture),
                        PActionId = param.ActionId,
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

        public async Task<IActionResult> BookingSummaryFilterGet()
        {
            var retVal = await RetriveFilter(ConstFilterBookingSummaryIndex);

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            var bookingDatesList = await _selectTcmPLRepository.DeskBookDatesList(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            var strSelectedDate = bookingDatesList.Reverse().FirstOrDefault().DataValueField;

            ViewData["BookingDatesList"] = new SelectList(bookingDatesList.Reverse(), "DataValueField", "DataTextField", strSelectedDate);

            IEnumerable<DataField> officeList = await _selectTcmPLRepository.DmsOfficeList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["OfficeList"] = new SelectList(officeList, "DataValueField", "DataTextField");

            return PartialView("_ModalBookingSummaryFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> BookingSummaryFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                string jsonFilter;
                jsonFilter = JsonConvert.SerializeObject(
                        new
                        {
                            filterDataModel.Office,
                            filterDataModel.BookingDate,
                        });

                _ = await CreateFilter(jsonFilter, ConstFilterBookingSummaryIndex);

                return Json(new
                {
                    success = true,
                    office = filterDataModel.Office,
                    bookingDate = filterDataModel.BookingDate,
                });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionDeskBookDept)]
        public async Task<IActionResult> BookingSummaryDetailIndex(string office, string workArea, string bookingDate, string assign)
        {
            try
            {
                var bookingDateConvert = DateTime.ParseExact(bookingDate, "yyyyMMdd", CultureInfo.InvariantCulture);

                var bookingSummaryDetails = await _bookingSummaryDetailRepository.BookingSummaryDetail(BaseSpTcmPLGet(),
                               new ParameterSpTcmPL
                               {
                                   POffice = office,
                                   PDate = bookingDateConvert,
                                   PAreaId = workArea,
                                   PCostcode = assign
                               }
                           );

                BookingSummaryDetailsViewModel bookingSummaryDetailsViewModel = new()
                {
                    Office = office,
                    AreaId = workArea,
                    BookingDate = bookingDateConvert,
                    bookingDate = bookingDate,
                    AreaDesc = bookingSummaryDetails.PAreaDesc,
                    DeskCount = bookingSummaryDetails.PDeskCount,
                    DeptEmpnoCount = bookingSummaryDetails.PDeptEmpnoCount,
                    BookedDesks = bookingSummaryDetails.PBookedDesks,
                    Costcode = assign,
                    ActionId = DeskBookingHelper.ActionDeskBookDept
                };

                return View("BookingSummaryDetailIndex", bookingSummaryDetailsViewModel);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionDeskBookDept)]
        public async Task<IActionResult> DeskListDetailIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterDeskListDetailsIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            DeskListViewModel deskListViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return PartialView("_DeskListPartial", deskListViewModel);
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionDeskBookDept)]
        public async Task<JsonResult> GetListsDeskList(string paramJSon)
        {
            DTResult<DeskListDataTableList> result = new();

            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJSon);

            int totalRow = 0;
            try
            {
                System.Collections.Generic.IEnumerable<DeskListDataTableList> data = await _deskListDataTableListRepository.DeskListDataTableListAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PGenericSearch = param.GenericSearch ?? " ",
                            POffice = param.Office,
                            PAreaId = param.AreaId,
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

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionDeskBookDept)]
        public async Task<IActionResult> EmpBookedDeskListDetailsIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterEmpBookedDeskListDetailsIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            EmpBookedDeskListViewModel empBookedDeskListViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return PartialView("_EmpBookedDeskListPartial", empBookedDeskListViewModel);
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionDeskBookDept)]
        public async Task<JsonResult> GetListsEmpBookedDeskList(string paramJSon)
        {
            DTResult<EmpBookedDeskListDataTableList> result = new();

            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJSon);

            int totalRow = 0;
            try
            {
                System.Collections.Generic.IEnumerable<EmpBookedDeskListDataTableList> data = await _empBookedDeskListDataTableListRepository.EmpBookedDeskListDataTableListAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PGenericSearch = param.GenericSearch ?? " ",
                            POffice = param.Office,
                            PAreaId = param.AreaId,
                            PDate = DateTime.ParseExact(param.BookingDate, "yyyyMMdd", CultureInfo.InvariantCulture),
                            PCostcode = param.Costcode,
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

        public async Task<IActionResult> BookingSummaryExcelDownload(string id)
        {
            try
            {
                string excelFileName = "DeskBookSummary.xlsx";
                string SummaryDataTable = "Summary";
                string DeskListDataTable = "DeskLists";
                //string DeptEmpListDataTable = "DeptEmpList";
                string BookedEmpListDataTable = "EmpList";
                string dataSheetName1 = "Summary";
                string dataSheetName2 = "DeskList";
                //string dataSheetName3 = "DeptEmpList";
                string dataSheetName3 = "EmpList";

                var retVal = await RetriveFilter(ConstFilterBookingSummaryIndex);

                FilterDataModel filterDataModel = new();

                if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                {
                    filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
                }

                if (filterDataModel.BookingDate == null)
                {
                    var bookingDatesList = await _selectTcmPLRepository.DeskBookDatesList(BaseSpTcmPLGet(), new ParameterSpTcmPL());

                    filterDataModel.BookingDate = bookingDatesList.Reverse().FirstOrDefault().DataValueField;
                }
                if (string.IsNullOrEmpty(filterDataModel.Office))
                {
                    filterDataModel.Office = ConstFilterByOffice;
                }

                var BookingDate = DateTime.ParseExact(filterDataModel.BookingDate, "yyyyMMdd", CultureInfo.InvariantCulture);

                var data = await _bookingSummaryXLReport.BookingSummaryXLReportAsync(BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        POffice = filterDataModel.Office,
                        PDate = BookingDate,
                        PActionId = id
                    });

                if (data == null) { return Json(ResponseHelper.GetMessageObject("No Data Found.", NotificationType.error)); }

                string stringFileName = "BookingSummary";

                string reportTitle = "Booking details of Office - " + filterDataModel.Office + " and Date - " + BookingDate.Day + "-" + BookingDate.ToString("MMM", CultureInfo.InvariantCulture) + "-" + BookingDate.Year;
                byte[] byteContent1 = null;

                byte[] templateBytes = System.IO.File.ReadAllBytes(StorageHelper.GetTemplateFilePath(StorageHelper.DeskBooking.RepositoryDeskBooking, FileName: excelFileName, Configuration));

                using (MemoryStream templateStream = new())
                {
                    templateStream.Write(templateBytes, 0, templateBytes.Length);

                    using (SpreadsheetDocument spreadsheetDocument = SpreadsheetDocument.Open(templateStream, true))
                    {
                        XLBookWriter.SetCellValue(spreadsheetDocument, dataSheetName1, "A1", reportTitle);
                        if (data.PSummaryList != null)
                        {
                            XLBookWriter.AppendDataInExcel(spreadsheetDocument, dataSheetName1, SummaryDataTable, data.PSummaryList);
                        }

                        XLBookWriter.SetCellValue(spreadsheetDocument, dataSheetName2, "A1", reportTitle);
                        if (data.PDeskList != null)
                        {
                            XLBookWriter.AppendDataInExcel(spreadsheetDocument, dataSheetName2, DeskListDataTable, data.PDeskList);
                        }
                        //if (data.PDeptEmpList != null)
                        //{
                        //    XLBookWriter.AppendDataInExcel(spreadsheetDocument, dataSheetName3, DeptEmpListDataTable, data.PDeptEmpList);
                        //}

                        XLBookWriter.SetCellValue(spreadsheetDocument, dataSheetName3, "A1", reportTitle);
                        if (data.PBookedEmpList != null)
                        {
                            XLBookWriter.AppendDataInExcel(spreadsheetDocument, dataSheetName3, BookedEmpListDataTable, data.PBookedEmpList);
                        }

                        XLBookWriter.SetCellValue(spreadsheetDocument, "Pivot", "A1", reportTitle);

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

        public async Task<IActionResult> DeptBookingSummaryExcelDownload(string id, string office, string areaId, string bookingDate, string costcode)
        {
            try
            {
                string excelFileName = "DeskBookSummaryDept.xlsx";
                string SummaryDataTable = "EmpList";
                string dataSheetName1 = "EmpList";

                var BookingDate = DateTime.ParseExact(bookingDate, "yyyyMMdd", CultureInfo.InvariantCulture);

                var data = await _bookingSummaryDeptXLReport.BookingSummaryDeptXLReportAsync(BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            POffice = office,
                            PDate = BookingDate,
                            PActionId = id,
                            PAreaId = areaId,
                            PCostcode = costcode
                        });

                if (data == null) { return Json(ResponseHelper.GetMessageObject("No Data Found.", NotificationType.error)); }

                string stringFileName = "DeptBookingSummary";

                string reportTitle = "Booking details of Office - " + office + ", Dept - " + costcode + " and Date - " + BookingDate.Day + "-" + BookingDate.ToString("MMM", CultureInfo.InvariantCulture) + "-" + BookingDate.Year;
                byte[] byteContent1 = null;

                byte[] templateBytes = System.IO.File.ReadAllBytes(StorageHelper.GetTemplateFilePath(StorageHelper.DeskBooking.RepositoryDeskBooking, FileName: excelFileName, Configuration));

                using (MemoryStream templateStream = new())
                {
                    templateStream.Write(templateBytes, 0, templateBytes.Length);

                    using (SpreadsheetDocument spreadsheetDocument = SpreadsheetDocument.Open(templateStream, true))
                    {
                        XLBookWriter.SetCellValue(spreadsheetDocument, "EmpList", "A1", reportTitle);
                        if (data.PBookedEmpList != null)
                        {
                            XLBookWriter.AppendDataInExcel(spreadsheetDocument, dataSheetName1, SummaryDataTable, data.PBookedEmpList);
                        }

                        XLBookWriter.SetCellValue(spreadsheetDocument, "Pivot", "A1", reportTitle);

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

        #endregion BookingSummary

        #region AdminBookingSummary

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionDeskBookAdmin)]
        public async Task<IActionResult> AdminBookingSummaryIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterAdminBookingSummaryIndex
            });
            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            if (string.IsNullOrEmpty(filterDataModel.Office))
            {
                filterDataModel.Office = ConstFilterByOffice;
            }

            if (filterDataModel.BookingDate == null)
            {
                var bookingDatesList = await _selectTcmPLRepository.DeskBookDatesList(BaseSpTcmPLGet(), new ParameterSpTcmPL());

                filterDataModel.BookingDate = bookingDatesList.Reverse().FirstOrDefault().DataValueField;
            }

            BookingSummaryViewModel bookingSummaryViewModel = new()
            {
                FilterDataModel = filterDataModel,
                ActionId = DeskBookingHelper.ActionDeskBookAdmin
            };

            return View(bookingSummaryViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionDeskBookAdmin)]
        public async Task<JsonResult> GetListsAdminBookingSummary(string paramJson)
        {
            DTResult<BookingSummaryDataTableList> result = new();
            int totalRow = 0;
            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            try
            {
                var dd = DateTime.ParseExact(param.BookingDate, "yyyyMMdd", CultureInfo.InvariantCulture);
                System.Collections.Generic.IEnumerable<BookingSummaryDataTableList> data = await _bookingSummaryDataTableListRepository.BookingSummaryDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch ?? " ",
                        POffice = param.Office,
                        PDate = DateTime.ParseExact(param.BookingDate, "yyyyMMdd", CultureInfo.InvariantCulture),
                        PActionId = param.ActionId,
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

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionDeskBookAdmin)]
        public async Task<IActionResult> AdminBookingSummaryDetailIndex(string office, string workArea, string bookingDate, string assign)
        {
            try
            {
                var bookingDateConvert = DateTime.ParseExact(bookingDate, "yyyyMMdd", CultureInfo.InvariantCulture);

                var bookingSummaryDetails = await _bookingSummaryDetailRepository.BookingSummaryDetail(BaseSpTcmPLGet(),
                               new ParameterSpTcmPL
                               {
                                   POffice = office,
                                   PDate = bookingDateConvert,
                                   PAreaId = workArea,
                                   PCostcode = assign
                               }
                           );

                BookingSummaryDetailsViewModel bookingSummaryDetailsViewModel = new()
                {
                    Office = office,
                    AreaId = workArea,
                    BookingDate = bookingDateConvert,
                    bookingDate = bookingDate,
                    AreaDesc = bookingSummaryDetails.PAreaDesc,
                    DeskCount = bookingSummaryDetails.PDeskCount,
                    DeptEmpnoCount = bookingSummaryDetails.PDeptEmpnoCount,
                    BookedDesks = bookingSummaryDetails.PBookedDesks,
                    Costcode = assign,
                    ActionId = DeskBookingHelper.ActionDeskBookAdmin
                };

                return View("AdminBookingSummaryDetailIndex", bookingSummaryDetailsViewModel);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        public async Task<IActionResult> AdminBookingSummaryFilterGet()
        {
            var retVal = await RetriveFilter(ConstFilterAdminBookingSummaryIndex);

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            var bookingDatesList = await _selectTcmPLRepository.DeskBookDatesList(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            var strSelectedDate = bookingDatesList.Reverse().FirstOrDefault().DataValueField;

            ViewData["BookingDatesList"] = new SelectList(bookingDatesList.Reverse(), "DataValueField", "DataTextField", strSelectedDate);

            IEnumerable<DataField> officeList = await _selectTcmPLRepository.DmsOfficeList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["OfficeList"] = new SelectList(officeList, "DataValueField", "DataTextField");

            return PartialView("_ModalAdminBookingSummaryFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> AdminBookingSummaryFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                string jsonFilter;
                jsonFilter = JsonConvert.SerializeObject(
                        new
                        {
                            filterDataModel.Office,
                            filterDataModel.BookingDate,
                        });

                _ = await CreateFilter(jsonFilter, ConstFilterAdminBookingSummaryIndex);

                return Json(new
                {
                    success = true,
                    office = filterDataModel.Office,
                    bookingDate = filterDataModel.BookingDate,
                });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionDeskBookAdmin)]
        public async Task<IActionResult> AdminDeskListDetailIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterAdminDeskListDetailsIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            DeskListViewModel deskListViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return PartialView("_AdminDeskListPartial", deskListViewModel);
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionDeskBookAdmin)]
        public async Task<JsonResult> GetListsAdminDeskList(string paramJSon)
        {
            DTResult<DeskListDataTableList> result = new();

            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJSon);

            int totalRow = 0;
            try
            {
                System.Collections.Generic.IEnumerable<DeskListDataTableList> data = await _deskListDataTableListRepository.DeskListDataTableListAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PGenericSearch = param.GenericSearch ?? " ",
                            POffice = param.Office,
                            PAreaId = param.AreaId,
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

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionDeskBookAdmin)]
        public async Task<IActionResult> AdminEmpBookedDeskListDetailsIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterAdminEmpBookedDeskListDetailsIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            EmpBookedDeskListViewModel empBookedDeskListViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return PartialView("_AdminEmpBookedDeskListPartial", empBookedDeskListViewModel);
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionDeskBookAdmin)]
        public async Task<JsonResult> GetListsAdminEmpBookedDeskList(string paramJSon)
        {
            DTResult<EmpBookedDeskListDataTableList> result = new();

            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJSon);

            int totalRow = 0;
            try
            {
                System.Collections.Generic.IEnumerable<EmpBookedDeskListDataTableList> data = await _empBookedDeskListDataTableListRepository.EmpBookedDeskListDataTableListAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PGenericSearch = param.GenericSearch ?? " ",
                            POffice = param.Office,
                            PAreaId = param.AreaId,
                            PDate = DateTime.ParseExact(param.BookingDate, "yyyyMMdd", CultureInfo.InvariantCulture),
                            PCostcode = param.Costcode,
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

        #endregion AdminBookingSummary

        #region DeskBookAttendanceDms

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionDeskBookAdmin)]
        public async Task<IActionResult> DeskBookAttendanceDmsIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterDeskBookAttendanceDmsIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            DeskBookEmpBookingDmsViewModel DeskBookAttendanceDmsViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            if (filterDataModel.BookingDate == null)
            {
                var bookingDatesList = await _selectTcmPLRepository.DeskBookDatesList(BaseSpTcmPLGet(), new ParameterSpTcmPL());

                filterDataModel.BookingDate = bookingDatesList.Reverse().FirstOrDefault().DataValueField;
            }

            return View(DeskBookAttendanceDmsViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> GetListsDeskBookAttendanceDms(string paramJson)
        {
            DTResult<DeskBookEmpBookingDmsDataTableList> result = new();
            int totalRow = 0;
            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            System.Collections.Generic.IEnumerable<DeskBookEmpBookingDmsDataTableList> data = await _deskBookAttendanceDmsDataTableListRepository.DeskBookAttendanceDataTableListAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PGenericSearch = param.GenericSearch ?? " ",
                    PAreaId = param.AreaId,
                    PCostCode = param.Costcode,
                    PAttendanceDate = DateTime.ParseExact(param.BookingDate, "yyyyMMdd", CultureInfo.InvariantCulture),
                    PIsPresent = param.IsPresent,
                    PIsDeskBooked = param.IsDeskBooked,
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

            var retVal = Json(result);

            return retVal;
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionDeskBookAdmin)]
        public async Task<IActionResult> DeskBookAttendanceDmsHistoryIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterDeskBookAttendanceDmsHistoryIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            DeskBookEmpBookingDmsHistoryViewModel DeskBookAttendanceDmsHistoryViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(DeskBookAttendanceDmsHistoryViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> GetListsDeskBookAttendanceDmsHistory(string paramJson)
        {
            DTResult<DeskBookEmpBookingDmsDataTableList> result = new();
            int totalRow = 0;
            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            System.Collections.Generic.IEnumerable<DeskBookEmpBookingDmsDataTableList> data = await _deskBookAttendanceDmsDataTableListRepository.DeskBookAttendanceHistoryDataTableListAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PGenericSearch = param.GenericSearch ?? " ",
                    PAreaId = param.AreaId,
                    PCostCode = param.Costcode,
                    PIsPresent = param.IsPresent,
                    PIsDeskBooked = param.IsDeskBooked,
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

            var retVal = Json(result);

            return retVal;
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionDeskBookAdmin)]
        public async Task<IActionResult> DeskBookAttendanceDmsExcelDownload()
        {
            var timeStamp = DateTime.Now.ToFileTime();

            string fileName = "Desk Book Attendance List_" + timeStamp.ToString();
            string reportTitle = "Desk Book Attendance List";
            string sheetName = "Desk Book Attendance List";

            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterDeskBookAttendanceDmsIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            if (string.IsNullOrEmpty(filterDataModel.OfficeLocationCode))
            {
                filterDataModel.OfficeLocationCode = ConstFilterByLocationAiroli;
            }

            IEnumerable<DeskBookEmpBookingDmsDataTableList> data = await _deskBookAttendanceDmsDataTableListRepository.DeskBookAttendanceXLDataTableListAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PGenericSearch = filterDataModel.GenericSearch ?? " ",
                    PAreaId = filterDataModel.AreaId,
                    PCostCode = filterDataModel.Costcode,
                    PAttendanceDate = null
                });

            if (data == null) { return NotFound(); }

            var json = JsonConvert.SerializeObject(data);

            IEnumerable<DeskBookAttendanceDmsDataTableExcel> excelData = JsonConvert.DeserializeObject<IEnumerable<DeskBookAttendanceDmsDataTableExcel>>(json);

            var byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, reportTitle, sheetName);

            var mimeType = MimeTypeMap.GetMimeType("xlsx");

            FileContentResult file = File(byteContent, mimeType, fileName);

            return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionDeskBookAdmin)]
        public async Task<IActionResult> DeskBookAttendanceDmsHistoryExcelDownload()
        {
            var timeStamp = DateTime.Now.ToFileTime();

            string fileName = "Desk Book Attendance List_" + timeStamp.ToString();
            string reportTitle = "Desk Book Attendance List";
            string sheetName = "Desk Book Attendance List";

            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterDeskBookAttendanceDmsHistoryIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            if (string.IsNullOrEmpty(filterDataModel.OfficeLocationCode))
            {
                filterDataModel.OfficeLocationCode = ConstFilterByLocationAiroli;
            }

            IEnumerable<DeskBookEmpBookingDmsDataTableList> data = await _deskBookAttendanceDmsDataTableListRepository.DeskBookAttendanceHistoryXLDataTableListAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PGenericSearch = filterDataModel.GenericSearch ?? " ",
                    PAreaId = filterDataModel.AreaId,
                    PCostCode = filterDataModel.Costcode,
                    PAttendanceDate = null
                });

            if (data == null) { return NotFound(); }

            var json = JsonConvert.SerializeObject(data);

            IEnumerable<DeskBookAttendanceDmsDataTableExcel> excelData = JsonConvert.DeserializeObject<IEnumerable<DeskBookAttendanceDmsDataTableExcel>>(json);

            var byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, reportTitle, sheetName);

            var mimeType = MimeTypeMap.GetMimeType("xlsx");

            FileContentResult file = File(byteContent, mimeType, fileName);

            return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
        }

        public async Task<IActionResult> DeskBookAttendanceDmsFilterGet()
        {
            var retVal = await RetriveFilter(ConstFilterDeskBookAttendanceDmsIndex);

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            IEnumerable<DataField> officeList = await _selectTcmPLRepository.DeskBookEmpOfficeList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["OfficeList"] = new SelectList(officeList, "DataValueField", "DataTextField");

            IEnumerable<DataField> areaList = await _selectTcmPLRepository.DeskBookAreaForAssignmentDmsList(BaseSpTcmPLGet(), new ParameterSpTcmPL { });
            ViewData["AreaList"] = new SelectList(areaList, "DataValueField", "DataTextField");

            IEnumerable<DataField> costCodeList = await _selectTcmPLRepository.DeskBookCostcodeList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["CostCodeList"] = new SelectList(costCodeList, "DataValueField", "DataTextField");

            var bookingDatesList = await _selectTcmPLRepository.DeskBookDatesList(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            var strSelectedDate = bookingDatesList.Reverse().FirstOrDefault().DataValueField;

            ViewData["BookingDatesList"] = new SelectList(bookingDatesList.Reverse(), "DataValueField", "DataTextField", strSelectedDate);

            return PartialView("_ModalDeskBookAttendanceDmsFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> DeskBookAttendanceDmsFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                string jsonFilter;
                jsonFilter = JsonConvert.SerializeObject(
                        new
                        {
                            filterDataModel.AreaId,
                            filterDataModel.CostCode,
                            filterDataModel.OfficeLocationCode,
                            filterDataModel.BookingDate,
                            filterDataModel.IsPresent,
                            filterDataModel.IsDeskBooked,
                        });

                _ = await CreateFilter(jsonFilter, ConstFilterDeskBookAttendanceDmsIndex);

                return Json(new
                {
                    success = true,
                    areaId = filterDataModel.AreaId,
                    costCode = filterDataModel.CostCode,
                    officeLocationCode = filterDataModel.OfficeLocationCode,
                    bookingDate = filterDataModel.BookingDate,
                    isPresent = filterDataModel.IsPresent,
                    isDeskBooked = filterDataModel.IsDeskBooked,
                });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        public async Task<IActionResult> DeskBookAttendanceDmsHistoryFilterGet()
        {
            var retVal = await RetriveFilter(ConstFilterDeskBookAttendanceDmsHistoryIndex);

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            IEnumerable<DataField> officeList = await _selectTcmPLRepository.DeskBookEmpOfficeList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["OfficeList"] = new SelectList(officeList, "DataValueField", "DataTextField");

            IEnumerable<DataField> areaList = await _selectTcmPLRepository.DeskBookDeskAreasForHod(BaseSpTcmPLGet(), new ParameterSpTcmPL { });
            ViewData["AreaList"] = new SelectList(areaList, "DataValueField", "DataTextField");

            IEnumerable<DataField> costCodeList = await _selectTcmPLRepository.DeskBookCostcodeList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["CostCodeList"] = new SelectList(costCodeList, "DataValueField", "DataTextField");

            var bookingDatesList = await _selectTcmPLRepository.DeskBookDatesList(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            var strSelectedDate = bookingDatesList.FirstOrDefault().DataValueField;

            ViewData["BookingDatesList"] = new SelectList(bookingDatesList, "DataValueField", "DataTextField", strSelectedDate);

            return PartialView("_ModalDeskBookAttendanceDmsHistoryFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> DeskBookAttendanceDmsHistoryFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                string jsonFilter;
                jsonFilter = JsonConvert.SerializeObject(
                        new
                        {
                            filterDataModel.AreaId,
                            filterDataModel.CostCode,
                            filterDataModel.OfficeLocationCode,
                            filterDataModel.IsPresent,
                            filterDataModel.IsDeskBooked,
                            filterDataModel.IsCrossAttend,
                        });

                _ = await CreateFilter(jsonFilter, ConstFilterDeskBookAttendanceDmsHistoryIndex);

                return Json(new
                {
                    success = true,
                    areaId = filterDataModel.AreaId,
                    costCode = filterDataModel.CostCode,
                    officeLocationCode = filterDataModel.OfficeLocationCode,
                    isPresent = filterDataModel.IsPresent,
                    isDeskBooked = filterDataModel.IsDeskBooked,
                    isCrossAttend = filterDataModel.IsCrossAttend
                });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionDeskBookAdmin)]
        public async Task<IActionResult> DeskBookAttendanceDmsDelete(string id)
        {
            try
            {
                var result = await _deskBookingRepository.ReleaseDeskAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL { PKeyId = id }
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
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionDeskBookAdmin)]
        public IActionResult ImportDeskBook()
        {
            DeskBookUploadViewModel deskBookUploadViewModel = new();

            return PartialView("_ModalDeskBookUploadPartial", deskBookUploadViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ImportDeskBook(DeskBookUploadViewModel deskBookUploadViewModel)
        {
            try
            {
                if (ModelState.IsValid == false)
                    return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage("Please Enter Valid Data"));
                var jsonstring = deskBookUploadViewModel.DeskId;

                if (jsonstring != null)
                {
                    jsonstring = MultilineToCSV(jsonstring);
                    if (jsonstring.Length == 0)
                    {
                        throw new Exception("Please Enter Valid Data");
                    }
                }

                string[] arrItems = jsonstring.Split(';');
                List<ExcelError> manualErrors = new();

                List<ReturnDesk> returnDeskBookList = new();
                int rowNumber = 1;
                foreach (var line in arrItems)
                {
                    var items = line.Split(',');

                    if (items.Length == 3)
                    {
                        if (!string.IsNullOrEmpty(items[0]) && items[0].Length <= 7)
                        {
                            if (!string.IsNullOrEmpty(items[1]) && items[1].Length <= 5)
                            {
                                if (!string.IsNullOrEmpty(items[2]) && items[2].Length == 2)
                                {
                                    string empno = items[1] = (items[1] ?? "00000").PadLeft(5, '0');

                                    returnDeskBookList.Add(new ReturnDesk { Deskid = items[0].ToUpper(), Empno = empno.ToUpper(), Shift = items[2].ToUpper() });
                                }
                                else
                                {
                                    manualErrors.Add(new ExcelError
                                    {
                                        Id = rowNumber,
                                        Section = "Desk Booking Data",
                                        ExcelRowNumber = rowNumber,
                                        FieldName = "Shift details is not valid",
                                        ErrorType = 1,
                                        ErrorTypeString = "Data Error",
                                        Message = "Shift Contain 2 characters."
                                    });
                                }
                                rowNumber++;
                            }
                            else
                            {
                                manualErrors.Add(new ExcelError
                                {
                                    Id = rowNumber,
                                    Section = "Desk Booking Data",
                                    ExcelRowNumber = rowNumber,
                                    FieldName = "Empno details is not valid",
                                    ErrorType = 1,
                                    ErrorTypeString = "Data Error",
                                    Message = "Empno Contain max 5 characters."
                                });
                                rowNumber++;
                            }
                        }
                        else
                        {
                            manualErrors.Add(new ExcelError
                            {
                                Id = rowNumber,
                                Section = "Desk Booking Data",
                                ExcelRowNumber = rowNumber,
                                FieldName = "Deskid details is not valid",
                                ErrorType = 1,
                                ErrorTypeString = "Data Error",
                                Message = "Deskid Contain max 7 characters."
                            });
                            rowNumber++;
                        }
                    }
                    else
                    {
                        manualErrors.Add(new ExcelError
                        {
                            Id = rowNumber,
                            Section = "Desk Booking Data",
                            ExcelRowNumber = rowNumber,
                            FieldName = "Line Format",
                            ErrorType = 1,
                            ErrorTypeString = "Format Error",
                            Message = "Each line must contain exactly 3 comma-separated values."
                        });
                        rowNumber++;
                    }
                }

                string formattedJson = JsonConvert.SerializeObject(returnDeskBookList);
                byte[] byteArray = Encoding.ASCII.GetBytes(formattedJson);

                DeskBookingOutPut uploadOutPut = new DeskBookingOutPut();

                if (manualErrors.Count() == 0)
                {
                    uploadOutPut = await _importDeskBookingsRepository.ImportDeskBookingJSonAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL
                    {
                        PParameterBlob = byteArray
                    });
                }

                uploadOutPut.PErrors = uploadOutPut.PErrors?.Concat(manualErrors) ?? manualErrors;
                List<ImportFileResultViewModel> importFileResults = new List<ImportFileResultViewModel>();

                List<Library.Excel.Template.Models.ValidationItem> validationItems = new List<Library.Excel.Template.Models.ValidationItem>();

                if (uploadOutPut.PMessageType != IsOk)
                {
                    if (uploadOutPut.PErrors != null)
                    {
                        foreach (var excelError in uploadOutPut.PErrors)
                        {
                            importFileResults.Add(new ImportFileResultViewModel
                            {
                                ErrorType = (ImportFileValidationErrorTypeEnum)excelError.ErrorType,
                                ExcelRowNumber = excelError.ExcelRowNumber,
                                FieldName = excelError.FieldName,
                                Id = excelError.Id,
                                Section = excelError.Section,
                                Message = excelError.Message,
                            });
                        }
                    }

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

                    var resultJsonError = new
                    {
                        success = false,
                        response = uploadOutPut.PMessageText,
                        data = importFileResults,
                        fileContent = ""
                    };

                    var timeStamp = DateTime.Now.ToFileTime();

                    string fileName = "Errors_" + timeStamp.ToString();
                    string reportTitle = "Errors";
                    string sheetName = "Errors";

                    var byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(importFileResults, reportTitle, sheetName);

                    var mimeType = MimeTypeMap.GetMimeType("xlsx");

                    FileContentResult file = File(byteContent, mimeType, fileName);

                    return Json(ResponseHelper.GetMessageObject("Error while performing action", file, MessageType: NotificationType.error));
                }
                else
                {
                    return Json(new { success = uploadOutPut.PMessageType, response = "Import data successfully executed" });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        public string MultilineToCSV(string sourceStr)
        {
            if (string.IsNullOrEmpty(sourceStr))
            {
                return "";
            }

            bool s = !Regex.IsMatch(sourceStr, @"[^0-9A-Za-z, \r\n]");

            if (!s)
            {
                throw new Exception("Please Enter Valid Employee No");
            }

            string retVal = sourceStr.Replace(System.Environment.NewLine, ";").Replace(" ", "");

            return retVal;
        }

        #endregion DeskBookAttendanceDms

        #region DeskBookingAttendanceStatus

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionDeskBookMonitor)]
        public async Task<IActionResult> DeskBookingAttendanceStatusIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterDeskBookAttendanceStatusIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            DeskBookingAttendanceStatusViewModel deskBookingAttendanceStatusViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            if (filterDataModel.BookingDate == null)
            {
                var bookingDatesList = await _selectTcmPLRepository.DeskBookDatesList(BaseSpTcmPLGet(), new ParameterSpTcmPL());

                filterDataModel.BookingDate = bookingDatesList.Reverse().FirstOrDefault().DataValueField;
            }
            filterDataModel.IsDeskBooked ??= ConstFilterIsDeskBooked_Yes;

            return View(deskBookingAttendanceStatusViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionDeskBookMonitor)]
        public async Task<IActionResult> GetListsDeskBookAttendanceStatus(string paramJson)
        {
            DTResult<DeskBookingAttendanceStatusDataTableList> result = new();
            int totalRow = 0;
            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            System.Collections.Generic.IEnumerable<DeskBookingAttendanceStatusDataTableList> data = await _deskBookingAttendanceStatusDataTableListRepository.DeskBookAttendanceStatusDataTableListAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PGenericSearch = param.GenericSearch ?? " ",
                    PAreaId = param.AreaId,
                    PCostCode = param.Costcode,
                    PIsDeskBooked = param.IsDeskBooked,
                    PIsPresent = param.IsPresent,
                    PIsCrossAttend = param.IsCrossAttend,
                    PAttendanceDate = DateTime.ParseExact(param.BookingDate, "yyyyMMdd", CultureInfo.InvariantCulture),
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

            var retVal = Json(result);

            return retVal;
        }

        public async Task<IActionResult> DeskBookAttendanceStatusFilterGet()
        {
            var retVal = await RetriveFilter(ConstFilterDeskBookAttendanceStatusIndex);

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            //IEnumerable<DataField> officeList = await _selectTcmPLRepository.DeskBookEmpOfficeList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            //ViewData["OfficeList"] = new SelectList(officeList, "DataValueField", "DataTextField");

            IEnumerable<DataField> areaList = await _selectTcmPLRepository.DeskBookAreaForAssignmentDmsList(BaseSpTcmPLGet(), new ParameterSpTcmPL { });
            ViewData["AreaList"] = new SelectList(areaList, "DataValueField", "DataTextField");

            IEnumerable<DataField> costCodeList = await _selectTcmPLRepository.DeskBookCostcodeList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["CostCodeList"] = new SelectList(costCodeList, "DataValueField", "DataTextField");

            var bookingDatesList = await _selectTcmPLRepository.DeskBookDatesList(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            var strSelectedDate = bookingDatesList.Reverse().FirstOrDefault().DataValueField;

            ViewData["BookingDatesList"] = new SelectList(bookingDatesList.Reverse(), "DataValueField", "DataTextField", strSelectedDate);

            return PartialView("_ModalDeskBookAttendanceStatusFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> DeskBookAttendanceStatusFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                string jsonFilter;
                jsonFilter = JsonConvert.SerializeObject(
                        new
                        {
                            filterDataModel.AreaId,
                            filterDataModel.CostCode,
                            filterDataModel.BookingDate,
                            filterDataModel.IsPresent,
                            filterDataModel.IsDeskBooked,
                            filterDataModel.IsCrossAttend,
                        });

                _ = await CreateFilter(jsonFilter, ConstFilterDeskBookAttendanceStatusIndex);

                return Json(new
                {
                    success = true,
                    areaId = filterDataModel.AreaId,
                    costCode = filterDataModel.CostCode,
                    bookingDate = filterDataModel.BookingDate,
                    isPresent = filterDataModel.IsPresent,
                    isDeskBooked = filterDataModel.IsDeskBooked,
                    isCrossAttend = filterDataModel.IsCrossAttend
                });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionDeskBookMonitor)]
        public async Task<IActionResult> DeskBookAttendanceStatusExcelDownload()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterDeskBookAttendanceStatusIndex
            });

            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            if (filterDataModel.BookingDate == null)
            {
                var bookingDatesList = await _selectTcmPLRepository.DeskBookDatesList(BaseSpTcmPLGet(), new ParameterSpTcmPL());

                filterDataModel.BookingDate = bookingDatesList.Reverse().FirstOrDefault().DataValueField;
            }
            var timeStamp = DateTime.Now.ToFileTime();

            string fileName = "DeskBookAttendStatusList_" + timeStamp.ToString();
            string reportTitle = "Desk Book Attendance Status List";
            string sheetName = "DeskBookAttendStatusList";

            IEnumerable<DeskBookingAttendanceStatusDataTableList> data = await _deskBookingAttendanceStatusDataTableListRepository.DeskBookAttendanceStatusXLDataTableListAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PGenericSearch = filterDataModel.GenericSearch ?? " ",
                    PAreaId = filterDataModel.AreaId,
                    PCostCode = filterDataModel.Costcode,
                    PIsDeskBooked = filterDataModel.IsDeskBooked,
                    PIsPresent = filterDataModel.IsPresent,
                    PIsCrossAttend = filterDataModel.IsCrossAttend,
                    PAttendanceDate = DateTime.ParseExact(filterDataModel.BookingDate, "yyyyMMdd", CultureInfo.InvariantCulture),
                });

            if (data == null) { return NotFound(); }

            var json = JsonConvert.SerializeObject(data);

            IEnumerable<DeskBookAttendanceStatusDataTableExcel> excelData = JsonConvert.DeserializeObject<IEnumerable<DeskBookAttendanceStatusDataTableExcel>>(json);

            var byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, reportTitle, sheetName);

            var mimeType = MimeTypeMap.GetMimeType("xlsx");

            FileContentResult file = File(byteContent, mimeType, fileName);

            return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionDeskBookMonitor)]
        public async Task<IActionResult> DeskBookingAttendanceStatusHistoryIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterDeskBookAttendanceStatusHistoryIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            DeskBookingAttendanceStatusHistoryViewModel deskBookingAttendanceStatusHistoryViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            if (filterDataModel.BookingDate == null)
            {
                var bookingDatesList = await _selectTcmPLRepository.DeskBookPreviousDatesList(BaseSpTcmPLGet(), new ParameterSpTcmPL());

                filterDataModel.BookingDate = bookingDatesList.Reverse().FirstOrDefault().DataValueField;
            }
            filterDataModel.IsDeskBooked ??= ConstFilterIsDeskBooked_Yes;
            return View(deskBookingAttendanceStatusHistoryViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionDeskBookMonitor)]
        public async Task<IActionResult> GetListsDeskBookAttendanceStatusHistory(string paramJson)
        {
            DTResult<DeskBookingAttendanceStatusDataTableList> result = new();
            int totalRow = 0;
            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            System.Collections.Generic.IEnumerable<DeskBookingAttendanceStatusDataTableList> data = await _deskBookingAttendanceStatusDataTableListRepository.DeskBookAttendanceStatusHistoryDataTableListAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PGenericSearch = param.GenericSearch ?? " ",
                    PAreaId = param.AreaId,
                    PCostCode = param.Costcode,
                    PIsDeskBooked = param.IsDeskBooked,
                    PIsPresent = param.IsPresent,
                    PIsCrossAttend = param.IsCrossAttend,
                    PAttendanceDate = DateTime.ParseExact(param.BookingDate, "yyyyMMdd", CultureInfo.InvariantCulture),
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

            var retVal = Json(result);

            return retVal;
        }

        public async Task<IActionResult> DeskBookAttendanceStatusHistoryFilterGet()
        {
            var retVal = await RetriveFilter(ConstFilterDeskBookAttendanceStatusHistoryIndex);

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            IEnumerable<DataField> areaList = await _selectTcmPLRepository.DeskBookAreaForAssignmentDmsList(BaseSpTcmPLGet(), new ParameterSpTcmPL { });
            ViewData["AreaList"] = new SelectList(areaList, "DataValueField", "DataTextField");

            IEnumerable<DataField> costCodeList = await _selectTcmPLRepository.DeskBookCostcodeList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["CostCodeList"] = new SelectList(costCodeList, "DataValueField", "DataTextField");

            var bookingDatesList = await _selectTcmPLRepository.DeskBookPreviousDatesList(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            var strSelectedDate = bookingDatesList.Reverse().FirstOrDefault().DataValueField;

            ViewData["BookingDatesList"] = new SelectList(bookingDatesList.Reverse(), "DataValueField", "DataTextField", strSelectedDate);

            return PartialView("_ModalDeskBookAttendanceStatusHistoryFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> DeskBookAttendanceStatusHistoryFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                string jsonFilter;
                jsonFilter = JsonConvert.SerializeObject(
                        new
                        {
                            filterDataModel.AreaId,
                            filterDataModel.CostCode,
                            filterDataModel.BookingDate,
                            filterDataModel.IsPresent,
                            filterDataModel.IsDeskBooked,
                            filterDataModel.IsCrossAttend,
                        });

                _ = await CreateFilter(jsonFilter, ConstFilterDeskBookAttendanceStatusHistoryIndex);

                return Json(new
                {
                    success = true,
                    areaId = filterDataModel.AreaId,
                    costCode = filterDataModel.CostCode,
                    bookingDate = filterDataModel.BookingDate,
                    isPresent = filterDataModel.IsPresent,
                    isDeskBooked = filterDataModel.IsDeskBooked,
                    isCrossAttend = filterDataModel.IsCrossAttend
                });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionDeskBookMonitor)]
        public async Task<IActionResult> DeskBookAttendanceStatusHistoryExcelDownload()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterDeskBookAttendanceStatusHistoryIndex
            });

            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            var timeStamp = DateTime.Now.ToFileTime();

            string fileName = "Booking_Attend_HistoryList_" + timeStamp.ToString();
            string reportTitle = "Booking_Attend_HistoryList";
            string sheetName = "Booking_Attend_History_" + filterDataModel.BookingDate;

            IEnumerable<DeskBookingAttendanceStatusDataTableList> data = await _deskBookingAttendanceStatusDataTableListRepository.DeskBookAttendanceStatusHistoryXLDataTableListAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PGenericSearch = filterDataModel.GenericSearch ?? " ",
                    PAreaId = filterDataModel.AreaId,
                    PCostCode = filterDataModel.Costcode,
                    PIsDeskBooked = filterDataModel.IsDeskBooked,
                    PIsPresent = filterDataModel.IsPresent,
                    PIsCrossAttend = filterDataModel.IsCrossAttend,
                    PAttendanceDate = DateTime.ParseExact(filterDataModel.BookingDate, "yyyyMMdd", CultureInfo.InvariantCulture),
                });

            if (data == null) { return NotFound(); }

            var json = JsonConvert.SerializeObject(data);

            IEnumerable<DeskBookAttendanceStatusDataTableExcel> excelData = JsonConvert.DeserializeObject<IEnumerable<DeskBookAttendanceStatusDataTableExcel>>(json);

            var byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, reportTitle, sheetName);

            var mimeType = MimeTypeMap.GetMimeType("xlsx");

            FileContentResult file = File(byteContent, mimeType, fileName);

            return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
        }

        #endregion DeskBookingAttendanceStatus

        #region EmpLocationMap

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionDeskBookAdmin)]
        public async Task<IActionResult> EmpLocationMappingIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterEmpLocationMappingIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            EmpLocationMappingViewModel empLocationMappingViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(empLocationMappingViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionDeskBookAdmin)]
        public async Task<IActionResult> GetListsEmpLocationMapping(string paramJson)
        {
            DTResult<EmpLocationMappingDataTableList> result = new();
            int totalRow = 0;
            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            System.Collections.Generic.IEnumerable<EmpLocationMappingDataTableList> data = await _empLocationMappingDataTableListRepository.EmpLocationMappingDataTableListAsync(
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

            var retVal = Json(result);

            return retVal;
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionDeskBookAdmin)]
        public async Task<IActionResult> EmpLocationMapCreate()
        {
            EmpLocationMapCreateViewModel empLocationMapCreateViewModel = new();

            IEnumerable<DataField> employeeList = await _selectTcmPLRepository.DeskBookEmployeeList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["EmployeeList"] = new SelectList(employeeList, "DataValueField", "DataTextField");

            IEnumerable<DataField> baseOfficeList = await _selectTcmPLRepository.DeskBookOfficeLocationList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["BaseOfficeList"] = new SelectList(baseOfficeList, "DataValueField", "DataTextField");

            return PartialView("_ModalEmpLocationMapCreate", empLocationMapCreateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionDeskBookAdmin)]
        public async Task<IActionResult> EmpLocationMapCreate([FromForm] EmpLocationMapCreateViewModel empLocationMapCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _empLocationMapRequestRepository.EmpLocationMapCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PEmpno = empLocationMapCreateViewModel.Empno,
                            POfficeLocationCode = empLocationMapCreateViewModel.OfficeLocationCode,
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

            IEnumerable<DataField> employeeList = await _selectTcmPLRepository.DeskBookEmployeeList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["EmployeeList"] = new SelectList(employeeList, "DataValueField", "DataTextField", empLocationMapCreateViewModel.Empno);

            IEnumerable<DataField> baseOfficeList = await _selectTcmPLRepository.DeskBookOfficeLocationList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["BaseOfficeList"] = new SelectList(baseOfficeList, "DataValueField", "DataTextField", empLocationMapCreateViewModel.OfficeLocationCode);

            return PartialView("_ModalEmpLocationMapCreate", empLocationMapCreateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionDeskBookAdmin)]
        public async Task<IActionResult> EmpLocationMapDelete(string id)
        {
            try
            {
                var result = await _empLocationMapRequestRepository.EmpLocationMapDeleteAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PKeyId = id
                    }
                    );

                return Json(new { success = result.PMessageType == IsOk, response = result.PMessageType, message = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionDeskBookAdmin)]
        public async Task<IActionResult> EmpLocationMapExcelDownload()
        {
            var timeStamp = DateTime.Now.ToFileTime();

            string fileName = "Emp Location Map List_" + timeStamp.ToString();
            string reportTitle = "Emp Location Map List";
            string sheetName = "Emp Location Map List";

            IEnumerable<EmpLocationMappingDataTableList> data = await _empLocationMappingDataTableListRepository.EmpLocationMappingDataTableListForExcelAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                });

            if (data == null) { return NotFound(); }

            var json = JsonConvert.SerializeObject(data);

            IEnumerable<EmpLocationMapDataTableExcel> excelData = JsonConvert.DeserializeObject<IEnumerable<EmpLocationMapDataTableExcel>>(json);

            var byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, reportTitle, sheetName);

            var mimeType = MimeTypeMap.GetMimeType("xlsx");

            FileContentResult file = File(byteContent, mimeType, fileName);

            return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
        }

        #endregion EmpLocationMap

        #region FloorPlan

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionDeskBookMonitor)]
        public async Task<IActionResult> FloorPlanIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterFloorPlanIndex
            });

            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            FloorPlanViewModel floorPlanViewModel = new()
            {
                FilterDataModel = filterDataModel
            };
            var bookingDatesList = await _selectTcmPLRepository.DeskBookDateRangeList(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            var strSelectedDate = bookingDatesList.Reverse().FirstOrDefault().DataValueField;

            ViewData["BookingDatesList"] = new SelectList(bookingDatesList.Reverse(), "DataValueField", "DataTextField", strSelectedDate);

            floorPlanViewModel.AttendanceDate = strSelectedDate;
            return View(floorPlanViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> GetBookedDeskList(string attendanceDate)
        {
            System.Collections.Generic.IEnumerable<BookedDeskDataTableList> data = await _bookedDeskDataTableListRepository.BookedDeskDataTableListAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PAttendanceDate = DateTime.ParseExact(attendanceDate, "yyyyMMdd", CultureInfo.InvariantCulture)
                }
            );

            return Json(data);
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionDeskBookMonitor)]
        public IActionResult BookDeskSummary(string attendanceDate)
        {
            FilterDataModel filterDataModel = new();
            BookingSummaryViewModel bookingSummaryViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            filterDataModel.BookingDate = attendanceDate;
            filterDataModel.ActionId = DeskBookingHelper.ActionDeskBookDept;
            filterDataModel.Office = ConstFilterByOffice;

            return PartialView("_ModalDeskBookingSummaryDetails", bookingSummaryViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionDeskBookMonitor)]
        public async Task<JsonResult> GetListsBookingSummaryDetails(string paramJson)
        {
            DTResult<BookingSummaryDataTableList> result = new();
            int totalRow = 0;
            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            try
            {
                System.Collections.Generic.IEnumerable<BookingSummaryDataTableList> data = await _bookingSummaryDataTableListRepository.DeskBookingSummaryDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch ?? " ",
                        POffice = ConstFilterByOffice,
                        PDate = DateTime.ParseExact(param.BookingDate, "yyyyMMdd", CultureInfo.InvariantCulture),
                        PActionId = DeskBookingHelper.ActionDeskBookAdmin,
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

        #endregion FloorPlan

        #region AiroliCabinBooking

        public async Task<IActionResult> DeskBookCabinBookingIndex()
        {
            if (!(CurrentUserIdentity.ProfileActions.Any(pa => pa.ActionId == DeskBookingHelper.ActionCabinBookEmployee) ||
                CurrentUserIdentity.ProfileActions.Any(pa => pa.ActionId == DeskBookingHelper.ActionCabinBookAdmin)))
            {
                Forbid();
            }

            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterAiroliCabinBookingIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            DeskBookCabinBookingViewModel deskBookCabinBookingViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(deskBookCabinBookingViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> GetListsCabinBookings(string genericSearch)
        {
            if (!(CurrentUserIdentity.ProfileActions.Any(pa => pa.ActionId == DeskBookingHelper.ActionCabinBookAdmin) ||
                CurrentUserIdentity.ProfileActions.Any(pa => pa.ActionId == DeskBookingHelper.ActionCabinBookEmployee)))
            {
                Forbid();
            }

            var data = await _cabinBookingsDataTableListRepository.CabinBookingList(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PGenericSearch = genericSearch
                }
            );

            if (data.Rows.Count == 0)
            {
                return Json(ResponseHelper.GetMessageObject("No Data Found.", NotificationType.error));
            }
            var jsonData = JsonConvert.SerializeObject(data);

            return Json(jsonData);
        }

        public async Task<IActionResult> CabinBookingsExcelDownload()
        {
            try
            {
                var result = await _cabinBookingsDataTableListRepository.CabinBookingList(BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                    }
                );
                if (result.Rows.Count == 0)
                {
                    return Json(ResponseHelper.GetMessageObject("No Data Found.", NotificationType.error));
                }
                string stringFileName = "CabinBookigs_.xlsx";

                string reportTitle = "Cabin Bookings ";

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

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionCabinBookEmployee)]
        public async Task<IActionResult> NewSelfCabinBooking()
        {
            NewCabinBookingCreateViewModel newCabinBookingCreateViewModel = new();

            var bookingDatesList = await _selectTcmPLRepository.DeskBookDatesList(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            ViewData["BookingDatesList"] = new SelectList(bookingDatesList.Reverse(), "DataValueField", "DataTextField");

            return PartialView("_ModalNewSelfCabinBookingPartial", newCabinBookingCreateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionCabinBookEmployee)]
        public async Task<IActionResult> NewSelfCabinBooking(NewCabinBookingCreateViewModel newCabinBookingCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _cabinBookingRepository.BookCabinAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PAttendanceDate = DateTime.ParseExact(newCabinBookingCreateViewModel.BookingDate, "yyyyMMdd", CultureInfo.InvariantCulture),
                            PDeskid = newCabinBookingCreateViewModel.Deskid,
                            PEmptype = "E"
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

            var bookingDatesList = await _selectTcmPLRepository.DeskBookDatesList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["BookingDatesList"] = new SelectList(bookingDatesList, "DataValueField", "DataTextField", newCabinBookingCreateViewModel.BookingDate);

            return PartialView("_ModalNewSelfCabinBookingPartial", newCabinBookingCreateViewModel);
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionCabinBookAdmin)]
        public async Task<IActionResult> NewGuestCabinBooking()
        {
            NewCabinBookingCreateViewModel newCabinBookingCreateViewModel = new();

            var bookingDatesList = await _selectTcmPLRepository.DeskBookDatesList(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            var strSelectedDate = bookingDatesList.Reverse().FirstOrDefault().DataValueField;

            ViewData["BookingDatesList"] = new SelectList(bookingDatesList.Reverse(), "DataValueField", "DataTextField");

            return PartialView("_ModalNewGuestCabinBookingPartial", newCabinBookingCreateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionCabinBookAdmin)]
        public async Task<IActionResult> NewGuestCabinBooking(NewCabinBookingCreateViewModel newCabinBookingCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _cabinBookingRepository.BookCabinAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PAttendanceDate = DateTime.ParseExact(newCabinBookingCreateViewModel.BookingDate, "yyyyMMdd", CultureInfo.InvariantCulture),
                            PDeskid = newCabinBookingCreateViewModel.Deskid,
                            PGuestName = newCabinBookingCreateViewModel.GuestName,
                            PEmptype = "G"
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

            var bookingDatesList = await _selectTcmPLRepository.DeskBookDatesList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["BookingDatesList"] = new SelectList(bookingDatesList, "DataValueField", "DataTextField", newCabinBookingCreateViewModel.BookingDate);

            return PartialView("_ModalNewSelfCabinBookingPartial", newCabinBookingCreateViewModel);
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionCabinBookEmployee)]
        public async Task<IActionResult> MyCabinBookingsIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterMyCabinBookingIndex
            });

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            DeskBookCabinBookingViewModel deskBookCabinBookingViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            var bookingDatesList = await _selectTcmPLRepository.DeskBookDatesList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["BookingDatesList"] = bookingDatesList;

            return View(deskBookCabinBookingViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionCabinBookEmployee)]
        public async Task<IActionResult> GetListsMyCabinBookings(string paramJson)
        {
            DTResult<DeskBookCabinBookingDataTableList> result = new();
            int totalRow = 0;
            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            System.Collections.Generic.IEnumerable<DeskBookCabinBookingDataTableList> data = await _deskBookCabinBookingsDataTableListRepository.MyCabinBookingsDataTableListAsync(
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

            var retVal = Json(result);

            return retVal;
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionCabinBookEmployee)]
        public async Task<IActionResult> MyCabinBookingsExcelDownload()
        {
            var timeStamp = DateTime.Now.ToFileTime();

            string fileName = "MyCabinBookings_" + timeStamp.ToString();
            string reportTitle = "MyCabinBookings";
            string sheetName = "MyCabinBookings";

            IEnumerable<DeskBookCabinBookingDataTableList> data = await _deskBookCabinBookingsDataTableListRepository.MyCabinBookingsXLDataTableListAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                });

            if (data == null) { return NotFound(); }

            var json = JsonConvert.SerializeObject(data);

            IEnumerable<CabinBookingsDataTableListExcel> excelData = JsonConvert.DeserializeObject<IEnumerable<CabinBookingsDataTableListExcel>>(json);

            var byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, reportTitle, sheetName);

            var mimeType = MimeTypeMap.GetMimeType("xlsx");

            FileContentResult file = File(byteContent, mimeType, fileName);

            return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionCabinBookAdmin)]
        public async Task<IActionResult> AllCabinBookingsIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterAllCabinBookingIndex
            });

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            DeskBookCabinBookingViewModel deskBookCabinBookingViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            var bookingDatesList = await _selectTcmPLRepository.DeskBookDatesList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["BookingDatesList"] = bookingDatesList;
            return View(deskBookCabinBookingViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionCabinBookAdmin)]
        public async Task<IActionResult> GetListsAllCabinBookings(string paramJson)
        {
            DTResult<DeskBookCabinBookingDataTableList> result = new();
            int totalRow = 0;

            try
            {
                var param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);
                System.Collections.Generic.IEnumerable<DeskBookCabinBookingDataTableList> data = await _deskBookCabinBookingsDataTableListRepository.AllCabinBookingsDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch ?? " ",
                        PStartDate = param.StartDate,
                        PEndDate = param.EndDate,
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

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionCabinBookAdmin)]
        public async Task<IActionResult> AllCabinBookingsExcelDownload()
        {
            var retVal = await RetriveFilter(ConstFilterAllCabinBookingIndex);

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            var timeStamp = DateTime.Now.ToFileTime();

            string fileName = "AllCabinBookings_" + timeStamp.ToString();
            string reportTitle = "AllCabinBookings";
            string sheetName = "AllCabinBookings";

            IEnumerable<DeskBookCabinBookingDataTableList> data = await _deskBookCabinBookingsDataTableListRepository.AllCabinBookingsXLDataTableListAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PStartDate = filterDataModel.StartDate,
                    PEndDate = filterDataModel.EndDate
                });

            if (data == null) { return NotFound(); }

            var json = JsonConvert.SerializeObject(data);

            IEnumerable<CabinBookingsDataTableListExcel> excelData = JsonConvert.DeserializeObject<IEnumerable<CabinBookingsDataTableListExcel>>(json);

            var byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, reportTitle, sheetName);

            var mimeType = MimeTypeMap.GetMimeType("xlsx");

            FileContentResult file = File(byteContent, mimeType, fileName);

            return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
        }

        [HttpPost]
        public async Task<IActionResult> CabinBookingDelete(string id)
        {
            if (!(CurrentUserIdentity.ProfileActions.Any(pa => pa.ActionId == DeskBookingHelper.ActionCabinBookEmployee) ||
                CurrentUserIdentity.ProfileActions.Any(pa => pa.ActionId == DeskBookingHelper.ActionCabinBookAdmin)))
            {
                Forbid();
            }

            try
            {
                var result = await _cabinBookingRepository.DeleteBookCabinAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL
                {
                    PKeyId = id
                });

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionCabinBookAdmin)]
        public async Task<IActionResult> CabinBookingsFilterGet()
        {
            Domain.Models.FilterRetrieve retVal = await RetriveFilter(ConstFilterAllCabinBookingIndex);

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            return PartialView("_ModalCabinBookingsFilterSet", filterDataModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionCabinBookAdmin)]
        public async Task<IActionResult> CabinBookingsFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                string jsonFilter;
                jsonFilter = JsonConvert.SerializeObject(
                        new
                        {
                            filterDataModel.StartDate,
                            filterDataModel.EndDate
                        });

                _ = await CreateFilter(jsonFilter, ConstFilterAllCabinBookingIndex);

                return Json(new
                {
                    success = true,
                    startDate = filterDataModel.StartDate,
                    endDate = filterDataModel.EndDate
                });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        [HttpGet]
        public async Task<IActionResult> GetPagingDeskSelectList(string search, int page, string id, string filter1)
        {
            Select2ResultList<DataFieldPaging> select2ResultList = new Select2ResultList<DataFieldPaging>();

            DateTime? date = string.IsNullOrEmpty(filter1) ? null : DateTime.ParseExact(filter1, "yyyyMMdd", CultureInfo.InvariantCulture);

            var data = await _selectTcmPLPagingRepository.CabinDeskIdListAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
                PGenericSearch = search,
                PRowNumber = (page - 1) * 250,
                PPageLength = 250,
                PAttendanceDate = date
            }
                );
            select2ResultList.items = data.ToList();
            if (data.Count() > 0)
                select2ResultList.totalCount = data.FirstOrDefault().TotalRow ?? 0;
            else
                select2ResultList.totalCount = 0;

            return Json(select2ResultList);
        }

        #endregion AiroliCabinBooking
    }
}