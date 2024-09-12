using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.SWPVaccine;
using TCMPLApp.Domain.Models.SWPVaccine;
using TCMPLApp.WebApp.Controllers;
using TCMPLApp.WebApp.CustomPolicyProvider;
using TCMPLApp.WebApp.Models;

namespace TCMPLApp.WebApp.Areas.SWP.Controllers
{
    [Area("SWPVaccine")]

    [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, SWPVaccineHelper.RoleSWPVaccineHR)]
    public class HREmpPolicyManageController : BaseController
    {
        readonly IHREmpPolicyManageRepository _hrEmpPolicyManageRepository;

        readonly IUtilityRepository _utilityRepository;

        public HREmpPolicyManageController(IHREmpPolicyManageRepository hrEmpPolicyManageRepository

            , IUtilityRepository utilityRepository)
        {
            _hrEmpPolicyManageRepository = hrEmpPolicyManageRepository;
            _utilityRepository = utilityRepository;
        }

        public async Task<IActionResult> Index()
        {
            SwpVuEmpResponseModel vSwpVuEmpResponse = new();

            try
            {
                ViewData["FilterVal"] = "Pending";

                string strUser = User.Identity.Name;

                vSwpVuEmpResponse.SwpVuEmpResponseList = await _hrEmpPolicyManageRepository.GetPendingApprovalList(strUser, "", "");

                var hrFilter = _hrEmpPolicyManageRepository.GetHRfilterListForDropDown();
                vSwpVuEmpResponse.HRfilterList = new SelectList(hrFilter);

                var deptList = _hrEmpPolicyManageRepository.GetDeptListForDropDown().Result.ToList();

                

                deptList.Insert(0, new DataField() { DataTextField = "All", DataValueField = "All" });
                
                vSwpVuEmpResponse.DeptList = new SelectList(deptList);

                return View(vSwpVuEmpResponse);
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message, "toaster", notificationType: NotificationType.error);
            }

            return View(vSwpVuEmpResponse);
        }

        [HttpPost]
        public async Task<IActionResult> Index(string ddlFilterList, string ddlDeptList)
        {
            SwpVuEmpResponseModel vSwpVuEmpResponse = new();

            try
            {
                ViewData["FilterVal"] = "";
                ViewData["DeptFilterVal"] = "";
                string strUser = User.Identity.Name;

                vSwpVuEmpResponse.SwpVuEmpResponseList = await _hrEmpPolicyManageRepository.GetPendingApprovalList(strUser, ddlFilterList, ddlDeptList);
                var hrFilter = _hrEmpPolicyManageRepository.GetHRfilterListForDropDown();
                vSwpVuEmpResponse.HRfilterList = new SelectList(hrFilter);
                var deptList = _hrEmpPolicyManageRepository.GetDeptListForDropDown().Result.ToList();

                deptList.Insert(0, new DataField(){ DataTextField ="All", DataValueField= "All" });
                vSwpVuEmpResponse.DeptList = new SelectList(deptList);

                ViewData["FilterVal"] = ddlFilterList;
                ViewData["DeptFilterVal"] = ddlDeptList;

                return View(vSwpVuEmpResponse);
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message, "toaster", notificationType: NotificationType.error);
            }

            return View(vSwpVuEmpResponse);
        }

        [HttpPost]
        public async Task<IActionResult> ApproveAsync(List<string> ChkEmpNo, SwpVuEmpResponseModel model)
        {
            try
            {
                JsonObjHr jsonClass = new();

                if (ChkEmpNo != null)
                {
                    foreach (string empNo in ChkEmpNo)
                    {
                        jsonClass.data.Rows.Add(empNo, "OK", "OK");
                    }

                    if (jsonClass.data.Rows.Count > 0)
                    {
                        string JsonResult = "";
                        JsonResult = JsonConvert.SerializeObject(jsonClass);

                        var retVal = await _hrEmpPolicyManageRepository.Approve(JsonResult, User.Identity.Name);

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

                var retVal = await _hrEmpPolicyManageRepository.Reject(Empno, User.Identity.Name);

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

        [HttpPost]
        public async Task<IActionResult> ResetAsync(string Empno)
        {
            try
            {
                if (string.IsNullOrEmpty(Empno))
                {
                    return Json(new { success = false, message = "Employee not found" });
                }

                var retVal = await _hrEmpPolicyManageRepository.Reset(Empno, User.Identity.Name);

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

        [HttpPost]
        public IActionResult ExcelDownloadAsync(string ddlFilterList, string ddlDeptList)
        {
            try
            {
                string strUser = User.Identity.Name;
                var dt = _hrEmpPolicyManageRepository.GetdataTable(strUser, ddlFilterList, ddlDeptList);

                var content = _utilityRepository.ExcelDownloadFromIEnumerable(dt, " Smart Working Report", " SmartWorking");
                string StrFimeName = "Smart Working Report";
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
    }
}