using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Repositories.SWPVaccine;
using TCMPLApp.WebApp.Models;
using TCMPLApp.Domain.Models.SWPVaccine;
using System.Data;
using System.Collections.Generic;
using System.Linq;
using System;
using Microsoft.AspNetCore.Mvc.Rendering;
using TCMPLApp.Domain.Models;

using TCMPLApp.WebApp.Controllers;
using TCMPLApp.WebApp.CustomPolicyProvider;

namespace TCMPLApp.WebApp.Areas.SWP.Controllers
{
    [Area("SWPVaccine")]
    [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SWPVaccineHelper.RoleTCMPLEmpStatus1)]
    public class VaccinationOfficeController : BaseController
    {

        private IVaccinationSelfRepository _vaccinationSelfRepository;
        private IVaccinationOfficeRepository _vaccinationOfficeRepository;
        private readonly IUtilityRepository _utilityRepository;
        private ISwpRelationMastRepository _swpRelationMast;
        private ISWPOfficeVaccineBatch2Repository _swpOfficeVaccineBatch2Repository;
        public VaccinationOfficeController(IVaccinationSelfRepository vaccinationSelfRepository,
                                            IVaccinationOfficeRepository vaccinationOfficeRepository,
                                            IUtilityRepository utilityRepository,
                                            ISwpRelationMastRepository swpRelationMastRepository,
                                            ISWPOfficeVaccineBatch2Repository swpOfficeVaccineBatch2Repository
            )
        {
            _vaccinationSelfRepository = vaccinationSelfRepository;
            _vaccinationOfficeRepository = vaccinationOfficeRepository;
            _utilityRepository = utilityRepository;
            _swpRelationMast = swpRelationMastRepository;
            _swpOfficeVaccineBatch2Repository = swpOfficeVaccineBatch2Repository;
        }

        public async Task<IActionResult> Index()
        {
            var registrationDetails = await _vaccinationOfficeRepository.GetRegistrationDetails(User.Identity.Name);

            if (registrationDetails == null)
                return RedirectToAction("Create");

            VaccinationOfficeCreateViewModel vaccinationOfficeCreateViewModel = new VaccinationOfficeCreateViewModel
            {
                CompanyBus = registrationDetails.OfficeBus == "OK",
                CompanyBusRoute = registrationDetails.OfficeBusRoute,
                CowinRegistered = registrationDetails.CowinRegtrd == "OK",
                CowinRegisteredMobile = registrationDetails.Mobile,
                IsAttendingForJab = registrationDetails.AttendingVaccination == "OK",
                JabNumber = registrationDetails.JabNumber,
                ReasonForNotAttendingJab = registrationDetails.NotAttendingReason
            };

            return View(vaccinationOfficeCreateViewModel);
        }

        public async Task<IActionResult> Create()
        {
            var registrationDetails = await _vaccinationOfficeRepository.GetRegistrationDetails(User.Identity.Name);
            if (registrationDetails != null)
                return RedirectToAction("Index");

            var registrationBatch = await _vaccinationOfficeRepository.GetRegistrationBatch();

            if (registrationBatch.IsOpen == "KO")
            {
                ViewData["RegistrationWindowClosed"] = true;
                return View("RegistrationNotAllowed");
            }

            VaccinationOfficeCreateViewModel vaccinationOfficeCreateViewModel = new VaccinationOfficeCreateViewModel();



            //return View("RegistrationNotAllowed");



            var selfVaccineDetails = await _vaccinationSelfRepository.VaccineDateDetails(User.Identity.Name);



            string errorMessage = null;

            if (selfVaccineDetails != null)
            {
                if (string.IsNullOrEmpty(selfVaccineDetails.VaccineType))
                    errorMessage = "Vaccine Jab type not yet updated";

                if (selfVaccineDetails.VaccineType != "COVISHIELD")
                    errorMessage += " <br />Vaccine Jab type is not COVISHIELD";

                if (selfVaccineDetails.Jab2Date.HasValue)
                    errorMessage += " <br />You are fully vaccinated";

                if (selfVaccineDetails.Jab1Date >= new DateTime(year: 2021, month: 6, day: 14))
                    errorMessage += " <br />Second Jab Not Yet Due";

                if (!string.IsNullOrEmpty(errorMessage))
                    return View("RegistrationNotAllowed");

                vaccinationOfficeCreateViewModel.SelfJab1Date = selfVaccineDetails.Jab1Date;
                vaccinationOfficeCreateViewModel.SelfJab2Date = selfVaccineDetails.Jab2Date;
                vaccinationOfficeCreateViewModel.SelfVaccineType = selfVaccineDetails.VaccineType;
                vaccinationOfficeCreateViewModel.JabNumber = "Second";
            }
            else
                vaccinationOfficeCreateViewModel.JabNumber = "First";

            return View(vaccinationOfficeCreateViewModel);

        }

        [HttpPost]
        public async Task<IActionResult> Create(VaccinationOfficeCreateViewModel vaccinationOfficeCreateViewModel)
        {
            if (!ModelState.IsValid)
                return View(vaccinationOfficeCreateViewModel);

            VaccinationOffice vaccinationOffice = new VaccinationOffice
            {
                JabNumber = vaccinationOfficeCreateViewModel.JabNumber,
                CompanyBus = (bool)vaccinationOfficeCreateViewModel.CompanyBus ? "OK" : "KO",
                CompanyBusRoute = vaccinationOfficeCreateViewModel.CompanyBusRoute,
                CowinRegistered = (bool)vaccinationOfficeCreateViewModel.CowinRegistered ? "OK" : "KO",
                CowinRegisteredMobile = vaccinationOfficeCreateViewModel.CowinRegisteredMobile,
                IsAttendingForJab = (bool)vaccinationOfficeCreateViewModel.IsAttendingForJab ? "OK" : "KO",
                ReasonForNotAttendingJab = vaccinationOfficeCreateViewModel.ReasonForNotAttendingJab

            };

            var retVal = await _vaccinationOfficeRepository.AddRegistration(User.Identity.Name, vaccinationOffice);

            if (retVal.Status == "OK")
            {
                Notify("Success", "Changes succesfully saved", "toaster", notificationType: NotificationType.success);
                return RedirectToAction("Index");
            }
            else
                Notify("Error", retVal.Message, "toaster", notificationType: NotificationType.success);


            return View(vaccinationOfficeCreateViewModel);
        }

        public IActionResult GetBusRoutesList()
        {
            var busRoutes = _vaccinationOfficeRepository.BusRoutes();
            return PartialView("_BusRoutePartial", busRoutes);
        }

        public IActionResult Registrations()
        {
            return View();
        }

        public async Task<IActionResult> RegistrationList()
        {



            var registrationslist = await _vaccinationOfficeRepository.GetRegistrationList();



            return PartialView("_RegistrationListPartial", registrationslist);
        }

        [HttpPost]
        public async Task<IActionResult> RemoveRegistration(string empno)
        {


            if (string.IsNullOrEmpty(empno))
            {
                return Json(new { success = false, message = "Employee not found" });
            }

            var retVal = await _vaccinationOfficeRepository.RemoveRegistration(empno);

            if (retVal.Status == "OK")
            {
                return Json(new { success = true, message = retVal.Message });
            }
            else
            {
                return Json(new { success = false, message = retVal.Message });
            }



            //return RedirectToAction("RegistrationList");
        }

        public async Task<IActionResult> ExcelDownload()
        {

            var registrationslist = await _vaccinationOfficeRepository.GetRegistrationList();


            var content = _utilityRepository.ExcelDownloadFromIEnumerable(registrationslist, "TCMPL Vaccination Drive", "Registrations");

            string StrFimeName = "TCMPVaccinationDrive-Registrations_" + DateTime.Now.ToString("dd-MMM-yyyy");
            return File(
               content,
               "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                        StrFimeName + ".xlsx");

        }

        #region Registration for Batch2

        public async Task<IActionResult> RegisterForBatch2Create()
        {
            const string COVISHIELD = "COVISHIELD";
            bool isSelfRegistratonAllowed = true;

            var registrationDetails = await _vaccinationOfficeRepository.GetEmployeeRegistrationBatch2(User.Identity.Name);
            if (registrationDetails != null)
                return RedirectToAction("RegisterForBatch2Index");

            VaccinationOfficeBatch2CreateViewModel vaccinationOfficeBatch2CreateViewModel = new VaccinationOfficeBatch2CreateViewModel();

            var registrationClosed = true;

            ViewData["RegistrationWindowClosed"] = registrationClosed;
            
            if (registrationClosed)
                return View("RegistrationNotAllowed");


            var selfVaccineDetails = await _vaccinationSelfRepository.VaccineDateDetails(User.Identity.Name);

            string errorMessage = null;
            List<DdlModel> radioListJabDates = new List<DdlModel>();
            List<DdlModel> selectListRegistrationFor = new List<DdlModel>();

            if (selfVaccineDetails != null)
            {
                if (string.IsNullOrEmpty(selfVaccineDetails.VaccineType))
                    return View("RegistrationNotAllowed");

                if (selfVaccineDetails.VaccineType != COVISHIELD)
                {
                    errorMessage += " <br />Vaccine Jab type is not COVISHIELD";
                    isSelfRegistratonAllowed = false;
                }

                if (selfVaccineDetails.Jab2Date.HasValue)
                {
                    errorMessage += " <br />You are fully vaccinated";
                    isSelfRegistratonAllowed = false;
                }

                var dateDiff = (new DateTime(year: 2021, month: 6, day: 27) - selfVaccineDetails.Jab1Date);

                if (dateDiff.Days < 84)
                {
                    errorMessage += " <br />Second Jab Not Yet Due";
                    isSelfRegistratonAllowed = false;
                }

                if (isSelfRegistratonAllowed)
                {
                    if (dateDiff.Days > 84)
                        radioListJabDates.Add(new DdlModel { Text = "26-Jun-2021", Val = "26-Jun-2021" });

                    radioListJabDates.Add(new DdlModel { Text = "27-Jun-2021", Val = "27-Jun-2021" });
                }
                else
                {
                    radioListJabDates.Add(new DdlModel { Text = "26-Jun-2021", Val = "26-Jun-2021" });
                    radioListJabDates.Add(new DdlModel { Text = "27-Jun-2021", Val = "27-Jun-2021" });
                }

                if (isSelfRegistratonAllowed)
                {
                    selectListRegistrationFor.Add(new DdlModel { Text = "Self", Val = "SELF" });
                    selectListRegistrationFor.Add(new DdlModel { Text = "Self & Family", Val = "SELF & FAMILY" });
                }
                selectListRegistrationFor.Add(new DdlModel { Text = "Family", Val = "FAMILY" });


                var selectListRelations = _swpRelationMast.GetAll().OrderBy(m => m.SortOrder).Select(m => new DdlModel { Text = m.RelationDesc, Val = m.RelationCode });

                ViewData["SelectListRelations"] = new SelectList(selectListRelations, "Val", "Text", null);

                vaccinationOfficeBatch2CreateViewModel.SelfJab1Date = selfVaccineDetails.Jab1Date;
                vaccinationOfficeBatch2CreateViewModel.SelfJab2Date = selfVaccineDetails.Jab2Date;
                vaccinationOfficeBatch2CreateViewModel.SelfVaccineType = selfVaccineDetails.VaccineType;

                if (isSelfRegistratonAllowed && selfVaccineDetails.Jab2Date == null)
                    vaccinationOfficeBatch2CreateViewModel.JabNumber = "Second";
                else
                    vaccinationOfficeBatch2CreateViewModel.JabNumber = "NONE";
            }
            else
            {
                vaccinationOfficeBatch2CreateViewModel.JabNumber = "First";
                radioListJabDates.Add(new DdlModel { Text = "26-Jun-2021", Val = "26-Jun-2021" });
                radioListJabDates.Add(new DdlModel { Text = "27-Jun-2021", Val = "27-Jun-2021" });

                selectListRegistrationFor.Add(new DdlModel { Text = "Self", Val = "SELF" });
                selectListRegistrationFor.Add(new DdlModel { Text = "Self & Family", Val = "SELF & FAMILY" });
                selectListRegistrationFor.Add(new DdlModel { Text = "Family", Val = "FAMILY" });
            }
            ViewData["SelectListRegistrationFor"] = new SelectList(selectListRegistrationFor, "Val", "Text", null);
            ViewData["RadioListJabDate"] = radioListJabDates;
            return View(vaccinationOfficeBatch2CreateViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> RegisterForBatch2Create(VaccinationOfficeBatch2CreateViewModel vaccinationOfficeBatch2CreateViewModel)
        {

            if (ModelState.IsValid)
            {
                SwpOfficeVaccineBatch2AddRegistration swpOfficeVaccineBatch2AddRegistration = new SwpOfficeVaccineBatch2AddRegistration
                {
                    JabNumber = vaccinationOfficeBatch2CreateViewModel.JabNumber,
                    ParamWinUid = User.Identity.Name,
                    ParamPreferredDate = vaccinationOfficeBatch2CreateViewModel.PreferredJabDate,
                    ParamVaccineFor = vaccinationOfficeBatch2CreateViewModel.RegistrationFor
                };
                var retVal = await _swpOfficeVaccineBatch2Repository.AddRegistration(swpOfficeVaccineBatch2AddRegistration);
                if (retVal.OutParamSuccess == "KO")
                {
                    Notify("Error", retVal.OutParamMessage, "toaster", notificationType: NotificationType.error);
                }
                else
                {
                    return RedirectToAction("RegisterForBatch2Index");
                }
            }


            return View(vaccinationOfficeBatch2CreateViewModel);
        }


        public async Task<IActionResult> RegisterForBatch2Index()
        {
            ViewData["RegistrationWindowClosed"] = true;

            var registrationDetails = await _vaccinationOfficeRepository.GetEmployeeRegistrationBatch2(User.Identity.Name);
            if (registrationDetails == null)
                return RedirectToAction("RegisterForBatch2Create");


            var selfVaccineDetails = await _vaccinationSelfRepository.VaccineDateDetails(User.Identity.Name);


            VaccinationOfficeBatch2CreateViewModel vaccinationOfficeBatch2CreateViewModel = new VaccinationOfficeBatch2CreateViewModel();

            vaccinationOfficeBatch2CreateViewModel.JabNumber = registrationDetails.JabNumber;
            vaccinationOfficeBatch2CreateViewModel.PreferredJabDate = registrationDetails.PreferredDate;
            vaccinationOfficeBatch2CreateViewModel.RegistrationFor = registrationDetails.VaccinationFor;

            if (selfVaccineDetails != null)
            {
                vaccinationOfficeBatch2CreateViewModel.SelfJab1Date = selfVaccineDetails.Jab1Date;
                vaccinationOfficeBatch2CreateViewModel.SelfJab2Date = selfVaccineDetails.Jab2Date;
                vaccinationOfficeBatch2CreateViewModel.SelfVaccineType = selfVaccineDetails.VaccineType;
            }




            return View(vaccinationOfficeBatch2CreateViewModel);
        }


        public IActionResult RegisterForBatch2FamilyCreate()
        {
            Batch2FamilyCreateViewModel batch2FamilyCreateViewModel = new();
            var selectListRelations = _swpRelationMast.GetAll().OrderBy(m => m.SortOrder).Select(m => new DdlModel { Text = m.RelationDesc, Val = m.RelationCode });

            ViewData["SelectListRelations"] = new SelectList(selectListRelations, "Val", "Text", null);
            return PartialView("_FamilyRegistrationPartial");

        }

        [HttpPost]
        public async Task<IActionResult> RegisterForBatch2FamilyCreate([FromForm] Batch2FamilyCreateViewModel batch2FamilyCreateViewModel)
        {
            if (ModelState.IsValid)
            {
                SwpOfficeVaccineBatch2AddFamilyMember swpOfficeVaccineBatch2AddFamilyMember = new SwpOfficeVaccineBatch2AddFamilyMember
                {
                    ParamFamilyMemberName = batch2FamilyCreateViewModel.FamilyMemberName,
                    ParamRelation = batch2FamilyCreateViewModel.Relation,
                    ParamYearOfBirth = batch2FamilyCreateViewModel.YearOfBirth,
                    ParamWinUid = User.Identity.Name
                };

                var retVal = await _swpOfficeVaccineBatch2Repository.AddFamilyMember(swpOfficeVaccineBatch2AddFamilyMember);
                if (retVal.OutParamSuccess == "KO")
                {
                    Notify("Error", retVal.OutParamMessage, "toaster", notificationType: NotificationType.error);
                }
                else
                {
                    Notify("Success", retVal.OutParamMessage, "toaster", notificationType: NotificationType.success);
                    return RedirectToAction("RegisterForBatch2FamilyCreate");
                }

            }

            var selectListRelations = _swpRelationMast.GetAll().OrderBy(m => m.SortOrder).Select(m => new DdlModel { Text = m.RelationDesc, Val = m.RelationCode });

            ViewData["SelectListRelations"] = new SelectList(selectListRelations, "Val", "Text", null);
            return PartialView("_FamilyRegistrationPartial", batch2FamilyCreateViewModel);


            //var selectListRelations = _swpRelationMast.GetAll().OrderBy(m => m.SortOrder).Select(m => new DdlModel { Text = m.RelationDesc, Val = m.RelationCode });

            //ViewData["SelectListRelations"] = new SelectList(selectListRelations, "Val", "Text", null);
            //return PartialView("_FamilyRegistrationPartial");

        }


        public async Task<IActionResult> RegisterForBatch2FamilyRemove(string keyid)
        {
            SwpOfficeVaccineBatch2RemoveFamilyMember swpOfficeVaccineBatch2RemoveFamilyMember = new SwpOfficeVaccineBatch2RemoveFamilyMember
            {
                ParamKeyid = keyid,
                ParamWinUid = User.Identity.Name
            };

            var retVal = await _swpOfficeVaccineBatch2Repository.RemoveFamilyMember(swpOfficeVaccineBatch2RemoveFamilyMember);
            if (retVal.OutParamSuccess == "OK")
            {
                return Json(new { success = true, message = retVal.OutParamMessage });
            }
            else
            {
                return Json(new { success = false, message = retVal.OutParamMessage });
            }


        }

        public async Task<IActionResult> RegisterForBatch2Reset(string keyid)
        {
            SwpOfficeVaccineBatch2ResetRegistration swpOfficeVaccineBatch2ResetRegistration = new SwpOfficeVaccineBatch2ResetRegistration
            {

                ParamWinUid = User.Identity.Name
            };

            var retVal = await _swpOfficeVaccineBatch2Repository.ResetRegistration(swpOfficeVaccineBatch2ResetRegistration);
            if (retVal.OutParamSuccess == "OK")
            {
                return Json(new { success = true, message = retVal.OutParamMessage });
            }
            else
            {
                return Json(new { success = false, message = retVal.OutParamMessage });
            }
        }


        public async Task<IActionResult> Batch2FamilyDetails()
        {
            var familyRegistrationDetails = await _vaccinationOfficeRepository.GetEmployeeFamilyRegistrationBatch2(User.Identity.Name);
            return PartialView("_FamilyDetailsPartial", familyRegistrationDetails);
        }
        #endregion
    }
}
