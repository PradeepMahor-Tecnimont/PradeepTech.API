using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.AspNetCore.Mvc.Rendering;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Repositories.Common;
using TCMPLApp.DataAccess.Repositories.HRMasters;
using TCMPLApp.WebApp.Areas.HRMasters.Models;
using TCMPLApp.WebApp.Controllers;
using System.Collections.Generic;
using TCMPLApp.WebApp.CustomPolicyProvider;
using TCMPLApp.WebApp.Models;
using TCMPLApp.Domain.Models.HRMasters;
using System;
using static TCMPLApp.WebApp.Classes.DTModel;
using System.Linq;
using Microsoft.EntityFrameworkCore;

namespace TCMPLApp.WebApp.Areas.HRMasters.Controllers
{
    [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, HRMastersHelper.RoleAttendanceAdmin)]
    [Area("HRMasters")]
    public class HolidayController : BaseController
    {
        private readonly IConfiguration _configuration;
        private readonly IHolidayMasterRepository _holidaymasterRepository;
        private readonly IHolidayMasterViewRepository _holidaymasterViewRepository;
        private readonly ISelectRepository _selectRepository;

        public HolidayController(IHolidayMasterRepository holidaymasterRepository,
                                 IHolidayMasterViewRepository holidaymasterViewRepository,
                                  ISelectRepository selectRepository,
                                  IConfiguration configuration)
        {
            _configuration = configuration;
            _holidaymasterRepository = holidaymasterRepository;
            _holidaymasterViewRepository = holidaymasterViewRepository;
            _selectRepository = selectRepository;
        }

        public IActionResult Index()
        {
            //var result = await _holidaymasterViewRepository.GetHolidayMasterListAsync();
            //return View(result);
            return View();
        }

        [HttpGet]       
        public async Task<IActionResult> Detail(string id)
        {
            if (id == null)
                return NotFound();

            var holidayDetail = await _holidaymasterViewRepository.HolidayDetail(int.Parse(id));

            if (holidayDetail == null)
            {
                return NotFound();
            }

            return View(holidayDetail);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetLists(string paramJson)
        {
            DTResult<HolidayMaster> result = new DTResult<HolidayMaster>();

            var param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            var data = (await _holidaymasterViewRepository.GetHolidayMasterListAsync()).ToList().AsQueryable();

            // Filtering
            if (!string.IsNullOrEmpty(param.GenericSearch))
            {
                data = data
                        .Where(
                        t => t.YYYYMM.Trim().ToLower().Contains(param.GenericSearch.Trim().ToLower(), StringComparison.InvariantCultureIgnoreCase)
                            | t.Weekday.Trim().ToLower().Contains(param.GenericSearch.Trim().ToLower(), StringComparison.InvariantCultureIgnoreCase)
                            | (!string.IsNullOrWhiteSpace(t.Description) && t.Description.Trim().ToLower().Contains(param.GenericSearch.Trim().ToLower(), StringComparison.InvariantCultureIgnoreCase))
                         );
            }

            result.draw = param.Draw;
            result.recordsTotal = data.Count();
            result.recordsFiltered = data.Count();
            result.data = data.Skip(param.Start).Take(param.Length).AsNoTracking().ToList();

            return Json(result);
        }

        public IActionResult Create()
        {   
            HolidayCreateViewModel holidayCreateViewModel = new HolidayCreateViewModel();

            return PartialView("_ModalHolidayCreatePartial", holidayCreateViewModel);
        }

        [HttpPost]        
        public async Task<IActionResult> Create([FromForm] HolidayCreateViewModel holidayCreateViewModel)
        {           
            try
            {
                if (ModelState.IsValid)
                {
                    HolidayMasterAdd holidayMasterAdd = new HolidayMasterAdd
                    {
                        PHoliday = (DateTime)holidayCreateViewModel.Holiday,
                        PDescription = holidayCreateViewModel.Description
                    };

                    var retVal = await _holidaymasterRepository.AddHoliday(holidayMasterAdd);

                    if (retVal.OutPSuccess == "OK")
                    {
                        Notify("Success", retVal.OutPMessage, "toaster", NotificationType.success);
                    }
                    else
                    {
                        Notify("Error", retVal.OutPMessage, "toaster", NotificationType.error);                        
                    }
                }
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
                return PartialView("_ModalHolidayCreatePartial", holidayCreateViewModel);
            }

            return Json(new { });
            //return RedirectToAction(actionName: nameof(Index));
        }

        [HttpGet]             
        public async Task<IActionResult> Edit(string id)
        {
            if (id == null)
                return NotFound();

            var model = new HolidayUpdateViewModel();

            var holidayDetail = await _holidaymasterViewRepository.HolidayDetail(int.Parse(id));

            if (holidayDetail == null)
            {
                return NotFound();
            }

            model.Srno = holidayDetail.Srno;
            model.Holiday = holidayDetail.Holiday;
            model.Description = holidayDetail.Description;

            return PartialView("_ModalHolidayUpdatePartial", model);
        }

        [HttpPost]        
        public async Task<IActionResult> Edit([FromForm] HolidayUpdateViewModel holidayUpdateViewModel)
        {
            var model = new HolidayUpdateViewModel();

            try
            {                
                var holidayDetail = await _holidaymasterViewRepository.HolidayDetail(holidayUpdateViewModel.Srno);

                model.Srno = holidayDetail.Srno;
                model.Holiday = holidayDetail.Holiday;
                model.Description = holidayDetail.Description;

                if (ModelState.IsValid)
                {
                    HolidayMasterUpdate holidayMasterUpdate = new HolidayMasterUpdate
                    {
                        PSrno = holidayUpdateViewModel.Srno,
                        PHoliday = holidayUpdateViewModel.Holiday,
                        PDescription = holidayUpdateViewModel.Description
                    };

                    var retVal = await _holidaymasterRepository.UpdateHoliday(holidayMasterUpdate);

                    if (retVal.OutPSuccess == "OK")
                    {
                        Notify("Success", retVal.OutPMessage, "toaster", NotificationType.success);
                    }
                    else
                    {
                        Notify("Error", retVal.OutPMessage, "toaster", NotificationType.error);
                    }
                }
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
                return PartialView("_ModalHolidayUpdatePartial", model);
            }

            return Json(new { });
            //return RedirectToAction(actionName: nameof(Index));
        }

        [HttpPost]        
        public async Task<IActionResult> DeleteHoliday(string id)
        {
            if (id == null)
                return NotFound();

            try
            {
                var holidayDelete = new HolidayDelete();

                holidayDelete.PSrno = int.Parse(id);

                var retVal = await _holidaymasterRepository.DeleteHoliday(holidayDelete);

                return Json(new { Success = retVal.OutPSuccess == "OK", Message = retVal.OutPMessage });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = ex.Message });
            }
        }

        [HttpPost]
        public async Task<IActionResult> PopulateWeekendHoliday(string id)
        {
            if (id == null)
                return NotFound();

            try
            {
                var weekendHoliday = new WeekendHoliday();

                weekendHoliday.PYyyy = id;

                var retVal = await _holidaymasterRepository.PopulateWeekendHoliday(weekendHoliday);

                return Json(new { Success = retVal.OutPSuccess == "OK", Message = retVal.OutPMessage });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = ex.Message });
            }
        }
    }
}
