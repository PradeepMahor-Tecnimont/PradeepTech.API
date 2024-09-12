using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using System;
using System.IO;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.Attendance;
using TCMPLApp.DataAccess.Repositories.ERS;
using TCMPLApp.Domain.Models;
using TCMPLApp.Domain.Models.ERS;
using TCMPLApp.WebApp.Classes;
using TCMPLApp.WebApp.Controllers;
using TCMPLApp.WebApp.CustomPolicyProvider;
using TCMPLApp.WebApp.Models;
using static TCMPLApp.WebApp.Classes.DTModel;

namespace TCMPLApp.WebApp.Areas.ERS.Controllers
{
    [Area("ERS")]

    public class UserController : BaseController
    {

        private readonly IConfiguration _configuration;
        private readonly IVacanciesDataTableListRepository _vacanciesDataTableListRepository;
        private readonly IUploadedCVDataTableListRepository _uploadedCVDataTableListRepository;
        private readonly IVacancyDetailRepository _vacancyDetailRepository;
        private readonly IVacancyRepository _vacancyRepository;
        private readonly IAttendanceEmployeeDetailsRepository _attendanceEmployeeDetailsRepository;

        public UserController(IConfiguration configuration,
             IVacanciesDataTableListRepository vacanciesDataTableListRepository,
             IUploadedCVDataTableListRepository uploadedCVDataTableListRepository,
             IVacancyDetailRepository vacancyDetailRepository,
             IVacancyRepository vacancyRepository,
             IAttendanceEmployeeDetailsRepository attendanceEmployeeDetailsRepository)
        {
            _configuration = configuration;
            _vacanciesDataTableListRepository = vacanciesDataTableListRepository;
            _uploadedCVDataTableListRepository = uploadedCVDataTableListRepository;
            _vacancyDetailRepository = vacancyDetailRepository;
            _vacancyRepository = vacancyRepository;
            _attendanceEmployeeDetailsRepository = attendanceEmployeeDetailsRepository;
        }

        #region Vacancies
        public IActionResult VacanciesIndex()
        {
            if (!(CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.ERS.ERSHelper.ActionEmpType_R_F)))
            {
                return Forbid();
            }

            return View();
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, ERSHelper.ActionEmpType_R_F)]
        public async Task<JsonResult> GetVacanciesList(DTParameters param)
        {
            int totalRow = 0;

            DTResult<VacanciesDataTableList> result = new DTResult<VacanciesDataTableList>();

            try
            {
                var data = await _vacanciesDataTableListRepository.VacanciesDataTableList(
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
                return Json(new
                {
                    error = ex.Message
                });
            }
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, ERSHelper.ActionEmpType_R_F)]
        public async Task<IActionResult> VacancyDetail(string id)
        {
            if (id == null)
                return NotFound();

            UserIdentity currentUserIdentity = CurrentUserIdentity;
            var result = await _vacancyDetailRepository.VacancyDetail(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PJobKeyId = id
                });

            VacancyDetailViewModel vacancyDetail = new VacancyDetailViewModel();

            if (result.PMessageType == IsOk)
            {
                vacancyDetail.JobKeyId = id;
                vacancyDetail.JobReferenceCode = result.PJobRefCode;
                vacancyDetail.JobOpenDate = result.PJobOpenDate;
                vacancyDetail.JobType = result.PJobType;
                vacancyDetail.JobLocation = result.PJobLocation;
                vacancyDetail.ShortDesc = result.PShortDesc;
                vacancyDetail.JobDesc01 = result.PJobDesc01;
                vacancyDetail.JobDesc02 = result.PJobDesc02;
                vacancyDetail.JobDesc03 = result.PJobDesc03;
            }

            return PartialView("_ModalVacancyDetailPartial", vacancyDetail);

        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, ERSHelper.ActionEmpType_R_F)]
        public async Task<IActionResult> VacancyRefer(string id)
        {
            if (id == null)
                return NotFound();

            VacancyReferViewModel vacancyReferViewModel = new VacancyReferViewModel();

            vacancyReferViewModel.VacancyJobKeyId = id;

            var vacancyDetail = await _vacancyDetailRepository.VacancyDetail(
               BaseSpTcmPLGet(),
               new ParameterSpTcmPL
               {
                   PJobKeyId = id
               });

            ViewData["JobReferenceCode"] = vacancyDetail.PJobRefCode;
            ViewData["JobOpenDate"] = vacancyDetail.PJobOpenDate;
            ViewData["ShortDesc"] = vacancyDetail.PShortDesc;
            ViewData["JobType"] = vacancyDetail.PJobType;
            ViewData["JobLocation"] = vacancyDetail.PJobLocation;
            ViewData["JobDesc01"] = vacancyDetail.PJobDesc01;

            return PartialView("_ModalReferVacancyPartial", vacancyReferViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, ERSHelper.ActionEmpType_R_F)]
        public async Task<IActionResult> VacancyRefer([FromForm] VacancyReferViewModel vacancyReferViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    string serverFileName = "";
                    string displayFileName = "";

                    var selfDetail = await _attendanceEmployeeDetailsRepository.AttendanceEmployeeDetailsAsync(BaseSpTcmPLGet(), null);


                    var resultValidate = await _vacancyRepository.VacancyReferValidate(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PJobKeyId = vacancyReferViewModel.VacancyJobKeyId,
                            PPan = vacancyReferViewModel.Pan
                        });

                    if (resultValidate.PMessageType != IsOk)
                    {
                        //throw new Exception(result.PMessageText.Replace("-", " "));

                        if (resultValidate.PMessageText.ToString().ToUpper().Contains("UNIQUE"))
                        {
                            throw new Exception("CV already exists... !!!");
                        }
                        else
                        {
                            throw new Exception(resultValidate.PMessageText.Replace("-", " "));
                        }                        
                    }
                    else
                    {
                        if (vacancyReferViewModel.file != null)
                        {
                            displayFileName = vacancyReferViewModel.file.FileName;
                            serverFileName = await StorageHelper.SaveFileAsync(StorageHelper.ERS.Repository, selfDetail.Empno, StorageHelper.ERS.Group, vacancyReferViewModel.file, Configuration);
                        }

                        var result = await _vacancyRepository.VacancyReferAsync(
                            BaseSpTcmPLGet(),
                            new ParameterSpTcmPL
                            {
                                PJobKeyId = vacancyReferViewModel.VacancyJobKeyId,
                                PPan = vacancyReferViewModel.Pan,
                                PCandidateName = vacancyReferViewModel.CandidateName,
                                PCandidateEmail = vacancyReferViewModel.CandidateEmail,
                                PCandidateMobile = vacancyReferViewModel.CandidateMobile,
                                PErsCvDispName = displayFileName,
                                PErsCvOsName = serverFileName
                            });

                        if (result.PMessageType != IsOk)
                        {
                            //throw new Exception(result.PMessageText.Replace("-", " "));

                            if (resultValidate.PMessageText.ToString().ToUpper().Contains("UNIQUE"))
                            {
                                throw new Exception("CV already exists... !!!");
                            }
                            else
                            {
                                throw new Exception(resultValidate.PMessageText.Replace("-", " "));
                            }
                        }
                        else
                        {
                            return Json(new { success = result.PMessageType == IsOk, response = result.PMessageText });
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            var vacancyDetail = await _vacancyDetailRepository.VacancyDetail(
                   BaseSpTcmPLGet(),
                   new ParameterSpTcmPL
                   {
                       PJobKeyId = vacancyReferViewModel.VacancyJobKeyId
                   });

            ViewData["JobReferenceCode"] = vacancyDetail.PJobRefCode;

            return PartialView("_ModalReferVacancyPartial", vacancyReferViewModel);
        }

        #endregion Vacancies

        #region Uploaded CVs
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, ERSHelper.ActionEmpType_R_F)]
        public IActionResult UploadedCVIndex()
        {
            return View();
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, ERSHelper.ActionEmpType_R_F)]
        public async Task<JsonResult> GetUploadedCVList(DTParameters param)
        {
            int totalRow = 0;

            DTResult<UploadedCVDataTableList> result = new DTResult<UploadedCVDataTableList>();

            try
            {
                var data = await _uploadedCVDataTableListRepository.UploadedCVDataTableList(
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
                return Json(new
                {
                    error = ex.Message
                });
            }
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, ERSHelper.ActionEmpType_R_F)]
        public async Task<IActionResult> VacancyReferDelete(string id)
        {
            if (id == null)
                return NotFound();

            try
            {
                var result = await _vacancyRepository.VacancyReferDeleteAsync(BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PJobKeyId = id.Split("!-!")[0],
                            PCandidateEmail = id.Split("!-!")[1]
                        });

                if (result.PMessageType == "OK")
                {
                    return Json(new { success = "OK", response = result.PMessageText });
                }
                else
                {
                    throw new Exception(result.PMessageText.Replace("-", " "));
                }
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = ex.Message });
            }
        }

        [HttpGet]        
        public IActionResult DownloadCandidateCV(string KeyId)
        { 
            if (string.IsNullOrEmpty(KeyId))
                return NotFound();

            try
            {
                var baseRepository = _configuration["TCMPLAppBaseRepository"];
                var areaRepository = _configuration["AreaRepository:EmployeeReferalScheme"];
                var folder = Path.Combine(baseRepository, areaRepository);
                var file = Path.Combine(folder, KeyId.Split("!-!")[0].ToString());

                //var fName = KeyId.Split("!-!")[1].ToString() + "_" + KeyId.Split("!-!")[2].ToString() + "_" + KeyId.Split("!-!")[3].ToString() + ".pdf";
                var fName = KeyId.Split("!-!")[1].ToString() + "_" + KeyId.Split("!-!")[3].ToString() + ".pdf";

                byte[] bytes = System.IO.File.ReadAllBytes(file);

                return File(bytes, "application/octet-stream", fName);
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = ex.Message });
            }
        }

        #endregion Uploaded CVs
    }
}
