using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MimeTypes;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Net;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.Common;
using TCMPLApp.DataAccess.Repositories.Logbook;
using TCMPLApp.DataAccess.Repositories.SWPVaccine;
using TCMPLApp.Domain.Models.Logbook;
using TCMPLApp.WebApp.Classes;
using TCMPLApp.WebApp.Controllers;
using TCMPLApp.WebApp.Models;
using TCMPLApp.WebApp.Services;

namespace TCMPLApp.WebApp.Areas.Logbook.Controller
{
    [Authorize]
    [Area("Logbook")]
    public class LogbookController : BaseController
    {
        private const string ConstFilterLogbookIndex = "LogbookCommonIndex";

        private readonly ILogbookReportDetailRepository _logbookReportDetailRepository;
        private readonly ILogbookReportRepository _logbookReportRepository;
        private readonly ILogbookDataTableListRepository _logbookDataTableListRepository;
        private readonly IHttpClientRapReporting _httpClientRapReporting;
        private readonly IUtilityRepository _utilityRepository;
        private readonly IFilterRepository _filterRepository;

        public LogbookController(
            ILogbookReportDetailRepository logbookReportDetailRepository,
            ILogbookReportRepository logbookReportRepository,
            IHttpClientRapReporting httpClientRapReporting,
            IUtilityRepository utilityRepository,
            ILogbookDataTableListRepository logbookDataTableListRepository,
            IFilterRepository filterRepository)
        {
            _logbookReportDetailRepository = logbookReportDetailRepository;
            _logbookReportRepository = logbookReportRepository;
            _httpClientRapReporting = httpClientRapReporting;
            _utilityRepository = utilityRepository;
            _logbookDataTableListRepository = logbookDataTableListRepository;
            _filterRepository = filterRepository;
        }
        public async Task<IActionResult> Index()
        {
            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterLogbookIndex
            });

            LogbookViewModel logbookViewModel = new LogbookViewModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                logbookViewModel.FilterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            return View(logbookViewModel);
        }


        public async Task<IActionResult> DownloadLogbookReport(string projno)
        {
            var timeStamp = DateTime.Now.ToFileTime();

            string fileName = "Logbook_" + timeStamp.ToString();
            string reportTitle = "Logbook";
            string sheetName = "Logbook";

            IEnumerable<LogbookDataTableList> data = await _logbookDataTableListRepository.LogbookDataTableListForExcelAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
                PProjno = projno
            });

            if (data == null) { return NotFound(); }

            var json = JsonConvert.SerializeObject(data);

            IEnumerable<LogbookDataTableListExcel> excelData = JsonConvert.DeserializeObject<IEnumerable<LogbookDataTableListExcel>>(json);

            var byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, reportTitle, sheetName);

            var mimeType = MimeTypeMap.GetMimeType("xlsx");

            FileContentResult file = File(byteContent, mimeType, fileName);

            return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
        }

        public async Task<string> CheckReportHit()
        {
            LogbookDetail logbookDetail = new LogbookDetail();

            logbookDetail = await _logbookReportDetailRepository.LogbookDetail(BaseSpTcmPLGet(), new ParameterSpTcmPL { });

            if (logbookDetail.KeyId != null)
            {
                return logbookDetail.KeyId;
            }
            else
            {
                return null;
            }
        }

        public async Task<IActionResult> GetReport()
        {
            LogbookDetail logbookDetail = new LogbookDetail();

            try
            {
                logbookDetail = await _logbookReportDetailRepository.LogbookDetail(BaseSpTcmPLGet(), new ParameterSpTcmPL { });

                if (logbookDetail.KeyId != null)
                {
                    HCModel hCModel;
                    hCModel = JsonConvert.DeserializeObject<HCModel>(logbookDetail.ReportParameter);

                    var result = await _logbookReportRepository.DeleteLogbookReportEntry(BaseSpTcmPLGet(), new ParameterSpTcmPL
                    {
                        PKeyId = logbookDetail.KeyId
                    });

                    if (result.PMessageType != "OK")
                    {
                        throw new Exception(result.PMessageText.Replace("-", " "));
                    }
                    else
                    {
                        return RedirectToAction(logbookDetail.ReportUrl, new { projno = hCModel.Projno, costcode = hCModel.CostCode });
                    }
                }
                else
                {
                    return Ok(logbookDetail);
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
        }
    }
}