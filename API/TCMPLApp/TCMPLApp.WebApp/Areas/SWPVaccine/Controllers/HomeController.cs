using Microsoft.AspNetCore.Mvc;
using TCMPLApp.WebApp.Controllers;

namespace TCMPLApp.WebApp.Areas.SWPVaccine.Controllers
{
    [Area("SWPVaccine")]
    public class HomeController : BaseController
    {
        public IActionResult Index()
        {
            return View();
        }
    }
}
