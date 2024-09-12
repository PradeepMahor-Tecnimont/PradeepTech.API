using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using MimeTypes;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.Common;
using TCMPLApp.DataAccess.Repositories.CoreSettings;
using TCMPLApp.DataAccess.Repositories.SWPVaccine;
using TCMPLApp.Domain.Models.CoreSettings;
using TCMPLApp.Domain.Models.DeskBooking;
using TCMPLApp.Library.Excel.Template.Models;
using TCMPLApp.WebApp.Classes;
using TCMPLApp.WebApp.Controllers;
using TCMPLApp.WebApp.CustomPolicyProvider;
using TCMPLApp.WebApp.Models;
using static TCMPLApp.WebApp.Classes.DTModel;

namespace TCMPLApp.WebApp.Areas.CoreSettings.Controllers
{
    [Authorize]
    [Area("CoreSettings")]
    public class UserAccessController : BaseController
    {
        private const string ConstModuleRole = "R003";

        private const string ConstFlagAuto = "1";
        private const string ConstFlagManual = "2";
        private const string ConstFlagCostCode = "3";
        private const string ConstFlagProject = "4";
        private const string ConstFlagDelegates = "5";

        private const string ConstFilterRolesIndex = "UserAccessRolesIndex";
        private const string ConstFilterModuleRolesIndex = "UserAccesssModuleRolesIndex";
        private const string ConstFilterModuleRolesActionsIndex = "UserAccesssModuleRolesActionsIndex";
        private const string ConstFilterActionsIndex = "UserAccesssActionsIndex";
        private const string ConstFilterModuleActionsIndex = "UserAccesssModuleActionsIndex";
        private const string ConstFilterModuleRolesUsersIndex = "UserAccesssModuleRolesUsersIndex";
        private const string ConstFilterModuleRoleUserLogsIndex = "UserAccesssModuleUserRoleLogsIndex";
        private const string ConstFilterModuleUserRoleActionsIndex = "UserAccesssModuleUserRoleActionsIndex";
        private const string ConstFilterModuleUserRoleCodeCodeIndex = "UserAccesssModuleUserRoleCodecodeIndex";

        private const string ConstFilterDelegateIndex = "DelegateIndex";
        private const string ConstFilterDelegateLogsIndex = "DelegateLogsIndex";

        private readonly IFilterRepository _filterRepository;
        private readonly ISelectTcmPLRepository _selectTcmPLRepository;
        private readonly IUtilityRepository _utilityRepository;

        private readonly IModulesRepository _modulesRepository;
        private readonly IModulesDataTableListRepository _modulesDataTableListRepository;

        private readonly IRolesDataTableListRepository _rolesDataTableListRepository;
        private readonly IRolesRepository _rolesRepository;
        private readonly IRolesDetailRepository _rolesDetailRepository;

        private readonly IActionsDataTableListRepository _actionsDataTableListRepository;
        private readonly IActionsRepository _actionsRepository;
        private readonly IActionsDetailRepository _actionsDetailRepository;

        private readonly IModuleActionsDataTableListRepository _moduleActionsDataTableListRepository;
        private readonly IModuleActionsRepository _moduleActionsRepository;
        //private readonly IModuleActionsDetailRepository _moduleActionsDetailRepository;

        private readonly IModuleRolesDataTableListRepository _moduleRolesDataTableListRepository;
        private readonly IModuleRolesRepository _moduleRolesRepository;
        private readonly IModuleRolesDetailRepository _moduleRolesDetailRepository;

        private readonly IModuleRolesActionsDataTableListRepository _moduleRolesActionsDataTableListRepository;
        private readonly IModuleRolesActionsRepository _moduleRolesActionsRepository;
        private readonly IModuleRolesActionsDetailRepository _moduleRolesActionsDetailRepository;

        private readonly IModuleUserRolesDataTableListRepository _moduleUserRolesDataTableListRepository;
        private readonly IModuleUserRolesRepository _moduleUserRolesRepository;
        private readonly IModuleUserRolesDetailRepository _moduleUserRolesDetailRepository;

        private readonly IVUModuleUserRoleActionsDataTableListRepository _VUModuleUserRoleActionsDataTableListRepository;

        private readonly IModuleUserRoleActionsDataTableListRepository _moduleUserRoleActionsDataTableListRepository;

        private readonly IDelegateDataTableListRepository _delegateDataTableListRepository;
        private readonly IDelegateRepository _delegateRepository;
        private readonly IModuleUserRoleCostCodeDataTableListRepository _moduleUserRoleCostCodeDataTableListRepository;
        private readonly IModuleUserRoleCostCodeRepository _moduleUserRoleCostCodeRepository;
        private readonly IModuleUserRoleBulkUploadRepository _moduleUserRoleBulkUploadRepository;

        public UserAccessController(
                IFilterRepository filterRepository,
                IUtilityRepository utilityRepository,
                ISelectTcmPLRepository selectTcmPLRepository,
                IModulesDetailRepository modulesDetailRepository,
                IModulesDataTableListRepository modulesDataTableListRepository,
                IModulesRepository modulesRepository,
                IRolesDataTableListRepository rolesDataTableListRepository,
                IRolesRepository rolesRepository,
                IRolesDetailRepository rolesDetailRepository,
                IActionsDataTableListRepository actionsDataTableListRepository,
                IActionsRepository actionsRepository,
                IActionsDetailRepository actionsDetailRepository,
                IModuleRolesDataTableListRepository moduleRolesDataTableListRepository,
                IModuleRolesRepository moduleRolesRepository,
                IModuleRolesDetailRepository moduleRolesDetailRepository,
                IModuleRolesActionsDataTableListRepository moduleRolesActionsDataTableListRepository,
                IModuleRolesActionsRepository moduleRolesActionsRepository,
                IModuleRolesActionsDetailRepository moduleRolesActionsDetailRepository,
                IModuleUserRolesDataTableListRepository moduleUserRolesDataTableListRepository,
                IModuleUserRolesRepository moduleUserRolesRepository,
                IModuleUserRolesDetailRepository moduleUserRolesDetailRepository,
                IVUModuleUserRoleActionsDataTableListRepository VUModuleUserRoleActionsDataTableListRepository,
                IModuleUserRoleActionsDataTableListRepository moduleUserRoleActionsDataTableListRepository,
                IDelegateDataTableListRepository delegateDataTableListRepository,
                IDelegateRepository delegateRepository,
                IModuleUserRoleCostCodeDataTableListRepository moduleUserRoleCostCodeDataTableListRepository,
                IModuleUserRoleCostCodeRepository moduleUserRoleCostCodeRepository,
                IModuleActionsDataTableListRepository moduleActionsDataTableListRepository,
                IModuleActionsRepository moduleActionsRepository,
                IModuleUserRoleBulkUploadRepository moduleUserRoleBulkUploadRepository

            )
        {
            _filterRepository = filterRepository;
            _utilityRepository=utilityRepository;
            _modulesDataTableListRepository = modulesDataTableListRepository;
            _modulesRepository = modulesRepository;
            _rolesDataTableListRepository = rolesDataTableListRepository;
            _rolesRepository = rolesRepository;
            _rolesDetailRepository = rolesDetailRepository;
            _selectTcmPLRepository = selectTcmPLRepository;
            _actionsDataTableListRepository = actionsDataTableListRepository;
            _actionsRepository = actionsRepository;
            _actionsDetailRepository = actionsDetailRepository;
            _moduleRolesDataTableListRepository = moduleRolesDataTableListRepository;
            _moduleRolesRepository = moduleRolesRepository;
            _moduleRolesDetailRepository = moduleRolesDetailRepository;
            _moduleRolesActionsDataTableListRepository = moduleRolesActionsDataTableListRepository;
            _moduleRolesActionsRepository = moduleRolesActionsRepository;
            _moduleRolesActionsDetailRepository = moduleRolesActionsDetailRepository;
            _moduleUserRolesDataTableListRepository = moduleUserRolesDataTableListRepository;
            _moduleUserRolesRepository = moduleUserRolesRepository;
            _moduleUserRolesDetailRepository = moduleUserRolesDetailRepository;
            _VUModuleUserRoleActionsDataTableListRepository = VUModuleUserRoleActionsDataTableListRepository;
            _moduleUserRoleActionsDataTableListRepository = moduleUserRoleActionsDataTableListRepository;
            _delegateRepository = delegateRepository;
            _delegateDataTableListRepository = delegateDataTableListRepository;
            _moduleUserRoleCostCodeDataTableListRepository = moduleUserRoleCostCodeDataTableListRepository;
            _moduleUserRoleCostCodeRepository = moduleUserRoleCostCodeRepository;
            _moduleActionsDataTableListRepository = moduleActionsDataTableListRepository;
            _moduleActionsRepository = moduleActionsRepository;
            _moduleUserRoleBulkUploadRepository= moduleUserRoleBulkUploadRepository;
        }

        public IActionResult Index()
        {
            return View();
        }

        #region Modules

        public async Task<IActionResult> ModulesIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterRolesIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            ModulesViewModel modulesViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(modulesViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsModules(string paramJSon)
        {
            DTResult<ModulesDataTableList> result = new();
            int totalRow = 0;

            try
            {
                DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJSon);

                System.Collections.Generic.IEnumerable<ModulesDataTableList> data = await _modulesDataTableListRepository.ModulesDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch ?? " ",
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
        [RoleActionAuthorize(Helper.PolicyNamePrefixAction, CoreSettingsHelper.ActionEditUserAccess)]
        public IActionResult ModulesCreate()
        {
            ModulesCreateViewModel modulesCreateViewModel = new();

            return PartialView("_ModalModulesCreatePartial", modulesCreateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(Helper.PolicyNamePrefixAction, CoreSettingsHelper.ActionEditUserAccess)]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ModulesCreate([FromForm] ModulesCreateViewModel modulesCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _modulesRepository.ModulesCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PModuleName = modulesCreateViewModel.ModuleName,
                            PModuleLongDesc = modulesCreateViewModel.ModuleLongDesc,
                            PIsActiveChar = modulesCreateViewModel.IsActive,
                            PModuleSchemaName = modulesCreateViewModel.ModuleSchemaName,
                            PFuncToCheckUserAccess = modulesCreateViewModel.FuncToCheckUserAccess,
                            PModuleShortDesc = modulesCreateViewModel.ModuleShortDesc
                        });

                    return result.PMessageType != IsOk
                        ? throw new Exception(result.PMessageText.Replace("-", " "))
                        : (IActionResult)Json(new { success = true, response = result.PMessageText });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            return PartialView("_ModalModulesCreatePartial", modulesCreateViewModel);
        }

        //[HttpGet]
        //public async Task<IActionResult> ModulesEdit(string id)
        //{
        //    if (id == null)
        //    {
        //        return NotFound();
        //    }

        // ModulesDetails result = await _modulesDetailRepository.ModulesDetail( BaseSpTcmPLGet(),
        // new ParameterSpTcmPL { PModuleId = id });

        // ModulesUpdateViewModel modulesUpdateViewModel = new();

        // if (result.PMessageType == Success) { modulesUpdateViewModel.ModuleId = id;
        // modulesUpdateViewModel.ModuleName = result.PModuleName;
        // modulesUpdateViewModel.ModuleLongDesc = result.PModuleLongDesc;
        // modulesUpdateViewModel.ModuleIsActive = result.PModuleIsActive;
        // modulesUpdateViewModel.ModuleSchemaName = result.PModuleSchemaName;
        // modulesUpdateViewModel.FuncToCheckUserAccess = result.PFuncToCheckUserAccess;
        // modulesUpdateViewModel.ModuleShortDesc = result.PModuleShortDesc;

        // }

        //    return PartialView("_ModalModulesEditPartial", modulesUpdateViewModel);
        //}

        //[HttpPost]
        ////[RoleActionAuthorize(Helper.PolicyNamePrefixAction, JOBHelper.ActionEditJob)]
        //[ValidateAntiForgeryToken]
        //public async Task<IActionResult> ModulesEdit([FromForm] ModulesUpdateViewModel modulesUpdateViewModel)
        //{
        //    try
        //    {
        //        if (ModelState.IsValid)
        //        {
        //            var result = await _modulesRepository.ModulesEditAsync(
        //                BaseSpTcmPLGet(),
        //                new ParameterSpTcmPL
        //                {
        //                    PModuleName = modulesUpdateViewModel.ModuleName,
        //                    PModuleLongDesc = modulesUpdateViewModel.ModuleLongDesc,
        //                    PModuleIsActive = modulesUpdateViewModel.ModuleIsActive,
        //                    PModuleSchemaName = modulesUpdateViewModel.ModuleSchemaName,
        //                    PFuncToCheckUserAccess = modulesUpdateViewModel.FuncToCheckUserAccess,
        //                    PModuleShortDesc = modulesUpdateViewModel.ModuleShortDesc,
        //                });

        // return result.PMessageType != Success ? throw new
        // Exception(result.PMessageText.Replace("-", " ")) : (IActionResult)Json(new { success =
        // true, response = result.PMessageText }); } } catch (Exception ex) { return
        // StatusCode((int)HttpStatusCode.InternalServerError,
        // StringHelper.CleanExceptionMessage(ex.Message)); }

        //    return PartialView("_ModalModulesEditPartial", modulesUpdateViewModel);
        //}

        [HttpPost]
        [RoleActionAuthorize(Helper.PolicyNamePrefixAction, CoreSettingsHelper.ActionEditUserAccess)]
        public async Task<IActionResult> ModulesDelete(string id)
        {
            try
            {
                Domain.Models.Common.DBProcMessageOutput result = await _modulesRepository.ModulesDeleteAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PModuleId = id
                    }
                    );

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageType, message = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        #endregion Modules

        #region Roles

        public async Task<IActionResult> RolesIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterRolesIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            RolesViewModel rolesViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(rolesViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsRoles(string paramJSon)
        {
            DTResult<RolesDataTableList> result = new();
            int totalRow = 0;

            try
            {
                DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJSon);
                System.Collections.Generic.IEnumerable<RolesDataTableList> data = await _rolesDataTableListRepository.RolesDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch ?? " ",
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
        [RoleActionAuthorize(Helper.PolicyNamePrefixAction, CoreSettingsHelper.ActionEditUserAccess)]
        public async Task<IActionResult> RolesCreate()
        {
            RolesCreateViewModel rolesCreateViewModel = new();
            //FlagIdList
            IEnumerable<DataField> flagIdList = await _selectTcmPLRepository.FlagIdList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });

            ViewData["FlagIdList"] = new SelectList(flagIdList, "DataValueField", "DataTextField");
            return PartialView("_ModalRolesCreatePartial", rolesCreateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(Helper.PolicyNamePrefixAction, CoreSettingsHelper.ActionEditUserAccess)]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> RolesCreate([FromForm] RolesCreateViewModel rolesCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _rolesRepository.RolesCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PRoleName = rolesCreateViewModel.RoleName,
                            PRoleDesc = rolesCreateViewModel.RoleDesc,
                            PIsActiveChar = rolesCreateViewModel.RoleIsActive,
                            PRoleId = rolesCreateViewModel.RoleId,
                            PFlagId = rolesCreateViewModel.FlagId,
                        });

                    return result.PMessageType != IsOk
                        ? throw new Exception(result.PMessageText.Replace("-", " "))
                        : (IActionResult)Json(new { success = true, response = result.PMessageText });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            IEnumerable<DataField> flagIdList = await _selectTcmPLRepository.FlagIdList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });

            ViewData["FlagIdList"] = new SelectList(flagIdList, "DataValueField", "DataTextField", rolesCreateViewModel.FlagId);
            return PartialView("_ModalRolesCreatePartial", rolesCreateViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> RoleEdit(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            RolesDetails result = await _rolesDetailRepository.RolesDetail(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PRoleId = id
                });

            RolesUpdateViewModel rolesUpdateViewModel = new();

            if (result.PMessageType == IsOk)
            {
                rolesUpdateViewModel.RoleId = id;
                rolesUpdateViewModel.RoleName = result.PRoleName;
                rolesUpdateViewModel.RoleDesc = result.PRoleDesc;
                rolesUpdateViewModel.RoleIsActive = result.PRoleIsActive;
            }

            return PartialView("_ModalRolesEditPartial", rolesUpdateViewModel);
        }

        [HttpPost]
        //[RoleActionAuthorize(Helper.PolicyNamePrefixAction, JOBHelper.ActionEditJob)]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> RoleEdit([FromForm] RolesUpdateViewModel rolesUpdateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _rolesRepository.RolesEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PRoleId = rolesUpdateViewModel.RoleId,
                            PRoleName = rolesUpdateViewModel.RoleName,
                            PRoleDesc = rolesUpdateViewModel.RoleDesc,
                            PRoleIsActive = rolesUpdateViewModel.RoleIsActive
                        });

                    return result.PMessageType != IsOk
                        ? throw new Exception(result.PMessageText.Replace("-", " "))
                        : (IActionResult)Json(new { success = true, response = result.PMessageText });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            return PartialView("_ModalRolesEditPartial", rolesUpdateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(Helper.PolicyNamePrefixAction, CoreSettingsHelper.ActionEditUserAccess)]
        public async Task<IActionResult> RolesDelete(string id)
        {
            try
            {
                Domain.Models.Common.DBProcMessageOutput result = await _rolesRepository.RolesDeleteAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRoleId = id
                    }
                    );

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageType, message = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        #endregion Roles

        #region ModuleRoles

        public async Task<IActionResult> ModuleRolesIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterModuleRolesIndex
            });

            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            ModuleRolesViewModel moduleRolesViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(moduleRolesViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsModuleRoles(string paramJSon)
        {
            DTResult<ModuleRolesDataTableList> result = new();
            int totalRow = 0;

            try
            {
                DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJSon);
                System.Collections.Generic.IEnumerable<ModuleRolesDataTableList> data = await _moduleRolesDataTableListRepository.ModuleRolesDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch ?? " ",
                        PModuleId = param.ModuleId,
                        PRoleId = param.RoleId,
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
        [RoleActionAuthorize(Helper.PolicyNamePrefixAction, CoreSettingsHelper.ActionEditUserAccess)]
        public async Task<IActionResult> ModuleRolesCreate()
        {
            ModuleRolesCreateViewModel moduleRolesCreateViewModel = new();

            IEnumerable<DataField> ModuleIdList = await _selectTcmPLRepository.ModuleIdList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });

            IEnumerable<DataField> RoleIdList = await _selectTcmPLRepository.RoleIdList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });

            ViewData["ModuleIdList"] = new SelectList(ModuleIdList, "DataValueField", "DataTextField");
            ViewData["RoleIdList"] = new SelectList(RoleIdList, "DataValueField", "DataTextField");

            return PartialView("_ModalModuleRolesCreatePartial", moduleRolesCreateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(Helper.PolicyNamePrefixAction, CoreSettingsHelper.ActionEditUserAccess)]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ModuleRolesCreate([FromForm] ModuleRolesCreateViewModel moduleRolesCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _moduleRolesRepository.ModuleRolesCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PModuleId = moduleRolesCreateViewModel.ModuleId,
                            PRoleId = moduleRolesCreateViewModel.RoleId,
                            //PModuleRoleKeyId = moduleRolesCreateViewModel.ModuleRoleKeyId
                        });

                    return result.PMessageType != IsOk
                        ? throw new Exception(result.PMessageText.Replace("-", " "))
                        : (IActionResult)Json(new { success = true, response = result.PMessageText });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            IEnumerable<DataField> ModuleIdList = await _selectTcmPLRepository.ModuleIdList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });

            IEnumerable<DataField> RoleIdList = await _selectTcmPLRepository.RoleIdList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });

            ViewData["ModuleIdList"] = new SelectList(ModuleIdList, "DataValueField", "DataTextField");
            ViewData["RoleIdList"] = new SelectList(RoleIdList, "DataValueField", "DataTextField");
            return PartialView("_ModalModuleRolesCreatePartial", moduleRolesCreateViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> ModuleRolesEdit(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            ModuleRolesDetails result = await _moduleRolesDetailRepository.ModuleRolesDetail(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PKeyId = id
                });

            ModuleRolesUpdateViewModel moduleRolesUpdateViewModel = new();

            if (result.PMessageType == IsOk)
            {
                moduleRolesUpdateViewModel.ModuleRoleKeyId = id;
                moduleRolesUpdateViewModel.ModuleId = result.PModuleId;
                moduleRolesUpdateViewModel.RoleId = result.PRoleId;
            }

            IEnumerable<DataField> ModuleIdList = await _selectTcmPLRepository.ModuleIdList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });

            IEnumerable<DataField> RoleIdList = await _selectTcmPLRepository.RoleIdList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });

            ViewData["ModuleIdList"] = new SelectList(ModuleIdList, "DataValueField", "DataTextField", moduleRolesUpdateViewModel.ModuleId);
            ViewData["RoleleIdList"] = new SelectList(RoleIdList, "DataValueField", "DataTextField", moduleRolesUpdateViewModel.RoleId);

            return PartialView("_ModalModuleRolesEditPartial", moduleRolesUpdateViewModel);
        }

        [HttpPost]
        //[RoleActionAuthorize(Helper.PolicyNamePrefixAction, JOBHelper.ActionEditJob)]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ModuleRolesEdit([FromForm] ModuleRolesUpdateViewModel moduleRolesUpdateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _moduleRolesRepository.ModuleRolesEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PKeyId = moduleRolesUpdateViewModel.ModuleRoleKeyId,
                            PModuleId = moduleRolesUpdateViewModel.ModuleId,
                            PRoleId = moduleRolesUpdateViewModel.RoleId
                        });

                    return result.PMessageType != IsOk
                        ? throw new Exception(result.PMessageText.Replace("-", " "))
                        : (IActionResult)Json(new { success = true, response = result.PMessageText });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            IEnumerable<DataField> ModuleIdList = await _selectTcmPLRepository.ModuleIdList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });

            IEnumerable<DataField> RoleIdList = await _selectTcmPLRepository.RoleIdList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });

            ViewData["ModuleIdList"] = new SelectList(ModuleIdList, "DataValueField", "DataTextField", moduleRolesUpdateViewModel.ModuleId);
            ViewData["RoleIdList"] = new SelectList(RoleIdList, "DataValueField", "DataTextField", moduleRolesUpdateViewModel.RoleId);

            return PartialView("_ModalModuleRolesEditPartial", moduleRolesUpdateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(Helper.PolicyNamePrefixAction, CoreSettingsHelper.ActionEditUserAccess)]
        public async Task<IActionResult> ModuleRolesDelete(string id)
        {
            try
            {
                Domain.Models.Common.DBProcMessageOutput result = await _moduleRolesRepository.ModuleRolesDeleteAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PModuleRoleKeyId = id
                    }
                    );

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageType, message = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        #endregion ModuleRoles

        #region Actions

        public async Task<IActionResult> ActionsIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterActionsIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            ActionsViewModel actionsViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(actionsViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsAction(string paramJSon)
        {
            DTResult<ActionsDataTableList> result = new();
            int totalRow = 0;

            try
            {
                DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJSon);

                System.Collections.Generic.IEnumerable<ActionsDataTableList> data = await _actionsDataTableListRepository.ActionsDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch ?? " ",
                        PActionId = param.ActionId,
                        PModuleId = param.ModuleId,
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
        [RoleActionAuthorize(Helper.PolicyNamePrefixAction, CoreSettingsHelper.ActionEditUserAccess)]
        public IActionResult ActionsCreate()
        {
            ActionsCreateViewModel actionsCreateViewModel = new();

            return PartialView("_ModalActionsCreatePartial", actionsCreateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(Helper.PolicyNamePrefixAction, CoreSettingsHelper.ActionEditUserAccess)]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ActionsCreate([FromForm] ActionsCreateViewModel actionsCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _actionsRepository.ActionsCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PActionName = actionsCreateViewModel.ActionName,
                            PActionDesc = actionsCreateViewModel.ActionDesc,
                            PActionId = actionsCreateViewModel.ActionId
                        });

                    return result.PMessageType != IsOk
                        ? throw new Exception(result.PMessageText.Replace("-", " "))
                        : (IActionResult)Json(new { success = true, response = result.PMessageText });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            IEnumerable<DataField> ModuleIdList = await _selectTcmPLRepository.ModuleIdList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });

            ViewData["ModuleIdList"] = new SelectList(ModuleIdList, "DataValueField", "DataTextField");

            return PartialView("_ModalActionsCreatePartial", actionsCreateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(Helper.PolicyNamePrefixAction, CoreSettingsHelper.ActionEditUserAccess)]
        public async Task<IActionResult> ActionsDelete(string actionId)
        {
            try
            {
                Domain.Models.Common.DBProcMessageOutput result = await _actionsRepository.ActionsDeleteAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PActionId = actionId
                    }
                    );

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageType, message = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        #endregion Actions

        #region ModuleActions

        public async Task<IActionResult> ModuleActionsIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterModuleActionsIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            ModuleActionsViewModel moduleActionsViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(moduleActionsViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsModuleAction(string paramJSon)
        {
            DTResult<ModuleActionsDataTableList> result = new();
            int totalRow = 0;

            try
            {
                DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJSon);

                System.Collections.Generic.IEnumerable<ModuleActionsDataTableList> data = await _moduleActionsDataTableListRepository.ModuleActionsDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch ?? " ",
                        PActionId = param.ActionId,
                        PModuleId = param.ModuleId,
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
        [RoleActionAuthorize(Helper.PolicyNamePrefixAction, CoreSettingsHelper.ActionEditUserAccess)]
        public async Task<IActionResult> ModuleActionsCreate()
        {
            ModuleActionsCreateViewModel actionsCreateViewModel = new();

            IEnumerable<DataField> ModuleIdList = await _selectTcmPLRepository.ModuleIdList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            IEnumerable<DataField> ActionIdList = await _selectTcmPLRepository.ActionIdList(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            ViewData["ActionIdList"] = new SelectList(ActionIdList, "DataValueField", "DataTextField");
            ViewData["ModuleIdList"] = new SelectList(ModuleIdList, "DataValueField", "DataTextField");

            return PartialView("_ModalModuleActionCreatePartial", actionsCreateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(Helper.PolicyNamePrefixAction, CoreSettingsHelper.ActionEditUserAccess)]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ModuleActionsCreate([FromForm] ModuleActionsCreateViewModel moduleActionsCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _moduleActionsRepository.ModuleActionsCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PModuleId = moduleActionsCreateViewModel.ModuleId,
                            PActionId = moduleActionsCreateViewModel.ActionId,
                            PIsActiveChar = moduleActionsCreateViewModel.ActionIsActive,
                        });

                    return result.PMessageType != IsOk
                        ? throw new Exception(result.PMessageText.Replace("-", " "))
                        : (IActionResult)Json(new { success = true, response = result.PMessageText });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            IEnumerable<DataField> ModuleIdList = await _selectTcmPLRepository.ModuleIdList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            IEnumerable<DataField> ActionIdList = await _selectTcmPLRepository.ActionIdList(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            ViewData["ActionIdList"] = new SelectList(ActionIdList, "DataValueField", "DataTextField", moduleActionsCreateViewModel.ActionId);
            ViewData["ModuleIdList"] = new SelectList(ModuleIdList, "DataValueField", "DataTextField", moduleActionsCreateViewModel.ModuleId);

            return PartialView("_ModalModuleActionCreatePartial", moduleActionsCreateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(Helper.PolicyNamePrefixAction, CoreSettingsHelper.ActionEditUserAccess)]
        public async Task<IActionResult> ModuleActionsDelete(string moduleId, string actionId)
        {
            try
            {
                Domain.Models.Common.DBProcMessageOutput result = await _moduleActionsRepository.ModuleActionsDeleteAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PModuleId = moduleId,
                        PActionId = actionId
                    }
                    );

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageType, message = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        #endregion ModuleActions

        #region ModuleRolesActions

        public async Task<IActionResult> ModuleRolesActionsIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterModuleRolesActionsIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            ModuleRolesActionsViewModel moduleRolesActionsViewModel = new()
            {
                FilterDataModel = filterDataModel
            };
            return View(moduleRolesActionsViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsModuleRolesActions(string paramJSon)
        {
            DTResult<ModuleRolesActionsDataTableList> result = new();
            int totalRow = 0;

            try
            {
                DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJSon);
                System.Collections.Generic.IEnumerable<ModuleRolesActionsDataTableList> data = await _moduleRolesActionsDataTableListRepository.ModuleRolesActionsDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch ?? " ",
                        PModuleId = param.ModuleId,
                        PRoleId = param.RoleId,
                        PActionId = param.ActionId,
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
        [RoleActionAuthorize(Helper.PolicyNamePrefixAction, CoreSettingsHelper.ActionEditUserAccess)]
        public async Task<IActionResult> ModuleRolesActionsCreate()
        {
            ModuleRolesActionsCreateViewModel moduleRolesActionsCreateViewModel = new();

            IEnumerable<DataField> ModuleIdList = await _selectTcmPLRepository.ModuleIdList(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            IEnumerable<DataField> RoleIdList = await _selectTcmPLRepository.RoleIdList(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            IEnumerable<DataField> ActionIdList = await _selectTcmPLRepository.ActionIdList(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            ViewData["ModuleIdList"] = new SelectList(ModuleIdList, "DataValueField", "DataTextField");
            ViewData["RoleIdList"] = new SelectList(RoleIdList, "DataValueField", "DataTextField");
            ViewData["ActionIdList"] = new SelectList(ActionIdList, "DataValueField", "DataTextField");

            return PartialView("_ModalModuleRolesActionsCreatePartial", moduleRolesActionsCreateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(Helper.PolicyNamePrefixAction, CoreSettingsHelper.ActionEditUserAccess)]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ModuleRolesActionsCreate([FromForm] ModuleRolesActionsCreateViewModel moduleRolesActionsCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _moduleRolesActionsRepository.ModuleRolesActionsCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PModuleId = moduleRolesActionsCreateViewModel.ModuleId,
                            PRoleId = moduleRolesActionsCreateViewModel.RoleId,
                            PActionId = moduleRolesActionsCreateViewModel.ActionId,
                            //PModuleRoleActionKeyId = moduleRolesActionsCreateViewModel.ModuleRoleActionKeyId,
                            //PModuleRoleKeyId = moduleRolesActionsCreateViewModel.ModuleRoleKeyId
                        });

                    return result.PMessageType != IsOk
                        ? throw new Exception(result.PMessageText.Replace("-", " "))
                        : (IActionResult)Json(new { success = true, response = result.PMessageText });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            IEnumerable<DataField> ModuleIdList = await _selectTcmPLRepository.ModuleIdList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });

            IEnumerable<DataField> RoleIdList = await _selectTcmPLRepository.RoleIdList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });

            IEnumerable<DataField> ActionIdList = await _selectTcmPLRepository.ActionIdList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });

            ViewData["ModuleIdList"] = new SelectList(ModuleIdList, "DataValueField", "DataTextField");
            ViewData["RoleIdList"] = new SelectList(RoleIdList, "DataValueField", "DataTextField");
            ViewData["ActionIdList"] = new SelectList(ActionIdList, "DataValueField", "DataTextField");

            return PartialView("_ModalModuleRolesActionsCreatePartial", moduleRolesActionsCreateViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> ModuleRolesActionsEdit(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            ModuleRolesActionsDetails result = await _moduleRolesActionsDetailRepository.ModuleRolesActionsDetail(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PKeyId = id
                });

            ModuleRolesActionsUpdateViewModel moduleRolesActionsUpdateViewModel = new();

            if (result.PMessageType == IsOk)
            {
                moduleRolesActionsUpdateViewModel.ModuleRoleActionKeyId = id;
                moduleRolesActionsUpdateViewModel.ModuleId = result.PModuleId;
                moduleRolesActionsUpdateViewModel.RoleId = result.PRoleId;
                moduleRolesActionsUpdateViewModel.ActionId = result.PActionId;
                moduleRolesActionsUpdateViewModel.ModuleRoleKeyId = result.PModuleRoleKeyId;
            }

            return PartialView("_ModalModuleRolesActionsEditPartial", moduleRolesActionsUpdateViewModel);
        }

        [HttpPost]
        //[RoleActionAuthorize(Helper.PolicyNamePrefixAction, JOBHelper.ActionEditJob)]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ModuleRolesActionsEdit([FromForm] ModuleRolesActionsUpdateViewModel moduleRolesActionsUpdateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _moduleRolesActionsRepository.ModuleRolesActionsEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PKeyId = moduleRolesActionsUpdateViewModel.ModuleRoleActionKeyId,
                            PModuleId = moduleRolesActionsUpdateViewModel.ModuleId,
                            PRoleId = moduleRolesActionsUpdateViewModel.RoleId,
                            PActionId = moduleRolesActionsUpdateViewModel.ActionId,
                            PModuleRoleKeyId = moduleRolesActionsUpdateViewModel.ModuleRoleKeyId
                        });

                    return result.PMessageType != IsOk
                        ? throw new Exception(result.PMessageText.Replace("-", " "))
                        : (IActionResult)Json(new { success = true, response = result.PMessageText });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            return PartialView("_ModalModuleRolesActionsEditPartial", moduleRolesActionsUpdateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(Helper.PolicyNamePrefixAction, CoreSettingsHelper.ActionEditUserAccess)]
        public async Task<IActionResult> ModuleRolesActionsDelete(string moduleRoleActionKeyId, string moduleRoleKeyId)
        {
            try
            {
                Domain.Models.Common.DBProcMessageOutput result = await _moduleRolesActionsRepository.ModuleRolesActionsDeleteAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PModuleRoleActionKeyId = moduleRoleActionKeyId,
                        PModuleRoleKeyId = moduleRoleKeyId
                    }
                    );

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageType, message = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        #endregion ModuleRolesActions

        #region ModuleUserRoles

        public async Task<IActionResult> ModuleUserRolesIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterModuleRolesUsersIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            ModuleUserRolesViewModel moduleUserRolesViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(moduleUserRolesViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsModuleUserRoles(string paramJSon)
        {
            DTResult<ModuleUserRolesDataTableList> result = new();
            int totalRow = 0;

            try
            {
                DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJSon);
                System.Collections.Generic.IEnumerable<ModuleUserRolesDataTableList> data = await _moduleUserRolesDataTableListRepository.ModuleUserRolesDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch ?? " ",
                        PModuleId = param.ModuleId,
                        PRoleId = param.RoleId,
                        PEmpno = param.Empno,
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

        public async Task<IActionResult> ModuleUserRoleLogsIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterModuleRoleUserLogsIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            ModuleUserRolesViewModel moduleUserRolesViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(moduleUserRolesViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsModuleUserRoleLogs(string paramJSon)
        {
            DTResult<ModuleUserRolesDataTableList> result = new();
            int totalRow = 0;

            try
            {
                DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJSon);
                System.Collections.Generic.IEnumerable<ModuleUserRolesDataTableList> data = await _moduleUserRolesDataTableListRepository.ModuleUserRolesLogDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch ?? " ",
                        PModuleId = param.ModuleId,
                        PRoleId = param.RoleId,
                        PEmpno = param.Empno,
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
        [RoleActionAuthorize(Helper.PolicyNamePrefixAction, CoreSettingsHelper.ActionEditUserAccess)]
        public async Task<IActionResult> ModuleUserRolesCreate()
        {
            ModuleUserRolesCreateViewModel moduleUserRolesCreateViewModel = new();

            IEnumerable<DataField> moduleIdList = await _selectTcmPLRepository.ModuleIdList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });

            IEnumerable<DataField> roleIdList = await _selectTcmPLRepository.RoleIdList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
                PFlagId = ConstFlagManual
            });
            IEnumerable<DataField> employeeList = await _selectTcmPLRepository.SWPEmployeeList4AdminAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });

            ViewData["ModuleIdList"] = new SelectList(moduleIdList, "DataValueField", "DataTextField");
            ViewData["RoleIdList"] = new SelectList(roleIdList, "DataValueField", "DataTextField");
            ViewData["EmployeeList"] = new SelectList(employeeList, "DataValueField", "DataTextField");

            return PartialView("_ModalModuleUserRolesCreatePartial", moduleUserRolesCreateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(Helper.PolicyNamePrefixAction, CoreSettingsHelper.ActionEditUserAccess)]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ModuleUserRolesCreate([FromForm] ModuleUserRolesCreateViewModel moduleUserRolesCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _moduleUserRolesRepository.ModuleUserRolesCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PModuleId = moduleUserRolesCreateViewModel.ModuleId,
                            PRoleId = moduleUserRolesCreateViewModel.RoleId,
                            PEmpno = moduleUserRolesCreateViewModel.Empno,
                            //PPersonId = moduleUserRolesCreateViewModel.PersonId,
                            //PModuleRoleKeyId = moduleUserRolesCreateViewModel.ModuleRoleKeyId
                        });

                    return result.PMessageType != IsOk
                        ? throw new Exception(result.PMessageText.Replace("-", " "))
                        : (IActionResult)Json(new { success = true, response = result.PMessageText });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            IEnumerable<DataField> moduleIdList = await _selectTcmPLRepository.ModuleIdList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });

            IEnumerable<DataField> roleIdList = await _selectTcmPLRepository.RoleIdList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
                PFlagId = ConstFlagManual
            });
            IEnumerable<DataField> employeeList = await _selectTcmPLRepository.SWPEmployeeList4AdminAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });

            ViewData["ModuleIdList"] = new SelectList(moduleIdList, "DataValueField", "DataTextField", moduleUserRolesCreateViewModel.ModuleId);
            ViewData["RoleIdList"] = new SelectList(roleIdList, "DataValueField", "DataTextField", moduleUserRolesCreateViewModel.RoleId);
            ViewData["EmployeeList"] = new SelectList(employeeList, "DataValueField", "DataTextField", moduleUserRolesCreateViewModel.Empno);

            return PartialView("_ModalModuleUserRolesCreatePartial", moduleUserRolesCreateViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> ModuleUserRolesEdit(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            ModuleUserRolesDetails result = await _moduleUserRolesDetailRepository.ModuleUserRolesDetail(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PKeyId = id
                });

            ModuleUserRolesUpdateViewModel moduleUserRolesUpdateViewModel = new();

            if (result.PMessageType == IsOk)
            {
                moduleUserRolesUpdateViewModel.ModuleRoleKeyId = id;
                moduleUserRolesUpdateViewModel.ModuleId = result.PModuleId;
                moduleUserRolesUpdateViewModel.RoleId = result.PRoleId;
                moduleUserRolesUpdateViewModel.Empno = result.PEmpno;
                moduleUserRolesUpdateViewModel.PersonId = result.PPersonId;
            }

            IEnumerable<DataField> moduleIdList = await _selectTcmPLRepository.ModuleIdList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });

            IEnumerable<DataField> roleIdList = await _selectTcmPLRepository.RoleIdList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
                PFlagId = ConstFlagManual
            });
            IEnumerable<DataField> employeeList = await _selectTcmPLRepository.SWPEmployeeList4AdminAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });

            ViewData["ModuleIdList"] = new SelectList(moduleIdList, "DataValueField", "DataTextField", moduleUserRolesUpdateViewModel.ModuleId);
            ViewData["RoleIdList"] = new SelectList(roleIdList, "DataValueField", "DataTextField", moduleUserRolesUpdateViewModel.RoleId);
            ViewData["EmployeeList"] = new SelectList(employeeList, "DataValueField", "DataTextField", moduleUserRolesUpdateViewModel.Empno);

            return PartialView("_ModalModuleUserRolesEditPartial", moduleUserRolesUpdateViewModel);
        }

        [HttpPost]
        //[RoleActionAuthorize(Helper.PolicyNamePrefixAction, JOBHelper.ActionEditJob)]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ModuleUserRolesEdit([FromForm] ModuleUserRolesUpdateViewModel moduleUserRolesUpdateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _moduleUserRolesRepository.ModuleUserRolesEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PKeyId = moduleUserRolesUpdateViewModel.ModuleRoleKeyId,
                            PModuleId = moduleUserRolesUpdateViewModel.ModuleId,
                            PRoleId = moduleUserRolesUpdateViewModel.RoleId,
                            PEmpno = moduleUserRolesUpdateViewModel.Empno,
                            PPersonId = moduleUserRolesUpdateViewModel.PersonId
                        });

                    return result.PMessageType != IsOk
                        ? throw new Exception(result.PMessageText.Replace("-", " "))
                        : (IActionResult)Json(new { success = true, response = result.PMessageText });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            IEnumerable<DataField> ModuleIdList = await _selectTcmPLRepository.ModuleIdList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });

            IEnumerable<DataField> RoleIdList = await _selectTcmPLRepository.RoleIdList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
                PFlagId = ConstFlagManual
            });

            ViewData["ModuleIdList"] = new SelectList(ModuleIdList, "DataValueField", "DataTextField", moduleUserRolesUpdateViewModel.ModuleId);
            ViewData["RoleIdList"] = new SelectList(RoleIdList, "DataValueField", "DataTextField", moduleUserRolesUpdateViewModel.RoleId);

            return PartialView("_ModalModuleUserRolesEditPartial", moduleUserRolesUpdateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(Helper.PolicyNamePrefixAction, CoreSettingsHelper.ActionEditUserAccess)]
        public async Task<IActionResult> ModuleUserRolesDelete(string moduleId, string roleId, string empNo)
        {
            try
            {
                Domain.Models.Common.DBProcMessageOutput result = await _moduleUserRolesRepository.ModuleUserRolesDeleteAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PModuleId = moduleId,
                        PRoleId = roleId,
                        PEmpno = empNo
                    }
                    );

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageType, message = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        [HttpGet]
        public async Task<IActionResult> ModuleUserRolesBulkCreate()
        {

            ModuleUserRolesBulkCreateViewModel moduleUserRolesBulkCreateViewModel = new();

            IEnumerable<DataField> moduleIdList = await _selectTcmPLRepository.ModuleIdList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });

            IEnumerable<DataField> roleIdList = await _selectTcmPLRepository.RoleIdList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
                PFlagId = ConstFlagManual
            });

            ViewData["ModuleIdList"] = new SelectList(moduleIdList, "DataValueField", "DataTextField");
            ViewData["RoleIdList"] = new SelectList(roleIdList, "DataValueField", "DataTextField");
            return PartialView("_ModalModuleUserRolesBulkCreatePartial", moduleUserRolesBulkCreateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ModuleUserRolesBulkCreate(ModuleUserRolesBulkCreateViewModel moduleUserRolesBulkCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid == false)
                    return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage("Please Enter Valid Employee No"));

                var jsonstring = moduleUserRolesBulkCreateViewModel.Employee;

                if (jsonstring != null)
                {
                    jsonstring = MultilineToCSV(jsonstring);
                    if (jsonstring.Length < 5)
                    {
                        throw new Exception("Please Enter Valid Employee No");
                    }
                }

                string[] arrItems = jsonstring.Split(',');

                List<ModuleUserRolesLists> returnEmpList = new List<ModuleUserRolesLists>();

                foreach (var emp in arrItems)
                {
                    if (emp != "")
                    {
                        returnEmpList.Add(new ModuleUserRolesLists { Empno = emp });
                    }
                }
                if (!returnEmpList.Any())
                {
                    throw new Exception("Please enter valid employee no (length:5)");
                }

                string formattedJson = JsonConvert.SerializeObject(returnEmpList);
                byte[] byteArray = Encoding.ASCII.GetBytes(formattedJson);

                var uploadOutPut = await _moduleUserRoleBulkUploadRepository.ModuleUserRoleJSonAsync(BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PModuleUserRolesBulkJson = byteArray,
                    PModuleId = moduleUserRolesBulkCreateViewModel.ModuleId,
                    PRoleId = moduleUserRolesBulkCreateViewModel.RoleId,
                });

                List<ImportFileResultViewModel> importFileResults = new List<ImportFileResultViewModel>();

                List<Library.Excel.Template.Models.ValidationItem> validationItems = new List<Library.Excel.Template.Models.ValidationItem>();

                if (uploadOutPut.PMessageType != IsOk)
                {
                    if (uploadOutPut.PEmpnoErrors != null)
                    {
                        foreach (var excelError in uploadOutPut.PEmpnoErrors)
                        {
                            importFileResults.Add(new ImportFileResultViewModel
                            {
                                ErrorType = (ImportFileValidationErrorTypeEnum)excelError.ErrorType,
                                ExcelRowNumber = excelError.ExcelRowNumber,
                                FieldName = excelError.FieldName,
                                Id = excelError.Id,
                                Section = excelError.Section,
                                Message = excelError.Message,
                            });
                        }
                    }

                    if (importFileResults.Count > 0)
                    {
                        foreach (var item in importFileResults)
                        {
                            validationItems.Add(new ValidationItem
                            {
                                ErrorType = (Library.Excel.Template.Models.ValidationItemErrorTypeEnum)Enum.Parse(typeof(Library.Excel.Template.Models.ValidationItemErrorTypeEnum), item.ErrorType.ToString(), true),
                                ExcelRowNumber = item.ExcelRowNumber.Value,
                                FieldName = item.FieldName,
                                Id = item.Id,
                                Section = item.Section,
                                Message = item.Message
                            });
                        }
                    }

                    var resultJsonError = new
                    {
                        success = false,
                        response = uploadOutPut.PMessageText,
                        data = importFileResults,
                        fileContent = ""
                    };

                    var timeStamp = DateTime.Now.ToFileTime();

                    string fileName = "Errors_" + timeStamp.ToString();
                    string reportTitle = "Errors";
                    string sheetName = "Errors";

                    var byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(importFileResults, reportTitle, sheetName);

                    var mimeType = MimeTypeMap.GetMimeType("xlsx");

                    FileContentResult file = File(byteContent, mimeType, fileName);

                    return Json(ResponseHelper.GetMessageObject("Error while performing action", file, MessageType: NotificationType.error));
                }
                else
                {
                    return Json(new { success = uploadOutPut.PMessageType, response = "Import data successfully executed" });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }


        public async Task<IActionResult> ModuleUserRoleExcelDownload()
        {
            var timeStamp = DateTime.Now.ToFileTime();

            string fileName = "Module User Role List_" + timeStamp.ToString();
            string reportTitle = "Module User Role List";
            string sheetName = "Module User Role List";

            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterModuleRolesUsersIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            IEnumerable<ModuleUserRolesDataTableList> data = await _moduleUserRolesDataTableListRepository.ModuleUserRolesXLDataTableListAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PModuleId = filterDataModel.ModuleId,
                    PRoleId = filterDataModel.RoleId,
                    PEmpno = filterDataModel.Empno
                });

            if (data == null) { return NotFound(); }

            var json = JsonConvert.SerializeObject(data);

            IEnumerable<ModuleUserRolesDataTableExcel> excelData = JsonConvert.DeserializeObject<IEnumerable<ModuleUserRolesDataTableExcel>>(json);

            var byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, reportTitle, sheetName);

            var mimeType = MimeTypeMap.GetMimeType("xlsx");

            FileContentResult file = File(byteContent, mimeType, fileName);

            return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
        }
        #endregion ModuleUserRoles

        #region VUModuleUserRoleActions

        public async Task<IActionResult> VUModuleUserRoleActionsIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterModuleUserRoleActionsIndex
            });

            VUModuleUserRoleActionsViewModel moduleUserRoleActionsViewModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                moduleUserRoleActionsViewModel.FilterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            return View(moduleUserRoleActionsViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsVUModuleUserRoleActions(string paramJSon)
        {
            DTResult<VUModuleUserRoleActionsDataTableList> result = new();
            int totalRow = 0;

            try
            {
                DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJSon);
                System.Collections.Generic.IEnumerable<VUModuleUserRoleActionsDataTableList> data =
                                                    await _VUModuleUserRoleActionsDataTableListRepository.VUModuleUserRoleActionsDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch ?? " ",
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
                        PModuleId = param.ModuleId,
                        PRoleId = param.RoleId,
                        PActionId = param.ActionId
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

        #endregion VUModuleUserRoleActions

        #region ModuleUserRoleActions

        public async Task<IActionResult> ModuleUserRoleActionsIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterRolesIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            ModuleUserRoleActionsViewModel moduleUserRoleActionsViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(moduleUserRoleActionsViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsModuleUserRoleActions(string paramJSon)
        {
            DTResult<ModuleUserRoleActionsDataTableList> result = new();
            int totalRow = 0;

            try
            {
                DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJSon);
                System.Collections.Generic.IEnumerable<ModuleUserRoleActionsDataTableList> data =
                                                    await _moduleUserRoleActionsDataTableListRepository.ModuleUserRoleActionsDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch ?? " ",
                        PRoleId = param.RoleId,
                        PModuleId = param.ModuleId,
                        PActionId = param.ActionId,
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
        [RoleActionAuthorize(Helper.PolicyNamePrefixAction, CoreSettingsHelper.ActionEditUserAccess)]
        public async Task<IActionResult> ModuleUserRoleActionsCreate()
        {
            ModuleUserRoleActionsCreateViewModel moduleUserRoleActionsCreateViewModel = new();

            IEnumerable<DataField> ModuleIdList = await _selectTcmPLRepository.ModuleIdList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });

            IEnumerable<DataField> RoleIdList = await _selectTcmPLRepository.RoleIdList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });

            IEnumerable<DataField> ActionIdList = await _selectTcmPLRepository.ActionIdList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });

            ViewData["ModuleIdList"] = new SelectList(ModuleIdList, "DataValueField", "DataTextField");
            ViewData["RoleIdList"] = new SelectList(RoleIdList, "DataValueField", "DataTextField");
            ViewData["ActionIdList"] = new SelectList(ActionIdList, "DataValueField", "DataTextField");

            return PartialView("_ModalModuleUserRoleActionsCreatePartial", moduleUserRoleActionsCreateViewModel);
        }

        #endregion ModuleUserRoleActions

        #region Delegate

        public async Task<IActionResult> DelegateIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterDelegateIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            DelegateViewModel delegateViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(delegateViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsDelegate(string paramJSon)
        {
            DTResult<DelegateDataTableList> result = new();
            int totalRow = 0;

            try
            {
                DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJSon);
                System.Collections.Generic.IEnumerable<DelegateDataTableList> data = await _delegateDataTableListRepository.DelegateDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch ?? " ",
                        PModuleId = param.ModuleId,
                        PEmpno = param.Empno,
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

        public async Task<IActionResult> DelegateLogsIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterDelegateLogsIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            DelegateViewModel DelegateViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(DelegateViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsDelegateLogs(string paramJSon)
        {
            DTResult<DelegateDataTableList> result = new();
            int totalRow = 0;

            try
            {
                DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJSon);
                System.Collections.Generic.IEnumerable<DelegateDataTableList> data = await _delegateDataTableListRepository.DelegateLogDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch ?? " ",
                        PModuleId = param.ModuleId,
                        PEmpno = param.Empno,
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
        [RoleActionAuthorize(Helper.PolicyNamePrefixAction, CoreSettingsHelper.ActionEditUserAccess)]
        public async Task<IActionResult> DelegateCreate()
        {
            DelegateCreateViewModel DelegateCreateViewModel = new();

            IEnumerable<DataField> moduleIdList = await _selectTcmPLRepository.ModuleIdList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
                PDelegationIsActive = IsOk
            });

            IEnumerable<DataField> principalEmpno = await _selectTcmPLRepository.SWPEmployeeList4AdminAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            IEnumerable<DataField> onBehalfEmpno = await _selectTcmPLRepository.SWPEmployeeList4AdminAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            ViewData["ModuleIdList"] = new SelectList(moduleIdList, "DataValueField", "DataTextField");
            ViewData["PrincipalEmpnoList"] = new SelectList(principalEmpno, "DataValueField", "DataTextField");
            ViewData["OnBehalfEmpnoList"] = new SelectList(onBehalfEmpno, "DataValueField", "DataTextField");

            return PartialView("_ModalDelegateCreatePartial", DelegateCreateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(Helper.PolicyNamePrefixAction, CoreSettingsHelper.ActionEditUserAccess)]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DelegateCreate([FromForm] DelegateCreateViewModel delegateCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    if (delegateCreateViewModel.PrincipalEmpno == delegateCreateViewModel.OnBehalfEmpno)
                    {
                        throw new Exception("Error : Invalid request - Principal employee and OnBehalf employee are same.");
                    }

                    Domain.Models.Common.DBProcMessageOutput result = await _delegateRepository.DelegateCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PModuleId = delegateCreateViewModel.ModuleId,
                            PPrincipalEmpno = delegateCreateViewModel.PrincipalEmpno,
                            POnBehalfEmpno = delegateCreateViewModel.OnBehalfEmpno,
                        });

                    return result.PMessageType != IsOk
                        ? throw new Exception(result.PMessageText.Replace("-", " "))
                        : (IActionResult)Json(new { success = true, response = result.PMessageText });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            IEnumerable<DataField> moduleIdList = await _selectTcmPLRepository.ModuleIdList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
                PDelegationIsActive = IsOk
            });

            IEnumerable<DataField> principalEmpno = await _selectTcmPLRepository.SWPEmployeeList4AdminAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            IEnumerable<DataField> onBehalfEmpno = await _selectTcmPLRepository.SWPEmployeeList4AdminAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            ViewData["ModuleIdList"] = new SelectList(moduleIdList, "DataValueField", "DataTextField", delegateCreateViewModel.ModuleId);
            ViewData["PrincipalEmpnoList"] = new SelectList(principalEmpno, "DataValueField", "DataTextField", delegateCreateViewModel.PrincipalEmpno);
            ViewData["OnBehalfEmpnoList"] = new SelectList(onBehalfEmpno, "DataValueField", "DataTextField", delegateCreateViewModel.OnBehalfEmpno);

            return PartialView("_ModalDelegateCreatePartial", delegateCreateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(Helper.PolicyNamePrefixAction, CoreSettingsHelper.ActionEditUserAccess)]
        public async Task<IActionResult> DelegateDelete(string moduleId, string onBehalfEmpno, string principalEmpno)
        {
            try
            {
                if (string.IsNullOrEmpty(moduleId) || string.IsNullOrEmpty(onBehalfEmpno) || string.IsNullOrEmpty(principalEmpno))
                {
                    return Json(new { success = false, response = NotOk, message = "Error : Invalid request - missing important values" });
                }

                Domain.Models.Common.DBProcMessageOutput result = await _delegateRepository.DelegateDeleteAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PModuleId = moduleId,
                        PPrincipalEmpno = principalEmpno,
                        POnBehalfEmpno = onBehalfEmpno,
                    }
                    );

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageType, message = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        #endregion Delegate

        #region ModuleUserRoleCostcode

        public async Task<IActionResult> ModuleUserRoleCostcodeIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterModuleUserRoleCodeCodeIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            ModuleUserRoleCostCodeViewModel moduleUserRoleCodeCodeViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(moduleUserRoleCodeCodeViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsModuleUserRoleCostcode(string paramJSon)
        {
            DTResult<ModuleUserRoleCostCodeDataTableList> result = new();
            int totalRow = 0;

            try
            {
                DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJSon);
                System.Collections.Generic.IEnumerable<ModuleUserRoleCostCodeDataTableList> data =
                                                    await _moduleUserRoleCostCodeDataTableListRepository.ModuleUserRoleCostCodeDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch ?? " ",
                        PModuleId = param.ModuleId,
                        PEmpno = param.Empno,
                        PParent = param.Parent,
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
        [RoleActionAuthorize(Helper.PolicyNamePrefixAction, CoreSettingsHelper.ActionEditUserAccess)]
        public async Task<IActionResult> ModuleUserRoleCostCodeCreate()
        {
            ModuleUserRoleCostCodeCreateViewModel moduleUserRoleCostCodeCreateViewModel = new();

            IEnumerable<DataField> moduleIdList = await _selectTcmPLRepository.ModuleIdList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });

            IEnumerable<DataField> roleIdList = await _selectTcmPLRepository.RoleIdList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
                PFlagId = ConstFlagCostCode
            });

            IEnumerable<DataField> costcodeList = await _selectTcmPLRepository.CostCodeListAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });

            IEnumerable<DataField> employeeList = await _selectTcmPLRepository.SWPEmployeeList4AdminAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });

            ViewData["ModuleIdList"] = new SelectList(moduleIdList, "DataValueField", "DataTextField");
            ViewData["RoleIdList"] = new SelectList(roleIdList, "DataValueField", "DataTextField", ConstModuleRole);
            ViewData["CostcodeList"] = new SelectList(costcodeList, "DataValueField", "DataTextField");
            ViewData["EmployeeList"] = new SelectList(employeeList, "DataValueField", "DataTextField");
            moduleUserRoleCostCodeCreateViewModel.RoleId = ConstModuleRole;

            return PartialView("_ModalModuleUserRolesCostCodeCreatePartial", moduleUserRoleCostCodeCreateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(Helper.PolicyNamePrefixAction, CoreSettingsHelper.ActionEditUserAccess)]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ModuleUserRoleCostCodeCreate([FromForm] ModuleUserRoleCostCodeCreateViewModel moduleUserRoleCostCodeCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _moduleUserRoleCostCodeRepository.ModuleUserRoleCostCodeCreateAsync(

                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PModuleId = moduleUserRoleCostCodeCreateViewModel.ModuleId,
                            PRoleId = moduleUserRoleCostCodeCreateViewModel.RoleId,
                            PParent = moduleUserRoleCostCodeCreateViewModel.Parent,
                            PEmpno = moduleUserRoleCostCodeCreateViewModel.Empno,
                        });

                    return result.PMessageType != IsOk
                        ? throw new Exception(result.PMessageText.Replace("-", " "))
                        : (IActionResult)Json(new { success = true, response = result.PMessageText });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            IEnumerable<DataField> moduleIdList = await _selectTcmPLRepository.ModuleIdList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });

            IEnumerable<DataField> roleIdList = await _selectTcmPLRepository.RoleIdList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
                PFlagId = ConstFlagCostCode
            });

            IEnumerable<DataField> costcodeList = await _selectTcmPLRepository.CostCodeListAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });

            IEnumerable<DataField> employeeList = await _selectTcmPLRepository.SWPEmployeeList4AdminAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });

            ViewData["ModuleIdList"] = new SelectList(moduleIdList, "DataValueField", "DataTextField", moduleUserRoleCostCodeCreateViewModel.ModuleId);
            ViewData["RoleIdList"] = new SelectList(roleIdList, "DataValueField", "DataTextField", moduleUserRoleCostCodeCreateViewModel.RoleId);
            ViewData["CostCodeList"] = new SelectList(costcodeList, "DataValueField", "DataTextField", moduleUserRoleCostCodeCreateViewModel.Parent);
            ViewData["EmployeeList"] = new SelectList(employeeList, "DataValueField", "DataTextField", moduleUserRoleCostCodeCreateViewModel.Empno);

            return PartialView("_ModalModuleUserRolesCostCodeCreatePartial", moduleUserRoleCostCodeCreateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(Helper.PolicyNamePrefixAction, CoreSettingsHelper.ActionEditUserAccess)]
        public async Task<IActionResult> ModuleUserRoleCostCodeDelete(string moduleId, string roleId, string empno, string parent)
        {
            try
            {
                Domain.Models.Common.DBProcMessageOutput result = await _moduleUserRoleCostCodeRepository.ModuleUserRoleCostCodeDeleteAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PModuleId = moduleId,
                        PRoleId = roleId,
                        PEmpno = empno,
                        PParent = parent,
                    }
                    );

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageType, message = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        #endregion ModuleUserRoleCostcode

        #region Filter

        public async Task<IActionResult> ResetFilter(string ActionId)
        {
            try
            {
                Domain.Models.FilterReset result = await _filterRepository.FilterResetAsync(new Domain.Models.FilterReset
                {
                    PModuleName = CurrentUserIdentity.CurrentModule,
                    PMetaId = CurrentUserIdentity.MetaId,
                    PPersonId = CurrentUserIdentity.EmployeeId,
                    PMvcActionName = ActionId,
                });

                return Json(new { success = result.OutPSuccess == "OK", response = result.OutPMessage });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        private async Task<Domain.Models.FilterCreate> CreateFilter(string jsonFilter, string ActionName)
        {
            Domain.Models.FilterCreate retVal = await _filterRepository.FilterCreateAsync(new Domain.Models.FilterCreate
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ActionName,
                PFilterJson = jsonFilter
            });
            return retVal;
        }

        private async Task<Domain.Models.FilterRetrieve> RetriveFilter(string ActionName)
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ActionName
            });
            return retVal;
        }

        public async Task<IActionResult> FilterGet(string moduleName, string module)
        {
            Domain.Models.FilterRetrieve retVal = await RetriveFilter(ConstFilterModuleUserRoleActionsIndex);

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            IEnumerable<DataField> ModuleIdList = await _selectTcmPLRepository.ModuleIdList(BaseSpTcmPLGet(), null);

            IEnumerable<DataField> RoleIdList = await _selectTcmPLRepository.RoleIdList(BaseSpTcmPLGet(), null);

            IEnumerable<DataField> ActionIdList = await _selectTcmPLRepository.ActionIdList(BaseSpTcmPLGet(), null);

            ViewData["ModuleIdList"] = new SelectList(ModuleIdList, "DataValueField", "DataTextField", module);
            ViewData["RoleIdList"] = new SelectList(RoleIdList, "DataValueField", "DataTextField", filterDataModel.RoleId);
            ViewData["ActionIdList"] = new SelectList(ActionIdList, "DataValueField", "DataTextField", filterDataModel.ActionId);

            ViewData["ModuleName"] = moduleName;
            ViewData["Module"] = module;

            return PartialView("_ModalModuleUserRoleActionsFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> FilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                string jsonFilter;
                jsonFilter = JsonConvert.SerializeObject(
                        new
                        {
                            filterDataModel.ModuleId,
                            filterDataModel.RoleId,
                            filterDataModel.ActionId
                        });

                _ = await CreateFilter(jsonFilter, ConstFilterModuleUserRoleActionsIndex);

                return Json(new { success = true, moduleId = filterDataModel.ModuleId, roleId = filterDataModel.RoleId, actionId = filterDataModel.ActionId });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        public async Task<IActionResult> ModuleRoleActionsFilterGet(string moduleName, string module)
        {
            Domain.Models.FilterRetrieve retVal = await RetriveFilter(ConstFilterModuleRolesActionsIndex);

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            IEnumerable<DataField> ModuleIdList = await _selectTcmPLRepository.ModuleIdList(BaseSpTcmPLGet(), null);

            ViewData["ModuleIdList"] = new SelectList(ModuleIdList, "DataValueField", "DataTextField", module);

            ViewData["ModuleName"] = moduleName;
            ViewData["Module"] = module;

            if (filterDataModel.ModuleId != null)
            {
                IEnumerable<DataField> RoleIdList = await _selectTcmPLRepository.RoleIdList(BaseSpTcmPLGet(), new ParameterSpTcmPL
                { PModuleId = filterDataModel.ModuleId });

                ViewData["RoleIdList"] = new SelectList(RoleIdList, "DataValueField", "DataTextField");
            }

            if (filterDataModel.ModuleId != null && filterDataModel.RoleId != null)
            {
                IEnumerable<DataField> ActionIdList = await _selectTcmPLRepository.ActionIdList(BaseSpTcmPLGet(), new ParameterSpTcmPL
                { PModuleId = filterDataModel.ModuleId, PRoleId = filterDataModel.RoleId });

                ViewData["ActionIdList"] = new SelectList(ActionIdList, "DataValueField", "DataTextField");
            }

            return PartialView("_ModalModuleRoleActionsFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> ModuleRoleActionsFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                string jsonFilter;
                jsonFilter = JsonConvert.SerializeObject(
                        new
                        {
                            filterDataModel.ModuleId,
                            filterDataModel.RoleId,
                            filterDataModel.ActionId
                        });

                _ = await CreateFilter(jsonFilter, ConstFilterModuleRolesActionsIndex);

                return Json(new { success = true, moduleId = filterDataModel.ModuleId, roleId = filterDataModel.RoleId, actionId = filterDataModel.ActionId });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        public async Task<IActionResult> ModuleActionFilterGet()
        {
            Domain.Models.FilterRetrieve retVal = await RetriveFilter(ConstFilterModuleActionsIndex);

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            IEnumerable<DataField> ModuleIdList = await _selectTcmPLRepository.ModuleIdList(BaseSpTcmPLGet(), null);
            IEnumerable<DataField> ActionIdList = await _selectTcmPLRepository.ActionIdList(BaseSpTcmPLGet(), new ParameterSpTcmPL { PModuleId = filterDataModel.ModuleId });

            ViewData["ModuleIdList"] = new SelectList(ModuleIdList, "DataValueField", "DataTextField", filterDataModel.ModuleId);
            ViewData["ActionIdList"] = new SelectList(ActionIdList, "DataValueField", "DataTextField", filterDataModel.ActionId);

            return PartialView("_ModalActionsFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> ActionsFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                string jsonFilter;
                jsonFilter = JsonConvert.SerializeObject(
                        new
                        {
                            filterDataModel.ModuleId,
                            filterDataModel.ActionId
                        });

                _ = await CreateFilter(jsonFilter, ConstFilterActionsIndex);

                return Json(new { success = true, moduleId = filterDataModel.ModuleId, actionId = filterDataModel.ActionId });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        public async Task<IActionResult> ModuleRoleFilterGet()
        {
            Domain.Models.FilterRetrieve retVal = await RetriveFilter(ConstFilterModuleRolesIndex);

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            IEnumerable<DataField> ModuleIdList = await _selectTcmPLRepository.ModuleIdList(BaseSpTcmPLGet(), null);

            IEnumerable<DataField> RoleIdList = await _selectTcmPLRepository.RoleIdList(BaseSpTcmPLGet(), new ParameterSpTcmPL { PModuleId = filterDataModel.ModuleId });

            ViewData["ModuleIdList"] = new SelectList(ModuleIdList, "DataValueField", "DataTextField", filterDataModel.ModuleId);
            ViewData["RoleIdList"] = new SelectList(RoleIdList, "DataValueField", "DataTextField", filterDataModel.RoleId);

            return PartialView("_ModalModuleRoleFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> ModuleRoleFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                string jsonFilter;
                jsonFilter = JsonConvert.SerializeObject(
                        new
                        {
                            filterDataModel.ModuleId,
                            filterDataModel.RoleId
                        });

                _ = await CreateFilter(jsonFilter, ConstFilterModuleRolesIndex);

                return Json(new { success = true, moduleId = filterDataModel.ModuleId, roleId = filterDataModel.RoleId });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        public async Task<IActionResult> ModuleUserRoleFilterGet(string moduleName, string module)
        {
            Domain.Models.FilterRetrieve retVal = await RetriveFilter(ConstFilterModuleRolesUsersIndex);

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            IEnumerable<DataField> ModuleIdList = await _selectTcmPLRepository.ModuleIdList(BaseSpTcmPLGet(), null);

            ViewData["ModuleIdList"] = new SelectList(ModuleIdList, "DataValueField", "DataTextField", module);

            ViewData["ModuleName"] = moduleName;
            ViewData["Module"] = module;

            if (filterDataModel.ModuleId != null)
            {
                IEnumerable<DataField> RoleIdList = await _selectTcmPLRepository.RoleIdList(BaseSpTcmPLGet(), new ParameterSpTcmPL
                { PModuleId = filterDataModel.ModuleId });

                ViewData["RoleIdList"] = new SelectList(RoleIdList, "DataValueField", "DataTextField");
            }

            if (filterDataModel.ModuleId != null && filterDataModel.RoleId != null)
            {
                IEnumerable<DataField> ActionIdList = await _selectTcmPLRepository.ActionIdList(BaseSpTcmPLGet(), new ParameterSpTcmPL
                { PModuleId = filterDataModel.ModuleId, PRoleId = filterDataModel.RoleId });

                ViewData["ActionIdList"] = new SelectList(ActionIdList, "DataValueField", "DataTextField");
            }

            if (filterDataModel.ModuleId != null && filterDataModel.RoleId != null)
            {
                IEnumerable<DataField> employeeList = await _selectTcmPLRepository.UserAccessEmployeeList(BaseSpTcmPLGet(), new ParameterSpTcmPL
                { PModuleId = filterDataModel.ModuleId, PRoleId = filterDataModel.RoleId });

                ViewData["EmployeeList"] = new SelectList(employeeList, "DataValueField", "DataTextField");
            }

            return PartialView("_ModalModuleUserRoleFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> ModuleUserRoleFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                string jsonFilter;
                jsonFilter = JsonConvert.SerializeObject(
                        new
                        {
                            filterDataModel.ModuleId,
                            filterDataModel.Empno,
                            filterDataModel.RoleId
                        });

                _ = await CreateFilter(jsonFilter, ConstFilterModuleRolesUsersIndex);

                return Json(new { success = true, moduleId = filterDataModel.ModuleId, empno = filterDataModel.Empno, roleId = filterDataModel.RoleId });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        public async Task<IActionResult> ModuleUserRoleLogsFilterGet(string moduleName, string module)
        {
            Domain.Models.FilterRetrieve retVal = await RetriveFilter(ConstFilterModuleRoleUserLogsIndex);

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            IEnumerable<DataField> ModuleIdList = await _selectTcmPLRepository.ModuleIdList(BaseSpTcmPLGet(), null);

            IEnumerable<DataField> RoleIdList = await _selectTcmPLRepository.RoleIdList(BaseSpTcmPLGet(), null);
            IEnumerable<DataField> employeeList = await _selectTcmPLRepository.SWPEmployeeList4AdminAsync(BaseSpTcmPLGet(), null);

            ViewData["EmployeeList"] = new SelectList(employeeList, "DataValueField", "DataTextField");
            ViewData["ModuleIdList"] = new SelectList(ModuleIdList, "DataValueField", "DataTextField", module);
            ViewData["RoleIdList"] = new SelectList(RoleIdList, "DataValueField", "DataTextField");
            ViewData["ModuleName"] = moduleName;
            ViewData["Module"] = module;
            return PartialView("_ModalModuleUserRoleLogsFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> ModuleUserRoleLogsFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                string jsonFilter;
                jsonFilter = JsonConvert.SerializeObject(
                        new
                        {
                            filterDataModel.ModuleId,
                            filterDataModel.Empno,
                            filterDataModel.RoleId
                        });

                _ = await CreateFilter(jsonFilter, ConstFilterModuleRoleUserLogsIndex);

                return Json(new { success = true, moduleId = filterDataModel.ModuleId, empno = filterDataModel.Empno, roleId = filterDataModel.RoleId });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        public async Task<IActionResult> DelegateFilterGet()
        {
            Domain.Models.FilterRetrieve retVal = await RetriveFilter(ConstFilterDelegateIndex);

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            IEnumerable<DataField> ModuleIdList = await _selectTcmPLRepository.ModuleIdList(BaseSpTcmPLGet(), null);

            ViewData["ModuleIdList"] = new SelectList(ModuleIdList, "DataValueField", "DataTextField", filterDataModel.ModuleId);

            return PartialView("_ModalDelegateFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> DelegateFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                string jsonFilter;
                jsonFilter = JsonConvert.SerializeObject(
                        new
                        {
                            filterDataModel.ModuleId
                        });

                _ = await CreateFilter(jsonFilter, ConstFilterDelegateIndex);

                return Json(new { success = true, moduleId = filterDataModel.ModuleId });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        public async Task<IActionResult> DelegateLogsFilterGet()
        {
            Domain.Models.FilterRetrieve retVal = await RetriveFilter(ConstFilterDelegateLogsIndex);

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            IEnumerable<DataField> ModuleIdList = await _selectTcmPLRepository.ModuleIdList(BaseSpTcmPLGet(), null);

            ViewData["ModuleIdList"] = new SelectList(ModuleIdList, "DataValueField", "DataTextField");

            return PartialView("_ModalDelegateLogsFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> DelegateLogsFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                string jsonFilter;
                jsonFilter = JsonConvert.SerializeObject(
                        new
                        {
                            filterDataModel.ModuleId
                        });

                _ = await CreateFilter(jsonFilter, ConstFilterDelegateLogsIndex);

                return Json(new { success = true, moduleId = filterDataModel.ModuleId });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        public async Task<IActionResult> ModuleUserRoleCostCodeFilterGet()
        {
            Domain.Models.FilterRetrieve retVal = await RetriveFilter(ConstFilterModuleUserRoleCodeCodeIndex);

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            IEnumerable<DataField> moduleIdList = await _selectTcmPLRepository.ModuleIdList(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            ViewData["ModuleIdList"] = new SelectList(moduleIdList, "DataValueField", "DataTextField");

            //IEnumerable<DataField> roleIdList = await _selectTcmPLRepository.RoleIdList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            //ViewData["RoleIdList"] = new SelectList(roleIdList, "DataValueField", "DataTextField");

            IEnumerable<DataField> costcodeList = await _selectTcmPLRepository.CostCodeListAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["CostcodeList"] = new SelectList(costcodeList, "DataValueField", "DataTextField");

            IEnumerable<DataField> employeeList = await _selectTcmPLRepository.SWPEmployeeList4AdminAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["EmployeeList"] = new SelectList(employeeList, "DataValueField", "DataTextField");

            return PartialView("_ModalModuleUserRoleCostCodeFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> ModuleUserRoleCostCodeFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                string jsonFilter;
                jsonFilter = JsonConvert.SerializeObject(
                        new
                        {
                            ModuleId = filterDataModel.ModuleId,
                            Empno = filterDataModel.Empno,
                            Parent = filterDataModel.Parent,
                            Costcode = filterDataModel.Costcode
                        });

                Domain.Models.FilterCreate retVal = await CreateFilter(jsonFilter, ConstFilterModuleUserRoleCodeCodeIndex);

                return Json(new
                {
                    success = true,
                    moduleId = filterDataModel.ModuleId,
                    empno = filterDataModel.Empno,
                    parent = filterDataModel.Parent,
                    costcode = filterDataModel.Costcode
                });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        #endregion Filter

        #region ModuleDetails

        private ModuleRolesViewModel GetListsModulesModuleRoles(string moduleId, string moduleName)
        {
            ModuleRolesViewModel moduleRolesViewModel = new ModuleRolesViewModel();
            moduleRolesViewModel.ModuleId = moduleId;
            moduleRolesViewModel.ModuleName = moduleName;

            return moduleRolesViewModel;
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult ModulesModuleDetail(string ModuleId, string ModuleName)
        {
            try
            {
                if (string.IsNullOrEmpty(ModuleId) || string.IsNullOrEmpty(ModuleName))
                {
                    return NotFound();
                }

                var ModuleDetails = GetListsModulesModuleRoles(ModuleId, ModuleName);

                return View(ModuleDetails);
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
            }
            return RedirectToAction("Index");
        }

        [HttpGet]
        public async Task<IActionResult> ModulesModuleRolesActionIndex(string id)
        {
            if (id == null)
                return NotFound();

            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterModuleRolesActionsIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            ModuleRolesActionsViewModel moduleRolesActionsViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            //ModuleRolesActionsViewModel moduleRolesActionsViewModel = new ModuleRolesActionsViewModel();
            ViewData["ModuleName"] = "ModuleRoleActionFilter";
            ViewData["Module"] = id;

            return PartialView("_ModulesModuleRolesActionIndexPartial", moduleRolesActionsViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> ModulesModuleUserRolesIndex(string id)
        {
            if (id == null)
                return NotFound();

            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterModuleRolesUsersIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            ModuleUserRolesViewModel moduleUserRolesViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            //ModuleUserRolesViewModel moduleUserRolesViewModel = new ModuleUserRolesViewModel();
            ViewData["ModuleName"] = "ModuleUserRoleFilter";
            ViewData["Module"] = id;

            return PartialView("_ModulesModuleUserRolesIndexPartial", moduleUserRolesViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> ModulesModuleUserRolesActionIndex(string id)
        {
            if (id == null)
                return NotFound();
            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterModuleUserRoleActionsIndex
            });

            VUModuleUserRoleActionsViewModel moduleUserRoleActionsViewModel = new VUModuleUserRoleActionsViewModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                moduleUserRoleActionsViewModel.FilterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            //VUModuleUserRoleActionsViewModel moduleUserRoleActionsViewModel = new VUModuleUserRoleActionsViewModel();
            ViewData["ModuleName"] = "ModuleUserRoleActionFilter";
            ViewData["Module"] = id;

            return PartialView("_ModulesModuleUserRolesActionIndexPartial", moduleUserRoleActionsViewModel);
        }

        [HttpGet]
        public IActionResult ModulesModuleDelegateIndex(string id)
        {
            if (id == null)
                return NotFound();

            DelegateViewModel delegateViewModel = new DelegateViewModel();
            //ViewData["ModuleName"] = "ModuleRoleActionFilter";
            //ViewData["Module"] = id;

            return PartialView("_ModulesModuleDelegateIndexPartial", delegateViewModel);
        }

        [HttpGet]
        public IActionResult ModulesModuleUserRoleCostCodeIndex(string id)
        {
            if (id == null)
                return NotFound();

            ModuleUserRoleCostCodeViewModel moduleUserRoleCostCodeViewModel = new ModuleUserRoleCostCodeViewModel();
            //ViewData["ModuleName"] = "ModuleRoleActionFilter";
            //ViewData["Module"] = id;

            return PartialView("_ModulesModuleUserRoleCostCodeIndexPartial", moduleUserRoleCostCodeViewModel);
        }

        #endregion ModuleDetails

        #region GetDependentDropDownList for filter

        [HttpGet]
        public async Task<IActionResult> GetEmployeesList(string module, string role)
        {
            if (string.IsNullOrEmpty(module))
            {
                return Json(null);
            }

            IEnumerable<DataField> employeeList = await _selectTcmPLRepository.UserAccessEmployeeList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
                PModuleId = module,
                PRoleId = role,
            });

            return Json(employeeList);
        }

        [HttpGet]
        public async Task<IActionResult> GetRolesList(string module, string role)
        {
            if (string.IsNullOrEmpty(module))
            {
                return Json(null);
            }

            IEnumerable<DataField> RoleIdList = await _selectTcmPLRepository.RoleIdList(BaseSpTcmPLGet(),
                     new ParameterSpTcmPL
                     {
                         PModuleId = module,
                     });

            return Json(RoleIdList);
        }

        [HttpGet]
        public async Task<IActionResult> GetActionsList(string module, string role)
        {
            if (string.IsNullOrEmpty(module))
            {
                return Json(null);
            }

            IEnumerable<DataField> ActionList = await _selectTcmPLRepository.ActionIdList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
                PModuleId = module,
                PRoleId = role,
            });

            return Json(ActionList);
        }

        #endregion GetDependentDropDownList for filter

        public string MultilineToCSV(string sourceStr)
        {
            if (string.IsNullOrEmpty(sourceStr))
            {
                return ("");
            }

            bool s = !Regex.IsMatch(sourceStr, @"[^0-9A-Za-z, \r\n]");

            if (!s)
            {
                throw new Exception("Please Enter Valid Employee No");
            }

            string retVal = sourceStr.Replace(System.Environment.NewLine, ",");

            retVal = Regex.Replace(retVal, @"\s+", ",");

            return retVal;
        }
    }
}