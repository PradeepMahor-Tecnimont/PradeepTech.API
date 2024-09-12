using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using TCMPLApp.WebApp.Controllers;
using TCMPLApp.DataAccess.Repositories.OffBoarding;

namespace TCMPLApp.WebApp.Areas.OffBoarding.Controllers
{
    [Area("OffBoarding")]
    public class HomeController : BaseController
    {
        IOffBoardingExitRepository _offBoardingExitRepository;
        public HomeController(IOffBoardingExitRepository offBoardingExitRepository )
        {
            _offBoardingExitRepository = offBoardingExitRepository;
        }
        public IActionResult Index()
        {
            return View();
        }
        public IActionResult OFBIndex()
        {
            return View();
        }
        public async Task< IActionResult> Exits()
        {
            var result = await _offBoardingExitRepository.GetExitsListAsync();
            return View(result);
        }
    }
}
