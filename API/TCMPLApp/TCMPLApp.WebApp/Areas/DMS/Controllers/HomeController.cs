using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Repositories.Attendance;
using TCMPLApp.Domain.Models.SelfService;
using TCMPLApp.WebApp.Controllers;
using TCMPLApp.WebApp.CustomPolicyProvider;

namespace TCMPLApp.WebApp.Areas.DMS.Controllers
{
    [Area("DMS")]
    public class HomeController : BaseController
    {
        public IActionResult Index()
        {
            return View();
        }
        public IActionResult ReportIndex()
        {
            return View();
        }
    }
}
