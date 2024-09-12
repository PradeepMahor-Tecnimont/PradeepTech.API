using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using MimeTypes;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.Common;
using TCMPLApp.DataAccess.Repositories.DMS;
using TCMPLApp.DataAccess.Repositories.SWPVaccine;
using TCMPLApp.Domain.Models.DMS;
using TCMPLApp.Domain.Models.SWP;
using TCMPLApp.WebApp.Classes;
using TCMPLApp.WebApp.Controllers;
using TCMPLApp.WebApp.CustomPolicyProvider;

//using TCMPLApp.WebApp.Lib.Models;
using TCMPLApp.WebApp.Models;
using static TCMPLApp.WebApp.Classes.DTModel;

namespace TCMPLApp.WebApp.Areas.DMS.Controllers
{
    [Authorize]
    [Area("DMS")]
    public class DMSController : BaseController
    {
        private const string ConstFilterDMSGuestMasterIndex = "DMSGuestMasterIndex";
        private const string ConstFilterDeskBlockIndex = "DeskBlockIndex";
        private const string ConstFilterNewEmployeeIndex = "NewEmployeesIndex";
        private const string ConstFilterExcludeIndex = "ExcludeIndex";
        private const string ConstFilterAiroliEmpInDmUsermasterIndex = "AiroliEmpInDmUsermasterIndex";
        private const string ConstFilterAssetMapWithEmpIndex = "AssetMapWithEmpIndex";

        private readonly IDMSEmployeeRepository _dmsEmployeeRepository;
        private readonly IDeskMasterRepository _deskMasterRepository;
        private readonly IDeskMasterViewRepository _deskMasterViewRepository;
        private readonly IDeskMasterDataTableListRepository _deskMasterDataTableListRepository;
        private readonly ISelectTcmPLRepository _selectTcmPLRepository;
        private readonly IFilterRepository _filterRepository;
        private readonly IDMSGuestMasterDataTableListRepository _dmsGuestMasterDataTableListRepository;
        private readonly IDMSGuestMasterRepository _dmsGuestMasterRepository;
        private readonly IDMSGuestMasterDetailRepository _dmsGuestMasterDetailRepository;
        private readonly IDeskBlockDataTableListRepository _deskBlockDataTableListRepository;
        private readonly IDeskBlockDetailRepository _deskBlockDetailRepository;
        private readonly IDeskBlockRepository _deskBlockRepository;
        private readonly IUtilityRepository _utilityRepository;
        private readonly INewEmployeeDataTableListRepository _newEmployeeDataTableListRepository;
        private readonly INewEmployeeDetailRepository _newEmployeeDetailRepository;
        private readonly IAssetMasterDetailRepository _assetMasterDetailRepository;
        private readonly ICommonEmployeeDetailsRepository _commonEmployeeDetailsRepository;
        private readonly IExcludeDataTableListRepository _excludeDataTableListRepository;
        private readonly IExcludeRepository _excludeRepository;
        private readonly IDmManagementRepository _dmManagementRepository;
        private readonly IAiroliEmpInDmUsermasterDataTableListRepository _airoliEmpInDmUsermasterDataTableListRepository;
        private readonly IAssetMapWithEmpDataTableListRepository _assetMapWithEmpDataTableListRepository;

        public DMSController(
            IFilterRepository filterRepository,
            IDMSEmployeeRepository dmsEmployeeRepository,
            IDeskMasterRepository deskMasterRepository,
            IDeskMasterViewRepository deskMasterViewRepository,
            IDeskMasterDataTableListRepository deskMasterDataTableListRepository,
            ISelectTcmPLRepository selectTcmPLRepository,
            IDMSGuestMasterDataTableListRepository dmsGuestMasterDataTableListRepository,
            IDMSGuestMasterRepository dmsGuestMasterRepository,
            IDMSGuestMasterDetailRepository dmsGuestMasterDetailRepository,
            IDeskBlockDataTableListRepository deskBlockDataTableListRepository,
            IDeskBlockDetailRepository deskBlockDetailRepository,
            IDeskBlockRepository deskBlockRepository,
            IUtilityRepository utilityRepository,
            INewEmployeeDataTableListRepository newEmployeeDataTableListRepository,
            INewEmployeeDetailRepository newEmployeeDetailRepository,
            IAssetMasterDetailRepository assetMasterDetailRepository,
            ICommonEmployeeDetailsRepository commonEmployeeDetailsRepository,
            IExcludeDataTableListRepository excludeDataTableListRepository,
            IExcludeRepository excludeRepository,
            IDmManagementRepository dmManagementRepository,
            IAiroliEmpInDmUsermasterDataTableListRepository airoliEmpInDmUsermasterDataTableListRepository,
            IAssetMapWithEmpDataTableListRepository assetMapWithEmpDataTableListRepository)
        {
            _dmsEmployeeRepository = dmsEmployeeRepository;
            _deskMasterRepository = deskMasterRepository;
            _deskMasterViewRepository = deskMasterViewRepository;
            _deskMasterDataTableListRepository = deskMasterDataTableListRepository;
            _selectTcmPLRepository = selectTcmPLRepository;
            _filterRepository = filterRepository;
            _dmsGuestMasterDataTableListRepository = dmsGuestMasterDataTableListRepository;
            _dmsGuestMasterRepository = dmsGuestMasterRepository;
            _dmsGuestMasterDetailRepository = dmsGuestMasterDetailRepository;
            _deskBlockDataTableListRepository = deskBlockDataTableListRepository;
            _deskBlockDetailRepository = deskBlockDetailRepository;
            _deskBlockRepository = deskBlockRepository;
            _utilityRepository = utilityRepository;
            _newEmployeeDataTableListRepository = newEmployeeDataTableListRepository;
            _newEmployeeDetailRepository = newEmployeeDetailRepository;
            _assetMasterDetailRepository = assetMasterDetailRepository;
            _commonEmployeeDetailsRepository = commonEmployeeDetailsRepository;
            _excludeDataTableListRepository = excludeDataTableListRepository;
            _excludeRepository = excludeRepository;
            _dmManagementRepository = dmManagementRepository;
            _airoliEmpInDmUsermasterDataTableListRepository = airoliEmpInDmUsermasterDataTableListRepository;
            _assetMapWithEmpDataTableListRepository = assetMapWithEmpDataTableListRepository;
        }

        public IActionResult Index()
        {
            return View();
        }

        public IActionResult Asset2HomeIndex()
        {
            return View();
        }

        public IActionResult MastersIndex()
        {
            return View();
        }

        [HttpGet]
        public IActionResult DeskMasterIndex()
        {
            //UserIdentity currentUserIdentity = CurrentUserIdentity;
            //var result = (await _employeeMasterViewRepository.GetEmployeeMasterListAsync(currentUserIdentity.EmpNo)).ToList().AsQueryable();
            //DeskMasterViewModel deskMasterViewModel = new DeskMasterViewModel();
            //deskMasterViewModel.FilterDataModel.Status = 1;
            //return View(deskMasterViewModel);
            //return RedirectToAction("DMS/DMS/Desk/DeskMasterIndex", "DMS"); ;
            return View();
        }

        #region DMSGuestMaster

        [HttpGet]
        public async Task<IActionResult> DMSGuestMasterIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterDMSGuestMasterIndex
            });

            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            DMSGuestMasterViewModel dmsGuestMasterViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(dmsGuestMasterViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsDMSGuestMaster(DTParameters param)
        {
            DTResult<DMSGuestMasterDataTableList> result = new();
            int totalRow = 0;

            try
            {
                System.Collections.Generic.IEnumerable<DMSGuestMasterDataTableList> data = await _dmsGuestMasterDataTableListRepository.GuestMasterDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch,
                        PStartDate = param.StartDate,
                        PEndDate = param.EndDate,
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

        public async Task<IActionResult> DMSGuestMasterFilterGet()
        {
            var retVal = await RetriveFilter(ConstFilterDMSGuestMasterIndex);

            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }
            var costCodeList = await _selectTcmPLRepository.DMSAdmHodSecCostCodeList(BaseSpTcmPLGet(), null);

            ViewData["CostCodeList"] = new SelectList(costCodeList, "DataValueField", "DataTextField");

            return PartialView("_ModalDMSGuestMasterFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> DMSGuestMasterFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                if (filterDataModel.StartDate != null || filterDataModel.EndDate != null)
                {
                    if (filterDataModel.StartDate == null || filterDataModel.EndDate == null)
                    {
                        throw new Exception("Both the dates are reqired.");
                    }
                    else if (filterDataModel.StartDate?.ToString("yyyy") != filterDataModel.EndDate?.ToString("yyyy"))
                    {
                        throw new Exception("Date range should be with in same year.");
                    }
                    else if (filterDataModel.StartDate > filterDataModel.EndDate)
                    {
                        throw new Exception("End date should be greater than start date");
                    }
                }

                string jsonFilter;
                jsonFilter = JsonConvert.SerializeObject(
                        new
                        {
                            filterDataModel.StartDate,
                            filterDataModel.EndDate,
                            filterDataModel.CostCode
                        });

                _ = await CreateFilter(jsonFilter, ConstFilterDMSGuestMasterIndex);

                return Json(new { success = true, startDate = filterDataModel.StartDate, endDate = filterDataModel.EndDate, costCode = filterDataModel.CostCode });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        [HttpGet]
        public async Task<IActionResult> DMSGuestMasterDetails(string guestEmpno)
        {
            if (guestEmpno == null)
            {
                return NotFound();
            }

            DMSGuestMasterDetails result = await _dmsGuestMasterDetailRepository.DMSGuestMasterDetail(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PGuestEmpno = guestEmpno
                });

            DMSGuestMasterDetailsViewModel dmsGuestMasterDetailsViewModel = new();

            if (result.PMessageType == IsOk)
            {
                dmsGuestMasterDetailsViewModel.GuestEmpNo = guestEmpno;
                dmsGuestMasterDetailsViewModel.CostCode = result.PCostcode;
                dmsGuestMasterDetailsViewModel.ProjNo5 = result.PProjno5;
                //dmsGuestMasterDetailsViewModel.ProjName = result.PProjName;
                dmsGuestMasterDetailsViewModel.TargetDesk = result.PTargetDesk;
                dmsGuestMasterDetailsViewModel.GuestName = result.PGuestName;
                //dmsGuestMasterDetailsViewModel.CreatedBy = result.PCreatedBy;
                //dmsGuestMasterDetailsViewModel.CreationDate = result.PCreationDate;
                dmsGuestMasterDetailsViewModel.ModifiedBy = result.PModifiedBy;
                dmsGuestMasterDetailsViewModel.ModifiedDate = result.PModifiedDate;
                dmsGuestMasterDetailsViewModel.FromDate = result.PFromDate;
                dmsGuestMasterDetailsViewModel.ToDate = result.PToDate;
            }

            return PartialView("_ModalDMSGuestMasterDetailsPartial", dmsGuestMasterDetailsViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> DMSGuestMasterCreate()
        {
            DMSGuestMasterCreateViewModel dmsGuestMasterCreateViewModel = new();

            var costCodeList = await _selectTcmPLRepository.CostCodeListAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });

            var projectList = await _selectTcmPLRepository.DMSProject7List(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });

            var targetDeskList = await _selectTcmPLRepository.DMSAvailableDesksForGuestList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });

            ViewData["ProjNo7List"] = new SelectList(projectList, "DataValueField", "DataTextField");
            ViewData["CostCodeList"] = new SelectList(costCodeList, "DataValueField", "DataTextField");
            ViewData["TargetDeskList"] = new SelectList(targetDeskList, "DataValueField", "DataTextField");

            return PartialView("_ModalDMSGuestMasterCreatePartial", dmsGuestMasterCreateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DMSGuestMasterCreate([FromForm] DMSGuestMasterCreateViewModel dmsGuestMasterCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _dmsGuestMasterRepository.GuestMasterCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PGuestName = dmsGuestMasterCreateViewModel.GuestName,
                            PGuestCostcode = dmsGuestMasterCreateViewModel.CostCode,
                            PGuestProjno = dmsGuestMasterCreateViewModel.ProjNo7,
                            PGuestFromDate = dmsGuestMasterCreateViewModel.FromDate,
                            PGuestToDate = dmsGuestMasterCreateViewModel.ToDate,
                            PGuestTargetDesk = dmsGuestMasterCreateViewModel.TargetDesk,
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

            var costCodeList = await _selectTcmPLRepository.CostCodeListAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });

            var projectList = await _selectTcmPLRepository.DMSProject7List(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });

            var targetDeskList = await _selectTcmPLRepository.DMSAvailableDesksForGuestList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });

            ViewData["ProjNo7List"] = new SelectList(projectList, "DataValueField", "DataTextField", dmsGuestMasterCreateViewModel.ProjNo7);
            ViewData["CostCodeList"] = new SelectList(costCodeList, "DataValueField", "DataTextField", dmsGuestMasterCreateViewModel.CostCode);
            ViewData["TargetDeskList"] = new SelectList(targetDeskList, "DataValueField", "DataTextField", dmsGuestMasterCreateViewModel.TargetDesk);

            return PartialView("_ModalDMSGuestMasterCreatePartial", dmsGuestMasterCreateViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> DMSGuestMasterEdit(string guestEmpno)
        {
            if (guestEmpno == null)
            {
                return NotFound();
            }

            DMSGuestMasterDetails result = await _dmsGuestMasterDetailRepository.DMSGuestMasterDetail(
                 BaseSpTcmPLGet(),
                 new ParameterSpTcmPL
                 {
                     PGuestEmpno = guestEmpno
                 });

            DMSGuestMasterUpdateViewModel dmsGuestMasterUpdateViewModel = new();

            if (result.PMessageType == IsOk)
            {
                dmsGuestMasterUpdateViewModel.GuestEmpNo = guestEmpno;
                dmsGuestMasterUpdateViewModel.CostCode = result.PCostcode;
                dmsGuestMasterUpdateViewModel.ProjNo7 = result.PProjno5;
                dmsGuestMasterUpdateViewModel.TargetDesk = result.PTargetDesk;
                dmsGuestMasterUpdateViewModel.GuestName = result.PGuestName;
                //dmsGuestMasterUpdateViewModel.CreatedBy = result.PCreatedBy;
                //dmsGuestMasterUpdateViewModel.CreationDate = result.PCreationDate;
                dmsGuestMasterUpdateViewModel.ModifiedBy = result.PModifiedBy;
                dmsGuestMasterUpdateViewModel.ModifiedDate = result.PModifiedDate;
                dmsGuestMasterUpdateViewModel.FromDate = result.PFromDate;
                dmsGuestMasterUpdateViewModel.ToDate = result.PToDate;
            }

            var costCodeList = await _selectTcmPLRepository.CostCodeListAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });

            var projectList = await _selectTcmPLRepository.DMSProject7List(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });

            var targetDeskList = await _selectTcmPLRepository.DMSAvailableDesksForGuestList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });

            ViewData["ProjNo7List"] = new SelectList(projectList, "DataValueField", "DataTextField", dmsGuestMasterUpdateViewModel.ProjNo7);
            ViewData["CostCodeList"] = new SelectList(costCodeList, "DataValueField", "DataTextField", dmsGuestMasterUpdateViewModel.CostCode);
            ViewData["TargetDeskList"] = new SelectList(targetDeskList, "DataValueField", "DataTextField", dmsGuestMasterUpdateViewModel.TargetDesk);

            return PartialView("_ModalDMSGuestMasterEditPartial", dmsGuestMasterUpdateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DMSGuestMasterEdit([FromForm] DMSGuestMasterUpdateViewModel dmsGuestMasterUpdateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    if (!string.IsNullOrEmpty(dmsGuestMasterUpdateViewModel.NewTargetDesk))
                    {
                        dmsGuestMasterUpdateViewModel.TargetDesk = dmsGuestMasterUpdateViewModel.NewTargetDesk;
                    }

                    var result = await _dmsGuestMasterRepository.GuestMasterEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PGuestEmpno = dmsGuestMasterUpdateViewModel.GuestEmpNo,
                            PGuestName = dmsGuestMasterUpdateViewModel.GuestName,
                            PGuestProjno = dmsGuestMasterUpdateViewModel.ProjNo7,
                            PGuestToDate = dmsGuestMasterUpdateViewModel.ToDate,
                            PGuestTargetDesk = dmsGuestMasterUpdateViewModel.TargetDesk,
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

            var costCodeList = await _selectTcmPLRepository.CostCodeListAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });

            var projectList = await _selectTcmPLRepository.DMSProject7List(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });

            var targetDeskList = await _selectTcmPLRepository.DMSAvailableDesksForGuestList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });

            ViewData["ProjNo7List"] = new SelectList(projectList, "DataValueField", "DataTextField", dmsGuestMasterUpdateViewModel.ProjNo7);
            ViewData["CostCodeList"] = new SelectList(costCodeList, "DataValueField", "DataTextField", dmsGuestMasterUpdateViewModel.CostCode);
            ViewData["TargetDeskList"] = new SelectList(targetDeskList, "DataValueField", "DataTextField", dmsGuestMasterUpdateViewModel.TargetDesk);

            return PartialView("_ModalDMSGuestMasterEditPartial", dmsGuestMasterUpdateViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> DMSGuestMasterDelete(string guestEmpno, string targetDesk)
        {
            try
            {
                if (string.IsNullOrEmpty(targetDesk) || string.IsNullOrEmpty(guestEmpno))
                {
                    return NotFound();
                }

                var result = await _dmsGuestMasterRepository.GuestMasterDeleteAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGuestEmpno = guestEmpno,

                        PGuestTargetDesk = targetDesk,
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
        public async Task<IActionResult> DMSGuestMasterReleaseDesk(string guestEmpno, string targetDesk)
        {
            try
            {
                if (string.IsNullOrEmpty(targetDesk) || string.IsNullOrEmpty(guestEmpno))
                {
                    return NotFound();
                }

                var result = await _dmsGuestMasterRepository.GuestMasterDeskReleaseAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGuestEmpno = guestEmpno,

                        PGuestTargetDesk = targetDesk,
                    }
                    );

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        public async Task<IActionResult> DMSGuestMasterExcelDownload()
        {
            try
            {
                var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
                {
                    PModuleName = CurrentUserIdentity.CurrentModule,
                    PMetaId = CurrentUserIdentity.MetaId,
                    PPersonId = CurrentUserIdentity.EmployeeId,
                    PMvcActionName = ConstFilterDMSGuestMasterIndex
                });
                FilterDataModel filterDataModel = new();
                if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                {
                    filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
                }

                string StrFimeName;

                var timeStamp = DateTime.Now.ToFileTime();
                StrFimeName = "GuestMaster_" + timeStamp.ToString();

                string strUser = User.Identity.Name;

                IEnumerable<DMSGuestMasterDataTableList> data = await _dmsGuestMasterDataTableListRepository.GuestMasterDataTableListForExcelAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = filterDataModel.GenericSearch,
                        PStartDate = filterDataModel.StartDate,
                        PEndDate = filterDataModel.EndDate,
                        PCostcode = filterDataModel.CostCode,
                        PRowNumber = 0,
                        PPageLength = 999999
                    });

                if (data == null) { return NotFound(); }

                var json = JsonConvert.SerializeObject(data);

                IEnumerable<DMSGuestMasterDataTableExcel> excelData = JsonConvert.DeserializeObject<IEnumerable<DMSGuestMasterDataTableExcel>>(json);

                byte[] byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, "GuestMasters", "GuestMasters");

                var mimeType = MimeTypeMap.GetMimeType("xlsx");

                FileContentResult file = File(byteContent, mimeType, StrFimeName);

                return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        [HttpGet]
        public async Task<IActionResult> DMSGuestMasterLogIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterDMSGuestMasterIndex
            });

            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            DMSGuestMasterViewModel dmsGuestMasterViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(dmsGuestMasterViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsDMSGuestMasterlog(DTParameters param)
        {
            DTResult<DMSGuestMasterDataTableList> result = new();
            int totalRow = 0;

            try
            {
                System.Collections.Generic.IEnumerable<DMSGuestMasterDataTableList> data = await _dmsGuestMasterDataTableListRepository.GuestMasterLogDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch,
                        PStartDate = param.StartDate,
                        PEndDate = param.EndDate,
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

        #endregion DMSGuestMaster

        #region Desk Block

        public async Task<IActionResult> DeskBlockIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterDeskBlockIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            DeskBlockViewModel deskBlockViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(deskBlockViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsDeskBlock(DTParameters param)
        {
            DTResult<DeskBlockDataTableList> result = new();
            int totalRow = 0;

            try
            {
                System.Collections.Generic.IEnumerable<DeskBlockDataTableList> data = await _deskBlockDataTableListRepository.DeskBlockDataTableListAsync(
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
        public async Task<IActionResult> DeskBlockExcelDownload()
        {
            try
            {
                var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
                {
                    PModuleName = CurrentUserIdentity.CurrentModule,
                    PMetaId = CurrentUserIdentity.MetaId,
                    PPersonId = CurrentUserIdentity.EmployeeId,
                    PMvcActionName = ConstFilterDeskBlockIndex
                });
                FilterDataModel filterDataModel = new();
                if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                {
                    filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
                }

                string StrFimeName;

                var timeStamp = DateTime.Now.ToFileTime();
                StrFimeName = "DeskBlock_" + timeStamp.ToString();

                string strUser = User.Identity.Name;

                IEnumerable<DeskBlockDataTableList> data = await _deskBlockDataTableListRepository.DeskBlockDataTableListForExcelAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = filterDataModel.GenericSearch
                    });

                if (data == null) { return NotFound(); }

                var json = JsonConvert.SerializeObject(data);

                IEnumerable<DeskBlockDataTableExcel> excelData = JsonConvert.DeserializeObject<IEnumerable<DeskBlockDataTableExcel>>(json);

                byte[] byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, "DeskBlock", "DeskBlock");

                var mimeType = MimeTypeMap.GetMimeType("xlsx");

                FileContentResult file = File(byteContent, mimeType, StrFimeName);

                return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        [HttpGet]
        public async Task<IActionResult> DeskBlockCreate()
        {
            DeskBlockCreateViewModel deskBlockCreateViewModel = new();

            var blockReasonList = await _selectTcmPLRepository.BlockReasonList(BaseSpTcmPLGet(), new ParameterSpTcmPL { });
            ViewData["BlockReasonList"] = new SelectList(blockReasonList, "DataValueField", "DataTextField");

            return PartialView("_ModalDeskBlockCreatePartial", deskBlockCreateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DMSHelper.ActionITAdm)]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeskBlockCreate([FromForm] DeskBlockCreateViewModel deskBlockCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _deskBlockRepository.DeskBlockCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PDeskid = deskBlockCreateViewModel.Deskid,
                            PRemarks = deskBlockCreateViewModel.Remarks,
                            PBlockreason = deskBlockCreateViewModel.Blockreason
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

            return PartialView("_ModalDeskBlockCreatePartial", deskBlockCreateViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> DeskBlockEdit(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            DeskBlockDetails result = await _deskBlockDetailRepository.DeskBlockDetail(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PDeskid = id
                });

            DeskBlockCreateViewModel deskBlockUpdateViewModel = new();

            if (result.PMessageType == IsOk)
            {
                deskBlockUpdateViewModel.Deskid = id;
                deskBlockUpdateViewModel.Remarks = result.PRemarks;
                deskBlockUpdateViewModel.Blockreason = result.PReasoncode;
            }

            var blockReasonList = await _selectTcmPLRepository.BlockReasonList(BaseSpTcmPLGet(), new ParameterSpTcmPL { });
            ViewData["BlockReasonList"] = new SelectList(blockReasonList, "DataValueField", "DataTextField", deskBlockUpdateViewModel.Blockreason);

            return PartialView("_ModalDeskBlockEditPartial", deskBlockUpdateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DMSHelper.ActionITAdm)]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeskBlockEdit([FromForm] DeskBlockCreateViewModel deskBlockUpdateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _deskBlockRepository.DeskBlockEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PDeskid = deskBlockUpdateViewModel.Deskid,
                            PRemarks = deskBlockUpdateViewModel.Remarks,
                            PBlockreason = deskBlockUpdateViewModel.Blockreason
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

            return PartialView("_ModalDeskBlockEditPartial", deskBlockUpdateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DMSHelper.ActionITAdm)]
        public async Task<IActionResult> DeskBlockDelete(string id)
        {
            try
            {
                var result = await _deskBlockRepository.DeskBlockRemoveAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PDeskid = id
                    }
                    );

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        #endregion Desk Block

        #region NewEmployee

        [HttpGet]
        public async Task<IActionResult> NewEmployeeIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterNewEmployeeIndex
            });

            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            NewEmployeeViewModel newEmployeeViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(newEmployeeViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsNewEmployees(string paramJson)
        {
            DTResult<NewEmployeeDataTableList> result = new();
            int totalRow = 0;

            try
            {
                var param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);
                System.Collections.Generic.IEnumerable<NewEmployeeDataTableList> data = await _newEmployeeDataTableListRepository.NewEmployeeDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch,
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

        public async Task<IActionResult> NewEmployeesExcelDownload()
        {
            try
            {
                var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
                {
                    PModuleName = CurrentUserIdentity.CurrentModule,
                    PMetaId = CurrentUserIdentity.MetaId,
                    PPersonId = CurrentUserIdentity.EmployeeId,
                    PMvcActionName = ConstFilterNewEmployeeIndex
                });
                FilterDataModel filterDataModel = new();
                if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                {
                    filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
                }

                string StrFimeName;

                var timeStamp = DateTime.Now.ToFileTime();
                StrFimeName = "NewEmployee_" + timeStamp.ToString();

                string strUser = User.Identity.Name;

                IEnumerable<NewEmployeeDataTableList> data = await _newEmployeeDataTableListRepository.NewEmployeeDataTableListForExcelAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PStartDate = filterDataModel.StartDate,
                        PEndDate = filterDataModel.EndDate
                    });

                if (data == null) { return NotFound(); }

                var json = JsonConvert.SerializeObject(data);

                IEnumerable<NewEmployeeDataTableExcel> excelData = JsonConvert.DeserializeObject<IEnumerable<NewEmployeeDataTableExcel>>(json);

                byte[] byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, "NewEmployee", "NewEmployee");

                var mimeType = MimeTypeMap.GetMimeType("xlsx");

                FileContentResult file = File(byteContent, mimeType, StrFimeName);

                return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        #endregion NewEmployee

        #region FloorPlan

        [HttpGet]
        public async Task<IActionResult> FloorPlanIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterNewEmployeeIndex
            });

            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            InternalTransferViewModel newEmployeeViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(newEmployeeViewModel);
        }

        #endregion FloorPlan

        #region filter

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

        public async Task<IActionResult> NewEmployeeFilterGet()
        {
            var retVal = await RetriveFilter(ConstFilterNewEmployeeIndex);

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            return PartialView("_ModalNewEmployeeFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> NewEmployeeFilterSet([FromForm] FilterDataModel filterDataModel)
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

                _ = await CreateFilter(jsonFilter, ConstFilterNewEmployeeIndex);

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

        public async Task<IActionResult> FloorPlanFilterGet()
        {
            var retVal = await RetriveFilter(ConstFilterNewEmployeeIndex);

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            var dmsFloorList = await _selectTcmPLRepository.DmsFloorList(BaseSpTcmPLGet(), null);
            ViewData["DmsFloorList"] = new SelectList(dmsFloorList, "DataValueField", "DataTextField");

            return PartialView("_ModalFloorpPlanFilterSet", filterDataModel);
        }

        #endregion filter

        #region AssetAssignment

        [HttpGet]
        public async Task<IActionResult> AssetSearchIndex(string search)
        {
            AssetSearchViewModel assetSearchViewModel = new();

            try
            {
                if (!string.IsNullOrEmpty(search))
                {
                    assetSearchViewModel.SearchByAssetId = search;
                    var result = await _assetMasterDetailRepository.AssetMasterDetail(
                              BaseSpTcmPLGet(),
                              new ParameterSpTcmPL
                              {
                                  PGenericSearch = assetSearchViewModel.SearchByAssetId.ToUpper()
                              });

                    assetSearchViewModel.AssetId = result.PMessageType == IsOk ? result.PAssetId : "";
                }
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
            }

            return View(assetSearchViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> AssetSearchIndex([FromForm] AssetSearchViewModel assetSearchViewModel)
        {
            try
            {
                if (!string.IsNullOrEmpty(assetSearchViewModel.SearchByAssetId))
                {
                    var result = await _assetMasterDetailRepository.AssetMasterDetail(
                              BaseSpTcmPLGet(),
                              new ParameterSpTcmPL
                              {
                                  PGenericSearch = assetSearchViewModel.SearchByAssetId
                              });

                    assetSearchViewModel.AssetId = result.PMessageType == IsOk ? result.PAssetId : "";
                }
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
            }

            return View(assetSearchViewModel);
        }

        public async Task<IActionResult> AssetSearchDetailsIndexPartial(string id)
        {
            AssetsDetailsViewModel assetsDetailsViewModel = new();

            try
            {
                if (string.IsNullOrEmpty(id))
                {
                    return NotFound();
                }

                var result = await _assetMasterDetailRepository.AssetMasterDetail(
                              BaseSpTcmPLGet(),
                              new ParameterSpTcmPL
                              {
                                  PGenericSearch = id
                              });

                if (result.PMessageType == IsOk)
                {
                    assetsDetailsViewModel.AssetId = result.PAssetId;
                    assetsDetailsViewModel.AssetType = result.PAssetType;
                    assetsDetailsViewModel.Model = result.PModel;
                    assetsDetailsViewModel.SerialNum = result.PSerialNum;
                    assetsDetailsViewModel.WarrantyEnd = result.PWarrantyEnd;
                    assetsDetailsViewModel.SapAssetCode = result.PSapAssetCode;
                    assetsDetailsViewModel.SubAssetType = result.PSubAssetType;
                    assetsDetailsViewModel.Scrap = result.PScrap;
                    assetsDetailsViewModel.ScrapDate = result.PScrapDate;
                    assetsDetailsViewModel.Employee = result.PEmployee;
                    assetsDetailsViewModel.Empno = result.PEmpno;
                    assetsDetailsViewModel.DeskId = result.PDeskid;
                    assetsDetailsViewModel.Status = result.PStatus;
                    assetsDetailsViewModel.Remarks = result.PRemarks;
                }
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
            }

            return PartialView("_AssetsDetailsIndexPartial", assetsDetailsViewModel);
        }

        #endregion AssetAssignment

        #region Exclude

        [HttpGet]
        public async Task<IActionResult> ExcludeIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterExcludeIndex
            });

            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            ExcludeViewModel excludeViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(excludeViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsExclude(string paramJson)
        {
            DTResult<ExcludeDataTableList> result = new();
            int totalRow = 0;

            try
            {
                var param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);
                System.Collections.Generic.IEnumerable<ExcludeDataTableList> data = await _excludeDataTableListRepository.ExcludeDataTableListAsync(
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
        public IActionResult ExcludeUpload()
        {
            ExcludeCreateViewModel excludeCreateViewModel = new();

            return PartialView("_ModalExcludeUploadPartial", excludeCreateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ExcludeUpload(ExcludeCreateViewModel excludeCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var jsonstring = excludeCreateViewModel.Employee;

                    if (jsonstring != null)
                    {
                        jsonstring = MultilineToCSV(jsonstring);
                        if (jsonstring.Length < 5)
                        {
                            throw new Exception("Please Enter Valid Employee No");
                        }
                    }

                    string[] arrItems = jsonstring.Split(',');

                    List<ReturnEmployee> returnEmpList = new();

                    foreach (var emp in arrItems)
                    {
                        if (emp != "" && emp.Length == 5)
                        {
                            returnEmpList.Add(new ReturnEmployee { Empno = emp });
                        }
                    }
                    if (!returnEmpList.Any())
                    {
                        throw new Exception("Please enter valid employee no (length:5)");
                    }
                    string formattedJson = JsonConvert.SerializeObject(returnEmpList);

                    var result = await _excludeRepository.ExcludeJSonAsync(
                              BaseSpTcmPLGet(),
                              new ParameterSpTcmPL
                              {
                                  PParameterJson = formattedJson
                              });

                    return result.PMessageType != IsOk
                        ? throw new Exception(result.PMessageText.Replace("-", " "))
                        : (IActionResult)Json(new { success = true, response = result.PMessageText });
                }
                throw new Exception("Please Enter Valid Employee No");
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

            string retVal = sourceStr.Replace(System.Environment.NewLine, ",");

            retVal = Regex.Replace(retVal, @"\s+", ",");

            return retVal;
        }

        [HttpPost]
        public async Task<IActionResult> ExcludeEmpDelete(string id)
        {
            try
            {
                Domain.Models.Common.DBProcMessageOutput result = await _excludeRepository.ExcludeEmpDeleteAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PEmpno = id
                    }
                    );

                return Json(new { success = result.PMessageType == IsOk, response = result.PMessageType, message = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        public async Task<IActionResult> ExcludeEmployeeExcelDownload()
        {
            var timeStamp = DateTime.Now.ToFileTime();

            string fileName = "Exclude Employees List_" + timeStamp.ToString();
            string reportTitle = "Exclude Employees List";
            string sheetName = "Exclude Employees List";

            IEnumerable<ExcludeDataTableList> data = await _excludeDataTableListRepository.ExcludeDataTableListAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PRowNumber = 0,
                    PPageLength = 1000,
                });

            if (data == null) { return NotFound(); }

            var json = JsonConvert.SerializeObject(data);

            IEnumerable<ExcludeEmployeeDataTableExcel> excelData = JsonConvert.DeserializeObject<IEnumerable<ExcludeEmployeeDataTableExcel>>(json);

            var byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, reportTitle, sheetName);

            var mimeType = MimeTypeMap.GetMimeType("xlsx");

            FileContentResult file = File(byteContent, mimeType, fileName);

            return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
        }

        #endregion Exclude

        #region AiroliEmpInDmUsermaster

        public IActionResult AiroliEmpInDmUsermasterIndex()
        {
            return View();
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListAiroliEmpInDmUsermaster(string paramJson)
        {
            DTResult<AiroliEmpInDmMasterDataTableList> result = new();
            int totalRow = 0;

            try
            {
                var param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

                IEnumerable<AiroliEmpInDmMasterDataTableList> data = await _airoliEmpInDmUsermasterDataTableListRepository.AiroliEmpInDmUsermasterDataTableListAsync(
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

        [HttpPost]
        public async Task<IActionResult> ClearAllAiroliEmpInDmUsermaster()
        {
            try
            {
                Domain.Models.Common.DBProcMessageOutput result = await _dmManagementRepository.RemoveAiroliEmpFromDmUsermasterAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                    }
                    );

                return Json(new { success = result.PMessageType == IsOk, response = result.PMessageType, message = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        #endregion AiroliEmpInDmUsermaster

        #region AssetMapWithEmployee

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DMSHelper.ActionITHelpDeskEng)]
        public async Task<IActionResult> AssetMapWithEmpIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterAssetMapWithEmpIndex
            });

            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }
            if (string.IsNullOrEmpty(filterDataModel.GroupType))
            {
                filterDataModel.GroupType = "Assets";
            }

            AssetMapWithEmpViewModel assetMapWithEmpViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(assetMapWithEmpViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DMSHelper.ActionITHelpDeskEng)]
        public async Task<JsonResult> GetAssetMapWithEmployees(string paramJson)
        {
            DTResult<AssetMapWithEmpDataTableList> result = new();
            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            int totalRow = 0;
            if (param.GroupType == "All")
                param.GroupType = null;
            try
            {
                System.Collections.Generic.IEnumerable<AssetMapWithEmpDataTableList> data = await _assetMapWithEmpDataTableListRepository.AssetMapWithEmpDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch ?? " ",
                        PGroupType = param.GroupType,
                        PAssetType = param.AssetType,
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

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DMSHelper.ActionITHelpDeskEng)]
        public async Task<IActionResult> AssetMapWithEmpExcelDownload()
        {
            var retVal = await RetriveFilter(ConstFilterAssetMapWithEmpIndex);

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }
            var groupType = filterDataModel.GroupType;

            if (groupType == "All")
                groupType = null;
            else if (groupType == null)
                groupType = "Assets";
            var timeStamp = DateTime.Now.ToFileTime();

            string fileName = "Asset Map With Emp List_" + timeStamp.ToString();
            string reportTitle = "Asset Map With Emp";
            string sheetName = "Asset Map With Emp";

            string assetType = filterDataModel.AssetType == null ? null : String.Join(",", filterDataModel.AssetType);

            IEnumerable<AssetMapWithEmpDataTableList> data = await _assetMapWithEmpDataTableListRepository.AssetMapWithEmpDataTableListForExcelAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PGenericSearch = filterDataModel.GenericSearch ?? " ",
                    PGroupType = groupType,
                    PAssetType = assetType,
                    PEmpno = filterDataModel.Empno
                });

            if (data == null) { return NotFound(); }

            var json = JsonConvert.SerializeObject(data);

            IEnumerable<AssetMapWithEmpDataTableExcel> excelData = JsonConvert.DeserializeObject<IEnumerable<AssetMapWithEmpDataTableExcel>>(json);

            var byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, reportTitle, sheetName);

            var mimeType = MimeTypeMap.GetMimeType("xlsx");

            FileContentResult file = File(byteContent, mimeType, fileName);

            return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DMSHelper.ActionITHelpDeskEng)]
        public async Task<IActionResult> AssetMapWithEmpFilterGet()
        {
            var retVal = await RetriveFilter(ConstFilterAssetMapWithEmpIndex);

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }
            if (string.IsNullOrEmpty(filterDataModel.GroupType))
            {
                filterDataModel.GroupType = "Assets";
            }
            IEnumerable<DataField> itemTypeList = await _selectTcmPLRepository.ItemTypeListForAssetMapping(BaseSpTcmPLGet(), new ParameterSpTcmPL { });
            ViewData["ItemTypeList"] = new SelectList(itemTypeList, "DataValueField", "DataTextField");

            return PartialView("_ModalAssetMapWithEmpFilterSet", filterDataModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DMSHelper.ActionITHelpDeskEng)]
        public async Task<IActionResult> AssetMapWithEmpFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                string jsonFilter;
                jsonFilter = JsonConvert.SerializeObject(
                        new
                        {
                            filterDataModel.GroupType,
                            filterDataModel.AssetType
                        });

                _ = await CreateFilter(jsonFilter, ConstFilterAssetMapWithEmpIndex);

                return Json(new
                {
                    success = true,
                    groupType = filterDataModel.GroupType,
                    assetType = filterDataModel.AssetType
                });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }
        
        #endregion AssetMapWithEmployee
    }
}