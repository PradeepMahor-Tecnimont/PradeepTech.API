using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using MimeTypes;
using Newtonsoft.Json;
using System;
using System.IO;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.Common;
using TCMPLApp.DataAccess.Repositories.EmpGenInfo;
using TCMPLApp.DataAccess.Repositories.SWPVaccine;
using TCMPLApp.Domain.Models.EmpGenInfo;
using TCMPLApp.Domain.Models.SWPVaccine;
using TCMPLApp.WebApp.Classes;
using TCMPLApp.WebApp.Controllers;
using TCMPLApp.WebApp.CustomPolicyProvider;
using TCMPLApp.WebApp.Models;
using static TCMPLApp.WebApp.Classes.DTModel;


namespace TCMPLApp.WebApp.Areas.EmpGenInfo.Controllers
{
    [Authorize]
    [Area("EmpGenInfo")]
    public class IcardConsentController : BaseController
    {
        private const string ConstFilterIcardConsentStatusIndex = "IcardConsentStatusIndex";

        private readonly IConfiguration _configuration;
        private readonly IEmployeeDetailsRepository _employeeDetailsRepository;
        private readonly IIcardConsentDetailsRepository _iCardConsentDetailsRepository;
        private readonly IICardConsentUpdateRepository _iCardConsentUpdateRepository;
        private readonly IIcardConsentPhotoImportRepository _icardConsentPhotoImportRepository;
        private readonly IFilterRepository _filterRepository;
        private readonly IICardConsentDataTableListRepository _iCardConsentDataTableListRepository;
        private readonly IICardConsentXLDataTableListRepository _iCardConsentXLDataTableListRepository;
        private readonly IUtilityRepository _utilityRepository;
        private readonly ICommonEmployeeDetailsRepository _commonEmployeeDetailsRepository;

        public IcardConsentController(IConfiguration configuration,
                                      IEmployeeDetailsRepository employeeDetailsRepository,
                                      IIcardConsentDetailsRepository iCardConsentDetailsRepository,
                                      IICardConsentUpdateRepository iCardConsentUpdateRepository,
                                      IIcardConsentPhotoImportRepository icardConsentPhotoImportRepository,
                                      IFilterRepository filterRepository,
                                      IICardConsentDataTableListRepository iCardConsentDataTableListRepository,
                                      IICardConsentXLDataTableListRepository iCardConsentXLDataTableListRepository,
                                      IUtilityRepository utilityRepository,
                                      ICommonEmployeeDetailsRepository commonEmployeeDetailsRepository)
        {
            _configuration = configuration;
            _employeeDetailsRepository = employeeDetailsRepository;
            _iCardConsentDetailsRepository = iCardConsentDetailsRepository;
            _iCardConsentUpdateRepository = iCardConsentUpdateRepository;
            _icardConsentPhotoImportRepository = icardConsentPhotoImportRepository;
            _filterRepository = filterRepository;
            _iCardConsentDataTableListRepository = iCardConsentDataTableListRepository;
            _utilityRepository = utilityRepository;
            _iCardConsentXLDataTableListRepository = iCardConsentXLDataTableListRepository;
            _commonEmployeeDetailsRepository = commonEmployeeDetailsRepository;
        }

        #region ICard Consent Form
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionICardPhotoConsent)]
        public async Task<IActionResult> Index()
        {
            var employeeDetails = await _commonEmployeeDetailsRepository.EmployeeDetailAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            if (!(employeeDetails.PEmpType == "R" || employeeDetails.PEmpType == "F" || employeeDetails.PEmpType == "C"))
            {
                return Unauthorized("Employee type not valid");
            }
                
            string empno = employeeDetails.PForEmpno;

            var baseRepository = _configuration["TCMPLAppBaseRepository"];
            var areaRepository = _configuration["AreaRepository:ICardPhoto"];
            var photoPath = Path.Combine(baseRepository, areaRepository, empno + ".jpg");

            string photoExists = NotOk;

            if (System.IO.File.Exists(photoPath))
            {
                photoExists = IsOk;
            }
            else
            {
                string noPhotoPath = Path.Combine(baseRepository, areaRepository, "nouser.jpg");
            }

            ViewData["Emnpno"] = empno;
            ViewData["PhotoExists"] = photoExists;
            ViewData["PhotoPathUrl"] = photoPath;            
            
            var result = await _iCardConsentDetailsRepository.IcardConsentDetailsAsync(
            BaseSpTcmPLGet(),
            new ParameterSpTcmPL
            {
                PEmpno = empno
            });
            result.PEmployee = String.IsNullOrEmpty(result.PEmployee) ? employeeDetails.PForEmpno + " - " + employeeDetails.PName : result.PEmployee;

            return View(result);
            
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionICardPhotoConsent)]
        public string GetEmployeePhoto(string id)
        {
            var baseRepository = _configuration["TCMPLAppBaseRepository"];
            var areaRepository = _configuration["AreaRepository:ICardPhoto"];
            string photoPath = Path.Combine(baseRepository, areaRepository, id + ".jpg");
            string noPhotoPath = Path.Combine(baseRepository, areaRepository, "nouser.jpg");

            byte[] templateBytes;

            if (System.IO.File.Exists(photoPath))
            {
                templateBytes = System.IO.File.ReadAllBytes(photoPath);
            }
            else
            {
                templateBytes = System.IO.File.ReadAllBytes(noPhotoPath);
            }

            string imgBase64Data = Convert.ToBase64String(templateBytes);
            string imgDataURL = string.Format("data:image/jpg;base64,{0}", imgBase64Data);

            return imgDataURL;
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionICardPhotoConsent)]
        public string GetSampleICard()
        {
            var baseRepository = _configuration["TCMPLAppBaseRepository"];
            var areaRepository = _configuration["AreaRepository:ICardPhoto"];
            string sampleICardPath = Path.Combine(baseRepository, areaRepository, "sample_icard.jpg");
            byte[] sampleICardBytes = System.IO.File.ReadAllBytes(sampleICardPath);
            string imgBase64Data = Convert.ToBase64String(sampleICardBytes);
            string imgDataURL = string.Format("data:image/jpg;base64,{0}", imgBase64Data);
            return imgDataURL;
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionICardPhotoConsent)]
        public void CopyPhotoConsentFile(string empno)
        {
            var baseRepository = _configuration["TCMPLAppBaseRepository"];
            var areaRepository = _configuration["AreaRepository:ICardPhoto"];
            string sourcePath = Path.Combine(baseRepository, areaRepository, empno + ".jpg");

            var targetAreaRepository = _configuration["AreaRepository:ICardPhotoConsented"];
            string targetPath = Path.Combine(baseRepository, targetAreaRepository, empno + ".jpg");

            if (System.IO.File.Exists(targetPath))
            {
                // if exists then remove file
            }
            else
            {
                System.IO.File.Copy(sourcePath, targetPath);
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionICardPhotoConsent)]
        public async Task<IActionResult> ConsentSave([FromForm] ICardConsentUpdate icardConsentUpdate)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    if (icardConsentUpdate.IsConsent == NotOk || icardConsentUpdate.IsConsent == null)
                    {
                        Notify("Error", "Please select 'I agree with this image to be printed on my new ICard' ", "toaster", NotificationType.error);
                    }
                    else
                    {
                        if (icardConsentUpdate.IsConsent == IsOk)
                        {
                            CopyPhotoConsentFile(icardConsentUpdate.Empno);
                        }
                        Domain.Models.Common.DBProcMessageOutput result = await _iCardConsentUpdateRepository.IcardConsentUpdateAsync(
                            BaseSpTcmPLGet(),
                            new ParameterSpTcmPL
                            {
                                PIsConsent = icardConsentUpdate.IsConsent.ToString()
                            });

                        if (result.PMessageType != "OK")
                        {
                            Notify("Error", result.PMessageText.Replace("-", " "), "toaster", NotificationType.error);
                        }
                        else
                        {
                            Notify("Success", result.PMessageText.Replace("-", " "), "toaster", NotificationType.success);
                        }
                    }
                }

                return RedirectToAction("Index");
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        #endregion  ICard Consent Form

        #region Photo upload

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionICardPhotoConsent)]
        public async Task<IActionResult> ICardConsentPhotoUpload()
        {
            //string empno = CurrentUserIdentity.EmpNo;
            //EmployeeDetails employeeDetail = await _employeeDetailsRepository.GetEmployeeDetailsAsync(empno);
            var employeeDetail = await _commonEmployeeDetailsRepository.EmployeeDetailAsync(
                BaseSpTcmPLGet(),
                null);
            ViewData["Empno"] = employeeDetail.PForEmpno;
            ViewData["Name"] = employeeDetail.PName;
            return PartialView("_ModalICardConsentPhotoUpload");
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionICardPhotoConsent)]
        public async Task<IActionResult> ICardConsentPhotoUpload(IFormFile file)
        {
            try
            {
                if (file == null || file.Length == 0)
                    return Json(new { success = false, response = "File not uploaded due to unrecongnised parameters" });

                FileInfo fileInfo = new FileInfo(file.FileName);
                string empno = CurrentUserIdentity.EmpNo;
        
                // Check file validation
                if (!fileInfo.Extension.ToUpper().Contains("JPG"))
                    return Json(new { success = false, response = "Jpg file not recognized" });

                var baseRepository = _configuration["TCMPLAppBaseRepository"];
                var areaRepository = _configuration["AreaRepository:ICardPhoto"];
                var folder = Path.Combine(baseRepository, areaRepository);
                var fileName = empno + Path.GetExtension(file.FileName);

                var fileNamePath = Path.Combine(folder, fileName);
                if (System.IO.File.Exists(fileNamePath))
                    System.IO.File.Delete(fileNamePath);

                using (Stream fileStream = new FileStream(fileNamePath, FileMode.Create))
                {
                    await file.CopyToAsync(fileStream);
                }

                var uploadOutPut = await _icardConsentPhotoImportRepository.ImportIcardPhotoAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {

                        }
                    );

                if (uploadOutPut.PMessageType != IsOk)
                {
                    var resultJsonError = new
                    {
                        success = false,
                        response = uploadOutPut.PMessageText
                    };

                    return Json(resultJsonError);
                }
                else
                {
                    var resultJson = new
                    {
                        success = true,
                        response = "ICard photo uploaded successfully"
                    };

                    return Json(resultJson);
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

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionICardPhotoConsent)]
        public async Task<IActionResult> EnableConsentConfirm(string id)
        {
            try
            {
                var result = await _iCardConsentDetailsRepository.IcardConsentDetailsAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PEmpno = id
                });
                return Json(result);
            }
            catch (Exception ex)
            {
                return NotFound(ex);
            }
        }

        #endregion Photo Upload

        #region HR Reports
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionICardPhotoConsentHR)]
        public async Task<IActionResult> IcardConsentStatusIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterIcardConsentStatusIndex
            });

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            HRICardConsentStatusViewModel hRICardConsentStatusViewModel = new()
            {
                FilterDataModel = filterDataModel
            };
            return View(hRICardConsentStatusViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionICardPhotoConsentHR)]
        public async Task<JsonResult> GetListsICardConsent(string paramJson)
        {
            DTResult<ICardConsentStatusDataTableList> result = new();
            int totalRow = 0;
            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            try
            {
                System.Collections.Generic.IEnumerable<ICardConsentStatusDataTableList> data = await _iCardConsentDataTableListRepository.ICardConsentStatusDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch,
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

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionICardPhotoConsentHR)]
        public async Task<IActionResult> ICardConsentStatusExcelDownload()
        {
            try
            {
                var timeStamp = DateTime.Now.ToFileTime();
                string fileName = "ICard Consent Status Details_" + timeStamp.ToString();
                string reportTitle = "ICard Consent Status Details ";
                string sheetName = "ICard Consent Status Details";

                var excelData = await _iCardConsentXLDataTableListRepository.ICardConsentStatusXLDataTableListAsync(
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

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionICardPhotoConsentHR)]
        public async Task<IActionResult> RevokeConsent(string id)
        {
            try
            {
                var result = await _iCardConsentUpdateRepository.IcardConsentUpdateAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PEmpno = id,
                        PIsConsent = "KO"
                    });

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        #endregion HR Reports
    }
}