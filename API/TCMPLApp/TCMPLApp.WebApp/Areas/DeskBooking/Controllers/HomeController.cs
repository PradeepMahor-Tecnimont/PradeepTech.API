using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using System;
using System.Linq;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.DeskBooking;
using TCMPLApp.Domain.Models.DeskBooking;
using TCMPLApp.WebApp.Controllers;
using TCMPLApp.WebApp.CustomPolicyProvider;
using TCMPLApp.WebApp.Models;
using static TCMPLApp.WebApp.Classes.DTModel;

namespace TCMPLApp.WebApp.Areas.DeskBooking.Controllers
{
    [Authorize]
    [Area("DeskBooking")]
    public class HomeController : BaseController
    {
        private readonly IDeskBookingDataTableListRepository _deskBookingDataTableListRepository;
        private readonly IDeskBookingRepository _deskBookingRepository;

        public HomeController(IDeskBookingDataTableListRepository deskBookingDataTableListRepository,
            IDeskBookingRepository deskBookingRepository)
        {
            _deskBookingDataTableListRepository = deskBookingDataTableListRepository;
            _deskBookingRepository = deskBookingRepository;
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionDeskBookUser)]
        public async Task<IActionResult> Index()
        {
            
            DeskBookingIndexViewModel deskBookingIndexViewModel = new DeskBookingIndexViewModel();

            if (CurrentUserIdentity.ProfileActions.Any(pa => pa.ActionId == DeskBookingHelper.ActionDeskBookingCreate))
            {
                var data = await _deskBookingDataTableListRepository.DeskBookingDataTableList(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PRowNumber = 0,
                            PPageLength = 10,
                        }
                    );

                deskBookingIndexViewModel.deskBookingDataTableLists = data;
            }
            return View(deskBookingIndexViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DeskBookingHelper.ActionDeskBookingCreate)]
        public async Task<IActionResult> ReleaseDesk(string id)
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
    }
}