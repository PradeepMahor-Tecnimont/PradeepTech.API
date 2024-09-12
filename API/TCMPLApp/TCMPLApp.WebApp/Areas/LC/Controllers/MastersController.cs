using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using System;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.Common;
using TCMPLApp.DataAccess.Repositories.LC;
using TCMPLApp.Domain.Models.LC;
using TCMPLApp.WebApp.Classes;
using TCMPLApp.WebApp.Controllers;
using TCMPLApp.WebApp.CustomPolicyProvider;
using TCMPLApp.WebApp.Models;
using static TCMPLApp.WebApp.Classes.DTModel;

namespace TCMPLApp.WebApp.Areas.LC.Controllers
{
    [Authorize]
    [Area("LC")]
    public class MastersController : BaseController
    {
        private const string ConstFilterVendorIndex = "VendorIndex";
        private const string ConstFilterCurrencyIndex = "CurrencyIndex";
        private const string ConstFilterBankIndex = "BankIndex";

        private readonly IVendorDataTableListRepository _vendorDataTableListRepository;
        private readonly ICurrencyDataTableListRepository _currencyDataTableListRepository;
        private readonly IBankDataTableListRepository _bankDataTableListRepository;

        private readonly ISelectTcmPLRepository _selectTcmPLRepository;
        private readonly ILCMastersRepository _lcMastersRepository;

        private readonly IVendorDetailsRepository _vendorDetailsRepository;
        private readonly ICurrencyDetailsRepository _currencyDetailsRepository;
        private readonly IBankDetailsRepository _bankDetailsRepository;

        private readonly IFilterRepository _filterRepository;

        public MastersController(

            ISelectTcmPLRepository selectTcmPLRepository,
            IFilterRepository filterRepository,
            IVendorDataTableListRepository vendorDataTableListRepository,
            ICurrencyDataTableListRepository currencyDataTableListRepository,
            IBankDataTableListRepository bankDataTableListRepository,
            IVendorDetailsRepository vendorDetailsRepository,
            ICurrencyDetailsRepository currencyDetailsRepository,
            IBankDetailsRepository bankDetailsRepository,
            ILCMastersRepository lcMastersRepository

            )
        {
            _selectTcmPLRepository = selectTcmPLRepository;
            _filterRepository = filterRepository;
            _vendorDataTableListRepository = vendorDataTableListRepository;
            _currencyDataTableListRepository = currencyDataTableListRepository;
            _bankDataTableListRepository = bankDataTableListRepository;
            _vendorDetailsRepository = vendorDetailsRepository;
            _currencyDetailsRepository = currencyDetailsRepository;
            _bankDetailsRepository = bankDetailsRepository;
            _lcMastersRepository = lcMastersRepository;
        }

        public IActionResult Index()
        {
            return View();
        }

        public async Task<IActionResult> ResetFilter(string ActionId)
        {
            try
            {
                var result = await _filterRepository.FilterResetAsync(new Domain.Models.FilterReset
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

        #region Bank

        public async Task<IActionResult> BankFilterGet()
        {
            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterBankIndex
            });
            FilterDataModel filterDataModel = new FilterDataModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }
            return PartialView("_ModalBankFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> BankFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                string jsonFilter;

                jsonFilter = JsonConvert.SerializeObject(new { IsActive = filterDataModel.IsActive });

                var retVal = await _filterRepository.FilterCreateAsync(new Domain.Models.FilterCreate
                {
                    PModuleName = CurrentUserIdentity.CurrentModule,
                    PMetaId = CurrentUserIdentity.MetaId,
                    PPersonId = CurrentUserIdentity.EmployeeId,
                    PMvcActionName = ConstFilterBankIndex,
                    PFilterJson = jsonFilter
                });

                return Json(new { success = true, isActive = filterDataModel.IsActive });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, LCHelper.ActionReadMasters)]
        public async Task<IActionResult> BankIndex()
        {
            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterBankIndex
            });
            FilterDataModel filterDataModel = new FilterDataModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            BankViewModel bankViewModel = new BankViewModel();
            bankViewModel.FilterDataModel = filterDataModel;

            return View(bankViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsBank(DTParameters param)
        {
            DTResult<BankDataTableList> result = new DTResult<BankDataTableList>();
            int totalRow = 0;

            try
            {
                var data = await _bankDataTableListRepository.BankDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
                        PIsActive = param.IsActive
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

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, LCHelper.ActionCreateMasters)]
        public IActionResult BankCreate()
        {
            BankCreateViewModel bankCreateViewModel = new BankCreateViewModel();
            bankCreateViewModel.IsActive = 1;
            return PartialView("_ModalBankCreate", bankCreateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, LCHelper.ActionCreateMasters)]
        public async Task<IActionResult> BankCreate([FromForm] BankCreateViewModel bankCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _lcMastersRepository.CreateBankAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PBankDesc = bankCreateViewModel.BankDesc,
                            PIsActive = bankCreateViewModel.IsActive,
                        });

                    if (result.PMessageType != IsOk)
                    {
                        throw new Exception(result.PMessageText.Replace("-", " "));
                    }
                    else
                    {
                        return Json(new { success = true, response = result.PMessageText });
                    }
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            return PartialView("_ModalBankCreate", bankCreateViewModel);
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, LCHelper.ActionCreateMasters)]
        public async Task<IActionResult> BankUpdate(string ApplicationId)
        {
            var result = await _bankDetailsRepository.BankDetailsAsync(
                        BaseSpTcmPLGet(), new ParameterSpTcmPL { PApplicationId = ApplicationId });

            BankUpdateViewModel bankUpdateViewModel = new BankUpdateViewModel()
            {
                BankDesc = result.PBankDesc,
                IsActive = result.PIsActive,
                ApplicationId = ApplicationId
            };
            return PartialView("_ModalBankUpdate", bankUpdateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, LCHelper.ActionCreateMasters)]
        public async Task<IActionResult> BankUpdate([FromForm] BankUpdateViewModel bankUpdateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _lcMastersRepository.UpdateBankAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PApplicationId = bankUpdateViewModel.ApplicationId,
                            PBankDesc = bankUpdateViewModel.BankDesc.Trim(),
                            PIsActive = bankUpdateViewModel.IsActive,
                        });

                    if (result.PMessageType != IsOk)
                    {
                        throw new Exception(result.PMessageText.Replace("-", " "));
                    }
                    else
                    {
                        return Json(new { success = true, response = result.PMessageText });
                    }
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            return PartialView("_ModalBankUpdate", bankUpdateViewModel);
        }

        // Bank

        #endregion Bank

        #region Currency

        public async Task<IActionResult> CurrencyFilterGet()
        {
            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterCurrencyIndex
            });
            FilterDataModel filterDataModel = new FilterDataModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }
            return PartialView("_ModalCurrencyFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> CurrencyFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                string jsonFilter;

                jsonFilter = JsonConvert.SerializeObject(new { IsActive = filterDataModel.IsActive });

                var retVal = await _filterRepository.FilterCreateAsync(new Domain.Models.FilterCreate
                {
                    PModuleName = CurrentUserIdentity.CurrentModule,
                    PMetaId = CurrentUserIdentity.MetaId,
                    PPersonId = CurrentUserIdentity.EmployeeId,
                    PMvcActionName = ConstFilterCurrencyIndex,
                    PFilterJson = jsonFilter
                });

                return Json(new { success = true, isActive = filterDataModel.IsActive });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, LCHelper.ActionReadMasters)]
        public async Task<IActionResult> CurrencyIndex()
        {
            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterCurrencyIndex
            });
            FilterDataModel filterDataModel = new FilterDataModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            CurrencyViewModel currencyViewModel = new CurrencyViewModel();
            currencyViewModel.FilterDataModel = filterDataModel;

            return View(currencyViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsCurrency(DTParameters param)
        {
            DTResult<CurrencyDataTableList> result = new DTResult<CurrencyDataTableList>();
            int totalRow = 0;

            try
            {
                var data = await _currencyDataTableListRepository.CurrencyDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
                        PIsActive = param.IsActive
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

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, LCHelper.ActionCreateMasters)]
        public IActionResult CurrencyCreate()
        {
            CurrencyCreateViewModel currencyCreateViewModel = new CurrencyCreateViewModel();
            currencyCreateViewModel.IsActive = 1;
            return PartialView("_ModalCurrencyCreate", currencyCreateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, LCHelper.ActionCreateMasters)]
        public async Task<IActionResult> CurrencyCreate([FromForm] CurrencyCreateViewModel currencyCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _lcMastersRepository.CreateCurrencyAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PCurrencyCode = currencyCreateViewModel.CurrencyCode,
                            PCurrencyDesc = currencyCreateViewModel.CurrencyDesc,
                            PIsActive = currencyCreateViewModel.IsActive,
                        });

                    if (result.PMessageType != IsOk)
                    {
                        throw new Exception(result.PMessageText.Replace("-", " "));
                    }
                    else
                    {
                        return Json(new { success = true, response = result.PMessageText });
                    }
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            return PartialView("_ModalCurrencyCreate", currencyCreateViewModel);
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, LCHelper.ActionCreateMasters)]
        public async Task<IActionResult> CurrencyUpdate(string ApplicationId)
        {
            var result = await _currencyDetailsRepository.CurrencyDetailsAsync(
                        BaseSpTcmPLGet(), new ParameterSpTcmPL { PApplicationId = ApplicationId });

            CurrencyUpdateViewModel CurrencyUpdateViewModel = new CurrencyUpdateViewModel()
            {
                CurrencyCode = result.PCurrencyCode,
                CurrencyDesc = result.PCurrencyDesc,
                IsActive = result.PIsActive,
                ApplicationId = ApplicationId
            };
            return PartialView("_ModalCurrencyUpdate", CurrencyUpdateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, LCHelper.ActionCreateMasters)]
        public async Task<IActionResult> CurrencyUpdate([FromForm] CurrencyUpdateViewModel currencyUpdateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _lcMastersRepository.UpdateCurrencyAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PApplicationId = currencyUpdateViewModel.ApplicationId,
                            PCurrencyCode = currencyUpdateViewModel.CurrencyCode.Trim(),
                            PCurrencyDesc = currencyUpdateViewModel.CurrencyDesc.Trim(),
                            PIsActive = currencyUpdateViewModel.IsActive,
                        });

                    if (result.PMessageType != IsOk)
                    {
                        throw new Exception(result.PMessageText.Replace("-", " "));
                    }
                    else
                    {
                        return Json(new { success = true, response = result.PMessageText });
                    }
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            return PartialView("_ModalCurrencyUpdate", currencyUpdateViewModel);
        }

        // Currency

        #endregion Currency

        #region Vendor

        public async Task<IActionResult> VendorFilterGet()
        {
            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterVendorIndex
            });
            FilterDataModel filterDataModel = new FilterDataModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }
            return PartialView("_ModalVendorFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> VendorFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                string jsonFilter;

                jsonFilter = JsonConvert.SerializeObject(new { IsActive = filterDataModel.IsActive });

                var retVal = await _filterRepository.FilterCreateAsync(new Domain.Models.FilterCreate
                {
                    PModuleName = CurrentUserIdentity.CurrentModule,
                    PMetaId = CurrentUserIdentity.MetaId,
                    PPersonId = CurrentUserIdentity.EmployeeId,
                    PMvcActionName = ConstFilterVendorIndex,
                    PFilterJson = jsonFilter
                });

                return Json(new { success = true, isActive = filterDataModel.IsActive });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, LCHelper.ActionReadMasters)]
        public async Task<IActionResult> VendorIndex()
        {
            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterVendorIndex
            });
            FilterDataModel filterDataModel = new FilterDataModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            VendorViewModel vendorViewModel = new VendorViewModel();
            vendorViewModel.FilterDataModel = filterDataModel;

            return View(vendorViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsVendor(DTParameters param)
        {
            DTResult<VendorDataTableList> result = new DTResult<VendorDataTableList>();
            int totalRow = 0;

            try
            {
                var data = await _vendorDataTableListRepository.VendorDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
                        PIsActive = param.IsActive
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

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, LCHelper.ActionCreateMasters)]
        public IActionResult VendorCreate()
        {
            VendorCreateViewModel vendorCreateViewModel = new VendorCreateViewModel();
            vendorCreateViewModel.IsActive = 1;
            return PartialView("_ModalVendorCreate", vendorCreateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, LCHelper.ActionCreateMasters)]
        public async Task<IActionResult> VendorCreate([FromForm] VendorCreateViewModel vendorCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _lcMastersRepository.CreateVendorAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PVendorName = vendorCreateViewModel.VendorName,
                            PIsActive = vendorCreateViewModel.IsActive,
                        });

                    if (result.PMessageType != IsOk)
                    {
                        throw new Exception(result.PMessageText.Replace("-", " "));
                    }
                    else
                    {
                        return Json(new { success = true, response = result.PMessageText });
                    }
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            return PartialView("_ModalVendorCreate", vendorCreateViewModel);
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, LCHelper.ActionCreateMasters)]
        public async Task<IActionResult> VendorUpdate(string ApplicationId)
        {
            var result = await _vendorDetailsRepository.VendorDetailsAsync(
                        BaseSpTcmPLGet(), new ParameterSpTcmPL { PApplicationId = ApplicationId });

            VendorUpdateViewModel vendorUpdateViewModel = new VendorUpdateViewModel()
            {
                VendorName = result.PVendorName,
                IsActive = result.PIsActive,
                ApplicationId = ApplicationId
            };
            return PartialView("_ModalVendorUpdate", vendorUpdateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, LCHelper.ActionCreateMasters)]
        public async Task<IActionResult> VendorUpdate([FromForm] VendorUpdateViewModel vendorUpdateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _lcMastersRepository.UpdateVendorAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PApplicationId = vendorUpdateViewModel.ApplicationId,
                            PVendorName = vendorUpdateViewModel.VendorName.Trim(),
                            PIsActive = vendorUpdateViewModel.IsActive,
                        });

                    if (result.PMessageType != IsOk)
                    {
                        throw new Exception(result.PMessageText.Replace("-", " "));
                    }
                    else
                    {
                        return Json(new { success = true, response = result.PMessageText });
                    }
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            return PartialView("_ModalVendorUpdate", vendorUpdateViewModel);
        }

        // Vendor

        #endregion Vendor
    }
}