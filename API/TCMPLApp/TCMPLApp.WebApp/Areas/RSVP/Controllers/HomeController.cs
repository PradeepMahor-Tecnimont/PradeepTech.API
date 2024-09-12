using ClosedXML.Excel;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using System;
using System.Data;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories;
using TCMPLApp.Domain.Models.Common;
using TCMPLApp.Library.Excel.Template;
using TCMPLApp.WebApp.Classes;
using TCMPLApp.WebApp.Controllers;
using TCMPLApp.WebApp.Models;

namespace TCMPLApp.WebApp.Areas.RSVP.Controllers
{
    [Area("RSVP")]

    public class HomeController : BaseController
    {
        private const string ModuleId = "M15";         

        private readonly IConfiguration _configuration;
        private readonly IRSVPRepository _rsvpRepository;
        private readonly IRSVPViewRepository _rsvpViewRepository;
        private readonly INavratriRSVPDetailRepository _navratriRSVPDetailRepository;
        private readonly IExcelTemplate _excelTemplate;

        public HomeController(IConfiguration configuration, 
                              IRSVPRepository rsvpRepository,
                              IRSVPViewRepository rsvpViewRepository,
                              INavratriRSVPDetailRepository navratriRSVPDetailRepository,
                              IExcelTemplate excelTemplate)
        {
            _configuration = configuration;
            _rsvpRepository = rsvpRepository;
            _rsvpViewRepository = rsvpViewRepository;
            _navratriRSVPDetailRepository = navratriRSVPDetailRepository;
            _excelTemplate = excelTemplate;
        }

        public async Task<IActionResult> Index()
        {
            NavratriRSVPCreateViewModel navratriRSVPCreateViewModel = new();


            var result = await _navratriRSVPDetailRepository.NavratriRSVPDetail(BaseSpTcmPLGet(), null );

            navratriRSVPCreateViewModel.Attend = result.PAttend;
            navratriRSVPCreateViewModel.Bus = result.PBus;
            navratriRSVPCreateViewModel.Dinner = result.PDinner;
            navratriRSVPCreateViewModel.Counter = result.PCounter;

            if (result.PMessageType != "OK")
            {
                Notify("Error", result.PMessageText.Replace("-", " "), "toaster", NotificationType.error);
            }           

            return View(navratriRSVPCreateViewModel);

        }

        [HttpPost]
        public async Task<IActionResult> RecordNavratriResponse([FromForm] NavratriRSVPCreateViewModel navratriRSVPCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _rsvpRepository.NavratriRSVPCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {                            
                            PAttend = navratriRSVPCreateViewModel.Attend,
                            PBus = navratriRSVPCreateViewModel.Bus,
                            PDinner = navratriRSVPCreateViewModel.Dinner
                        });

                    if (result.PMessageType != "OK")
                    {
                        Notify("Error", result.PMessageText.Replace("-", " "), "toaster", NotificationType.error);
                    }
                    //else
                    //{
                    //    Notify("Success", result.PMessageText.Replace("-", " "), "toaster", NotificationType.success);                        
                    //}
                }
            }
            catch (Exception ex)
            {                
                Notify("Error", StringHelper.CleanExceptionMessage(ex.Message).Replace("-", " "), "toaster", NotificationType.error);
            }

            return RedirectToAction("Index");
        }

        
        #region >>>>>>>>>>> Navratri Excel Download <<<<<<<<<<<<<<

        public async Task<IActionResult> NavratriExcelDownload()
        {
            try
            {
                DataTable dt = new DataTable();
                string strUser = User.Identity.Name;
                var result = await _rsvpViewRepository.GetNavratriRSVPExcelListAsync(
                        BaseSpTcmPLGet(), 
                        null
                    );

                if (result == null)
                {
                    return NotFound();
                }

                ListtoDataTableConverter converter = new ListtoDataTableConverter();
                dt = converter.ToDataTable(result.ToList());
                var timeStamp = DateTime.Now.ToFileTime();
                string StrFimeName = "NavratriExcelDownload_" + timeStamp.ToString();
                using (XLWorkbook wb = new XLWorkbook())
                {
                    wb.Worksheets.Add(dt);
                    using (MemoryStream stream = new MemoryStream())
                    {
                        wb.SaveAs(stream);
                        stream.Position = 0;
                        return File(stream.ToArray(),
                                   "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                                   StrFimeName + ".xlsx");
                    }
                }

                //Notify("Success", "Download successful...", "toaster", NotificationType.success);
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message, "toaster", notificationType: NotificationType.error);
            }
            return RedirectToAction("Index");
        }

        #endregion >>>>>>>>>>> Excel Download <<<<<<<<<<<<<<
    }
}
