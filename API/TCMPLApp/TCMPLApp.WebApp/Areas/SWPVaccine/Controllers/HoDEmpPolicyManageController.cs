using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using TCMPLApp.WebApp.Models;
using TCMPLApp.DataAccess.Repositories.SWPVaccine;
using TCMPLApp.Domain.Models.SWPVaccine;
using Newtonsoft.Json;
using Microsoft.AspNetCore.Authorization;
using TCMPLApp.WebApp.Controllers;
using TCMPLApp.WebApp.CustomPolicyProvider;
using Microsoft.AspNetCore.Mvc.Rendering;

namespace TCMPLApp.WebApp.Areas.SWP.Controllers
{
    [Area("SWPVaccine")]

    [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SWPVaccineHelper.RoleSWPVaccineHoD)]
    public class HoDEmpPolicyManageController : BaseController
    {
        readonly IHoDEmpPolicyManageRepository _hoDEmpPolicyManageRepository;

        public HoDEmpPolicyManageController(IHoDEmpPolicyManageRepository hoDEmpPolicyManageRepository)
        {
            _hoDEmpPolicyManageRepository = hoDEmpPolicyManageRepository;
        }

        [HttpGet]
        public async Task<IActionResult> Index()
        {
            SwpVuEmpResponseModel vSwpVuEmpResponse = new();

            try
            {
                ViewData["FilterVal"] = "Pending";

                string strUser = User.Identity.Name;

                vSwpVuEmpResponse.SwpVuEmpResponseList = await _hoDEmpPolicyManageRepository.GetPendingApprovalList(strUser, "");

                var hodFilter = _hoDEmpPolicyManageRepository.GetHodfilterListForDropDown();
                vSwpVuEmpResponse.HodfilterList = new SelectList(hodFilter);

                return View(vSwpVuEmpResponse);
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message, "toaster", notificationType: NotificationType.error);
            }

            return View(vSwpVuEmpResponse);
        }

        [HttpPost]
        public async Task<IActionResult> Index(string ddlFilterList)
        {
            SwpVuEmpResponseModel vSwpVuEmpResponse = new();

            try
            {
                string strUser = User.Identity.Name;
                vSwpVuEmpResponse.SwpVuEmpResponseList = await _hoDEmpPolicyManageRepository.GetPendingApprovalList(strUser, ddlFilterList);

                var hodFilter = _hoDEmpPolicyManageRepository.GetHodfilterListForDropDown();
                vSwpVuEmpResponse.HodfilterList = new SelectList(hodFilter);

                ViewData["FilterVal"] = ddlFilterList;
                return View(vSwpVuEmpResponse);
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message, "toaster", notificationType: NotificationType.error);
            }

            return View(vSwpVuEmpResponse);
        }

        [HttpPost]
        public async Task<IActionResult> ApproveAsync(List<string> ChkEmpNo)
        {
            try
            {
                JsonObj jsonClass = new();

                //string empList = "";

                if (ChkEmpNo != null)
                {
                    foreach (string empNo in ChkEmpNo)
                    {
                        jsonClass.data.Rows.Add(empNo, "OK");
                    }

                    if (jsonClass.data.Rows.Count > 0)
                    {
                        string JsonResult = "";
                        JsonResult = JsonConvert.SerializeObject(jsonClass);

                        var retVal = await _hoDEmpPolicyManageRepository.Approve(JsonResult, User.Identity.Name);

                        if (retVal.Status == "OK")
                        {
                            Notify("Success", retVal.Message, "toaster", notificationType: NotificationType.success);
                        }
                        else
                        {
                            Notify("Error", retVal.Message, "toaster", notificationType: NotificationType.error);
                        }
                    }
                    else
                    {
                        Notify("Warning", "No data Selected", "toaster", notificationType: NotificationType.warning);
                    }
                }
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message, "toaster", notificationType: NotificationType.error);
            }
            return RedirectToAction("Index");
        }

        [HttpPost]
        public async Task<IActionResult> RejectAsync(string Empno)
        {
            try
            {
                if (string.IsNullOrEmpty(Empno))
                {
                    return Json(new { success = false, message = "Employee not found" });
                }

                var retVal = await _hoDEmpPolicyManageRepository.Reject(Empno, User.Identity.Name);

                if (retVal.Status == "OK")
                {
                    return Json(new { success = true, message = retVal.Message });
                }
                else
                {
                    return Json(new { success = false, message = retVal.Message });
                }
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message, "toaster", notificationType: NotificationType.error);
                return Json(new { success = false, message = ex });
            }
        }
    }
}