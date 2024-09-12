using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Repositories.SWPVaccine;
using TCMPLApp.Domain.Models.SWPVaccine;
using TCMPLApp.WebApp.Controllers;
using TCMPLApp.WebApp.CustomPolicyProvider;
using TCMPLApp.WebApp.Models;

namespace TCMPLApp.WebApp.Areas.SWP.Controllers
{
    [Area("SWPVaccine")]
    [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SWPVaccineHelper.RoleSWPVaccineHR)]

    public class EmployeeTrainingController : BaseController
    {
        private readonly IEmployeeTrainingRepository _employeeTrainingRepository;
        private readonly IUploadExcelBLobRepository _uploadExcelBLobRepository;

        public EmployeeTrainingController(IEmployeeTrainingRepository employeeTrainingRepository, IUploadExcelBLobRepository uploadExcelBLobRepository)
        {
            _employeeTrainingRepository = employeeTrainingRepository;
            _uploadExcelBLobRepository = uploadExcelBLobRepository;
        }


        public IActionResult Index()
        {
            //try
            //{
            //    var empTrainings = await _employeeTrainingRepository.GetEmployeeTrainings();

            //    return View(empTrainings);
            //}
            //catch (Exception ex)
            //{
            //    Notify("Error", ex.Message, "toaster", notificationType: NotificationType.error);
            //}

            return View();
        }

        public async Task<IActionResult> GetAllTrainings()
        {
            var empTrainings = await _employeeTrainingRepository.GetEmployeeTrainings();

            return PartialView("_TrainingListPartial", empTrainings);

        }

        public IActionResult TrainingFileUpload()
        {
            return PartialView("_ImportTrainingsPartialView");
        }

        [HttpPost]
        public async Task<IActionResult> TrainingFileUpload(IFormFile file)
        {
            try
            {
                if (file.Length == 0)
                {
                    return Json(new { success = false, message = "Excel file not selected." });
                }

                byte[] data = null;

                using (var ms = new MemoryStream())
                {
                    file.CopyTo(ms);
                    data = ms.ToArray();
                }

                UploadExcelFileToDb uploadExcelFile = new UploadExcelFileToDb
                {
                    PBlob = data
                };
                var retVal = await _uploadExcelBLobRepository.UploadSchedule(uploadExcelFile);


                return Json(new { success = retVal.OutPSuccess == "OK", message = retVal.OutPSuccess == "OK" ? "Data uploaded successfully." : retVal.OutPMessage });


            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = ex.Message });
            }
        }

    }
}
