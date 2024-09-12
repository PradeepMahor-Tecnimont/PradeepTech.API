using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.Extensions.Configuration;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.Common;
using TCMPLApp.DataAccess.Repositories.Attendance;

using TCMPLApp.Domain.Models.Attendance;
using TCMPLApp.WebApp.Classes;
using TCMPLApp.WebApp.Controllers;
using TCMPLApp.WebApp.Models;
using static TCMPLApp.WebApp.Classes.DTModel;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;

namespace TCMPLApp.WebApp.Areas.SelfService.Controllers
{
    [Authorize]
    [Area("SelfService")]
    public class HSEController : BaseController
    {
        private readonly ISelectTcmPLRepository _selectTcmPLRepository;

        public HSEController(
            ISelectTcmPLRepository selectTcmPLRepository)
        {
            _selectTcmPLRepository = selectTcmPLRepository;
        }

        public IActionResult Index()
        {
            return View();
        }

        public IActionResult HSESuggestionIndex()
        {
            return View();
        }

        public IActionResult HSESuggestionDeskIndex()
        {
            return View();
        }
    }
}