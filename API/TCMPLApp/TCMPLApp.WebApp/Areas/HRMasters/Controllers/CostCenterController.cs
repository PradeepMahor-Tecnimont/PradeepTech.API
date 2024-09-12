using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.AspNetCore.Mvc.Rendering;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Repositories.Common;
using TCMPLApp.DataAccess.Repositories.HRMasters;
using TCMPLApp.WebApp.Areas.HRMasters.Models;
using TCMPLApp.WebApp.Controllers;
using System;
using TCMPLApp.WebApp.Models;
using TCMPLApp.Domain.Models.HRMasters;
using TCMPLApp.Domain.Models.HRMasters.View;

using static TCMPLApp.WebApp.Classes.DTModel;
using System.Linq;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using TCMPLApp.WebApp.CustomPolicyProvider;

//using TCMPLApp.WebApp.Lib.Models;
using Microsoft.AspNetCore.Authorization;
using System.Data;
using TCMPLApp.Domain.Models.Common;
using ClosedXML.Excel;
using System.IO;
using TCMPLApp.Domain.Models;
using MimeTypes;
using TCMPLApp.WebApp.Classes;
using System.Net;

namespace TCMPLApp.WebApp.Areas.HRMasters.Controllers
{
    [Authorize]
    [Area("HRMasters")]
    public class CostCenterController : BaseController
    {
        private readonly IConfiguration _configuration;
        private readonly ICostCenterMasterMainDataTableListRepository _costCenterMasterMainDataTableListRepository;
        private readonly ICostCenterMasterMainRepository _costCenterMasterMainRepository;
        private readonly ICostCenterMasterRepository _costCenterMasterRepository;
        private readonly ISelectRepository _selectRepository;

        public CostCenterController(
            ICostCenterMasterMainDataTableListRepository costCenterMasterMainDataTableListRepository,
            ICostCenterMasterMainRepository costCenterMasterMainRepository,
            ICostCenterMasterRepository costCenterMasterRepository,
            ISelectRepository selectRepository,
            IConfiguration configuration)
        {
            _configuration = configuration;
            _costCenterMasterMainDataTableListRepository = costCenterMasterMainDataTableListRepository;
            _costCenterMasterMainRepository = costCenterMasterMainRepository;
            _costCenterMasterRepository = costCenterMasterRepository;
            _selectRepository = selectRepository;
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, HRMastersHelper.ActionViewHRMasters)]
        public async Task<IActionResult> Index()
        {
            UserIdentity currentUserIdentity = CurrentUserIdentity;
            var result = (await _costCenterMasterMainDataTableListRepository.CostCenterMasterMainDataTableListAsync(currentUserIdentity.EmpNo)).ToList().AsQueryable();
            return View(result);
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, HRMastersHelper.ActionViewHRMasters)]
        public async Task<IActionResult> Detail(string id)
        {
            if (id == null)
            {
                return NotFound();
            }
            UserIdentity currentUserIdentity = CurrentUserIdentity;
            var costCenterDetail = await _costCenterMasterMainRepository.CostCenterMasterMainDetailAsync(id, currentUserIdentity.EmpNo);
            return View(costCenterDetail);
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, HRMastersHelper.ActionViewHRMasters)]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetLists(string paramJson)
        {
            DTResult<CostCenterMasterMainDataTableList> result = new DTResult<CostCenterMasterMainDataTableList>();

            var param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);
            UserIdentity currentUserIdentity = CurrentUserIdentity;
            var data = (await _costCenterMasterMainDataTableListRepository.CostCenterMasterMainDataTableListAsync(currentUserIdentity.EmpNo)).ToList().AsQueryable();

            // Filtering
            if (!string.IsNullOrEmpty(param.GenericSearch))
            {
                data = data
                        .Where(
                        t => t.Costcode.Trim().ToLower().Contains(param.GenericSearch.Trim().ToLower(), StringComparison.InvariantCultureIgnoreCase)
                            | t.Name.Trim().ToLower().Contains(param.GenericSearch.Trim().ToLower(), StringComparison.InvariantCultureIgnoreCase)
                            | t.Abbr.Trim().ToLower().Contains(param.GenericSearch.Trim().ToLower(), StringComparison.InvariantCultureIgnoreCase)
                            | t.Hodname.Trim().ToLower().Contains(param.GenericSearch.Trim().ToLower(), StringComparison.InvariantCultureIgnoreCase)
                         );
            }

            result.draw = param.Draw;
            result.recordsTotal = data.Count();
            result.recordsFiltered = data.Count();
            result.data = data.Skip(param.Start).Take(param.Length).AsNoTracking().ToList();

            return Json(result);
        }

        #region crud

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, HRMastersHelper.RolePayRollAdmin)]
        public async Task<IActionResult> Create()
        {
            CostCenterMainCreateViewModel costCenterMainCreateViewModel = new CostCenterMainCreateViewModel();

            var employeeList = await _selectRepository.EmployeeSelectListCacheAsync();
            var costCenterList = await _selectRepository.CostcenterIdSelectListCacheAsync();
            var costGroupList = await _selectRepository.CostGroupSelectListCacheAsync();
            var costTypeList = await _selectRepository.CostTypeSelectListCacheAsync();
            var enggNonenggList = new List<SelectListItem> { new SelectListItem { Text = "Engineering", Value = "E"},
                                                             new SelectListItem { Text = "Non engineering", Value = "N"}
                                                           };

            ViewData["HoDId"] = new SelectList(employeeList, "DataValueField", "DataTextField");
            ViewData["SecretaryId"] = new SelectList(employeeList, "DataValueField", "DataTextField");
            ViewData["GroupId"] = new SelectList(costCenterList, "DataValueField", "DataTextField");
            ViewData["ParentCostCenterId"] = new SelectList(costCenterList, "DataValueField", "DataTextField");
            ViewData["CostGroupId"] = new SelectList(costGroupList, "DataValueField", "DataTextField");
            ViewData["CostTypeId"] = new SelectList(costTypeList, "DataValueField", "DataTextField");
            ViewData["EnggNonenggList"] = new SelectList(enggNonenggList, "Value", "Text");

            return PartialView("_ModalCreatePartial", costCenterMainCreateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, HRMastersHelper.RolePayRollAdmin)]
        public async Task<IActionResult> Create([FromForm] CostCenterMainCreateViewModel costCenterMainCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    CostCenterMasterMainCreate costCenterMasterMainCreate = new CostCenterMasterMainCreate();

                    costCenterMasterMainCreate.ParamCostcode = costCenterMainCreateViewModel.CostCode;
                    costCenterMasterMainCreate.ParamName = costCenterMainCreateViewModel.Name;
                    costCenterMasterMainCreate.ParamAbbr = costCenterMainCreateViewModel.Abbr;
                    costCenterMasterMainCreate.ParamSapcc = costCenterMainCreateViewModel.SAPCC;
                    costCenterMasterMainCreate.ParamHod = costCenterMainCreateViewModel.HoD;
                    costCenterMasterMainCreate.ParamParentCostcodeid = costCenterMainCreateViewModel.ParentCostCodeId;
                    costCenterMasterMainCreate.ParamCostgroupid = costCenterMainCreateViewModel.CostGroupId;
                    costCenterMasterMainCreate.ParamCostTypeId = costCenterMainCreateViewModel.CostTypeId;
                    costCenterMasterMainCreate.ParamSecretary = costCenterMainCreateViewModel.Secretary;
                    costCenterMasterMainCreate.ParamGroupid = costCenterMainCreateViewModel.GroupId;
                    costCenterMasterMainCreate.ParamSdate = costCenterMainCreateViewModel.SDate;
                    costCenterMasterMainCreate.ParamEdate = costCenterMainCreateViewModel.EDate;
                    costCenterMasterMainCreate.ParamNoofemps = costCenterMainCreateViewModel.NoOfEmps;
                    costCenterMasterMainCreate.ParamEnggNonengg = costCenterMainCreateViewModel.EnggNonengg;

                    var retVal = await _costCenterMasterRepository.CostCenterMasterMainCreate(costCenterMasterMainCreate);

                    if (retVal.OutParamSuccess == "OK")
                    {
                        return Json(new { success = "OK", response = retVal.OutParamMessage });
                    }
                    else
                    {
                        throw new Exception(retVal.OutParamMessage.Replace("-", " "));
                    }

                    //if (retVal.OutParamSuccess == "OK")
                    //{
                    //    Notify("Success", retVal.OutParamMessage, "toaster", NotificationType.success);
                    //}
                    //else
                    //{
                    //    Notify("Error", retVal.OutParamMessage, "toaster", NotificationType.error);
                    //}
                }
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
            }

            return RedirectToAction("Index", "CostCenter");
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, HRMastersHelper.RolePayRollAdmin)]
        public async Task<IActionResult> Edit(string id)
        {
            CostCenterMainCreateViewModel costCenterMainCreateViewModel = new CostCenterMainCreateViewModel();

            try
            {
                if (id == null)
                {
                    return NotFound();
                }

                UserIdentity currentUserIdentity = CurrentUserIdentity;
                var costCenterMasterDetail = await _costCenterMasterMainRepository.CostCenterMasterMainDetailAsync(id, currentUserIdentity.EmpNo);

                costCenterMainCreateViewModel.CostCodeId = costCenterMasterDetail.CostCodeId;
                costCenterMainCreateViewModel.CostCode = costCenterMasterDetail.CostCode;
                costCenterMainCreateViewModel.Name = costCenterMasterDetail.Name;
                costCenterMainCreateViewModel.Abbr = costCenterMasterDetail.Abbr;
                costCenterMainCreateViewModel.HoD = costCenterMasterDetail.HoD;
                costCenterMainCreateViewModel.NoOfEmps = costCenterMasterDetail.NoOfEmps;
                costCenterMainCreateViewModel.CostGroupId = costCenterMasterDetail.CostGroupId;
                costCenterMainCreateViewModel.GroupId = costCenterMasterDetail.GroupId;
                costCenterMainCreateViewModel.CostTypeId = costCenterMasterDetail.CostTypeId;
                costCenterMainCreateViewModel.Secretary = costCenterMasterDetail.Secretary;
                costCenterMainCreateViewModel.SDate = costCenterMasterDetail.SDate;
                costCenterMainCreateViewModel.EDate = costCenterMasterDetail.EDate;
                costCenterMainCreateViewModel.SAPCC = costCenterMasterDetail.SAPCC;
                costCenterMainCreateViewModel.ParentCostCodeId = costCenterMasterDetail.ParentCostCodeId;
                costCenterMainCreateViewModel.EnggNonengg = costCenterMasterDetail.EnggNonengg;

                var costCenterEmployeeList = await _selectRepository.CostcenterEmployeeSelectListCacheAsync(costCenterMasterDetail.HoD);
                var secretaryEmployeeList = await _selectRepository.SecretaryEmployeeSelectListCacheAsync();
                var costGroupCostCenterList = await _selectRepository.CostGroupCostcenterIdSelectListCacheAsync();
                var parentCostCenterCostCenterList = await _selectRepository.ParentCostcenterCostcenterIdSelectListCacheAsync();
                var costGroupList = await _selectRepository.CostGroupSelectListCacheAsync();
                var costTypeList = await _selectRepository.CostTypeSelectListCacheAsync();
                var enggNonenggList = new List<SelectListItem> { new SelectListItem { Text = "Engineering", Value = "E"},
                                                                 new SelectListItem { Text = "Non engineering", Value = "N"}
                                                               };

                ViewData["HoDId"] = new SelectList(costCenterEmployeeList, "DataValueField", "DataTextField");
                ViewData["SecretaryId"] = new SelectList(secretaryEmployeeList, "DataValueField", "DataTextField");
                ViewData["GroupId"] = new SelectList(costGroupCostCenterList, "DataValueField", "DataTextField");
                ViewData["ParentCostCenterId"] = new SelectList(parentCostCenterCostCenterList, "DataValueField", "DataTextField");
                ViewData["CostGroupId"] = new SelectList(costGroupList, "DataValueField", "DataTextField");
                ViewData["CostTypeId"] = new SelectList(costTypeList, "DataValueField", "DataTextField");
                ViewData["EnggNonenggList"] = new SelectList(enggNonenggList, "Value", "Text");
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
            }

            return PartialView("_ModalEditPartial", costCenterMainCreateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, HRMastersHelper.RolePayRollAdmin)]
        public async Task<IActionResult> Edit(CostCenterMainCreateViewModel costCenterMainCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    CostCenterMasterMainUpdate costCenterMasterMainUpdate = new CostCenterMasterMainUpdate();

                    costCenterMasterMainUpdate.ParamCostcodeid = costCenterMainCreateViewModel.CostCodeId;
                    costCenterMasterMainUpdate.ParamName = costCenterMainCreateViewModel.Name;
                    costCenterMasterMainUpdate.ParamAbbr = costCenterMainCreateViewModel.Abbr;
                    costCenterMasterMainUpdate.ParamSapcc = costCenterMainCreateViewModel.SAPCC;
                    costCenterMasterMainUpdate.ParamHod = costCenterMainCreateViewModel.HoD;
                    costCenterMasterMainUpdate.ParamParentCostcodeid = costCenterMainCreateViewModel.ParentCostCodeId;
                    costCenterMasterMainUpdate.ParamCostgroupid = costCenterMainCreateViewModel.CostGroupId;
                    costCenterMasterMainUpdate.ParamCostTypeId = costCenterMainCreateViewModel.CostTypeId;
                    costCenterMasterMainUpdate.ParamSecretary = costCenterMainCreateViewModel.Secretary;
                    costCenterMasterMainUpdate.ParamGroupid = costCenterMainCreateViewModel.GroupId;
                    costCenterMasterMainUpdate.ParamSdate = costCenterMainCreateViewModel.SDate;
                    costCenterMasterMainUpdate.ParamEdate = costCenterMainCreateViewModel.EDate;
                    costCenterMasterMainUpdate.ParamNoofemps = costCenterMainCreateViewModel.NoOfEmps;
                    costCenterMasterMainUpdate.ParamEnggNonengg = costCenterMainCreateViewModel.EnggNonengg;

                    var retVal = await _costCenterMasterRepository.CostCenterMasterMainUpdate(costCenterMasterMainUpdate);

                    if (retVal.OutParamSuccess == "OK")
                    {
                        return Json(new { success = "OK", response = retVal.OutParamMessage });
                    }
                    else
                    {
                        throw new Exception(retVal.OutParamMessage.Replace("-", " "));
                    }

                    //if (retVal.OutParamSuccess == "OK")
                    //{
                    //    Notify("Success", retVal.OutParamMessage, "toaster", NotificationType.success);
                    //}
                    //else
                    //{
                    //    Notify("Error", retVal.OutParamMessage, "toaster", NotificationType.error);
                    //}
                }
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
            }

            return RedirectToAction(actionName: nameof(Detail), new { id = costCenterMainCreateViewModel.CostCodeId });
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, HRMastersHelper.RolePayRollAdmin)]
        public async Task<IActionResult> DeactivateCostCenter(string id)
        {
            if (id == null)
                return NotFound();

            var costCenterMasterDeactivate = new CostCenterMasterDeactivate();

            costCenterMasterDeactivate.ParamCostcodeid = id;

            var retVal = await _costCenterMasterRepository.CostCenterMasterDeactivate(costCenterMasterDeactivate);

            if (retVal.OutParamSuccess == "OK")
            {
                Notify("Success", retVal.OutParamMessage, "toaster", NotificationType.success);
            }
            else
            {
                Notify("Error", retVal.OutParamMessage, "toaster", NotificationType.error);
            }

            return Json(new { success = true, response = "Operation successfully executed" });
        }

        #endregion crud

        #region hod

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, HRMastersHelper.ActionViewHRMasters)]
        public async Task<IActionResult> HoDTabDetail(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            UserIdentity currentUserIdentity = CurrentUserIdentity;
            var costCenterHoDTabDetail = await _costCenterMasterMainRepository.CostCenterMasterHoDDetailAsync(id, currentUserIdentity.EmpNo);
            return PartialView("_HoDDetailPartial", costCenterHoDTabDetail);
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, HRMastersHelper.RolePayRollAdmin)]
        public async Task<IActionResult> HoDTabEdit(string id)
        {
            CostCenterHoDCreateViewModel costCenterHoDCreateViewModel = new CostCenterHoDCreateViewModel();

            try
            {
                if (id == null)
                {
                    return NotFound();
                }

                UserIdentity currentUserIdentity = CurrentUserIdentity;
                var costCenterMasterHoDDetail = await _costCenterMasterMainRepository.CostCenterMasterHoDDetailAsync(id, currentUserIdentity.EmpNo);

                costCenterHoDCreateViewModel.CostCodeId = costCenterMasterHoDDetail.CostCodeId;
                costCenterHoDCreateViewModel.CostCode = costCenterMasterHoDDetail.CostCode;
                costCenterHoDCreateViewModel.DyHoD = costCenterMasterHoDDetail.DyHoD;
                costCenterHoDCreateViewModel.ChangedNemps = costCenterMasterHoDDetail.ChangedNemps;

                var employeeList = await _selectRepository.EmployeeSelectListCacheAsync();

                ViewData["DyHoDId"] = new SelectList(employeeList, "DataValueField", "DataTextField");
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
            }

            return PartialView("_ModalHoDEditPartial", costCenterHoDCreateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, HRMastersHelper.RolePayRollAdmin)]
        public async Task<IActionResult> HoDTabEdit(CostCenterHoDCreateViewModel costCenterHoDCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    CostCenterMasterHoDUpdate costCenterMasterHoDUpdate = new CostCenterMasterHoDUpdate();

                    costCenterMasterHoDUpdate.ParamCostcodeid = costCenterHoDCreateViewModel.CostCodeId;
                    costCenterMasterHoDUpdate.ParamDyHod = costCenterHoDCreateViewModel.DyHoD;
                    costCenterMasterHoDUpdate.ParamChangedNemps = costCenterHoDCreateViewModel.ChangedNemps;

                    var retVal = await _costCenterMasterRepository.CostCenterMasterHoDUpdate(costCenterMasterHoDUpdate);

                    if (retVal.OutParamSuccess == "OK")
                    {
                        return Json(new { success = "OK", response = retVal.OutParamMessage });
                    }
                    else
                    {
                        throw new Exception(retVal.OutParamMessage.Replace("-", " "));
                    }

                    //if (retVal.OutParamSuccess == "OK")
                    //{
                    //    Notify("Success", retVal.OutParamMessage, "toaster", NotificationType.success);
                    //}
                    //else
                    //{
                    //    Notify("Error", retVal.OutParamMessage, "toaster", NotificationType.error);
                    //}
                }
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
            }

            return RedirectToAction("HoDTabEdit", "CostCenter", new { id = costCenterHoDCreateViewModel.CostCodeId });
        }

        #endregion hod

        #region cost control

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, HRMastersHelper.ActionViewHRMasters)]
        public async Task<IActionResult> CostControlTabDetail(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            UserIdentity currentUserIdentity = CurrentUserIdentity;
            var costCenterCostControlTabDetail = await _costCenterMasterMainRepository.CostCenterMasterCostControlDetailAsync(id, currentUserIdentity.EmpNo);
            return PartialView("_CostControlDetailPartial", costCenterCostControlTabDetail);
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, HRMastersHelper.ActionViewHRMasters)]
        public async Task<IActionResult> GetPhases(string cmid)
        {
            if (cmid == null)
            {
                return NotFound();
            }

            var jobPhasesList = await _selectRepository.JobPhasesSelectListCacheAsync(cmid);

            return Json(jobPhasesList);
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, HRMastersHelper.RoleCostControlAdmin)]
        public async Task<IActionResult> CostControlTabEdit(string id)
        {
            CostCenterCostControlCreateViewModel costCenterCostControlCreateViewModel = new CostCenterCostControlCreateViewModel();

            try
            {
                if (id == null)
                {
                    return NotFound();
                }

                UserIdentity currentUserIdentity = CurrentUserIdentity;
                var costCenterMasterCostControlDetail = await _costCenterMasterMainRepository.CostCenterMasterCostControlDetailAsync(id, currentUserIdentity.EmpNo);

                costCenterCostControlCreateViewModel.CostCodeId = costCenterMasterCostControlDetail.CostCodeId;
                costCenterCostControlCreateViewModel.CostCode = costCenterMasterCostControlDetail.CostCode;
                costCenterCostControlCreateViewModel.Tm01Id = costCenterMasterCostControlDetail.Tm01Id;
                costCenterCostControlCreateViewModel.TmaId = costCenterMasterCostControlDetail.TmaId;
                costCenterCostControlCreateViewModel.Activity = costCenterMasterCostControlDetail.Activity;
                costCenterCostControlCreateViewModel.GroupChart = costCenterMasterCostControlDetail.GroupChart;
                costCenterCostControlCreateViewModel.ItalianName = costCenterMasterCostControlDetail.ItalianName;
                costCenterCostControlCreateViewModel.CmId = costCenterMasterCostControlDetail.CmId;
                costCenterCostControlCreateViewModel.Phase = costCenterMasterCostControlDetail.Phase;

                var tm01GrpList = await _selectRepository.TM01GRPSelectListCacheAsync();
                var tmaGrpList = await _selectRepository.TMAGRPSelectListCacheAsync();
                var compReportList = await _selectRepository.CompanyReportSelectListCacheAsync();
                var toggleList = new List<SelectListItem> { new SelectListItem { Text = "Yes", Value = "Yes"},
                                                            new SelectListItem { Text = "No", Value = "No"}
                                                          };

                ViewData["Tm01GrpId"] = new SelectList(tm01GrpList, "DataValueField", "DataTextField");
                ViewData["TmaGrpId"] = new SelectList(tmaGrpList, "DataValueField", "DataTextField");
                ViewData["ActivityList"] = new SelectList(toggleList, "Value", "Text");
                ViewData["GroupChartList"] = new SelectList(toggleList, "Value", "Text");
                ViewData["CompReportId"] = new SelectList(compReportList, "DataValueField", "DataTextField");

                if (!string.IsNullOrEmpty(costCenterMasterCostControlDetail.CmId))
                {
                    var jobPhasesList = await _selectRepository.JobPhasesSelectListCacheAsync(costCenterMasterCostControlDetail.CmId);
                    ViewData["JobPhasesId"] = new SelectList(jobPhasesList, "DataValueField", "DataTextField", costCenterMasterCostControlDetail.Phase);
                }
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
            }

            return PartialView("_ModalCostControlEditPartial", costCenterCostControlCreateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, HRMastersHelper.RoleCostControlAdmin)]
        public async Task<IActionResult> CostControlTabEdit(CostCenterCostControlCreateViewModel costCenterCostControlCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    CostCenterMasterCostControlUpdate costCenterMasterCostControlUpdate = new CostCenterMasterCostControlUpdate();

                    costCenterMasterCostControlUpdate.ParamCostcodeid = costCenterCostControlCreateViewModel.CostCodeId;
                    costCenterMasterCostControlUpdate.ParamTm01id = costCenterCostControlCreateViewModel.Tm01Id;
                    costCenterMasterCostControlUpdate.ParamTmaid = costCenterCostControlCreateViewModel.TmaId;
                    costCenterMasterCostControlUpdate.ParamActivity = costCenterCostControlCreateViewModel.Activity;
                    costCenterMasterCostControlUpdate.ParamGroupChart = costCenterCostControlCreateViewModel.GroupChart;
                    costCenterMasterCostControlUpdate.ParamItalianName = costCenterCostControlCreateViewModel.ItalianName;
                    costCenterMasterCostControlUpdate.ParamCmid = costCenterCostControlCreateViewModel.CmId;
                    costCenterMasterCostControlUpdate.ParamPhase = costCenterCostControlCreateViewModel.Phase;

                    var retVal = await _costCenterMasterRepository.CostCenterMasterCostControlUpdate(costCenterMasterCostControlUpdate);

                    if (retVal.OutParamSuccess == "OK")
                    {
                        return Json(new { success = "OK", response = retVal.OutParamMessage });
                    }
                    else
                    {
                        throw new Exception(retVal.OutParamMessage.Replace("-", " "));
                    }

                    //if (retVal.OutParamSuccess == "OK")
                    //{
                    //    Notify("Success", retVal.OutParamMessage, "toaster", NotificationType.success);
                    //}
                    //else
                    //{
                    //    Notify("Error", retVal.OutParamMessage, "toaster", NotificationType.error);
                    //}
                }
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
            }

            return RedirectToAction("CostControlTabEdit", "CostCenter", new { id = costCenterCostControlCreateViewModel.CostCodeId });
        }

        #endregion cost control

        #region afc

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, HRMastersHelper.ActionViewHRMasters)]
        public async Task<IActionResult> AFCTabDetail(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            UserIdentity currentUserIdentity = CurrentUserIdentity;
            var costCenterAFCTabDetail = await _costCenterMasterMainRepository.CostCenterMasterAFCDetailAsync(id, currentUserIdentity.EmpNo);
            return PartialView("_AFCDetailPartial", costCenterAFCTabDetail);
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, HRMastersHelper.RoleAFCAdmin)]
        public async Task<IActionResult> AFCTabEdit(string id)
        {
            CostCenterAFCCreateViewModel costCenterAFCCreateViewModel = new CostCenterAFCCreateViewModel();

            try
            {
                if (id == null)
                {
                    return NotFound();
                }

                UserIdentity currentUserIdentity = CurrentUserIdentity;
                var costCenterMasterAFCDetail = await _costCenterMasterMainRepository.CostCenterMasterAFCDetailAsync(id, currentUserIdentity.EmpNo);

                costCenterAFCCreateViewModel.CostCodeId = costCenterMasterAFCDetail.CostCodeId;
                costCenterAFCCreateViewModel.CostCode = costCenterMasterAFCDetail.CostCode;
                costCenterAFCCreateViewModel.TcmCostCodeId = costCenterMasterAFCDetail.TcmCostCodeId;
                costCenterAFCCreateViewModel.TcmActPhId = costCenterMasterAFCDetail.TcmActPhId;
                costCenterAFCCreateViewModel.TcmPasPhId = costCenterMasterAFCDetail.TcmPasPhId;
                costCenterAFCCreateViewModel.PO = costCenterMasterAFCDetail.PO;

                var tcmCostCenterList = await _selectRepository.TCMCostCenterSelectListCacheAsync();
                var tcmActPhList = await _selectRepository.TCMActPhSelectListCacheAsync();
                var tcmPasPhList = await _selectRepository.TCMPasPhSelectListCacheAsync();

                ViewData["tcmCostCenterId"] = new SelectList(tcmCostCenterList, "DataValueField", "DataTextField");
                ViewData["tcmActPhId"] = new SelectList(tcmActPhList, "DataValueField", "DataTextField");
                ViewData["tcmPasPhId"] = new SelectList(tcmPasPhList, "DataValueField", "DataTextField");
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
            }

            return PartialView("_ModalAFCEditPartial", costCenterAFCCreateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, HRMastersHelper.RoleAFCAdmin)]
        public async Task<IActionResult> AFCTabEdit(CostCenterAFCCreateViewModel costCenterAFCCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    CostCenterMasterAFCUpdate costCenterMasterAFCUpdate = new CostCenterMasterAFCUpdate();

                    costCenterMasterAFCUpdate.ParamCostcodeid = costCenterAFCCreateViewModel.CostCodeId;
                    costCenterMasterAFCUpdate.ParamTcmcostcodeid = costCenterAFCCreateViewModel.TcmCostCodeId;
                    costCenterMasterAFCUpdate.ParamTcmActPhId = costCenterAFCCreateViewModel.TcmActPhId;
                    costCenterMasterAFCUpdate.ParamTcmPasPhId = costCenterAFCCreateViewModel.TcmPasPhId;
                    costCenterMasterAFCUpdate.ParamPo = costCenterAFCCreateViewModel.PO;

                    var retVal = await _costCenterMasterRepository.CostCenterMasterAFCUpdate(costCenterMasterAFCUpdate);

                    if (retVal.OutParamSuccess == "OK")
                    {
                        return Json(new { success = "OK", response = retVal.OutParamMessage });
                    }
                    else
                    {
                        throw new Exception(retVal.OutParamMessage.Replace("-", " "));
                    }

                    //if (retVal.OutParamSuccess == "OK")
                    //{
                    //    Notify("Success", retVal.OutParamMessage, "toaster", NotificationType.success);
                    //}
                    //else
                    //{
                    //    Notify("Error", retVal.OutParamMessage, "toaster", NotificationType.error);
                    //}
                }
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
            }

            return RedirectToAction("AFCTabDetail", "CostCenter", new { id = costCenterAFCCreateViewModel.CostCodeId });
        }

        #endregion afc

        #region excel download

        public async Task<IActionResult> ExcelDownload()
        {
            try
            {
                DataTable dt = new DataTable();
                string strUser = User.Identity.Name;
                var result = (await _costCenterMasterMainDataTableListRepository.GetCostcenterMasterDownload()).ToList();

                if (result == null)
                {
                    return NotFound();
                }

                ListtoDataTableConverter converter = new ListtoDataTableConverter();
                dt = converter.ToDataTable(result);
                var timeStamp = DateTime.Now.ToFileTime();
                string StrFimeName = "CostcenterMasterDownload_" + timeStamp.ToString();
                using (XLWorkbook wb = new XLWorkbook())
                {
                    wb.Worksheets.Add(dt);
                    using (MemoryStream stream = new MemoryStream())
                    {
                        wb.SaveAs(stream);
                        stream.Position = 0;
                        

                        var mimeType = MimeTypeMap.GetMimeType("xlsx");

                        FileContentResult file = File(stream.ToArray(), mimeType, StrFimeName);

                        return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
                    }
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
            //return RedirectToAction("Index");
        }

        #endregion excel download
    }
}