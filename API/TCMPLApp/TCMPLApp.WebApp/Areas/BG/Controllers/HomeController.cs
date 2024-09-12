using Microsoft.AspNetCore.Mvc;
using TCMPLApp.WebApp.Controllers;

namespace TCMPLApp.WebApp.Areas.BG.Controllers
{
    [Area("BG")]
    public class HomeController : BaseController
    {
        public HomeController()
        {
        }

        public IActionResult Index()
        {
            return View();
        }
    }
}