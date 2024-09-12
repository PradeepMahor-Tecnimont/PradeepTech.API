using Microsoft.AspNetCore.Mvc;
using MimeTypes;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.Common;
using TCMPLApp.DataAccess.Repositories.CoreSettings;
using TCMPLApp.DataAccess.Repositories.SWPVaccine;
using TCMPLApp.Domain.Models.CoreSettings;
using TCMPLApp.Domain.Models.DeskBooking;
using TCMPLApp.Domain.Models.HRMasters;
using TCMPLApp.Library.Excel.Template.Models;
using TCMPLApp.WebApp.Classes;
using TCMPLApp.WebApp.Controllers;
using TCMPLApp.WebApp.Models;
using TCMPLApp.WebApp.Services;
using static TCMPLApp.WebApp.Classes.DTModel;

namespace TCMPLApp.WebApp.Areas.CoreSettings.Controllers
{
    [Area("CoreSettings")]
    public class HomeController : BaseController
    {
        private const string ConstFilterAppMailProcessStatusLogIndex = "AppMailProcessStatusLogIndex";
        private const string ConstFilterUserMasterIndex = "UserMasterIndex";

        private readonly IAppMailProcessStatusDetailsRepository _appMailProcessStatusDetailsRepository;
        private readonly IAppMailProcessStatusRepository _appMailProcessStatusRepository;
        private readonly IAppMailProcessStatusLogDataTableListRepository _appMailProcessStatusLogDataTableListRepository;
        private readonly IFilterRepository _filterRepository;
        private readonly IAppUserMasterDataTableListRepository _appUserMasterDataTableListRepository;
        private readonly IUploadAppUserRepository _uploadEmployeeRepository;
        private readonly IUtilityRepository _utilityRepository;
        private readonly IHttpClientWebApi _httpClientWebApi;
        private readonly IUpdateAppUserMasterRepository _updateAppUserMasterRepository;

        public HomeController(IAppMailProcessStatusDetailsRepository appMailProcessStatusDetailsRepository,
            IAppMailProcessStatusRepository appMailProcessStatusRepository,
            IAppMailProcessStatusLogDataTableListRepository appMailProcessStatusLogDataTableListRepository,
            IFilterRepository filterRepository,
            IHttpClientWebApi httpClientWebApi,
            IAppUserMasterDataTableListRepository appUserMasterDataTableListRepository,
            IUploadAppUserRepository uploadEmployeeRepository,
            IUtilityRepository utilityRepository,
            IUpdateAppUserMasterRepository updateAppUserMasterRepository)
        {
            _appMailProcessStatusRepository = appMailProcessStatusRepository;
            _appMailProcessStatusDetailsRepository = appMailProcessStatusDetailsRepository;
            _appMailProcessStatusLogDataTableListRepository = appMailProcessStatusLogDataTableListRepository;
            _filterRepository = filterRepository;
            _appUserMasterDataTableListRepository = appUserMasterDataTableListRepository;
            _uploadEmployeeRepository = uploadEmployeeRepository;
            _utilityRepository = utilityRepository;
            _updateAppUserMasterRepository = updateAppUserMasterRepository;
            _httpClientWebApi = httpClientWebApi;
        }

        public async Task<IActionResult> Index()
        {
            var details = await _appMailProcessStatusDetailsRepository.AppMailProcessStatusDetailsAsync(
                           BaseSpTcmPLGet(),
                           new ParameterSpTcmPL());
            ViewData["EmailProcessStatus"] = details.PProcessMailText;
            return View();
        }

        [HttpGet]
        public async Task<IActionResult> ChangeProcessmailStatusAsync()
        {
            ChangeProcessmailStatusViewModel changeProcessmailStatusViewModel = new();

            var details = await _appMailProcessStatusDetailsRepository.AppMailProcessStatusDetailsAsync(
                           BaseSpTcmPLGet(),
                           new ParameterSpTcmPL());

            changeProcessmailStatusViewModel.ProcessMailStatus = details.PProcessMail;

            return PartialView("_ModalProcessMailStatusChangePartial", changeProcessmailStatusViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ChangeProcessmailStatus([FromForm] ChangeProcessmailStatusViewModel changeProcessmailStatusViewModel)
        {
            if (ModelState.IsValid)
            {
                Domain.Models.Common.DBProcMessageOutput result = await _appMailProcessStatusRepository.AppMailProcessStatusChangeAsync(

                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PProcessMail = changeProcessmailStatusViewModel.ProcessMailStatus,
                    });
                if (result.PMessageType == IsOk)
                {
                    Notify("Success", "Procedure executed successfully", "", NotificationType.success);
                    return RedirectToAction("Index");
                }
                else
                {
                    Notify("Error", result.PMessageText, "", NotificationType.error);
                }
            }
            return RedirectToAction("Index");
        }

        public async Task<IActionResult> ProcessMailStatusLogIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterAppMailProcessStatusLogIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            AppMailProcessStatusLogViewModel appMailProcessStatusLogViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(appMailProcessStatusLogViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetProcessMailStatusLog(string paramJSon)
        {
            DTResult<AppMailProcessStatusLogDataTableList> result = new();
            int totalRow = 0;

            try
            {
                DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJSon);

                System.Collections.Generic.IEnumerable<AppMailProcessStatusLogDataTableList> data = await _appMailProcessStatusLogDataTableListRepository.AppMailProcessStatusLogDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch ?? " ",
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


        #region AppUserMaster

        public async Task<IActionResult> UserMasterIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterUserMasterIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            AppUserMasterViewModel appUserMasterViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(appUserMasterViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetUserMasterList(string paramJSon)
        {
            DTResult<AppUserMasterDataTableList> result = new();
            int totalRow = 0;

            try
            {
                DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJSon);

                System.Collections.Generic.IEnumerable<AppUserMasterDataTableList> data = await _appUserMasterDataTableListRepository.AppUserMasterDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch ?? " ",
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

        [HttpGet]
        public IActionResult EmployeeUpload()
        {
            AppUserUploadViewModel employeeUploadViewModel = new();

            return PartialView("_ModalAppUserUploadPartial", employeeUploadViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> EmployeeUpload(AppUserUploadViewModel employeeUploadViewModel)
        {
            try
            {
                if (ModelState.IsValid == false)
                    return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage("Please Enter Valid Employee No"));
                var jsonstring = employeeUploadViewModel.Employee;

                if (jsonstring != null)
                {
                    jsonstring = MultilineToCSV(jsonstring);
                }

                string[] arrItems = jsonstring.Split(',');

                List<ReturnEmp> returnEmpList = new();
                foreach (var emp in arrItems)
                {
                    if (emp != "")
                    {
                        returnEmpList.Add(new ReturnEmp { Empno = (emp ?? "00000").PadLeft(5, '0') });
                    }
                }
                if (!returnEmpList.Any())
                {
                    throw new Exception("Please enter valid employee no (length:5)");
                }
                string formattedJson = JsonConvert.SerializeObject(returnEmpList);
                byte[] byteArray = Encoding.ASCII.GetBytes(formattedJson);


                var uploadOutPut = await _uploadEmployeeRepository.UploadAppUserJSonAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL
                {
                    PEmpnoJson = byteArray
                });


                List<ImportFileResultViewModel> importFileResults = new List<ImportFileResultViewModel>();

                List<Library.Excel.Template.Models.ValidationItem> validationItems = new List<Library.Excel.Template.Models.ValidationItem>();

                if (uploadOutPut.PMessageType != IsOk)
                {
                    if (uploadOutPut.PEmpnoErrors != null)
                    {
                        foreach (var excelError in uploadOutPut.PEmpnoErrors)
                        {
                            importFileResults.Add(new ImportFileResultViewModel
                            {
                                ErrorType = (ImportFileValidationErrorTypeEnum)excelError.ErrorType,
                                ExcelRowNumber = excelError.ExcelRowNumber,
                                FieldName = excelError.FieldName,
                                Id = excelError.Id,
                                Section = excelError.Section,
                                Message = excelError.Message,
                            });
                        }
                    }

                    if (importFileResults.Count > 0)
                    {
                        foreach (var item in importFileResults)
                        {
                            validationItems.Add(new ValidationItem
                            {
                                ErrorType = (Library.Excel.Template.Models.ValidationItemErrorTypeEnum)Enum.Parse(typeof(Library.Excel.Template.Models.ValidationItemErrorTypeEnum), item.ErrorType.ToString(), true),
                                ExcelRowNumber = item.ExcelRowNumber.Value,
                                FieldName = item.FieldName,
                                Id = item.Id,
                                Section = item.Section,
                                Message = item.Message
                            });
                        }
                    }

                    var resultJsonError = new
                    {
                        success = false,
                        response = uploadOutPut.PMessageText,
                        data = importFileResults,
                        fileContent = ""
                    };

                    var timeStamp = DateTime.Now.ToFileTime();

                    string fileName = "Errors_" + timeStamp.ToString();
                    string reportTitle = "Errors";
                    string sheetName = "Errors";

                    var byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(importFileResults, reportTitle, sheetName);

                    var mimeType = MimeTypeMap.GetMimeType("xlsx");

                    FileContentResult file = File(byteContent, mimeType, fileName);

                    return Json(ResponseHelper.GetMessageObject("Error while performing action", file, MessageType: NotificationType.error));
                }
                else
                {
                    return Json(new { success = uploadOutPut.PMessageType, response = "Import data successfully executed" });
                }

            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        public string MultilineToCSV(string sourceStr)
        {
            if (string.IsNullOrEmpty(sourceStr))
            {
                return "";
            }

            bool s = !Regex.IsMatch(sourceStr, @"[^0-9A-Za-z, \r\n]");

            if (!s)
            {
                throw new Exception("Please Enter Valid Employee No");
            }

            string retVal = sourceStr.Replace(System.Environment.NewLine, ",");

            retVal = Regex.Replace(retVal, @"\s+", ",");

            return retVal;
        }

        public async Task<IActionResult> ActiveEmployee(List<string> selectedRecords)
        {
            List<ReturnEmp> returnEmps = new();

            foreach (var item in selectedRecords)
            {
                if (!string.IsNullOrEmpty(item))
                {
                    string[] arrRetItems = item.Split(",");
                    ReturnEmp Item = new()
                    {
                        Empno = arrRetItems[0].ToString()
                    };

                    returnEmps.Add(Item);
                }
            }

            var jsonString = JsonConvert.SerializeObject(returnEmps);

            var result = await _updateAppUserMasterRepository.ActivateEmpJSonAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
                PParameterJson = jsonString
            });
            return result.PMessageType != IsOk
                        ? throw new Exception(result.PMessageText.Replace("-", " "))
                        : (IActionResult)Json(new { success = true, response = result.PMessageText });
        }

        public async Task<IActionResult> DeActiveEmployee(List<string> selectedRecords)
        {
            List<ReturnEmp> returnEmps = new();

            foreach (var item in selectedRecords)
            {
                if (!string.IsNullOrEmpty(item))
                {
                    string[] arrRetItems = item.Split(",");
                    ReturnEmp Item = new()
                    {
                        Empno = arrRetItems[0].ToString()
                    };

                    returnEmps.Add(Item);
                }
            }

            var jsonString = JsonConvert.SerializeObject(returnEmps);

            var result = await _updateAppUserMasterRepository.DeactivateEmpJSonAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
                PParameterJson = jsonString
            });
            return result.PMessageType != IsOk
                        ? throw new Exception(result.PMessageText.Replace("-", " "))
                        : (IActionResult)Json(new { success = true, response = result.PMessageText });
        }

        #endregion AppUserMaster
    }
}