using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.Common;
using TCMPLApp.DataAccess.Repositories.EmpGenInfo;
using TCMPLApp.Domain.Models;
using TCMPLApp.Domain.Models.EmpGenInfo;
using TCMPLApp.WebApp.Controllers;
using TCMPLApp.WebApp.CustomPolicyProvider;
using TCMPLApp.WebApp.Models;
using static TCMPLApp.WebApp.Classes.DTModel;

namespace TCMPLApp.WebApp.Areas.EmpGenInfo.Controllers
{
    [Authorize]
    [Area("EmpGenInfo")]
    public class VppConfigProcessController : BaseController
    {
        private readonly IFilterRepository _filterRepository;
        private const string ConstFilterVppConfigProcessIndex = "VppConfigProcessIndex";
        private readonly IHRVppConfigProcessDataTableListRepository _hRVppConfigProcessDataTableListRepository;
        private readonly IVppConfigProcessRepository _vppConfigProcessRepository;
        private readonly IHRVppConfigProcessDetailRepository _hRVppConfigProcessDetailRepository;
        private readonly IVppConfigPremiumDataTableListRepository _vppConfigPremiumDataTableListRepository;

        public VppConfigProcessController(
            IFilterRepository filterRepository,
            IHRVppConfigProcessDataTableListRepository hRVppConfigProcessDataTableListRepository,
            IVppConfigProcessRepository vppConfigProcessRepository,
            IHRVppConfigProcessDetailRepository hRVppConfigProcessDetailRepository,
            IVppConfigPremiumDataTableListRepository vppConfigPremiumDataTableListRepository)
        {
            _filterRepository = filterRepository;
            _hRVppConfigProcessDataTableListRepository = hRVppConfigProcessDataTableListRepository;
            _vppConfigProcessRepository = vppConfigProcessRepository;
            _hRVppConfigProcessDetailRepository = hRVppConfigProcessDetailRepository;
            _vppConfigPremiumDataTableListRepository = vppConfigPremiumDataTableListRepository;
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionVPPManagement)]
        public async Task<IActionResult> VppConfigProcessIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterVppConfigProcessIndex
            });

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            HRVppConfigProcessStatusViewModel hRVppConfigProcessStatusViewModel = new()
            {
                FilterDataModel = filterDataModel
            };
            return View(hRVppConfigProcessStatusViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsVppConfigProcessList(string paramJson)
        {
            DTResult<HRVppConfigProcessDataTableList> result = new();
            int totalRow = 0;
            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            try
            {
                System.Collections.Generic.IEnumerable<HRVppConfigProcessDataTableList> data = await _hRVppConfigProcessDataTableListRepository.HRVppConfigProcessDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch,
                        PRowNumber = param.Start,
                        PPageLength = param.Length
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
                return Json(new { error = ex.Message });
            }
        }

        [HttpGet]
        public IActionResult VppConfigProcessCreate()
        {
            HRVppConfigProcessCreateViewModel hRVppConfigProcessCreateViewModel = new();

            return PartialView("_ModalHRVppConfigProcessCreatePartial", hRVppConfigProcessCreateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionVPPManagement)]
        public async Task<IActionResult> VppConfigProcessCreate(HRVppConfigProcessCreateViewModel hRVppConfigProcessCreateViewModel)
        {
            if (hRVppConfigProcessCreateViewModel.BtnName == "SaveDraft")
            {
                hRVppConfigProcessCreateViewModel.IsDraft = 1;
            }
            else
            {
                hRVppConfigProcessCreateViewModel.IsDraft = 0;
            }
            hRVppConfigProcessCreateViewModel.IsDisplayPremium = 1;
            var result = await _vppConfigProcessRepository.VppConfigProcessCreateAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PEndDate = hRVppConfigProcessCreateViewModel.EndDate,
                        PIsDisplayPremium = hRVppConfigProcessCreateViewModel.IsDisplayPremium,
                        PIsDraft = hRVppConfigProcessCreateViewModel.IsDraft,
                        PEmpJoiningDate = hRVppConfigProcessCreateViewModel.EmpJoiningDate,
                        PIsApplicableToAll = hRVppConfigProcessCreateViewModel.IsApplicableToAll,
                    }
                );

            return result.PMessageType != IsOk
                    ? throw new Exception(result.PMessageText.Replace("-", " "))
                    : (IActionResult)Json(new { success = true, response = result.PMessageText });
        }

        [HttpGet]
        public async Task<IActionResult> VppConfigProcessDetail(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            HRVppConfigProcessDetails result = await _hRVppConfigProcessDetailRepository.HRVppConfigProcessDetail(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PKeyId = id
                });

            HRVppConfigProcessDetailsViewModel hRVppConfigProcessDetailsViewModel = new();

            if (result.PMessageType == IsOk)
            {
                hRVppConfigProcessDetailsViewModel.StartDate = result.PStartDate;
                hRVppConfigProcessDetailsViewModel.EndDate = result.PEndDate;
                hRVppConfigProcessDetailsViewModel.IsDisplayPremiumVal = result.PIsDisplayPremiumVal;
                hRVppConfigProcessDetailsViewModel.IsDisplayPremiumText = result.PIsDisplayPremiumText;
                hRVppConfigProcessDetailsViewModel.IsDraft = result.PIsDraftVal;
                hRVppConfigProcessDetailsViewModel.IsDraftText = result.PIsDraftText;
                hRVppConfigProcessDetailsViewModel.EmpJoiningDate = result.PEmpJoiningDate;
                hRVppConfigProcessDetailsViewModel.IsInitiateConfig = result.PIsInitiateConfigVal;
                hRVppConfigProcessDetailsViewModel.IsInitiateConfigText = result.PIsInitiateConfigText;
                hRVppConfigProcessDetailsViewModel.IsApplicableToAll = result.PIsApplicableToAllVal;
                hRVppConfigProcessDetailsViewModel.IsApplicableToAllText = result.PIsApplicableToAllText;
                hRVppConfigProcessDetailsViewModel.CreatedBy = result.PCreatedBy;
                hRVppConfigProcessDetailsViewModel.CreatedOn = result.PCreatedOn;
                hRVppConfigProcessDetailsViewModel.ModifiedBy = result.PModifiedBy;
                hRVppConfigProcessDetailsViewModel.ModifiedOn = result.PModifiedOn;
            }

            IEnumerable<VppConfigPremiumDataTableList> data = await _vppConfigPremiumDataTableListRepository
                                            .VppConfigPremiumDataTableList(
                                                BaseSpTcmPLGet(),
                                                new ParameterSpTcmPL
                                                {
                                                    PKeyId = id,
                                                    PRowNumber = 0,
                                                    PPageLength = 99999
                                                }
                                            );

            hRVppConfigProcessDetailsViewModel.vppConfigPremiumDataTableList = data;

            return PartialView("_ModalHRVppConfigProcessDetailsPartial", hRVppConfigProcessDetailsViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> VppConfigProcessEdit(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            HRVppConfigProcessDetails result = await _hRVppConfigProcessDetailRepository.HRVppConfigProcessDetail(
                 BaseSpTcmPLGet(),
                 new ParameterSpTcmPL
                 {
                     PKeyId = id
                 });

            HRVppConfigProcessUpdateViewModel hRVppConfigProcessUpdateViewModel = new();

            if (result.PMessageType == IsOk)
            {
                hRVppConfigProcessUpdateViewModel.keyid = id;
                hRVppConfigProcessUpdateViewModel.EndDate = result.PEndDate;
                hRVppConfigProcessUpdateViewModel.IsDisplayPremium = result.PIsDisplayPremiumVal;
                hRVppConfigProcessUpdateViewModel.IsDraft = result.PIsDraftVal;
                hRVppConfigProcessUpdateViewModel.EmpJoiningDate = result.PEmpJoiningDate;
                hRVppConfigProcessUpdateViewModel.IsApplicableToAll = result.PIsApplicableToAllVal;
            }

            return PartialView("_ModalHRVppConfigProcessEditPartial", hRVppConfigProcessUpdateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionVPPManagement)]
        public async Task<IActionResult> VppConfigProcessEdit([FromForm] HRVppConfigProcessUpdateViewModel hRVppConfigProcessUpdateViewModel)
        {
            if (ModelState.IsValid)
            {
                Domain.Models.Common.DBProcMessageOutput result = await _vppConfigProcessRepository.VppConfigProcessEditAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PKeyId = hRVppConfigProcessUpdateViewModel.keyid,
                        PEndDate = hRVppConfigProcessUpdateViewModel.EndDate,
                        PIsDisplayPremium = hRVppConfigProcessUpdateViewModel.IsDisplayPremium,
                        PIsDraft = hRVppConfigProcessUpdateViewModel.IsDraft,
                        PEmpJoiningDate = hRVppConfigProcessUpdateViewModel.EmpJoiningDate,
                        PIsApplicableToAll = hRVppConfigProcessUpdateViewModel.IsApplicableToAll,
                    });

                return result.PMessageType != BaseController.IsOk
                    ? throw new Exception(result.PMessageText.Replace("-", " "))
                    : (IActionResult)base.Json(new { success = true, response = result.PMessageText });
            }

            return PartialView("_ModalHRVppConfigProcessEditPartial", hRVppConfigProcessUpdateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionVPPManagement)]
        public async Task<IActionResult> VppConfigProcessDelete(string id)
        {
            try
            {
                Domain.Models.Common.DBProcMessageOutput result = await _vppConfigProcessRepository.VppConfigProcessDeleteAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PKeyId = id
                    }
                    );

                return base.Json(new { success = result.PMessageType == BaseController.IsOk, response = result.PMessageType, message = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionVPPManagement)]
        public async Task<IActionResult> VppConfigProcessDeactivate(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            HRVppConfigProcessDetails result = await _hRVppConfigProcessDetailRepository.HRVppConfigProcessDetail(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PKeyId = id
                });

            HRVppConfigProcessDetailsViewModel hRVppConfigProcessDetailsViewModel = new();

            if (result.PMessageType == IsOk)
            {
                hRVppConfigProcessDetailsViewModel.KeyId = id;
                hRVppConfigProcessDetailsViewModel.StartDate = result.PStartDate;
                hRVppConfigProcessDetailsViewModel.EndDate = result.PEndDate;
                hRVppConfigProcessDetailsViewModel.IsDisplayPremiumVal = result.PIsDisplayPremiumVal;
                hRVppConfigProcessDetailsViewModel.IsDisplayPremiumText = result.PIsDisplayPremiumText;
                hRVppConfigProcessDetailsViewModel.IsDraft = result.PIsDraftVal;
                hRVppConfigProcessDetailsViewModel.IsDraftText = result.PIsDraftText;
                hRVppConfigProcessDetailsViewModel.EmpJoiningDate = result.PEmpJoiningDate;
                hRVppConfigProcessDetailsViewModel.IsInitiateConfig = result.PIsInitiateConfigVal;
                hRVppConfigProcessDetailsViewModel.IsInitiateConfigText = result.PIsInitiateConfigText;
                hRVppConfigProcessDetailsViewModel.IsApplicableToAll = result.PIsApplicableToAllVal;
                hRVppConfigProcessDetailsViewModel.IsApplicableToAllText = result.PIsApplicableToAllText;
                hRVppConfigProcessDetailsViewModel.CreatedBy = result.PCreatedBy;
                hRVppConfigProcessDetailsViewModel.CreatedOn = result.PCreatedOn;
                hRVppConfigProcessDetailsViewModel.ModifiedBy = result.PModifiedBy;
                hRVppConfigProcessDetailsViewModel.ModifiedOn = result.PModifiedOn;
            }

            //HRVppConfigProcessDeactiveViewModel hRVppConfigProcessDeactiveViewModel = new();
            //hRVppConfigProcessDeactiveViewModel.keyid = id;

            return PartialView("_ModalHRVppConfigProcessDeactivatePartial", hRVppConfigProcessDetailsViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionVPPManagement)]
        public async Task<IActionResult> VppConfigProcessDeactivate(string KeyId, DateTime enddate)
        {
            try
            {
                Domain.Models.Common.DBProcMessageOutput result = await _vppConfigProcessRepository.VppConfigProcessDeactivateAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PKeyId = KeyId,
                        PEndDate = enddate
                    }
                    );

                return base.Json(new { success = result.PMessageType == BaseController.IsOk, response = result.PMessageType, message = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionVPPManagement)]
        public async Task<IActionResult> VppConfigProcessActiveDetails(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            HRVppConfigProcessDetails result = await _hRVppConfigProcessDetailRepository.HRVppConfigProcessDetail(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PKeyId = id
                });

            HRVppConfigProcessDetailsViewModel hRVppConfigProcessDetailsViewModel = new();

            if (result.PMessageType == IsOk)
            {
                hRVppConfigProcessDetailsViewModel.KeyId = id;
                hRVppConfigProcessDetailsViewModel.StartDate = result.PStartDate;
                hRVppConfigProcessDetailsViewModel.EndDate = result.PEndDate;
                hRVppConfigProcessDetailsViewModel.IsDisplayPremiumVal = result.PIsDisplayPremiumVal;
                hRVppConfigProcessDetailsViewModel.IsDisplayPremiumText = result.PIsDisplayPremiumText;
                hRVppConfigProcessDetailsViewModel.IsDraft = result.PIsDraftVal;
                hRVppConfigProcessDetailsViewModel.IsDraftText = result.PIsDraftText;
                hRVppConfigProcessDetailsViewModel.EmpJoiningDate = result.PEmpJoiningDate;
                hRVppConfigProcessDetailsViewModel.IsInitiateConfig = result.PIsInitiateConfigVal;
                hRVppConfigProcessDetailsViewModel.IsInitiateConfigText = result.PIsInitiateConfigText;
                hRVppConfigProcessDetailsViewModel.IsApplicableToAll = result.PIsApplicableToAllVal;
                hRVppConfigProcessDetailsViewModel.IsApplicableToAllText = result.PIsApplicableToAllText;
                hRVppConfigProcessDetailsViewModel.CreatedBy = result.PCreatedBy;
                hRVppConfigProcessDetailsViewModel.CreatedOn = result.PCreatedOn;
                hRVppConfigProcessDetailsViewModel.ModifiedBy = result.PModifiedBy;
                hRVppConfigProcessDetailsViewModel.ModifiedOn = result.PModifiedOn;
            }

            return PartialView("_ModalHRVppConfigProcessActivePartial", hRVppConfigProcessDetailsViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionVPPManagement)]
        public async Task<IActionResult> VppConfigProcessActive(string KeyId)
        {
            try
            {
                Domain.Models.Common.DBProcMessageOutput result = await _vppConfigProcessRepository.VppConfigProcessActivateAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PKeyId = KeyId
                    });

                return result.PMessageType != IsOk
                        ? throw new Exception(result.PMessageText.Replace("-", " "))
                        : (IActionResult)Json(new { success = true, response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsVppConfigPremiumList(string paramJson)
        {
            DTResult<VppConfigPremiumDataTableList> result = new();
            int totalRow = 0;
            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            try
            {
                IEnumerable<VppConfigPremiumDataTableList> data = await _vppConfigPremiumDataTableListRepository
                                            .VppConfigPremiumDataTableList(
                                                BaseSpTcmPLGet(),
                                                new ParameterSpTcmPL
                                                {
                                                    PKeyId = param.ApplicationId,
                                                    PRowNumber = 0,
                                                    PPageLength = 99999
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
                return Json(new { error = ex.Message });
            }
        }
    }
}