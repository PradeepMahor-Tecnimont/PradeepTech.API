using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.ProcessQueue;
using TCMPLApp.DataAccess.Repositories.ProcessQueue.View.Interface;
using TCMPLApp.WebApp.Classes;
using TCMPLApp.WebApp.Controllers;


namespace TCMPLApp.WebApp.Areas.ERS.Controllers
{
    [Area("ERS")]

    public class HomeController : BaseController
    {
        private const string ModuleId = "M12";        

        private readonly IConfiguration _configuration;        
        private readonly IProcessQueueDataTableListRepository _processQueueDataTableListRepository;
        private readonly IProcessQueueRepository _processQueueRepository;

        public HomeController(IConfiguration configuration, IProcessQueueDataTableListRepository processQueueDataTableListRepository, IProcessQueueRepository processQueueRepository)
        {
            _configuration = configuration;
            _processQueueDataTableListRepository = processQueueDataTableListRepository;
            _processQueueRepository = processQueueRepository;
        }

        public IActionResult Index()
        {            
            //var task1 = Task.Run(async () =>
            //{
            //    //var result = await _processQueueDataTableListRepository.ProcessQueueDataTableList(
            //    //                    BaseSpTcmPLGet(),
            //    //                    new ParameterSpTcmPL
            //    //                    {
            //    //                        //PEmpno = CurrentUserIdentity.EmpNo,
            //    //                        //PModuleId = ModuleId
            //    //                    });
            //    //if (result.Count() > 0)
            //    //{                    
            //    //    ViewData["statusSharePoint"] = "Processing..."; ;
            //    //}
            //    //else
            //    //{
            //    //    ViewData["statusSharePoint"] = "";
            //    //}

            //    ViewData["statusSharePoint"] = "";
            //});
            
            //await Task.WhenAll(task1);
            ViewData["statusSharePoint"] = "";
            return View();
        }
                
        public async Task<IActionResult> SyncSharePointProcess()
        {
            try
            {
                string parameterJson;
                var settings = new JsonSerializerSettings
                {
                    NullValueHandling = NullValueHandling.Ignore
                };

                parameterJson = JsonConvert.SerializeObject(new HCModel { }, settings);

                var result = await _processQueueRepository.AddProcessQueue(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PModuleId = ModuleId,
                        PProcessId = "ERSSP",
                        PProcessDesc = "ERS - SYNCSHAREPOINT",
                        PParameterJson = parameterJson,
                        PMailTo = "",
                        PMailCc = ""
                    });

                if (result.PMessageType != IsOk)
                {
                    throw new Exception(result.PMessageText.Replace("-", " "));
                }
                else
                {
                    return RedirectToAction("Index", "Home");
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }


        }
    }
}
