using ClosedXML.Excel;
using DocumentFormat.OpenXml.Drawing.Charts;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using MimeTypes;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.Common;
using TCMPLApp.DataAccess.Repositories.DeskBooking;
using TCMPLApp.DataAccess.Repositories.DMS;
using TCMPLApp.DataAccess.Repositories.SWPVaccine;
using TCMPLApp.Domain.Models.DMS;
using TCMPLApp.Library.Excel.Template;
using TCMPLApp.Library.Excel.Template.Models;
using TCMPLApp.WebApp.Classes;
using TCMPLApp.WebApp.Controllers;
using TCMPLApp.WebApp.CustomPolicyProvider;
using TCMPLApp.WebApp.Models;
using static TCMPLApp.WebApp.Classes.DTModel;

//using TCMPLApp.WebApp.Lib.Models;

namespace TCMPLApp.WebApp.Areas.DMS.Controllers
{
    [Authorize]
    [Area("DMS")]
    public class MastersController : BaseController
    {
        private const string ConstFilterDeskMasterIndex = "DmsDeskMasterIndex";
        private const string ConstFilterDeskAreaIndex = "DmsDeskAreaIndex";
        private const string ConstFilterDeskAreaCategoriesIndex = "DmsDeskAreaCategoriesIndex";
        private const string ConstFilterBayIndex = "DmsBayIndex";
        private const string ConstFilterOfficeIndex = "OfficeIndex";
        private const string ConstFilterDeskAreaOfficeMapIndex = "DeskAreaOfficeMapIndex";
        private const string ConstFilterDeskAreaDepartmentMapIndex = "DeskAreaDepartmentMapIndex";
        private const string ConstFilterDeskAreaProjectMapIndex = "DeskAreaProjectMapIndex";
        private const string ConstFilterDeskAreaUserMapIndex = "DeskAreaUserMapIndex";
        private const string ConstFilterByLocationAiroli = "02";

        private const string ConstFilterDeskAreaEmpAreaTypeMapIndex = "DeskAreaEmpAreaTypeMapIndex";
        private const string ConstFilterDeskAreaEmployeeMapIndex = "DeskAreaEmployeeMapIndex";
        private const string ConstDeskTypeForDept = "AT01";
        private const string ConstDeskTypeForProject = "AT02";
        private const string ConstDeskTypeForEmployee = "AT03";
        private const string ConstDeskTypeForSemiFixed = "AT04";
        private const string ConstDeskTypeForOpenArea = "AT05";
        private const string ConstDeskTypeForNotForDeskBooking = "AT06";
        private const string ConstFilterDmAreaTypeIndex = "DmAreaTypeIndex";
        private const string ConstFilterDeskAreaDeskListIndex = "DeskAreaDeskListIndex";
        private const string ConstFilterDeskAreaOfficeListIndex = "DeskAreaOfficeListIndex";
        private const string ConstFilterDeskAreaUserListIndex = "DeskAreaUserListIndex";
        private const string ConstFilterTagObjectMappingIndex = "TagObjectMappingIndex";

        private const string ConstFilterDeskImportIndex = "DeskImportIndex";

        private readonly IDesksDataTableListRepository _desksDataTableListRepository;
        private readonly ISetZoneDeskImportRepository _deskImportRepository;

        private readonly IDMSEmployeeRepository _dmsEmployeeRepository;
        private readonly ISelectTcmPLRepository _selectTcmPLRepository;
        private readonly IFilterRepository _filterRepository;
        private readonly IExcelTemplate _excelTemplate;

        private readonly IBayDataTableListRepository _bayDataTableListRepository;
        private readonly IDeskAreaCategoriesDataTableListRepository _deskAreaCategoriesDataTableListRepository;
        private readonly IDeskAreaDataTableListRepository _deskAreaDataTableListRepository;
        private readonly IDeskMasterDataTableListRepository _deskMasterDataTableListRepository;
        private readonly IOfficeDataTableListRepository _officeDataTableListRepository;
        private readonly IOfficeRequestRepository _officeRequestRepository;
        private readonly IOfficeDetailRepository _officeDetailRepository;
        private readonly IDeskAreaOfficeMapDataTableListRepository _deskAreaOfficeMapDataTableListRepository;
        private readonly IDeskAreaOfficeMapDetailRepository _deskAreaOfficeMapDetailRepository;
        private readonly IDeskAreaOfficeMapRequestRepository _deskAreaOfficeMapRequestRepository;
        private readonly IDeskAreaDepartmentMapDataTableListRepository _deskAreaDepartmentMapDataTableListRepository;
        private readonly IDeskAreaDepartmentMapRequestRepository _deskAreaDepartmentMapRequestRepository;
        private readonly IDeskAreaDepartmentMapDetailRepository _deskAreaDepartmentMapDetailRepository;
        private readonly IDeskAreaProjectMapDataTableListRepository _deskAreaProjectMapDataTableListRepository;

        private readonly IBayDetailRepository _bayDetailRepository;
        private readonly IDeskAreaCategoriesDetailRepository _deskAreaCategoriesDetailRepository;
        private readonly IDeskAreaDetailRepository _deskAreaDetailRepository;
        private readonly IDeskMasterDetailRepository _deskMasterDetailRepository;
        private readonly IBayRepository _bayRepository;
        private readonly IDeskAreaCategoriesRepository _deskAreaCategoriesRepository;
        private readonly IDeskAreaRepository _deskAreaRepository;
        private readonly IDeskMasterRepository _deskMasterRepository;
        private readonly IUtilityRepository _utilityRepository;

        private readonly IDmAreaTypeDataTableListRepository _dmAreaTypeDataTableListRepository;
        private readonly IDmAreaTypeDetailRepository _dmAreaTypeDetailRepository;
        private readonly IDmAreaTypeRepository _dmAreaTypeRepository;
        private readonly IDeskAreaProjectMapRepository _deskAreaProjectMapRepository;
        private readonly IDeskAreaProjectMapDetailRepository _deskAreaProjectMapDetailRepository;

        private readonly IDeskAreaUserMapDataTableListRepository _deskAreaUserMapDataTableListRepository;
        private readonly IDeskAreaUserMapRequestRepository _deskAreaUserMapRequestRepository;
        private readonly IDeskAreaUserMapDetailRepository _deskAreaUserMapDetailRepository;

        private readonly IDeskAreaEmployeeMapDataTableListRepository _deskAreaEmployeeMapDataTableListRepository;
        private readonly IDeskAreaEmployeeMapRepository _deskAreaEmployeeMapRepository;
        private readonly IDeskAreaEmployeeMapDetailRepository _deskAreaEmployeeMapDetailRepository;

        private readonly IDeskAreaEmpAreaTypeMapDataTableListRepository _deskAreaEmpAreaTypeMapDataTableListRepository;
        private readonly IDeskAreaEmpAreaTypeMapRequestRepository _deskAreaEmpAreaTypeMapRequestRepository;
        private readonly IDeskAreaEmpAreaTypeMapDetailRepository _deskAreaEmpAreaTypeMapDetailRepository;
        private readonly IDeskAreaDepartmentDataTableListRepository _deskAreaDepartmentDataTableListRepository;
        private readonly IDeskAreaProjectDataTableListRepository _deskAreaProjectDataTableListRepository;
        private readonly ICommonEmployeeDetailsRepository _commonEmployeeDetailsRepository;

        private readonly IDeskBookingRepository _deskBookingRepository;

        private readonly ITagObjectMapDataTableListRepository _tagObjectMapDataTableListRepository;
        private readonly ITagObjectMapRepository _tagObjectMapRepository;

        private readonly IDeskAreaDeskListImportRepository _deskAreaDeskListImportRepository;
        private readonly IDeskAreaUserListImportRepository _deskAreaUserListImportRepository;

        public MastersController(
            IDMSEmployeeRepository dmsEmployeeRepository,
            IFilterRepository filterRepository,
            ISelectTcmPLRepository selectTcmPLRepository,
            IExcelTemplate excelTemplate,
            IBayDataTableListRepository bayDataTableListRepository,
            IDeskAreaCategoriesDataTableListRepository deskAreaCategoriesDataTableListRepository,
            IDeskAreaDataTableListRepository deskAreaDataTableListRepository,
            IDeskMasterDataTableListRepository deskMasterDataTableListRepository,
            IBayDetailRepository bayDetailRepository,
            IDeskAreaCategoriesDetailRepository deskAreaCategoriesDetailRepository,
            IDeskAreaDetailRepository deskAreaDetailRepository,
            IDeskMasterDetailRepository deskMasterDetailRepository,
            IBayRepository bayRepository,
            IDeskAreaCategoriesRepository deskAreaCategoriesRepository,
            IDeskAreaRepository deskAreaRepository,
            IDeskMasterRepository deskMasterRepository,
            IUtilityRepository utilityRepository,
            IOfficeDataTableListRepository officeDataTableListRepository,
            IOfficeRequestRepository officeRequestRepository,
            IOfficeDetailRepository officeDetailRepository,
            IDeskAreaOfficeMapDataTableListRepository deskAreaOfficeMapDataTableListRepository,
            IDeskAreaOfficeMapDetailRepository deskAreaOfficeMapDetailRepository,
            IDeskAreaOfficeMapRequestRepository deskAreaOfficeMapRequestRepository,
            IDmAreaTypeDataTableListRepository dmAreaTypeDataTableListRepository,
            IDmAreaTypeDetailRepository dmAreaTypeDetailRepository,
            IDmAreaTypeRepository dmAreaTypeRepository,
            IDeskAreaDepartmentMapDataTableListRepository deskAreaDepartmentMapDataTableListRepository,
            IDeskAreaDepartmentMapRequestRepository deskAreaDepartmentMapRequestRepository,
            IDeskAreaDepartmentMapDetailRepository deskAreaDepartmentMapDetailRepository,
            IDeskAreaUserMapDataTableListRepository deskAreaUserMapDataTableListRepository,
            IDeskAreaUserMapRequestRepository deskAreaUserMapRequestRepository,
            IDeskAreaUserMapDetailRepository deskAreaUserMapDetailRepository,

            IDeskAreaProjectMapDataTableListRepository deskAreaProjectMapDataTableListRepository,
            IDeskAreaProjectMapRepository deskAreaProjectMapRepository,
            IDeskAreaProjectMapDetailRepository deskAreaProjectMapDetailRepository,
            IDeskAreaEmployeeMapDataTableListRepository deskAreaEmployeeMapDataTableListRepository,
            IDeskAreaEmployeeMapRepository deskAreaEmployeeMapRepository,
            IDeskAreaEmployeeMapDetailRepository deskAreaEmployeeMapDetailRepository,
            IDeskAreaEmpAreaTypeMapDataTableListRepository deskAreaEmpAreaTypeMapDataTableListRepository,
            IDeskAreaEmpAreaTypeMapRequestRepository deskAreaEmpAreaTypeMapRequestRepository,
            IDeskAreaEmpAreaTypeMapDetailRepository deskAreaEmpAreaTypeMapDetailRepository,
            IDeskAreaDepartmentDataTableListRepository deskAreaDepartmentDataTableListRepository,
            IDeskAreaProjectDataTableListRepository deskAreaProjectDataTableListRepository,
            ICommonEmployeeDetailsRepository commonEmployeeDetailsRepository,
            IDeskBookingRepository deskBookingRepository,
            ITagObjectMapDataTableListRepository tagObjectMapDataTableListRepository,
            ITagObjectMapRepository tagObjectMapRepository,
            IDeskAreaDeskListImportRepository deskAreaDeskListImportRepository,
            IDeskAreaUserListImportRepository deskAreaUserListImportRepository,
            IDesksDataTableListRepository desksDataTableListRepository,
        ISetZoneDeskImportRepository deskImportRepository
            )
        {
            _dmsEmployeeRepository = dmsEmployeeRepository;
            _deskMasterRepository = deskMasterRepository;
            _selectTcmPLRepository = selectTcmPLRepository;
            _filterRepository = filterRepository;
            _excelTemplate = excelTemplate;

            _bayDataTableListRepository = bayDataTableListRepository;
            _deskAreaCategoriesDataTableListRepository = deskAreaCategoriesDataTableListRepository;
            _deskAreaDataTableListRepository = deskAreaDataTableListRepository;
            _deskMasterDataTableListRepository = deskMasterDataTableListRepository;
            _bayDetailRepository = bayDetailRepository;
            _deskAreaCategoriesDetailRepository = deskAreaCategoriesDetailRepository;
            _deskAreaDetailRepository = deskAreaDetailRepository;
            _deskMasterDetailRepository = deskMasterDetailRepository;
            _bayRepository = bayRepository;
            _deskAreaCategoriesRepository = deskAreaCategoriesRepository;
            _deskAreaRepository = deskAreaRepository;
            _deskMasterRepository = deskMasterRepository;
            _officeDataTableListRepository = officeDataTableListRepository;
            _officeRequestRepository = officeRequestRepository;
            _officeDetailRepository = officeDetailRepository;
            _deskAreaOfficeMapDataTableListRepository = deskAreaOfficeMapDataTableListRepository;
            _deskAreaOfficeMapDetailRepository = deskAreaOfficeMapDetailRepository;
            _utilityRepository = utilityRepository;
            _deskAreaOfficeMapRequestRepository = deskAreaOfficeMapRequestRepository;

            _dmAreaTypeDataTableListRepository = dmAreaTypeDataTableListRepository;
            _dmAreaTypeDetailRepository = dmAreaTypeDetailRepository;
            _dmAreaTypeRepository = dmAreaTypeRepository;

            _deskAreaDepartmentMapDataTableListRepository = deskAreaDepartmentMapDataTableListRepository;
            _deskAreaDepartmentMapRequestRepository = deskAreaDepartmentMapRequestRepository;
            _deskAreaDepartmentMapDetailRepository = deskAreaDepartmentMapDetailRepository;
            _deskAreaUserMapDataTableListRepository = deskAreaUserMapDataTableListRepository;
            _deskAreaUserMapRequestRepository = deskAreaUserMapRequestRepository;
            _deskAreaUserMapDetailRepository = deskAreaUserMapDetailRepository;

            _deskAreaEmpAreaTypeMapDataTableListRepository = deskAreaEmpAreaTypeMapDataTableListRepository;
            _deskAreaEmpAreaTypeMapRequestRepository = deskAreaEmpAreaTypeMapRequestRepository;
            _deskAreaEmpAreaTypeMapDetailRepository = deskAreaEmpAreaTypeMapDetailRepository;
            _deskAreaProjectMapDataTableListRepository = deskAreaProjectMapDataTableListRepository;
            _deskAreaProjectMapRepository = deskAreaProjectMapRepository;
            _deskAreaProjectMapDetailRepository = deskAreaProjectMapDetailRepository;
            _deskAreaEmployeeMapDataTableListRepository = deskAreaEmployeeMapDataTableListRepository;
            _deskAreaEmployeeMapRepository = deskAreaEmployeeMapRepository;
            _deskAreaEmployeeMapDetailRepository = deskAreaEmployeeMapDetailRepository;
            _deskAreaProjectMapDetailRepository = deskAreaProjectMapDetailRepository;
            _deskAreaDepartmentDataTableListRepository = deskAreaDepartmentDataTableListRepository;
            _deskAreaProjectDataTableListRepository = deskAreaProjectDataTableListRepository;
            _commonEmployeeDetailsRepository = commonEmployeeDetailsRepository;
            _deskBookingRepository = deskBookingRepository;
            _tagObjectMapDataTableListRepository = tagObjectMapDataTableListRepository;
            _tagObjectMapRepository = tagObjectMapRepository;

            _deskAreaDeskListImportRepository = deskAreaDeskListImportRepository;
            _deskAreaUserListImportRepository = deskAreaUserListImportRepository;
            _desksDataTableListRepository = desksDataTableListRepository;
            _deskImportRepository = deskImportRepository;
        }

        public IActionResult Index()
        {
            return View();
        }

        #region DeskMasterIndex

        public async Task<IActionResult> DeskMasterIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterDeskMasterIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            DeskMasterViewModel deskMasterViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(deskMasterViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> DeskMasterDetail(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            DeskMasterDetails result = await _deskMasterDetailRepository.DeskMasterDetail(
                         BaseSpTcmPLGet(), new ParameterSpTcmPL { PDeskId = id });

            DeskMasterViewModel deskMasterViewModel = new();

            if (result.PMessageType == IsOk)
            {
                deskMasterViewModel.DeskId = id;
                deskMasterViewModel.Office = result.POffice;
                deskMasterViewModel.Floor = result.PFloor;
                deskMasterViewModel.Wing = result.PWing;
                deskMasterViewModel.Bay = result.PBay;
                deskMasterViewModel.SeatNo = result.PSeatNo;
                deskMasterViewModel.Cabin = result.PCabin;
                deskMasterViewModel.IsDeleted = result.PIsDeleted;
                deskMasterViewModel.IsBlocked = result.PIsBlocked;
                deskMasterViewModel.DeskidOld = result.PDeskidOld;
                deskMasterViewModel.WorkArea = result.PWorkAreaCode == null ? "" : result.PWorkAreaCategories + " - " + result.PWorkAreaCode + " - " + result.PWorkAreaDesc;
                //deskMasterViewModel.WorkAreaCode = result.PWorkAreaCode == null ? "" : result.PWorkAreaCategories + " - " + result.PWorkAreaCode + " - " + result.PWorkAreaDesc;
                deskMasterViewModel.Remarks = result.PRemarks;
            }

            return PartialView("_ModalDeskMasterDetailPartial", deskMasterViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsDeskMaster(DTParameters param)
        {
            DTResult<DeskMasterDataTableList> result = new();
            int totalRow = 0;

            try
            {
                System.Collections.Generic.IEnumerable<DeskMasterDataTableList> data = await _deskMasterDataTableListRepository.DeskMasterDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch ?? " ",
                        PWorkAreaCategories = param.AreaCategory,
                        PWorkArea = param.WorkArea,
                        POffice = param.Office,
                        PIsBlocked = param.IsBlocked,
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
        public async Task<IActionResult> DeskMasterCreate()
        {
            TCMPLApp.WebApp.Models.DeskMasterCreateViewModel deskMasterCreateViewModel = new()
            {
                Cabin = "N",
                IsBlocked = 0
            };

            var dmsAreaList = await _selectTcmPLRepository.DmsAreaList(BaseSpTcmPLGet(), null);
            ViewData["DmsAreaList"] = new SelectList(dmsAreaList, "DataValueField", "DataTextField");

            var dmsOfficeList = await _selectTcmPLRepository.DmsOfficeList(BaseSpTcmPLGet(), null);
            ViewData["DmsOfficeList"] = new SelectList(dmsOfficeList, "DataValueField", "DataTextField");

            var dmsFloorList = await _selectTcmPLRepository.DmsFloorList(BaseSpTcmPLGet(), null);
            ViewData["DmsFloorList"] = new SelectList(dmsFloorList, "DataValueField", "DataTextField");

            var dmsWingList = await _selectTcmPLRepository.DmsWingList(BaseSpTcmPLGet(), null);
            ViewData["DmsWingList"] = new SelectList(dmsWingList, "DataValueField", "DataTextField");

            var dmsBayList = await _selectTcmPLRepository.DmsBayList(BaseSpTcmPLGet(), null);
            ViewData["DmsBayList"] = new SelectList(dmsBayList, "DataValueField", "DataTextField");

            return PartialView("_ModalDeskMasterCreatePartial", deskMasterCreateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DMSHelper.ActionITAdm)]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeskMasterCreate([FromForm] TCMPLApp.WebApp.Models.DeskMasterCreateViewModel deskMasterCreateViewModel)
        {
            try
            {
                if (deskMasterCreateViewModel.IsBlocked == 1 && string.IsNullOrEmpty(deskMasterCreateViewModel.Remarks))
                {
                    throw new Exception("Remarks is required when IsBlocked is Yes");
                }

                if (ModelState.IsValid)
                {
                    var result = await _deskMasterRepository.DeskMasterCreateAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PDeskId = deskMasterCreateViewModel.Deskid,
                        POffice = deskMasterCreateViewModel.Office,
                        PFloor = deskMasterCreateViewModel.Floor,
                        PSeatNo = deskMasterCreateViewModel.Seatno,
                        PWing = deskMasterCreateViewModel.Wing,
                        PIsBlocked = deskMasterCreateViewModel.IsBlocked,
                        PCabin = deskMasterCreateViewModel.Cabin,
                        PRemarks = deskMasterCreateViewModel.Remarks,
                        PWorkAreaCode = deskMasterCreateViewModel.Workarea,
                        PBay = deskMasterCreateViewModel.Bay,
                        PDeskidOld = null
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

            var dmsAreaList = await _selectTcmPLRepository.DmsAreaList(BaseSpTcmPLGet(), null);
            ViewData["DmsAreaList"] = new SelectList(dmsAreaList, "DataValueField", "DataTextField", deskMasterCreateViewModel.Workarea);

            var dmsOfficeList = await _selectTcmPLRepository.DmsOfficeList(BaseSpTcmPLGet(), null);
            ViewData["DmsOfficeList"] = new SelectList(dmsOfficeList, "DataValueField", "DataTextField", deskMasterCreateViewModel.Office);

            var dmsFloorList = await _selectTcmPLRepository.DmsFloorList(BaseSpTcmPLGet(), null);
            ViewData["DmsFloorList"] = new SelectList(dmsFloorList, "DataValueField", "DataTextField", deskMasterCreateViewModel.Floor);

            var dmsWingList = await _selectTcmPLRepository.DmsWingList(BaseSpTcmPLGet(), null);
            ViewData["DmsWingList"] = new SelectList(dmsWingList, "DataValueField", "DataTextField", deskMasterCreateViewModel.Wing);

            var dmsBayList = await _selectTcmPLRepository.DmsBayList(BaseSpTcmPLGet(), null);
            ViewData["DmsBayList"] = new SelectList(dmsBayList, "DataValueField", "DataTextField", deskMasterCreateViewModel.Bay);

            return PartialView("_ModalDeskMasterCreatePartial", deskMasterCreateViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> DeskMasterUpdate(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var result = await _deskMasterDetailRepository.DeskMasterDetail(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PDeskId = id
                });

            DeskMasterUpdateViewModel deskMasterUpdateViewModel = new();

            if (result.PMessageType == IsOk)
            {
                deskMasterUpdateViewModel.Deskid = id;
                deskMasterUpdateViewModel.Office = result.POffice.Trim();
                deskMasterUpdateViewModel.Floor = result.PFloor;
                deskMasterUpdateViewModel.Wing = result.PWing;
                deskMasterUpdateViewModel.Bay = result.PBay;
                deskMasterUpdateViewModel.Seatno = result.PSeatNo;
                deskMasterUpdateViewModel.Workarea = result.PWorkAreaCode;
                deskMasterUpdateViewModel.Cabin = result.PCabin;
                deskMasterUpdateViewModel.DeskidOld = result.PDeskidOld;
                deskMasterUpdateViewModel.IsBlocked = result.PIsBlocked;
                deskMasterUpdateViewModel.Remarks = result.PRemarks;
            }

            var dmsAreaList = await _selectTcmPLRepository.DmsAreaList(BaseSpTcmPLGet(), null);
            ViewData["DmsAreaList"] = new SelectList(dmsAreaList, "DataValueField", "DataTextField", deskMasterUpdateViewModel.Workarea);

            var dmsOfficeList = await _selectTcmPLRepository.DmsOfficeList(BaseSpTcmPLGet(), null);
            ViewData["DmsOfficeList"] = new SelectList(dmsOfficeList, "DataValueField", "DataTextField", deskMasterUpdateViewModel.Office);

            var dmsFloorList = await _selectTcmPLRepository.DmsFloorList(BaseSpTcmPLGet(), null);
            ViewData["DmsFloorList"] = new SelectList(dmsFloorList, "DataValueField", "DataTextField", deskMasterUpdateViewModel.Floor);

            var dmsWingList = await _selectTcmPLRepository.DmsWingList(BaseSpTcmPLGet(), null);
            ViewData["DmsWingList"] = new SelectList(dmsWingList, "DataValueField", "DataTextField", deskMasterUpdateViewModel.Wing);

            var dmsBayList = await _selectTcmPLRepository.DmsBayList(BaseSpTcmPLGet(), null);
            ViewData["DmsBayList"] = new SelectList(dmsBayList, "DataValueField", "DataTextField", deskMasterUpdateViewModel.Bay);

            return PartialView("_ModalDeskMasterEditPartial", deskMasterUpdateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DMSHelper.ActionITAdm)]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeskMasterUpdate([FromForm] DeskMasterUpdateViewModel deskMasterUpdateViewModel)
        {
            try
            {
                if (deskMasterUpdateViewModel.IsBlocked == 1 && string.IsNullOrEmpty(deskMasterUpdateViewModel.Remarks))
                {
                    throw new Exception("Remarks is required when IsBlocked is Yes");
                }

                if (ModelState.IsValid)
                {
                    var result = await _deskMasterRepository.DeskMasterEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PDeskId = deskMasterUpdateViewModel.Deskid,
                            POffice = deskMasterUpdateViewModel.Office,
                            PFloor = deskMasterUpdateViewModel.Floor,
                            PSeatNo = deskMasterUpdateViewModel.Seatno,
                            PWing = deskMasterUpdateViewModel.Wing,
                            PIsBlocked = deskMasterUpdateViewModel.IsBlocked,
                            PCabin = deskMasterUpdateViewModel.Cabin,
                            PRemarks = deskMasterUpdateViewModel.Remarks,
                            PDeskidOld = deskMasterUpdateViewModel.DeskidOld,
                            PWorkAreaCode = deskMasterUpdateViewModel.Workarea,
                            PBay = deskMasterUpdateViewModel.Bay
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

            var dmsAreaList = await _selectTcmPLRepository.DmsAreaList(BaseSpTcmPLGet(), null);
            ViewData["DmsAreaList"] = new SelectList(dmsAreaList, "DataValueField", "DataTextField", deskMasterUpdateViewModel.Workarea);

            var dmsOfficeList = await _selectTcmPLRepository.DmsOfficeList(BaseSpTcmPLGet(), null);
            ViewData["DmsOfficeList"] = new SelectList(dmsOfficeList, "DataValueField", "DataTextField", deskMasterUpdateViewModel.Office);

            var dmsFloorList = await _selectTcmPLRepository.DmsFloorList(BaseSpTcmPLGet(), null);
            ViewData["DmsFloorList"] = new SelectList(dmsFloorList, "DataValueField", "DataTextField", deskMasterUpdateViewModel.Floor);

            var dmsWingList = await _selectTcmPLRepository.DmsWingList(BaseSpTcmPLGet(), null);
            ViewData["DmsWingList"] = new SelectList(dmsWingList, "DataValueField", "DataTextField", deskMasterUpdateViewModel.Wing);

            var dmsBayList = await _selectTcmPLRepository.DmsBayList(BaseSpTcmPLGet(), null);
            ViewData["DmsBayList"] = new SelectList(dmsBayList, "DataValueField", "DataTextField", deskMasterUpdateViewModel.Bay);

            return PartialView("_ModalDeskMasterEditPartial", deskMasterUpdateViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> DeskMasterExcludeView(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var result = await _deskMasterDetailRepository.DeskMasterDetail(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PDeskId = id
                });

            DeskMasterExcludeViewModel deskMasterExcludeViewModel = new();

            if (result.PMessageType == IsOk)
            {
                deskMasterExcludeViewModel.Deskid = id;
            }

            var dmsDeskLockReasonList = await _selectTcmPLRepository.DmsDeskLockReasonList(BaseSpTcmPLGet(), null);
            ViewData["DmsDeskLockReasonList"] = new SelectList(dmsDeskLockReasonList, "DataValueField", "DataTextField");

            return PartialView("_ModalDeskMasterExcludePartial", deskMasterExcludeViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DMSHelper.ActionITAdm)]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeskMasterExcludeView([FromForm] DeskMasterExcludeViewModel deskMasterExcludeViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _deskMasterRepository.DeskMasterExcludeAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PDeskId = deskMasterExcludeViewModel.Deskid,
                            PWorkAreaCode = deskMasterExcludeViewModel.DeskDeletionReason,
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

            var dmsDeskLockReasonList = await _selectTcmPLRepository.DmsDeskLockReasonList(BaseSpTcmPLGet(), null);
            ViewData["DmsDeskLockReasonList"] = new SelectList(dmsDeskLockReasonList, "DataValueField", "DataTextField", deskMasterExcludeViewModel.DeskDeletionReason);

            return PartialView("_ModalDeskMasterExcludePartial", deskMasterExcludeViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DMSHelper.ActionITAdm)]
        public async Task<IActionResult> DeskMasterDelete(string id)
        {
            try
            {
                var result = await _deskMasterRepository.DeskMasterExcludeAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL { PDeskid = id }
                    );

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        public async Task<IActionResult> DeskMasterExcelDownload()
        {
            try
            {
                var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
                {
                    PModuleName = CurrentUserIdentity.CurrentModule,
                    PMetaId = CurrentUserIdentity.MetaId,
                    PPersonId = CurrentUserIdentity.EmployeeId,
                    PMvcActionName = ConstFilterDeskMasterIndex
                });
                FilterDataModel filterDataModel = new();
                if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                {
                    filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
                }

                string StrFimeName;

                var timeStamp = DateTime.Now.ToFileTime();
                StrFimeName = "Desk_" + timeStamp.ToString();

                string strUser = User.Identity.Name;

                IEnumerable<DeskMasterDataTableList> data = await _deskMasterDataTableListRepository.DeskMasterDataTableListForExcelAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = filterDataModel.GenericSearch ?? " ",
                        PWorkAreaCategories = filterDataModel.AreaCategory,
                        PWorkArea = filterDataModel.WorkArea,
                        POffice = filterDataModel.Office,
                        PIsBlocked = filterDataModel.IsBlocked,
                    });

                if (data == null) { return NotFound(); }

                var json = JsonConvert.SerializeObject(data);

                IEnumerable<DeskMasterDataTableExcel> excelData = JsonConvert.DeserializeObject<IEnumerable<DeskMasterDataTableExcel>>(json);

                byte[] byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, "Desks", "Desks");

                var mimeType = MimeTypeMap.GetMimeType("xlsx");

                FileContentResult file = File(byteContent, mimeType, StrFimeName);

                return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        #region DeskMasterFilter

        public async Task<IActionResult> DMSDeskMasterFilterGet()
        {
            var retVal = await RetriveFilter(ConstFilterDeskMasterIndex);

            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            var areaCategoryList = await _selectTcmPLRepository.DmsAreaCatgCodeList(BaseSpTcmPLGet(), null);
            var workAreaList = await _selectTcmPLRepository.DmsAreaList(BaseSpTcmPLGet(), null);
            var officeList = await _selectTcmPLRepository.DmsOfficeList(BaseSpTcmPLGet(), null);

            ViewData["AreaCategoryList"] = new SelectList(areaCategoryList, "DataValueField", "DataTextField");
            ViewData["OfficeList"] = new SelectList(officeList, "DataValueField", "DataTextField");
            ViewData["WorkAreaList"] = new SelectList(workAreaList, "DataValueField", "DataTextField");

            return PartialView("_ModalDMSDeskMasterFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> DMSDeskMasterFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                string jsonFilter;
                jsonFilter = JsonConvert.SerializeObject(
                        new
                        {
                            office = filterDataModel.Office,
                            isBlocked = filterDataModel.IsBlocked,
                            filterDataModel.WorkArea,
                            filterDataModel.AreaCategory
                        });

                _ = await CreateFilter(jsonFilter, ConstFilterDeskMasterIndex);

                return Json(new
                {
                    success = true,
                    office = filterDataModel.Office,
                    isBlocked = filterDataModel.IsBlocked,
                    workArea = filterDataModel.WorkArea,
                    areaCategory = filterDataModel.AreaCategory
                });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        #endregion DeskMasterFilter

        #endregion DeskMasterIndex

        #region DeskAreaCategoriesIndex

        public async Task<IActionResult> DeskAreaCategoriesIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterDeskAreaCategoriesIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            DeskAreaCategoriesViewModel deskAreaCategoriesViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(deskAreaCategoriesViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsDeskAreaCategories(DTParameters param)
        {
            DTResult<DeskAreaCategoriesDataTableList> result = new();
            int totalRow = 0;

            try
            {
                System.Collections.Generic.IEnumerable<DeskAreaCategoriesDataTableList> data = await _deskAreaCategoriesDataTableListRepository.DeskAreaCategoriesDataTableListAsync(
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
        public IActionResult DeskAreaCategoriesCreate()
        {
            DeskAreaCategoriesCreateViewModel deskAreaCategoriesCreateViewModel = new();

            return PartialView("_ModalDeskAreaCategoriesCreatePartial", deskAreaCategoriesCreateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DMSHelper.ActionITAdm)]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeskAreaCategoriesCreate([FromForm] DeskAreaCategoriesCreateViewModel deskAreaCategoriesCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _deskAreaCategoriesRepository.DeskAreaCategoriesCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PAreaCatgCode = deskAreaCategoriesCreateViewModel.AreaCatgCode,
                            PAreaDesc = deskAreaCategoriesCreateViewModel.AreaDesc
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

            return PartialView("_ModalDeskAreaCategoriesCreatePartial", deskAreaCategoriesCreateViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> DeskAreaCategoriesEdit(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            DeskAreaCategoriesDetails result = await _deskAreaCategoriesDetailRepository.DeskAreaCategoriesDetail(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PAreaCatgCode = id
                });

            DeskAreaCategoriesUpdateViewModel deskAreaCategoriesUpdateViewModel = new();

            if (result.PMessageType == IsOk)
            {
                deskAreaCategoriesUpdateViewModel.AreaCatgCode = id;
                deskAreaCategoriesUpdateViewModel.AreaDesc = result.PAreaDescription;
            }

            return PartialView("_ModalDeskAreaCategoriesEditPartial", deskAreaCategoriesUpdateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DMSHelper.ActionITAdm)]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeskAreaCategoriesEdit([FromForm] DeskAreaCategoriesUpdateViewModel deskAreaCategoriesUpdateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _deskAreaCategoriesRepository.DeskAreaCategoriesEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PAreaCatgCode = deskAreaCategoriesUpdateViewModel.AreaCatgCode,
                            PAreaDesc = deskAreaCategoriesUpdateViewModel.AreaDesc
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

            return PartialView("_ModalDeskAreaCategoriesEditPartial", deskAreaCategoriesUpdateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DMSHelper.ActionITAdm)]
        public async Task<IActionResult> DeskAreaCategoriesDelete(string id)
        {
            try
            {
                var result = await _deskAreaCategoriesRepository.DeskAreaCategoriesDeleteAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PAreaCatgCode = id
                    }
                    );

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        public async Task<IActionResult> DeskAreaCategoriesExcelDownload()
        {
            try
            {
                var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
                {
                    PModuleName = CurrentUserIdentity.CurrentModule,
                    PMetaId = CurrentUserIdentity.MetaId,
                    PPersonId = CurrentUserIdentity.EmployeeId,
                    PMvcActionName = ConstFilterDeskAreaCategoriesIndex
                });
                FilterDataModel filterDataModel = new();
                if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                {
                    filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
                }

                string StrFimeName;

                var timeStamp = DateTime.Now.ToFileTime();
                StrFimeName = "Area categories_" + timeStamp.ToString();

                string strUser = User.Identity.Name;

                IEnumerable<DeskAreaCategoriesDataTableList> data = await _deskAreaCategoriesDataTableListRepository.DeskAreaCategoriesDataTableListForExcelAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                    });

                if (data == null) { return NotFound(); }

                var json = JsonConvert.SerializeObject(data);

                IEnumerable<DeskAreaCategoriesDataTableExcel> excelData = JsonConvert.DeserializeObject<IEnumerable<DeskAreaCategoriesDataTableExcel>>(json);

                byte[] byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, "Desk area categories", "Desk area categories");

                var mimeType = MimeTypeMap.GetMimeType("xlsx");

                FileContentResult file = File(byteContent, mimeType, StrFimeName);

                return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        #endregion DeskAreaCategoriesIndex

        #region DeskBayIndex

        public async Task<IActionResult> DeskBayIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterBayIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            DeskBayViewModel deskBayViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(deskBayViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsDeskBay(DTParameters param)
        {
            DTResult<BayDataTableList> result = new();
            int totalRow = 0;

            try
            {
                System.Collections.Generic.IEnumerable<BayDataTableList> data = await _bayDataTableListRepository.BayDataTableListAsync(
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
        public IActionResult DeskBayCreate()
        {
            DeskBayCreateViewModel deskBayCreateViewModel = new();

            return PartialView("_ModalDeskBayCreatePartial", deskBayCreateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DMSHelper.ActionITAdm)]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeskBayCreate([FromForm] DeskBayCreateViewModel deskBayCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _bayRepository.BayCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PBayId = deskBayCreateViewModel.BayId,
                            PBayDesc = deskBayCreateViewModel.BayDesc
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

            return PartialView("_ModalDeskBayCreatePartial", deskBayCreateViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> DeskBayEdit(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            BayDetails result = await _bayDetailRepository.BayDetail(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PBayId = id
                });

            DeskBayUpdateViewModel deskBayUpdateViewModel = new();

            if (result.PMessageType == IsOk)
            {
                deskBayUpdateViewModel.BayId = id;
                deskBayUpdateViewModel.BayDesc = result.PBayDesc;
            }

            return PartialView("_ModalDeskBayEditPartial", deskBayUpdateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DMSHelper.ActionITAdm)]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeskBayEdit([FromForm] DeskBayUpdateViewModel deskBayUpdateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _bayRepository.BayEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PBayId = deskBayUpdateViewModel.BayId,
                            PBayDesc = deskBayUpdateViewModel.BayDesc
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

            return PartialView("_ModalDeskBayEditPartial", deskBayUpdateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DMSHelper.ActionITAdm)]
        public async Task<IActionResult> DeskBayDelete(string id)
        {
            try
            {
                var result = await _bayRepository.BayDeleteAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PBayId = id
                    }
                    );

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        public async Task<IActionResult> DeskBayExcelDownload()
        {
            try
            {
                var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
                {
                    PModuleName = CurrentUserIdentity.CurrentModule,
                    PMetaId = CurrentUserIdentity.MetaId,
                    PPersonId = CurrentUserIdentity.EmployeeId,
                    PMvcActionName = ConstFilterBayIndex
                });
                FilterDataModel filterDataModel = new();
                if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                {
                    filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
                }

                string StrFimeName;

                var timeStamp = DateTime.Now.ToFileTime();
                StrFimeName = "Bay_" + timeStamp.ToString();

                string strUser = User.Identity.Name;

                IEnumerable<BayDataTableList> data = await _bayDataTableListRepository.BayDataTableListForExcelAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                    });

                if (data == null) { return NotFound(); }

                var json = JsonConvert.SerializeObject(data);

                IEnumerable<DeskBayDataTableExcel> excelData = JsonConvert.DeserializeObject<IEnumerable<DeskBayDataTableExcel>>(json);

                byte[] byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, "Bays", "Bays");

                var mimeType = MimeTypeMap.GetMimeType("xlsx");

                FileContentResult file = File(byteContent, mimeType, StrFimeName);

                return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        #endregion DeskBayIndex

        #region DeskAreaIndex

        public async Task<IActionResult> DeskAreaIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterDeskAreaIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            DeskAreaViewModel deskAreaViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(deskAreaViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsDeskArea(DTParameters param)
        {
            DTResult<DeskAreaDataTableList> result = new();
            int totalRow = 0;

            try
            {
                System.Collections.Generic.IEnumerable<DeskAreaDataTableList> data = await _deskAreaDataTableListRepository.DeskAreaDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch ?? " ",
                        PIsRestricted = param.IsRestricted,
                        PAreaCatgCode = param.AreaCatgCode,
                        PAreaType = param.AreaType,
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
        public async Task<IActionResult> DeskAreaCreate()
        {
            DeskAreaCreateViewModel deskAreaCreateViewModel = new();
            var areaCatgCodeList = await _selectTcmPLRepository.DmsAreaCatgCodeList(BaseSpTcmPLGet(), null);
            ViewData["AreaCatgCodeList"] = new SelectList(areaCatgCodeList, "DataValueField", "DataTextField");

            var areaTypeList = await _selectTcmPLRepository.DmsAreaTypeList(BaseSpTcmPLGet(), null);
            ViewData["AreaTypeList"] = new SelectList(areaTypeList, "DataValueField", "DataTextField");

            IEnumerable<DataField> tagTypeList = await _selectTcmPLRepository.DmsTagTypeList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["TagTypeList"] = new SelectList(tagTypeList, "DataValueField", "DataTextField");

            return PartialView("_ModalDeskAreaCreatePartial", deskAreaCreateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DMSHelper.ActionITAdm)]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeskAreaCreate([FromForm] DeskAreaCreateViewModel deskAreaCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _deskAreaRepository.DeskAreaCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PAreaId = deskAreaCreateViewModel.AreaId,
                            PAreaDesc = deskAreaCreateViewModel.AreaDesc,
                            PAreaCatgCode = deskAreaCreateViewModel.AreaCatgCode,
                            PAreaInfo = deskAreaCreateViewModel.AreaInfo,
                            PAreaType = deskAreaCreateViewModel.AreaType,
                            PIsRestricted = deskAreaCreateViewModel.IsRestricted,
                            PIsActive = deskAreaCreateViewModel.IsActive,
                            PTagId = deskAreaCreateViewModel.TagId
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

            var areaCatgCodeList = await _selectTcmPLRepository.DmsAreaCatgCodeList(BaseSpTcmPLGet(), null);
            ViewData["AreaCatgCodeList"] = new SelectList(areaCatgCodeList, "DataValueField", "DataTextField");

            var areaTypeList = await _selectTcmPLRepository.DmsAreaTypeList(BaseSpTcmPLGet(), null);
            ViewData["AreaTypeList"] = new SelectList(areaTypeList, "DataValueField", "DataTextField");

            IEnumerable<DataField> tagTypeList = await _selectTcmPLRepository.DmsTagTypeList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["TagTypeList"] = new SelectList(tagTypeList, "DataValueField", "DataTextField");

            return PartialView("_ModalDeskAreaCreatePartial", deskAreaCreateViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> DeskAreaEdit(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            DeskAreaDetails result = await _deskAreaDetailRepository.DeskAreaDetail(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PAreaId = id
                });

            DeskAreaUpdateViewModel deskAreaUpdateViewModel = new();

            if (result.PMessageType == IsOk)
            {
                deskAreaUpdateViewModel.AreaId = id;
                deskAreaUpdateViewModel.AreaDesc = result.PAreaDesc;
                deskAreaUpdateViewModel.AreaCatgCode = result.PAreaCatgCode;
                deskAreaUpdateViewModel.AreaInfo = result.PAreaInfo;
                deskAreaUpdateViewModel.AreaType = result.PAreaTypeVal;
                deskAreaUpdateViewModel.IsRestricted = result.PIsRestrictedVal;
                deskAreaUpdateViewModel.IsActive = result.PIsActiveVal;
                deskAreaUpdateViewModel.TagIdList = result.PTagId?.Split(',');
            }
            var areaCatgCodeList = await _selectTcmPLRepository.DmsAreaCatgCodeList(BaseSpTcmPLGet(), null);
            ViewData["AreaCatgCodeList"] = new SelectList(areaCatgCodeList, "DataValueField", "DataTextField", deskAreaUpdateViewModel.AreaCatgCode);

            var areaTypeList = await _selectTcmPLRepository.DmsAreaTypeList(BaseSpTcmPLGet(), null);
            ViewData["AreaTypeList"] = new SelectList(areaTypeList, "DataValueField", "DataTextField", deskAreaUpdateViewModel.AreaType);

            IEnumerable<DataField> tagTypeList = await _selectTcmPLRepository.DmsTagTypeList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["TagTypeList"] = new SelectList(tagTypeList, "DataValueField", "DataTextField", deskAreaUpdateViewModel.TagIdList);

            return PartialView("_ModalDeskAreaEditPartial", deskAreaUpdateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DMSHelper.ActionITAdm)]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeskAreaEdit([FromForm] DeskAreaUpdateViewModel deskAreaUpdateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    //string[] updatedTagIdList = deskAreaUpdateViewModel.TagIdList.Skip(1).ToArray();
                    //string newTagIdList = String.Join(",", updatedTagIdList);
                    string newTagIdList = "";

                    if (deskAreaUpdateViewModel.TagIdList != null)
                    {
                        newTagIdList = string.Join(",", deskAreaUpdateViewModel.TagIdList.Where(s => !string.IsNullOrEmpty(s) && s != "System.String[]"));
                    }

                    var result = await _deskAreaRepository.DeskAreaEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PAreaId = deskAreaUpdateViewModel.AreaId,
                            PAreaDesc = deskAreaUpdateViewModel.AreaDesc,
                            PAreaCatgCode = deskAreaUpdateViewModel.AreaCatgCode,
                            PAreaInfo = deskAreaUpdateViewModel.AreaInfo,
                            PAreaType = deskAreaUpdateViewModel.AreaType,
                            PIsRestricted = deskAreaUpdateViewModel.IsRestricted,
                            PTagId = newTagIdList,
                            PIsActive = deskAreaUpdateViewModel.IsActive
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

            var areaCatgCodeList = await _selectTcmPLRepository.DmsAreaCatgCodeList(BaseSpTcmPLGet(), null);
            ViewData["AreaCatgCodeList"] = new SelectList(areaCatgCodeList, "DataValueField", "DataTextField", deskAreaUpdateViewModel.AreaCatgCode);

            var areaTypeList = await _selectTcmPLRepository.DmsAreaTypeList(BaseSpTcmPLGet(), null);
            ViewData["AreaTypeList"] = new SelectList(areaTypeList, "DataValueField", "DataTextField", deskAreaUpdateViewModel.AreaType);

            IEnumerable<DataField> tagTypeList = await _selectTcmPLRepository.DmsTagTypeList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["TagTypeList"] = new SelectList(tagTypeList, "DataValueField", "DataTextField", deskAreaUpdateViewModel.TagIdList);

            return PartialView("_ModalDeskAreaEditPartial", deskAreaUpdateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DMSHelper.ActionITAdm)]
        public async Task<IActionResult> DeskAreaDelete(string id)
        {
            try
            {
                var result = await _deskAreaRepository.DeskAreaDeleteAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PAreaId = id
                    }
                    );

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        public async Task<IActionResult> DeskAreaExcelDownload()
        {
            try
            {
                DataTable dt = new();

                DataTable dtDeskArea = new();
                DataTable dtDeskList = new();
                DataTable dtUserList = new();

                var timeStamp = DateTime.Now.ToFileTime();
                string StrFimeName = "Area_" + timeStamp.ToString();

                string strUser = User.Identity.Name;

                IEnumerable<DeskAreaDataTableList> resultDeskArea = await _deskAreaDataTableListRepository.DeskAreaDataTableListForExcelAsync(
                                        BaseSpTcmPLGet(),
                                        new ParameterSpTcmPL
                                        {
                                        });

                IEnumerable<DeskMasterDataTableList> resultDeskList = await _deskMasterDataTableListRepository.DeskMasterDataTableListForExcelAsync(
                                        BaseSpTcmPLGet(),
                                        new ParameterSpTcmPL
                                        {
                                        });

                IEnumerable<DeskAreaUserMapDataTableList> resultUserList = await _deskAreaUserMapDataTableListRepository.DeskAreaUserMapDataTableListForExcelAsync(
                                        BaseSpTcmPLGet(),
                                        new ParameterSpTcmPL
                                        {
                                        });

                if (resultDeskArea == null)
                {
                    return NotFound();
                }

                using XLWorkbook wb = new();
                var sheet1 = wb.Worksheets.Add("Desk area categories");
                _ = sheet1.Cell(3, 1).InsertTable(resultDeskArea);

                var sheet2 = wb.Worksheets.Add("Desk list");
                _ = sheet2.Cell(3, 1).InsertTable(resultDeskList);

                var sheet3 = wb.Worksheets.Add("User list");
                _ = sheet3.Cell(3, 1).InsertTable(resultUserList);

                await Task.Delay(1000);

                sheet1.Columns(1, 2).Delete();
                sheet1.Cell(1, 1).Value = "Desk area categories";

                sheet2.Columns(1, 2).Delete();
                sheet2.Cell(1, 1).Value = "Desk list";

                sheet3.Columns(1, 2).Delete();
                sheet3.Cell(1, 1).Value = "User list";

                using MemoryStream stream = new();
                wb.SaveAs(stream);
                stream.Position = 0;
                byte[] byteContent = stream.ToArray();

                var mimeType = MimeTypeMap.GetMimeType("xlsx");

                FileContentResult file = File(byteContent, mimeType, StrFimeName);

                return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        #region Desk area excel import

        [HttpGet]
        public async Task<IActionResult> ImportDeskArea(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var areaId = id.Split("!-!")[0];
            _ = id.Split("!-!")[1];

            var deskAreaDetails = await _deskAreaDetailRepository.DeskAreaDetail(
               BaseSpTcmPLGet(),
               new ParameterSpTcmPL
               {
                   PAreaId = areaId
               });

            IEnumerable<DataField> resultOfficeLocation = await _selectTcmPLRepository.DeskBookOfficeLocationList(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            ViewData["OfficeLocation"] = new SelectList(resultOfficeLocation, "DataValueField", "DataTextField");
            ViewData["AreaId"] = areaId;
            ViewData["AreaName"] = areaId + " - " + deskAreaDetails.PAreaDesc;
            ViewData["AreaCategoryCodeName"] = deskAreaDetails.PAreaCatgCode + " - " + deskAreaDetails.PAreaCatgDesc;
            ViewData["AreaTypeName"] = deskAreaDetails.PAreaTypeVal + " - " + deskAreaDetails.PAreaTypeText;

            return PartialView("_ModalMastersDeskAreaImportPartial");
        }

        [HttpGet]
        public async Task<IActionResult> ExportDMSDeskAreaTemplate(string deskAreaTemplateType, string areaId)
        {
            if (deskAreaTemplateType == string.Empty || areaId == string.Empty)
            {
                return Json(new { success = false, response = "Parameter values not found" });
            }

            try
            {
                string fileName = string.Empty;
                var mimeType = MimeTypeMap.GetMimeType("xlsx");
                List<DictionaryItem> dictionaryItems = new();

                var deskAreaDetails = await _deskAreaDetailRepository.DeskAreaDetail(
                   BaseSpTcmPLGet(),
                   new ParameterSpTcmPL
                   {
                       PAreaId = areaId
                   });

                if (deskAreaTemplateType == "Desk")
                {
                    // Area id
                    dictionaryItems.Add(new Library.Excel.Template.Models.DictionaryItem
                    {
                        FieldName = "AreaId",
                        Value = areaId + " - " + deskAreaDetails.PAreaDesc
                    });

                    //Area category code
                    dictionaryItems.Add(new Library.Excel.Template.Models.DictionaryItem
                    {
                        FieldName = "AreaCatgCode",
                        Value = deskAreaDetails.PAreaCatgCode + " - " + deskAreaDetails.PAreaCatgDesc
                    });

                    var ms = _excelTemplate.ExportDMSDeskAreaDeskList("v01",
                        new Library.Excel.Template.Models.DictionaryCollection
                        {
                            DictionaryItems = dictionaryItems
                        },
                        500);

                    //OVERWRITTEN BY PAGE SCRIPT IN Index.cshtml
                    fileName = "ImporDeskAreaDeskListTemplate.xlsx";

                    ms.Position = 0;
                    return File(ms, mimeType, fileName);
                }

                if (deskAreaTemplateType == "User")
                {
                    // Area id
                    dictionaryItems.Add(new Library.Excel.Template.Models.DictionaryItem
                    {
                        FieldName = "AreaId",
                        Value = areaId + " - " + deskAreaDetails.PAreaDesc
                    });

                    //Area category code
                    dictionaryItems.Add(new Library.Excel.Template.Models.DictionaryItem
                    {
                        FieldName = "AreaCatgCode",
                        Value = deskAreaDetails.PAreaCatgCode + " - " + deskAreaDetails.PAreaCatgDesc
                    });

                    //Area type
                    dictionaryItems.Add(new Library.Excel.Template.Models.DictionaryItem
                    {
                        FieldName = "AreaType",
                        Value = deskAreaDetails.PAreaTypeVal + " - " + deskAreaDetails.PAreaTypeText
                    });

                    var ms = _excelTemplate.ExportDMSDeskAreaUserList("v01",
                        new Library.Excel.Template.Models.DictionaryCollection
                        {
                            DictionaryItems = dictionaryItems
                        },
                        500);

                    //OVERWRITTEN BY PAGE SCRIPT IN Index.cshtml
                    fileName = "ImporDeskAreaUserListTemplate.xlsx";

                    ms.Position = 0;
                    return File(ms, mimeType, fileName);
                }

                return null;
            }
            catch (Exception ex)
            {
                throw new CustomJsonException(ex.Message, ex);
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ImportDMSDeskAreaTemplate(string deskAreaTemplateType, string deskAreaOfficeLocation, IFormFile file)
        {
            if (deskAreaTemplateType == string.Empty || deskAreaOfficeLocation == string.Empty || file == null || file.Length == 0)
            {
                return Json(new { success = false, response = "File not uploaded due to unrecongnised parameters" });
            }

            try
            {
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
                string jsonString = string.Empty;
                //byte[] byteArray;

                if (deskAreaTemplateType == "Desk")
                {
                    List<DeskAreaDeskList> deskAreaDeskItems = _excelTemplate.ImportDMSDeskAreaDeskList(stream);

                    string[] aryDesks = deskAreaDeskItems.Select(p =>
                                                           p.AreaId?[..3] + "~!~" +
                                                           p.AreaCatgCode?[..4] + "~!~" +
                                                           p.DeskId).ToArray();

                    var uploadOutPutDesk = await _deskAreaDeskListImportRepository.ImportDeskAreaDeskListAsync(
                            BaseSpTcmPLGet(),
                            new ParameterSpTcmPL
                            {
                                PDeskAreaDesk = aryDesks
                            }
                        );

                    List<ImportFileResultViewModel> importFileResults = new();

                    if (uploadOutPutDesk.PDeskAreaDeskErrors?.Length > 0)
                    {
                        foreach (string err in uploadOutPutDesk.PDeskAreaDeskErrors)
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

                    if (uploadOutPutDesk.PMessageType != BaseController.IsOk)
                    {
                        if (importFileResults.Any())
                        {
                            var streamError = _excelTemplate.ValidateImport(stream, validationItems);
                            FileContentResult fileContentResult = base.File(streamError.ToArray(), mimeType, fileNameErrors);

                            var resultJsonError = new
                            {
                                success = false,
                                response = uploadOutPutDesk.PMessageText,
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
                                response = uploadOutPutDesk.PMessageText,
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

                if (deskAreaTemplateType == "User")
                {
                    List<DeskAreaUserList> deskAreaUserItems = _excelTemplate.ImportDMSDeskAreaUserList(stream);

                    string[] aryUsers = deskAreaUserItems.Select(p =>
                                                           p.AreaId?[..3] + "~!~" +
                                                           p.AreaCatgCode?[..4] + "~!~" +
                                                           p.AreaType?[..4] + "~!~" +
                                                           p.Empno).ToArray();

                    var uploadOutPutUser = await _deskAreaUserListImportRepository.ImportDeskAreaUserListAsync(
                            BaseSpTcmPLGet(),
                            new ParameterSpTcmPL
                            {
                                PDeskAreaUser = aryUsers,
                                POfficeCode = deskAreaOfficeLocation
                            }
                        );

                    List<ImportFileResultViewModel> importFileResults = new();

                    if (uploadOutPutUser.PDeskAreaUserErrors?.Length > 0)
                    {
                        foreach (string err in uploadOutPutUser.PDeskAreaUserErrors)
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

                    if (uploadOutPutUser.PMessageType != BaseController.IsOk)
                    {
                        if (importFileResults.Any())
                        {
                            var streamError = _excelTemplate.ValidateImport(stream, validationItems);
                            FileContentResult fileContentResult = base.File(streamError.ToArray(), mimeType, fileNameErrors);

                            var resultJsonError = new
                            {
                                success = false,
                                response = uploadOutPutUser.PMessageText,
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
                                response = uploadOutPutUser.PMessageText,
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

                return base.Json("Undefined error");
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

        #endregion Desk area excel import

        #endregion DeskAreaIndex

        #region OfficeIndex

        public async Task<IActionResult> OfficeIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterOfficeIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            OfficeViewModel officeViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(officeViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsOffice(string paramJson)
        {
            DTResult<OfficeDataTableList> result = new();
            int totalRow = 0;
            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);
            try
            {
                System.Collections.Generic.IEnumerable<OfficeDataTableList> data = await _officeDataTableListRepository.OfficeDataTableListAsync(
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
        public async Task<IActionResult> OfficesCreate()
        {
            OfficesCreateViewModel officeCreateViewModel = new();

            IEnumerable<DataField> officeList = await _selectTcmPLRepository.HRMISOfficeLocationList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["OfficeList"] = new SelectList(officeList, "DataValueField", "DataTextField");

            return PartialView("_ModalOfficeCreatePartial", officeCreateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DMSHelper.ActionITAdm)]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> OfficesCreate([FromForm] OfficesCreateViewModel officeCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _officeRequestRepository.OfficesCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            POfficeCode = officeCreateViewModel.OfficeCode,
                            POfficeName = officeCreateViewModel.OfficeName,
                            POfficeDesc = officeCreateViewModel.OfficeDesc,
                            POfficeLocationCode = officeCreateViewModel.OfficeLocationCode,
                            PSmartDeskBookingEnabled = officeCreateViewModel.SmartDeskBookingEnabled,
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

            IEnumerable<DataField> officeList = await _selectTcmPLRepository.HRMISOfficeLocationList(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            ViewData["OfficeList"] = new SelectList(officeList, "DataValueField", "DataTextField", officeCreateViewModel.OfficeLocationCode);

            return PartialView("_ModalOfficeCreatePartial", officeCreateViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> OfficeEdit(string id)
        {
            try
            {
                if (id == null)
                {
                    return NotFound();
                }
                OfficesUpdateViewModel officeUpdateViewModel = new();

                var result = await _officeDetailRepository.OfficeDetail(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    POfficeCode = id
                });

                if (result.PMessageType == IsOk)
                {
                    officeUpdateViewModel.OfficeCode = id;
                    officeUpdateViewModel.OfficeName = result.POfficeName;
                    officeUpdateViewModel.OfficeDesc = result.POfficeDesc;
                    officeUpdateViewModel.OfficeLocationCode = result.POfficeLocationVal;
                    officeUpdateViewModel.SmartDeskBookingEnabled = result.PSmartDeskBookingEnabledVal;
                }

                IEnumerable<DataField> officeList = await _selectTcmPLRepository.HRMISOfficeLocationList(BaseSpTcmPLGet(), new ParameterSpTcmPL());

                ViewData["OfficeList"] = new SelectList(officeList, "DataValueField", "DataTextField", officeUpdateViewModel.OfficeLocationCode);

                return PartialView("_ModalOfficesUpdatePartial", officeUpdateViewModel);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DMSHelper.ActionITAdm)]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> OfficeEdit([FromForm] OfficesUpdateViewModel officesUpdateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _officeRequestRepository.OfficesEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            POfficeCode = officesUpdateViewModel.OfficeCode,
                            POfficeName = officesUpdateViewModel.OfficeName,
                            POfficeDesc = officesUpdateViewModel.OfficeDesc,
                            POfficeLocationCode = officesUpdateViewModel.OfficeLocationCode,
                            PSmartDeskBookingEnabled = officesUpdateViewModel.SmartDeskBookingEnabled,
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

            IEnumerable<DataField> officeList = await _selectTcmPLRepository.HRMISOfficeLocationList(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            ViewData["OfficeList"] = new SelectList(officeList, "DataValueField", "DataTextField", officesUpdateViewModel.OfficeLocationCode);

            return PartialView("_ModalOfficesUpdatePartial", officesUpdateViewModel);
        }

        public async Task<IActionResult> OfficeExcelDownload()
        {
            var timeStamp = DateTime.Now.ToFileTime();

            string fileName = "Office List_" + timeStamp.ToString();
            string reportTitle = "Office List";
            string sheetName = "Office List";

            IEnumerable<OfficeDataTableList> data = await _officeDataTableListRepository.OfficeDataTableListForExcelAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                });

            if (data == null) { return NotFound(); }

            var json = JsonConvert.SerializeObject(data);

            IEnumerable<OfficeDataTableExcel> excelData = JsonConvert.DeserializeObject<IEnumerable<OfficeDataTableExcel>>(json);

            var byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, reportTitle, sheetName);

            var mimeType = MimeTypeMap.GetMimeType("xlsx");

            FileContentResult file = File(byteContent, mimeType, fileName);

            return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
        }

        [HttpGet]
        public async Task<IActionResult> OfficeDetails(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var result = await _officeDetailRepository.OfficeDetail(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    POfficeCode = id
                });

            OfficeDetailsViewModel officeDetailsViewModel = new();

            if (result.PMessageType == IsOk)
            {
                officeDetailsViewModel.OfficeCode = id;
                officeDetailsViewModel.OfficeName = result.POfficeName;
                officeDetailsViewModel.OfficeDesc = result.POfficeDesc;
                officeDetailsViewModel.OfficeLocationVal = result.POfficeLocationVal;
                officeDetailsViewModel.OfficeLocationTxt = result.POfficeLocationTxt;
                officeDetailsViewModel.SmartDeskBookingEnabledVal = result.PSmartDeskBookingEnabledVal;
                officeDetailsViewModel.SmartDeskBookingEnabledTxt = result.PSmartDeskBookingEnabledTxt;
            }

            return PartialView("_ModalOfficeDetailsPartial", officeDetailsViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DMSHelper.ActionITAdm)]
        public async Task<IActionResult> OfficeDelete(string id)
        {
            try
            {
                var result = await _officeRequestRepository.OfficesDeleteAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        POfficeCode = id
                    }
                    );

                return Json(new { success = result.PMessageType == IsOk, response = result.PMessageType, message = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        #endregion OfficeIndex

        #region DeskAreaOfficeMapIndex

        public async Task<IActionResult> DeskAreaOfficeMapIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterDeskAreaOfficeMapIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            DeskAreaOfficeMapViewModel deskAreaOfficeMapViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(deskAreaOfficeMapViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsDeskAreaOfficeMap(string paramJson)
        {
            DTResult<DeskAreaOfficeMapDataTableList> result = new();
            int totalRow = 0;
            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);
            try
            {
                System.Collections.Generic.IEnumerable<DeskAreaOfficeMapDataTableList> data = await _deskAreaOfficeMapDataTableListRepository.DeskAreaOfficeMapDataTableListAsync(
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
        public async Task<IActionResult> DeskAreaOfficeMapCreate()
        {
            DeskAreaOfficeMapCreateViewModel deskAreaOfficeMapCreateViewModel = new();

            IEnumerable<DataField> officeList = await _selectTcmPLRepository.DmsOfficeList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["OfficeList"] = new SelectList(officeList, "DataValueField", "DataTextField");

            IEnumerable<DataField> areaList = await _selectTcmPLRepository.DmsAreaList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["AreaList"] = new SelectList(areaList, "DataValueField", "DataTextField");

            return PartialView("_ModalDeskAreaOfficeMapCreatePartial", deskAreaOfficeMapCreateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DMSHelper.ActionITAdm)]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeskAreaOfficeMapCreate([FromForm] DeskAreaOfficeMapCreateViewModel deskAreaOfficeMapCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _deskAreaOfficeMapRequestRepository.DeskAreaOfficeMapCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PAreaId = deskAreaOfficeMapCreateViewModel.AreaId,
                            POfficeCode = deskAreaOfficeMapCreateViewModel.OfficeCode,
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

            IEnumerable<DataField> officeList = await _selectTcmPLRepository.DmsOfficeList(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            ViewData["OfficeList"] = new SelectList(officeList, "DataValueField", "DataTextField", deskAreaOfficeMapCreateViewModel.OfficeCode);

            IEnumerable<DataField> areaList = await _selectTcmPLRepository.DmsAreaCatgCodeList(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            ViewData["AreaList"] = new SelectList(areaList, "DataValueField", "DataTextField", deskAreaOfficeMapCreateViewModel.AreaId);

            return PartialView("_ModalDeskAreaOfficeMapCreatePartial", deskAreaOfficeMapCreateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DMSHelper.ActionITAdm)]
        public async Task<IActionResult> DeskAreaOfficeMapDelete(string id, string code)
        {
            try
            {
                var result = await _deskAreaOfficeMapRequestRepository.DeskAreaOfficeMapDeleteAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PAreaId = id,
                        POfficeCode = code
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
        public async Task<IActionResult> DeskAreaOfficeMapDetails(string id, string code)
        {
            if (id == null)
            {
                return NotFound();
            }

            var result = await _deskAreaOfficeMapDetailRepository.DeskAreaOfficeMapDetail(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PAreaId = id,
                    POfficeCode = code
                });

            DeskAreaOfficeMapDetailsViewModel deskAreaOfficeMapDetailsViewModel = new();

            if (result.PMessageType == IsOk)
            {
                deskAreaOfficeMapDetailsViewModel.AreaText = result.PAreaText;
                deskAreaOfficeMapDetailsViewModel.OfficeText = result.POfficeText;
            }

            return PartialView("_ModalDeskAreaOfficeMapDetailsPartial", deskAreaOfficeMapDetailsViewModel);
        }

        public async Task<IActionResult> DeskAreaOfficeMapExcelDownload()
        {
            var timeStamp = DateTime.Now.ToFileTime();

            string fileName = "Desk Area Office Map List_" + timeStamp.ToString();
            string reportTitle = "Desk Area Office Map List";
            string sheetName = "Desk Area Office Map List";

            IEnumerable<DeskAreaOfficeMapDataTableList> data = await _deskAreaOfficeMapDataTableListRepository.DeskAreaOfficeMapDataTableListForExcelAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                });

            if (data == null) { return NotFound(); }

            var json = JsonConvert.SerializeObject(data);

            IEnumerable<DeskAreaOfficeMapDataTableExcel> excelData = JsonConvert.DeserializeObject<IEnumerable<DeskAreaOfficeMapDataTableExcel>>(json);

            var byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, reportTitle, sheetName);

            var mimeType = MimeTypeMap.GetMimeType("xlsx");

            FileContentResult file = File(byteContent, mimeType, fileName);

            return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
        }

        #endregion DeskAreaOfficeMapIndex

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

        //DmAreaTypeIndex

        #region DmAreaType

        public async Task<IActionResult> DmAreaTypeIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterDmAreaTypeIndex
            });

            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            DmAreaTypeViewModel dmAreaTypViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(dmAreaTypViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsDmAreaType(DTParameters param)
        {
            DTResult<DmAreaTypeDataTableList> result = new();
            int totalRow = 0;

            try
            {
                var data = await _dmAreaTypeDataTableListRepository.AreaTypeDataTableListAsync(
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
        public async Task<IActionResult> DmAreaTypeCreate()
        {
            DmAreaTypCreateViewModel dmAreaTypCreateViewModel = new();

            var dmsAreaTypeMasterList = await _selectTcmPLRepository.DmsAreaTypeList(BaseSpTcmPLGet(), null);
            ViewData["DmsAreaTypeMasterList"] = new SelectList(dmsAreaTypeMasterList, "DataValueField", "DataTextField");

            return PartialView("_ModalDmAreaTypeCreate", dmAreaTypCreateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DMSHelper.ActionITAdm)]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DmAreaTypCreate([FromForm] DmAreaTypCreateViewModel dmAreaTypCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _dmAreaTypeRepository.DmAreaTypeCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PKeyId = dmAreaTypCreateViewModel.KeyId,
                            PShortDesc = dmAreaTypCreateViewModel.ShortDesc,
                            PDescription = dmAreaTypCreateViewModel.Description,
                            PIsActive = dmAreaTypCreateViewModel.IsActive,
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
            var dmsAreaTypeMasterList = await _selectTcmPLRepository.DmsAreaTypeList(BaseSpTcmPLGet(), null);
            ViewData["DmsAreaTypeMasterList"] = new SelectList(dmsAreaTypeMasterList, "DataValueField", "DataTextField");

            return PartialView("_ModalDmAreaTypeCreate", dmAreaTypCreateViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> DmAreaTypeEdit(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            DmAreaTypeDetails result = await _dmAreaTypeDetailRepository.AreaTypeDetail(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PKeyId = id
                });

            DmAreaTypEditViewModel dmAreaTypEditViewModel = new();

            if (result.PMessageType == IsOk)
            {
                dmAreaTypEditViewModel.KeyId = id;
                dmAreaTypEditViewModel.ShortDesc = result.PShortDesc;
                dmAreaTypEditViewModel.Description = result.PDescription;
                dmAreaTypEditViewModel.IsActive = result.PIsActiveVal;
            }

            return PartialView("_ModalDmAreaTypeEdit", dmAreaTypEditViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DMSHelper.ActionITAdm)]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DmAreaTypeEdit([FromForm] DmAreaTypEditViewModel dmAreaTypEditViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _dmAreaTypeRepository.DmAreaTypeEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PKeyId = dmAreaTypEditViewModel.KeyId,
                            PShortDesc = dmAreaTypEditViewModel.ShortDesc,
                            PDescription = dmAreaTypEditViewModel.Description,
                            PIsActive = dmAreaTypEditViewModel.IsActive
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

            return PartialView("_ModalDmAreaTypeEdit", dmAreaTypEditViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DMSHelper.ActionITAdm)]
        public async Task<IActionResult> DmAreaTypeDelete(string id)
        {
            try
            {
                var result = await _dmAreaTypeRepository.DmAreaTypeDeleteAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PKeyId = id
                    }
                    );

                return Json(new { success = result.PMessageType == "OK", message = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = ex.Message });
            }
        }

        //public async Task<IActionResult> DmAreaTypExcelDownload()
        //{
        //    try
        //    {
        //        var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
        //        {
        //            PModuleName = CurrentUserIdentity.CurrentModule,
        //            PMetaId = CurrentUserIdentity.MetaId,
        //            PPersonId = CurrentUserIdentity.EmployeeId,
        //            PMvcActionName = ConstFilterBayIndex
        //        });
        //        FilterDataModel filterDataModel = new FilterDataModel();
        //        if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
        //            filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

        //        string StrFimeName;

        //        var timeStamp = DateTime.Now.ToFileTime();
        //        StrFimeName = "Bay_" + timeStamp.ToString();

        //        string strUser = User.Identity.Name;

        //        IEnumerable<BayDataTableList> data = await _bayDataTableListRepository.BayDataTableListForExcelAsync(
        //            BaseSpTcmPLGet(),
        //            new ParameterSpTcmPL
        //            {
        //            });

        //        if (data == null) { return NotFound(); }

        //        var json = JsonConvert.SerializeObject(data);

        //        IEnumerable<DmAreaTypDataTableExcel> excelData = JsonConvert.DeserializeObject<IEnumerable<DmAreaTypDataTableExcel>>(json);

        //        byte[] byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, "Bays", "Bays");

        //        var mimeType = MimeTypeMap.GetMimeType("xlsx");

        //        FileContentResult file = File(byteContent, mimeType, StrFimeName);

        //        return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
        //    }
        //    catch (Exception ex)
        //    {
        //        return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
        //    }
        //}

        #endregion DmAreaType

        #region DeskAreaDepartmentMapping

        public async Task<IActionResult> DeskAreaDepartmentMapIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterDeskAreaDepartmentMapIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            DeskAreaDepartmentMapViewModel deskAreaDepartmentMapViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(deskAreaDepartmentMapViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsDeskAreaDepartmentMap(string paramJson)
        {
            DTResult<DeskAreaDepartmentMapDataTableList> result = new();
            int totalRow = 0;
            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);
            try
            {
                System.Collections.Generic.IEnumerable<DeskAreaDepartmentMapDataTableList> data = await _deskAreaDepartmentMapDataTableListRepository.DeskAreaDepartmentMapDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch ?? " ",
                        PAreaId = param.AreaId,
                        PCostCode = param.Costcode,
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
        public async Task<IActionResult> DeskAreaDepartmentMapCreate(string areaId)
        {
            try
            {
                DeskAreaDepartmentMapCreateViewModel deskAreaDepartmentMapCreateViewModel = new();

                DeskAreaDetails result = await _deskAreaDetailRepository.DeskAreaDetail(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PAreaId = areaId
                });

                IEnumerable<DataField> costCodeList = await _selectTcmPLRepository.DeskBookCostcodeList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
                ViewData["CostCodeList"] = new SelectList(costCodeList, "DataValueField", "DataTextField");

                deskAreaDepartmentMapCreateViewModel.AreaId = areaId;
                deskAreaDepartmentMapCreateViewModel.AreaDesc = result.PAreaDesc;
                deskAreaDepartmentMapCreateViewModel.AreaCatgCode = result.PAreaCatgCode;
                deskAreaDepartmentMapCreateViewModel.AreaCatgDesc = result.PAreaCatgDesc;

                return PartialView("_ModalDeskAreaDepartmentMapCreate", deskAreaDepartmentMapCreateViewModel);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DMSHelper.ActionITAdm)]
        public async Task<IActionResult> DeskAreaDepartmentMapCreate([FromForm] DeskAreaDepartmentMapCreateViewModel deskAreaDepartmentMapCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _deskAreaDepartmentMapRequestRepository.DeskAreaDepartmentMapCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PAreaId = deskAreaDepartmentMapCreateViewModel.AreaId,
                            PCostCode = deskAreaDepartmentMapCreateViewModel.CostCode,
                        });

                    return result.PMessageType == IsOk
                        ? RedirectToAction("DeskAreaDepartmentMapList", new { id = deskAreaDepartmentMapCreateViewModel.AreaId })
                        : StatusCode((int)HttpStatusCode.InternalServerError, result.PMessageText);
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            IEnumerable<DataField> costCodeList = await _selectTcmPLRepository.DeskBookCostcodeList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["CostCodeList"] = new SelectList(costCodeList, "DataValueField", "DataTextField", deskAreaDepartmentMapCreateViewModel.CostCode);

            return PartialView("_ModalDeskAreaDeptMapCreate", deskAreaDepartmentMapCreateViewModel);
        }

        public async Task<IActionResult> DeskAreaDepartmentMapList(string id)
        {
            try
            {
                if (id == null)
                {
                    return NotFound();
                }

                DeskAreaDetails result = await _deskAreaDetailRepository.DeskAreaDetail(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PAreaId = id
                });
                DeskAreaDepartmentMapUpdateViewModel deskAreaDepartmentMapUpdateViewModel = new()
                {
                    AreaId = id,
                    AreaDesc = result.PAreaDesc,
                    AreaCatgCode = result.PAreaCatgCode,
                    AreaCatgDesc = result.PAreaCatgDesc
                };

                return PartialView("_ModalDeskAreaDepartmentMapList", deskAreaDepartmentMapUpdateViewModel);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        public async Task<JsonResult> GetListsDepartmentDetailsList(string paramJson)
        {
            DTResult<DeskAreaDepartmentDataTableList> result = new();

            var param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            int totalRow = 0;

            try
            {
                var data = await _deskAreaDepartmentDataTableListRepository.DeskAreaDepartmentDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
                        PAreaId = param.AreaId
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

        [HttpGet]
        public async Task<IActionResult> DeskAreaDepartmentMapEdit(string id)
        {
            try
            {
                if (id == null)
                {
                    return NotFound();
                }
                DeskAreaDepartmentMapUpdateViewModel deskAreaDepartmentMapUpdateViewModel = new();

                var result = await _deskAreaDepartmentMapDetailRepository.DeskAreaDepartmentMapDetail(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PKeyId = id
                });

                if (result.PMessageType == IsOk)
                {
                    deskAreaDepartmentMapUpdateViewModel.KeyId = id;
                    deskAreaDepartmentMapUpdateViewModel.AreaId = result.PAreaId;
                    deskAreaDepartmentMapUpdateViewModel.AreaDesc = result.PAreaDesc;
                    deskAreaDepartmentMapUpdateViewModel.CostCode = result.PCostCode;
                    deskAreaDepartmentMapUpdateViewModel.CostCodeName = result.PCostCodeName;
                }

                return PartialView("_ModalDeskAreaDepartmentMapUpdate", deskAreaDepartmentMapUpdateViewModel);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        public async Task<IActionResult> DeskAreaCostcodeCreate(string areaId, string areaDesc, string areaCatgCode, string areaCatgDesc)
        {
            try
            {
                DeskAreaDepartmentMapCreateViewModel deskAreaDepartmentMapCreateViewModel = new();

                IEnumerable<DataField> costCodeList = await _selectTcmPLRepository.DeskBookCostcodeList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
                ViewData["CostCodeList"] = new SelectList(costCodeList, "DataValueField", "DataTextField");

                deskAreaDepartmentMapCreateViewModel.AreaId = areaId;
                deskAreaDepartmentMapCreateViewModel.AreaDesc = areaDesc;
                deskAreaDepartmentMapCreateViewModel.AreaCatgCode = areaCatgCode;
                deskAreaDepartmentMapCreateViewModel.AreaCatgDesc = areaCatgDesc;

                return PartialView("_ModalDeskAreaDeptMapCreate", deskAreaDepartmentMapCreateViewModel);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DMSHelper.ActionITAdm)]
        public async Task<IActionResult> DeskAreaDepartmentMapEdit([FromForm] DeskAreaDepartmentMapUpdateViewModel deskAreaDepartmentMapUpdateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _deskAreaDepartmentMapRequestRepository.DeskAreaDepartmentMapEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PKeyId = deskAreaDepartmentMapUpdateViewModel.KeyId,
                            PAreaId = deskAreaDepartmentMapUpdateViewModel.AreaId,
                            PCostCode = deskAreaDepartmentMapUpdateViewModel.CostCode
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

            IEnumerable<DataField> areaList = await _selectTcmPLRepository.DeskBookAreaForAssignmentList(BaseSpTcmPLGet(), new ParameterSpTcmPL { PAreaType = ConstDeskTypeForDept });

            ViewData["AreaList"] = new SelectList(areaList, "DataValueField", "DataTextField", deskAreaDepartmentMapUpdateViewModel.AreaId);

            IEnumerable<DataField> costCodeList = await _selectTcmPLRepository.DeskBookCostcodeList(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            ViewData["CostCodeList"] = new SelectList(costCodeList, "DataValueField", "DataTextField", deskAreaDepartmentMapUpdateViewModel.CostCode);

            return PartialView("_ModalDeskAreaDepartmentMapUpdate", deskAreaDepartmentMapUpdateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DMSHelper.ActionITAdm)]
        public async Task<IActionResult> DeskAreaDepartmentMapDelete(string id)
        {
            try
            {
                var result = await _deskAreaDepartmentMapRequestRepository.DeskAreaDepartmentMapDeleteAsync(
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
        public async Task<IActionResult> DeskAreaDepartmentMapDetails(string id)
        {
            try
            {
                if (id == null)
                {
                    return NotFound();
                }

                DeskAreaDetails result = await _deskAreaDetailRepository.DeskAreaDetail(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PAreaId = id
                });
                DeskAreaDepartmentMapDetailsViewModel deskAreaDepartmentMapDetailsViewModel = new()
                {
                    AreaId = id,
                    AreaDesc = result.PAreaDesc,
                    AreaCatgCode = result.PAreaCatgCode,
                    AreaCatgDesc = result.PAreaCatgDesc
                };

                return PartialView("_ModalDeskAreaDepartmentMapDetails", deskAreaDepartmentMapDetailsViewModel);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        public async Task<IActionResult> DeskAreaDepartmentMapExcelDownload()
        {
            var timeStamp = DateTime.Now.ToFileTime();

            string fileName = "Desk Area Department Map List_" + timeStamp.ToString();
            string reportTitle = "Desk Area Department Map List";
            string sheetName = "Desk Area Department Map List";

            IEnumerable<DeskAreaDepartmentMapDataTableList> data = await _deskAreaDepartmentMapDataTableListRepository.DeskAreaDepartmentMapDataTableListForExcelAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                });

            if (data == null) { return NotFound(); }

            var json = JsonConvert.SerializeObject(data);

            IEnumerable<DeskAreaDepartmentMapDataTableExcel> excelData = JsonConvert.DeserializeObject<IEnumerable<DeskAreaDepartmentMapDataTableExcel>>(json);

            var byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, reportTitle, sheetName);

            var mimeType = MimeTypeMap.GetMimeType("xlsx");

            FileContentResult file = File(byteContent, mimeType, fileName);

            return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
        }

        #endregion DeskAreaDepartmentMapping

        #region DeskAreaProjectMapping

        public async Task<IActionResult> DeskAreaProjectMapIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterDeskAreaProjectMapIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            DeskAreaProjectMapViewModel deskAreaProjectMapViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(deskAreaProjectMapViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsDeskAreaProjectMap(string paramJson)
        {
            DTResult<DeskAreaProjectMapDataTableList> result = new();
            int totalRow = 0;
            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);
            try
            {
                System.Collections.Generic.IEnumerable<DeskAreaProjectMapDataTableList> data = await _deskAreaProjectMapDataTableListRepository.DeskAreaProjectMapDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch ?? " ",
                        PAreaId = param.AreaId,
                        PProjectNo = param.ProjectNo,
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

        public async Task<IActionResult> DeskAreaProjectMapList(string id)
        {
            try
            {
                if (id == null)
                {
                    return NotFound();
                }

                DeskAreaDetails result = await _deskAreaDetailRepository.DeskAreaDetail(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PAreaId = id
                });
                DeskAreaProjectMapUpdateViewModel deskAreaProjectMapUpdateViewModel = new()
                {
                    AreaId = id,
                    AreaDesc = result.PAreaDesc,
                    AreaCatgCode = result.PAreaCatgCode,
                    AreaCatgDesc = result.PAreaCatgDesc
                };

                return PartialView("_ModalDeskAreaProjectMapList", deskAreaProjectMapUpdateViewModel);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        public async Task<JsonResult> GetListsProjectDetailsList(string paramJson)
        {
            DTResult<DeskAreaProjectDataTableList> result = new();

            var param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            int totalRow = 0;

            try
            {
                var data = await _deskAreaProjectDataTableListRepository.DeskAreaProjectDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
                        PAreaId = param.AreaId
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

        [HttpGet]
        public async Task<IActionResult> DeskAreaProjectMapCreate(string areaId)
        {
            DeskAreaProjectMapCreateViewModel deskAreaProjectMapCreateViewModel = new();

            DeskAreaDetails result = await _deskAreaDetailRepository.DeskAreaDetail(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PAreaId = areaId
                });

            deskAreaProjectMapCreateViewModel.AreaId = areaId;
            deskAreaProjectMapCreateViewModel.AreaDesc = result.PAreaDesc;
            deskAreaProjectMapCreateViewModel.AreaCatgCode = result.PAreaCatgCode;
            deskAreaProjectMapCreateViewModel.AreaCatgDesc = result.PAreaCatgDesc;

            IEnumerable<DataField> projectList = await _selectTcmPLRepository.DeskBookProjectMapList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["ProjNoList"] = new SelectList(projectList, "DataValueField", "DataTextField");

            return PartialView("_ModalDeskAreaProjectMapCreate", deskAreaProjectMapCreateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DMSHelper.ActionITAdm)]
        public async Task<IActionResult> DeskAreaProjectMapCreate([FromForm] DeskAreaProjectMapCreateViewModel deskAreaProjectMapCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _deskAreaProjectMapRepository.DeskAreaprojectMapCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PAreaId = deskAreaProjectMapCreateViewModel.AreaId,
                            PProjectNo = deskAreaProjectMapCreateViewModel.ProjectNo,
                        });

                    return result.PMessageType == IsOk
                        ? RedirectToAction("DeskAreaProjectMapList", new { id = deskAreaProjectMapCreateViewModel.AreaId })
                        : StatusCode((int)HttpStatusCode.InternalServerError, result.PMessageText);
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            IEnumerable<DataField> projectList = await _selectTcmPLRepository.DeskBookProjectMapList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["ProjNoList"] = new SelectList(projectList, "DataValueField", "DataTextField", deskAreaProjectMapCreateViewModel.ProjectNo);

            return PartialView("_ModalDeskAreaProjectMapCreate", deskAreaProjectMapCreateViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> DeskAreaProjectMapEdit(string id)
        {
            try
            {
                if (id == null)
                {
                    return NotFound();
                }
                DeskAreaProjectMapUpdateViewModel deskAreaProjectMapUpdateViewModel = new();

                var result = await _deskAreaProjectMapDetailRepository.DeskAreaProjectMapDetail(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PKeyId = id
                });

                if (result.PMessageType == IsOk)
                {
                    deskAreaProjectMapUpdateViewModel.KeyId = id;
                    deskAreaProjectMapUpdateViewModel.AreaId = result.PAreaId;
                    deskAreaProjectMapUpdateViewModel.ProjectNo = result.PProjectNo;
                }

                IEnumerable<DataField> areaList = await _selectTcmPLRepository.DeskBookAreaForAssignmentList(BaseSpTcmPLGet(), new ParameterSpTcmPL { PAreaType = ConstDeskTypeForProject });

                ViewData["AreaList"] = new SelectList(areaList, "DataValueField", "DataTextField", deskAreaProjectMapUpdateViewModel.AreaId);

                IEnumerable<DataField> projectList = await _selectTcmPLRepository.DeskBookProjectMapList(BaseSpTcmPLGet(), new ParameterSpTcmPL());

                ViewData["ProjNoList"] = new SelectList(projectList, "DataValueField", "DataTextField", deskAreaProjectMapUpdateViewModel.ProjectNo);

                return PartialView("_ModalDeskAreaProjectMapUpdate", deskAreaProjectMapUpdateViewModel);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DMSHelper.ActionITAdm)]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeskAreaProjectMapEdit([FromForm] DeskAreaProjectMapUpdateViewModel deskAreaProjectMapUpdateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _deskAreaProjectMapRepository.DeskAreaprojectMapEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PKeyId = deskAreaProjectMapUpdateViewModel.KeyId,
                            PAreaId = deskAreaProjectMapUpdateViewModel.AreaId,
                            PProjectNo = deskAreaProjectMapUpdateViewModel.ProjectNo
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

            IEnumerable<DataField> areaList = await _selectTcmPLRepository.DeskBookAreaForAssignmentList(BaseSpTcmPLGet(), new ParameterSpTcmPL { PAreaType = ConstDeskTypeForProject });

            ViewData["AreaList"] = new SelectList(areaList, "DataValueField", "DataTextField", deskAreaProjectMapUpdateViewModel.AreaId);

            IEnumerable<DataField> projectList = await _selectTcmPLRepository.DeskBookProjectMapList(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            ViewData["ProjNoList"] = new SelectList(projectList, "DataValueField", "DataTextField", deskAreaProjectMapUpdateViewModel.ProjectNo);

            return PartialView("_ModalDeskAreaProjectMapUpdate", deskAreaProjectMapUpdateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DMSHelper.ActionITAdm)]
        public async Task<IActionResult> DeskAreaProjectMapDelete(string id)
        {
            try
            {
                var result = await _deskAreaProjectMapRepository.DeskAreaprojectMapDeleteAsync(
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
        public async Task<IActionResult> DeskAreaProjectMapDetails(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var result = await _deskAreaDetailRepository.DeskAreaDetail(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PAreaId = id
                });

            DeskAreaProjectMapDetailsViewModel deskAreaProjectMapDetailsViewModel = new();

            if (result.PMessageType == IsOk)
            {
                deskAreaProjectMapDetailsViewModel.AreaCatgCode = result.PAreaCatgCode;
                deskAreaProjectMapDetailsViewModel.AreaCatgDesc = result.PAreaCatgDesc;
                deskAreaProjectMapDetailsViewModel.AreaId = id;
                deskAreaProjectMapDetailsViewModel.AreaDesc = result.PAreaDesc;
            }

            return PartialView("_ModalDeskAreaProjectMapDetails", deskAreaProjectMapDetailsViewModel);
        }

        public async Task<IActionResult> DeskAreaProjectMapExcelDownload()
        {
            var timeStamp = DateTime.Now.ToFileTime();

            string fileName = "Desk Area Project Map List_" + timeStamp.ToString();
            string reportTitle = "Desk Area Project Map List";
            string sheetName = "Desk Area Project Map List";

            IEnumerable<DeskAreaProjectMapDataTableList> data = await _deskAreaProjectMapDataTableListRepository.DeskAreaProjectMapDataTableListForExcelAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                });

            if (data == null) { return NotFound(); }

            var json = JsonConvert.SerializeObject(data);

            IEnumerable<DeskAreaProjectMapDataTableExcel> excelData = JsonConvert.DeserializeObject<IEnumerable<DeskAreaProjectMapDataTableExcel>>(json);

            var byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, reportTitle, sheetName);

            var mimeType = MimeTypeMap.GetMimeType("xlsx");

            FileContentResult file = File(byteContent, mimeType, fileName);

            return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
        }

        #endregion DeskAreaProjectMapping

        #region DeskAreaUserMapping

        public async Task<IActionResult> DeskAreaUserMapIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterDeskAreaUserMapIndex
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

            DeskAreaUserMapViewModel deskAreaUserMapViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(deskAreaUserMapViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsDeskAreaUserMap(string paramJson)
        {
            DTResult<DeskAreaUserMapDataTableList> result = new();
            int totalRow = 0;
            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);
            try
            {
                System.Collections.Generic.IEnumerable<DeskAreaUserMapDataTableList> data = await _deskAreaUserMapDataTableListRepository.DeskAreaUserMapDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch ?? " ",
                        POfficeLocationCode = param.OfficeLocationCode,
                        PAreaId = param.AreaId,
                        PCostCode = param.Costcode,
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
        public async Task<IActionResult> DeskAreaUserMapCreate()
        {
            DeskAreaUserMapCreateViewModel deskAreaUserMapCreateViewModel = new();

            IEnumerable<DataField> employeeList = await _selectTcmPLRepository.DeskBookEmployeeList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["EmployeeList"] = new SelectList(employeeList, "DataValueField", "DataTextField");

            //IEnumerable<DataField> baseOfficeList = await _selectTcmPLRepository.DeskBookingbOfficeLocationList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            //ViewData["BaseOfficeList"] = new SelectList(baseOfficeList, "DataValueField", "DataTextField");

            //IEnumerable<DataField> areaList = await _selectTcmPLRepository.DeskBookAreaList(BaseSpTcmPLGet(), new ParameterSpTcmPL { PAreaType = ConstDeskTypeForSemiFixed });
            //ViewData["AreaList"] = new SelectList(areaList, "DataValueField", "DataTextField");

            return PartialView("_ModalDeskAreaUserMapCreate", deskAreaUserMapCreateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeskAreaUserMapCreate([FromForm] DeskAreaUserMapCreateViewModel deskAreaUserMapCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _deskAreaUserMapRequestRepository.SetDeskAreaUserMapAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PAreaId = deskAreaUserMapCreateViewModel.AreaId,
                            PEmpno = deskAreaUserMapCreateViewModel.Employee,
                            PStartDate = deskAreaUserMapCreateViewModel.FromDate,
                            POfficeCode = deskAreaUserMapCreateViewModel.OfficeCode,
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
            ViewData["EmployeeList"] = new SelectList(employeeList, "DataValueField", "DataTextField", deskAreaUserMapCreateViewModel.Employee);

            IEnumerable<DataField> baseOfficeList = await _selectTcmPLRepository.DeskBookingOfficeLocationList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["BaseOfficeList"] = new SelectList(baseOfficeList, "DataValueField", "DataTextField");

            IEnumerable<DataField> areaList = await _selectTcmPLRepository.DeskBookAreaForAssignmentList(BaseSpTcmPLGet(), new ParameterSpTcmPL { PAreaType = ConstDeskTypeForSemiFixed });
            ViewData["AreaList"] = new SelectList(areaList, "DataValueField", "DataTextField", deskAreaUserMapCreateViewModel.AreaId);

            return PartialView("_ModalDeskAreaUserMapCreate", deskAreaUserMapCreateViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> DeskAreaUserMapEdit(string id)
        {
            try
            {
                if (id == null)
                {
                    return NotFound();
                }
                DeskAreaUserMapUpdateViewModel deskAreaUserMapUpdateViewModel = new();

                var result = await _deskAreaUserMapDetailRepository.DeskAreaUserMapDetail(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PKeyId = id
                });

                if (result.PMessageType == IsOk)
                {
                    deskAreaUserMapUpdateViewModel.KeyId = id;
                    deskAreaUserMapUpdateViewModel.AreaId = result.PAreaId;
                    deskAreaUserMapUpdateViewModel.Employee = result.PEmpNo;
                    deskAreaUserMapUpdateViewModel.FromDate = result.PFromDate;
                    deskAreaUserMapUpdateViewModel.OfficeCode = result.POfficeCode;
                }

                IEnumerable<DataField> employeeList = await _selectTcmPLRepository.DeskBookEmployeeList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
                ViewData["EmployeeList"] = new SelectList(employeeList, "DataValueField", "DataTextField", deskAreaUserMapUpdateViewModel.Employee);

                IEnumerable<DataField> baseOfficeList = await _selectTcmPLRepository.DeskBookingOfficeLocationList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
                ViewData["BaseOfficeList"] = new SelectList(baseOfficeList, "DataValueField", "DataTextField", deskAreaUserMapUpdateViewModel.OfficeCode);

                IEnumerable<DataField> areaList = await _selectTcmPLRepository.DeskBookAreaForAssignmentList(BaseSpTcmPLGet(), new ParameterSpTcmPL { PAreaType = ConstDeskTypeForSemiFixed });
                ViewData["AreaList"] = new SelectList(areaList, "DataValueField", "DataTextField", deskAreaUserMapUpdateViewModel.AreaId);

                return PartialView("_ModalDeskAreaUserMapUpdate", deskAreaUserMapUpdateViewModel);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeskAreaUserMapEdit([FromForm] DeskAreaUserMapUpdateViewModel deskAreaUserMapUpdateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _deskAreaUserMapRequestRepository.SetDeskAreaUserMapAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PKeyId = deskAreaUserMapUpdateViewModel.KeyId,
                            PAreaId = deskAreaUserMapUpdateViewModel.AreaId,
                            PEmpno = deskAreaUserMapUpdateViewModel.Employee,
                            PStartDate = deskAreaUserMapUpdateViewModel.FromDate,
                            POfficeCode = deskAreaUserMapUpdateViewModel.OfficeCode,
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

            IEnumerable<DataField> employeeList = await _selectTcmPLRepository.DeskBookEmployeeList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["EmployeeList"] = new SelectList(employeeList, "DataValueField", "DataTextField", deskAreaUserMapUpdateViewModel.Employee);

            IEnumerable<DataField> baseOfficeList = await _selectTcmPLRepository.DeskBookingOfficeLocationList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["BaseOfficeList"] = new SelectList(baseOfficeList, "DataValueField", "DataTextField", deskAreaUserMapUpdateViewModel.OfficeCode);

            IEnumerable<DataField> areaList = await _selectTcmPLRepository.DeskBookAreaForAssignmentList(BaseSpTcmPLGet(), new ParameterSpTcmPL { PAreaType = ConstDeskTypeForSemiFixed });
            ViewData["AreaList"] = new SelectList(areaList, "DataValueField", "DataTextField", deskAreaUserMapUpdateViewModel.AreaId);

            return PartialView("_ModalDeskAreaUserMapUpdate", deskAreaUserMapUpdateViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> DeskAreaUserMapDelete(string id)
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
        public async Task<IActionResult> DeskAreaUserMapDetails(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var result = await _deskAreaUserMapDetailRepository.DeskAreaUserMapDetail(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PKeyId = id
                });

            DeskAreaUserMapDetailsViewModel deskAreaUserMapDetailsViewModel = new();

            if (result.PMessageType == IsOk)
            {
                deskAreaUserMapDetailsViewModel.KeyId = id;
                deskAreaUserMapDetailsViewModel.AreaCatgCode = result.PAreaCatgCode;
                deskAreaUserMapDetailsViewModel.AreaCatgDesc = result.PAreaCatgDesc;
                deskAreaUserMapDetailsViewModel.AreaId = result.PAreaId;
                deskAreaUserMapDetailsViewModel.AreaDesc = result.PAreaDesc;
                deskAreaUserMapDetailsViewModel.EmpName = result.PEmpName;
                deskAreaUserMapDetailsViewModel.EmpNo = result.PEmpNo;
                deskAreaUserMapDetailsViewModel.ModifiedBy = result.PModifiedBy;
                deskAreaUserMapDetailsViewModel.ModifiedOn = result.PModifiedOn;
                deskAreaUserMapDetailsViewModel.OfficeCode = result.POfficeCode;
                deskAreaUserMapDetailsViewModel.Office = result.POfficeCode;
            }

            return PartialView("_ModalDeskAreaUserMapDetails", deskAreaUserMapDetailsViewModel);
        }

        public async Task<IActionResult> DeskAreaUserMapExcelDownload()
        {
            var retVal = await RetriveFilter(ConstFilterDeskAreaUserMapIndex);

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }
            if (string.IsNullOrEmpty(filterDataModel.OfficeLocationCode))
            {
                filterDataModel.OfficeLocationCode = ConstFilterByLocationAiroli;
            }
            var timeStamp = DateTime.Now.ToFileTime();

            string fileName = "Desk Area User Map List_" + timeStamp.ToString();
            string reportTitle = "Desk Area User Map List";
            string sheetName = "Desk Area User Map List";

            IEnumerable<DeskAreaUserMapDataTableList> data = await _deskAreaUserMapDataTableListRepository.DeskAreaUserMapDataTableListForExcelAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PGenericSearch = filterDataModel.GenericSearch ?? " ",
                    PAreaId = filterDataModel.AreaId,
                    POfficeLocationCode = filterDataModel.OfficeLocationCode,
                    PCostCode = filterDataModel.CostCode
                });

            if (data == null) { return NotFound(); }

            //var json = JsonConvert.SerializeObject(data);

            //IEnumerable<DeskAreaUserMapDataTableExcel> excelData = JsonConvert.DeserializeObject<IEnumerable<DeskAreaUserMapDataTableExcel>>(json);

            var byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(data, reportTitle, sheetName);

            var mimeType = MimeTypeMap.GetMimeType("xlsx");

            FileContentResult file = File(byteContent, mimeType, fileName);

            return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
        }

        #endregion DeskAreaUserMapping

        #region DeskAreaEmployeeMapping

        public async Task<IActionResult> DeskAreaEmployeeMapIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterDeskAreaEmployeeMapIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            DeskAreaEmployeeMapViewModel deskAreaEmployeeMapViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(deskAreaEmployeeMapViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsDeskAreaEmployeeMap(string paramJson)
        {
            DTResult<DeskAreaEmployeeMapDataTableList> result = new();
            int totalRow = 0;
            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);
            try
            {
                System.Collections.Generic.IEnumerable<DeskAreaEmployeeMapDataTableList> data = await _deskAreaEmployeeMapDataTableListRepository.DeskAreaEmployeeMapDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch ?? " ",
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

        [HttpGet]
        public async Task<IActionResult> DeskAreaEmployeeMapCreate()
        {
            DeskAreaEmployeeMapCreateViewModel deskAreaEmployeeMapCreateViewModel = new();

            IEnumerable<DataField> employeeList = await _selectTcmPLRepository.DeskBookEmployeeList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["EmployeeList"] = new SelectList(employeeList, "DataValueField", "DataTextField");

            return PartialView("_ModalDeskAreaEmployeeMapCreate", deskAreaEmployeeMapCreateViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> GetDeskList(string office, string areaId)
        {
            var deskList = await _selectTcmPLRepository.DeskBookDeskIdList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
                POffice = office,
                PAreaId = areaId
            });

            return Json(deskList);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DMSHelper.ActionITAdm)]
        public async Task<IActionResult> DeskAreaEmployeeMapCreate([FromForm] DeskAreaEmployeeMapCreateViewModel deskAreaEmployeeMapCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _deskAreaEmployeeMapRepository.DeskAreaEmployeeMapCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PAreaId = deskAreaEmployeeMapCreateViewModel.AreaId,
                            PEmpno = deskAreaEmployeeMapCreateViewModel.Empno,
                            PDeskId = deskAreaEmployeeMapCreateViewModel.DeskId,
                            POfficeCode = deskAreaEmployeeMapCreateViewModel.OfficeCode
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

            IEnumerable<DataField> areaList = await _selectTcmPLRepository.DeskBookAreaForAssignmentList(BaseSpTcmPLGet(), new ParameterSpTcmPL { PAreaType = ConstDeskTypeForEmployee });
            ViewData["AreaList"] = new SelectList(areaList, "DataValueField", "DataTextField", deskAreaEmployeeMapCreateViewModel.AreaId);

            IEnumerable<DataField> employeeList = await _selectTcmPLRepository.DeskBookEmployeeList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["EmployeeList"] = new SelectList(employeeList, "DataValueField", "DataTextField", deskAreaEmployeeMapCreateViewModel.Empno);

            IEnumerable<DataField> deskList = await _selectTcmPLRepository.DeskBookDeskList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["DeskList"] = new SelectList(deskList, "DataValueField", "DataTextField", deskAreaEmployeeMapCreateViewModel.DeskId);

            IEnumerable<DataField> baseOfficeList = await _selectTcmPLRepository.DeskBookingOfficeLocationList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["BaseOfficeList"] = new SelectList(baseOfficeList, "DataValueField", "DataTextField", deskAreaEmployeeMapCreateViewModel.OfficeCode);

            return PartialView("_ModalDeskAreaEmployeeMapCreate", deskAreaEmployeeMapCreateViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> DeskAreaEmployeeMapEdit(string id)
        {
            try
            {
                if (id == null)
                {
                    return NotFound();
                }

                DeskAreaEmployeeMapUpdateViewModel deskAreaEmployeeMapUpdateViewModel = new();

                var result = await _deskAreaEmployeeMapDetailRepository.DeskAreaEmployeeMapDetail(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PKeyId = id
                });

                if (result.PMessageType == IsOk)
                {
                    deskAreaEmployeeMapUpdateViewModel.KeyId = id;
                    deskAreaEmployeeMapUpdateViewModel.AreaId = result.PAreaId;
                    deskAreaEmployeeMapUpdateViewModel.Empno = result.PEmpNo;
                    deskAreaEmployeeMapUpdateViewModel.DeskId = result.PDeskId;
                    deskAreaEmployeeMapUpdateViewModel.OfficeCode = result.POfficeCode;
                }
                var empdetails = await _commonEmployeeDetailsRepository.EmployeeDetailAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL
                {
                    PEmpno = result.PEmpNo
                });

                IEnumerable<DataField> areaList = await _selectTcmPLRepository.DeskBookAreaForFixedPcList(BaseSpTcmPLGet(), new ParameterSpTcmPL
                {
                    POffice = result.POfficeCode,
                    PEmpno = result.PEmpNo
                });

                ViewData["AreaList"] = new SelectList(areaList, "DataValueField", "DataTextField", deskAreaEmployeeMapUpdateViewModel.AreaId);

                IEnumerable<DataField> employeeList = await _selectTcmPLRepository.DeskBookEmployeeList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
                ViewData["EmployeeList"] = new SelectList(employeeList, "DataValueField", "DataTextField", deskAreaEmployeeMapUpdateViewModel.Empno);

                IEnumerable<DataField> deskList = await _selectTcmPLRepository.DeskBookDeskIdList(BaseSpTcmPLGet(), new ParameterSpTcmPL
                {
                    POffice = result.POfficeCode,
                    PAreaId = result.PAreaId
                });
                ViewData["DeskList"] = new SelectList(deskList, "DataValueField", "DataTextField", deskAreaEmployeeMapUpdateViewModel.DeskId);

                IEnumerable<DataField> baseOfficeList = await _selectTcmPLRepository.DeskBookingOfficeLocationList(BaseSpTcmPLGet(), new ParameterSpTcmPL
                {
                    PLocation = empdetails.PCurrentOfficeLocation.Trim(),
                    PEmpno = empdetails.PForEmpno
                });
                ViewData["BaseOfficeList"] = new SelectList(baseOfficeList, "DataValueField", "DataTextField", deskAreaEmployeeMapUpdateViewModel.OfficeCode);

                return PartialView("_ModalDeskAreaEmployeeMapUpdate", deskAreaEmployeeMapUpdateViewModel);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DMSHelper.ActionITAdm)]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeskAreaEmployeeMapEdit([FromForm] DeskAreaEmployeeMapUpdateViewModel deskAreaEmployeeMapUpdateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _deskAreaEmployeeMapRepository.DeskAreaEmployeeMapEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PKeyId = deskAreaEmployeeMapUpdateViewModel.KeyId,
                            PAreaId = deskAreaEmployeeMapUpdateViewModel.AreaId,
                            PEmpno = deskAreaEmployeeMapUpdateViewModel.Empno,
                            PDeskId = deskAreaEmployeeMapUpdateViewModel.DeskId,
                            POfficeCode = deskAreaEmployeeMapUpdateViewModel.OfficeCode
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

            var empdetails = await _commonEmployeeDetailsRepository.EmployeeDetailAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
                PEmpno = deskAreaEmployeeMapUpdateViewModel.Empno
            });

            IEnumerable<DataField> areaList = await _selectTcmPLRepository.DeskBookAreaForAssignmentList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
                POffice = deskAreaEmployeeMapUpdateViewModel.OfficeCode,
                PAreaType = ConstDeskTypeForEmployee
            });
            ViewData["AreaList"] = new SelectList(areaList, "DataValueField", "DataTextField", deskAreaEmployeeMapUpdateViewModel.AreaId);

            IEnumerable<DataField> employeeList = await _selectTcmPLRepository.DeskBookEmployeeList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["EmployeeList"] = new SelectList(employeeList, "DataValueField", "DataTextField", deskAreaEmployeeMapUpdateViewModel.Empno);

            IEnumerable<DataField> deskList = await _selectTcmPLRepository.DeskBookDeskIdList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
                POffice = deskAreaEmployeeMapUpdateViewModel.OfficeCode,
                PAreaId = deskAreaEmployeeMapUpdateViewModel.AreaId
            });
            ViewData["DeskList"] = new SelectList(deskList, "DataValueField", "DataTextField", deskAreaEmployeeMapUpdateViewModel.DeskId);

            IEnumerable<DataField> baseOfficeList = await _selectTcmPLRepository.DeskBookingOfficeLocationList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
                PLocation = empdetails.PCurrentOfficeLocation.Trim(),
                PEmpno = empdetails.PForEmpno
            });
            ViewData["BaseOfficeList"] = new SelectList(baseOfficeList, "DataValueField", "DataTextField", deskAreaEmployeeMapUpdateViewModel.OfficeCode);

            return PartialView("_ModalDeskAreaEmployeeMapUpdate", deskAreaEmployeeMapUpdateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DMSHelper.ActionITAdm)]
        public async Task<IActionResult> DeskAreaEmployeeMapDelete(string id)
        {
            try
            {
                var result = await _deskAreaEmployeeMapRepository.DeskAreaEmployeeMapDeleteAsync(
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
        public async Task<IActionResult> DeskAreaEmployeeMapDetails(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var result = await _deskAreaEmployeeMapDetailRepository.DeskAreaEmployeeMapDetail(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PKeyId = id
                });

            DeskAreaEmployeeMapDetailsViewModel deskAreaEmployeeMapDetailsViewModel = new();

            if (result.PMessageType == IsOk)
            {
                deskAreaEmployeeMapDetailsViewModel.KeyId = id;
                deskAreaEmployeeMapDetailsViewModel.AreaCatgCode = result.PAreaCatgCode;
                deskAreaEmployeeMapDetailsViewModel.AreaCatgDesc = result.PAreaCatgDesc;
                deskAreaEmployeeMapDetailsViewModel.AreaId = result.PAreaId;
                deskAreaEmployeeMapDetailsViewModel.AreaDesc = result.PAreaDesc;
                deskAreaEmployeeMapDetailsViewModel.DeskId = result.PDeskId;
                deskAreaEmployeeMapDetailsViewModel.EmpNo = result.PEmpNo;
                deskAreaEmployeeMapDetailsViewModel.EmpName = result.PEmpName;
                deskAreaEmployeeMapDetailsViewModel.ModifiedBy = result.PModifiedBy;
                deskAreaEmployeeMapDetailsViewModel.ModifiedOn = result.PModifiedOn;
                deskAreaEmployeeMapDetailsViewModel.OfficeCode = result.POfficeCode;
                deskAreaEmployeeMapDetailsViewModel.Office = result.POfficeCode;
            }

            return PartialView("_ModalDeskAreaEmployeeMapDetails", deskAreaEmployeeMapDetailsViewModel);
        }

        public async Task<IActionResult> DeskAreaEmployeeMapExcelDownload()
        {
            var timeStamp = DateTime.Now.ToFileTime();

            string fileName = "Desk Area Employee Map List_" + timeStamp.ToString();
            string reportTitle = "Desk Area Employee Map List";
            string sheetName = "Desk Area Employee Map List";

            IEnumerable<DeskAreaEmployeeMapDataTableList> data = await _deskAreaEmployeeMapDataTableListRepository.DeskAreaEmployeeMapDataTableListForExcelAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                });

            if (data == null) { return NotFound(); }

            //var json = JsonConvert.SerializeObject(data);

            //IEnumerable<DeskAreaEmployeeMapDataTableExcel> excelData = JsonConvert.DeserializeObject<IEnumerable<DeskAreaEmployeeMapDataTableExcel>>(json);

            var byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(data, reportTitle, sheetName);

            var mimeType = MimeTypeMap.GetMimeType("xlsx");

            FileContentResult file = File(byteContent, mimeType, fileName);

            return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
        }

        #endregion DeskAreaEmployeeMapping

        #region Filters

        public async Task<IActionResult> DeskAreaFilterGet()
        {
            var retVal = await RetriveFilter(ConstFilterDeskAreaIndex);

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            var areaCatgCodeList = await _selectTcmPLRepository.DmsAreaCatgCodeList(BaseSpTcmPLGet(), null);
            ViewData["AreaCatgCodeList"] = new SelectList(areaCatgCodeList, "DataValueField", "DataTextField");

            var areaTypeList = await _selectTcmPLRepository.DmsAreaTypeList(BaseSpTcmPLGet(), null);
            ViewData["AreaTypeList"] = new SelectList(areaTypeList, "DataValueField", "DataTextField");

            return PartialView("_ModalDeskAreaFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> DeskAreaFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                string jsonFilter;
                jsonFilter = JsonConvert.SerializeObject(
                        new
                        {
                            filterDataModel.IsRestricted,
                            filterDataModel.AreaCatgCode,
                            filterDataModel.AreaType,
                        });

                _ = await CreateFilter(jsonFilter, ConstFilterDeskAreaIndex);

                return Json(new
                {
                    success = true,
                    isRestricted = filterDataModel.IsRestricted,
                    areaCatgCode = filterDataModel.AreaCatgCode,
                    areaType = filterDataModel.AreaType,
                });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        public async Task<IActionResult> DeskAreaDepartmentMapFilterGet()
        {
            var retVal = await RetriveFilter(ConstFilterDeskAreaDepartmentMapIndex);

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }
            IEnumerable<DataField> areaList = await _selectTcmPLRepository.DeskBookAreaForAssignmentList(BaseSpTcmPLGet(), new ParameterSpTcmPL { PAreaType = ConstDeskTypeForDept });
            ViewData["AreaList"] = new SelectList(areaList, "DataValueField", "DataTextField");

            IEnumerable<DataField> costCodeList = await _selectTcmPLRepository.DeskBookCostcodeList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["CostCodeList"] = new SelectList(costCodeList, "DataValueField", "DataTextField");

            return PartialView("_ModalDeskAreaDepartmentMapFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> DeskAreaDepartmentMapFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                string jsonFilter;
                jsonFilter = JsonConvert.SerializeObject(
                        new
                        {
                            filterDataModel.AreaId,
                            filterDataModel.CostCode,
                        });

                _ = await CreateFilter(jsonFilter, ConstFilterDeskAreaDepartmentMapIndex);

                return Json(new
                {
                    success = true,
                    areaId = filterDataModel.AreaId,
                    costCode = filterDataModel.CostCode,
                });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        public async Task<IActionResult> DeskAreaProjectMapFilterGet()
        {
            var retVal = await RetriveFilter(ConstFilterDeskAreaProjectMapIndex);

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }
            IEnumerable<DataField> areaList = await _selectTcmPLRepository.DeskBookAreaForAssignmentList(BaseSpTcmPLGet(), new ParameterSpTcmPL { PAreaType = ConstDeskTypeForProject });
            ViewData["AreaList"] = new SelectList(areaList, "DataValueField", "DataTextField");

            IEnumerable<DataField> projectList = await _selectTcmPLRepository.DeskBookProjectMapList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["ProjNoList"] = new SelectList(projectList, "DataValueField", "DataTextField");

            return PartialView("_ModalDeskAreaProjectMapFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> DeskAreaProjectMapFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                string jsonFilter;
                jsonFilter = JsonConvert.SerializeObject(
                        new
                        {
                            filterDataModel.AreaId,
                            filterDataModel.ProjectNo,
                        });

                _ = await CreateFilter(jsonFilter, ConstFilterDeskAreaProjectMapIndex);

                return Json(new
                {
                    success = true,
                    areaId = filterDataModel.AreaId,
                    projectNo = filterDataModel.ProjectNo,
                });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        public async Task<IActionResult> DeskAreaUserMapFilterGet()
        {
            var retVal = await RetriveFilter(ConstFilterDeskAreaUserMapIndex);

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            IEnumerable<DataField> officeList = await _selectTcmPLRepository.HRMISOfficeLocationList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["OfficeList"] = new SelectList(officeList, "DataValueField", "DataTextField");

            IEnumerable<DataField> areaList = await _selectTcmPLRepository.DeskBookAreaForAssignmentDmsList(BaseSpTcmPLGet(), new ParameterSpTcmPL { });
            ViewData["AreaList"] = new SelectList(areaList, "DataValueField", "DataTextField");

            IEnumerable<DataField> costCodeList = await _selectTcmPLRepository.DeskBookCostcodeList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["CostCodeList"] = new SelectList(costCodeList, "DataValueField", "DataTextField");

            return PartialView("_ModalDeskAreaUserMapFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> DeskAreaUserMapFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                string jsonFilter;
                jsonFilter = JsonConvert.SerializeObject(
                        new
                        {
                            filterDataModel.AreaId,
                            filterDataModel.OfficeLocationCode,
                            filterDataModel.CostCode,
                        });

                _ = await CreateFilter(jsonFilter, ConstFilterDeskAreaUserMapIndex);

                return Json(new
                {
                    success = true,
                    areaId = filterDataModel.AreaId,
                    officeLocationCode = filterDataModel.OfficeLocationCode,
                    costCode = filterDataModel.CostCode,
                });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        public async Task<IActionResult> DeskAreaEmployeeMapFilterGet()
        {
            var retVal = await RetriveFilter(ConstFilterDeskAreaEmployeeMapIndex);

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }
            IEnumerable<DataField> areaList = await _selectTcmPLRepository.DeskBookAreaForAssignmentList(BaseSpTcmPLGet(), new ParameterSpTcmPL { PAreaType = ConstDeskTypeForEmployee });
            ViewData["AreaList"] = new SelectList(areaList, "DataValueField", "DataTextField");

            return PartialView("_ModalDeskAreaEmployeeMapFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> DeskAreaEmployeeMapFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                string jsonFilter;
                jsonFilter = JsonConvert.SerializeObject(
                        new
                        {
                            filterDataModel.AreaId,
                        });

                _ = await CreateFilter(jsonFilter, ConstFilterDeskAreaEmployeeMapIndex);

                return Json(new
                {
                    success = true,
                    areaId = filterDataModel.AreaId,
                });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        public async Task<IActionResult> DeskAreaEmpAreaTypeMapFilterGet()
        {
            var retVal = await RetriveFilter(ConstFilterDeskAreaEmpAreaTypeMapIndex);

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }
            IEnumerable<DataField> areaTypeList = await _selectTcmPLRepository.DmsAreaTypeList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["AreaTypeList"] = new SelectList(areaTypeList, "DataValueField", "DataTextField");

            return PartialView("_ModalDeskAreaEmpAreaTypeMapFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> DeskAreaEmpAreaTypeMapFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                string jsonFilter;
                jsonFilter = JsonConvert.SerializeObject(
                        new
                        {
                            filterDataModel.DeskType,
                        });

                _ = await CreateFilter(jsonFilter, ConstFilterDeskAreaEmpAreaTypeMapIndex);

                return Json(new
                {
                    success = true,
                    deskType = filterDataModel.DeskType,
                });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        #endregion Filters

        #region DeskAreaEmpAreaTypeMapping

        public async Task<IActionResult> DeskAreaEmpAreaTypeMapIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterDeskAreaEmpAreaTypeMapIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            DeskAreaEmpAreaTypeMapViewModel deskAreaEmpAreaTypeMapViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(deskAreaEmpAreaTypeMapViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsDeskAreaEmpAreaTypeMap(string paramJson)
        {
            DTResult<DeskAreaEmpAreaTypeMapDataTableList> result = new();
            int totalRow = 0;
            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);
            try
            {
                IEnumerable<DeskAreaEmpAreaTypeMapDataTableList> data = await _deskAreaEmpAreaTypeMapDataTableListRepository.DeskAreaEmpAreaTypeMapDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch ?? " ",
                        PDeskType = param.DeskType,
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
        public async Task<IActionResult> DeskAreaEmpAreaTypeMapCreate()
        {
            DeskAreaEmpAreaTypeMapCreateViewModel deskAreaEmpAreaTypeMapCreateViewModel = new();

            IEnumerable<DataField> areaTypeList = await _selectTcmPLRepository.DmsAreaTypeList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["AreaTypeList"] = new SelectList(areaTypeList, "DataValueField", "DataTextField");

            IEnumerable<DataField> areaList = await _selectTcmPLRepository.DeskBookAreaForAssignmentList(BaseSpTcmPLGet(), new ParameterSpTcmPL { PAreaType = ConstDeskTypeForSemiFixed });
            ViewData["AreaList"] = new SelectList(areaList, "DataValueField", "DataTextField");

            IEnumerable<DataField> employeeList = await _selectTcmPLRepository.EmployeeListForHRAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["EmployeeList"] = new SelectList(employeeList, "DataValueField", "DataTextField");

            return PartialView("_ModalDeskAreaEmpAreaTypeMapCreate", deskAreaEmpAreaTypeMapCreateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DMSHelper.ActionITAdm)]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeskAreaEmpAreaTypeMapCreate([FromForm] DeskAreaEmpAreaTypeMapCreateViewModel deskAreaEmpAreaTypeMapCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _deskAreaEmpAreaTypeMapRequestRepository.DeskAreaEmpAreaTypeMapCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PAreaId = deskAreaEmpAreaTypeMapCreateViewModel.AreaId,
                            PEmpno = deskAreaEmpAreaTypeMapCreateViewModel.Employee,
                            PAreaType = deskAreaEmpAreaTypeMapCreateViewModel.DeskAreaType,
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

            IEnumerable<DataField> areaTypeList = await _selectTcmPLRepository.DmsAreaTypeList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["AreaTypeList"] = new SelectList(areaTypeList, "DataValueField", "DataTextField", deskAreaEmpAreaTypeMapCreateViewModel.DeskAreaType);

            IEnumerable<DataField> areaList = await _selectTcmPLRepository.DeskBookAreaForAssignmentList(BaseSpTcmPLGet(), new ParameterSpTcmPL { PAreaType = ConstDeskTypeForSemiFixed });
            ViewData["AreaList"] = new SelectList(areaList, "DataValueField", "DataTextField", deskAreaEmpAreaTypeMapCreateViewModel.AreaId);

            IEnumerable<DataField> employeeList = await _selectTcmPLRepository.EmployeeListForHRAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["EmployeeList"] = new SelectList(employeeList, "DataValueField", "DataTextField", deskAreaEmpAreaTypeMapCreateViewModel.Employee);

            return PartialView("_ModalDeskAreaEmpAreaTypeMapCreate", deskAreaEmpAreaTypeMapCreateViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> DeskAreaEmpAreaTypeMapEdit(string id)
        {
            try
            {
                if (id == null)
                {
                    return NotFound();
                }
                DeskAreaEmpAreaTypeMapUpdateViewModel deskAreaEmpAreaTypeMapUpdateViewModel = new();

                var result = await _deskAreaEmpAreaTypeMapDetailRepository.DeskAreaEmpAreaTypeMapDetail(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PKeyId = id
                });

                if (result.PMessageType == IsOk)
                {
                    deskAreaEmpAreaTypeMapUpdateViewModel.KeyId = id;
                    deskAreaEmpAreaTypeMapUpdateViewModel.AreaId = result.PAreaId;
                    deskAreaEmpAreaTypeMapUpdateViewModel.Employee = result.PEmpNo;
                    deskAreaEmpAreaTypeMapUpdateViewModel.DeskAreaType = result.PAreaTypeCode;
                }

                IEnumerable<DataField> areaTypeList = await _selectTcmPLRepository.DmsAreaTypeList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
                ViewData["AreaTypeList"] = new SelectList(areaTypeList, "DataValueField", "DataTextField", deskAreaEmpAreaTypeMapUpdateViewModel.DeskAreaType);

                IEnumerable<DataField> areaList = await _selectTcmPLRepository.DeskBookAreaForAssignmentList(BaseSpTcmPLGet(), new ParameterSpTcmPL { PAreaType = ConstDeskTypeForSemiFixed });
                ViewData["AreaList"] = new SelectList(areaList, "DataValueField", "DataTextField", deskAreaEmpAreaTypeMapUpdateViewModel.AreaId);

                IEnumerable<DataField> employeeList = await _selectTcmPLRepository.EmployeeListForHRAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());
                ViewData["EmployeeList"] = new SelectList(employeeList, "DataValueField", "DataTextField", deskAreaEmpAreaTypeMapUpdateViewModel.Employee);

                return PartialView("_ModalDeskAreaEmpAreaTypeMapUpdate", deskAreaEmpAreaTypeMapUpdateViewModel);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DMSHelper.ActionITAdm)]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeskAreaEmpAreaTypeMapEdit([FromForm] DeskAreaEmpAreaTypeMapUpdateViewModel deskAreaEmpAreaTypeMapUpdateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _deskAreaEmpAreaTypeMapRequestRepository.DeskAreaEmpAreaTypeMapEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PKeyId = deskAreaEmpAreaTypeMapUpdateViewModel.KeyId,
                            PAreaId = deskAreaEmpAreaTypeMapUpdateViewModel.AreaId,
                            PEmpno = deskAreaEmpAreaTypeMapUpdateViewModel.Employee,
                            PAreaType = deskAreaEmpAreaTypeMapUpdateViewModel.DeskAreaType
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

            IEnumerable<DataField> areaTypeList = await _selectTcmPLRepository.DmsAreaTypeList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["AreaTypeList"] = new SelectList(areaTypeList, "DataValueField", "DataTextField", deskAreaEmpAreaTypeMapUpdateViewModel.DeskAreaType);

            IEnumerable<DataField> areaList = await _selectTcmPLRepository.DeskBookAreaForAssignmentList(BaseSpTcmPLGet(), new ParameterSpTcmPL { PAreaType = ConstDeskTypeForSemiFixed });
            ViewData["AreaList"] = new SelectList(areaList, "DataValueField", "DataTextField", deskAreaEmpAreaTypeMapUpdateViewModel.AreaId);

            IEnumerable<DataField> employeeList = await _selectTcmPLRepository.EmployeeListForHRAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["EmployeeList"] = new SelectList(employeeList, "DataValueField", "DataTextField", deskAreaEmpAreaTypeMapUpdateViewModel.Employee);

            return PartialView("_ModalDeskAreaEmpAreaTypeMapUpdate", deskAreaEmpAreaTypeMapUpdateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DMSHelper.ActionITAdm)]
        public async Task<IActionResult> DeskAreaEmpAreaTypeMapDelete(string id)
        {
            try
            {
                var result = await _deskAreaEmpAreaTypeMapRequestRepository.DeskAreaEmpAreaTypeMapDeleteAsync(
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
        public async Task<IActionResult> DeskAreaEmpAreaTypeMapDetails(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var result = await _deskAreaEmpAreaTypeMapDetailRepository.DeskAreaEmpAreaTypeMapDetail(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PKeyId = id
                });

            DeskAreaEmpAreaTypeMapDetailsViewModel deskAreaEmpAreaTypeMapDetailsViewModel = new();

            if (result.PMessageType == IsOk)
            {
                deskAreaEmpAreaTypeMapDetailsViewModel.KeyId = id;
                deskAreaEmpAreaTypeMapDetailsViewModel.AreaCatgCode = result.PAreaCatgCode;
                deskAreaEmpAreaTypeMapDetailsViewModel.AreaCatgDesc = result.PAreaCatgDesc;
                deskAreaEmpAreaTypeMapDetailsViewModel.AreaId = result.PAreaId;
                deskAreaEmpAreaTypeMapDetailsViewModel.AreaDesc = result.PAreaDesc;
                deskAreaEmpAreaTypeMapDetailsViewModel.EmpName = result.PEmpName;
                deskAreaEmpAreaTypeMapDetailsViewModel.EmpNo = result.PEmpNo;
                deskAreaEmpAreaTypeMapDetailsViewModel.ModifiedBy = result.PModifiedBy;
                deskAreaEmpAreaTypeMapDetailsViewModel.ModifiedOn = result.PModifiedOn;
            }

            return PartialView("_ModalDeskAreaEmpAreaTypeMapDetails", deskAreaEmpAreaTypeMapDetailsViewModel);
        }

        public async Task<IActionResult> DeskAreaEmpAreaTypeMapExcelDownload()
        {
            var timeStamp = DateTime.Now.ToFileTime();

            string fileName = "Desk Area Emp Area Type Map List_" + timeStamp.ToString();
            string reportTitle = "Desk Area Emp Area Type Map List";
            string sheetName = "Desk Area EmpAreaType Map List";

            IEnumerable<DeskAreaEmpAreaTypeMapDataTableList> data = await _deskAreaEmpAreaTypeMapDataTableListRepository.DeskAreaEmpAreaTypeMapDataTableListForExcelAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                });

            if (data == null) { return NotFound(); }

            var json = JsonConvert.SerializeObject(data);

            IEnumerable<DeskAreaEmpAreaTypeMapDataTableExcel> excelData = JsonConvert.DeserializeObject<IEnumerable<DeskAreaEmpAreaTypeMapDataTableExcel>>(json);

            var byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, reportTitle, sheetName);

            var mimeType = MimeTypeMap.GetMimeType("xlsx");

            FileContentResult file = File(byteContent, mimeType, fileName);

            return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
        }

        #endregion DeskAreaEmpAreaTypeMapping

        #region DeskAreaDetails

        public async Task<IActionResult> DeskAreaDetails(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            DeskAreaDetailsViewModel deskAreaDetailsViewModel = new();

            var result = await _deskAreaDetailRepository.DeskAreaDetail(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PAreaId = id
                });

            if (result.PMessageType == IsOk)
            {
                deskAreaDetailsViewModel.AreaId = id;
                deskAreaDetailsViewModel.AreaDesc = result.PAreaDesc;
                deskAreaDetailsViewModel.AreaCatgCode = result.PAreaCatgCode;
                deskAreaDetailsViewModel.AreaCatgDesc = result.PAreaCatgDesc;
                deskAreaDetailsViewModel.AreaInfo = result.PAreaInfo;
                deskAreaDetailsViewModel.AreaTypeVal = result.PAreaTypeVal;
                deskAreaDetailsViewModel.AreaTypeText = result.PAreaTypeText;
                deskAreaDetailsViewModel.IsRestrictedVal = result.PIsRestrictedVal;
                deskAreaDetailsViewModel.IsRestrictedText = result.PIsRestrictedText;
            }

            return View("DeskAreaDetails", deskAreaDetailsViewModel);
        }

        public async Task<IActionResult> DeskListDetailIndex(string areaId)
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterDeskAreaDeskListIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            DeskMasterViewModel deskMasterViewModel = new()
            {
                FilterDataModel = filterDataModel
            };
            ViewData["ModuleName"] = "DeskAreaDeskListFilter";

            return PartialView("_DeskAreaDeskListPartial", deskMasterViewModel);
        }

        [HttpGet]
        public async Task<JsonResult> GetListsDeskAreaDeskList(string paramJSon)
        {
            DTResult<DeskMasterDataTableList> result = new();

            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJSon);

            int totalRow = 0;
            try
            {
                System.Collections.Generic.IEnumerable<DeskMasterDataTableList> data = await _deskMasterDataTableListRepository.DeskMasterDataTableListAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PGenericSearch = param.GenericSearch ?? " ",
                            PWorkArea = param.WorkArea,
                            POffice = param.Office,
                            PFloor = param.Floor,
                            PCabin = param.Cabin,
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

        public async Task<IActionResult> OfficeListDetailsIndex(string areaId)
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterDeskAreaOfficeListIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            DeskAreaOfficeMapViewModel deskAreaOfficeMapViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            //DeskAreaDetailsViewModel deskAreaDetailsViewModel = new();

            return PartialView("_DeskAreaOfficeListPartial", deskAreaOfficeMapViewModel);
        }

        [HttpGet]
        public async Task<JsonResult> GetListsDeskAreaOfficeList(string paramJson)
        {
            DTResult<DeskAreaOfficeMapDataTableList> result = new();
            int totalRow = 0;
            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);
            try
            {
                System.Collections.Generic.IEnumerable<DeskAreaOfficeMapDataTableList> data = await _deskAreaOfficeMapDataTableListRepository.DeskAreaOfficeMapDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch ?? " ",
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

        public async Task<IActionResult> UserListDetailsIndex(string areaId)
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterDeskAreaUserListIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            DeskAreaUserMapViewModel deskAreaUserMapViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            //DeskAreaDetailsViewModel deskAreaDetailsViewModel = new();

            return PartialView("_DeskAreaUserListPartial", deskAreaUserMapViewModel);
        }

        [HttpGet]
        public async Task<JsonResult> GetListsDeskAreaUserList(string paramJson)
        {
            DTResult<DeskAreaUserMapDataTableList> result = new();
            int totalRow = 0;
            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);
            try
            {
                System.Collections.Generic.IEnumerable<DeskAreaUserMapDataTableList> data = await _deskAreaUserMapDataTableListRepository.DeskAreaUserMapDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch ?? " ",
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

        public async Task<IActionResult> DeskAreaDeskListFilterGet(string moduleName)
        {
            Domain.Models.FilterRetrieve retVal = await RetriveFilter(ConstFilterDeskAreaDeskListIndex);

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }
            var officeList = await _selectTcmPLRepository.DmsOfficeList(BaseSpTcmPLGet(), null);
            var floorList = await _selectTcmPLRepository.DmsFloorList(BaseSpTcmPLGet(), null);

            ViewData["OfficeList"] = new SelectList(officeList, "DataValueField", "DataTextField");
            ViewData["FloorList"] = new SelectList(floorList, "DataValueField", "DataTextField");

            ViewData["ModuleName"] = moduleName;

            return PartialView("_ModalDeskAreaDeskListFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> DeskAreaDeskListFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                string jsonFilter;
                jsonFilter = JsonConvert.SerializeObject(
                        new
                        {
                            filterDataModel.Office,
                            filterDataModel.Floor,
                            filterDataModel.Cabin,
                        });

                _ = await CreateFilter(jsonFilter, ConstFilterDeskAreaDeskListIndex);

                return Json(new { success = true, office = filterDataModel.Office, floor = filterDataModel.Floor, cabin = filterDataModel.Cabin });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        #endregion DeskAreaDetails

        #region TagObjectMapping

        public async Task<IActionResult> TagObjectMappingIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterTagObjectMappingIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            TagObjectMapViewModel tagObjectMapViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(tagObjectMapViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsTagObjMapping(string paramJson)
        {
            DTResult<TagObjectMapDataTableList> result = new();
            int totalRow = 0;
            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);
            try
            {
                System.Collections.Generic.IEnumerable<TagObjectMapDataTableList> data = await _tagObjectMapDataTableListRepository.TagObjectMapDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch ?? " ",
                        PTagId = param.TagId,
                        PObjTypeId = param.ObjTypeId,
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
        public async Task<IActionResult> TagObjectMappingCreate()
        {
            TagObjectMapCreateViewModel tagObjectMapCreateViewModel = new();

            IEnumerable<DataField> objectTypeList = await _selectTcmPLRepository.DmsTagObjectTypeList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["ObjectTypeList"] = new SelectList(objectTypeList, "DataValueField", "DataTextField");

            IEnumerable<DataField> tagTypeList = await _selectTcmPLRepository.DmsTagTypeList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["TagTypeList"] = new SelectList(tagTypeList, "DataValueField", "DataTextField");

            return PartialView("_ModalTagObjectMappingCreate", tagObjectMapCreateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> TagObjectMappingCreate([FromForm] TagObjectMapCreateViewModel tagObjectMapCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _tagObjectMapRepository.TagObjectMapCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PTagId = tagObjectMapCreateViewModel.TagId,
                            PObjId = tagObjectMapCreateViewModel.ObjId,
                            PObjTypeId = tagObjectMapCreateViewModel.ObjTypeId
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

            IEnumerable<DataField> objectTypeList = await _selectTcmPLRepository.DmsTagObjectTypeList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["ObjectTypeList"] = new SelectList(objectTypeList, "DataValueField", "DataTextField", tagObjectMapCreateViewModel.ObjId);

            IEnumerable<DataField> tagTypeList = await _selectTcmPLRepository.DmsTagTypeList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["TagTypeList"] = new SelectList(tagTypeList, "DataValueField", "DataTextField");

            return PartialView("_ModalTagObjectMappingCreate", tagObjectMapCreateViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> TagObjectMappingDelete(string id)
        {
            try
            {
                var result = await _tagObjectMapRepository.TagObjectMapDeleteAsync(
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

        public async Task<IActionResult> TagObjectMappingExcelDownload()
        {
            var timeStamp = DateTime.Now.ToFileTime();

            string fileName = "Tag Object Mapping List_" + timeStamp.ToString();
            string reportTitle = "Tag Object Mapping List";
            string sheetName = "Tag Object Mapping List";

            IEnumerable<TagObjectMapDataTableList> data = await _tagObjectMapDataTableListRepository.TagObjectMapDataTableListForExcelAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                });

            if (data == null) { return NotFound(); }

            var json = JsonConvert.SerializeObject(data);

            IEnumerable<TagObjectMapDataTableExcel> excelData = JsonConvert.DeserializeObject<IEnumerable<TagObjectMapDataTableExcel>>(json);

            var byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, reportTitle, sheetName);

            var mimeType = MimeTypeMap.GetMimeType("xlsx");

            FileContentResult file = File(byteContent, mimeType, fileName);

            return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
        }

        public async Task<IActionResult> TagObjectMappingFilterGet()
        {
            var retVal = await RetriveFilter(ConstFilterTagObjectMappingIndex);

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            IEnumerable<DataField> tagTypeList = await _selectTcmPLRepository.DmsTagTypeList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["TagTypeList"] = new SelectList(tagTypeList, "DataValueField", "DataTextField");

            IEnumerable<DataField> objectTypeList = await _selectTcmPLRepository.DmsTagObjectTypeList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["ObjectTypeList"] = new SelectList(objectTypeList, "DataValueField", "DataTextField");

            return PartialView("_ModalTagObjectMappingFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> TagObjectMappingFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                string jsonFilter;
                jsonFilter = JsonConvert.SerializeObject(
                        new
                        {
                            filterDataModel.TagId,
                            filterDataModel.ObjTypeId
                        });

                _ = await CreateFilter(jsonFilter, ConstFilterTagObjectMappingIndex);

                return Json(new
                {
                    success = true,
                    tagId = filterDataModel.TagId,
                    objTypeId = filterDataModel.ObjTypeId,
                });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        #endregion TagObjectMapping

        #region SelectListFunctions

        public async Task<IEnumerable<DataField>> DeskAreaDeptInAreaList(string areaId)
        {
            IEnumerable<DataField> deptList = await _selectTcmPLRepository.DeskBookDeptInAreaList(BaseSpTcmPLGet(), new ParameterSpTcmPL { PAreaId = areaId });

            return deptList;
        }

        public async Task<IEnumerable<DataField>> DeskAreaProjectInAreaList(string areaId)
        {
            IEnumerable<DataField> projectList = await _selectTcmPLRepository.DeskBookProjectInAreaList(BaseSpTcmPLGet(), new ParameterSpTcmPL { PAreaId = areaId });

            return projectList;
        }

        public async Task<IEnumerable<DataField>> DeskAreaUserInAreaList(string areaId)
        {
            IEnumerable<DataField> userList = await _selectTcmPLRepository.DeskBookUserInAreaList(BaseSpTcmPLGet(), new ParameterSpTcmPL { PAreaId = areaId });

            return userList;
        }

        public async Task<IEnumerable<DataField>> DeskAreaEmpAndDeskInAreaList(string areaId)
        {
            IEnumerable<DataField> empAndDeskList = await _selectTcmPLRepository.DeskBookEmpAndDeskInAreaList(BaseSpTcmPLGet(), new ParameterSpTcmPL { PAreaId = areaId });

            return empAndDeskList;
        }

        public async Task<IEnumerable<DataField>> DeskAreaEmpAndDeskTypeInAreaList(string areaId)
        {
            IEnumerable<DataField> empAndDeskTypeList = await _selectTcmPLRepository.DeskBookEmpAndDeskTypeInAreaList(BaseSpTcmPLGet(), new ParameterSpTcmPL { PAreaId = areaId });

            return empAndDeskTypeList;
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
        public async Task<IActionResult> GetOfficeList(string employee)
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
        public async Task<IActionResult> GeteTagListForEmp(string employee)
        {
            var TagList = await _selectTcmPLRepository.DeskBookingTagForEmpList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
                PEmpno = employee
            });

            return Json(new { TagList });
        }

        [HttpGet]
        public async Task<IActionResult> GetOfficeListForHod(string employee)
        {
            var empdetails = await _commonEmployeeDetailsRepository.EmployeeDetailAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
                PEmpno = employee
            });

            var OfficeList = await _selectTcmPLRepository.DeskBookingOfficeLocationList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
                PLocation = empdetails.PCurrentOfficeLocation.Trim(),
            });

            return Json(new { OfficeList, BaseOfficeLocation = empdetails.PCurrentOfficeLocation });
        }

        [HttpGet]
        public async Task<IActionResult> GetAreaListForEmpAreaMap(string office, string employee)
        {
            var empdetails = await _commonEmployeeDetailsRepository.EmployeeDetailAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
                PEmpno = employee
            });

            var deskAreaList = await _selectTcmPLRepository.DeskBookAreaForAssignmentDmsList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
                POffice = office,
                PAreaType = "DEPT+PROJ",
                PEmpno = empdetails.PForEmpno
            });

            return Json(deskAreaList);
        }

        [HttpGet]
        public async Task<IActionResult> GetAreaListForFixedPc(string office, string employee)
        {
            var deskAreaList = await _selectTcmPLRepository.DeskBookAreaForFixedPcList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
                POffice = office,
                PEmpno = employee
            });

            return Json(deskAreaList);
        }

        [HttpGet]
        public async Task<IActionResult> GetDeskAreaListForHod()
        {
            var deskAreaList = await _selectTcmPLRepository.DeskBookDeskAreasForHod(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });

            return Json(deskAreaList);
        }

        [HttpGet]
        public async Task<IActionResult> GetObjIdList(string objTypeId)
        {
            var objIdList = await _selectTcmPLRepository.DmsDeskBookObjIdList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
                PObjId = objTypeId
            });

            return Json(objIdList);
        }

        //[HttpGet]
        //public async Task<IActionResult> GetDeskList(string office, string areaId)
        //{
        //    var deskList = await _selectTcmPLRepository.DeskBookDeskIdList(BaseSpTcmPLGet(), new ParameterSpTcmPL
        //    {
        //        POffice = office,
        //        PAreaId = areaId
        //    });

        //    return Json(deskList);
        //}

        #endregion SelectListFunctions

        #region DeskImport

        [HttpGet]
        public async Task<IActionResult> DeskImportIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterDeskImportIndex
            });

            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            DeskViewModel deskViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(deskViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsDesks(string paramJson)
        {
            DTResult<SetZoneDeskDataTableList> result = new();
            int totalRow = 0;

            try
            {
                var param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);
                System.Collections.Generic.IEnumerable<SetZoneDeskDataTableList> data = await _desksDataTableListRepository.DesksDataTableListAsync(
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
        public IActionResult DesksImport()
        {
            SetZoneDesksCreateViewModel desksCreateViewModel = new();

            return PartialView("_ModalDeskUploadPartial", desksCreateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DesksImport(SetZoneDesksCreateViewModel setZonedesksCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var jsonstring = setZonedesksCreateViewModel.DeskId;

                    if (jsonstring != null)
                    {
                        jsonstring = MultilineToCSV(jsonstring);
                        if (jsonstring.Length < 5)
                        {
                            throw new Exception("Please Enter Valid Desk Id");
                        }
                    }

                    string[] arrItems = jsonstring.Split(',');

                    List<ReturnDeskid> returnDeskList = new();

                    string formattedString = null;

                    foreach (var desk in arrItems)
                    {
                        formattedString = formattedString + "," + desk;
                        returnDeskList.Add(new ReturnDeskid { Deskid = desk });
                    }
                    if (!returnDeskList.Any())
                    {
                        throw new Exception("Please enter valid desk id ");
                    }
                    //string formattedString = JsonConvert.SerializeObject(returnDeskList);

                    formattedString = formattedString.Trim(',');

                    var result = await _deskImportRepository.ImportSetZoneDeskJSonAsync(
                              BaseSpTcmPLGet(),
                              new ParameterSpTcmPL
                              {
                                  PParameterJson = formattedString
                              });

                    return result.PMessageType != IsOk
                        ? throw new Exception(result.PMessageText.Replace("-", " "))
                        : (IActionResult)Json(new { success = true, response = result.PMessageText });
                }
                throw new Exception("Please Enter Valid DeskId");
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
                throw new Exception("Please Enter Valid desk No");
            }

            string retVal = sourceStr.Replace(System.Environment.NewLine, ",");

            retVal = Regex.Replace(retVal, @"\s+", ",");

            return retVal;
        }

        public async Task<IActionResult> ImportDesksExcelDownload()
        {
            var timeStamp = DateTime.Now.ToFileTime();

            string fileName = "Desk List_" + timeStamp.ToString();
            string reportTitle = "Desk List";
            string sheetName = "Desk List";

            IEnumerable<SetZoneDeskDataTableList> data = await _desksDataTableListRepository.DesksDataTableListAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PRowNumber = 0,
                    PPageLength = 1000,
                });

            if (data == null) { return NotFound(); }

            var json = JsonConvert.SerializeObject(data);

            IEnumerable<DeskDataTableExcel> excelData = JsonConvert.DeserializeObject<IEnumerable<DeskDataTableExcel>>(json);

            var byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, reportTitle, sheetName);

            var mimeType = MimeTypeMap.GetMimeType("xlsx");

            FileContentResult file = File(byteContent, mimeType, fileName);

            return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
        }

        #endregion DeskImport
    }
}