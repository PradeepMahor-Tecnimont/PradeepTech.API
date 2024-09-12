using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.Extensions.Configuration;
using Newtonsoft.Json;
using System;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.BG;
using TCMPLApp.DataAccess.Repositories.Common;
using TCMPLApp.Domain.Models.BG;
using TCMPLApp.Domain.Models.Common;
using TCMPLApp.Domain.Models.LC;
using TCMPLApp.WebApp.Classes;
using TCMPLApp.WebApp.Controllers;
using TCMPLApp.WebApp.CustomPolicyProvider;
using TCMPLApp.WebApp.Models;
using static TCMPLApp.WebApp.Classes.DTModel;

namespace TCMPLApp.WebApp.Areas.BG.Controllers
{
    [Area("BG")]
    public class MastersController : BaseController
    {

        private const string ConstFilterAcceptableIndex = "BgAcceptableIndex";
        private const string ConstFilterBankIndex = "BgBankIndex";
        private const string ConstFilterCompanyIndex = "BgCompanyIndex";
        private const string ConstFilterCurrencyIndex = "BgCurrencyIndex";
        private const string ConstFilterGuaranteeTypeIndex = "BgGuaranteeTypeIndex";
        private const string ConstFilterPayableIndex = "BgPayableIndex";
        private const string ConstFilterProjectControlIndex = "BgProjectControlIndex";
        private const string ConstFilterProjectDriIndex = "BgProjectDriIndex";
        private const string ConstFilterProjectIndex = "BgProjectIndex";
        private const string ConstFilterVendorIndex = "BgVendorIndex";
        private const string ConstFilterVendorTypeIndex = "BgVendorTypeIndex";
        private const string ConstFilterPPCIndex = "BgPPCIndex";
        private const string ConstFilterPPMIndex = "BgPPMIndex";

        private readonly IConfiguration _configuration;
        private readonly IFilterRepository _filterRepository;
        private readonly ISelectRepository _selectRepository;
        private readonly ISelectTcmPLRepository _selectTcmPLRepository;

        private readonly IBGAcceptableMasterDetailRepository _bgAcceptableMasterDetailRepository;
        private readonly IBGAcceptableMasterRepository _bgAcceptableMasterRepository;

        private readonly IBGBankMasterDetailRepository _bgBankMasterDetailRepository;
        private readonly IBGBankMasterRepository _bgBankMasterRepository;

        private readonly IBGCompanyMasterDetailRepository _bgCompanyMasterDetailRepository;
        private readonly IBGCompanyMasterRepository _bgCompanyMasterRepository;

        private readonly IBGCurrencyMasterDetailRepository _bgCurrencyMasterDetailRepository;
        private readonly IBGCurrencyMasterRepository _bgCurrencyMasterRepository;

        private readonly IBGGuaranteeTypeMasterDetailRepository _bgGuaranteeTypeMasterDetailRepository;
        private readonly IBGGuaranteeTypeMasterRepository _bgGuaranteeTypeMasterRepository;

        private readonly IBGPayableMasterDetailRepository _bgPayableMasterDetailRepository;
        private readonly IBGPayableMasterRepository _bgPayableMasterRepository;

        private readonly IBGProjectMasterDetailRepository _bgProjectMasterDetailRepository;
        private readonly IBGProjectMasterRepository _bgProjectMasterRepository;

        private readonly IBGProjectControlMasterDetailRepository _bgProjectControlMasterDetailRepository;
        private readonly IBGProjectControlMasterRepository _bgProjectControlMasterRepository;

        private readonly IBGProjectDriMasterDetailRepository _bgProjectDriMasterDetailRepository;
        private readonly IBGProjectDriMasterRepository _bgProjectDriMasterRepository;

        private readonly IBGVendorTypeMasterDetailRepository _bgVendorTypeMasterDetailRepository;
        private readonly IBGVendorTypeMasterRepository _bgVendorTypeMasterRepository;

        private readonly IBGVendorMasterDetailRepository _bgVendorMasterDetailRepository;
        private readonly IBGVendorMasterRepository _bgVendorMasterRepository;

        private readonly IBGPPCMasterDetailRepository _bgPPCMasterDetailRepository;
        private readonly IBGPPCMasterRepository _bgPPCMasterRepository;

        private readonly IBGPPMMasterDetailRepository _bgPPMMasterDetailRepository;
        private readonly IBGPPMMasterRepository _bgPPMMasterRepository;

        private readonly IBGAcceptableMasterDataTableListRepository _bgAcceptableMasterDataTableListRepository;
        private readonly IBGAmendmentDataTableListRepository _bgAmendmentDataTableListRepository;
        private readonly IBGBankMasterDataTableListRepository _bgBankMasterDataTableListRepository;
        private readonly IBGCompanyMasterDataTableListRepository _bgCompanyMasterDataTableListRepository;
        private readonly IBGCurrencyMasterDataTableListRepository _bgCurrencyMasterDataTableListRepository;
        private readonly IBGGuaranteeTypeMasterDataTableListRepository _bgGuaranteeTypeMasterDataTableListRepository;
        private readonly IBGPayableMasterDataTableListRepository _bgPayableMasterDataTableListRepository;
        private readonly IBGProjectMasterDataTableListRepository _bgProjectMasterDataTableListRepository;

        private readonly IBGProjectControlMasterDataTableListRepository _bgProjectControlMasterDataTableListRepository;
        private readonly IBGPPCMasterDataTableListRepository _bgPPCMasterDataTableListRepository;
        private readonly IBGPPMMasterDataTableListRepository _bgPPMMasterDataTableListRepository;
        private readonly IBGProjectDriMasterDataTableListRepository _bgProjectDriMasterDataTableListRepository;
        private readonly IBGVendorTypeMasterDataTableListRepository _bgVendorTypeMasterDataTableListRepository;
        private readonly IBGVendorMasterDataTableListRepository _bgVendorMasterDataTableListRepository;

        public MastersController(
            IConfiguration configuration,
            IFilterRepository filterRepository,
            ISelectRepository selectRepository,
            ISelectTcmPLRepository selectTcmPLRepository,
            IBGAcceptableMasterDetailRepository bgAcceptableMasterDetailRepository,
            IBGAcceptableMasterRepository bgAcceptableMasterRepository,
            IBGBankMasterDetailRepository bgBankMasterDetailRepository,
            IBGBankMasterRepository bgBankMasterRepository,
            IBGCompanyMasterDetailRepository bgCompanyMasterDetailRepository,
            IBGCompanyMasterRepository bgCompanyMasterRepository,
            IBGCurrencyMasterDetailRepository bgCurrencyMasterDetailRepository,
            IBGCurrencyMasterRepository bgCurrencyMasterRepository,
            IBGGuaranteeTypeMasterDetailRepository bgGuaranteeTypeMasterDetailRepository,
            IBGGuaranteeTypeMasterRepository bgGuaranteeTypeMasterRepository,
            IBGPayableMasterDetailRepository bgPayableMasterDetailRepository,
            IBGPayableMasterRepository bgPayableMasterRepository,
            IBGAcceptableMasterDataTableListRepository bgAcceptableMasterDataTableListRepository,
            IBGAmendmentDataTableListRepository bgAmendmentDataTableListRepository,
            IBGBankMasterDataTableListRepository bgBankMasterDataTableListRepository,
            IBGCompanyMasterDataTableListRepository bgCompanyMasterDataTableListRepository,
            IBGCurrencyMasterDataTableListRepository bgCurrencyMasterDataTableListRepository,
            IBGGuaranteeTypeMasterDataTableListRepository bgGuaranteeTypeMasterDataTableListRepository,
            IBGPayableMasterDataTableListRepository bgPayableMasterDataTableListRepository,

            IBGProjectMasterDataTableListRepository bgProjectMasterDataTableListRepository,          
            IBGProjectMasterDetailRepository bgProjectMasterDetailRepository,
            IBGProjectMasterRepository bgProjectMasterRepository,


            IBGProjectControlMasterDetailRepository bgProjectControlMasterDetailRepository,
            IBGProjectControlMasterRepository bgProjectControlMasterRepository,
            IBGProjectDriMasterDetailRepository bgProjectDriMasterDetailRepository,
            IBGProjectDriMasterRepository bgProjectDriMasterRepository,
            IBGVendorTypeMasterDetailRepository bgVendorTypeMasterDetailRepository,
            IBGVendorTypeMasterRepository bgVendorTypeMasterRepository,
            IBGPPCMasterDetailRepository bgPPCMasterDetailRepository,
            IBGPPCMasterRepository bgPPCMasterRepository,
            IBGPPMMasterDetailRepository bgPPMMasterDetailRepository,
            IBGPPMMasterRepository bgPPMMasterRepository,
            IBGVendorMasterDetailRepository bgVendorMasterDetailRepository,
            IBGVendorMasterRepository bgVendorMasterRepository,
            IBGProjectControlMasterDataTableListRepository bgProjectControlMasterDataTableListRepository,
            IBGPPCMasterDataTableListRepository bgPPCMasterDataTableListRepository,
            IBGPPMMasterDataTableListRepository bgPPMMasterDataTableListRepository,
            IBGProjectDriMasterDataTableListRepository bgProjectDriMasterDataTableListRepository,
            IBGVendorTypeMasterDataTableListRepository bgVendorTypeMasterDataTableListRepository,
            IBGVendorMasterDataTableListRepository bgVendorMasterDataTableListRepository
        )
        {
            _configuration = configuration;
            _filterRepository = filterRepository;
            _selectRepository = selectRepository;
            _selectTcmPLRepository = selectTcmPLRepository;
            _bgAcceptableMasterDetailRepository = bgAcceptableMasterDetailRepository;
            _bgAcceptableMasterRepository = bgAcceptableMasterRepository;
            _bgBankMasterDetailRepository = bgBankMasterDetailRepository;
            _bgBankMasterRepository = bgBankMasterRepository;
            _bgCompanyMasterDetailRepository = bgCompanyMasterDetailRepository;
            _bgCompanyMasterRepository = bgCompanyMasterRepository;
            _bgCurrencyMasterDetailRepository = bgCurrencyMasterDetailRepository;
            _bgCurrencyMasterRepository = bgCurrencyMasterRepository;
            _bgGuaranteeTypeMasterDetailRepository = bgGuaranteeTypeMasterDetailRepository;
            _bgGuaranteeTypeMasterRepository = bgGuaranteeTypeMasterRepository;
            _bgPayableMasterDetailRepository = bgPayableMasterDetailRepository;
            _bgPayableMasterRepository = bgPayableMasterRepository;
            _bgAcceptableMasterDataTableListRepository = bgAcceptableMasterDataTableListRepository;
            _bgAmendmentDataTableListRepository = bgAmendmentDataTableListRepository;
            _bgBankMasterDataTableListRepository = bgBankMasterDataTableListRepository;
            _bgCompanyMasterDataTableListRepository = bgCompanyMasterDataTableListRepository;
            _bgCurrencyMasterDataTableListRepository = bgCurrencyMasterDataTableListRepository;
            _bgGuaranteeTypeMasterDataTableListRepository = bgGuaranteeTypeMasterDataTableListRepository;
            _bgPayableMasterDataTableListRepository = bgPayableMasterDataTableListRepository;

            _bgProjectMasterDataTableListRepository = bgProjectMasterDataTableListRepository;
            _bgProjectMasterDetailRepository = bgProjectMasterDetailRepository;
            _bgProjectMasterRepository = bgProjectMasterRepository;

            _bgProjectControlMasterDetailRepository = bgProjectControlMasterDetailRepository;
            _bgProjectControlMasterRepository = bgProjectControlMasterRepository;
            _bgProjectDriMasterDetailRepository = bgProjectDriMasterDetailRepository;
            _bgProjectDriMasterRepository = bgProjectDriMasterRepository;
            _bgVendorTypeMasterDetailRepository = bgVendorTypeMasterDetailRepository;
            _bgVendorTypeMasterRepository = bgVendorTypeMasterRepository;
            _bgVendorMasterDetailRepository = bgVendorMasterDetailRepository;
            _bgVendorMasterRepository = bgVendorMasterRepository;
            _bgPPCMasterDetailRepository = bgPPCMasterDetailRepository;
            _bgPPCMasterRepository = bgPPCMasterRepository;
            _bgPPMMasterDetailRepository = bgPPMMasterDetailRepository;
            _bgPPMMasterRepository = bgPPMMasterRepository;

            _bgProjectControlMasterDataTableListRepository = bgProjectControlMasterDataTableListRepository;
            _bgProjectDriMasterDataTableListRepository = bgProjectDriMasterDataTableListRepository;
            _bgVendorTypeMasterDataTableListRepository = bgVendorTypeMasterDataTableListRepository;
            _bgVendorMasterDataTableListRepository = bgVendorMasterDataTableListRepository;
            _bgPPCMasterDataTableListRepository = bgPPCMasterDataTableListRepository;
            _bgPPMMasterDataTableListRepository = bgPPMMasterDataTableListRepository;
        }

        public IActionResult Index()
        {
            return View();
        }

        #region AcceptableIndex

        public async Task<IActionResult> AcceptableIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterAcceptableIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            BGAcceptableViewModel bgAcceptableViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(bgAcceptableViewModel);

            //var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            //{
            //    PModuleName = CurrentUserIdentity.CurrentModule,
            //    PMetaId = CurrentUserIdentity.MetaId,
            //    PPersonId = CurrentUserIdentity.EmployeeId,
            //    PMvcActionName = "Index"
            //});
            //FilterDataModel filterDataModel = new FilterDataModel();
            //if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            //    filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            //BGAmendmentDataTableListViewModel bgAmendmentDataTableListViewModel = new BGAmendmentDataTableListViewModel();
            //bgAmendmentDataTableListViewModel.FilterDataModel = filterDataModel;

            //return View(bgAmendmentDataTableListViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> AcceptableDetail(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            BGAcceptableMasterDetail result = await _bgAcceptableMasterDetailRepository.BGAcceptableMasterDetail(
                         BaseSpTcmPLGet(), new ParameterSpTcmPL { PAcceptableId = id });

            BGAcceptableViewModel bgAcceptableViewModel = new();

            if (result.PMessageType == IsOk)
            {
                bgAcceptableViewModel.ApplicationId = id;
                bgAcceptableViewModel.AcceptableName = result.PAcceptableName;
                bgAcceptableViewModel.IsVisible = result.PIsVisible;
                bgAcceptableViewModel.IsDeleted = result.PIsDeleted;
                bgAcceptableViewModel.ModifiedOn = result.PModifiedOn;
                bgAcceptableViewModel.ModifiedBy = result.PModifiedBy;
            }

            return PartialView("_ModalAcceptableDetail", bgAcceptableViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsAcceptable(DTParameters param)
        {
            DTResult<BGAcceptableMasterDataTableList> result = new();
            int totalRow = 0;

            try
            {
                System.Collections.Generic.IEnumerable<BGAcceptableMasterDataTableList> data = await _bgAcceptableMasterDataTableListRepository.BGAcceptableMasterDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
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

        //[RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, BGHelper.ActionCreateMasters)]
        public IActionResult AcceptableCreate()
        {
            BGAcceptableCreateViewModel acceptableCreateViewModel = new()
            {
                IsVisible = 1
            };
            return PartialView("_ModalAcceptableCreate", acceptableCreateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> AcceptableCreate([FromForm] BGAcceptableCreateViewModel acceptableCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    DBProcMessageOutput result = await _bgAcceptableMasterRepository.BGAcceptableMasterCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PAcceptableId = acceptableCreateViewModel.AcceptableId,
                            PAccetableName = acceptableCreateViewModel.AcceptableName,
                            PIsVisible = acceptableCreateViewModel.IsVisible
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

            return PartialView("_ModalAcceptableCreate", acceptableCreateViewModel);
        }

        //[RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, BGHelper.ActionCreateMasters)]
        public async Task<IActionResult> AcceptableUpdate(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            BGAcceptableMasterDetail result = await _bgAcceptableMasterDetailRepository.BGAcceptableMasterDetail(
                         BaseSpTcmPLGet(), new ParameterSpTcmPL { PAcceptableId = id });

            BGAcceptableUpdateViewModel bgAcceptableUpdateViewModel = new();

            if (result.PMessageType == IsOk)
            {
                bgAcceptableUpdateViewModel.AcceptableId = id;
                bgAcceptableUpdateViewModel.AcceptableName = result.PAcceptableName;
                bgAcceptableUpdateViewModel.IsVisible = result.PIsVisible;
            }

            return PartialView("_ModalAcceptableUpdate", bgAcceptableUpdateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> AcceptableUpdate([FromForm] BGAcceptableUpdateViewModel acceptableUpdateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _bgAcceptableMasterRepository.BGAcceptableMasterEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PAcceptableId = acceptableUpdateViewModel.AcceptableId,
                            PAccetableName = acceptableUpdateViewModel.AcceptableName,
                            PIsVisible = acceptableUpdateViewModel.IsVisible
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

            return PartialView("_ModalAcceptableUpdate", acceptableUpdateViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> AcceptableDelete(string id)
        {
            try
            {
                var result = await _bgAcceptableMasterRepository.BGAcceptableMasterDeleteAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL { PAcceptableId = id }
                    );

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        #endregion AcceptableIndex

        #region BankIndex

        public async Task<IActionResult> BankIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterBankIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            BGBankViewModel bgBankViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(bgBankViewModel);

            //var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            //{
            //    PModuleName = CurrentUserIdentity.CurrentModule,
            //    PMetaId = CurrentUserIdentity.MetaId,
            //    PPersonId = CurrentUserIdentity.EmployeeId,
            //    PMvcActionName = "Index"
            //});
            //FilterDataModel filterDataModel = new FilterDataModel();
            //if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            //    filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            //BGAmendmentDataTableListViewModel bgAmendmentDataTableListViewModel = new BGAmendmentDataTableListViewModel();
            //bgAmendmentDataTableListViewModel.FilterDataModel = filterDataModel;

            //return View(bgAmendmentDataTableListViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> BankDetail(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            BGBankMasterDetail result = await _bgBankMasterDetailRepository.BGBankMasterDetail(
                         BaseSpTcmPLGet(), new ParameterSpTcmPL { PBankId = id });

            BGBankViewModel bgBankViewModel = new();

            if (result.PMessageType == IsOk)
            {
                bgBankViewModel.ApplicationId = id;
                bgBankViewModel.BankName = result.PBankName;
                bgBankViewModel.Comp = result.PComp;
                bgBankViewModel.IsVisible = result.PIsVisible;
                bgBankViewModel.IsDeleted = result.PIsDeleted;
                bgBankViewModel.ModifiedOn = result.PModifiedOn;
                bgBankViewModel.ModifiedBy = result.PModifiedBy;
            }

            return PartialView("_ModalBankDetail", bgBankViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsBank(DTParameters param)
        {
            DTResult<BGBankMasterDataTableList> result = new();
            int totalRow = 0;

            try
            {
                System.Collections.Generic.IEnumerable<BGBankMasterDataTableList> data = await _bgBankMasterDataTableListRepository.BGBankMasterDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
                        PGenericSearch = param.GenericSearch ?? " "
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

        //[RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, BGHelper.ActionCreateMasters)]
        public async Task<IActionResult> BankCreate()
        {
            BGBankCreateViewModel BankCreateViewModel = new()
            {
                IsVisible = 1
            };

            var bgCompanies = await _selectTcmPLRepository.BgCompanyListAsync(BaseSpTcmPLGet(), null);
            ViewData["BgCompanies"] = new SelectList(bgCompanies, "DataValueField", "DataTextField");

            return PartialView("_ModalBankCreate", BankCreateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> BankCreate([FromForm] BGBankCreateViewModel bankCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _bgBankMasterRepository.BGBankMasterCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PBankName = bankCreateViewModel.BankName,
                            PComp = bankCreateViewModel.CompId,
                            PIsVisible = bankCreateViewModel.IsVisible
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

            return PartialView("_ModalBankCreate", bankCreateViewModel);
        }

        //[RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, BGHelper.ActionCreateMasters)]
        public async Task<IActionResult> BankUpdate(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            BGBankMasterDetail result = await _bgBankMasterDetailRepository.BGBankMasterDetail(
                         BaseSpTcmPLGet(), new ParameterSpTcmPL { PBankId = id });

            BGBankUpdateViewModel bgBankUpdateViewModel = new();

            if (result.PMessageType == IsOk)
            {
                bgBankUpdateViewModel.BankId = id;
                bgBankUpdateViewModel.BankName = result.PBankName;
                bgBankUpdateViewModel.CompId = result.PComp;
                bgBankUpdateViewModel.IsVisible = result.PIsVisible;
            }
            var bgCompanies = await _selectTcmPLRepository.BgCompanyListAsync(BaseSpTcmPLGet(), null);
            ViewData["BgCompanies"] = new SelectList(bgCompanies, "DataValueField", "DataTextField", bgBankUpdateViewModel.CompId);

            return PartialView("_ModalBankUpdate", bgBankUpdateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> BankUpdate([FromForm] BGBankUpdateViewModel bankUpdateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _bgBankMasterRepository.BGBankMasterEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PBankId = bankUpdateViewModel.BankId,
                            PBankName = bankUpdateViewModel.BankName,
                            PComp = bankUpdateViewModel.CompId,
                            PIsVisible = bankUpdateViewModel.IsVisible
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

            return PartialView("_ModalBankUpdate", bankUpdateViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> BankDelete(string id)
        {
            try
            {
                var result = await _bgBankMasterRepository.BGBankMasterDeleteAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL { PBankId = id }
                    );

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        #endregion BankIndex

        #region CompanyIndex

        public async Task<IActionResult> CompanyIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterCompanyIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            BGCompanyViewModel bgCompanyViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(bgCompanyViewModel);

            //var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            //{
            //    PModuleName = CurrentUserIdentity.CurrentModule,
            //    PMetaId = CurrentUserIdentity.MetaId,
            //    PPersonId = CurrentUserIdentity.EmployeeId,
            //    PMvcActionName = "Index"
            //});
            //FilterDataModel filterDataModel = new FilterDataModel();
            //if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            //    filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            //BGAmendmentDataTableListViewModel bgAmendmentDataTableListViewModel = new BGAmendmentDataTableListViewModel();
            //bgAmendmentDataTableListViewModel.FilterDataModel = filterDataModel;

            //return View(bgAmendmentDataTableListViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> CompanyDetail(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            BGCompanyMasterDetail result = await _bgCompanyMasterDetailRepository.BGCompanyMasterDetail(
                         BaseSpTcmPLGet(), new ParameterSpTcmPL { PCompId = id });

            BGCompanyViewModel bgCompanyViewModel = new();

            if (result.PMessageType == IsOk)
            {
                bgCompanyViewModel.ApplicationId = id;
                bgCompanyViewModel.CompDesc = result.PCompDesc;
                bgCompanyViewModel.Domain = result.PDomain;
                bgCompanyViewModel.IsVisible = result.PIsVisible;
                bgCompanyViewModel.IsDeleted = result.PIsDeleted;
                bgCompanyViewModel.ModifiedOn = result.PModifiedOn;
                bgCompanyViewModel.ModifiedBy = result.PModifiedBy;
            }

            return PartialView("_ModalCompanyDetail", bgCompanyViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsCompany(DTParameters param)
        {
            DTResult<BGCompanyMasterDataTableList> result = new();
            int totalRow = 0;

            try
            {
                System.Collections.Generic.IEnumerable<BGCompanyMasterDataTableList> data = await _bgCompanyMasterDataTableListRepository.BGCompanyMasterDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
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

        //[RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, BGHelper.ActionCreateMasters)]
        public IActionResult CompanyCreate()
        {
            BGCompanyCreateViewModel CompanyCreateViewModel = new()
            {
                IsVisible = 1
            };
            return PartialView("_ModalCompanyCreate", CompanyCreateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> CompanyCreate([FromForm] BGCompanyCreateViewModel companyCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _bgCompanyMasterRepository.BGCompanyMasterCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PCompId = companyCreateViewModel.CompanyId,
                            PCompDesc = companyCreateViewModel.CompDesc,
                            PDomain = companyCreateViewModel.Domain,
                            PIsVisible = companyCreateViewModel.IsVisible
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

            return PartialView("_ModalCompanyCreate", companyCreateViewModel);
        }

        //[RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, BGHelper.ActionCreateMasters)]
        public async Task<IActionResult> CompanyUpdate(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            BGCompanyMasterDetail result = await _bgCompanyMasterDetailRepository.BGCompanyMasterDetail(
                         BaseSpTcmPLGet(), new ParameterSpTcmPL { PCompId = id });

            BGCompanyUpdateViewModel bgCompanyUpdateViewModel = new();

            if (result.PMessageType == IsOk)
            {
                bgCompanyUpdateViewModel.CompanyId = id;
                bgCompanyUpdateViewModel.CompDesc = result.PCompDesc;
                bgCompanyUpdateViewModel.Domain = result.PDomain;
                bgCompanyUpdateViewModel.IsVisible = result.PIsVisible;
            }

            return PartialView("_ModalCompanyUpdate", bgCompanyUpdateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> CompanyUpdate([FromForm] BGCompanyUpdateViewModel companyUpdateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _bgCompanyMasterRepository.BGCompanyMasterEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PCompId = companyUpdateViewModel.CompanyId,
                            PCompDesc = companyUpdateViewModel.CompDesc,
                            PDomain = companyUpdateViewModel.Domain,
                            PIsVisible = companyUpdateViewModel.IsVisible
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

            return PartialView("_ModalCompanyUpdate", companyUpdateViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> CompanyDelete(string id)
        {
            try
            {
                var result = await _bgCompanyMasterRepository.BGCompanyMasterDeleteAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL { PCompId = id }
                    );

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        #endregion CompanyIndex

        #region CurrencyIndex

        public async Task<IActionResult> CurrencyIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterCurrencyIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            BGCurrencyViewModel bgCurrencyViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(bgCurrencyViewModel);

            //var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            //{
            //    PModuleName = CurrentUserIdentity.CurrentModule,
            //    PMetaId = CurrentUserIdentity.MetaId,
            //    PPersonId = CurrentUserIdentity.EmployeeId,
            //    PMvcActionName = "Index"
            //});
            //FilterDataModel filterDataModel = new FilterDataModel();
            //if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            //    filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            //BGAmendmentDataTableListViewModel bgAmendmentDataTableListViewModel = new BGAmendmentDataTableListViewModel();
            //bgAmendmentDataTableListViewModel.FilterDataModel = filterDataModel;

            //return View(bgAmendmentDataTableListViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> CurrencyDetail(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            BGCurrencyMasterDetail result = await _bgCurrencyMasterDetailRepository.BGCurrencyMasterDetail(
                         BaseSpTcmPLGet(), new ParameterSpTcmPL { PCurrId = id });

            BGCurrencyViewModel bgCurrencyViewModel = new();

            if (result.PMessageType == IsOk)
            {
                bgCurrencyViewModel.ApplicationId = id;
                bgCurrencyViewModel.CompDesc = result.PCompDesc;
                bgCurrencyViewModel.CurrDesc = result.PCurrDesc;
                bgCurrencyViewModel.CompId = result.PCompId;
                bgCurrencyViewModel.IsVisible = result.PIsVisible;
                bgCurrencyViewModel.IsDeleted = result.PIsDeleted;
                bgCurrencyViewModel.ModifiedOn = result.PModifiedOn;
                bgCurrencyViewModel.ModifiedBy = result.PModifiedBy;
            }

            return PartialView("_ModalCurrencyDetail", bgCurrencyViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsCurrency(DTParameters param)
        {
            DTResult<BGCurrencyMasterDataTableList> result = new();
            int totalRow = 0;

            try
            {
                System.Collections.Generic.IEnumerable<BGCurrencyMasterDataTableList> data = await _bgCurrencyMasterDataTableListRepository.BGCurrencyMasterDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
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

        //[RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, BGHelper.ActionCreateMasters)]
        public async Task<IActionResult> CurrencyCreate()
        {
            BGCurrencyCreateViewModel CurrencyCreateViewModel = new()
            {
                IsVisible = 1
            };

            var bgCompanies = await _selectTcmPLRepository.BgCompanyListAsync(BaseSpTcmPLGet(), null);
            ViewData["BgCompanies"] = new SelectList(bgCompanies, "DataValueField", "DataTextField");

            return PartialView("_ModalCurrencyCreate", CurrencyCreateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> CurrencyCreate([FromForm] BGCurrencyCreateViewModel currencyCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _bgCurrencyMasterRepository.BGCurrencyMasterCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PCurrId = currencyCreateViewModel.CurrencyId,
                            PCurrDesc = currencyCreateViewModel.CurrDesc,
                            PCompId = currencyCreateViewModel.CompId,
                            PIsVisible = currencyCreateViewModel.IsVisible
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

            return PartialView("_ModalCurrencyCreate", currencyCreateViewModel);
        }

        //[RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, BGHelper.ActionCreateMasters)]
        public async Task<IActionResult> CurrencyUpdate(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            BGCurrencyMasterDetail result = await _bgCurrencyMasterDetailRepository.BGCurrencyMasterDetail(
                         BaseSpTcmPLGet(), new ParameterSpTcmPL { PCurrId = id });

            BGCurrencyUpdateViewModel bgCurrencyUpdateViewModel = new();

            if (result.PMessageType == IsOk)
            {
                bgCurrencyUpdateViewModel.CurrencyId = id;
                bgCurrencyUpdateViewModel.CompDesc = result.PCompDesc;
                bgCurrencyUpdateViewModel.CurrDesc = result.PCurrDesc;
                bgCurrencyUpdateViewModel.CompId = result.PCompId;
                bgCurrencyUpdateViewModel.IsVisible = result.PIsVisible;
            }
            var bgCompanies = await _selectTcmPLRepository.BgCompanyListAsync(BaseSpTcmPLGet(), null);
            ViewData["BgCompanies"] = new SelectList(bgCompanies, "DataValueField", "DataTextField", bgCurrencyUpdateViewModel.CompId);

            return PartialView("_ModalCurrencyUpdate", bgCurrencyUpdateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> CurrencyUpdate([FromForm] BGCurrencyUpdateViewModel currencyUpdateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _bgCurrencyMasterRepository.BGCurrencyMasterEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PCurrId = currencyUpdateViewModel.CurrencyId,
                            PCurrDesc = currencyUpdateViewModel.CurrDesc,
                            PCompId = currencyUpdateViewModel.CompId,
                            PIsVisible = currencyUpdateViewModel.IsVisible
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

            return PartialView("_ModalCurrencyUpdate", currencyUpdateViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> CurrencyDelete(string id)
        {
            try
            {
                var result = await _bgCurrencyMasterRepository.BGCurrencyMasterDeleteAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL { PCurrId = id }
                    );

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        #endregion CurrencyIndex

        #region GuaranteeTypeIndex

        public async Task<IActionResult> GuaranteeTypeIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterGuaranteeTypeIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            BGGuaranteeTypeViewModel bgGuaranteeTypeViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(bgGuaranteeTypeViewModel);

            //var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            //{
            //    PModuleName = CurrentUserIdentity.CurrentModule,
            //    PMetaId = CurrentUserIdentity.MetaId,
            //    PPersonId = CurrentUserIdentity.EmployeeId,
            //    PMvcActionName = "Index"
            //});
            //FilterDataModel filterDataModel = new FilterDataModel();
            //if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            //    filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            //BGAmendmentDataTableListViewModel bgAmendmentDataTableListViewModel = new BGAmendmentDataTableListViewModel();
            //bgAmendmentDataTableListViewModel.FilterDataModel = filterDataModel;

            //return View(bgAmendmentDataTableListViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> GuaranteeTypeDetail(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            BGGuaranteeTypeMasterDetail result = await _bgGuaranteeTypeMasterDetailRepository.BGGuaranteeTypeMasterDetail(
                         BaseSpTcmPLGet(), new ParameterSpTcmPL { PGuaranteeTypeId = id });

            BGGuaranteeTypeViewModel bgGuaranteeTypeViewModel = new();

            if (result.PMessageType == IsOk)
            {
                bgGuaranteeTypeViewModel.ApplicationId = id;
                bgGuaranteeTypeViewModel.GuaranteeType = result.PGuaranteeType;
                bgGuaranteeTypeViewModel.IsVisible = result.PIsVisible;
                bgGuaranteeTypeViewModel.IsDeleted = result.PIsDeleted;
                bgGuaranteeTypeViewModel.ModifiedOn = result.PModifiedOn;
                bgGuaranteeTypeViewModel.ModifiedBy = result.PModifiedBy;
            }

            return PartialView("_ModalGuaranteeTypeDetail", bgGuaranteeTypeViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsGuaranteeType(DTParameters param)
        {
            DTResult<BGGuaranteeTypeMasterDataTableList> result = new();
            int totalRow = 0;

            try
            {
                System.Collections.Generic.IEnumerable<BGGuaranteeTypeMasterDataTableList> data = await _bgGuaranteeTypeMasterDataTableListRepository.BGGuaranteeTypeMasterDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
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

        //[RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, BGHelper.ActionCreateMasters)]
        public IActionResult GuaranteeTypeCreate()
        {
            BGGuaranteeTypeCreateViewModel GuaranteeTypeCreateViewModel = new()
            {
                IsVisible = 1
            };
            return PartialView("_ModalGuaranteeTypeCreate", GuaranteeTypeCreateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> GuaranteeTypeCreate([FromForm] BGGuaranteeTypeCreateViewModel guaranteeTypeCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _bgGuaranteeTypeMasterRepository.BGGuaranteeTypeMasterCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PGuaranteeTypeId = guaranteeTypeCreateViewModel.GuaranteeTypeId,
                            PGuaranteeType = guaranteeTypeCreateViewModel.GuaranteeType,
                            PIsVisible = guaranteeTypeCreateViewModel.IsVisible
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

            return PartialView("_ModalGuaranteeTypeCreate", guaranteeTypeCreateViewModel);
        }

        //[RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, BGHelper.ActionCreateMasters)]
        public async Task<IActionResult> GuaranteeTypeUpdate(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            BGGuaranteeTypeMasterDetail result = await _bgGuaranteeTypeMasterDetailRepository.BGGuaranteeTypeMasterDetail(
                         BaseSpTcmPLGet(), new ParameterSpTcmPL { PGuaranteeTypeId = id });

            BGGuaranteeTypeUpdateViewModel bgGuaranteeTypeUpdateViewModel = new();

            if (result.PMessageType == IsOk)
            {
                bgGuaranteeTypeUpdateViewModel.GuaranteeTypeId = id;
                bgGuaranteeTypeUpdateViewModel.GuaranteeType = result.PGuaranteeType;

                bgGuaranteeTypeUpdateViewModel.IsVisible = result.PIsVisible;
            }

            return PartialView("_ModalGuaranteeTypeUpdate", bgGuaranteeTypeUpdateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> GuaranteeTypeUpdate([FromForm] BGGuaranteeTypeUpdateViewModel guaranteeTypeUpdateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _bgGuaranteeTypeMasterRepository.BGGuaranteeTypeMasterEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PGuaranteeTypeId = guaranteeTypeUpdateViewModel.GuaranteeTypeId,
                            PGuaranteeType = guaranteeTypeUpdateViewModel.GuaranteeType,
                            PIsVisible = guaranteeTypeUpdateViewModel.IsVisible
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

            return PartialView("_ModalGuaranteeTypeUpdate", guaranteeTypeUpdateViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> GuaranteeTypeDelete(string id)
        {
            try
            {
                var result = await _bgGuaranteeTypeMasterRepository.BGGuaranteeTypeMasterDeleteAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL { PGuaranteeTypeId = id }
                    );

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        #endregion GuaranteeTypeIndex

        #region PayableIndex

        public async Task<IActionResult> PayableIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterPayableIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            BGPayableViewModel bgPayableViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(bgPayableViewModel);

            //var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            //{
            //    PModuleName = CurrentUserIdentity.CurrentModule,
            //    PMetaId = CurrentUserIdentity.MetaId,
            //    PPersonId = CurrentUserIdentity.EmployeeId,
            //    PMvcActionName = "Index"
            //});
            //FilterDataModel filterDataModel = new FilterDataModel();
            //if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            //    filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            //BGAmendmentDataTableListViewModel bgAmendmentDataTableListViewModel = new BGAmendmentDataTableListViewModel();
            //bgAmendmentDataTableListViewModel.FilterDataModel = filterDataModel;

            //return View(bgAmendmentDataTableListViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> PayableDetail(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            BGPayableMasterDetail result = await _bgPayableMasterDetailRepository.BGPayableMasterDetail(
                         BaseSpTcmPLGet(), new ParameterSpTcmPL { PPayableId = id });

            BGPayableViewModel bgPayableViewModel = new();

            if (result.PMessageType == IsOk)
            {
                bgPayableViewModel.ApplicationId = id;
                bgPayableViewModel.Employee = result.PEmpno;
                bgPayableViewModel.Employee = result.PEmployee;

                bgPayableViewModel.IsVisible = result.PIsVisible;
                bgPayableViewModel.IsDeleted = result.PIsDeleted;
                bgPayableViewModel.ModifiedOn = result.PModifiedOn;
                bgPayableViewModel.ModifiedBy = result.PModifiedBy;
            }

            return PartialView("_ModalPayableDetail", bgPayableViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsPayable(DTParameters param)
        {
            DTResult<BGPayableMasterDataTableList> result = new();
            int totalRow = 0;

            try
            {
                System.Collections.Generic.IEnumerable<BGPayableMasterDataTableList> data = await _bgPayableMasterDataTableListRepository.BGPayableMasterDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
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

        //[RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, BGHelper.ActionCreateMasters)]
        public async Task<IActionResult> PayableCreate()
        {
            BGPayableCreateViewModel PayableCreateViewModel = new()
            {
                IsVisible = 1
            };

            var bgCompanies = await _selectTcmPLRepository.BgCompanyListAsync(BaseSpTcmPLGet(), null);
            ViewData["BgCompanies"] = new SelectList(bgCompanies, "DataValueField", "DataTextField");

            var bgEmployees = await _selectTcmPLRepository.SWPEmployeeList4AdminAsync(BaseSpTcmPLGet(), null);
            ViewData["BgEmployees"] = new SelectList(bgEmployees, "DataValueField", "DataTextField");

            return PartialView("_ModalPayableCreate", PayableCreateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> PayableCreate([FromForm] BGPayableCreateViewModel payableCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _bgPayableMasterRepository.BGPayableMasterCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PEmpno = payableCreateViewModel.Empno,
                            PCompId = payableCreateViewModel.CompId,
                            PIsVisible = payableCreateViewModel.IsVisible
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
            var bgCompanies = await _selectTcmPLRepository.BgCompanyListAsync(BaseSpTcmPLGet(), null);
            ViewData["BgCompanies"] = new SelectList(bgCompanies, "DataValueField", "DataTextField", payableCreateViewModel.CompId);

            var bgEmployees = await _selectTcmPLRepository.SWPEmployeeList4AdminAsync(BaseSpTcmPLGet(), null);
            ViewData["BgEmployees"] = new SelectList(bgEmployees, "DataValueField", "DataTextField", payableCreateViewModel.Empno);

            return PartialView("_ModalPayableCreate", payableCreateViewModel);
        }

        //[RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, BGHelper.ActionCreateMasters)]
        public async Task<IActionResult> PayableUpdate(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            BGPayableMasterDetail result = await _bgPayableMasterDetailRepository.BGPayableMasterDetail(
                         BaseSpTcmPLGet(), new ParameterSpTcmPL { PPayableId = id });

            BGPayableUpdateViewModel bgPayableUpdateViewModel = new();

            if (result.PMessageType == IsOk)
            {
                bgPayableUpdateViewModel.PayableId = id;
                bgPayableUpdateViewModel.CompId = result.PCompId;
                bgPayableUpdateViewModel.Employee = result.PEmployee;
                bgPayableUpdateViewModel.Empno = result.PEmpno;
                bgPayableUpdateViewModel.IsVisible = result.PIsVisible;
            }

            var bgCompanies = await _selectTcmPLRepository.BgCompanyListAsync(BaseSpTcmPLGet(), null);
            ViewData["BgCompanies"] = new SelectList(bgCompanies, "DataValueField", "DataTextField", bgPayableUpdateViewModel.CompId);

            var bgEmployees = await _selectTcmPLRepository.SWPEmployeeList4AdminAsync(BaseSpTcmPLGet(), null);
            ViewData["BgEmployees"] = new SelectList(bgEmployees, "DataValueField", "DataTextField", bgPayableUpdateViewModel.Empno);

            return PartialView("_ModalPayableUpdate", bgPayableUpdateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> PayableUpdate([FromForm] BGPayableUpdateViewModel payableUpdateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _bgPayableMasterRepository.BGPayableMasterEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PPayableId = payableUpdateViewModel.PayableId,
                            PEmpno = payableUpdateViewModel.Empno,
                            PCompId = payableUpdateViewModel.CompId,
                            PIsVisible = payableUpdateViewModel.IsVisible
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

            return PartialView("_ModalPayableUpdate", payableUpdateViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> PayableDelete(string id)
        {
            try
            {
                var result = await _bgPayableMasterRepository.BGPayableMasterDeleteAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL { PPayableId = id }
                    );

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        #endregion PayableIndex

        #region ProjectIndex

        public async Task<IActionResult> ProjectIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterProjectIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            BGProjectViewModel bgProjectViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(bgProjectViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> ProjectDetail(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            BGProjectMasterDetail result = await _bgProjectMasterDetailRepository.BGProjectMasterDetail(
                         BaseSpTcmPLGet(), new ParameterSpTcmPL { PProjnum = id });

            BGProjectViewModel bgProjectViewModel = new();

            if (result.PMessageType == IsOk)
            {
                bgProjectViewModel.Projnum = id;
                bgProjectViewModel.Name = result.PName;
                bgProjectViewModel.Mngrname = result.PMngrname;
                bgProjectViewModel.Mngremail = result.PMngremail;
                bgProjectViewModel.Isclosed = result.PIsclosed;
                bgProjectViewModel.Modifiedon = result.PModifiedon;
                bgProjectViewModel.Modifiedby = result.PModifiedby;
            }

            return PartialView("_ModalProjectDetail", bgProjectViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsProject(DTParameters param)
        {
            DTResult<BGProjectMasterDataTableList> result = new();
            int totalRow = 0;

            try
            {
                System.Collections.Generic.IEnumerable<BGProjectMasterDataTableList> data = await _bgProjectMasterDataTableListRepository.BGProjectMasterDataTableList(
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
      
        public IActionResult ProjectCreate()
        {
            BGProjectCreateViewModel ProjectCreateViewModel = new();            

            return PartialView("_ModalProjectCreate", ProjectCreateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ProjectCreate([FromForm] BGProjectCreateViewModel projectCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _bgProjectMasterRepository.BGProjectMasterCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PProjnum = projectCreateViewModel.Projnum,
                            PName = projectCreateViewModel.Name,
                            PMngrname = projectCreateViewModel.Mngrname,
                            PMngremail = projectCreateViewModel.Mngremail
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

            return PartialView("_ModalProjectCreate", projectCreateViewModel);
        }
        
        public async Task<IActionResult> ProjectUpdate(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            BGProjectMasterDetail result = await _bgProjectMasterDetailRepository.BGProjectMasterDetail(
                         BaseSpTcmPLGet(), new ParameterSpTcmPL { PProjnum = id });

            BGProjectUpdateViewModel bgProjectUpdateViewModel = new();

            if (result.PMessageType == IsOk)
            {
                bgProjectUpdateViewModel.Projnum = id;
                bgProjectUpdateViewModel.Name = result.PName;
                bgProjectUpdateViewModel.Mngrname = result.PMngrname;
                bgProjectUpdateViewModel.Mngremail = result.PMngremail;
                bgProjectUpdateViewModel.Isclosed = result.PIsclosed;
            }

            return PartialView("_ModalProjectUpdate", bgProjectUpdateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ProjectUpdate([FromForm] BGProjectUpdateViewModel projectUpdateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _bgProjectMasterRepository.BGProjectMasterEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PProjnum = projectUpdateViewModel.Projnum,
                            PName = projectUpdateViewModel.Name,
                            PMngrname = projectUpdateViewModel.Mngrname,
                            PMngremail = projectUpdateViewModel.Mngremail,
                            PIsClosed = projectUpdateViewModel.Isclosed
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

            return PartialView("_ModalProjectUpdate", projectUpdateViewModel);
        }


        #endregion ProjectIndex

        #region ProjectControlIndex

        public async Task<IActionResult> ProjectControlIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterProjectControlIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            BGProjectControlViewModel bgProjectControlViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(bgProjectControlViewModel);

            //var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            //{
            //    PModuleName = CurrentUserIdentity.CurrentModule,
            //    PMetaId = CurrentUserIdentity.MetaId,
            //    PPersonId = CurrentUserIdentity.EmployeeId,
            //    PMvcActionName = "Index"
            //});
            //FilterDataModel filterDataModel = new FilterDataModel();
            //if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            //    filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            //BGAmendmentDataTableListViewModel bgAmendmentDataTableListViewModel = new BGAmendmentDataTableListViewModel();
            //bgAmendmentDataTableListViewModel.FilterDataModel = filterDataModel;

            //return View(bgAmendmentDataTableListViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> ProjectControlDetail(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            BGProjectControlMasterDetail result = await _bgProjectControlMasterDetailRepository.BGProjectControlMasterDetail(
                         BaseSpTcmPLGet(), new ParameterSpTcmPL { PProjContlId = id });

            BGProjectControlViewModel bgProjectControlViewModel = new();

            if (result.PMessageType == IsOk)
            {
                bgProjectControlViewModel.ApplicationId = id;
                bgProjectControlViewModel.Employee = result.PEmpno;
                bgProjectControlViewModel.Employee = result.PEmployee;

                bgProjectControlViewModel.IsVisible = result.PIsVisible;
                bgProjectControlViewModel.IsDeleted = result.PIsDeleted;
                bgProjectControlViewModel.ModifiedOn = result.PModifiedOn;
                bgProjectControlViewModel.ModifiedBy = result.PModifiedBy;
            }

            return PartialView("_ModalProjectControlDetail", bgProjectControlViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsProjectControl(DTParameters param)
        {
            DTResult<BGProjectControlMasterDataTableList> result = new();
            int totalRow = 0;

            try
            {
                System.Collections.Generic.IEnumerable<BGProjectControlMasterDataTableList> data = await _bgProjectControlMasterDataTableListRepository.BGProjectControlMasterDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
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

        //[RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, BGHelper.ActionCreateMasters)]
        public async Task<IActionResult> ProjectControlCreate()
        {
            BGProjectControlCreateViewModel ProjectControlCreateViewModel = new()
            {
                IsVisible = 1
            };

            var bgCompanies = await _selectTcmPLRepository.BgCompanyListAsync(BaseSpTcmPLGet(), null);
            ViewData["BgCompanies"] = new SelectList(bgCompanies, "DataValueField", "DataTextField");

            var bgEmployees = await _selectTcmPLRepository.SWPEmployeeList4AdminAsync(BaseSpTcmPLGet(), null);
            ViewData["BgEmployees"] = new SelectList(bgEmployees, "DataValueField", "DataTextField");

            return PartialView("_ModalProjectControlCreate", ProjectControlCreateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ProjectControlCreate([FromForm] BGProjectControlCreateViewModel bgProjectControlCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _bgProjectControlMasterRepository.BGProjectControlMasterCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PEmpno = bgProjectControlCreateViewModel.Empno,
                            PCompId = bgProjectControlCreateViewModel.CompId,
                            PIsVisible = bgProjectControlCreateViewModel.IsVisible
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
            var bgCompanies = await _selectTcmPLRepository.BgCompanyListAsync(BaseSpTcmPLGet(), null);
            ViewData["BgCompanies"] = new SelectList(bgCompanies, "DataValueField", "DataTextField", bgProjectControlCreateViewModel.CompId);

            var bgEmployees = await _selectTcmPLRepository.SWPEmployeeList4AdminAsync(BaseSpTcmPLGet(), null);
            ViewData["BgEmployees"] = new SelectList(bgEmployees, "DataValueField", "DataTextField", bgProjectControlCreateViewModel.Empno);

            return PartialView("_ModalProjectControlCreate", bgProjectControlCreateViewModel);
        }

        //[RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, BGHelper.ActionCreateMasters)]
        public async Task<IActionResult> ProjectControlUpdate(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            BGProjectControlMasterDetail result = await _bgProjectControlMasterDetailRepository.BGProjectControlMasterDetail(
                         BaseSpTcmPLGet(), new ParameterSpTcmPL { PProjContlId = id });

            BGProjectControlUpdateViewModel bgProjectControlUpdateViewModel = new();

            if (result.PMessageType == IsOk)
            {
                bgProjectControlUpdateViewModel.ProjectControlId = id;
                bgProjectControlUpdateViewModel.CompId = result.PCompId;
                bgProjectControlUpdateViewModel.Employee = result.PEmployee;
                bgProjectControlUpdateViewModel.Empno = result.PEmpno;
                bgProjectControlUpdateViewModel.IsVisible = result.PIsVisible;
            }

            var bgCompanies = await _selectTcmPLRepository.BgCompanyListAsync(BaseSpTcmPLGet(), null);
            ViewData["BgCompanies"] = new SelectList(bgCompanies, "DataValueField", "DataTextField", bgProjectControlUpdateViewModel.CompId);

            var bgEmployees = await _selectTcmPLRepository.SWPEmployeeList4AdminAsync(BaseSpTcmPLGet(), null);
            ViewData["BgEmployees"] = new SelectList(bgEmployees, "DataValueField", "DataTextField", bgProjectControlUpdateViewModel.Empno);

            return PartialView("_ModalProjectControlUpdate", bgProjectControlUpdateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ProjectControlUpdate([FromForm] BGProjectControlUpdateViewModel bgProjectControlUpdateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _bgProjectControlMasterRepository.BGProjectControlMasterEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PProjContlId = bgProjectControlUpdateViewModel.ProjectControlId,
                            PEmpno = bgProjectControlUpdateViewModel.Empno,
                            PCompId = bgProjectControlUpdateViewModel.CompId,
                            PIsVisible = bgProjectControlUpdateViewModel.IsVisible
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

            return PartialView("_ModalProjectControlUpdate", bgProjectControlUpdateViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> ProjectControlDelete(string id)
        {
            try
            {
                var result = await _bgProjectControlMasterRepository.BGProjectControlMasterDeleteAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL { PProjContlId = id }
                    );

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        #endregion ProjectControlIndex

        #region ProjectDriIndex

        public async Task<IActionResult> ProjectDriIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterProjectDriIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            BGProjectDriViewModel bgProjectDriViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(bgProjectDriViewModel);

            //var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            //{
            //    PModuleName = CurrentUserIdentity.CurrentModule,
            //    PMetaId = CurrentUserIdentity.MetaId,
            //    PPersonId = CurrentUserIdentity.EmployeeId,
            //    PMvcActionName = "Index"
            //});
            //FilterDataModel filterDataModel = new FilterDataModel();
            //if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            //    filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            //BGAmendmentDataTableListViewModel bgAmendmentDataTableListViewModel = new BGAmendmentDataTableListViewModel();
            //bgAmendmentDataTableListViewModel.FilterDataModel = filterDataModel;

            //return View(bgAmendmentDataTableListViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> ProjectDriDetail(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            BGProjectDriMasterDetail result = await _bgProjectDriMasterDetailRepository.BGProjectDriMasterDetail(
                         BaseSpTcmPLGet(), new ParameterSpTcmPL { PProjDirId = id });

            BGProjectDriViewModel bgProjectDriViewModel = new();

            if (result.PMessageType == IsOk)
            {
                bgProjectDriViewModel.ApplicationId = id;
                bgProjectDriViewModel.Employee = result.PEmpno;
                bgProjectDriViewModel.Employee = result.PEmployee;

                bgProjectDriViewModel.IsVisible = result.PIsVisible;
                bgProjectDriViewModel.IsDeleted = result.PIsDeleted;
                bgProjectDriViewModel.ModifiedOn = result.PModifiedOn;
                bgProjectDriViewModel.ModifiedBy = result.PModifiedBy;
            }

            return PartialView("_ModalProjectDriDetail", bgProjectDriViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsProjectDri(DTParameters param)
        {
            DTResult<BGProjectDriMasterDataTableList> result = new();
            int totalRow = 0;

            try
            {
                System.Collections.Generic.IEnumerable<BGProjectDriMasterDataTableList> data = await _bgProjectDriMasterDataTableListRepository.BGProjectDriMasterDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
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

        //[RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, BGHelper.ActionCreateMasters)]
        public async Task<IActionResult> ProjectDriCreate()
        {
            BGProjectDriCreateViewModel ProjectDriCreateViewModel = new()
            {
                IsVisible = 1
            };

            var bgCompanies = await _selectTcmPLRepository.BgCompanyListAsync(BaseSpTcmPLGet(), null);
            ViewData["BgCompanies"] = new SelectList(bgCompanies, "DataValueField", "DataTextField");

            var bgEmployees = await _selectTcmPLRepository.SWPEmployeeList4AdminAsync(BaseSpTcmPLGet(), null);
            ViewData["BgEmployees"] = new SelectList(bgEmployees, "DataValueField", "DataTextField");

            return PartialView("_ModalProjectDriCreate", ProjectDriCreateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ProjectDriCreate([FromForm] BGProjectDriCreateViewModel payableCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _bgProjectDriMasterRepository.BGProjectDriMasterCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PEmpno = payableCreateViewModel.Empno,
                            PCompId = payableCreateViewModel.CompId,
                            PIsVisible = payableCreateViewModel.IsVisible
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
            var bgCompanies = await _selectTcmPLRepository.BgCompanyListAsync(BaseSpTcmPLGet(), null);
            ViewData["BgCompanies"] = new SelectList(bgCompanies, "DataValueField", "DataTextField", payableCreateViewModel.CompId);

            var bgEmployees = await _selectTcmPLRepository.SWPEmployeeList4AdminAsync(BaseSpTcmPLGet(), null);
            ViewData["BgEmployees"] = new SelectList(bgEmployees, "DataValueField", "DataTextField", payableCreateViewModel.Empno);

            return PartialView("_ModalProjectDriCreate", payableCreateViewModel);
        }

        //[RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, BGHelper.ActionCreateMasters)]
        public async Task<IActionResult> ProjectDriUpdate(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            BGProjectDriMasterDetail result = await _bgProjectDriMasterDetailRepository.BGProjectDriMasterDetail(
                         BaseSpTcmPLGet(), new ParameterSpTcmPL { PProjDirId = id });

            BGProjectDriUpdateViewModel bgProjectDriUpdateViewModel = new();

            if (result.PMessageType == IsOk)
            {
                bgProjectDriUpdateViewModel.ProjectDriId = id;
                bgProjectDriUpdateViewModel.CompId = result.PCompId;
                bgProjectDriUpdateViewModel.Employee = result.PEmployee;
                bgProjectDriUpdateViewModel.Empno = result.PEmpno;
                bgProjectDriUpdateViewModel.IsVisible = result.PIsVisible;
            }

            var bgCompanies = await _selectTcmPLRepository.BgCompanyListAsync(BaseSpTcmPLGet(), null);
            ViewData["BgCompanies"] = new SelectList(bgCompanies, "DataValueField", "DataTextField", bgProjectDriUpdateViewModel.CompId);

            var bgEmployees = await _selectTcmPLRepository.SWPEmployeeList4AdminAsync(BaseSpTcmPLGet(), null);
            ViewData["BgEmployees"] = new SelectList(bgEmployees, "DataValueField", "DataTextField", bgProjectDriUpdateViewModel.Empno);

            return PartialView("_ModalProjectDriUpdate", bgProjectDriUpdateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ProjectDriUpdate([FromForm] BGProjectDriUpdateViewModel payableUpdateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _bgProjectDriMasterRepository.BGProjectDriMasterEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PProjDirId = payableUpdateViewModel.ProjectDriId,
                            PEmpno = payableUpdateViewModel.Empno,
                            PCompId = payableUpdateViewModel.CompId,
                            PIsVisible = payableUpdateViewModel.IsVisible
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

            return PartialView("_ModalProjectDriUpdate", payableUpdateViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> ProjectDriDelete(string id)
        {
            try
            {
                var result = await _bgProjectDriMasterRepository.BGProjectDriMasterDeleteAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL { PProjDirId = id }
                    );

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        #endregion ProjectDriIndex

        #region VendorIndex

        public async Task<IActionResult> VendorIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterVendorIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            BGVendorViewModel bgVendorViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(bgVendorViewModel);

            //var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            //{
            //    PModuleName = CurrentUserIdentity.CurrentModule,
            //    PMetaId = CurrentUserIdentity.MetaId,
            //    PPersonId = CurrentUserIdentity.EmployeeId,
            //    PMvcActionName = "Index"
            //});
            //FilterDataModel filterDataModel = new FilterDataModel();
            //if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            //    filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            //BGAmendmentDataTableListViewModel bgAmendmentDataTableListViewModel = new BGAmendmentDataTableListViewModel();
            //bgAmendmentDataTableListViewModel.FilterDataModel = filterDataModel;

            //return View(bgAmendmentDataTableListViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> VendorDetail(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            BGVendorMasterDetail result = await _bgVendorMasterDetailRepository.BGVendorMasterDetail(
                         BaseSpTcmPLGet(), new ParameterSpTcmPL { PVendorId = id });

            BGVendorViewModel bgVendorViewModel = new();

            if (result.PMessageType == IsOk)
            {
                bgVendorViewModel.ApplicationId = id;

                bgVendorViewModel.VendorName = result.PVendorName;

                bgVendorViewModel.IsVisible = result.PIsVisible;
                bgVendorViewModel.IsDeleted = result.PIsDeleted;
                bgVendorViewModel.ModifiedOn = result.PModifiedOn;
                bgVendorViewModel.ModifiedBy = result.PModifiedBy;
            }

            return PartialView("_ModalVendorDetail", bgVendorViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsVendor(DTParameters param)
        {
            DTResult<BGVendorMasterDataTableList> result = new();
            int totalRow = 0;

            try
            {
                System.Collections.Generic.IEnumerable<BGVendorMasterDataTableList> data = await _bgVendorMasterDataTableListRepository.BGVendorMasterDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
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

        //[RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, BGHelper.ActionCreateMasters)]
        public async Task<IActionResult> VendorCreate()
        {
            BGVendorCreateViewModel VendorCreateViewModel = new()
            {
                IsVisible = 1
            };

            var bgCompanies = await _selectTcmPLRepository.BgCompanyListAsync(BaseSpTcmPLGet(), null);
            ViewData["BgCompanies"] = new SelectList(bgCompanies, "DataValueField", "DataTextField");

            return PartialView("_ModalVendorCreate", VendorCreateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> VendorCreate([FromForm] BGVendorCreateViewModel payableCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _bgVendorMasterRepository.BGVendorMasterCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PVendorName = payableCreateViewModel.VendorName,
                            PCompId = payableCreateViewModel.CompId,
                            PIsVisible = payableCreateViewModel.IsVisible
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
            var bgCompanies = await _selectTcmPLRepository.BgCompanyListAsync(BaseSpTcmPLGet(), null);
            ViewData["BgCompanies"] = new SelectList(bgCompanies, "DataValueField", "DataTextField", payableCreateViewModel.CompId);

            return PartialView("_ModalVendorCreate", payableCreateViewModel);
        }

        //[RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, BGHelper.ActionCreateMasters)]
        public async Task<IActionResult> VendorUpdate(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            BGVendorMasterDetail result = await _bgVendorMasterDetailRepository.BGVendorMasterDetail(
                         BaseSpTcmPLGet(), new ParameterSpTcmPL { PVendorId = id });

            BGVendorUpdateViewModel bgVendorUpdateViewModel = new();

            if (result.PMessageType == IsOk)
            {
                bgVendorUpdateViewModel.VendorId = id;
                bgVendorUpdateViewModel.CompId = result.PCompId;
                bgVendorUpdateViewModel.VendorName = result.PVendorName;
                bgVendorUpdateViewModel.IsVisible = result.PIsVisible;
            }

            var bgCompanies = await _selectTcmPLRepository.BgCompanyListAsync(BaseSpTcmPLGet(), null);
            ViewData["BgCompanies"] = new SelectList(bgCompanies, "DataValueField", "DataTextField", bgVendorUpdateViewModel.CompId);

            return PartialView("_ModalVendorUpdate", bgVendorUpdateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> VendorUpdate([FromForm] BGVendorUpdateViewModel payableUpdateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _bgVendorMasterRepository.BGVendorMasterEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PVendorId = payableUpdateViewModel.VendorId,
                            PVendorName = payableUpdateViewModel.VendorName,
                            PCompId = payableUpdateViewModel.CompId,
                            PIsVisible = payableUpdateViewModel.IsVisible
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

            return PartialView("_ModalVendorUpdate", payableUpdateViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> VendorDelete(string id)
        {
            try
            {
                var result = await _bgVendorMasterRepository.BGVendorMasterDeleteAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL { PVendorId = id }
                    );

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        #endregion VendorIndex

        #region VendorTypeIndex

        public async Task<IActionResult> VendorTypeIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterVendorTypeIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            BGVendorTypeViewModel bgVendorTypeViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(bgVendorTypeViewModel);

            //var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            //{
            //    PModuleName = CurrentUserIdentity.CurrentModule,
            //    PMetaId = CurrentUserIdentity.MetaId,
            //    PPersonId = CurrentUserIdentity.EmployeeId,
            //    PMvcActionName = "Index"
            //});
            //FilterDataModel filterDataModel = new FilterDataModel();
            //if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            //    filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            //BGAmendmentDataTableListViewModel bgAmendmentDataTableListViewModel = new BGAmendmentDataTableListViewModel();
            //bgAmendmentDataTableListViewModel.FilterDataModel = filterDataModel;

            //return View(bgAmendmentDataTableListViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> VendorTypeDetail(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            BGVendorTypeMasterDetail result = await _bgVendorTypeMasterDetailRepository.BGVendorTypeMasterDetail(
                         BaseSpTcmPLGet(), new ParameterSpTcmPL { PVendorTypeId = id });

            BGVendorTypeViewModel bgVendorTypeViewModel = new();

            if (result.PMessageType == IsOk)
            {
                bgVendorTypeViewModel.ApplicationId = id;

                bgVendorTypeViewModel.VendorType = result.PVendorType;

                bgVendorTypeViewModel.IsVisible = result.PIsVisible;
                bgVendorTypeViewModel.IsDeleted = result.PIsDeleted;
                bgVendorTypeViewModel.ModifiedOn = result.PModifiedOn;
                bgVendorTypeViewModel.ModifiedBy = result.PModifiedBy;
            }

            return PartialView("_ModalVendorTypeDetail", bgVendorTypeViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsVendorType(DTParameters param)
        {
            DTResult<BGVendorTypeMasterDataTableList> result = new();
            int totalRow = 0;

            try
            {
                System.Collections.Generic.IEnumerable<BGVendorTypeMasterDataTableList> data = await _bgVendorTypeMasterDataTableListRepository.BGVendorTypeMasterDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
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

        //[RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, BGHelper.ActionCreateMasters)]
        public IActionResult VendorTypeCreate()
        {
            BGVendorTypeCreateViewModel VendorTypeCreateViewModel = new()
            {
                IsVisible = 1
            };

            return PartialView("_ModalVendorTypeCreate", VendorTypeCreateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> VendorTypeCreate([FromForm] BGVendorTypeCreateViewModel bgVendorTypeCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _bgVendorTypeMasterRepository.BGVendorTypeMasterCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PVendorType = bgVendorTypeCreateViewModel.VendorType,
                            PIsVisible = bgVendorTypeCreateViewModel.IsVisible
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

            return PartialView("_ModalVendorTypeCreate", bgVendorTypeCreateViewModel);
        }

        //[RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, BGHelper.ActionCreateMasters)]
        public async Task<IActionResult> VendorTypeUpdate(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            BGVendorTypeMasterDetail result = await _bgVendorTypeMasterDetailRepository.BGVendorTypeMasterDetail(
                         BaseSpTcmPLGet(), new ParameterSpTcmPL { PVendorTypeId = id });

            BGVendorTypeUpdateViewModel bgVendorTypeUpdateViewModel = new();

            if (result.PMessageType == IsOk)
            {
                bgVendorTypeUpdateViewModel.VendorTypeId = id;
                bgVendorTypeUpdateViewModel.VendorType = result.PVendorType;
                bgVendorTypeUpdateViewModel.IsVisible = result.PIsVisible;
            }

            return PartialView("_ModalVendorTypeUpdate", bgVendorTypeUpdateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> VendorTypeUpdate([FromForm] BGVendorTypeUpdateViewModel payableUpdateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _bgVendorTypeMasterRepository.BGVendorTypeMasterEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PVendorTypeId = payableUpdateViewModel.VendorTypeId,
                            PVendorType = payableUpdateViewModel.VendorType,
                            PIsVisible = payableUpdateViewModel.IsVisible
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

            return PartialView("_ModalVendorTypeUpdate", payableUpdateViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> VendorTypeDelete(string id)
        {
            try
            {
                var result = await _bgVendorTypeMasterRepository.BGVendorTypeMasterDeleteAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL { PVendorTypeId = id }
                    );

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        #endregion VendorTypeIndex

        #region PPCIndex

        public async Task<IActionResult> PPCIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterPPCIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            BGPPCViewModel bgPPCViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(bgPPCViewModel);

            //var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            //{
            //    PModuleName = CurrentUserIdentity.CurrentModule,
            //    PMetaId = CurrentUserIdentity.MetaId,
            //    PPersonId = CurrentUserIdentity.EmployeeId,
            //    PMvcActionName = "Index"
            //});
            //FilterDataModel filterDataModel = new FilterDataModel();
            //if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            //    filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            //BGAmendmentDataTableListViewModel bgAmendmentDataTableListViewModel = new BGAmendmentDataTableListViewModel();
            //bgAmendmentDataTableListViewModel.FilterDataModel = filterDataModel;

            //return View(bgAmendmentDataTableListViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> PPCDetail(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            BGPPCMasterDetail result = await _bgPPCMasterDetailRepository.BGPPCMasterDetail(
                         BaseSpTcmPLGet(), new ParameterSpTcmPL { PPpcId = id });

            BGPPCViewModel bgPPCViewModel = new();

            if (result.PMessageType == IsOk)
            {
                bgPPCViewModel.ApplicationId = id;
                bgPPCViewModel.Employee = result.PEmpno;
                bgPPCViewModel.Employee = result.PEmployee;
                bgPPCViewModel.ProjectNo = result.PProjno;
                bgPPCViewModel.Project = result.PProject;

                bgPPCViewModel.IsVisible = result.PIsVisible;
                bgPPCViewModel.IsDeleted = result.PIsDeleted;
                bgPPCViewModel.ModifiedOn = result.PModifiedOn;
                bgPPCViewModel.ModifiedBy = result.PModifiedBy;
            }

            return PartialView("_ModalPPCDetail", bgPPCViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsPPC(DTParameters param)
        {
            DTResult<BGPPCMasterDataTableList> result = new();
            int totalRow = 0;

            try
            {
                System.Collections.Generic.IEnumerable<BGPPCMasterDataTableList> data = await _bgPPCMasterDataTableListRepository.BGPPCMasterDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
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

        //[RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, BGHelper.ActionCreateMasters)]
        public async Task<IActionResult> PPCCreate()
        {
            BGPPCCreateViewModel PPCCreateViewModel = new()
            {
                IsVisible = 1
            };

            var bgProjects = await _selectTcmPLRepository.BgProjectListAsync(BaseSpTcmPLGet(), null);
            ViewData["BgProjects"] = new SelectList(bgProjects, "DataValueField", "DataTextField");

            var bgCompanies = await _selectTcmPLRepository.BgCompanyListAsync(BaseSpTcmPLGet(), null);
            ViewData["BgCompanies"] = new SelectList(bgCompanies, "DataValueField", "DataTextField");

            var bgEmployees = await _selectTcmPLRepository.SWPEmployeeList4AdminAsync(BaseSpTcmPLGet(), null);
            ViewData["BgEmployees"] = new SelectList(bgEmployees, "DataValueField", "DataTextField");

            return PartialView("_ModalPPCCreate", PPCCreateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> PPCCreate([FromForm] BGPPCCreateViewModel bgPPCCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _bgPPCMasterRepository.BGPPCMasterCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PEmpno = bgPPCCreateViewModel.Empno,
                            PProjno = bgPPCCreateViewModel.Project,
                            PCompId = bgPPCCreateViewModel.CompId,
                            PIsVisible = bgPPCCreateViewModel.IsVisible
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
            var bgProjects = await _selectTcmPLRepository.BgProjectListAsync(BaseSpTcmPLGet(), null);
            ViewData["BgProjects"] = new SelectList(bgProjects, "DataValueField", "DataTextField", bgPPCCreateViewModel.Project);

            var bgCompanies = await _selectTcmPLRepository.BgCompanyListAsync(BaseSpTcmPLGet(), null);
            ViewData["BgCompanies"] = new SelectList(bgCompanies, "DataValueField", "DataTextField", bgPPCCreateViewModel.CompId);

            var bgEmployees = await _selectTcmPLRepository.SWPEmployeeList4AdminAsync(BaseSpTcmPLGet(), null);
            ViewData["BgEmployees"] = new SelectList(bgEmployees, "DataValueField", "DataTextField", bgPPCCreateViewModel.Empno);

            return PartialView("_ModalPPCCreate", bgPPCCreateViewModel);
        }

        //[RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, BGHelper.ActionCreateMasters)]
        public async Task<IActionResult> PPCUpdate(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            BGPPCMasterDetail result = await _bgPPCMasterDetailRepository.BGPPCMasterDetail(
                         BaseSpTcmPLGet(), new ParameterSpTcmPL { PPpcId = id });

            BGPPCUpdateViewModel bgPPCUpdateViewModel = new();

            if (result.PMessageType == IsOk)
            {
                bgPPCUpdateViewModel.PPCId = id;
                bgPPCUpdateViewModel.CompId = result.PCompId;
                bgPPCUpdateViewModel.Employee = result.PEmployee;
                bgPPCUpdateViewModel.Projno = result.PProjno;
                bgPPCUpdateViewModel.Project = result.PProject;
                bgPPCUpdateViewModel.Empno = result.PEmpno;
                bgPPCUpdateViewModel.IsVisible = result.PIsVisible;
            }

            var bgProjects = await _selectTcmPLRepository.BgProjectListAsync(BaseSpTcmPLGet(), null);
            ViewData["BgProjects"] = new SelectList(bgProjects, "DataValueField", "DataTextField", bgPPCUpdateViewModel.Projno);

            var bgCompanies = await _selectTcmPLRepository.BgCompanyListAsync(BaseSpTcmPLGet(), null);
            ViewData["BgCompanies"] = new SelectList(bgCompanies, "DataValueField", "DataTextField", bgPPCUpdateViewModel.CompId);

            var bgEmployees = await _selectTcmPLRepository.SWPEmployeeList4AdminAsync(BaseSpTcmPLGet(), null);
            ViewData["BgEmployees"] = new SelectList(bgEmployees, "DataValueField", "DataTextField", bgPPCUpdateViewModel.Empno);

            return PartialView("_ModalPPCUpdate", bgPPCUpdateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> PPCUpdate([FromForm] BGPPCUpdateViewModel bgPPCUpdateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _bgPPCMasterRepository.BGPPCMasterEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PPpcId = bgPPCUpdateViewModel.PPCId,
                            PProjno = bgPPCUpdateViewModel.Projno,
                            PEmpno = bgPPCUpdateViewModel.Empno,
                            PCompId = bgPPCUpdateViewModel.CompId,
                            PIsVisible = bgPPCUpdateViewModel.IsVisible
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

            return PartialView("_ModalPPCUpdate", bgPPCUpdateViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> PPCDelete(string id)
        {
            try
            {
                var result = await _bgPPCMasterRepository.BGPPCMasterDeleteAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL { PPpcId = id }
                    );

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        #endregion PPCIndex

        #region PPMIndex

        public async Task<IActionResult> PPMIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterPPMIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            BGPPMViewModel bgPPMViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(bgPPMViewModel);

            //var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            //{
            //    PModuleName = CurrentUserIdentity.CurrentModule,
            //    PMetaId = CurrentUserIdentity.MetaId,
            //    PPersonId = CurrentUserIdentity.EmployeeId,
            //    PMvcActionName = "Index"
            //});
            //FilterDataModel filterDataModel = new FilterDataModel();
            //if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            //    filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            //BGAmendmentDataTableListViewModel bgAmendmentDataTableListViewModel = new BGAmendmentDataTableListViewModel();
            //bgAmendmentDataTableListViewModel.FilterDataModel = filterDataModel;

            //return View(bgAmendmentDataTableListViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> PPMDetail(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            BGPPMMasterDetail result = await _bgPPMMasterDetailRepository.BGPPMMasterDetail(
                         BaseSpTcmPLGet(), new ParameterSpTcmPL { PPpmId = id });

            BGPPMViewModel bgPPMViewModel = new();

            if (result.PMessageType == IsOk)
            {
                bgPPMViewModel.ApplicationId = id;
                bgPPMViewModel.Employee = result.PEmpno;
                bgPPMViewModel.Employee = result.PEmployee;
                bgPPMViewModel.ProjectNo = result.PProjno;
                bgPPMViewModel.Project = result.PProject;
                bgPPMViewModel.IsVisible = result.PIsVisible;
                bgPPMViewModel.IsDeleted = result.PIsDeleted;
                bgPPMViewModel.ModifiedOn = result.PModifiedOn;
                bgPPMViewModel.ModifiedBy = result.PModifiedBy;
            }

            return PartialView("_ModalPPMDetail", bgPPMViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsPPM(DTParameters param)
        {
            DTResult<BGPPMMasterDataTableList> result = new();
            int totalRow = 0;

            try
            {
                System.Collections.Generic.IEnumerable<BGPPMMasterDataTableList> data = await _bgPPMMasterDataTableListRepository.BGPPMMasterDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
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

        //[RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, BGHelper.ActionCreateMasters)]
        public async Task<IActionResult> PPMCreate()
        {
            BGPPMCreateViewModel PPMCreateViewModel = new()
            {
                IsVisible = 1
            };

            var bgProjects = await _selectTcmPLRepository.BgProjectListAsync(BaseSpTcmPLGet(), null);
            ViewData["BgProjects"] = new SelectList(bgProjects, "DataValueField", "DataTextField");

            var bgCompanies = await _selectTcmPLRepository.BgCompanyListAsync(BaseSpTcmPLGet(), null);
            ViewData["BgCompanies"] = new SelectList(bgCompanies, "DataValueField", "DataTextField");

            var bgEmployees = await _selectTcmPLRepository.SWPEmployeeList4AdminAsync(BaseSpTcmPLGet(), null);
            ViewData["BgEmployees"] = new SelectList(bgEmployees, "DataValueField", "DataTextField");

            return PartialView("_ModalPPMCreate", PPMCreateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> PPMCreate([FromForm] BGPPMCreateViewModel bgPPMCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _bgPPMMasterRepository.BGPPMMasterCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PEmpno = bgPPMCreateViewModel.Empno,
                            PProjno = bgPPMCreateViewModel.Project,
                            PCompId = bgPPMCreateViewModel.CompId,
                            PIsVisible = bgPPMCreateViewModel.IsVisible
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
            var bgProjects = await _selectTcmPLRepository.BgProjectListAsync(BaseSpTcmPLGet(), null);
            ViewData["BgProjects"] = new SelectList(bgProjects, "DataValueField", "DataTextField", bgPPMCreateViewModel.Project);

            var bgCompanies = await _selectTcmPLRepository.BgCompanyListAsync(BaseSpTcmPLGet(), null);
            ViewData["BgCompanies"] = new SelectList(bgCompanies, "DataValueField", "DataTextField", bgPPMCreateViewModel.CompId);

            var bgEmployees = await _selectTcmPLRepository.SWPEmployeeList4AdminAsync(BaseSpTcmPLGet(), null);
            ViewData["BgEmployees"] = new SelectList(bgEmployees, "DataValueField", "DataTextField", bgPPMCreateViewModel.Empno);

            return PartialView("_ModalPPMCreate", bgPPMCreateViewModel);
        }

        //[RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, BGHelper.ActionCreateMasters)]
        public async Task<IActionResult> PPMUpdate(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            BGPPMMasterDetail result = await _bgPPMMasterDetailRepository.BGPPMMasterDetail(
                         BaseSpTcmPLGet(), new ParameterSpTcmPL { PPpmId = id });

            BGPPMUpdateViewModel bgPPMUpdateViewModel = new();

            if (result.PMessageType == IsOk)
            {
                bgPPMUpdateViewModel.PPMId = id;
                bgPPMUpdateViewModel.CompId = result.PCompId;
                bgPPMUpdateViewModel.Employee = result.PEmployee;
                bgPPMUpdateViewModel.Projno = result.PProjno;
                bgPPMUpdateViewModel.Project = result.PProject;
                bgPPMUpdateViewModel.Empno = result.PEmpno;
                bgPPMUpdateViewModel.IsVisible = result.PIsVisible;
            }

            var bgProjects = await _selectTcmPLRepository.BgProjectListAsync(BaseSpTcmPLGet(), null);
            ViewData["BgProjects"] = new SelectList(bgProjects, "DataValueField", "DataTextField", bgPPMUpdateViewModel.Projno);

            var bgCompanies = await _selectTcmPLRepository.BgCompanyListAsync(BaseSpTcmPLGet(), null);
            ViewData["BgCompanies"] = new SelectList(bgCompanies, "DataValueField", "DataTextField", bgPPMUpdateViewModel.CompId);

            var bgEmployees = await _selectTcmPLRepository.SWPEmployeeList4AdminAsync(BaseSpTcmPLGet(), null);
            ViewData["BgEmployees"] = new SelectList(bgEmployees, "DataValueField", "DataTextField", bgPPMUpdateViewModel.Empno);

            return PartialView("_ModalPPMUpdate", bgPPMUpdateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> PPMUpdate([FromForm] BGPPMUpdateViewModel bgPPMUpdateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _bgPPMMasterRepository.BGPPMMasterEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PPpmId = bgPPMUpdateViewModel.PPMId,
                            PProjno = bgPPMUpdateViewModel.Projno,
                            PEmpno = bgPPMUpdateViewModel.Empno,
                            PCompId = bgPPMUpdateViewModel.CompId,
                            PIsVisible = bgPPMUpdateViewModel.IsVisible
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

            return PartialView("_ModalPPMUpdate", bgPPMUpdateViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> PPMDelete(string id)
        {
            try
            {
                var result = await _bgPPMMasterRepository.BGPPMMasterDeleteAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL { PPpmId = id }
                    );

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        #endregion PPMIndex
    }
}