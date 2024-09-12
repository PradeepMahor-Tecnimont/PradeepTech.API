using ClosedXML.Report;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Net;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.SWP;
using TCMPLApp.WebApi.Classes;

namespace TCMPLApp.WebApi.Controllers
{
    [ApiController]
    [Route("[controller]")]
    [Authorize]
    public class SWPProcessesController : BaseController<SWPProcessesController>
    {

        private readonly ISWPAttendanceStatusForDayDataTableListRepository _swpAttendanceStatusForDayDataTableListRepository;
        public SWPProcessesController(ISWPAttendanceStatusForDayDataTableListRepository swpAttendanceStatusForDayDataTableListRepository)
        {
            _swpAttendanceStatusForDayDataTableListRepository = swpAttendanceStatusForDayDataTableListRepository;
        }

        [Route("AttendanceStatusForPrevWorkDate")]
        [HttpGet]
        public async Task<IActionResult> AttendanceStatusForPrevWorkDate()
        {
            var data = await _swpAttendanceStatusForDayDataTableListRepository.SWPAttendanceStatusForPrevWorkDayDataTableListAsync(
                 BaseSpTcmPLGet(),
                 new DataAccess.Models.ParameterSpTcmPL { }
                );

            if (!data.Any())
                return StatusCode((int)HttpStatusCode.InternalServerError, "No data found");


            DateTime startDate = data.FirstOrDefault().DDate;

            string excelFileName = "AttendanceStatusForDayTemplate.xlsx";
            string summarySheetName = "Summary";
            string dataSheetName = "Data";
            string attendanceDataTableName = "AttendanceData";
            string summaryTitle = "Attendance status summary for the day " + startDate.ToString("dd-MMM-yyyy") + " as on " + DateTime.Now.ToString("dd-MMM-yyyy HH:mm");
            string datatTitle = summaryTitle.Replace(" summary", "");

            //var template = new XLTemplate(StorageHelper.GetFilePath(StorageHelper.SWP.RepositoryExcelTemplate, FileName: excelFileName, Configuration));
            var template = new XLTemplate(StorageHelper.GetFilePath(StorageHelper.SWP.SWPRepository, FileName: excelFileName, Configuration));

            string strFileName = string.Empty;
            strFileName = "AttendanceStatusForDay_" + DateTime.Now.ToString("yyyyMMdd_HHmm") + ".xlsx";

            var wb = template.Workbook;

            wb.Table(attendanceDataTableName).ReplaceData(data);

            wb.Table(attendanceDataTableName).SetShowAutoFilter(false);

            wb.Worksheet(dataSheetName).Cell("A1").Value = datatTitle;
            wb.Worksheet(summarySheetName).Cell("B2").Value = summaryTitle;

            byte[] byteContent = null;

            using (MemoryStream ms = new MemoryStream())
            {
                wb.SaveAs(ms);
                byte[] buffer = ms.GetBuffer();
                long length = ms.Length;
                byteContent = ms.ToArray();
            }
            //throw new Exception("This is a test exception");

            return File(byteContent,
                    "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                    strFileName);

        }
    }
}
