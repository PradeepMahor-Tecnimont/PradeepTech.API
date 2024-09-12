using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using System.Net;
using System.Threading.Tasks;
using System;
using TCMPLApp.WebApp.Classes;
using TCMPLApp.WebApp.Controllers;
using TCMPLApp.WebApp.Models;
using Microsoft.Extensions.Configuration;
using TCMPLApp.DataAccess.Repositories.Common;
using TCMPLApp.Domain.Models.BG;
using System.Linq;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.BG;
using static TCMPLApp.WebApp.Classes.DTModel;
using Microsoft.AspNetCore.Mvc.Rendering;

namespace TCMPLApp.WebApp.Areas.BG.Controllers
{
    [Area("BG")]
    public class BGMainController : BaseController
    {

        private const string ConstFilterBankGuaranteeIndex = "Index";

        private readonly IConfiguration _configuration;        
        private readonly IFilterRepository _filterRepository;
        private readonly ISelectRepository _selectRepository;
        private readonly ISelectTcmPLRepository _selectTcmPLRepository;        
        private readonly IBGMasterRepository _bgMasterRepository;
        private readonly IBGMasterDetailRepository _bgMasterDetailRepository;        
        private readonly IBGMasterDataTableListRepository _bgMasterDataTableListRepository;
        private readonly IBGAmendmentRepository _bgAmendmentRepository;
        private readonly IBGAmendmentDetailRepository _bgAmendmentDetailRepository;
        private readonly IBGAmendmentDataTableListRepository _bgAmendmentDataTableListRepository;
        private readonly IBGRecipientsDataTableListRepository _bgRecipientsDataTableListRepository;

        public BGMainController(
            IConfiguration configuration,
            IFilterRepository filterRepository,
            ISelectRepository selectRepository,
            ISelectTcmPLRepository selectTcmPLRepository,
            IBGMasterDetailRepository bgMasterDetailRepository,
            IBGAmendmentDetailRepository bgAmendmentDetailRepository,
            IBGMasterRepository bgMasterRepository,
            IBGAmendmentRepository bgAmendmentRepository,
            IBGMasterDataTableListRepository bgMasterDataTableListRepository,
            IBGAmendmentDataTableListRepository bgAmendmentDataTableListRepository,
            IBGRecipientsDataTableListRepository bgRecipientsDataTableListRepository)
        {
            _configuration = configuration;
            _filterRepository = filterRepository;
            _selectRepository = selectRepository;
            _selectTcmPLRepository = selectTcmPLRepository;
            _bgMasterRepository = bgMasterRepository;
            _bgMasterDetailRepository = bgMasterDetailRepository;          
            _bgMasterDataTableListRepository = bgMasterDataTableListRepository;            
            _bgAmendmentRepository = bgAmendmentRepository;
            _bgAmendmentDetailRepository = bgAmendmentDetailRepository;
            _bgAmendmentDataTableListRepository = bgAmendmentDataTableListRepository;
            _bgRecipientsDataTableListRepository = bgRecipientsDataTableListRepository;
    }

        #region BG Master
        public async Task<IActionResult> Index()
        {
            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterBankGuaranteeIndex
            });
            FilterDataModel filterDataModel = new FilterDataModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            BGMasterDataTableListViewModel bgMasterDataTableListViewModel = new BGMasterDataTableListViewModel();
            bgMasterDataTableListViewModel.FilterDataModel = filterDataModel;

            return View(bgMasterDataTableListViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> Detail(string id)
        {
            if (id == null)
                return NotFound();

            var resultMaster = await _bgMasterDetailRepository.BGMasterDetail(
                         BaseSpTcmPLGet(), new ParameterSpTcmPL { PRefnum = id });

            var resultAmendment = await _bgAmendmentDetailRepository.BGAmendmentDetail(
                         BaseSpTcmPLGet(), new ParameterSpTcmPL { PRefnum = id, PAmendment = " " });

            BGDetailViewModel bgDetail = new()
            {
                Refnum = id,
                BGMaster = resultMaster,
                BGAmendment = resultAmendment
            };

            ViewData["Refnum"] = id;
            ViewData["DocFileName"] = bgDetail.BGAmendment.PDocurl;

            var sharepointDocUri = _configuration.GetSection("AFCBGSharePointBaseUri").Value;
            bgDetail.BGAmendment.PDocurl = sharepointDocUri + bgDetail.BGMaster.PBgnum ;

            return View(bgDetail);
        }

        public async Task<IActionResult> Create()
        {
            BGMasterCreateViewModel bgMaster = new();

            var companies = await _selectTcmPLRepository.BgCompanyListAsync(BaseSpTcmPLGet(), null);
            var currencies = await _selectTcmPLRepository.BgCurrenciesListAsync(BaseSpTcmPLGet(), null);
            var projects = await _selectTcmPLRepository.BgProjectListAsync(BaseSpTcmPLGet(), null);
            var issuedby = await _selectTcmPLRepository.BgIssuedByListAsync(BaseSpTcmPLGet(), null);
            var issuedto = await _selectTcmPLRepository.BgIssuedToListAsync(BaseSpTcmPLGet(), null);
            var banks = await _selectTcmPLRepository.BgBankListAsync(BaseSpTcmPLGet(), null);
            var acceptables = await _selectTcmPLRepository.BGAcceptableAsync(BaseSpTcmPLGet(), null);

            ViewData["CompanyList"] = new SelectList(companies, "DataValueField", "DataTextField");
            ViewData["CurrencyList"] = new SelectList(currencies, "DataValueField", "DataTextField");
            ViewData["ProjectList"] = new SelectList(projects, "DataValueField", "DataTextField");
            ViewData["IssuedbyList"] = new SelectList(issuedby, "DataValueField", "DataTextField");
            ViewData["IssuedtoList"] = new SelectList(issuedto, "DataValueField", "DataTextField");
            ViewData["BankList"] = new SelectList(banks, "DataValueField", "DataTextField");
            ViewData["AcceptableList"] = new SelectList(acceptables, "DataValueField", "DataTextField");

            return View("Create", bgMaster);
        }

        [HttpPost]
        public async Task<IActionResult> Create([FromForm] BGMasterCreateViewModel bgMasterCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _bgMasterRepository.BGMasterCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PBgnum = bgMasterCreateViewModel.Bgnum,
                            PBgdate = bgMasterCreateViewModel.Bgdate,
                            PCompid = bgMasterCreateViewModel.Compid ?? " ",
                            PBgtype = bgMasterCreateViewModel.Bgtype,
                            PPonum = bgMasterCreateViewModel.Ponum ?? " ",
                            PProjnum = bgMasterCreateViewModel.Projnum ?? " ",
                            PIssuebyid = bgMasterCreateViewModel.Issuebyid ?? " ",
                            PIssuetoid = bgMasterCreateViewModel.Issuetoid ?? " ",
                            PBgvaldt = bgMasterCreateViewModel.Bgvaldt,
                            PBgclmdt = bgMasterCreateViewModel.Bgclmdt,
                            PBankid = bgMasterCreateViewModel.Bankid ?? " ",
                            PRemarks = bgMasterCreateViewModel.Remarks ?? " ",
                            PReleased = (decimal?)bgMasterCreateViewModel.Released ?? 0,
                            PReldt = bgMasterCreateViewModel.Reldt,
                            PReldetails = bgMasterCreateViewModel.Reldetails ?? " ",
                            PAmendmentnum = bgMasterCreateViewModel.Amendmentnum,
                            PCurrid = bgMasterCreateViewModel.Currid ?? " ",
                            PBgamt = bgMasterCreateViewModel.Bgamt ?? " ",
                            PBgrecdt = bgMasterCreateViewModel.Bgrecdt,
                            PBgaccept = bgMasterCreateViewModel.Bgaccept ?? " ",
                            PBgacceptrmk = bgMasterCreateViewModel.Bgacceptrmk ?? " ",
                            PDocurl = bgMasterCreateViewModel.Docurl ?? " ",
                            PConvrate = bgMasterCreateViewModel.Convrate ?? " "
                        });

                    if (result.PMessageType != "OK")
                    {
                        Notify("Error", result.PMessageText.Replace("-", " "), "toaster", NotificationType.error);
                    }
                    else
                    {
                        Notify("Success", result.PMessageText.Replace("-", " "), "toaster", NotificationType.success);
                        return RedirectToAction("Index");
                    }
                }
            }
            catch (Exception ex)
            {               
                Notify("Error", StringHelper.CleanExceptionMessage(ex.Message).Replace("-", " "), "toaster", NotificationType.error);
            }

            var companies = await _selectTcmPLRepository.BgCompanyListAsync(BaseSpTcmPLGet(), null);
            var currencies = await _selectTcmPLRepository.BgCurrenciesListAsync(BaseSpTcmPLGet(), null);
            var projects = await _selectTcmPLRepository.BgProjectListAsync(BaseSpTcmPLGet(), null);
            var issuedby = await _selectTcmPLRepository.BgIssuedByListAsync(BaseSpTcmPLGet(), null);
            var issuedto = await _selectTcmPLRepository.BgIssuedToListAsync(BaseSpTcmPLGet(), null);
            var banks = await _selectTcmPLRepository.BgBankListAsync(BaseSpTcmPLGet(), null);
            var acceptables = await _selectTcmPLRepository.BGAcceptableAsync(BaseSpTcmPLGet(), null);

            ViewData["CompanyList"] = new SelectList(companies, "DataValueField", "DataTextField");
            ViewData["CurrencyList"] = new SelectList(currencies, "DataValueField", "DataTextField");
            ViewData["ProjectList"] = new SelectList(projects, "DataValueField", "DataTextField");
            ViewData["IssuedbyList"] = new SelectList(issuedby, "DataValueField", "DataTextField");
            ViewData["IssuedtoList"] = new SelectList(issuedto, "DataValueField", "DataTextField");
            ViewData["BankList"] = new SelectList(banks, "DataValueField", "DataTextField");
            ViewData["AcceptableList"] = new SelectList(acceptables, "DataValueField", "DataTextField");

            return View(bgMasterCreateViewModel);
        }

        public async Task<IActionResult> Edit(string id)
        {
            if (id == null)
                return NotFound();

            var resultMaster = await _bgMasterDetailRepository.BGMasterDetail(
                         BaseSpTcmPLGet(), new ParameterSpTcmPL { PRefnum = id });

            BGMasterUpdateViewModel bgMasterUpdateViewModel = new();

            bgMasterUpdateViewModel.Refnum = id;
            bgMasterUpdateViewModel.Bgnum = resultMaster.PBgnum;
            bgMasterUpdateViewModel.Bgdate = resultMaster.PBgdate;
            bgMasterUpdateViewModel.Compid = resultMaster.PCompid;
            bgMasterUpdateViewModel.Bgtype = resultMaster.PBgtype;
            bgMasterUpdateViewModel.Ponum = resultMaster.PPonum;
            bgMasterUpdateViewModel.Projnum = resultMaster.PProjnum;
            bgMasterUpdateViewModel.Issuebyid = resultMaster.PIssuebyid;
            bgMasterUpdateViewModel.Issuetoid = resultMaster.PIssuetoid;
            bgMasterUpdateViewModel.Bgvaldt = resultMaster.PBgvaldt;
            bgMasterUpdateViewModel.Bgclmdt = resultMaster.PBgclmdt;
            bgMasterUpdateViewModel.Bankid = resultMaster.PBankid;
            bgMasterUpdateViewModel.Remarks = resultMaster.PRemarks;
            bgMasterUpdateViewModel.Released = resultMaster.PReleased;
            bgMasterUpdateViewModel.Reldt = resultMaster.PReldt;
            bgMasterUpdateViewModel.Reldetails = resultMaster.PReldetails;

            var companies = await _selectTcmPLRepository.BgCompanyListAsync(BaseSpTcmPLGet(), null);
            var currencies = await _selectTcmPLRepository.BgCurrenciesListAsync(BaseSpTcmPLGet(), null);
            var projects = await _selectTcmPLRepository.BgProjectListAsync(BaseSpTcmPLGet(), null);
            var issuedby = await _selectTcmPLRepository.BgIssuedByListAsync(BaseSpTcmPLGet(), null);
            var issuedto = await _selectTcmPLRepository.BgIssuedToListAsync(BaseSpTcmPLGet(), null);
            var banks = await _selectTcmPLRepository.BgBankListAsync(BaseSpTcmPLGet(), null);            

            ViewData["CompanyList"] = new SelectList(companies, "DataValueField", "DataTextField", resultMaster.PCompid);            
            ViewData["ProjectList"] = new SelectList(projects, "DataValueField", "DataTextField", resultMaster.PProjnum);
            ViewData["IssuedbyList"] = new SelectList(issuedby, "DataValueField", "DataTextField", resultMaster.PIssuebyid);
            ViewData["IssuedtoList"] = new SelectList(issuedto, "DataValueField", "DataTextField", resultMaster.PIssuetoid);
            ViewData["BankList"] = new SelectList(banks, "DataValueField", "DataTextField", resultMaster.PBankid);           
            ViewData["Refnum"] = id;

            return PartialView("_ModalMasterEditPartial", bgMasterUpdateViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> Edit([FromForm] BGMasterUpdateViewModel bgMasterUpdateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _bgMasterRepository.BGMasterEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        { 
                            PRefnum = bgMasterUpdateViewModel.Refnum,
                            PBgnum = bgMasterUpdateViewModel.Bgnum,
                            PBgdate = bgMasterUpdateViewModel.Bgdate,
                            PCompid = bgMasterUpdateViewModel.Compid,
                            PBgtype = bgMasterUpdateViewModel.Bgtype ?? " ",
                            PPonum = bgMasterUpdateViewModel.Ponum ?? " ",
                            PProjnum = bgMasterUpdateViewModel.Projnum ?? " ",
                            PIssuebyid = bgMasterUpdateViewModel.Issuebyid ?? " ",
                            PIssuetoid = bgMasterUpdateViewModel.Issuetoid ?? " ",
                            PBgvaldt = bgMasterUpdateViewModel.Bgvaldt,
                            PBgclmdt = bgMasterUpdateViewModel.Bgclmdt,
                            PBankid = bgMasterUpdateViewModel.Bankid ?? " ",
                            PRemarks = bgMasterUpdateViewModel.Remarks ?? " ",
                            PReleased = (decimal?)bgMasterUpdateViewModel.Released ?? 0,
                            PReldt = bgMasterUpdateViewModel.Reldt,
                            PReldetails = bgMasterUpdateViewModel.Reldetails ?? " "
                        });

                    if (result.PMessageType != "OK")
                    {
                        Notify("Error", result.PMessageText.Replace("-", " "), "toaster", NotificationType.error);
                    }
                    else
                    {
                        Notify("Success", result.PMessageText.Replace("-", " "), "toaster", NotificationType.success);
                        return RedirectToAction("Index");
                    }
                }
            }
            catch (Exception ex)
            {
                Notify("Error", StringHelper.CleanExceptionMessage(ex.Message).Replace("-", " "), "toaster", NotificationType.error);
            }

            var companies = await _selectTcmPLRepository.BgCompanyListAsync(BaseSpTcmPLGet(), null);
            var currencies = await _selectTcmPLRepository.BgCurrenciesListAsync(BaseSpTcmPLGet(), null);
            var projects = await _selectTcmPLRepository.BgProjectListAsync(BaseSpTcmPLGet(), null);
            var issuedby = await _selectTcmPLRepository.BgIssuedByListAsync(BaseSpTcmPLGet(), null);
            var issuedto = await _selectTcmPLRepository.BgIssuedToListAsync(BaseSpTcmPLGet(), null);
            var banks = await _selectTcmPLRepository.BgBankListAsync(BaseSpTcmPLGet(), null);

            ViewData["CompanyList"] = new SelectList(companies, "DataValueField", "DataTextField");
            ViewData["CurrencyList"] = new SelectList(currencies, "DataValueField", "DataTextField");
            ViewData["ProjectList"] = new SelectList(projects, "DataValueField", "DataTextField");
            ViewData["IssuedbyList"] = new SelectList(issuedby, "DataValueField", "DataTextField");
            ViewData["IssuedtoList"] = new SelectList(issuedto, "DataValueField", "DataTextField");
            ViewData["BankList"] = new SelectList(banks, "DataValueField", "DataTextField");

            return View(bgMasterUpdateViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> Delete(string id)
        {
            if (id == null)
                return NotFound();

            var refnum = id.Split("!-!")[0];
            var bgnum = id.Split("!-!")[1];

            var msgText = "Error occured";
            try
            {
                var result = await _bgMasterRepository.BGMasterDeleteAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL 
                    { 
                        PRefnum = refnum,
                        PBgnum = bgnum
                    });

                if (result.PMessageType != "OK")
                {
                    Notify("Error", result.PMessageText.Replace("-", " "), "toaster", NotificationType.error);                    
                }
                else
                {
                    Notify("Success", result.PMessageText.Replace("-", " "), "toaster", NotificationType.success);
                    return Json(new { success = result.PMessageType == IsOk, response = result.PMessageText });                    
                }
            }
            catch (Exception ex)
            {
                msgText = ex.Message.ToString();                
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            return Json(new { success = false, response = msgText });
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsBGMaster(DTParameters param)
        {
            DTResult<BGMasterDataTableList> result = new DTResult<BGMasterDataTableList>();
            int totalRow = 0;           

            try
            {
                var data = await _bgMasterDataTableListRepository.BGMasterDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
                        PGenericSearch = param.GenericSearch ?? " ",
                        PProjno = param.Projno,
                        PBgtype = param.BgType,
                        PBgFromDate = param.BgFromDate,
                        PBgToDate = param.BgToDate,
                        PBgValFromDate = param.BgValFromDate,
                        PBgValToDate = param.BgValToDate,
                        PBgClaimFromDate = param.BgClaimFromDate,
                        PBgClaimToDate = param.BgClaimToDate
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

        #endregion BG Master

        #region Amendment               

        public IActionResult AmendmentIndex(string id)
        {
            if (id == null)
                return NotFound();

            BGAmendmentDataTableListViewModel bgAmendmentList = new();

            ViewData["Refnum"] = id;

            return PartialView("_AmendmentIndexPartial", bgAmendmentList);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsAmedments(DTParameters param)
        {
            DTResult<BGAmendmentDataTableList> result = new DTResult<BGAmendmentDataTableList>();
            int totalRow = 0;

            try
            {
                var data = await _bgAmendmentDataTableListRepository.BGAmendmentDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
                        PRefnum = param.Refnum,
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
                return Json(new
                {
                    error = ex.Message
                });
            }
        }

        [HttpGet]
        public async Task<IActionResult> AmendmentDetail(string id)
        {
            if (id == null)
                return NotFound();

            var result = await _bgAmendmentDetailRepository.BGAmendmentDetail(
                         BaseSpTcmPLGet(), new ParameterSpTcmPL { PRefnum = id });

            BGAmendmentDetailViewModel bgamendment = new();

            ViewData["Refnum"] = id;
            ViewData["DocFileName"] = result.PDocurl ?? "";

            if (result.PMessageType == IsOk)
            {
                var sharepointDocUri = _configuration.GetSection("AFCBGSharePointBaseUri").Value;

                var resultMaster = await _bgMasterDetailRepository.BGMasterDetail(
                         BaseSpTcmPLGet(), new ParameterSpTcmPL { PRefnum = id });   

                bgamendment.Amendmentnum = result.PAmendmentnum;
                bgamendment.Currid = result.PCurrid;
                bgamendment.Currdesc = result.PCurrdesc;
                bgamendment.Bgamt = result.PBgamt;
                bgamendment.Bgrecdt = result.PBgrecdt;
                bgamendment.Bgaccept = result.PBgaccept;
                bgamendment.Bgacceptrmk = result.PBgacceptrmk;
                bgamendment.Docurl = sharepointDocUri + resultMaster.PBgnum + @"\" + result.PDocurl;
                bgamendment.Convrate = result.PConvrate;
            }
           
            return PartialView("_ModalDetail", bgamendment);
        }               

        public async Task<IActionResult> AmendmentCreate(string id)
        {
            BGAmendmentCreateViewModel bgamendment = new();

            var result = await _bgAmendmentDetailRepository.BGAmendmentDetail(
                         BaseSpTcmPLGet(), new ParameterSpTcmPL { PRefnum = id, PAmendment = " " });            

            if (result.PMessageType == IsOk)
            {
                bgamendment.Refnum = id;                
                bgamendment.Currid = result.PCurrid;                
                bgamendment.Bgamt = result.PBgamt;
                bgamendment.Bgrecdt = result.PBgrecdt;
                bgamendment.Bgaccept = result.PBgaccept;
                bgamendment.Bgacceptrmk = result.PBgacceptrmk;
                bgamendment.Docurl = result.PDocurl;
                bgamendment.Convrate = result.PConvrate;
            }

            var currencies = await _selectTcmPLRepository.BgCurrenciesListAsync(BaseSpTcmPLGet(), null);
            var acceptables = await _selectTcmPLRepository.BGAcceptableAsync(BaseSpTcmPLGet(), null);

            ViewData["Currencies"] = new SelectList(currencies, "DataValueField", "DataTextField");
            ViewData["AcceptableList"] = new SelectList(acceptables, "DataValueField", "DataTextField", null);

            return PartialView("_ModalAmendmentCreatePartial", bgamendment);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> AmendmentCreate([FromForm] BGAmendmentCreateViewModel bgAmendmentCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _bgAmendmentRepository.BGAmendmentCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PRefnum = bgAmendmentCreateViewModel.Refnum,
                            PAmendmentnum = bgAmendmentCreateViewModel.Amendmentnum ?? " ",
                            PCurrid = bgAmendmentCreateViewModel.Currid ?? " ",
                            PBgamt = bgAmendmentCreateViewModel.Bgamt ?? " ",
                            PBgrecdt = bgAmendmentCreateViewModel.Bgrecdt,
                            PBgaccept = bgAmendmentCreateViewModel.Bgaccept ?? " ",                            
                            PBgacceptrmk = bgAmendmentCreateViewModel.Bgacceptrmk ?? " ",
                            PDocurl = bgAmendmentCreateViewModel.Docurl ?? " ",
                            PConvrate = bgAmendmentCreateViewModel.Convrate ?? " "
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

            var currencies = await _selectTcmPLRepository.BgCurrenciesListAsync(BaseSpTcmPLGet(), null);
            ViewData["Currencies"] = new SelectList(currencies, "DataValueField", "DataTextField", bgAmendmentCreateViewModel.Currid);

            return PartialView("_ModalBankCreate", bgAmendmentCreateViewModel);
        }

        public async Task<IActionResult> AmendmentEdit(string id)
        {
            BGAmendmentCreateViewModel bgamendment = new();

            var refnum = id.Split("!-!")[0];
            var amendment = id.Split("!-!")[1];            

            var result = await _bgAmendmentDetailRepository.BGAmendmentDetail(
                         BaseSpTcmPLGet(), new ParameterSpTcmPL { PRefnum = refnum, PAmendment = amendment ?? " " });

            if (result.PMessageType == IsOk)
            {
                bgamendment.Refnum = refnum;
                bgamendment.Amendmentnum = amendment;
                bgamendment.Currid = result.PCurrid;
                bgamendment.Bgamt = result.PBgamt;
                bgamendment.Bgrecdt = result.PBgrecdt;
                bgamendment.Bgaccept = result.PBgaccept;
                bgamendment.Bgacceptname = result.PBgacceptname;
                bgamendment.Bgacceptrmk = result.PBgacceptrmk;
                bgamendment.Docurl = result.PDocurl;
                bgamendment.Convrate = result.PConvrate;
            }

            var currencies = await _selectTcmPLRepository.BgCurrenciesListAsync(BaseSpTcmPLGet(), null);
            var acceptables = await _selectTcmPLRepository.BGAcceptableAsync(BaseSpTcmPLGet(), null);

            ViewData["Currencies"] = new SelectList(currencies, "DataValueField", "DataTextField", result.PCurrid);
            ViewData["AcceptableList"] = new SelectList(acceptables, "DataValueField", "DataTextField", result.PBgaccept);

            return PartialView("_ModalAmendmentEditPartial", bgamendment);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> AmendmentEdit([FromForm] BGAmendmentCreateViewModel bgAmendmentCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _bgAmendmentRepository.BGAmendmentEditAsync(
                    BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {                            
                            PRefnum = bgAmendmentCreateViewModel.Refnum,
                            PAmendmentnum = bgAmendmentCreateViewModel.Amendmentnum,
                            PCurrid = bgAmendmentCreateViewModel.Currid,
                            PBgamt = bgAmendmentCreateViewModel.Bgamt ?? " ",
                            PBgrecdt = bgAmendmentCreateViewModel.Bgrecdt,
                            PBgaccept = bgAmendmentCreateViewModel.Bgaccept ?? " ",
                            PBgacceptrmk = bgAmendmentCreateViewModel.Bgacceptrmk ?? " " ,
                            PDocurl = bgAmendmentCreateViewModel.Docurl ?? " ",
                            PConvrate = bgAmendmentCreateViewModel.Convrate ?? " "
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

            var currencies = await _selectTcmPLRepository.BgCurrenciesListAsync(BaseSpTcmPLGet(), null);
            var acceptables = await _selectTcmPLRepository.BGAcceptableAsync(BaseSpTcmPLGet(), null);

            ViewData["Currencies"] = new SelectList(currencies, "DataValueField", "DataTextField", bgAmendmentCreateViewModel.Currid?.ToString());
            ViewData["AcceptableList"] = new SelectList(acceptables, "DataValueField", "DataTextField", bgAmendmentCreateViewModel.Bgaccept?.ToString());

            return PartialView("_ModalBankCreate", bgAmendmentCreateViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> AmendmentDelete(string id)
        {
            BGAmendmentCreateViewModel bgamendment = new();

            var refnum = id.Split("!-!")[0];
            var amendment = id.Split("!-!")[1];

            var result = await _bgAmendmentRepository.BGAmendmentDeleteAsync(
                         BaseSpTcmPLGet(), 
                         new ParameterSpTcmPL 
                         { 
                             PRefnum = refnum, 
                             PAmendment = amendment ?? " " 
                         });

            return result.PMessageType != IsOk
                        ? throw new Exception(result.PMessageText.Replace("-", " "))
                        : (IActionResult)Json(new { success = true, response = result.PMessageText });
            
        }

        #endregion Amendment

        #region Recipients

        public IActionResult RecipientsIndex(string id)
        {
            if (id == null)
                return NotFound();

            BGRecipientsDataTableListViewModel bgRecipientsList = new();

            ViewData["Refnum"] = id;

            return PartialView("_RecipientsIndexPartial", bgRecipientsList);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsRecipients(DTParameters param)
        {
            DTResult<BGRecipientsDataTableList> result = new DTResult<BGRecipientsDataTableList>();
            int totalRow = 0;

            try
            {
                var data = await _bgRecipientsDataTableListRepository.BGRecipientsDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
                        PProjno = param.Projno,
                        PCompid = param.CompanyCode
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

        #endregion Recipients

        #region Filter

        public async Task<IActionResult> FilterGet()
        {
            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterBankGuaranteeIndex
            });

            var projects = await _selectTcmPLRepository.BgProjectFilterList(BaseSpTcmPLGet(), null);
            ViewData["ProjectList"] = new SelectList(projects, "DataValueField", "DataTextField");

            FilterDataModel filterDataModel = new FilterDataModel();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            return PartialView("_FilterSetPartial", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> FilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                string jsonFilter;

                jsonFilter = JsonConvert.SerializeObject(new
                {
                    Projno = filterDataModel.Projno,
                    BgType = filterDataModel.BgType,
                    BgFromDate = filterDataModel.BgFromDate,
                    BgToDate = filterDataModel.BgToDate,
                    BgValFromDate = filterDataModel.BgValFromDate,
                    BgValToDate = filterDataModel.BgValToDate,
                    BgClaimFromDate = filterDataModel.BgClaimFromDate,
                    BgClaimToDate = filterDataModel.BgClaimToDate
                });

                var retVal = await _filterRepository.FilterCreateAsync(new Domain.Models.FilterCreate
                {
                    PModuleName = CurrentUserIdentity.CurrentModule,
                    PMetaId = CurrentUserIdentity.MetaId,
                    PPersonId = CurrentUserIdentity.EmployeeId,
                    PMvcActionName = ConstFilterBankGuaranteeIndex,
                    PFilterJson = jsonFilter
                });

                return Json(new
                {
                    success = true,
                    Projno = filterDataModel.Projno,
                    BgType = filterDataModel.BgType,
                    BgFromDate = filterDataModel.BgFromDate,
                    BgToDate = filterDataModel.BgToDate,
                    BgValFromDate = filterDataModel.BgValFromDate,
                    BgValToDate = filterDataModel.BgValToDate,
                    BgClaimFromDate = filterDataModel.BgClaimFromDate,
                    BgClaimToDate = filterDataModel.BgClaimToDate
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

        #endregion Filter
    }
}