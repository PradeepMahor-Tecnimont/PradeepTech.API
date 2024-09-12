using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Repositories.SWPVaccine;
using TCMPLApp.Domain.Models;
using TCMPLApp.Domain.Models.SWPVaccine;
using TCMPLApp.WebApp.Controllers;
using TCMPLApp.WebApp.CustomPolicyProvider;

namespace TCMPLApp.WebApp.Areas.SWP.Controllers
{
    [Area("SWPVaccine")]

    [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SWPVaccineHelper.RoleSWPVaccineGense)]

    public class TPLVaccineBatchController : BaseController
    {
        ISwpTplVaccineBatchRepository _swpTplVaccineBatchRepository;
        ISwpTplVaccineBatchDetailsRepository _swpTplVaccineBatchDetailsRepository;
        IUploadExcelBLobRepository _tplVaccineBatchImportBatchEmpRepository;

        public TPLVaccineBatchController(
                ISwpTplVaccineBatchRepository swpTplVaccineBatchRepository,
                ISwpTplVaccineBatchDetailsRepository swpTplVaccineBatchDetailsRepository,
                IUploadExcelBLobRepository tplVaccineBatchImportBatchEmpRepository
            )
        {
            _swpTplVaccineBatchRepository = swpTplVaccineBatchRepository;
            _swpTplVaccineBatchDetailsRepository = swpTplVaccineBatchDetailsRepository;
            _tplVaccineBatchImportBatchEmpRepository = tplVaccineBatchImportBatchEmpRepository;
        }

        public IActionResult Index()
        {
            //var openBatch = await _swpTplVaccineBatchRepository.GetAsync(o => o.IsOpen == "OK");

            //ViewData["OpenBatchDetails"] = openBatch?.VaccineDate;

            return View();
        }

        public async Task<IActionResult> GetOpenBatchDetails()
        {

            var tplVaccineBatch = await _swpTplVaccineBatchRepository.GetAsync(o => o.IsOpen == "OK");

            var vaccineBatchEmployeeDetails = await _swpTplVaccineBatchDetailsRepository.GetAllAsync(o => o.BatchKeyId == tplVaccineBatch.BatchKeyId);

            ViewData["TPLVaccineBatch"] = tplVaccineBatch;

            return PartialView("_OpenBatchPartialView", vaccineBatchEmployeeDetails);

        }

        [HttpGet]
        public async Task<IActionResult> ImportBatchEmployees(string batchID)
        {
            if (string.IsNullOrEmpty(batchID))
                return NotFound();

            var tplVaccineBatch = await _swpTplVaccineBatchRepository.GetAsync(o => o.BatchKeyId == batchID);

            ViewData["TPLVaccineBatch"] = tplVaccineBatch;

            return PartialView("_ImportBatchEmployeesPartialView");
        }

        [HttpPost]
        public async Task<IActionResult> ImportBatchEmployees(string batchID, IFormFile file)
        {
            if (string.IsNullOrEmpty(batchID))
                return NotFound();

            byte[] data = null;

            using (var ms = new MemoryStream())
            {
                file.CopyTo(ms);
                data = ms.ToArray();
            }
            var tplVaccineBatch = await _swpTplVaccineBatchRepository.GetAsync(o => o.BatchKeyId == batchID);

            UploadExcelFileToDb uploadExcelFile = new UploadExcelFileToDb
            {
                PBlob = data
            };
            var retVal = await _tplVaccineBatchImportBatchEmpRepository.UploadSchedule(uploadExcelFile);

            return Json(new ProcedureResult { Status = retVal.OutPSuccess, Message = "File successfully uploaded. " + retVal.OutPMessage });


            //return View();
        }


    }
}
