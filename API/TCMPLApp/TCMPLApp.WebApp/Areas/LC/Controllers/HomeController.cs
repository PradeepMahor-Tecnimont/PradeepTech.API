using Microsoft.AspNetCore.Mvc;
using TCMPLApp.WebApp.Controllers;

namespace TCMPLApp.WebApp.Areas.LC.Controllers
{
    [Area("LC")]
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