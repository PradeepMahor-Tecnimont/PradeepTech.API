using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Repositories.SWPVaccine;
using TCMPLApp.DataAccess.Repositories.Common;
using TCMPLApp.Models;
using TCMPLApp.WebApp.Controllers;
using TCMPLApp.Domain.Models;
using TCMPLApp.DataAccess.Models;

namespace TCMPLApp.Controllers
{
    [Authorize]
    public class HomeController : BaseController
    {
        private readonly ILogger<HomeController> _logger;
        
        IEmployeePolicyRepository _employeePolicyRepository;
        IDmsUser _dmsUser;
        IEmployeeDetailsRepository _employeeDetailsRepository;
        ICommonEmployeeDetailsRepository _commonEmployeeDetailsRepository;
        public HomeController(ILogger<HomeController> logger, IEmployeePolicyRepository employeePolicyRepository, IDmsUser dmsUser, IEmployeeDetailsRepository employeeDetailsRepository, ICommonEmployeeDetailsRepository commonEmployeeDetailsRepository)
        {
            _logger = logger;
            _employeePolicyRepository = employeePolicyRepository;
            _employeeDetailsRepository = employeeDetailsRepository;
            _dmsUser = dmsUser;
            _commonEmployeeDetailsRepository = commonEmployeeDetailsRepository;
        }

        public async Task< IActionResult > Index()
        {
            //return  RedirectToAction("Create", "EmployeePolicy");
            //return RedirectToAction("Index", "VaccinationSelf");
            string empno = CurrentUserIdentity.EmpNo;
            var retVal = await _dmsUser.CheckUserAccess(new DmsUserCheck { PEmpno = empno });
            ViewData["IsDMSUser"] = retVal.OutReturnValue == "OK";

            //var empDetail = await _employeeDetailsRepository.GetEmployeeDetailsAsync(empno);
            var empDetail = await _commonEmployeeDetailsRepository.EmployeeDetailAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PEmpno = empno
                });
            if (empDetail.PEmpType.ToString() == "R" || empDetail.PEmpType.ToString() == "F")
            {
                ViewData["IsHealthUser"] = true;
            } else
            {
                ViewData["IsHealthUser"] = false;
            }            
            return View();
        }

        public IActionResult Privacy()
        {
            return View();
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }

        public IActionResult ErrorIE()
        {
            return View();
        }

        public IActionResult SWPEmployeeWorkspaceDetails()
        {
            return ViewComponent("SWPEmployeeWorkspaceDetails", new { 
                Empno = CurrentUserIdentity.EmpNo,
                baseSpTcmPL = BaseSpTcmPLGet(),
                userIdentity = CurrentUserIdentity,
            });
        }
    }
}
