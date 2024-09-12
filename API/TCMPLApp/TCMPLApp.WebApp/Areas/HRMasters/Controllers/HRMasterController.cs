using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using MimeTypes;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.Common;
using TCMPLApp.DataAccess.Repositories.HRMasters;
using TCMPLApp.DataAccess.Repositories.SWPVaccine;
using TCMPLApp.Domain.Models.HRMasters;
using TCMPLApp.WebApp.Classes;
using TCMPLApp.WebApp.Controllers;
using TCMPLApp.WebApp.Models;
using static TCMPLApp.WebApp.Classes.DTModel;

namespace TCMPLApp.WebApp.Areas.HRMasters.Controllers
{
    [Area("HRMasters")]
    public class HRMasterController : BaseController
    {
        private const string ConstFilterRegionIndex = "RegionsIndex";
        private const string ConstFilterHolidaysIndex = "RegionHolidaysIndex";

        private readonly IFilterRepository _filterRepository;
        private readonly ISelectTcmPLRepository _selectTcmPLRepository;
        private readonly IUtilityRepository _utilityRepository;
        private readonly IRegionDataTableListRepository _regionDataTableListRepository;
        private readonly IRegionRepository _regionRepository;
        private readonly IRegionDetailRepository _regionDetailRepository;
        private readonly IRegionHolidaysDataTableListRepository _holidaysDataTableListRepository;
        private readonly IRegionHolidaysRepository _holidaysRepository;
        private readonly IRegionHolidaysDetailRepository _holidayDetailRepository;

        public HRMasterController(IFilterRepository filterRepository,
            ISelectTcmPLRepository selectTcmPLRepository,
            IUtilityRepository utilityRepository,
            IRegionDataTableListRepository regionDataTableListRepository,
            IRegionRepository regionRepository,
            IRegionDetailRepository regionDetailRepository,
            IRegionHolidaysDataTableListRepository holidaysDataTableListRepository,
            IRegionHolidaysRepository holidaysRepository,
            IRegionHolidaysDetailRepository holidayDetailRepository)
        {
            _filterRepository = filterRepository;
            _selectTcmPLRepository = selectTcmPLRepository;
            _utilityRepository = utilityRepository;
            _regionDataTableListRepository = regionDataTableListRepository;
            _regionRepository = regionRepository;
            _regionDetailRepository = regionDetailRepository;
            _holidaysDataTableListRepository = holidaysDataTableListRepository;
            _holidaysRepository = holidaysRepository;
            _holidayDetailRepository = holidayDetailRepository;
        }

        #region Region Master

        public async Task<IActionResult> RegionsIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterRegionIndex
            });

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            RegionViewModel regionViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(regionViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListRegions(string paramJson)
        {
            DTResult<RegionDataTableList> result = new();
            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            int totalRow = 0;

            try
            {
                System.Collections.Generic.IEnumerable<RegionDataTableList> data = await _regionDataTableListRepository.RegionDataTableListAsync(
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
        public IActionResult RegionCreate()
        {
            RegionCreateViewModel regionCreateViewModel = new();

            return PartialView("_ModalRegionCreatePartial", regionCreateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> RegionCreate([FromForm] RegionCreateViewModel regionCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _regionRepository.RegionCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PRegionName = regionCreateViewModel.RegionName
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

            return PartialView("_ModalRegionCreatePartial", regionCreateViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> RegionDelete(string id)
        {
            try
            {
                Domain.Models.Common.DBProcMessageOutput result = await _regionRepository.RegionDeleteAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRegionCode = id
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
        public async Task<IActionResult> RegionDetail(string id)
        {
            try
            {
                if (string.IsNullOrEmpty(id))
                {
                    return NotFound();
                }

                RegionDetails result = await _regionDetailRepository.RegionDetail(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRegionCode = id
                    });

                RegionDetailViewModel regionDetailViewModel = new();

                if (result.PMessageType == IsOk)
                {
                    regionDetailViewModel.RegionCode = id;
                    regionDetailViewModel.RegionName = result.PRegionName;
                    regionDetailViewModel.ModifiedOn = result.PModifiedOn;
                    regionDetailViewModel.ModifiedBy = result.PModifiedBy;
                }

                return PartialView("_ModalRegionDetails", regionDetailViewModel);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        #endregion Region Master

        #region Holidays

        public async Task<IActionResult> RegionHolidaysIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterHolidaysIndex
            });

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            HolidaysViewModel holidaysViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(holidaysViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListRegionHolidays(string paramJson)
        {
            DTResult<RegionHolidaysDataTableList> result = new();
            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            int totalRow = 0;

            try
            {
                System.Collections.Generic.IEnumerable<RegionHolidaysDataTableList> data = await _holidaysDataTableListRepository.HolidaysDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch ?? " ",
                        PRegionCode = param.RegionCode,
                        PYyyy = param.Year,
                        PShowSatSun = param.IsYes.GetValueOrDefault() ? IsOk : NotOk,
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
        public async Task<IActionResult> HolidaysCreate()
        {
            HolidaysCreateViewModel holidaysCreateViewModel = new();

            IEnumerable<DataField> regionList = await _selectTcmPLRepository.RegionsList(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            ViewData["RegionList"] = new SelectList(regionList, "DataValueField", "DataTextField");

            return PartialView("_ModalHolidaysCreatePartial", holidaysCreateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> HolidaysCreate([FromForm] HolidaysCreateViewModel holidaysCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _holidaysRepository.HolidayCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PHoliday = holidaysCreateViewModel.Holiday,
                            PRegionCode = holidaysCreateViewModel.RegionCode,
                            PYyyymm = holidaysCreateViewModel.Yyyymm,
                            PWeekday = holidaysCreateViewModel.Weekday,
                            PDescription = holidaysCreateViewModel.Description
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

            return PartialView("_ModalHolidaysCreatePartial", holidaysCreateViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> HolidaysDelete(string id, DateTime? holiday)
        {
            try
            {
                Domain.Models.Common.DBProcMessageOutput result = await _holidaysRepository.HolidayDeleteAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRegionCode = id,
                        PHoliday = holiday
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
        public async Task<IActionResult> HolidaysDetail(string id, DateTime? holiday)
        {
            try
            {
                if (string.IsNullOrEmpty(id))
                {
                    return NotFound();
                }

                HolidayDetails result = await _holidayDetailRepository.HolidayDetail(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRegionCode = id,
                        PHoliday = holiday
                    });

                HolidayDetailViewModel holidayDetailViewModel = new();

                if (result.PMessageType == IsOk)
                {
                    holidayDetailViewModel.RegionCode = id;
                    holidayDetailViewModel.Holiday = holiday;
                    holidayDetailViewModel.RegionName = result.PRegionName;
                    holidayDetailViewModel.Yyyymm = result.PYyyymm;
                    holidayDetailViewModel.Weekday = result.PWeekday;
                    holidayDetailViewModel.Description = result.PDescription;
                }

                return PartialView("_ModalHolidayDetails", holidayDetailViewModel);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        public async Task<IActionResult> HolidaysExcelDownload()
        {
            var timeStamp = DateTime.Now.ToFileTime();

            string fileName = "Holidays_" + timeStamp.ToString();
            string reportTitle = "Holidays";
            string sheetName = "Holidays";

            IEnumerable<RegionHolidaysDataTableList> data = await _holidaysDataTableListRepository.HolidaysXLDataTableListForExcelAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                });

            if (data == null) { return NotFound(); }

            var json = JsonConvert.SerializeObject(data);

            IEnumerable<HolidaysDataTableListExcel> excelData = JsonConvert.DeserializeObject<IEnumerable<HolidaysDataTableListExcel>>(json);

            var byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, reportTitle, sheetName);

            var mimeType = MimeTypeMap.GetMimeType("xlsx");

            FileContentResult file = File(byteContent, mimeType, fileName);

            return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
        }

        #endregion Holidays

        #region Filters

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

        public async Task<IActionResult> HolidaysFilterGet()
        {
            Domain.Models.FilterRetrieve retVal = await RetriveFilter(ConstFilterHolidaysIndex);

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }


            IEnumerable<DataField> regionList = await _selectTcmPLRepository.RegionsList(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            ViewData["RegionList"] = new SelectList(regionList, "DataValueField", "DataTextField");

            return PartialView("_ModalHolidaysFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> HolidaysFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                string jsonFilter;
                jsonFilter = JsonConvert.SerializeObject(
                        new
                        {
                            filterDataModel.RegionCode,
                            filterDataModel.Year,
                            filterDataModel.IsYes
                        });

                Domain.Models.FilterCreate retVal = await CreateFilter(jsonFilter, ConstFilterHolidaysIndex);

                return Json(ResponseHelper.GetMessageObject("No message", NotificationType.success));
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        #endregion Filters
    }
}