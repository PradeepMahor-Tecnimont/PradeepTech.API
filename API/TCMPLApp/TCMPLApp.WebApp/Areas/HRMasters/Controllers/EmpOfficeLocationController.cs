using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using System.Linq;
using System;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.Common;
using TCMPLApp.DataAccess.Repositories.SWPVaccine;
using TCMPLApp.Domain.Models.HRMasters;
using TCMPLApp.WebApp.Controllers;
using TCMPLApp.WebApp.CustomPolicyProvider;
using TCMPLApp.WebApp.Models;
using static TCMPLApp.WebApp.Classes.DTModel;
using TCMPLApp.DataAccess.Repositories.DMS;
using TCMPLApp.DataAccess.Repositories.HRMasters;
using System.Net;
using Microsoft.AspNetCore.Mvc.Rendering;
using System.Collections.Generic;
using TCMPLApp.WebApp.Classes;
using MimeTypes;
using System.Text.RegularExpressions;
using OfficeOpenXml.FormulaParsing.Excel.Functions.Math;
using System.Text;
using DocumentFormat.OpenXml.Bibliography;
using System.IO;
using TCMPLApp.Library.Excel.Template;
using TCMPLApp.Library.Excel.Template.Models;

namespace TCMPLApp.WebApp.Areas.HRMasters.Controllers
{
    [Area("HRMasters")]
    [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, HRMastersHelper.ActionViewHRMasters)]
    public class EmpOfficeLocationController : BaseController
    {
        private const string ConstFilterEmpOfficeLocation = "EmpOfficeLocationIndex";


        private readonly IFilterRepository _filterRepository;
        private readonly ISelectTcmPLRepository _selectTcmPLRepository;
        private readonly IUtilityRepository _utilityRepository;

        private readonly IEmpOfficeLocationDataTableListRepository _empOfficeLocationDataTableListRepository;
        private readonly IEmpOfficeLocationXLDataTableListRepository _empOfficeLocationXLDataTableListRepository;
        private readonly IEmpOfficeLocationDetailRepository _empOfficeLocationDetailRepository;
        private readonly IEmpOfficeLocationHistoryDataTableListRepository _empOfficeDataTableListRepository;
        private readonly IEmpOfficeLocationRepository _empOfficeLocationRepository;
        private readonly IEmpOfficeLocationImportRepository _empOfficeLocationImportRepository;
        private readonly IExcelTemplate _excelTemplate;

        public EmpOfficeLocationController(
            IFilterRepository filterRepository,
            ISelectTcmPLRepository selectTcmPLRepository,
            IUtilityRepository utilityRepository,
            IEmpOfficeLocationDataTableListRepository empOfficeLocationDataTableListRepository,
            IEmpOfficeLocationXLDataTableListRepository empOfficeLocationXLDataTableListRepository,
            IEmpOfficeLocationDetailRepository empOfficeLocationDetailRepository,
            IEmpOfficeLocationHistoryDataTableListRepository empOfficeDataTableListRepository,
            IEmpOfficeLocationRepository empOfficeLocationRepository,
            IEmpOfficeLocationImportRepository empOfficeLocationImportRepository,
            IExcelTemplate excelTemplate)

        {
            _filterRepository = filterRepository;
            _selectTcmPLRepository = selectTcmPLRepository;
            _utilityRepository = utilityRepository;
            _empOfficeLocationDataTableListRepository = empOfficeLocationDataTableListRepository;
            _empOfficeLocationXLDataTableListRepository = empOfficeLocationXLDataTableListRepository;
            _empOfficeLocationDetailRepository = empOfficeLocationDetailRepository;
            _empOfficeDataTableListRepository = empOfficeDataTableListRepository;
            _empOfficeLocationRepository = empOfficeLocationRepository;
            _empOfficeLocationImportRepository = empOfficeLocationImportRepository;
            _excelTemplate = excelTemplate;
        }

        #region EmpOfficeLocation

        [HttpGet]
        public async Task<IActionResult> EmpOfficeLocationIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterEmpOfficeLocation
            });

            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            EmpOfficeLocationViewModel empOfficeLocationViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(empOfficeLocationViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsEmpOfficeLocation(string paramJson)
        {
            DTResult<EmpOfficeLocationDataTableList> result = new();

            var param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            int totalRow = 0;

            try
            {
                System.Collections.Generic.IEnumerable<EmpOfficeLocationDataTableList> data = await _empOfficeLocationDataTableListRepository.EmpOfficeLocationDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch,
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
                        PParent = param.Parent,
                        PGrade = param.Grade,
                        PEmpType = param.EmpType,
                        POfficeLocationCode = param.OfficeLocationCode
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
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, HRMastersHelper.ActionEditEmplmast)]
        public async Task<IActionResult> EmpOfficeLocationCreate(string empno)
        {
            try
            {
                if (empno == null)
                {
                    return NotFound();
                }

                var empOfficeDetails = await _empOfficeLocationDetailRepository.EmpOfficeLocationDetail(BaseSpTcmPLGet(),
                               new ParameterSpTcmPL
                               {
                                   PEmpno = empno
                               }
                           );

                EmpOfficeLocationEditViewModel empOfficeLocationEditViewModel = new EmpOfficeLocationEditViewModel();

                empOfficeLocationEditViewModel.Empno = empno;
                empOfficeLocationEditViewModel.Name = empOfficeDetails.PName;
                empOfficeLocationEditViewModel.Grade = empOfficeDetails.PGrade;
                empOfficeLocationEditViewModel.Parent = empOfficeDetails.PParent;
                empOfficeLocationEditViewModel.Assign = empOfficeDetails.PAssign;
                empOfficeLocationEditViewModel.Emptype = empOfficeDetails.PEmptype;
                //empOfficeLocationEditViewModel.EmpOffice = empOfficeDetails.EmpOffice;


                IEnumerable<DataField> officeLocation = await _selectTcmPLRepository.HRMISOfficeLocationList(BaseSpTcmPLGet(), new ParameterSpTcmPL());

                ViewData["OfficeList"] = new SelectList(officeLocation, "DataValueField", "DataTextField", empOfficeLocationEditViewModel.EmpOfficeLocation);

                return PartialView("_ModalEmpOfficeLocationCreatePartial", empOfficeLocationEditViewModel);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }

        }


        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, HRMastersHelper.ActionEditEmplmast)]
        public async Task<IActionResult> EmpOfficeLocationCreate([FromForm] EmpOfficeLocationEditViewModel empOfficeLocationEditViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _empOfficeLocationRepository.EmpOfficeLocationEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PEmpno = empOfficeLocationEditViewModel.Empno,
                            POfficeLocationCode = empOfficeLocationEditViewModel.EmpOfficeLocation,
                            PStartDate = empOfficeLocationEditViewModel.StartDate
                        });

                    if (result.PMessageType == "OK")
                    {
                        return RedirectToAction("EmpOfficeLocationList", new { empno = empOfficeLocationEditViewModel.Empno });
                    }
                    else
                    {
                        return StatusCode((int)HttpStatusCode.InternalServerError, result.PMessageText);
                    }
                }

                IEnumerable<DataField> officeLocationList = await _selectTcmPLRepository.HRMISOfficeLocationList(BaseSpTcmPLGet(), new ParameterSpTcmPL());

                ViewData["OfficeList"] = new SelectList(officeLocationList, "DataValueField", "DataTextField", empOfficeLocationEditViewModel.EmpOfficeLocation);

                return PartialView("_ModalEmpOfficeLocationCreatePartial", empOfficeLocationEditViewModel);

            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
        }


        public async Task<IActionResult> EmpOfficeLocationExcelDownload()
        {
            try
            {

                var timeStamp = DateTime.Now.ToFileTime();
                string fileName = "Emp Office Location Details_" + timeStamp.ToString();
                string reportTitle = "Emp Office Location Details ";
                string sheetName = "Emp Office Location Details";

                var excelData = await _empOfficeLocationXLDataTableListRepository.EmpOfficeLocationDataTableListForExcelAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                    });

                if (excelData == null || excelData.Count() == 0) { throw new Exception("No Data Found"); }

                byte[] byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, reportTitle, sheetName);

                var mimeType = MimeTypeMap.GetMimeType("xlsx");

                FileContentResult file = File(byteContent, mimeType, fileName);

                return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));

            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        public async Task<IActionResult> EmpOfficeLocationDetailIndex(string Empno)
        {
            try
            {
                var empOfficeDetails = await _empOfficeLocationDetailRepository.EmpOfficeLocationDetail(BaseSpTcmPLGet(),
                               new ParameterSpTcmPL
                               {
                                   PEmpno = Empno
                               }
                           );

                EmpOfficeLocationEditViewModel empOfficeLocationEditViewModel = new EmpOfficeLocationEditViewModel();

                empOfficeLocationEditViewModel.Empno = Empno;
                empOfficeLocationEditViewModel.Name = empOfficeDetails.PName;
                empOfficeLocationEditViewModel.Grade = empOfficeDetails.PGrade;
                empOfficeLocationEditViewModel.Parent = empOfficeDetails.PParent;
                empOfficeLocationEditViewModel.Assign = empOfficeDetails.PAssign;
                empOfficeLocationEditViewModel.Emptype = empOfficeDetails.PEmptype;
                //empOfficeLocationEditViewModel.EmpOffice = empOfficeDetails.EmpOffice;

                return PartialView("_ModalEmpOfficeLocationDetail", empOfficeLocationEditViewModel);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        public async Task<JsonResult> GetListsEmpOfficeLocationHistory(string paramJson)
        {

            DTResult<EmpOfficeLocationHistoryDataTableList> result = new();

            var param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            int totalRow = 0;

            try
            {
                var data = await _empOfficeDataTableListRepository.EmpOfficeLocationHistoryDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
                        PEmpno = param.Empno
                    });

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
        
        public async Task<IActionResult> EmpOfficeLocationList(string Empno)
        {
            try
            {
                var empOfficeDetails = await _empOfficeLocationDetailRepository.EmpOfficeLocationDetail(BaseSpTcmPLGet(),
                               new ParameterSpTcmPL
                               {
                                   PEmpno = Empno
                               }
                           );

                EmpOfficeLocationEditViewModel empOfficeLocationEditViewModel = new EmpOfficeLocationEditViewModel();

                empOfficeLocationEditViewModel.Empno = Empno;
                empOfficeLocationEditViewModel.Name = empOfficeDetails.PName;
                empOfficeLocationEditViewModel.Grade = empOfficeDetails.PGrade;
                empOfficeLocationEditViewModel.Parent = empOfficeDetails.PParent;
                empOfficeLocationEditViewModel.Assign = empOfficeDetails.PAssign;
                empOfficeLocationEditViewModel.Emptype = empOfficeDetails.PEmptype;
                //empOfficeLocationEditViewModel.EmpOffice = empOfficeDetails.EmpOffice;

                return PartialView("_ModalEmpOfficeLocationUpdatePartial", empOfficeLocationEditViewModel);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, HRMastersHelper.ActionEditEmplmast)]
        public async Task<IActionResult> EmpOfficeLocationDelete(string id)
        {
            try
            {
                Domain.Models.Common.DBProcMessageOutput result = await _empOfficeLocationRepository.EmpOfficeLocationDeleteAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PKeyId = id
                    }
                    );

                return Json(new { success = result.PMessageType == IsOk, response = result.PMessageType, message = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        [HttpGet]
        public async Task<IActionResult> ImportEmpOffice()
        {

            EmpOfficeViewModel empOfficeViewModel = new();

            IEnumerable<DataField> officeLocation = await _selectTcmPLRepository.HRMISOfficeLocationList(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            ViewData["OfficeList"] = new SelectList(officeLocation, "DataValueField", "DataTextField", empOfficeViewModel.EmpOfficeLocation);

            return PartialView("_ModalEmpOfficeLocationUploadPartial", empOfficeViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ImportEmpOffice(EmpOfficeViewModel empOfficeViewModel)
        {
            try
            {
                if (ModelState.IsValid == false)
                    return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage("Please Enter Valid Employee No"));

                var jsonstring = empOfficeViewModel.Employee;

                if (jsonstring != null)
                {
                    jsonstring = MultilineToCSV(jsonstring);
                    if (jsonstring.Length < 5)
                    {
                        throw new Exception("Please Enter Valid Employee No");
                    }
                }

                string[] arrItems = jsonstring.Split(',');

                List<ReturnEmployee> returnEmpList = new List<ReturnEmployee>();

                foreach (var emp in arrItems)
                {
                    if (emp != "" && emp.Length == 5)
                    {
                        returnEmpList.Add(new ReturnEmployee { Empno = emp });
                    }
                }
                if (!returnEmpList.Any())
                {
                    throw new Exception("Please enter valid employee no (length:5)");
                }

                string formattedJson = JsonConvert.SerializeObject(returnEmpList);
                byte[] byteArray = Encoding.ASCII.GetBytes(formattedJson);

                var uploadOutPut = await _empOfficeLocationImportRepository.ImportEmpOfficeLocationAsync(BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PEmpOfficeLocationJson = byteArray,
                    POfficeLocationCode = empOfficeViewModel.EmpOfficeLocation,
                    PStartDate = empOfficeViewModel.StartDate
                });

                List<ImportFileResultViewModel> importFileResults = new List<ImportFileResultViewModel>();

                List<Library.Excel.Template.Models.ValidationItem> validationItems = new List<Library.Excel.Template.Models.ValidationItem>();

                if (uploadOutPut.PMessageType != IsOk)
                {
                    if (uploadOutPut.PEmpOfficeLocationErrors != null)
                    {
                        foreach (var excelError in uploadOutPut.PEmpOfficeLocationErrors)
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
                return ("");
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

        #endregion EmpOfficeLocation


        #region filter

        private async Task<Domain.Models.FilterCreate> CreateFilter(string jsonFilter, string ActionName)
        {
            var retVal = await _filterRepository.FilterCreateAsync(new Domain.Models.FilterCreate
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ActionName,
                PFilterJson = jsonFilter
            });
            return retVal;
        }

        private async Task<Domain.Models.FilterRetrieve> RetriveFilter(string ActionName)
        {
            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ActionName
            });
            return retVal;
        }

        public async Task<IActionResult> ResetFilter(string ActionId)
        {
            try
            {
                var result = await _filterRepository.FilterResetAsync(new Domain.Models.FilterReset
                {
                    PModuleName = CurrentUserIdentity.CurrentModule,
                    PMetaId = CurrentUserIdentity.MetaId,
                    PPersonId = CurrentUserIdentity.EmployeeId,
                    PMvcActionName = ActionId,
                });

                return Json(new { success = result.OutPSuccess == "OK", response = result.OutPMessage });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        public async Task<IActionResult> EmpOfficeLocationFilterGet()
        {
            var retVal = await RetriveFilter(ConstFilterEmpOfficeLocation);

            FilterDataModel filterDataModel = new FilterDataModel();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            IEnumerable<DataField> officeList = await _selectTcmPLRepository.HRMISOfficeLocationList(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            ViewData["OfficeList"] = new SelectList(officeList, "DataValueField", "DataTextField");

            IEnumerable<DataField> costCodeList = await _selectTcmPLRepository.HRMISDeptList(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            ViewData["CostCodeList"] = new SelectList(costCodeList, "DataValueField", "DataTextField");

            IEnumerable<DataField> gradeList = await _selectTcmPLRepository.GradeListSWP(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            ViewData["GradeList"] = new SelectList(gradeList, "DataValueField", "DataTextField");

            IEnumerable<DataField> empTypeList = await _selectTcmPLRepository.EmployeeTypeListSWP(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            ViewData["EmpTypeList"] = new SelectList(empTypeList, "DataValueField", "DataTextField");

            return PartialView("_ModalEmpOfficeLocationFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> EmpOfficeLocationFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                string jsonFilter;
                jsonFilter = JsonConvert.SerializeObject(
                        new
                        {
                            StartDate = filterDataModel.StartDate,
                            EndDate = filterDataModel.EndDate,
                            Parent = filterDataModel.Parent,
                            Grade = filterDataModel.Grade,
                            EmpType = filterDataModel.EmpType,
                            OfficeLocationCode = filterDataModel.OfficeLocationCode
                        });

                _ = await CreateFilter(jsonFilter, ConstFilterEmpOfficeLocation);

                return Json(new
                {
                    success = true,
                    startDate = filterDataModel.StartDate,
                    endDate = filterDataModel.EndDate,
                    parent = filterDataModel.Parent,
                    grade = filterDataModel.Grade,
                    empType = filterDataModel.EmpType,
                    officeLocationCode = filterDataModel.OfficeLocationCode
                });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        #endregion filter
    }
}
