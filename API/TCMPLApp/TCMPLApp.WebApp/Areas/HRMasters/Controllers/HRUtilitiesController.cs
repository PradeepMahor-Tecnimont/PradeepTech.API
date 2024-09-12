using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using MimeTypes;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.Common;
using TCMPLApp.DataAccess.Repositories.HRMasters;
using TCMPLApp.Domain.Models.HRMasters;
using TCMPLApp.Library.Excel.Template;
using TCMPLApp.Library.Excel.Template.Models;
using TCMPLApp.WebApp.Areas.HRMasters.Models;
using TCMPLApp.WebApp.Controllers;
//using TCMPLApp.WebApp.Lib.Models;
using TCMPLApp.WebApp.Models;
using static TCMPLApp.WebApp.Classes.DTModel;

namespace TCMPLApp.WebApp.Areas.HRMasters.Controllers
{
    [Area("HRMasters")]
    public class HRUtilitiesController : BaseController
    {

        private readonly ISelectRepository _selectRepository;
        private readonly ICostCenterMasterMainRepository _costCenterMasterMainRepository;
        private readonly IHRUtilitiesRepository _hrUtilitiesRepository;
        private readonly IExcelTemplate _excelTemplate;
        private readonly IEmployeeDeleteDataTableListRepository _employeeDeleteDataTableListRepository;
        private readonly IEmployeeDeleteRepository _employeeDeleteRepository;
        private readonly IHRMastersCustomImportRepository _hrmastersCustomImportRepository;

        public HRUtilitiesController(
            ISelectRepository selectRepository,
            ICostCenterMasterMainRepository costCenterMasterMainRepository,
            IHRUtilitiesRepository hrUtilitiesRepository,
            IExcelTemplate excelTemplate,
            IEmployeeDeleteDataTableListRepository employeeDeleteDataTableListRepository,
            IEmployeeDeleteRepository employeeDeleteRepository,
            IHRMastersCustomImportRepository hrmastersCustomImportRepository
            )
        {
            _selectRepository = selectRepository;
            _costCenterMasterMainRepository = costCenterMasterMainRepository;
            _hrUtilitiesRepository = hrUtilitiesRepository;
            _excelTemplate = excelTemplate;
            _employeeDeleteDataTableListRepository = employeeDeleteDataTableListRepository;
            _employeeDeleteRepository = employeeDeleteRepository;
            _hrmastersCustomImportRepository = hrmastersCustomImportRepository;
        }

        #region >>>>>>>>>>> Bulk HoD  / Manager change  <<<<<<<<<<<<<<

        public async Task<IActionResult> BulkHoDMngrChange()
        {
            BulkHoDMngrChangeViewModel bulkHoDMngrChangeViewModel = new BulkHoDMngrChangeViewModel();

            var employees = await _selectRepository.EmployeeSelectListCacheAsync();

            ViewData["HoDMngr"] = new SelectList(employees, "DataValueField", "DataTextField");

            return PartialView("_ModalBulkHoDMngrChange", bulkHoDMngrChangeViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> BulkHoDMngrChange([FromForm] BulkHoDMngrChangeViewModel bulkHoDMngrChangeViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    BulkHoDMngrUpdate bulkHoDMngrUpdate = new BulkHoDMngrUpdate
                    {
                        PHodMngrOld = bulkHoDMngrChangeViewModel.HodMngrOld,
                        PHodMngrNew = bulkHoDMngrChangeViewModel.HodMngrNew,
                        PType = bulkHoDMngrChangeViewModel.Changetype
                    };

                    var retVal = await _hrUtilitiesRepository.BulkHoDMngrEdit(bulkHoDMngrUpdate);

                    if (retVal.OutPSuccess == "OK")
                    {
                        Notify("Success", retVal.OutPMessage, "toaster", NotificationType.success);
                    }
                    else
                    {
                        Notify("Error", retVal.OutPMessage, "toaster", NotificationType.error);
                    }
                }
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
                return PartialView("_ModalHolidayCreatePartial", bulkHoDMngrChangeViewModel);
            }

            return Json(new { });
        }

        #endregion >>>>>>>>>>> Bulk HoD / Manager change <<<<<<<<<<<<<<


        #region >>>>>>>>>>> Employee Delete  <<<<<<<<<<<<<<

        [HttpGet]        
        public IActionResult EmployeeDeleteIndex()
        {
            return View();
        }

        [HttpGet]
        [ValidateAntiForgeryToken]        
        public async Task<JsonResult> GetEmployeeDeleteList(string paramJSon)
        {
            int totalRow = 0;

            DTResult<EmployeeDeleteDataTableList> result = new();

            try
            {
                DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJSon);
                IEnumerable<EmployeeDeleteDataTableList> data = await _employeeDeleteDataTableListRepository.GetEmployeeDeleteDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
                        PGenericSearch = param.GenericSearch ?? " "
                    }
                );

                if (data.Any())
                {
                    totalRow = data.Count();
                }

                result.draw = param.Draw;
                result.recordsTotal = totalRow;
                result.recordsFiltered = totalRow;
                result.data = data.ToList();

                return Json(result);
            }
            catch (Exception ex)
            {
                return Json(new
                {
                    error = ex.Message
                });
            }
        }


        public IActionResult EmployeeDeleteRequest()
        {
            EmployeeDeleteCreate employeeDeleteCreate = new EmployeeDeleteCreate();

            return PartialView("_ModalEmployeeDeleteRequestPartial", employeeDeleteCreate);
        }

        [HttpPost]
        public async Task<IActionResult> EmployeeDeleteRequest([FromForm] EmployeeDeleteCreate employeeDeleteCreate)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var retVal = await _employeeDeleteRepository.EmployeeDeleteRequestCreate(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PEmpno = employeeDeleteCreate.Empno
                        });                                        

                    if (retVal.PMessageType == IsOk)
                    {
                        Notify("Success", retVal.PMessageText, "toaster", NotificationType.success);
                    }
                    else
                    {
                        Notify("Error", retVal.PMessageText, "toaster", NotificationType.error);
                    }
                }
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
                return PartialView("_ModalEmployeeDeleteRequestPartial", employeeDeleteCreate);
            }
            
            return Json(new { });            
        }

        [HttpPost]
        public async Task<IActionResult> EmployeeDeleteRequestApprove(string id)
        {
            if (id == null)
                return NotFound();

            try
            {
                var retVal = await _employeeDeleteRepository.EmployeeDeleteRequestApproval(
                       BaseSpTcmPLGet(),
                       new ParameterSpTcmPL
                       {
                           PKeyId = id
                       });


                if (retVal.PMessageType == IsOk)
                {
                    return Json(new { success = retVal.PMessageType == "OK", response = retVal.PMessageType, message = retVal.PMessageText });
                }
                else
                {
                    throw new Exception(retVal.PMessageText.Replace("-", " "));
                }
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        [HttpPost]
        public async Task<IActionResult> EmployeeDeleteRequestDelete(string id)
        {
            if (id == null)
                return NotFound();

            try
            {                
                var retVal = await _employeeDeleteRepository.EmployeeDeleteRequestDelete(
                       BaseSpTcmPLGet(),
                       new ParameterSpTcmPL
                       {
                            PKeyId = id
                       });

                if (retVal.PMessageType == IsOk)
                {
                    return Json(new { success = retVal.PMessageType == "OK", response = retVal.PMessageType, message = retVal.PMessageText });
                }
                else
                {
                    throw new Exception(retVal.PMessageText.Replace("-", " "));
                }               
            }
            catch (Exception ex)
            {                
                return Json(new { success = false, response = ex.Message });
            }
            
        }


        #endregion >>>>>>>>>>> Employee Delete <<<<<<<<<<<<<<


        #region >>>>>>>>>>> HR Masters Custom Excel Import <<<<<<<<<<<<<<

        [HttpGet]
        public IActionResult CustomImport()
        {
            return PartialView("_ModalBulkImportPartial");
        }

        public IActionResult CustomXLTemplateDownload()
        {
            var dictionaryItems = new List<Library.Excel.Template.Models.DictionaryItem>();

            Stream ms = _excelTemplate.ExportHRMastersCustom("v01",
                    new Library.Excel.Template.Models.DictionaryCollection
                    {
                        DictionaryItems = dictionaryItems
                    },
                500);
            var fileName = "ImportHRMasterCustomData.xlsx";
            var mimeType = MimeTypeMap.GetMimeType("xlsx");

            ms.Position = 0;
            return File(ms, mimeType, fileName);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> CustomXLUpload(IFormFile file)
        {
            try
            {
                if (file == null || file.Length == 0)
                    return Json(new { success = false, response = "File not uploaded due to unrecongnised parameters" });


                FileInfo fileInfo = new FileInfo(file.FileName);

                Guid storageId = Guid.NewGuid();
                var stream = file.OpenReadStream();
                var fileName = file.FileName;
                var fileSize = file.Length;
                var mimeType = MimeTypeMap.GetMimeType(fileInfo.Extension);
                string fileNameErrors = Path.GetFileNameWithoutExtension(fileInfo.Name) + "-Err" + fileInfo.Extension;
                                
                if (!fileInfo.Extension.Contains("xls"))
                    return Json(new { success = false, response = "Excel file not recognized" });
                                
                string json = string.Empty;
                
                List<EmployeeCustom> employeeItems = _excelTemplate.ImportHRMastersCustom(stream);
                
                string jsonString = JsonConvert.SerializeObject(employeeItems);
                byte[] byteArray = Encoding.ASCII.GetBytes(jsonString);

                var uploadOutPut = await _hrmastersCustomImportRepository.ImportHRMastersCustomAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PEmployeesJson = byteArray
                        }
                    );

                var employeeErrors = JsonConvert.SerializeObject(uploadOutPut.PEmployeesErrors);
                ImportFileResultViewModel importFileResult = new();
                IEnumerable<ImportFileResultViewModel> importFileResults = JsonConvert.DeserializeObject<IEnumerable<ImportFileResultViewModel>>(employeeErrors);

                List<Library.Excel.Template.Models.ValidationItem> validationItems = new List<Library.Excel.Template.Models.ValidationItem>();

                if (importFileResults?.Count() > 0)
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

                if (uploadOutPut.PMessageType != BaseController.IsOk)
                {
                    if (importFileResults.Count() > 0)
                    {
                        var streamError = _excelTemplate.ValidateImport(stream, validationItems);
                        FileContentResult fileContentResult = base.File(streamError.ToArray(), mimeType, fileNameErrors);

                        var resultJsonError = new
                        {
                            success = false,
                            response = uploadOutPut.PMessageText,
                            data = importFileResults,
                            fileContent = fileContentResult
                        };

                        return base.Json(resultJsonError);
                    }
                    else
                    {
                        var resultJsonError = new
                        {
                            success = false,
                            response = uploadOutPut.PMessageText,
                            data = importFileResults
                        };

                        return base.Json(resultJsonError);
                    }
                }
                else
                {
                    var resultJson = new
                    {
                        success = true,
                        response = "Import data successfully executed"
                    };

                    return base.Json(resultJson);
                }
            }
            catch (Exception ex)
            {
                var resultJson = new
                {
                    success = false,
                    response = ex.Message
                };

                return Json(resultJson);
            }
        }

        #endregion

    }
}
