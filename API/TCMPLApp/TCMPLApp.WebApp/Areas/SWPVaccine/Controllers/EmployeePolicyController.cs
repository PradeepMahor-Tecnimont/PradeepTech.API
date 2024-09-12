using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using TCMPLApp.WebApp.Models;
using TCMPLApp.DataAccess.Repositories.SWPVaccine;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc.Rendering;
using TCMPLApp.Domain.Models.SWPVaccine;
using TCMPLApp.WebApp.Controllers;
using TCMPLApp.WebApp.CustomPolicyProvider;

namespace TCMPLApp.WebApp.Areas.SWP.Controllers
{
    [Area("SWPVaccine")]

    //[Authorize]
    //[Authorize(Roles = RoleProvider.BASIC_USER)]
    [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SWPVaccineHelper.RoleTCMPLEmpStatus1)]

    public class EmployeePolicyController : BaseController
    {
        private IEmployeePolicyRepository _employeePolicyRepository;
        private ISWPCheckDetailsRepository _swpCheckDetailsRepository;
        public EmployeePolicyController(IEmployeePolicyRepository employeePolicyRepository, ISWPCheckDetailsRepository swpCheckDetailsRepository )
        {
            _employeePolicyRepository = employeePolicyRepository;
            _swpCheckDetailsRepository = swpCheckDetailsRepository;
        }

        public IActionResult Index()
        {
            return RedirectToAction("Create");
            //return View();
        }

        public async Task<IActionResult> Detail()
        {

            var swpVuEmpResponseModel = await _employeePolicyRepository.EmpSWPDetails(User.Identity.Name);
            return View(swpVuEmpResponseModel);
        }

        public async Task<IActionResult> Create()
        {
            SWPCheckDetails swpCheckDetails = new SWPCheckDetails { ParamWinUid = User.Identity.Name };
            var retVal = await _swpCheckDetailsRepository.CheckDetails(swpCheckDetails);

            bool canUserDoSWP = retVal.OutParamUserCanDoSwp == "OK";
            bool isIphoneUser = retVal.OutParamIsIphoneUser == "OK";
            bool IsSWPExists = retVal.OutParamSwpExists == "OK";

            //var retVal = await _employeePolicyRepository.SWPPreCheck(User.Identity.Name);
            //var outValue = (Dictionary<string, string>)retVal.Data;
            //bool canUserDoSWP = outValue["param_user_can_do_swp"] == "OK";
            //bool isIphoneUser = outValue["param_is_iphone_user"] == "OK";
            //bool IsSWPExists = outValue["param_swp_exists"] == "OK";

            if (!canUserDoSWP)
            {
                return View("UserCannotDoSWP");
            }
            if (IsSWPExists)
                return RedirectToAction("Detail", "EmployeePolicy");
            else
            {
                EmployeePolicyViewModel employeePolicyModel = new EmployeePolicyViewModel { IsIphoneUser = isIphoneUser, InstallMSAuthenticator = isIphoneUser ? "KK" : "" };


                var training = await _employeePolicyRepository.EmpTrainingDetails(User.Identity.Name);

                if (training == null)
                    employeePolicyModel.IsTrainingCompleted = false;
                else
                    employeePolicyModel.IsTrainingCompleted = ((bool)training.Onedrive365
                                                                && (bool)training.Planner
                                                                && (bool)training.Security
                                                                && (bool)training.Sharepoint16
                                                                && (bool)training.Teams);

                var selectListISP = _employeePolicyRepository.SelectListISP().ToList();


                List<Domain.Models.DdlModel> selectListElectLoadShedding = new List<Domain.Models.DdlModel>();
                selectListElectLoadShedding.Insert(0, new Domain.Models.DdlModel { Text = "", Val = "" });
                selectListElectLoadShedding.Insert(0, new Domain.Models.DdlModel { Text = "UPS", Val = "UPS" });
                selectListElectLoadShedding.Insert(0, new Domain.Models.DdlModel { Text = "INVERTER", Val = "INVERTER" });
                selectListElectLoadShedding.Insert(0, new Domain.Models.DdlModel { Text = "Backup Not Required", Val = "NA" });

                ViewData["SelectListISP"] = new SelectList(selectListISP, "Val", "Text", null);

                ViewData["SelectListElectLoadShedding"] = new SelectList(selectListElectLoadShedding, "Val", "Text", null);

                return View(employeePolicyModel);
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(EmployeePolicyViewModel employeePolicy)
        {
            bool isTrainingCompleted;
            var training = await _employeePolicyRepository.EmpTrainingDetails(userWinUid: User.Identity.Name);

            isTrainingCompleted = ((bool)training.Onedrive365
                                && (bool)training.Planner
                                && (bool)training.Security
                                && (bool)training.Sharepoint16
                                && (bool)training.Teams);

            if (employeePolicy.IsTrainingCompleted == false ||

                 string.IsNullOrEmpty(employeePolicy.ISP) ||
                 employeePolicy.ISP == "MTNL/BSNL" ||
                 employeePolicy.DownloadSpeed == "KO" ||
                 employeePolicy.UploadSpeed == "KO" ||
                 employeePolicy.UploadSpeed == "KO" ||

                 employeePolicy.MonthlyQuota == "KO" ||
                 string.IsNullOrEmpty(employeePolicy.RouterBrand) ||
                 string.IsNullOrEmpty(employeePolicy.RouterModel) ||
                 isTrainingCompleted == false
                )
            {
                Notify("Error", "Mandatory pre-requisite not fulfilled. Cannot save.", "toaster", notificationType: NotificationType.error);
                return View(employeePolicy);
            }


            EmployeePolicyExecModel employeePolicyExecModel = new EmployeePolicyExecModel
            {
                PolicyAccepted = ((bool)employeePolicy.PolicyAccepted),

                ISP = employeePolicy.ISP,
                DownloadSpeed = employeePolicy.DownloadSpeed,
                UploadSpeed = employeePolicy.UploadSpeed,
                ElectricityBackUp = employeePolicy.ElectricityBackUp,
                MonthlyQuota = employeePolicy.MonthlyQuota,
                RouterBrand = employeePolicy.RouterBrand,
                RouterModel = employeePolicy.RouterModel,
                MSAuthOnOwnMob = employeePolicy.InstallMSAuthenticator
            };


            var retVal = await _employeePolicyRepository.Create(userWinUid: User.Identity.Name, employeePolicyExecModel);
            if (retVal.Status == "OK")
                return RedirectToAction("Detail", "EmployeePolicy");
            else
            {
                Notify(Title: "Error", Message: "Error while saving." + retVal.Message, Provider: "toaster", notificationType: NotificationType.error);
                return View(employeePolicy);
            }

        }


    }

}