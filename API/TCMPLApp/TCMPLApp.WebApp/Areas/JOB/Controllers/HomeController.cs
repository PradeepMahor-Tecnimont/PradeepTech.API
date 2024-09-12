using Microsoft.AspNetCore.Mvc;
using TCMPLApp.WebApp.Controllers;

namespace TCMPLApp.WebApp.Areas.JOB.Controllers
{
    [Area("JOB")]
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
