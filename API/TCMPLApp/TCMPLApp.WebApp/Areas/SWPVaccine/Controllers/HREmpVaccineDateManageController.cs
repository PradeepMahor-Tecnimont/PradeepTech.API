using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Repositories.SWPVaccine;
using TCMPLApp.WebApp.Models;
using System.Data;
using Microsoft.AspNetCore.Authorization;
using TCMPLApp.WebApp.Controllers;
using TCMPLApp.DataAccess.Models;
using Microsoft.AspNetCore.Mvc.Rendering;
using System.Net;
using TCMPLApp.WebApp.CustomPolicyProvider;
using TCMPLApp.Domain.Models.SWPVaccine;
using TCMPLApp.DataAccess.Repositories.Common;

namespace TCMPLApp.WebApp.Areas.SWP.Controllers
{
    [Area("SWPVaccine")]

    [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SWPVaccineHelper.RoleSWPVaccineHR)]
    public class HREmpVaccineDateManageController : BaseController
    {

        private readonly IHRVaccineDateManageRepository _hrVaccineDateManage;
        private readonly IEmployeeDetailsRepository _employeeDetailsRepository;

        private readonly IUtilityRepository _utilityRepository;
        private readonly IVaccinationSelfRepository _vaccineDateRepository;

        private readonly ICommonEmployeeDetailsRepository _commonEmployeeDetailsRepository;
        public HREmpVaccineDateManageController(IHRVaccineDateManageRepository hrVaccineDateManage,
            IEmployeeDetailsRepository employeeDetailsRepository,

             IUtilityRepository utilityRepository,
             IVaccinationSelfRepository vaccinationSelfRepository,

             ICommonEmployeeDetailsRepository commonEmployeeDetailsRepository
            )
        {
            _hrVaccineDateManage = hrVaccineDateManage;
            _utilityRepository = utilityRepository;
            _employeeDetailsRepository = employeeDetailsRepository;
            _vaccineDateRepository = vaccinationSelfRepository;
            _commonEmployeeDetailsRepository = commonEmployeeDetailsRepository;
        }
        public IActionResult Index()
        {
            //var empVaccineDateList = _hrVaccineDateManage.GetEmpVaccineDateList();
            //return View(empVaccineDateList.Result);
            return View();
        }

        [HttpGet]
        public IActionResult GetEmpVaccineDateList()
        {
            var empVaccineDateList = _hrVaccineDateManage.GetEmpVaccineDateList();
            return PartialView("_VaccineDateEmployeeList", empVaccineDateList);
        }


        [HttpPost]
        public async Task<IActionResult> DeleteEmpVaccineDates(string Empno)
        {
            try
            {
                if (string.IsNullOrEmpty(Empno))
                {
                    return Json(new { success = false, message = "Employee not found" });
                }

                var retVal = await _hrVaccineDateManage.DeleteEmpVaccineDates(Empno, User.Identity.Name);

                return Json(new { success = retVal.Status == "OK", message = retVal.Message });
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message, "toaster", notificationType: NotificationType.error);
                return Json(new { success = false, message = ex.Message });
            }
        }


        public IActionResult CreateEmpVaccineDetails()
        {

            var empList = _employeeDetailsRepository.GetEmployeeSelectAsync().ToList();

            ViewData["EmployeeList"] = new SelectList(empList, "Val", "Text", null);

            var vaccineTypes = _vaccineDateRepository.SelectListVaccineTypes();
            ViewData["VaccineTypes"] = new SelectList(vaccineTypes, "Val", "Text", null);

            return PartialView("_ModalCreateEmpVaccineDetailsPartial");
        }

        [HttpPost]
        public async Task< IActionResult> CreateEmpVaccineDetails(VaccineEmpCreateViewModel vaccineEmpCreateViewModel)
        {
            if (ModelState.IsValid)
            {
                try
                {
                    var retVal = await _hrVaccineDateManage.AddEmpVaccineDates(User.Identity.Name,
                        vaccineEmpCreateViewModel.Empno,
                        vaccineEmpCreateViewModel.VaccineType,
                        vaccineEmpCreateViewModel.FirstJab,
                        vaccineEmpCreateViewModel.SecondJab,
                        vaccineEmpCreateViewModel.BoosterJab
                        );
                    if(retVal.Status !="OK")
                        return StatusCode((int)HttpStatusCode.InternalServerError, retVal.Message);
                    else
                        return Json(new { success = retVal.Status == "OK", message = retVal.Message });

                }
                catch (Exception ex)
                {
                    return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
                }
            }
            var empList = _employeeDetailsRepository.GetEmployeeSelectAsync().ToList();

            ViewData["EmployeeList"] = new SelectList(empList, "Val", "Text", vaccineEmpCreateViewModel.Empno);

            var vaccineTypes = _vaccineDateRepository.SelectListVaccineTypes();
            ViewData["VaccineTypes"] = new SelectList(vaccineTypes, "Val", "Text", vaccineEmpCreateViewModel.VaccineType);

            return PartialView("_ModalCreateEmpVaccineDetailsPartial");
        }



        public async Task<IActionResult> EditEmpVaccineDetails(string Empno)
        {

            //var empDetails = await _employeeDetailsRepository.GetEmployeeDetailsAsync(Empno);
            var empDetails = await _commonEmployeeDetailsRepository.EmployeeDetailAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PEmpno = Empno
                });

            var empVaccineDetails = await _hrVaccineDateManage.EmpVaccineDateDetails(Empno);

            //var jabSponsorOffice = getListVaccineSponsor();
            //ViewData["JabSponsorOffice"] = new SelectList(jabSponsorOffice, "DataValueField", "DataTextField");

            VaccineEmpCreateViewModel vaccineEmpEdit = new VaccineEmpCreateViewModel
            {
                Empno = empVaccineDetails.Empno,
                FirstJab = empVaccineDetails.Jab1Date,
                SecondJab = empVaccineDetails.Jab2Date,
                FirstJabSponsorOffice = empVaccineDetails.IsJab1ByOffice,
                SecondJabSponsorOffice = empVaccineDetails.IsJab2ByOffice,
                BoosterJab = empVaccineDetails.BoosterJabDate,
                Name = empDetails.PName,
                VaccineType = empVaccineDetails.VaccineType
            };

            return PartialView("_ModalEditEmpVaccineDetailsPartial", vaccineEmpEdit);
        }

        [HttpPost]
        public async Task<IActionResult> EditEmpVaccineDetails(VaccineEmpCreateViewModel  vaccineEmpCreateViewModel)
        {
            if (ModelState.IsValid)
            {
                try
                {
                    if (string.IsNullOrEmpty(vaccineEmpCreateViewModel.Empno))
                        return Json(new { success = false, message = "Employee not found" });


                    var retVal = await _hrVaccineDateManage.UpdateEmpVaccineDates(User.Identity.Name, vaccineEmpCreateViewModel.Empno,
                         vaccineEmpCreateViewModel.SecondJab.GetValueOrDefault(),
                         vaccineEmpCreateViewModel.BoosterJab
                        );

                    if (retVal.Status == "OK")
                        return Json(new { success = true, message = retVal.Message });
                    else
                        Notify("Error", retVal.Message, "", notificationType: NotificationType.error);
                }
                catch (Exception ex)
                {
                    return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
                }
            }
            //var jabSponsorOffice = getListVaccineSponsor();
            //ViewData["JabSponsorOffice"] = new SelectList(jabSponsorOffice, "DataValueField", "DataTextField", vaccineEmpCreateViewModel.SecondJabSponsorOffice);
            return PartialView("_ModalEditEmpVaccineDetailsPartial", vaccineEmpCreateViewModel);
        }


        [HttpGet]
        public IActionResult ExcelDownload()
        {
            try
            {
                string strUser = User.Identity.Name;
                dynamic dt = _hrVaccineDateManage.GetEmpVaccineDateTable();

                var content = _utilityRepository.ExcelDownloadFromIEnumerable(dt, "Employee Vaccine Data", " Employee Vaccine Data");

                string StrFimeName = "EmployeeVaccineData_" + DateTime.Now.ToString("dd-MMM-yyyy");
                return File(
                   content,
                   "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                            StrFimeName + ".xlsx");
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message, "toaster", notificationType: NotificationType.error);
            }
            return RedirectToAction("Index");
        }

        //private List<DataField> getListVaccineSponsor()
        //{
        //    var list = new List<DataField>();
        //    list.Add(new DataField { DataTextField = "", DataValueField = "" });
        //    list.Add(new DataField { DataTextField = "Office", DataValueField = "OK" });
        //    list.Add(new DataField { DataTextField = "Others", DataValueField = "KO" });
        //    return list;
        //}

    }
}
