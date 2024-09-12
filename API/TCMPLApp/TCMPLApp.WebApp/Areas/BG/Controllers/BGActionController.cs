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
using TCMPLApp.Domain.Models.ERS;
using TCMPLApp.WebApp.Areas.ERS;
using TCMPLApp.WebApp.CustomPolicyProvider;

namespace TCMPLApp.WebApp.Areas.BG.Controllers
{
    [Area("BG")]
    public class BGActionController : BaseController
    {

        private const string ConstFilterBankGuaranteeActionIndex = "BankGuaranteeActionIndex";

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
        private readonly IBGAmendmentStatusDetailRepository _bgAmendmentStatusDetailRepository;
        private readonly IBGAmendmentStatusRepository _bgAmendmentStatusRepository;
        private readonly IBGRecipientsDataTableListRepository _bgRecipientsDataTableListRepository;

        public BGActionController(
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
            IBGAmendmentStatusDetailRepository bgAmendmentStatusDetailRepository,
            IBGAmendmentStatusRepository bgAmendmentStatusRepository,
            IBGRecipientsDataTableListRepository bgRecipientsDataTableListRepository
            )
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
            _bgAmendmentStatusDetailRepository = bgAmendmentStatusDetailRepository;
            _bgAmendmentStatusRepository = bgAmendmentStatusRepository;
            _bgRecipientsDataTableListRepository = bgRecipientsDataTableListRepository;
        }

        #region BG Master
        public async Task<IActionResult> BankGuaranteeActionIndex()
        {
            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterBankGuaranteeActionIndex
            });
            FilterDataModel filterDataModel = new FilterDataModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            BGMasterDataTableListViewModel bgMasterDataTableListViewModel = new BGMasterDataTableListViewModel();
            bgMasterDataTableListViewModel.FilterDataModel = filterDataModel;

            return View(bgMasterDataTableListViewModel);
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
            bgDetail.BGAmendment.PDocurl = sharepointDocUri + bgDetail.BGMaster.PBgnum;

            return View(bgDetail);
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

            var refnum = id.Split("!-!")[0];
            var amendment = id.Split("!-!")[1];

            var result = await _bgAmendmentDetailRepository.BGAmendmentDetail(
                         BaseSpTcmPLGet(), new ParameterSpTcmPL { PRefnum = refnum, PAmendment = amendment });

            var resultAmendmentStatusDetail = await _bgAmendmentStatusDetailRepository.BGAmendmentStatusDetail(
                         BaseSpTcmPLGet(), new ParameterSpTcmPL { PRefnum = refnum, PAmendmentnum = amendment });

            BGAmendmentDetailViewModel bgamendment = new();

            if (result.PMessageType == IsOk)
            {
                bgamendment.Amendmentnum = result.PAmendmentnum;
                bgamendment.Currid = result.PCurrid;
                bgamendment.Currdesc = result.PCurrdesc;
                bgamendment.Bgamt = result.PBgamt;
                bgamendment.Bgrecdt = result.PBgrecdt;
                bgamendment.Bgaccept = result.PBgaccept;
                bgamendment.Bgacceptrmk = result.PBgacceptrmk;
                bgamendment.Docurl = result.PDocurl;
                bgamendment.Convrate = result.PConvrate;
            }

            ViewData["Refnum"] = refnum;
            ViewData["AmendmentStatus"] = resultAmendmentStatusDetail.PStatusTypeDesc;

            return PartialView("_ModalAmendmentDetailPartial", bgamendment);
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
                PMvcActionName = ConstFilterBankGuaranteeActionIndex
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
                    PMvcActionName = ConstFilterBankGuaranteeActionIndex,
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

        #region Action

        [HttpGet]
        public async Task<IActionResult> BGAction(string id)
        {
            if (id == null)
                return NotFound();

            BGMasterActionUpdateViewModel bgMasterActionUpdateViewModel = new BGMasterActionUpdateViewModel();

            var resultMasterDetail = await _bgMasterDetailRepository.BGMasterDetail(
                         BaseSpTcmPLGet(), new ParameterSpTcmPL { PRefnum = id });

            var resultAmendmentDetail = await _bgAmendmentDetailRepository.BGAmendmentDetail(
                         BaseSpTcmPLGet(), new ParameterSpTcmPL { PRefnum = id });

            var resultAmendmentStatusDetail = await _bgAmendmentStatusDetailRepository.BGAmendmentStatusDetail(
                         BaseSpTcmPLGet(), new ParameterSpTcmPL { PRefnum = id });
            
            bgMasterActionUpdateViewModel.Refnum = id;
            bgMasterActionUpdateViewModel.Amendmentnum = resultAmendmentDetail.PAmendmentnum;
            bgMasterActionUpdateViewModel.StatusTypeId = resultAmendmentStatusDetail.PStatusTypeId;
            bgMasterActionUpdateViewModel.StatusTypeDesc = resultAmendmentStatusDetail.PStatusTypeDesc;
            bgMasterActionUpdateViewModel.bgMasterDetail = resultMasterDetail;
            bgMasterActionUpdateViewModel.bgAmendmentDetail = resultAmendmentDetail;

            var statusTypeList = await _selectTcmPLRepository.SelectBGStatus(BaseSpTcmPLGet(), null);
            ViewData["StatusTypeList"] = new SelectList(statusTypeList, "DataValueField", "DataTextField", bgMasterActionUpdateViewModel.StatusTypeId.ToString());


            ViewData["DocFileName"] = bgMasterActionUpdateViewModel.bgAmendmentDetail.PDocurl;

            var sharepointDocUri = _configuration.GetSection("AFCBGSharePointBaseUri").Value;
            bgMasterActionUpdateViewModel.bgAmendmentDetail.PDocurl = sharepointDocUri + bgMasterActionUpdateViewModel.bgMasterDetail.PBgnum;


            return PartialView("_ModalBankGuaranteeActionPartial", bgMasterActionUpdateViewModel);
        }

        [HttpPost]
        //[RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, ERSHelper.ActionHR)]
        public async Task<IActionResult> BGAction([FromForm] BGMasterActionUpdateViewModel bgMasterActionUpdateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _bgAmendmentStatusRepository.BGAmendmentStatus(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PRefnum = bgMasterActionUpdateViewModel.Refnum,
                            PAmendmentnum = bgMasterActionUpdateViewModel.bgAmendmentDetail.PAmendmentnum,
                            PStatusTypeId = bgMasterActionUpdateViewModel.StatusTypeId
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
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
            }

            return PartialView("_ModalBankGuaranteeActionPartial", bgMasterActionUpdateViewModel);
        }

        #endregion
    }
}