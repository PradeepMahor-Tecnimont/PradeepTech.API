using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.AspNetCore.Mvc.Rendering;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Repositories.Common;
using TCMPLApp.DataAccess.Repositories.HRMasters;
using TCMPLApp.WebApp.Areas.HRMasters.Models;
using TCMPLApp.WebApp.Controllers;
using System.Collections.Generic;
using TCMPLApp.WebApp.CustomPolicyProvider;
using TCMPLApp.WebApp.Models;
using TCMPLApp.Domain.Models.HRMasters;
using System;
using static TCMPLApp.WebApp.Classes.DTModel;
using System.Linq;
using Microsoft.EntityFrameworkCore;
using TCMPLApp.DataAccess.Models;
using System.Data;
using TCMPLApp.Domain.Models.Common;
using ClosedXML.Excel;
using System.IO;
using System.Net;
using TCMPLApp.WebApp.Classes;
using Newtonsoft.Json;
using ClosedXML.Report;
using TCMPLApp.WebApp.Services;
using System.Net.Http;
using MimeTypes;

namespace TCMPLApp.WebApp.Areas.HRMasters.Controllers
{
    [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, HRMastersHelper.RoleAttendanceAdmin)]
    [Area("HRMasters")]
    public class ReportsController : BaseController
    {
        private static readonly string _uriMonthlyConsolidated = "api/rap/hrmasters/GetMonthlyConsolidated";
        private static readonly string _uriMonthlyConsolidatedEngg = "api/rap/hrmasters/GetMonthlyConsolidatedEngg";
        private static readonly string _uriMonthlyOutsourceEmployee = "api/rap/hrmasters/GetMonthlyOutsourceEmployee";

        private readonly IConfiguration _configuration;
        private readonly IHRMastersReportsViewRepository _hrmastersReportsViewRepository;
        private readonly IHRMastersQueryReportsViewRepository _hrmastersQueryReportsViewRepository;
        private readonly ISelectRepository _selectRepository;
        private readonly IHttpClientRapReporting _httpClientRapReporting;

        public ReportsController(IHRMastersReportsViewRepository hrmastersReportsViewRepository,
                                 IHRMastersQueryReportsViewRepository hrmastersQueryReportsViewRepository,
                                 ISelectRepository selectRepository,
                                 IConfiguration configuration,
                                 IHttpClientRapReporting httpClientRapReporting)
        {
            _configuration = configuration;
            _hrmastersReportsViewRepository = hrmastersReportsViewRepository;
            _hrmastersQueryReportsViewRepository = hrmastersQueryReportsViewRepository;
            _selectRepository = selectRepository;
            _httpClientRapReporting = httpClientRapReporting;
        }

        [HttpGet]
        public IActionResult GetParentwiseSubcontractReport()
        {
            return PartialView("_ParentwiseSubcontractReportPartial");
        }

        [HttpGet]
        public async Task<IActionResult> GetEmployeewiseReporting()
        {
            try
            {                
                DataTable dt = new DataTable();
                string strUser = User.Identity.Name;
                var result = (await _hrmastersQueryReportsViewRepository.EmployeewiseReportingListAsync()).ToList();

                if (result == null)
                {
                    return NotFound();
                }

                ListtoDataTableConverter converter = new ListtoDataTableConverter();
                dt = converter.ToDataTable(result);
                var timeStamp = DateTime.Now.ToFileTime();
                string StrFimeName = "EmployeeReporting_" + timeStamp.ToString();
                using (XLWorkbook wb = new XLWorkbook())
                {
                    wb.Worksheets.Add(dt);
                    using (MemoryStream stream = new MemoryStream())
                    {
                        wb.SaveAs(stream);
                        stream.Position = 0;
                        
                        var mimeType = MimeTypeMap.GetMimeType("xlsx");

                        FileContentResult file = File(stream.ToArray(), mimeType, StrFimeName);

                        return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
                    }
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        [HttpGet]
        public async Task<IActionResult> GetEmployeeResigned(string startDate, string endDate)
        {            
            if (startDate == null || endDate == null)
            {
                return NotFound();
            }

            try
            {
                DataTable dt = new DataTable();
                
                DataTable dtcostcode = new DataTable();
                DataTable dtmonth = new DataTable();
                string strUser = User.Identity.Name;
                var result = (await _hrmastersQueryReportsViewRepository.EmployeeResignedListAsync(DateTime.Parse(startDate), DateTime.Parse(endDate))).ToList();
                var resultcostcode = (await _hrmastersQueryReportsViewRepository.EmployeeResignedCostcodeListAsync(DateTime.Parse(startDate), DateTime.Parse(endDate))).ToList();
                var resultmonth = (await _hrmastersQueryReportsViewRepository.EmployeeResignedMonthListAsync(DateTime.Parse(startDate), DateTime.Parse(endDate))).ToList();

                if (result == null || resultcostcode == null || resultmonth == null)
                {
                    return NotFound();
                }
               
                var timeStamp = DateTime.Now.ToFileTime();
                string StrFimeName = "EmployeeResigned_" + timeStamp.ToString();
                using (XLWorkbook wb = new XLWorkbook())
                {
                    var sheet1 = wb.Worksheets.Add("Resigned List");
                    sheet1.Cell(1, 1).InsertTable(result);

                    var sheet2 = wb.Worksheets.Add("Costcodewise Resigned List");
                    sheet2.Cell(1, 1).InsertTable(resultcostcode);

                    var sheet3 = wb.Worksheets.Add("Monthwise Resigned List");
                    sheet3.Cell(1, 1).InsertTable(resultmonth);

                    using (MemoryStream stream = new MemoryStream())
                    {
                        wb.SaveAs(stream);
                        stream.Position = 0;
                        return File(stream.ToArray(),
                                   "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                                   StrFimeName + ".xlsx");
                    }
                }
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message, "toaster", notificationType: NotificationType.error);
            }
            return Redirect("~/HRMasters/Home/ReportIndex");
        }

        [HttpGet]
        public async Task<IActionResult> GetEmployeeJoined(string startDate, string endDate)
        {
            FilterDataModel filterDataModel = new FilterDataModel();

            try
            {
                DataTable dt = new DataTable();
                
                DataTable dtcostcode = new DataTable();
                DataTable dtmonth = new DataTable();
                string strUser = User.Identity.Name;
                var result = (await _hrmastersQueryReportsViewRepository.EmployeeJoinedListAsync(DateTime.Parse(startDate), DateTime.Parse(endDate))).ToList();
                var resultcostcode = (await _hrmastersQueryReportsViewRepository.EmployeeJoinedCostcodeListAsync(DateTime.Parse(startDate), DateTime.Parse(endDate))).ToList();
                var resultmonth = (await _hrmastersQueryReportsViewRepository.EmployeeJoinedMonthListAsync(DateTime.Parse(startDate), DateTime.Parse(endDate))).ToList();

                if (result == null || resultcostcode == null || resultmonth == null)
                {
                    return NotFound();
                }
                
                var timeStamp = DateTime.Now.ToFileTime();
                string StrFimeName = "EmployeeJoined_" + timeStamp.ToString();
                using (XLWorkbook wb = new XLWorkbook())
                {
                    var sheet1 = wb.Worksheets.Add("Joined List");
                    sheet1.Cell(1, 1).InsertTable(result);

                    var sheet2 = wb.Worksheets.Add("Costcodewise Joined List");
                    sheet2.Cell(1, 1).InsertTable(resultcostcode);

                    var sheet3 = wb.Worksheets.Add("Monthwise Joined List");
                    sheet3.Cell(1, 1).InsertTable(resultmonth);

                    using (MemoryStream stream = new MemoryStream())
                    {
                        wb.SaveAs(stream);
                        stream.Position = 0;
                        return File(stream.ToArray(),
                                   "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                                   StrFimeName + ".xlsx");
                    }
                }
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message, "toaster", notificationType: NotificationType.error);
            }
            return Redirect("~/HRMasters/Home/ReportIndex");
        }

        [HttpGet]
        public async Task<IActionResult> GetCostcodewiseemployeeCount()
        {
            try
            {
                DataTable dt = new DataTable();
                string strUser = User.Identity.Name;
                var result = (await _hrmastersQueryReportsViewRepository.CostcodewiseEmployeeCountListAsync()).ToList();

                if (result == null)
                {
                    return NotFound();
                }

                ListtoDataTableConverter converter = new ListtoDataTableConverter();
                dt = converter.ToDataTable(result);
                var timeStamp = DateTime.Now.ToFileTime();
                string StrFimeName = "CostcodewiseEmployeeCount_" + timeStamp.ToString();
                using (XLWorkbook wb = new XLWorkbook())
                {
                    wb.Worksheets.Add(dt);
                    using (MemoryStream stream = new MemoryStream())
                    {
                        wb.SaveAs(stream);
                        stream.Position = 0;
                        
                        var mimeType = MimeTypeMap.GetMimeType("xlsx");

                        FileContentResult file = File(stream.ToArray(), mimeType, StrFimeName);

                        return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
                    }
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        [HttpGet]
        public async Task<IActionResult> GetCategorywiseemployeeCount()
        {
            try
            {
                DataTable dt = new DataTable();
                string strUser = User.Identity.Name;
                var result = (await _hrmastersQueryReportsViewRepository.CategorywiseEmployeeCountListAsync()).ToList();

                if (result == null)
                {
                    return NotFound();
                }

                ListtoDataTableConverter converter = new ListtoDataTableConverter();
                dt = converter.ToDataTable(result);
                var timeStamp = DateTime.Now.ToFileTime();
                string StrFimeName = "CategorywiseEmployeeCount_" + timeStamp.ToString();
                using (XLWorkbook wb = new XLWorkbook())
                {
                    wb.Worksheets.Add(dt);
                    using (MemoryStream stream = new MemoryStream())
                    {
                        wb.SaveAs(stream);
                        stream.Position = 0;

                        var mimeType = MimeTypeMap.GetMimeType("xlsx");

                        FileContentResult file = File(stream.ToArray(), mimeType, StrFimeName);

                        return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
                    }
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }  
        }

        [HttpGet]
        public async Task<IActionResult> GetContractEmployee()
        {
            try
            {
                DataTable dt = new DataTable();
                
                string strUser = User.Identity.Name;
                var result = (await _hrmastersQueryReportsViewRepository.ContractEmployeeListAsync()).ToList();

                if (result == null)
                {
                    return NotFound();
                }
               
                var timeStamp = DateTime.Now.ToFileTime();
                string StrFimeName = "ContractEmployee_" + timeStamp.ToString();
                using (XLWorkbook wb = new XLWorkbook())
                {                    
                    var sheet1 = wb.Worksheets.Add("Contract Employee List");
                    sheet1.Cell(1, 1).InsertTable(result);

                    using (MemoryStream stream = new MemoryStream())
                    {
                        wb.SaveAs(stream);
                        stream.Position = 0;
                        
                        var mimeType = MimeTypeMap.GetMimeType("xlsx");

                        FileContentResult file = File(stream.ToArray(), mimeType, StrFimeName);

                        return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
                    }
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        [HttpGet]
        public async Task<IActionResult> GetSubcontractEmployee()
        {
            try
            {
                DataTable dt = new DataTable();
                
                string strUser = User.Identity.Name;
                var result = (await _hrmastersQueryReportsViewRepository.SubcontractEmployeeListAsync()).ToList();

                if (result == null)
                {
                    return NotFound();
                }
                                
                var timeStamp = DateTime.Now.ToFileTime();
                string StrFimeName = "SubcontractEmployeePayrollTrue_" + timeStamp.ToString();
                using (XLWorkbook wb = new XLWorkbook())
                {                   
                    var sheet1 = wb.Worksheets.Add("Subcontract Payroll True");
                    sheet1.Cell(1, 1).InsertTable(result);
                    
                    using (MemoryStream stream = new MemoryStream())
                    {
                        wb.SaveAs(stream);
                        stream.Position = 0;
                        
                        var mimeType = MimeTypeMap.GetMimeType("xlsx");

                        FileContentResult file = File(stream.ToArray(), mimeType, StrFimeName);

                        return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));

                    }
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        [HttpGet]
        public async Task<IActionResult> GetSubcontractActiveEmployee()
        {
            try
            {
                DataTable dt = new DataTable();

                string strUser = User.Identity.Name;
                var result = (await _hrmastersQueryReportsViewRepository.SubcontractActiveEmployeeListAsync()).ToList();

                if (result == null)
                {
                    return NotFound();
                }

                var timeStamp = DateTime.Now.ToFileTime();
                string StrFimeName = "SubcontractActiveEmployee_" + timeStamp.ToString();
                using (XLWorkbook wb = new XLWorkbook())
                {
                    var sheet1 = wb.Worksheets.Add("Subcontract Active Employee");
                    sheet1.Cell(1, 1).InsertTable(result);

                    using (MemoryStream stream = new MemoryStream())
                    {
                        wb.SaveAs(stream);
                        stream.Position = 0;

                        var mimeType = MimeTypeMap.GetMimeType("xlsx");

                        FileContentResult file = File(stream.ToArray(), mimeType, StrFimeName);

                        return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));

                    }
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }


        [HttpGet]
        public async Task<IActionResult> GetOutsourceEmployee(string yyyymm)
        {
            if (yyyymm == null)
            {
                return NotFound();
            }

            var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel { Yymm = yyyymm }, _uriMonthlyOutsourceEmployee);
            return ConvertResponseMessageToIActionResult(returnResponse, "OutsourceEmployee.xlsx");


            //try
            //{
            //    DataTable dt = new DataTable();
            //    string strUser = User.Identity.Name;
            //    var result = (await _hrmastersQueryReportsViewRepository.OutsourceEmployeeListAsync(yyyymm)).ToList();

            //    if (result == null)
            //    {
            //        return NotFound();
            //    }

            //    ListtoDataTableConverter converter = new ListtoDataTableConverter();
            //    dt = converter.ToDataTable(result);
            //    var timeStamp = DateTime.Now.ToFileTime();
            //    string StrFimeName = "OutsourceEmployee_" + timeStamp.ToString();
            //    using (XLWorkbook wb = new XLWorkbook())
            //    {
            //        wb.Worksheets.Add(dt);
            //        using (MemoryStream stream = new MemoryStream())
            //        {
            //            wb.SaveAs(stream);
            //            stream.Position = 0;
            //            return File(stream.ToArray(),
            //                       "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
            //                       StrFimeName + ".xlsx");
            //        }
            //    }
            //}
            //catch (Exception ex)
            //{
            //    Notify("Error", ex.Message, "toaster", notificationType: NotificationType.error);
            //}
            //return Redirect("~/HRMasters/Home/ReportIndex");
        }
        

        [HttpGet]
        public async Task<IActionResult> GetSubcontractEmployeePivot(string yyyymm)
        {
            if (yyyymm == null)
            {
                return NotFound();
            }

            try
            {
                DataTable dt = new DataTable();
                
                string strUser = User.Identity.Name;
                var result = (await _hrmastersQueryReportsViewRepository.SubcontractEmployeePivotListAsync(yyyymm)).ToList();

                if (result == null)
                {
                    return NotFound();
                }
                
                var timeStamp = DateTime.Now.ToFileTime();
                string StrFimeName = "SubcontractEmployeePivot_" + timeStamp.ToString();
                using (XLWorkbook wb = new XLWorkbook())
                {                    
                    var sheet1 = wb.Worksheets.Add("Subcontract Employee List");
                    sheet1.Cell(1, 1).InsertTable(result);

                    using (MemoryStream stream = new MemoryStream())
                    {
                        wb.SaveAs(stream);
                        stream.Position = 0;
                        return File(stream.ToArray(),
                                   "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                                   StrFimeName + ".xlsx");
                    }
                }
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message, "toaster", notificationType: NotificationType.error);
            }
            return Redirect("~/HRMasters/Home/ReportIndex");
        }


        [HttpGet]
        public async Task<IActionResult> GetParentSubcontractEmployee(string yyyymm)
        {
            if (yyyymm == null)
            {
                return NotFound();
            }

            try 
            {
                DataTable dt = new DataTable();
                string strUser = User.Identity.Name;
                var result = (await _hrmastersQueryReportsViewRepository.ParentwiseSubcontractListAsync(yyyymm)).ToString();

                if (result == null)
                {
                    return NotFound();
                }

                result = result.Replace("\\u0027", "");

                DataSet ds = JsonConvert.DeserializeObject<DataSet>(result);
                dt = ds.Tables[0];

                List<string> arrCol = new List<string>();                

                foreach(DataColumn dc in dt.Columns)
                {
                    if (dc.ColumnName.ToString() != "SUBCONTRACT" && dc.ColumnName.ToString() != "SUBCONTRACT NAME" && dc.ColumnName.ToString() != "TOTAL")
                    {
                        arrCol.Add(dc.ColumnName.ToString());
                    }                        
                }

                arrCol.Sort();

                Int32 i = 2;

                foreach(var item in arrCol)
                {
                    if (item.ToString() != "SUBCONTRACT" && item.ToString() != "SUBCONTRACT NAME" && item.ToString() != "TOTAL")
                    { 
                        dt.Columns[item.ToString()].SetOrdinal(i);
                        i += 1;
                    }                    
                }

                dt.Columns["TOTAL"].SetOrdinal(dt.Columns.Count - 1);

                var timeStamp = DateTime.Now.ToFileTime();
                string StrFimeName = "ParentSubcontractEmployee_" + timeStamp.ToString();
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
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message, "toaster", notificationType: NotificationType.error);
            }
            return Redirect("~/HRMasters/Home/ReportIndex");

        }

        [HttpGet]
        public async Task<IActionResult> GetMonthlyConsolidated(string yyyymm)
        {
            if (yyyymm == null)
            {
                return NotFound();
            }

            var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel { Yymm = yyyymm }, _uriMonthlyConsolidated);
            return ConvertResponseMessageToIActionResult(returnResponse, "MonthlyConsolidated.xlsx");
        }

        [HttpGet]
        public async Task<IActionResult> GetMonthlyConsolidatedEngg(string yyyymm)
        {
            if (yyyymm == null)
            {
                return NotFound();
            }

            var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel { Yymm = yyyymm }, _uriMonthlyConsolidatedEngg);
            return ConvertResponseMessageToIActionResult(returnResponse, "MonthlyConsolidatedEngg.xlsx");
        }

        private IActionResult ConvertResponseMessageToIActionResult(HttpResponseMessage httpResponseMessage, string defaultFileName)
        {
            string fileName = string.Empty;
            if (httpResponseMessage.IsSuccessStatusCode)
            {
                if (httpResponseMessage.Content.Headers.ContentType.ToString() == "application/json")
                {
                    var jsonResult = httpResponseMessage.Content.ReadAsStringAsync().Result;
                    var jsonResultObj = Newtonsoft.Json.Linq.JObject.Parse(jsonResult);
                    return Json(new
                    {
                        success = jsonResultObj.Value<string>("Status") == "OK",
                        response = jsonResultObj.Value<string>("MessageCode") + " - " + jsonResultObj.Value<string>("Message")
                    });
                }
                IEnumerable<string> values;
                if (httpResponseMessage.Headers.TryGetValues("xl_file_name", out values))
                    fileName = values.First();

                fileName = fileName ?? defaultFileName;

                return File(httpResponseMessage.Content.ReadAsStreamAsync().Result, "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", fileName);
            }
            else
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, "Internal server error");
            }
        }


        #region Filter

        public IActionResult FilterSet(string param, string title, string actionname)
        {
            FilterDataModel filterDataModel = new FilterDataModel();

            ViewData["Param"] = param;
            ViewData["Title"] = title;
            ViewData["Actionname"] = actionname;
            return PartialView("_FilterSetPartial", filterDataModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult FilterSet([FromForm] FilterDataModel filterDataModel)
        {            
            try
            {
                //return Json(new { success = true, startDate = filterDataModel.StartDate, endDate = filterDataModel.EndDate, actionName =  filterDataModel.ActionName });
                
                return Json(new { success = true, status = filterDataModel.Status });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }


        #endregion


    }
}
