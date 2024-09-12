using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using TCMPLApp.WebApp.Controllers;


namespace TCMPLApp.WebApp.Areas.DigiForm.Controllers
{
    [Area("DigiForm")]

    public class HomeController : BaseController
    {
        private const string ModuleId = "M19";

        private readonly IConfiguration _configuration;

        public HomeController(IConfiguration configuration)
        {
            _configuration = configuration;
            
        }

        public IActionResult Index()
        { 
            return View();
        }         

    }
}
