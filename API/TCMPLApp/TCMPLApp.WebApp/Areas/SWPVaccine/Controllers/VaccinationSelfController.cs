using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using TCMPLApp.WebApp.Models;
using TCMPLApp.DataAccess.Repositories.SWPVaccine;
using TCMPLApp.Domain.Models;
using Microsoft.AspNetCore.Authorization;
using TCMPLApp.WebApp.Controllers;
using Microsoft.AspNetCore.Mvc.Rendering;
using TCMPLApp.WebApp.CustomPolicyProvider;
using TCMPLApp.Domain.Models.SWPVaccine;

namespace TCMPLApp.WebApp.Areas.SWP.Controllers
{
    [Area("SWPVaccine")]
    [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SWPVaccineHelper.RoleTCMPLEmpStatus1)]
    public class VaccinationSelfController : BaseController
    {
        private IVaccinationSelfRepository _vaccineDateRepository;
        public VaccinationSelfController(IVaccinationSelfRepository vaccineDateRepository)
        {
            _vaccineDateRepository = vaccineDateRepository;
        }

        public async Task<IActionResult> Index()
        {
            //return View("UnderMaintenance");
            var empVaccineDates = await _vaccineDateRepository.VaccineDateDetails(User.Identity.Name);
            if (empVaccineDates == null)
                return RedirectToAction("Create");
            else
                return RedirectToAction("Detail");
        }

        public async Task<IActionResult> Detail()
        {
            //return View("UnderMaintenance");
            var empVaccineDates = await _vaccineDateRepository.VaccineDateDetails(User.Identity.Name);
            if (empVaccineDates == null)
                return RedirectToAction("Create");
            var empVaccineDateReadOnly = new VaccinationSelfCreateViewModel
            {
                VaccineType = empVaccineDates.VaccineType,
                FirstJab = empVaccineDates.Jab1Date,
                SecondJab = empVaccineDates.Jab2Date == null ? null : (DateTime)empVaccineDates.Jab2Date,
                BoosterJab = empVaccineDates.BoosterJabDate
            };
            return View("Detail", empVaccineDateReadOnly);

        }

        public async Task<IActionResult> Create()
        {
            //return View("UnderMaintenance");
            var empVaccineDates = await _vaccineDateRepository.VaccineDateDetails(User.Identity.Name);
            if (empVaccineDates != null)
                return RedirectToAction("Detail");

            var vaccineTypes = _vaccineDateRepository.SelectListVaccineTypes();
            ViewData["VaccineTypes"] = new SelectList(vaccineTypes, "Val", "Text", null);

            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(VaccinationSelfCreateViewModel vaccineDateModel)
        {
            if (ModelState.IsValid)
            {
                var retVal = await _vaccineDateRepository.Create(User.Identity.Name,vaccineDateModel.VaccineType, (DateTime)vaccineDateModel.FirstJab, vaccineDateModel.SecondJab);
                if (retVal.Status == "OK")
                {
                    Notify("Success", "Changes succesfully saved", "toaster", notificationType: NotificationType.success);
                    return RedirectToAction("Index");
                }
                else
                {
                    Notify("Error", "Error while saving changes", "toaster", notificationType: NotificationType.error);
                    return RedirectToAction("Create");
                }
            }
            else
            {
                var vaccineTypes = _vaccineDateRepository.SelectListVaccineTypes();
                ViewData["VaccineTypes"] = new SelectList(vaccineTypes, "Val", "Text", null);
                return View(vaccineDateModel);

            }
        }

        public async Task<IActionResult> Edit()
        {
            //return View("UnderMaintenance");
            var empVaccineDates = await _vaccineDateRepository.VaccineDateDetails(User.Identity.Name);
            if (empVaccineDates == null)
                return RedirectToAction("Create");
            var empVaccineDateEdit = new VaccineSelfEditViewModel
            {
                VaccineType = empVaccineDates.VaccineType,
                FirstJab = empVaccineDates.Jab1Date,
                SecondJab = empVaccineDates.Jab2Date,
                DummySecondJabDate = empVaccineDates.Jab2Date,
                BoosterJab = empVaccineDates.BoosterJabDate,
                IsSecondJabNull = empVaccineDates.Jab2Date == null
            };

            var vaccineTypes = _vaccineDateRepository.SelectListVaccineTypes();
            ViewData["VaccineTypes"] = new SelectList(vaccineTypes, "Val", "Text", null);


            return View(empVaccineDateEdit);

        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(VaccineSelfEditViewModel vaccineDateModelEdit)
        {
            if (!ModelState.IsValid)
                return View(vaccineDateModelEdit);
            //var retVal = await _vaccineDateRepository.UpdateSecondJab(User.Identity.Name, (DateTime)vaccineDateModelEdit.SecondJab);
            var retVal = await _vaccineDateRepository.UpdateSelfJabs(User.Identity.Name, vaccineDateModelEdit.SecondJab,vaccineDateModelEdit.BoosterJab);
            if (retVal.Status == "OK")
            {
                Notify("Success", "Changes succesfully saved", "toaster", notificationType: NotificationType.success);

                return RedirectToAction("Detail");
            }
            else
            {
                Notify("Error", retVal.Message, "toaster", notificationType: NotificationType.error);
                return View(vaccineDateModelEdit);
            }

        }

        public async Task<IActionResult> UpdateVaccineType()
        {
            var empVaccineDates = await _vaccineDateRepository.VaccineDateDetails(User.Identity.Name);
            if (empVaccineDates == null)
                return RedirectToAction("Create");

            var vaccineTypes = _vaccineDateRepository.SelectListVaccineTypes();
            ViewData["VaccineTypes"] = new SelectList(vaccineTypes, "Val", "Text", empVaccineDates.VaccineType);

            var empVaccineDateEdit = new VaccinationSelfCreateViewModel
            {
                IsSecondJabNull = !empVaccineDates.Jab2Date.HasValue,
                FirstJab = empVaccineDates.Jab1Date,
                SecondJab = empVaccineDates.Jab2Date
                
            };
            return View(empVaccineDateEdit);

        }

        //[HttpPost]
        //public async Task<IActionResult> UpdateVaccineType(VaccinationSelfCreateViewModel vaccineDateCreateViewModel)
        //{
        //    if (ModelState.IsValid)
        //    {
        //        var retVal = await _vaccineDateRepository.UpdateVaccineType(User.Identity.Name, vaccineDateCreateViewModel.VaccineType, vaccineDateCreateViewModel.SecondJab);

        //        if (retVal.Status == "OK")
        //        {
        //            Notify("Success", "Changes succesfully saved", "toaster", notificationType: NotificationType.success);

        //            return RedirectToAction("Detail");
        //        }
        //        else
        //        {
        //            Notify("Error", "Error while saving changes", "toaster", notificationType: NotificationType.error);
        //        }
        //    }

        //    var vaccineTypes = _vaccineDateRepository.SelectListVaccineTypes();
        //    ViewData["VaccineTypes"] = new SelectList(vaccineTypes, "Val", "Text", vaccineDateCreateViewModel.VaccineType);

        //    return View(vaccineDateCreateViewModel);

        //}


    }
}
