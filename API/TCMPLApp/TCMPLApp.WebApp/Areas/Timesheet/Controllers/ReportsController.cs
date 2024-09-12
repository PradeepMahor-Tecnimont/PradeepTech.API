using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.Extensions.Configuration;
using MimeTypes;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.Common;
using TCMPLApp.DataAccess.Repositories.HRMasters;
using TCMPLApp.DataAccess.Repositories.SWPVaccine;
using TCMPLApp.DataAccess.Repositories.Timesheet;
using TCMPLApp.DataAccess.Repositories.Timesheet.Exec.Implementation;
using TCMPLApp.DataAccess.Repositories.Timesheet.Exec.Interface;
using TCMPLApp.DataAccess.Repositories.Timesheet.View.Interface;
using TCMPLApp.Domain.Models.HRMasters;
using TCMPLApp.Domain.Models.Timesheet;
using TCMPLApp.WebApp.Classes;
using TCMPLApp.WebApp.Controllers;
using TCMPLApp.WebApp.CustomPolicyProvider;
using TCMPLApp.WebApp.Models;
using TCMPLApp.WebApp.Services;
using static TCMPLApp.WebApp.Classes.DTModel;

namespace TCMPLApp.WebApp.Areas.Timesheet.Controllers
{
    [Authorize]
    [Area("Timesheet")]
    public class ReportsController : BaseController
    {
        private const string ConstFilterTimesheetIndex = "TimesheetCommonIndex";
        
        private const string ModuleId = "M10";
        private readonly string YearMode = "A";

        private readonly IFilterRepository _filterRepository;
        private readonly ISelectTcmPLRepository _selectTcmPLRepository;
        private readonly IConfiguration _configuration;
        private readonly IWebHostEnvironment _env;
        private readonly ITimesheetReportRepository _timesheetReportRepository;
        private readonly ITimesheetReportDetailRepository _timesheetReportDetailRepository;
        private readonly IEmployeeTimesheetDataTableListRepository _employeeTimesheetDataTableListRepository;
        private readonly ICommonEmployeeDetailsRepository _commonEmployeeDetailsRepository;
        private readonly IEmployeeTimesheetDetailsRepository _employeeTimesheetDetailsRepository;
        
        private readonly IUtilityRepository _utilityRepository;

        private static readonly string _uriTimesheetHR = "api/rap/rpt/downloadTimesheet";

        private readonly IHttpClientRapReporting _httpClientRapReporting;

        public ReportsController(IConfiguration configuration,
            IHttpClientRapReporting httpClientRapReporting,
            IFilterRepository filterRepository,
            ISelectTcmPLRepository selectTcmPLRepository,
            IWebHostEnvironment env,
            ITimesheetReportRepository timesheetReportRepository,
            ITimesheetReportDetailRepository timesheetReportDetailRepository,
            IEmployeeTimesheetDataTableListRepository employeeTimesheetDataTableListRepository,
            ICommonEmployeeDetailsRepository commonEmployeeDetailsRepository,
            IEmployeeTimesheetDetailsRepository employeeTimesheetDetailsRepository,
            
            IUtilityRepository utilityRepository)
        {
            _configuration = configuration;
            _httpClientRapReporting = httpClientRapReporting;
            _filterRepository = filterRepository;
            _selectTcmPLRepository = selectTcmPLRepository;
            _env = env;
            _timesheetReportRepository = timesheetReportRepository;
            _timesheetReportDetailRepository = timesheetReportDetailRepository;
            _employeeTimesheetDataTableListRepository = employeeTimesheetDataTableListRepository;
            _commonEmployeeDetailsRepository = commonEmployeeDetailsRepository;
            _employeeTimesheetDetailsRepository = employeeTimesheetDetailsRepository;
            
            _utilityRepository = utilityRepository;
        }

        public async Task<IActionResult> SelectEmployeeList()
        {
            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterTimesheetIndex
            });
            FilterDataModel filterDataModel;
            if (string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = new FilterDataModel();
                filterDataModel.Yyyy = null;
                filterDataModel.Yyyymm = null;
            }
            else
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            filterDataModel.YearMode = YearMode;


            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TimesheetHelper.ActionDeptEmployeeTimesheetReport))
            {
                var empnos = await _selectTcmPLRepository.SelectDeptEmpnoTimeSheet(BaseSpTcmPLGet(), new ParameterSpTcmPL { PYyyymm = filterDataModel.Yyyymm });
                ViewData["Empnos"] = new SelectList(empnos, "DataValueField", "DataTextField", null, "DataGroupField");
            }
            else if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TimesheetHelper.ActionAllEmployeeTimesheetReport))
            {
                var empnos = await _selectTcmPLRepository.SelectAllEmpnoTimeSheet(BaseSpTcmPLGet(), new ParameterSpTcmPL { PYyyymm = filterDataModel.Yyyymm });
                ViewData["Empnos"] = new SelectList(empnos, "DataValueField", "DataTextField", null, "DataGroupField");
            }

            return PartialView("_ModalTimesheetPartial", filterDataModel);
        }

        public async Task<IActionResult> DownloadTimesheetReport(string empno, string yymm)
        {
            var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
            { Empno = empno, Yymm = yymm }, _uriTimesheetHR);
            return ConvertResponseMessageToIActionResult(returnResponse, "Timesheet.xlsx");
        }

        public async Task<string> CheckReportHit()
        {
            ReportDetail reportDetail = new ReportDetail();

            reportDetail = await _timesheetReportDetailRepository.ReportDetail(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {

                }
            );

            if (reportDetail.KeyId != null)
            {
                return reportDetail.KeyId;
            }
            else
            {
                return null;
            }
        }


        public async Task<IActionResult> GetReport()
        {
            ReportDetail reportDetail = new ReportDetail();

            try
            {
                reportDetail = await _timesheetReportDetailRepository.ReportDetail(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {

                    }
                );

                if (reportDetail.KeyId != null)
                {
                    HCModel hCModel;
                    hCModel = JsonConvert.DeserializeObject<HCModel>(reportDetail.ReportParameter);

                    var result = await _timesheetReportRepository.DeleteReportEntry(
                     BaseSpTcmPLGet(),
                     new ParameterSpTcmPL
                     {
                         PKeyId = reportDetail.KeyId
                     });

                    if (result.PMessageType != "OK")
                    {
                        throw new Exception(result.PMessageText.Replace("-", " "));
                    }
                    else
                    {
                        return RedirectToAction(reportDetail.ReportUrl, new { empno = hCModel.Empno, yymm = hCModel.Yyyymm });
                    }
                }
                else
                {
                    return Ok(reportDetail);
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
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


        #region EmployeeReport

        public async Task<IActionResult> EmployeeReportIndex(string costcode)
        {

            string defaultCostcode = string.Empty;

            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterTimesheetIndex
            });

            FilterDataModel filterDataModel = new();

            if (string.IsNullOrEmpty(retVal.OutPFilterJson))
                return NotFound();
            else
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TimesheetHelper.ActionDeptTimesheet))
            {
                var costCodes = await _selectTcmPLRepository.TSOSCMhrsCostcodeList(BaseSpTcmPLGet(), null);
                defaultCostcode = costcode == null ? costCodes.FirstOrDefault().DataValueField?.ToString() : costcode?.ToString();
                ViewData["CostCodes"] = new SelectList(costCodes, "DataValueField", "DataTextField", defaultCostcode);
            }

            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TimesheetHelper.ActionAllEmployeeTimesheetReport))
            {
                var costCodes = await _selectTcmPLRepository.SelectCostCodeRapReportingProco(BaseSpTcmPLGet(), null);
                defaultCostcode = costcode == null ? costCodes.FirstOrDefault().DataValueField?.ToString() : costcode?.ToString();
                ViewData["CostCodes"] = new SelectList(costCodes, "DataValueField", "DataTextField", defaultCostcode);
            }

            EmployeeTimesheetViewModel employeeTimesheetViewModel = new EmployeeTimesheetViewModel { FilterDataModel = filterDataModel };

            ViewData["DefaultCostcode"] = defaultCostcode;
            return View(employeeTimesheetViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsEmployees(string paramJSon)
        {
            DTResult<EmployeeTimesheetDataTableList> result = new();
            int totalRow = 0;

            try
            {
                DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJSon);

                IEnumerable<EmployeeTimesheetDataTableList> data = await _employeeTimesheetDataTableListRepository.EmployeeTimesheetDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch ?? " ",
                        PCostcode = param.Costcode,
                        PRowNumber = param.Start,
                        PPageLength = param.Length
                    }
                );

                if (data.Any())
                {
                    totalRow = (int)data.FirstOrDefault().TotalRow.Value;
                }

                result.draw = param.Draw;
                result.recordsTotal = totalRow;
                result.recordsFiltered = totalRow;
                result.data = data.ToList();

                return Json(result);
            }
            catch (Exception ex)
            {
                return Json(new { error = ex.Message });
            }

        }

        public async Task<IActionResult> EmployeeTimesheet(string id,string assign)
        {
            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterTimesheetIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            EmployeeTimesheetDetail employeeTimesheetDetails = new()
            {
                FilterDataModel = filterDataModel
            };

            var empdetails = await _commonEmployeeDetailsRepository.EmployeeDetailAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
                PEmpno = id
            });

            employeeTimesheetDetails.Empno = empdetails.PForEmpno;
            employeeTimesheetDetails.Name = empdetails.PName;
            employeeTimesheetDetails.DesgCode = empdetails.PDesgCode;
            employeeTimesheetDetails.DesgName = empdetails.PDesgName;
            employeeTimesheetDetails.Parent = empdetails.PParent;
            employeeTimesheetDetails.CostName = empdetails.PCostName;
            employeeTimesheetDetails.Assign = assign;
            
            IEnumerable<DataField> departmentList = await _selectTcmPLRepository.TimesheetCostcodeList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
                PYymm = filterDataModel.Yyyymm,
                PEmpno = id
            });
            if (departmentList.Any())
            {
                ViewData["DepartmentList"] = new SelectList(departmentList, "DataValueField", "DataTextField", assign);
                ViewData["Count"] = departmentList.Count();
            }
            else
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage("Timesheet data is not available for this month"));
            }

            return PartialView("_ModalEmployeeTimesheetPartial", employeeTimesheetDetails);
        }

        [HttpGet]
        public async Task<IActionResult> GetTimesheetData(string costcode, string yymm, string empno)
        {
            var data = await _employeeTimesheetDetailsRepository.TimesheetDetailsAsync(BaseSpTcmPLGet(),
                   new ParameterSpTcmPL
                   {
                       PEmpno = empno,
                       PYymm = yymm,
                       PCostcode = costcode
                   });
            return Json(data);

        }

        #endregion EmployeeReport
    }
}