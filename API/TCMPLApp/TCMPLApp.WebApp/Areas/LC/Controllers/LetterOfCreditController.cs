using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using MimeTypes;
using Newtonsoft.Json;
using System;
using System.Data;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.Attendance;
using TCMPLApp.DataAccess.Repositories.Common;
using TCMPLApp.DataAccess.Repositories.LC;
using TCMPLApp.DataAccess.Repositories.SWPVaccine;
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
    public class LetterOfCreditController : BaseController
    {
        private const string ConstFilterLetterOfCreditIndex = "LetterOfCreditIndex";

        //private const string ConstFilterCurrencyIndex = "CurrencyIndex";
        //private const string ConstFilterBankIndex = "BankIndex";

        private readonly ISelectTcmPLRepository _selectTcmPLRepository;

        private readonly IAttendanceEmployeeDetailsRepository _attendanceEmployeeDetailsRepository;
        private readonly IAfcLcMainDataTableListRepository _afcLcMainDataTableListRepository;
        private readonly IAfcLcMainExcelDataTableListRepository _afcLcMainExcelDataTableListRepository;
        private readonly ILcAmountDataTableListRepository _lcAmountDataTableListRepository;
        private readonly ILcChargesDataTableListRepository _lcChargesDataTableListRepository;
        private readonly ILcMainPoSapInvoiceDataTableListRepository _lcMainPoSapInvoiceDataTableListRepository;
        private readonly ILCRepository _lcRepository;
        private readonly ILcMainDetailsRepository _lcMainDetailsRepository;
        private readonly ILcAcceptanceDetailsRepository _lcAcceptanceDetailsRepository;
        private readonly ILcBankDetailsRepository _lcBankDetailsRepository;
        private readonly ILcChargesDetailsRepository _lcChargesDetailsRepository;
        private readonly ILcAmountDetailsRepository _lcAmountDetailsRepository;
        private readonly ILcLiveStatusDataTableListRepository _lcLiveStatusDataTableListRepository;

        private readonly IUtilityRepository _utilityRepository;

        private readonly IFilterRepository _filterRepository;

        public LetterOfCreditController(

            IAttendanceEmployeeDetailsRepository attendanceEmployeeDetailsRepository,
            IAfcLcMainDataTableListRepository afcLcMainDataTableListRepository,
            IAfcLcMainExcelDataTableListRepository afcLcMainExcelDataTableListRepository,
            ILcAmountDataTableListRepository lcAmountDataTableListRepository,
            ILcChargesDataTableListRepository lcChargesDataTableListRepository,
            ILcMainPoSapInvoiceDataTableListRepository lcMainPoSapInvoiceDataTableListRepository,
            ILcLiveStatusDataTableListRepository lcLiveStatusDataTableListRepository,
            ISelectTcmPLRepository selectTcmPLRepository,
            ILCRepository lcRepository,
            ILcMainDetailsRepository lcMainDetailsRepository,
            ILcAcceptanceDetailsRepository lcAcceptanceDetailsRepository,
            ILcBankDetailsRepository lcBankDetailsRepository,
            ILcChargesDetailsRepository lcChargesDetailsRepository,
            ILcAmountDetailsRepository lcAmountDetailsRepository,
            IFilterRepository filterRepository,
            IUtilityRepository utilityRepository
            )
        {
            _attendanceEmployeeDetailsRepository = attendanceEmployeeDetailsRepository;
            _selectTcmPLRepository = selectTcmPLRepository;
            _afcLcMainDataTableListRepository = afcLcMainDataTableListRepository;
            _afcLcMainExcelDataTableListRepository = afcLcMainExcelDataTableListRepository;
            _lcAmountDataTableListRepository = lcAmountDataTableListRepository;
            _lcMainPoSapInvoiceDataTableListRepository = lcMainPoSapInvoiceDataTableListRepository;
            _lcChargesDataTableListRepository = lcChargesDataTableListRepository;
            _lcRepository = lcRepository;
            _filterRepository = filterRepository;
            _lcMainDetailsRepository = lcMainDetailsRepository;
            _lcAcceptanceDetailsRepository = lcAcceptanceDetailsRepository;
            _lcBankDetailsRepository = lcBankDetailsRepository;
            _lcChargesDetailsRepository = lcChargesDetailsRepository;
            _lcAmountDetailsRepository = lcAmountDetailsRepository;
            _lcLiveStatusDataTableListRepository = lcLiveStatusDataTableListRepository;
            _utilityRepository = utilityRepository;
        }

        public async Task<IActionResult> Index()
        {
            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterLetterOfCreditIndex
            });
            FilterDataModel filterDataModel = new FilterDataModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            LcViewModel letterOfCreditViewModel = new LcViewModel();
            letterOfCreditViewModel.FilterDataModel = filterDataModel;

            return View(letterOfCreditViewModel);
        }

        public async Task<IActionResult> Detail(string ApplicationId)
        {
            if (ApplicationId == null)
                return NotFound();

            var result = await _lcMainDetailsRepository.ILCMainDetailsAsync(
                         BaseSpTcmPLGet(), new ParameterSpTcmPL { PApplicationId = ApplicationId });

            LcMainDetailsViewModel lcMainDetailsViewModel = new LcMainDetailsViewModel();

            if (result.PMessageType == IsOk)
            {
                lcMainDetailsViewModel.ApplicationId = ApplicationId;
                lcMainDetailsViewModel.LcSerialNo = result.PLcSerialNo;
                lcMainDetailsViewModel.CompanyCode = result.PCompanyCode;
                lcMainDetailsViewModel.CompanyShortName = result.PCompanyShortName;
                lcMainDetailsViewModel.CompanyFullName = result.PCompanyFullName;
                lcMainDetailsViewModel.PaymentYyyymm = result.PPaymentYyyymm;
                lcMainDetailsViewModel.PaymentYyyymmHalf = result.PPaymentYyyymmHalfText;
                lcMainDetailsViewModel.Currency = result.PCurrencyCode + " - " + result.PCurrencyDesc;
                lcMainDetailsViewModel.Project = result.PProject;
                lcMainDetailsViewModel.Vendor = result.PVendor;
                lcMainDetailsViewModel.LcAmount = result.PLcAmount;
                lcMainDetailsViewModel.Remarks = result.PRemarks;
                lcMainDetailsViewModel.ModifiedBy = result.PModifiedBy;
                lcMainDetailsViewModel.ModifiedOn = result.PModifiedOn;
                lcMainDetailsViewModel.LcStatusText = result.PLcStatusText;
                lcMainDetailsViewModel.LcStatusVal = int.Parse(result.PLcStatusVal);
                lcMainDetailsViewModel.SendToTreasuryVal = int.Parse(result.PSendToTreasury);
            }

            var data = await _lcMainPoSapInvoiceDataTableListRepository.LcMainPoSapInvoiceDataTableList(
                     BaseSpTcmPLGet(),
                     new ParameterSpTcmPL
                     {
                         PLcKeyId = ApplicationId,
                         PRowNumber = 0,
                         PPageLength = 100
                     });
            lcMainDetailsViewModel.lcMainPoSapInvoiceDataTableList = data.ToList();

            return View(lcMainDetailsViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsLetterOfCredit(DTParameters param)
        {
            DTResult<AfcLcMainDataTableList> result = new DTResult<AfcLcMainDataTableList>();
            int totalRow = 0;
            int? listForUSer = null;

            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.LC.LCHelper.ActionEditLc))
            {
                listForUSer = 1;
            };

            try
            {
                var data = await _afcLcMainDataTableListRepository.AfcLcMainDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
                        PProjno = param.Projno,
                        PCompanyCode = param.CompanyCode,
                        PCurrencyCode = param.Currency,
                        PVendorKeyId = param.Vendor,
                        PSendToTreasury = listForUSer
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
                return Json(new
                {
                    error = ex.Message
                });
            }
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, LCHelper.ActionCreateLc)]
        public async Task<IActionResult> LetterOfCreditMainCreate()
        {
            LcMainCreateViewModel lcCreateViewModel = new LcMainCreateViewModel();

            lcCreateViewModel.SendToTreasury = 0;

            var yymmHalf = _selectTcmPLRepository.GetListYymmHalf();
            ViewData["YymmHalfs"] = new SelectList(yymmHalf, "DataValueField", "DataTextField");

            var project = await _selectTcmPLRepository.ProjectListAsync(BaseSpTcmPLGet(), null);
            ViewData["Projects"] = new SelectList(project, "DataValueField", "DataTextField");

            var banks = await _selectTcmPLRepository.LcBankListAsync(BaseSpTcmPLGet(), null);
            ViewData["Banks"] = new SelectList(banks, "DataValueField", "DataTextField");

            var companies = await _selectTcmPLRepository.LcCompanyListAsync(BaseSpTcmPLGet(), null);
            ViewData["Companies"] = new SelectList(companies, "DataValueField", "DataTextField");

            var vendors = await _selectTcmPLRepository.LcVendorsListAsync(BaseSpTcmPLGet(), null);
            ViewData["Vendors"] = new SelectList(vendors, "DataValueField", "DataTextField");

            var currencies = await _selectTcmPLRepository.LcCurrenciesListAsync(BaseSpTcmPLGet(), null);
            ViewData["Currencies"] = new SelectList(currencies, "DataValueField", "DataTextField");

            return PartialView("_ModalLcMainCreate", lcCreateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, LCHelper.ActionCreateLc)]
        public async Task<IActionResult> LetterOfCreditMainCreate([FromForm] LcMainCreateViewModel lcMainCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    if (lcMainCreateViewModel.PaymentYyyymm.Length == 6)
                    {
                        string yyyymm = lcMainCreateViewModel.PaymentYyyymm;

                        int month = int.Parse(yyyymm.Substring(yyyymm.Length - 2));
                        if (month < 01 || month > 12)
                        {
                            throw new Exception("PaymentYyyymm invalid.");
                        }
                    }
                    else
                    {
                        throw new Exception("PaymentYyyymm invalid.");
                    }
                    if (lcMainCreateViewModel.LcAmount < 0)
                    {
                        throw new Exception("Lc Amount invalid.");
                    }
                    var result = await _lcRepository.CreateLcMainAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PCompanyCode = lcMainCreateViewModel.CompanyCode,
                            PPaymentYyyymm = lcMainCreateViewModel.PaymentYyyymm,
                            PPaymentYyyymmHalf = lcMainCreateViewModel.PaymentYyyymmHalf,
                            PVendorKeyId = lcMainCreateViewModel.Vendor,
                            PProjno = lcMainCreateViewModel.Projno,
                            PCurrencyKeyId = lcMainCreateViewModel.Currency,
                            PLcAmount = lcMainCreateViewModel.LcAmount,
                            PRemarks = lcMainCreateViewModel.Remarks,
                            PSendToTreasury = lcMainCreateViewModel.SendToTreasury
                        });

                    if (result.PMessageType != IsOk)
                    {
                        throw new Exception(result.PMessageText.Replace("-", " "));
                    }
                    else
                    {
                        return Json(new { success = result.PMessageType == IsOk, response = result.PMessageText });
                    }
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            var yymmHalf = _selectTcmPLRepository.GetListYymmHalf();
            ViewData["YymmHalfs"] = new SelectList(yymmHalf, "DataValueField", "DataTextField", lcMainCreateViewModel.PaymentYyyymmHalf);

            var project = await _selectTcmPLRepository.ProjectListAsync(BaseSpTcmPLGet(), null);
            ViewData["Projects"] = new SelectList(project, "DataValueField", "DataTextField", lcMainCreateViewModel.Projno);

            var companies = await _selectTcmPLRepository.LcCompanyListAsync(BaseSpTcmPLGet(), null);
            ViewData["Companies"] = new SelectList(companies, "DataValueField", "DataTextField", lcMainCreateViewModel.CompanyCode);

            var vendors = await _selectTcmPLRepository.LcVendorsListAsync(BaseSpTcmPLGet(), null);
            ViewData["Vendors"] = new SelectList(vendors, "DataValueField", "DataTextField", lcMainCreateViewModel.Vendor);

            var currencies = await _selectTcmPLRepository.LcCurrenciesListAsync(BaseSpTcmPLGet(), null);
            ViewData["Currencies"] = new SelectList(currencies, "DataValueField", "DataTextField", lcMainCreateViewModel.Currency);

            return PartialView("_ModalLcMainCreate", lcMainCreateViewModel);
        }

        public async Task<IActionResult> LcFilterGet()
        {
            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterLetterOfCreditIndex
            });
            FilterDataModel filterDataModel = new FilterDataModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            var project = await _selectTcmPLRepository.ProjectListAsync(BaseSpTcmPLGet(), null);
            ViewData["Projects"] = new SelectList(project, "DataValueField", "DataTextField", filterDataModel.Projno);

            var companies = await _selectTcmPLRepository.LcCompanyListAsync(BaseSpTcmPLGet(), null);
            ViewData["Companies"] = new SelectList(companies, "DataValueField", "DataTextField", filterDataModel.CompanyCode);

            var vendors = await _selectTcmPLRepository.LcVendorsListAsync(BaseSpTcmPLGet(), null);
            ViewData["Vendors"] = new SelectList(vendors, "DataValueField", "DataTextField", filterDataModel.Vendor);

            var currencies = await _selectTcmPLRepository.LcCurrenciesListAsync(BaseSpTcmPLGet(), null);
            ViewData["Currencies"] = new SelectList(currencies, "DataValueField", "DataTextField", filterDataModel.Currency);

            return PartialView("_ModalLcFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> LcFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                string jsonFilter;

                jsonFilter = JsonConvert.SerializeObject(new
                {
                    Vendor = filterDataModel.Vendor,
                    Currency = filterDataModel.Currency,
                    CompanyCode = filterDataModel.CompanyCode,
                    Projno = filterDataModel.Projno
                });

                var retVal = await _filterRepository.FilterCreateAsync(new Domain.Models.FilterCreate
                {
                    PModuleName = CurrentUserIdentity.CurrentModule,
                    PMetaId = CurrentUserIdentity.MetaId,
                    PPersonId = CurrentUserIdentity.EmployeeId,
                    PMvcActionName = ConstFilterLetterOfCreditIndex,
                    PFilterJson = jsonFilter
                });

                return Json(new
                {
                    success = true,
                    Vendor = filterDataModel.Vendor,
                    Currency = filterDataModel.Currency,
                    CompanyCode = filterDataModel.CompanyCode,
                    Projno = filterDataModel.Projno
                });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
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

        #region Details

        public async Task<IActionResult> LcBankingDetail(string id)
        {
            if (id == null)
                return NotFound();

            var lCResult = await _lcMainDetailsRepository.ILCMainDetailsAsync(
                         BaseSpTcmPLGet(), new ParameterSpTcmPL { PApplicationId = id });

            var result = await _lcBankDetailsRepository.ILCBankDetailsAsync(
                      BaseSpTcmPLGet(), new ParameterSpTcmPL { PApplicationId = id });

            LcBankDetailsViewModel lcBankDetailsViewModel = new LcBankDetailsViewModel();

            lcBankDetailsViewModel.ApplicationId = id;

            if (lCResult.PMessageType == IsOk)
            {
                lcBankDetailsViewModel.LcStatusText = lCResult.PLcStatusText;
                lcBankDetailsViewModel.LcStatusVal = int.Parse(lCResult.PLcStatusVal);
                lcBankDetailsViewModel.SendToTreasury = int.Parse(lCResult.PSendToTreasury);
            }

            if (result.PMessageType == IsOk)
            {
                lcBankDetailsViewModel.AdvisingBank = result.PAdvisingBank;
                lcBankDetailsViewModel.DiscountingBank = result.PDiscountingBank;
                lcBankDetailsViewModel.IssuingBank = result.PIssuingBank;

                lcBankDetailsViewModel.AdvisingBankId = result.PAdvisingBankId;
                lcBankDetailsViewModel.DiscountingBankId = result.PDiscountingBankId;
                lcBankDetailsViewModel.IssuingBankId = result.PIssuingBankId;

                lcBankDetailsViewModel.ValidityDate = result.PValidityDate;
                lcBankDetailsViewModel.TenureNoOfDays = result.PNoOfDays;

                lcBankDetailsViewModel.DurationTypeVal = result.PDurationTypeVal;
                lcBankDetailsViewModel.DurationTypeText = result.PDurationTypeText;

                lcBankDetailsViewModel.IssueDate = result.PIssueDate;
                lcBankDetailsViewModel.LCNumber = result.PLcNumber;
                lcBankDetailsViewModel.PaymentDateEst = result.PPaymentDateEst;
                lcBankDetailsViewModel.Remarks = result.PRemarks;
                lcBankDetailsViewModel.CreateEditStatus = 1;
            }
            else
            {
                lcBankDetailsViewModel.CreateEditStatus = 0;
            }

            return PartialView("_LcBankDetailPartial", lcBankDetailsViewModel);
        }

        //For DataTable
        public IActionResult LcChargesList(string id)
        {
            if (id == null)
                return NotFound();

            ViewData["ApplicationId"] = id;

            return PartialView("_LcChargesIndexPartial");
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsLcAmount(DTParameters param)
        {
            DTResult<LcAmountDataTableList> result = new DTResult<LcAmountDataTableList>();
            int totalRow = 0;

            try
            {
                var data = await _lcAmountDataTableListRepository.LcAmountDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PApplicationId = param.ApplicationId,
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

        //For DataTable
        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsLcCharges(DTParameters param)
        {
            DTResult<LcChargesDataTableList> result = new DTResult<LcChargesDataTableList>();
            int totalRow = 0;

            try
            {
                var data = await _lcChargesDataTableListRepository.LcChargesDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PApplicationId = param.ApplicationId,
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

        public async Task<IActionResult> LcAmountDetail(string id)
        {
            if (id == null)
                return NotFound();

            var lCResult = await _lcMainDetailsRepository.ILCMainDetailsAsync(
                      BaseSpTcmPLGet(), new ParameterSpTcmPL { PApplicationId = id });

            LcAmountDetailsViewModel lcAmountDetailsViewModel = new LcAmountDetailsViewModel();

            lcAmountDetailsViewModel.ApplicationId = id;

            if (lCResult.PMessageType == IsOk)
            {
                lcAmountDetailsViewModel.LcStatusVal = int.Parse(lCResult.PLcStatusVal);
                lcAmountDetailsViewModel.LcStatusText = lCResult.PLcStatusText;
                lcAmountDetailsViewModel.SendToTreasury = int.Parse(lCResult.PSendToTreasury);
            }

            var data = await _lcAmountDataTableListRepository.LcAmountDataTableList(
                     BaseSpTcmPLGet(),
                     new ParameterSpTcmPL
                     {
                         PApplicationId = id,
                         PRowNumber = 0,
                         PPageLength = 100
                     });

            lcAmountDetailsViewModel.lcAmountDataTableList = data;

            return PartialView("_LcAmountDetailPartial", lcAmountDetailsViewModel);
        }

        public async Task<IActionResult> LcAcceptanceDetail(string id)
        {
            if (id == null)
                return NotFound();

            var lCResult = await _lcMainDetailsRepository.ILCMainDetailsAsync(
                       BaseSpTcmPLGet(), new ParameterSpTcmPL { PApplicationId = id });

            var result = await _lcAcceptanceDetailsRepository.ILCAcceptanceDetailsAsync(
                        BaseSpTcmPLGet(), new ParameterSpTcmPL { PApplicationId = id });

            LcAcceptanceDetailsViewModel lcAcceptanceDetailsViewModel = new LcAcceptanceDetailsViewModel();

            lcAcceptanceDetailsViewModel.ApplicationId = id;

            if (lCResult.PMessageType == IsOk)
            {
                lcAcceptanceDetailsViewModel.LcClPaymentDate = lCResult.PLcClPaymentDate;
                lcAcceptanceDetailsViewModel.LcClActualAmount = lCResult.PLcClActualAmount;
                lcAcceptanceDetailsViewModel.LcClOtherCharges = lCResult.PLcClOtherCharges;
                lcAcceptanceDetailsViewModel.LcClRemarks = lCResult.PLcClRemarks;
                lcAcceptanceDetailsViewModel.LcClModOn = lCResult.PLcClModOn;
                lcAcceptanceDetailsViewModel.LcClModBy = lCResult.PLcClModBy;
                lcAcceptanceDetailsViewModel.LcStatusVal = int.Parse(lCResult.PLcStatusVal);
                lcAcceptanceDetailsViewModel.LcStatusText = lCResult.PLcStatusText;
                lcAcceptanceDetailsViewModel.SendToTreasury = int.Parse(lCResult.PSendToTreasury);
            }
            if (result.PMessageType == IsOk)
            {
                lcAcceptanceDetailsViewModel.ActualAmountPaid = result.PActualAmountPaid;
                lcAcceptanceDetailsViewModel.Remarks = result.PRemarks;
                lcAcceptanceDetailsViewModel.AcceptanceDate = result.PAcceptanceDate;
                lcAcceptanceDetailsViewModel.PaymentDateAct = result.PPaymentDateAct;

                lcAcceptanceDetailsViewModel.Status = 1;
            }
            else
            {
                lcAcceptanceDetailsViewModel.Status = 0;
            }

            return PartialView("_LcAcceptanceDetailPartial", lcAcceptanceDetailsViewModel);
        }

        public async Task<IActionResult> LcChargesDetail(string id)
        {
            if (id == null)
                return NotFound();

            var lCResult = await _lcMainDetailsRepository.ILCMainDetailsAsync(
                       BaseSpTcmPLGet(), new ParameterSpTcmPL { PApplicationId = id });

            LcChargesDetailsViewModel lcChargesDetailsViewModel = new LcChargesDetailsViewModel();

            if (lCResult.PMessageType == IsOk)
            {
                lcChargesDetailsViewModel.LcStatusVal = int.Parse(lCResult.PLcStatusVal);
                lcChargesDetailsViewModel.LcStatusText = lCResult.PLcStatusText;
                lcChargesDetailsViewModel.SendToTreasury = int.Parse(lCResult.PSendToTreasury);
            }

            lcChargesDetailsViewModel.ApplicationId = id;

            var data = await _lcChargesDataTableListRepository.LcChargesDataTableList(
                     BaseSpTcmPLGet(),
                     new ParameterSpTcmPL
                     {
                         PApplicationId = id,
                         PRowNumber = 0,
                         PPageLength = 100
                     });

            lcChargesDetailsViewModel.lcChargesDataTableList = data;

            return PartialView("_LcChargesDetailPartial", lcChargesDetailsViewModel);
        }

        public async Task<IActionResult> LcLiveStatusDetail(string id)
        {
            if (id == null)
                return NotFound();

            ViewData["ApplicationId"] = id;

            var data = await _lcLiveStatusDataTableListRepository.LcLiveStatusDataTableList(
                     BaseSpTcmPLGet(),
                     new ParameterSpTcmPL
                     {
                         PApplicationId = id,
                         PRowNumber = 0,
                         PPageLength = 100
                     });

            return PartialView("_LcLiveStatusDetailPartial", data);
        }

        #endregion Details

        #region Actions

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, LCHelper.ActionCreateLc)]
        public async Task<IActionResult> LcBeforeMainEdit(string id)
        {
            if (id == null)
                return NotFound();

            var result = await _lcMainDetailsRepository.ILCMainDetailsAsync(
                        BaseSpTcmPLGet(), new ParameterSpTcmPL { PApplicationId = id });

            LcMainEditViewModel lcMainEditViewModel = new LcMainEditViewModel();

            if (result.PMessageType == IsOk)
            {
                lcMainEditViewModel.ApplicationId = id;
                lcMainEditViewModel.LcSerialNo = result.PLcSerialNo;
                lcMainEditViewModel.LcAmount = decimal.Parse(result.PLcAmount);
                lcMainEditViewModel.CompanyCode = result.PCompanyCode;
                lcMainEditViewModel.PaymentYyyymm = result.PPaymentYyyymm;
                lcMainEditViewModel.PaymentYyyymmHalf = int.Parse(result.PPaymentYyyymmHalfVal);
                lcMainEditViewModel.Currency = result.PCurrencyKeyId;
                lcMainEditViewModel.Projno = result.PProjno;
                lcMainEditViewModel.Remarks = result.PRemarks;
                lcMainEditViewModel.Vendor = result.PVendorKeyId;
                lcMainEditViewModel.SendToTreasury = int.Parse(result.PSendToTreasury);
            }

            var yymmHalf = _selectTcmPLRepository.GetListYymmHalf();
            ViewData["YymmHalfs"] = new SelectList(yymmHalf, "DataValueField", "DataTextField", lcMainEditViewModel.PaymentYyyymmHalf);

            var project = await _selectTcmPLRepository.ProjectListAsync(BaseSpTcmPLGet(), null);
            ViewData["Projects"] = new SelectList(project, "DataValueField", "DataTextField", lcMainEditViewModel.Projno);

            var companies = await _selectTcmPLRepository.LcCompanyListAsync(BaseSpTcmPLGet(), null);
            ViewData["Companies"] = new SelectList(companies, "DataValueField", "DataTextField", lcMainEditViewModel.CompanyCode);

            var vendors = await _selectTcmPLRepository.LcVendorsListAsync(BaseSpTcmPLGet(), null);
            ViewData["Vendors"] = new SelectList(vendors, "DataValueField", "DataTextField", lcMainEditViewModel.Vendor);

            var currencies = await _selectTcmPLRepository.LcCurrenciesListAsync(BaseSpTcmPLGet(), null);
            ViewData["Currencies"] = new SelectList(currencies, "DataValueField", "DataTextField", lcMainEditViewModel.Currency);

            return PartialView("_ModalLcMainEdit", lcMainEditViewModel);
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, LCHelper.ActionEditLc)]
        public async Task<IActionResult> LcAfterMainEdit(string id)
        {
            if (id == null)
                return NotFound();

            var result = await _lcMainDetailsRepository.ILCMainDetailsAsync(
                        BaseSpTcmPLGet(), new ParameterSpTcmPL { PApplicationId = id });

            LcMainEditViewModel lcMainEditViewModel = new LcMainEditViewModel();

            if (result.PMessageType == IsOk)
            {
                lcMainEditViewModel.ApplicationId = id;
                lcMainEditViewModel.LcSerialNo = result.PLcSerialNo;
                lcMainEditViewModel.LcAmount = decimal.Parse(result.PLcAmount);
                lcMainEditViewModel.CompanyCode = result.PCompanyCode;
                lcMainEditViewModel.PaymentYyyymm = result.PPaymentYyyymm;
                lcMainEditViewModel.PaymentYyyymmHalf = int.Parse(result.PPaymentYyyymmHalfVal);
                lcMainEditViewModel.Currency = result.PCurrencyKeyId;
                lcMainEditViewModel.Projno = result.PProjno;
                lcMainEditViewModel.Remarks = result.PRemarks;
                lcMainEditViewModel.Vendor = result.PVendorKeyId;
                lcMainEditViewModel.SendToTreasury = int.Parse(result.PSendToTreasury);
            }

            var yymmHalf = _selectTcmPLRepository.GetListYymmHalf();
            ViewData["YymmHalfs"] = new SelectList(yymmHalf, "DataValueField", "DataTextField", lcMainEditViewModel.PaymentYyyymmHalf);

            var project = await _selectTcmPLRepository.ProjectListAsync(BaseSpTcmPLGet(), null);
            ViewData["Projects"] = new SelectList(project, "DataValueField", "DataTextField", lcMainEditViewModel.Projno);

            var companies = await _selectTcmPLRepository.LcCompanyListAsync(BaseSpTcmPLGet(), null);
            ViewData["Companies"] = new SelectList(companies, "DataValueField", "DataTextField", lcMainEditViewModel.CompanyCode);

            var vendors = await _selectTcmPLRepository.LcVendorsListAsync(BaseSpTcmPLGet(), null);
            ViewData["Vendors"] = new SelectList(vendors, "DataValueField", "DataTextField", lcMainEditViewModel.Vendor);

            var currencies = await _selectTcmPLRepository.LcCurrenciesListAsync(BaseSpTcmPLGet(), null);
            ViewData["Currencies"] = new SelectList(currencies, "DataValueField", "DataTextField", lcMainEditViewModel.Currency);

            return PartialView("_ModalLcMainEdit", lcMainEditViewModel);
        }

        //[HttpPost]
        //[RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, LCHelper.ActionEditLc)]
        //public async Task<IActionResult> LcAfterMainEdit([FromForm] LcMainEditViewModel letterOfCreditEditViewModel)
        //{
        //    try
        //    {
        //        if (ModelState.IsValid)
        //        {
        //            if (letterOfCreditEditViewModel.PaymentYyyymm.Length == 6)
        //            {
        //                string yyyymm = letterOfCreditEditViewModel.PaymentYyyymm;

        // int month = int.Parse(yyyymm.Substring(yyyymm.Length - 2)); if (month < 01 || month > 12)
        // { throw new Exception("PaymentYyyymm invalid."); } } else { throw new
        // Exception("PaymentYyyymm invalid."); } if (letterOfCreditEditViewModel.LcAmount < 0) {
        // throw new Exception("Lc Amount invalid."); } var result = await
        // _lcRepository.UpdateLcMainAsync( BaseSpTcmPLGet(), new ParameterSpTcmPL { PApplicationId
        // = letterOfCreditEditViewModel.ApplicationId,

        // PCompanyCode = letterOfCreditEditViewModel.CompanyCode, PPaymentYyyymm =
        // letterOfCreditEditViewModel.PaymentYyyymm.ToString(), PPaymentYyyymmHalf =
        // letterOfCreditEditViewModel.PaymentYyyymmHalf, PVendorKeyId =
        // letterOfCreditEditViewModel.Vendor, PProjno = letterOfCreditEditViewModel.Projno,
        // PCurrencyKeyId = letterOfCreditEditViewModel.Currency, PLcAmount =
        // letterOfCreditEditViewModel.LcAmount, PRemarks = letterOfCreditEditViewModel.Remarks,
        // PSendToTreasury = letterOfCreditEditViewModel.SendToTreasury });

        // if (result.PMessageType != Success) { throw new
        // Exception(result.PMessageText.Replace("-", " ")); } else { return Json(new { success =
        // result.PMessageType == Success, response = result.PMessageText }); } } } catch (Exception
        // ex) { return StatusCode((int)HttpStatusCode.InternalServerError,
        // StringHelper.CleanExceptionMessage(ex.Message)); }

        //    return RedirectToAction("Details", new { ApplicationId = letterOfCreditEditViewModel.ApplicationId });
        //}

        [HttpPost]
        public async Task<IActionResult> LcMainEdit([FromForm] LcMainEditViewModel letterOfCreditEditViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    if (letterOfCreditEditViewModel.PaymentYyyymm.Length == 6)
                    {
                        string yyyymm = letterOfCreditEditViewModel.PaymentYyyymm;

                        int month = int.Parse(yyyymm.Substring(yyyymm.Length - 2));
                        if (month < 01 || month > 12)
                        {
                            throw new Exception("PaymentYyyymm invalid.");
                        }
                    }
                    else
                    {
                        throw new Exception("PaymentYyyymm invalid.");
                    }
                    if (letterOfCreditEditViewModel.LcAmount < 0)
                    {
                        throw new Exception("Lc Amount invalid.");
                    }
                    var result = await _lcRepository.UpdateLcMainAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PApplicationId = letterOfCreditEditViewModel.ApplicationId,

                            PCompanyCode = letterOfCreditEditViewModel.CompanyCode,
                            PPaymentYyyymm = letterOfCreditEditViewModel.PaymentYyyymm.ToString(),
                            PPaymentYyyymmHalf = letterOfCreditEditViewModel.PaymentYyyymmHalf,
                            PVendorKeyId = letterOfCreditEditViewModel.Vendor,
                            PProjno = letterOfCreditEditViewModel.Projno,
                            PCurrencyKeyId = letterOfCreditEditViewModel.Currency,
                            PLcAmount = letterOfCreditEditViewModel.LcAmount,
                            PRemarks = letterOfCreditEditViewModel.Remarks,
                            PSendToTreasury = letterOfCreditEditViewModel.SendToTreasury
                        });

                    if (result.PMessageType != IsOk)
                    {
                        throw new Exception(result.PMessageText.Replace("-", " "));
                    }
                    else
                    {
                        return Json(new { success = result.PMessageType == IsOk, response = result.PMessageText });
                    }
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            return RedirectToAction("Details", new { ApplicationId = letterOfCreditEditViewModel.ApplicationId });
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, LCHelper.ActionEditLc)]
        public async Task<IActionResult> LcBankingCreate(string id)
        {
            if (id == null)
                return NotFound();

            LcBankCreateViewModel lcBankCreateViewModel = new LcBankCreateViewModel();

            lcBankCreateViewModel.ValidityDate = null;

            lcBankCreateViewModel.ApplicationId = id;

            var durationType = _selectTcmPLRepository.GetListLcDurationType();
            ViewData["DurationType"] = new SelectList(durationType, "DataValueField", "DataTextField");

            var advisingBanks = await _selectTcmPLRepository.LcBankListAsync(BaseSpTcmPLGet(), null);
            ViewData["AdvisingBanks"] = new SelectList(advisingBanks, "DataValueField", "DataTextField");

            var discountingBanks = await _selectTcmPLRepository.LcBankListAsync(BaseSpTcmPLGet(), null);
            ViewData["DiscountingBanks"] = new SelectList(discountingBanks, "DataValueField", "DataTextField");

            var issuingBanks = await _selectTcmPLRepository.LcBankListAsync(BaseSpTcmPLGet(), null);
            ViewData["IssuingBanks"] = new SelectList(issuingBanks, "DataValueField", "DataTextField");

            return PartialView("_ModalLcBankCreate", lcBankCreateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, LCHelper.ActionEditLc)]
        public async Task<IActionResult> LcBankingCreate([FromForm] LcBankCreateViewModel lcBankCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    if (lcBankCreateViewModel.IssueDate >= lcBankCreateViewModel.ValidityDate)
                    {
                        throw new Exception("Validity date invalid.Validity date must be grater then Issue date");
                    }

                    lcBankCreateViewModel.PaymentDateEst = lcBankCreateViewModel.IssueDate.Value.AddDays((int)lcBankCreateViewModel.TenureNoOfDays);

                    var result = await _lcRepository.CreateLcBanksAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PApplicationId = lcBankCreateViewModel.ApplicationId,
                            PIssuingBank = lcBankCreateViewModel.IssuingBank,
                            PDiscountingBank = lcBankCreateViewModel.DiscountingBank,
                            PAdvisingBank = lcBankCreateViewModel.AdvisingBank,
                            PValidityDate = lcBankCreateViewModel.ValidityDate,
                            PIssueDate = lcBankCreateViewModel.IssueDate,
                            PLcNumber = lcBankCreateViewModel.LCNumber,
                            PDurationType = lcBankCreateViewModel.DurationType,
                            PPaymentDateEst = lcBankCreateViewModel.PaymentDateEst,
                            PRemarks = lcBankCreateViewModel.Remarks,
                            PNoOfDays = lcBankCreateViewModel.TenureNoOfDays
                        });

                    if (result.PMessageType != IsOk)
                    {
                        throw new Exception(result.PMessageText.Replace("-", " "));
                    }
                    else
                    {
                        return Json(new { success = result.PMessageType == IsOk, response = result.PMessageText });
                    }
                }
                return RedirectToAction("BankingDetail", new { ApplicationId = lcBankCreateViewModel.ApplicationId });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, LCHelper.ActionEditLc)]
        public async Task<IActionResult> LcBankingEdit(string id)
        {
            if (id == null)
                return NotFound();

            var result = await _lcBankDetailsRepository.ILCBankDetailsAsync(
                        BaseSpTcmPLGet(), new ParameterSpTcmPL { PApplicationId = id });

            LcBankEditViewModel lcBankEditViewModel = new LcBankEditViewModel();

            lcBankEditViewModel.ApplicationId = id;

            if (result.PMessageType == IsOk)
            {
                lcBankEditViewModel.AdvisingBank = result.PAdvisingBankId;
                lcBankEditViewModel.DiscountingBank = result.PDiscountingBankId;
                lcBankEditViewModel.IssuingBank = result.PIssuingBankId;

                if (!string.IsNullOrEmpty(result.PLcNumber))
                {
                    lcBankEditViewModel.LCNumber = int.Parse(result.PLcNumber);
                }
                lcBankEditViewModel.ValidityDate = DateTime.Parse(result.PValidityDate);
                lcBankEditViewModel.TenureNoOfDays = int.Parse(result.PNoOfDays);
                lcBankEditViewModel.DurationType = result.PDurationTypeVal;
                lcBankEditViewModel.Remarks = result.PRemarks;

                if (!string.IsNullOrEmpty(result.PIssueDate))
                {
                    lcBankEditViewModel.IssueDate = DateTime.Parse(result.PIssueDate);
                }
            }

            var durationType = _selectTcmPLRepository.GetListLcDurationType();
            ViewData["DurationType"] = new SelectList(durationType, "DataValueField", "DataTextField", lcBankEditViewModel.DurationType);

            var advisingBanks = await _selectTcmPLRepository.LcBankListAsync(BaseSpTcmPLGet(), null);
            ViewData["AdvisingBanks"] = new SelectList(advisingBanks, "DataValueField", "DataTextField", lcBankEditViewModel.AdvisingBank);

            var discountingBanks = await _selectTcmPLRepository.LcBankListAsync(BaseSpTcmPLGet(), null);
            ViewData["DiscountingBanks"] = new SelectList(discountingBanks, "DataValueField", "DataTextField", lcBankEditViewModel.DiscountingBank);

            var issuingBanks = await _selectTcmPLRepository.LcBankListAsync(BaseSpTcmPLGet(), null);
            ViewData["IssuingBanks"] = new SelectList(issuingBanks, "DataValueField", "DataTextField", lcBankEditViewModel.IssuingBank);

            return PartialView("_ModalLcBankEdit", lcBankEditViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, LCHelper.ActionEditLc)]
        public async Task<IActionResult> LcBankingEdit([FromForm] LcBankEditViewModel lcBankEditViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    if (lcBankEditViewModel.IssueDate >= lcBankEditViewModel.ValidityDate)
                    {
                        throw new Exception("Validity date invalid.Validity date must be grater then Issue date");
                    }
                    lcBankEditViewModel.PaymentDateEst = lcBankEditViewModel.IssueDate.Value.AddDays((int)lcBankEditViewModel.TenureNoOfDays);

                    var result = await _lcRepository.UpdateLcBanksAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PApplicationId = lcBankEditViewModel.ApplicationId,
                            PIssuingBank = lcBankEditViewModel.IssuingBank,
                            PDiscountingBank = lcBankEditViewModel.DiscountingBank,
                            PAdvisingBank = lcBankEditViewModel.AdvisingBank,
                            PValidityDate = lcBankEditViewModel.ValidityDate,
                            PIssueDate = lcBankEditViewModel.IssueDate,
                            PLcNumber = lcBankEditViewModel.LCNumber,
                            PDurationType = lcBankEditViewModel.DurationType,
                            PNoOfDays = lcBankEditViewModel.TenureNoOfDays,
                            PPaymentDateEst = lcBankEditViewModel.PaymentDateEst,
                            PRemarks = lcBankEditViewModel.Remarks
                        });

                    if (result.PMessageType != IsOk)
                    {
                        throw new Exception(result.PMessageText.Replace("-", " "));
                    }
                    else
                    {
                        return Json(new { success = result.PMessageType == IsOk, response = result.PMessageText });
                    }
                }
                return RedirectToAction("BankingDetail", new { ApplicationId = lcBankEditViewModel.ApplicationId });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, LCHelper.ActionEditLc)]
        public IActionResult LcAcceptanceCreate(string id)
        {
            if (id == null)
                return NotFound();

            LcAcceptanceCreateViewModel lcAcceptanceCreateViewModel = new LcAcceptanceCreateViewModel();

            lcAcceptanceCreateViewModel.ApplicationId = id;
            lcAcceptanceCreateViewModel.AcceptanceDate = null;
            lcAcceptanceCreateViewModel.PaymentDateAct = null;
            return PartialView("_ModalLcAcceptanceCreate", lcAcceptanceCreateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, LCHelper.ActionEditLc)]
        public async Task<IActionResult> LcAcceptanceCreate([FromForm] LcAcceptanceCreateViewModel lcAcceptanceCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    if (lcAcceptanceCreateViewModel.AcceptanceDate >= lcAcceptanceCreateViewModel.PaymentDateAct)
                    {
                        throw new Exception("Date invalid. LC payment due date (per acceptance) must be grater then AcceptanceDate");
                    }

                    var result = await _lcRepository.CreateLcAcceptanceAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PApplicationId = lcAcceptanceCreateViewModel.ApplicationId,
                            PAcceptanceDate = lcAcceptanceCreateViewModel.AcceptanceDate,
                            PRemarks = lcAcceptanceCreateViewModel.Remarks,
                            PPaymentDateAct = lcAcceptanceCreateViewModel.PaymentDateAct,
                            PActualAmountPaid = lcAcceptanceCreateViewModel.ActualAmountPaid
                        });

                    if (result.PMessageType != IsOk)
                    {
                        throw new Exception(result.PMessageText.Replace("-", " "));
                    }
                    else
                    {
                        return Json(new { success = result.PMessageType == IsOk, response = result.PMessageText });
                    }
                }
                return RedirectToAction("LcAcceptanceDetail", new { ApplicationId = lcAcceptanceCreateViewModel.ApplicationId });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, LCHelper.ActionEditLc)]
        public async Task<IActionResult> LcAcceptanceEdit(string id)
        {
            if (id == null)
                return NotFound();

            var result = await _lcAcceptanceDetailsRepository.ILCAcceptanceDetailsAsync(
                        BaseSpTcmPLGet(), new ParameterSpTcmPL { PApplicationId = id });

            LcAcceptanceEditViewModel lcAcceptanceEditViewModel = new LcAcceptanceEditViewModel();

            lcAcceptanceEditViewModel.ApplicationId = id;

            if (result.PMessageType == IsOk)
            {
                lcAcceptanceEditViewModel.ActualAmountPaid = decimal.Parse(result.PActualAmountPaid);
                lcAcceptanceEditViewModel.PaymentDateAct = DateTime.Parse(result.PPaymentDateAct);

                lcAcceptanceEditViewModel.Remarks = result.PRemarks;

                lcAcceptanceEditViewModel.AcceptanceDate = DateTime.Parse(result.PAcceptanceDate);
            }

            return PartialView("_ModalLcAcceptanceEdit", lcAcceptanceEditViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> LcAcceptanceEdit([FromForm] LcAcceptanceEditViewModel lcAcceptanceEditViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    if (lcAcceptanceEditViewModel.AcceptanceDate >= lcAcceptanceEditViewModel.PaymentDateAct)
                    {
                        throw new Exception("Date invalid. LC payment due date (per acceptance) must be grater then AcceptanceDate");
                    }
                    var result = await _lcRepository.UpdateLcAcceptanceAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PApplicationId = lcAcceptanceEditViewModel.ApplicationId,
                            PAcceptanceDate = lcAcceptanceEditViewModel.AcceptanceDate,
                            PRemarks = lcAcceptanceEditViewModel.Remarks,
                            PPaymentDateAct = lcAcceptanceEditViewModel.PaymentDateAct,
                            PActualAmountPaid = lcAcceptanceEditViewModel.ActualAmountPaid
                        });

                    if (result.PMessageType != IsOk)
                    {
                        throw new Exception(result.PMessageText.Replace("-", " "));
                    }
                    else
                    {
                        return Json(new { success = result.PMessageType == IsOk, response = result.PMessageText });
                    }
                }
                return RedirectToAction("AcceptanceDetail", new { ApplicationId = lcAcceptanceEditViewModel.ApplicationId });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, LCHelper.ActionEditLc)]
        public async Task<IActionResult> LcClosureEdit(string id)
        {
            if (id == null)
                return NotFound();

            var lCResult = await _lcMainDetailsRepository.ILCMainDetailsAsync(
                        BaseSpTcmPLGet(), new ParameterSpTcmPL { PApplicationId = id });

            LcMainCloseEditViewModel lcMainCloseEditViewModel = new LcMainCloseEditViewModel();

            lcMainCloseEditViewModel.ApplicationId = id;

            if (lCResult.PMessageType == IsOk)
            {
                lcMainCloseEditViewModel.IsActive = decimal.Parse(lCResult.PLcStatusVal);

                if (lCResult.PLcClActualAmount != null)
                {
                    lcMainCloseEditViewModel.LcClActualAmount = decimal.Parse(lCResult.PLcClActualAmount);
                }
                if (lCResult.PLcClOtherCharges != null)
                {
                    lcMainCloseEditViewModel.LcClOtherCharges = decimal.Parse(lCResult.PLcClOtherCharges);
                }
                if (lCResult.PLcClPaymentDate != null)
                {
                    lcMainCloseEditViewModel.LcClPaymentDate = DateTime.Parse(lCResult.PLcClPaymentDate);
                }

                lcMainCloseEditViewModel.LcClRemarks = lCResult.PLcClRemarks;
            }

            return PartialView("_ModalLcMainCloseEdit", lcMainCloseEditViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, LCHelper.ActionEditLc)]
        public async Task<IActionResult> LcClosureEdit([FromForm] LcMainCloseEditViewModel lcMainCloseEditViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _lcRepository.UpdateLcCloseAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PApplicationId = lcMainCloseEditViewModel.ApplicationId,

                            PLcClPaymentDate = lcMainCloseEditViewModel.LcClPaymentDate,
                            PLcClOtherCharges = lcMainCloseEditViewModel.LcClOtherCharges,
                            PLcClActualAmount = lcMainCloseEditViewModel.LcClActualAmount,
                            PRemarks = lcMainCloseEditViewModel.LcClRemarks,
                            PIsActive = lcMainCloseEditViewModel.IsActive
                        });

                    if (result.PMessageType != IsOk)
                    {
                        throw new Exception(result.PMessageText.Replace("-", " "));
                    }
                    else
                    {
                        return Json(new { success = result.PMessageType == IsOk, response = result.PMessageText });
                    }
                }
                return RedirectToAction("AcceptanceDetail", new { ApplicationId = lcMainCloseEditViewModel.ApplicationId });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, LCHelper.ActionCreateLc)]
        public async Task<IActionResult> LcBeforePoSapInvoiceCreate(string id)
        {
            if (id == null)
                return NotFound();

            LcPoSapInvoiceCreateViewModel lcPoSapInvoiceCreateViewModel = new LcPoSapInvoiceCreateViewModel();

            lcPoSapInvoiceCreateViewModel.LcKeyId = id;

            var chargesStatus = await _selectTcmPLRepository.LcChargesStatusListAsync(BaseSpTcmPLGet(), null);

            ViewData["ChargesStatus"] = new SelectList(chargesStatus, "DataValueField", "DataTextField");

            return PartialView("_ModalLcPoSapInvoiceCreate", lcPoSapInvoiceCreateViewModel);
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, LCHelper.ActionEditLc)]
        public async Task<IActionResult> LcAftrePoSapInvoiceCreate(string id)
        {
            if (id == null)
                return NotFound();

            LcPoSapInvoiceCreateViewModel lcPoSapInvoiceCreateViewModel = new LcPoSapInvoiceCreateViewModel();

            lcPoSapInvoiceCreateViewModel.LcKeyId = id;

            var chargesStatus = await _selectTcmPLRepository.LcChargesStatusListAsync(BaseSpTcmPLGet(), null);

            ViewData["ChargesStatus"] = new SelectList(chargesStatus, "DataValueField", "DataTextField");

            return PartialView("_ModalLcPoSapInvoiceCreate", lcPoSapInvoiceCreateViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> LcPoSapInvoiceCreate([FromForm] LcPoSapInvoiceCreateViewModel lcPoSapInvoiceCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _lcRepository.CreateLcMainPoSapInvoiceAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PLcKeyId = lcPoSapInvoiceCreateViewModel.LcKeyId,
                            PPo = lcPoSapInvoiceCreateViewModel.Po,
                            PSap = lcPoSapInvoiceCreateViewModel.Sap,
                            PInvoice = lcPoSapInvoiceCreateViewModel.Invoice
                        });

                    if (result.PMessageType != IsOk)
                    {
                        throw new Exception(result.PMessageText.Replace("-", " "));
                    }
                    else
                    {
                        return Json(new { success = result.PMessageType == IsOk, response = result.PMessageText });
                    }
                }
                return RedirectToAction("Detail", new { ApplicationId = lcPoSapInvoiceCreateViewModel.LcKeyId });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, LCHelper.ActionCreateLc)]
        public async Task<IActionResult> LcBeforePoSapInvoiceDelete(string ApplicationId)
        {
            try
            {
                var result = await _lcRepository.DeleteLcMainPoSapInvoiceAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL { PApplicationId = ApplicationId }
                    );

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                //return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));

                return Json(new { success = false, response = ex.Message });
            }
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, LCHelper.ActionEditLc)]
        public async Task<IActionResult> LcAftrePoSapInvoiceDelete(string ApplicationId)
        {
            try
            {
                var result = await _lcRepository.DeleteLcMainPoSapInvoiceAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL { PApplicationId = ApplicationId }
                    );

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                //return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));

                return Json(new { success = false, response = ex.Message });
            }
        }

        //[HttpPost]
        //[RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, LCHelper.ActionEditLc)]
        //public async Task<IActionResult> LcPoSapInvoiceCreate([FromForm] LcPoSapInvoiceCreateViewModel lcPoSapInvoiceCreateViewModel)
        //{
        //    try
        //    {
        //        if (ModelState.IsValid)
        //        {
        //            var result = await _lcRepository.CreateLcMainPoSapInvoiceAsync(
        //                BaseSpTcmPLGet(),
        //                new ParameterSpTcmPL
        //                {
        //                    PLcKeyId = lcPoSapInvoiceCreateViewModel.LcKeyId,
        //                    PPo = lcPoSapInvoiceCreateViewModel.Po,
        //                    PSap = lcPoSapInvoiceCreateViewModel.Sap,
        //                    PInvoice = lcPoSapInvoiceCreateViewModel.Invoice
        //                });

        //    return PartialView("_ModalLcPoSapInvoiceCreatePartial", lcPoSapInvoiceCreateViewModel);
        //}

        //[HttpPost]
        //[RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, LCHelper.ActionEditLc)]
        //public async Task<IActionResult> LcPoSapInvoiceDelete(string ApplicationId)
        //{
        //    try
        //    {
        //        var result = await _lcRepository.DeleteLcMainPoSapInvoiceAsync(
        //            BaseSpTcmPLGet(),
        //            new ParameterSpTcmPL { PApplicationId = ApplicationId }
        //            );

        // return Json(new { success = result.PMessageType == "OK", response = result.PMessageText
        // }); } catch (Exception ex) { //return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
        //        return Json(new { success = false, response = ex.Message });
        //    }
        //}

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, LCHelper.ActionEditLc)]
        public async Task<IActionResult> LcChargesCreate(string id)
        {
            if (id == null)
                return NotFound();

            LcChargesCreateViewModel lcChargesCreateViewModel = new LcChargesCreateViewModel();

            lcChargesCreateViewModel.ApplicationId = id;

            var chargesStatus = await _selectTcmPLRepository.LcChargesStatusListAsync(BaseSpTcmPLGet(), null);

            ViewData["ChargesStatus"] = new SelectList(chargesStatus, "DataValueField", "DataTextField");

            return PartialView("_ModalLcChargesCreate", lcChargesCreateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, LCHelper.ActionEditLc)]
        public async Task<IActionResult> LcChargesCreate([FromForm] LcChargesCreateViewModel lcChargesCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    string serverFileName = "";
                    string ClintFileName = "";
                    var selfDetail = await _attendanceEmployeeDetailsRepository.AttendanceEmployeeDetailsAsync(BaseSpTcmPLGet(), null);

                    if (lcChargesCreateViewModel.file != null)
                    {
                        ClintFileName = lcChargesCreateViewModel.file.FileName;
                        serverFileName = await StorageHelper.SaveFileAsync(StorageHelper.LC.RepositoryLc, selfDetail.Empno, StorageHelper.LC.GroupLc, lcChargesCreateViewModel.file, Configuration);
                    }

                    var result = await _lcRepository.CreateLcChargesAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PApplicationId = lcChargesCreateViewModel.ApplicationId,
                            PBasicCharges = lcChargesCreateViewModel.BasicCharges,
                            POtherCharges = lcChargesCreateViewModel.OtherCharges,
                            PTax = lcChargesCreateViewModel.Tax,
                            PLcChargesStatus = lcChargesCreateViewModel.LcChargesStatus,
                            PCommissionRate = lcChargesCreateViewModel.CommissionRate,
                            PDays = lcChargesCreateViewModel.Days,
                            PClintFileName = ClintFileName,
                            PServerFileName = serverFileName,
                            PRemarks = lcChargesCreateViewModel.Remarks
                        });

                    if (result.PMessageType != IsOk)
                    {
                        throw new Exception(result.PMessageText.Replace("-", " "));
                    }
                    else
                    {
                        return Json(new { success = result.PMessageType == IsOk, response = result.PMessageText });
                    }
                }
                return RedirectToAction("LcChargesDetail", new { ApplicationId = lcChargesCreateViewModel.ApplicationId });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, LCHelper.ActionEditLc)]
        public async Task<IActionResult> LcChargesEdit(string id)
        {
            if (id == null)
                return NotFound();

            var result = await _lcChargesDetailsRepository.ILCChargesDetailsAsync(
                        BaseSpTcmPLGet(), new ParameterSpTcmPL { PApplicationId = id });

            LcChargesEditViewModel lcChargesEditViewModel = new LcChargesEditViewModel();

            lcChargesEditViewModel.ApplicationId = id;

            if (result.PMessageType == IsOk)
            {
                lcChargesEditViewModel.LcKeyId = result.PLcKeyId;
                lcChargesEditViewModel.BasicCharges = decimal.Parse(result.PBasicCharges);
                lcChargesEditViewModel.OtherCharges = decimal.Parse(result.POtherCharges);

                lcChargesEditViewModel.Tax = decimal.Parse(result.PTax);
                lcChargesEditViewModel.CommissionRate = decimal.Parse(result.PCommissionRate);
                lcChargesEditViewModel.Days = int.Parse(result.PDays);
                lcChargesEditViewModel.LcChargesStatus = result.PLcChargesStatusVal;

                lcChargesEditViewModel.ClintFileName = result.PClintFileName;
                lcChargesEditViewModel.ServerFileName = result.PServerFileName;
                lcChargesEditViewModel.Remarks = result.PRemarks;
            }

            var chargesStatus = await _selectTcmPLRepository.LcChargesStatusListAsync(BaseSpTcmPLGet(), null);

            ViewData["ChargesStatus"] = new SelectList(chargesStatus, "DataValueField", "DataTextField", lcChargesEditViewModel.LcChargesStatus);

            return PartialView("_ModalLcChargesEdit", lcChargesEditViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, LCHelper.ActionEditLc)]
        public async Task<IActionResult> LcChargesEdit([FromForm] LcChargesEditViewModel lcChargesEditViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    string serverFileName = "";
                    string ClintFileName = "";
                    var selfDetail = await _attendanceEmployeeDetailsRepository.AttendanceEmployeeDetailsAsync(BaseSpTcmPLGet(), null);

                    if (!string.IsNullOrEmpty(lcChargesEditViewModel.ServerFileName))
                    {
                        StorageHelper.DeleteFile(StorageHelper.LC.RepositoryLc, lcChargesEditViewModel.ServerFileName, Configuration);
                    }

                    if (lcChargesEditViewModel.file != null)
                    {
                        ClintFileName = lcChargesEditViewModel.file.FileName;
                        serverFileName = await StorageHelper.SaveFileAsync(StorageHelper.LC.RepositoryLc, selfDetail.Empno, StorageHelper.LC.GroupLc, lcChargesEditViewModel.file, Configuration);
                    }

                    var result = await _lcRepository.UpdateLcChargesAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PApplicationId = lcChargesEditViewModel.ApplicationId,
                            PBasicCharges = lcChargesEditViewModel.BasicCharges,
                            POtherCharges = lcChargesEditViewModel.OtherCharges,
                            PTax = lcChargesEditViewModel.Tax,
                            PLcChargesStatus = lcChargesEditViewModel.LcChargesStatus,
                            PCommissionRate = lcChargesEditViewModel.CommissionRate,
                            PDays = lcChargesEditViewModel.Days,
                            PClintFileName = ClintFileName,
                            PServerFileName = serverFileName,
                            PRemarks = lcChargesEditViewModel.Remarks
                        });

                    if (result.PMessageType != IsOk)
                    {
                        throw new Exception(result.PMessageText.Replace("-", " "));
                    }
                    else
                    {
                        return Json(new { success = result.PMessageType == IsOk, response = result.PMessageText });
                    }
                }
                return RedirectToAction("LcChargesDetail", new { ApplicationId = lcChargesEditViewModel.ApplicationId });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, LCHelper.ActionEditLc)]
        public async Task<IActionResult> LcAmountCreate(string id)
        {
            if (id == null)
                return NotFound();

            LcAmountCreateViewModel lcAmountCreateViewModel = new LcAmountCreateViewModel();

            lcAmountCreateViewModel.ApplicationId = id;

            var currencies = await _selectTcmPLRepository.LcCurrenciesListAsync(BaseSpTcmPLGet(), null);

            ViewData["Currencies"] = new SelectList(currencies, "DataValueField", "DataTextField");

            return PartialView("_ModalLcAmountCreate", lcAmountCreateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, LCHelper.ActionEditLc)]
        public async Task<IActionResult> LcAmountCreate([FromForm] LcAmountCreateViewModel lcAmountCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _lcRepository.CreateLcAmountAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PApplicationId = lcAmountCreateViewModel.ApplicationId,
                            PCurrencyKeyId = lcAmountCreateViewModel.Currency,
                            PExchageRateDate = lcAmountCreateViewModel.ExchageRateDate,
                            PExchangeRate = lcAmountCreateViewModel.ExchangeRate,
                            PLcAmount = lcAmountCreateViewModel.LcAmount,
                            PAmountInInr = lcAmountCreateViewModel.AmountInInr
                        });

                    if (result.PMessageType != IsOk)
                    {
                        throw new Exception(result.PMessageText.Replace("-", " "));
                    }
                    else
                    {
                        return Json(new { success = result.PMessageType == IsOk, response = result.PMessageText });
                    }
                }
                return RedirectToAction("LcAmountDetail", new { ApplicationId = lcAmountCreateViewModel.ApplicationId });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, LCHelper.ActionEditLc)]
        public async Task<IActionResult> LcAmountEdit(string id)
        {
            if (id == null)
                return NotFound();

            var result = await _lcAmountDetailsRepository.ILCAmountDetailsAsync(
                        BaseSpTcmPLGet(), new ParameterSpTcmPL { PApplicationId = id });

            LcAmountEditViewModel lcAmountEditViewModel = new LcAmountEditViewModel();

            lcAmountEditViewModel.ApplicationId = id;

            if (result.PMessageType == IsOk)
            {
                lcAmountEditViewModel.LcKeyId = result.PLcKeyId;
                lcAmountEditViewModel.Currency = result.PCurrencyKeyId;
                lcAmountEditViewModel.ExchageRateDate = DateTime.Parse(result.PExchangeRateDate);

                lcAmountEditViewModel.ExchangeRate = decimal.Parse(result.PExchangeRate);
                lcAmountEditViewModel.LcAmount = decimal.Parse(result.PLcAmount);
                lcAmountEditViewModel.AmountInInr = decimal.Parse(result.PAmountInInr);
            }

            var currencies = await _selectTcmPLRepository.LcCurrenciesListAsync(BaseSpTcmPLGet(), null);

            ViewData["Currencies"] = new SelectList(currencies, "DataValueField", "DataTextField", lcAmountEditViewModel.Currency);

            return PartialView("_ModalLcAmountEdit", lcAmountEditViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, LCHelper.ActionEditLc)]
        public async Task<IActionResult> LcAmountEdit([FromForm] LcAmountEditViewModel lcAmountEditViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _lcRepository.UpdateLcAmountAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PApplicationId = lcAmountEditViewModel.ApplicationId,
                            PCurrencyKeyId = lcAmountEditViewModel.Currency,
                            PExchageRateDate = lcAmountEditViewModel.ExchageRateDate,
                            PExchangeRate = lcAmountEditViewModel.ExchangeRate,
                            PLcAmount = lcAmountEditViewModel.LcAmount,
                            PAmountInInr = lcAmountEditViewModel.AmountInInr
                        });

                    if (result.PMessageType != IsOk)
                    {
                        throw new Exception(result.PMessageText.Replace("-", " "));
                    }
                    else
                    {
                        return Json(new { success = result.PMessageType == IsOk, response = result.PMessageText });
                    }
                }
                return RedirectToAction("LcAmountDetail", new { ApplicationId = lcAmountEditViewModel.ApplicationId });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        public async Task<IActionResult> DownloadFile(string KeyId)
        {
            var result = await _lcChargesDetailsRepository.ILCChargesDetailsAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL { PApplicationId = KeyId });

            byte[] bytes = StorageHelper.DownloadFile(StorageHelper.LC.RepositoryLc, FileName: result.PServerFileName, Configuration);

            return File(bytes, "application/octet-stream");
        }

        #endregion Actions

        #region Excel Download

        public async Task<IActionResult> ExcelDownload(string id)
        {
            try
            {
                string StrFimeName;

                var timeStamp = DateTime.Now.ToFileTime();
                StrFimeName = "FileName_" + timeStamp.ToString();

                DataTable dt = new DataTable();
                string strUser = User.Identity.Name;

                var data = await _afcLcMainExcelDataTableListRepository.AfcLcMainExcelDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                    });

                if (data == null) { return NotFound(); }

                var byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(data, "Report Title", "Sheet name");

                
                var mimeType = MimeTypeMap.GetMimeType("xlsx");

                FileContentResult file = File(byteContent, mimeType, StrFimeName);

                return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));

            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        #endregion Excel Download
    }
}