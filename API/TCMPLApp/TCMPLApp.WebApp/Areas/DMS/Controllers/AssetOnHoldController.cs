using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using System;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.Common;
using TCMPLApp.DataAccess.Repositories.DMS;
using TCMPLApp.WebApp.Classes;
using TCMPLApp.WebApp.Controllers;
using static TCMPLApp.WebApp.Classes.DTModel;
using TCMPLApp.WebApp.Models;
using TCMPLApp.Domain.Models.DMS;
using TCMPLApp.DataAccess.Repositories.SWPVaccine;
using System.Collections.Generic;
using DocumentFormat.OpenXml.Drawing.Charts;
using NuGet.Protocol.Plugins;
using System.Net.NetworkInformation;
using TCMPLApp.WebApp.CustomPolicyProvider;
using DocumentFormat.OpenXml.Packaging;
using System.IO;
using Microsoft.AspNetCore.Mvc.Rendering;
using NuGet.Protocol;

//using TCMPLApp.WebApp.Lib.Models;

namespace TCMPLApp.WebApp.Areas.DMS.Controllers
{
    [Authorize]
    [Area("DMS")]
    public class AssetOnHoldController : BaseController
    {
        private const string ConstAssetOnHold = "4";
        private const string ConstInService = "3";
        private const string ConstFilterAssetOnHoldIndex = "DmsAssetOnHoldIndex";
        private const string ConstFilterDmsAssetOnHoldTransLogIndex = "DmsAssetOnHoldTransLogIndex";

        private readonly IDMSEmployeeRepository _dmsEmployeeRepository;
        private readonly ISelectTcmPLRepository _selectTcmPLRepository;
        private readonly IFilterRepository _filterRepository;

        private readonly IAssetOnHoldActionTransDataTableListRepository _assetOnHoldActionTransDataTableListRepository;
        private readonly IAssetOnHoldAssetAddDataTableListRepository _assetOnHoldAssetAddDataTableListRepository;
        private readonly IDeskAreaDataTableListRepository _deskAreaDataTableListRepository;
        private readonly IDeskMasterDataTableListRepository _deskMasterDataTableListRepository;

        private readonly IBayDetailRepository _bayDetailRepository;
        private readonly IDeskAreaCategoriesDetailRepository _deskAreaCategoriesDetailRepository;
        private readonly IAssetOnHoldActionTransDetailRepository _assetOnHoldActionTransDetailRepository;
        private readonly IAssetOnHoldAssetAddDetailRepository _assetOnHoldAssetAddDetailRepository;
        private readonly IAssetOnHoldActionTransRepository _assetOnHoldActionTransRepository;
        private readonly IDeskAreaCategoriesRepository _deskAreaCategoriesRepository;
        private readonly IAssetOnHoldAssetAddRepository _assetOnHoldAssetAddRepository;
        private readonly IDeskMasterRepository _deskMasterRepository;
        private readonly IUtilityRepository _utilityRepository;

        public AssetOnHoldController(
            IDMSEmployeeRepository dmsEmployeeRepository,
            IFilterRepository filterRepository,
            ISelectTcmPLRepository selectTcmPLRepository,
            IAssetOnHoldActionTransDataTableListRepository assetOnHoldActionTransDataTableListRepository,
            IAssetOnHoldAssetAddDataTableListRepository assetOnHoldAssetAddDataTableListRepository,
            IDeskAreaDataTableListRepository deskAreaDataTableListRepository,
            IDeskMasterDataTableListRepository deskMasterDataTableListRepository,
            IBayDetailRepository bayDetailRepository,
            IDeskAreaCategoriesDetailRepository deskAreaCategoriesDetailRepository,
            IAssetOnHoldActionTransDetailRepository assetOnHoldActionTransDetailRepository,
            IAssetOnHoldAssetAddDetailRepository assetOnHoldAssetAddDetailRepository,
            IAssetOnHoldActionTransRepository assetOnHoldActionTransRepository,
            IDeskAreaCategoriesRepository deskAreaCategoriesRepository,
            IAssetOnHoldAssetAddRepository assetOnHoldAssetAddRepository,
            IDeskMasterRepository deskMasterRepository,
            IUtilityRepository utilityRepository
            )
        {
            _dmsEmployeeRepository = dmsEmployeeRepository;
            _deskMasterRepository = deskMasterRepository;
            _selectTcmPLRepository = selectTcmPLRepository;
            _filterRepository = filterRepository;

            _assetOnHoldActionTransDataTableListRepository = assetOnHoldActionTransDataTableListRepository;
            _assetOnHoldAssetAddDataTableListRepository = assetOnHoldAssetAddDataTableListRepository;
            _deskAreaDataTableListRepository = deskAreaDataTableListRepository;
            _deskMasterDataTableListRepository = deskMasterDataTableListRepository;
            _bayDetailRepository = bayDetailRepository;
            _deskAreaCategoriesDetailRepository = deskAreaCategoriesDetailRepository;
            _assetOnHoldActionTransDetailRepository = assetOnHoldActionTransDetailRepository;
            _assetOnHoldAssetAddDetailRepository = assetOnHoldAssetAddDetailRepository;
            _assetOnHoldActionTransRepository = assetOnHoldActionTransRepository;
            _deskAreaCategoriesRepository = deskAreaCategoriesRepository;
            _assetOnHoldAssetAddRepository = assetOnHoldAssetAddRepository;
            _deskMasterRepository = deskMasterRepository;

            _utilityRepository = utilityRepository;
        }

        public IActionResult Index()
        {
            return View();
        }

        #region AssetOnHoldIndex

        public async Task<IActionResult> AssetOnHoldIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterAssetOnHoldIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            AssetOnHoldViewModel invAssetOnHoldViewModel = new() { FilterDataModel = filterDataModel };

            return View(invAssetOnHoldViewModel);
        }

        public async Task<IActionResult> AssetOnHoldTransLogIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterDmsAssetOnHoldTransLogIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            AssetOnHoldTransLogViewModel assetOnHoldTransLogViewModel = new() { FilterDataModel = filterDataModel };

            return View(assetOnHoldTransLogViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsAssetOnHoldTransLog(DTParameters param)
        {
            DTResult<AssetOnHoldActionTransDataTableList> result = new();
            int totalRow = 0;

            try
            {
                IEnumerable<AssetOnHoldActionTransDataTableList> data = await
            _assetOnHoldActionTransDataTableListRepository.AssetOnHoldActionTransDataTableListAsync(BaseSpTcmPLGet(),
            new ParameterSpTcmPL
            {
                PGenericSearch = param.GenericSearch ?? " ",
                PRowNumber =
            param.Start,
                PPageLength = param.Length
            });

                if (data.Any()) { totalRow = (int)data.FirstOrDefault().TotalRow.Value; }

                result.draw = param.Draw; result.recordsTotal = totalRow; result.recordsFiltered =
                totalRow; result.data = data.ToList();

                return Json(result);
            }
            catch (Exception ex)
            {
                return Json(new { error = ex.Message });
            }
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsAssetOnHold(DTParameters param)
        {
            DTResult<AssetOnHoldAssetAddDataTableList> result = new();
            int totalRow = 0;

            try
            {
                IEnumerable<AssetOnHoldAssetAddDataTableList> data =
                                await _assetOnHoldAssetAddDataTableListRepository.AssetOnHoldAssetAddDataTableListAsync(BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PGenericSearch = param.GenericSearch ?? " ",
                    PRowNumber = param.Start,
                    PPageLength = param.Length
                });

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

        //[HttpGet]
        //public async Task<IActionResult> AssetOnHoldActionTransCreate()
        //{
        //    AssetOnHoldActionTransCreateViewModel assetOnHoldActionTransCreateViewModel = new();

        // var invTransTypeList = await
        // _selectTcmPLRepository.InvTransTypeCreateList(BaseSpTcmPLGet(), null);
        // ViewData["ActionTypeList"] = new SelectList(invTransTypeList, "DataValueField", "DataTextField");

        // var dmsEmployeeList = await
        // _selectTcmPLRepository.EmployeeListForHRAsync(BaseSpTcmPLGet(), null);
        // ViewData["SourceEmpList"] = new SelectList(dmsEmployeeList, "DataValueField", "DataTextField");

        // var invItemTypeFullList = await _selectTcmPLRepository.InvItemTypeAssetFullList(
        // BaseSpTcmPLGet(), new ParameterSpTcmPL { }); ViewData["AssetIdList"] = new
        // SelectList(invItemTypeFullList, "DataValueField", "DataTextField");

        // var targetAssetList = await _selectTcmPLRepository.InvItemTypeAssetFullList(
        // BaseSpTcmPLGet(), new ParameterSpTcmPL { }); ViewData["TargetAssetList"] = new
        // SelectList(targetAssetList, "DataValueField", "DataTextField");

        // var sourceDeskList = await _selectTcmPLRepository.DeskListForOfficeSWP( BaseSpTcmPLGet(),
        // new ParameterSpTcmPL { }); ViewData["SourceDeskList"] = new SelectList(sourceDeskList,
        // "DataValueField", "DataTextField");

        //    return PartialView("_ModalAssetOnHoldActionTransCreatePartial", assetOnHoldActionTransCreateViewModel);
        //}

        //[HttpPost]
        //[ValidateAntiForgeryToken]
        //public async Task<IActionResult> AssetOnHoldActionTransCreate([FromForm] AssetOnHoldActionTransCreateViewModel assetOnHoldActionTransCreateViewModel)
        //{
        //    try
        //    {
        //        if (ModelState.IsValid)
        //        {
        //            var result = await _assetOnHoldActionTransRepository.DmActionTransCreateAsync(
        //                BaseSpTcmPLGet(),
        //                new ParameterSpTcmPL
        //                {
        //                    PAssetId = assetOnHoldActionTransCreateViewModel.AssetId,
        //                    PTargetAsset = assetOnHoldActionTransCreateViewModel.TargetAsset,
        //                    PAssetidOld = assetOnHoldActionTransCreateViewModel.AssetidOld,
        //                    PRemarks = assetOnHoldActionTransCreateViewModel.Remarks,
        //                    PActionType = assetOnHoldActionTransCreateViewModel.ActionType,
        //                    PSourceDesk = assetOnHoldActionTransCreateViewModel.SourceDesk,
        //                    PSourceEmp = assetOnHoldActionTransCreateViewModel.SourceEmp,
        //                });

        // return result.PMessageType != Success ? throw new
        // Exception(result.PMessageText.Replace("-", " ")) : (IActionResult)Json(new { success =
        // true, response = result.PMessageText }); } } catch (Exception ex) { return
        // StatusCode((int)HttpStatusCode.InternalServerError,
        // StringHelper.CleanExceptionMessage(ex.Message)); }

        // var invTransTypeList = await
        // _selectTcmPLRepository.InvTransTypeCreateList(BaseSpTcmPLGet(), null);
        // ViewData["ActionTypeList"] = new SelectList(invTransTypeList, "DataValueField",
        // "DataTextField", assetOnHoldActionTransCreateViewModel.ActionType);

        // var dmsEmployeeList = await
        // _selectTcmPLRepository.EmployeeListForHRAsync(BaseSpTcmPLGet(), null);
        // ViewData["SourceEmpList"] = new SelectList(dmsEmployeeList, "DataValueField",
        // "DataTextField", assetOnHoldActionTransCreateViewModel.SourceEmp);

        // var invItemTypeFullList = await _selectTcmPLRepository.InvItemTypeAssetFullList(
        // BaseSpTcmPLGet(), new ParameterSpTcmPL { }); ViewData["AssetIdList"] = new
        // SelectList(invItemTypeFullList, "DataValueField", "DataTextField", assetOnHoldActionTransCreateViewModel.AssetId);

        // var targetAssetList = await _selectTcmPLRepository.TargetDeskListAsync( BaseSpTcmPLGet(),
        // new ParameterSpTcmPL { }); ViewData["TargetAssetList"] = new SelectList(targetAssetList,
        // "DataValueField", "DataTextField", assetOnHoldActionTransCreateViewModel.TargetAsset);

        // var sourceDeskList = await _selectTcmPLRepository.SourceDeskListAsync( BaseSpTcmPLGet(),
        // new ParameterSpTcmPL { }); ViewData["SourceDeskList"] = new SelectList(sourceDeskList,
        // "DataValueField", "DataTextField", assetOnHoldActionTransCreateViewModel.SourceDesk);

        //    return PartialView("_ModalAssetOnHoldActionTransCreatePartial", assetOnHoldActionTransCreateViewModel);
        //}

        [HttpGet]
        public async Task<IActionResult> AssetOnHoldAssetAddCreate()
        {
            AssetOnHoldAssetAddCreateViewModel assetOnHoldAssetAddCreateViewModel = new();

            var invAssetCategoryList = await _selectTcmPLRepository.InvItemTypeList(BaseSpTcmPLGet(), new ParameterSpTcmPL { });
            ViewData["AssetCategoryList"] = new SelectList(invAssetCategoryList, "DataValueField", "DataTextField");

            ViewData["AssetIdList"] = null;

            var invTransTypeList = await _selectTcmPLRepository.InvActionTypeList(BaseSpTcmPLGet(), new ParameterSpTcmPL { });
            ViewData["ActionTypeList"] = new SelectList(invTransTypeList, "DataValueField", "DataTextField", ConstAssetOnHold);

            var dmsEmployeeList = await
            _selectTcmPLRepository.EmployeeListForHRAsync(BaseSpTcmPLGet(), null);
            ViewData["EmpList"] = new SelectList(dmsEmployeeList, "DataValueField", "DataTextField");

            var sourceDeskList = await _selectTcmPLRepository.InvDesk4AssetOnHoldList(
            BaseSpTcmPLGet(), new ParameterSpTcmPL { });
            ViewData["DeskIdList"] = new SelectList(sourceDeskList, "DataValueField", "DataTextField", assetOnHoldAssetAddCreateViewModel.DeskId);

            var assignList = await _selectTcmPLRepository.SWPCostCodeList4AdminAsync(
            BaseSpTcmPLGet(), new ParameterSpTcmPL { });
            ViewData["AssignList"] = new SelectList(assignList, "DataValueField", "DataTextField");

            assetOnHoldAssetAddCreateViewModel.ActionType = ConstAssetOnHold;

            return PartialView("_ModalAssetOnHoldAssetAddCreatePartial", assetOnHoldAssetAddCreateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> AssetOnHoldAssetAddCreate([FromForm] AssetOnHoldAssetAddCreateViewModel assetOnHoldAssetAddCreateViewModel)
        {
            try
            {
                if (string.IsNullOrEmpty(assetOnHoldAssetAddCreateViewModel.Empno))
                {
                    assetOnHoldAssetAddCreateViewModel.Empno = "NULL";
                }

                if (ModelState.IsValid)
                {
                    var result = await _assetOnHoldAssetAddRepository.DmAssetAddCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PAssetId = assetOnHoldAssetAddCreateViewModel.AssetId,
                            PDeskid = assetOnHoldAssetAddCreateViewModel.DeskId,
                            PEmpno = assetOnHoldAssetAddCreateViewModel.Empno,
                            PRemarks = assetOnHoldAssetAddCreateViewModel.Remarks,
                            PAssignCode = assetOnHoldAssetAddCreateViewModel.AssignCode,
                            PActionType = decimal.Parse(assetOnHoldAssetAddCreateViewModel.ActionType),
                        });

                    return result.PMessageType != IsOk ? throw new
                    Exception(result.PMessageText.Replace("-", " ")) : (IActionResult)Json(new
                    {
                        success = true,
                        response = result.PMessageText
                    });
                }
            }
            catch (Exception ex)
            {
                return
                    StatusCode((int)HttpStatusCode.InternalServerError,
                    StringHelper.CleanExceptionMessage(ex.Message));
            }

            var invTransTypeList = await
             _selectTcmPLRepository.InvItemAddonTypeList(BaseSpTcmPLGet(), null);
            ViewData["ActionTypeList"] = new SelectList(invTransTypeList, "DataValueField", "DataTextField", assetOnHoldAssetAddCreateViewModel.ActionType);

            var dmsEmployeeList = await
            _selectTcmPLRepository.EmployeeListForHRAsync(BaseSpTcmPLGet(), null);
            ViewData["EmpList"] = new SelectList(dmsEmployeeList, "DataValueField", "DataTextField", assetOnHoldAssetAddCreateViewModel.Empno);

            var invItemTypeFullList = await _selectTcmPLRepository.InvItemTypeAssetFullList(
            BaseSpTcmPLGet(), new ParameterSpTcmPL { });
            ViewData["AssetIdList"] = new SelectList(invItemTypeFullList, "DataValueField", "DataTextField", assetOnHoldAssetAddCreateViewModel.AssetId);

            var sourceDeskList = await _selectTcmPLRepository.DMSAvailableDesksForGuestList(
            BaseSpTcmPLGet(), new ParameterSpTcmPL { });
            ViewData["DeskIdList"] = new SelectList(sourceDeskList, "DataValueField", "DataTextField", assetOnHoldAssetAddCreateViewModel.DeskId);

            var assignList = await _selectTcmPLRepository.SWPCostCodeList4AdminAsync(
            BaseSpTcmPLGet(), new ParameterSpTcmPL { });
            ViewData["AssignList"] = new SelectList(assignList, "DataValueField", "DataTextField", assetOnHoldAssetAddCreateViewModel.AssignCode);

            return PartialView("_ModalAssetOnHoldAssetAddCreatePartial", assetOnHoldAssetAddCreateViewModel);
        }

        public async Task<IActionResult> GetAssetList(string assetCategory)
        {
            try
            {
                if (string.IsNullOrEmpty(assetCategory))
                {
                    return NotFound();
                }

                var invAssetsList = (await _selectTcmPLRepository.InvAsset4AssetOnHoldList(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PItemTypeKeyId = assetCategory
                })).ToJson();

                return Json(invAssetsList);
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
            }

            return NotFound(); ;
        }

        [HttpGet]
        public async Task<IActionResult> RemoveAssetOnHold(string id)
        {
            if (string.IsNullOrEmpty(id))
            {
                return NotFound();
            }

            RemoveAssetOnHoldViewModel assetOnHoldAssetAddUpdateViewModel = new();

            var resultDetails = await _assetOnHoldAssetAddDetailRepository.DmAssetAddDetail(BaseSpTcmPLGet(),
                new ParameterSpTcmPL { PUnqid = id });

            if (resultDetails.PMessageType == "OK")
            {
                assetOnHoldAssetAddUpdateViewModel.AssetId = resultDetails.PAssetId;
                assetOnHoldAssetAddUpdateViewModel.AssetDesc = resultDetails.PAssetDesc;
                assetOnHoldAssetAddUpdateViewModel.DeskId = resultDetails.PDeskId;
                assetOnHoldAssetAddUpdateViewModel.AssignCode = resultDetails.PAssignDesc;
                assetOnHoldAssetAddUpdateViewModel.Remarks = resultDetails.PRemarks;
                if (string.IsNullOrEmpty(resultDetails.PEmpno) || resultDetails.PEmpno.Trim() == "NULL")
                {
                    resultDetails.PEmpno = "";
                    resultDetails.PEmpname = "";
                }

                assetOnHoldAssetAddUpdateViewModel.Empno = resultDetails.PEmpno;
                assetOnHoldAssetAddUpdateViewModel.Empname = resultDetails.PEmpname;

                assetOnHoldAssetAddUpdateViewModel.Unqid = id;
            }
            assetOnHoldAssetAddUpdateViewModel.ActionType = ConstInService;

            var invTransTypeList = await
            _selectTcmPLRepository.InvActionTypeList(BaseSpTcmPLGet(), null);
            ViewData["ActionTypeList"] = new SelectList(invTransTypeList, "DataValueField", "DataTextField", ConstInService);

            var assignList = await _selectTcmPLRepository.SWPCostCodeList4AdminAsync(
            BaseSpTcmPLGet(), new ParameterSpTcmPL { });
            ViewData["AssignList"] = new SelectList(assignList, "DataValueField", "DataTextField", assetOnHoldAssetAddUpdateViewModel.AssignCode);

            return PartialView("_ModalRemoveAssetOnHoldPartial", assetOnHoldAssetAddUpdateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> RemoveAssetOnHold([FromForm] RemoveAssetOnHoldViewModel assetOnHoldAssetAddUpdateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _assetOnHoldAssetAddRepository.DmAssetAddEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PUnqid = assetOnHoldAssetAddUpdateViewModel.Unqid,
                            PAssetId = assetOnHoldAssetAddUpdateViewModel.AssetId,
                            PDeskid = assetOnHoldAssetAddUpdateViewModel.DeskId,
                            PEmpno = assetOnHoldAssetAddUpdateViewModel.Empno,
                            PActionType = decimal.Parse(assetOnHoldAssetAddUpdateViewModel.ActionType),
                            PAssignCode = assetOnHoldAssetAddUpdateViewModel.AssignCode,
                            PRemarks = assetOnHoldAssetAddUpdateViewModel.Remarks,
                        });

                    return result.PMessageType != IsOk ? throw new
                    Exception(result.PMessageText.Replace("-", " ")) : (IActionResult)Json(new
                    {
                        success =
                    true,
                        response = result.PMessageText
                    });
                }
            }
            catch (Exception ex)
            {
                return
                    StatusCode((int)HttpStatusCode.InternalServerError,
                    StringHelper.CleanExceptionMessage(ex.Message));
            }

            var invTransTypeList = await
            _selectTcmPLRepository.InvActionTypeList(BaseSpTcmPLGet(), null);
            ViewData["ActionTypeList"] = new SelectList(invTransTypeList, "DataValueField", "DataTextField", ConstInService);

            var assignList = await _selectTcmPLRepository.SWPCostCodeList4AdminAsync(
            BaseSpTcmPLGet(), new ParameterSpTcmPL { });
            ViewData["AssignList"] = new SelectList(assignList, "DataValueField", "DataTextField", assetOnHoldAssetAddUpdateViewModel.AssignCode);

            return PartialView("_ModalRemoveAssetOnHoldPartial", assetOnHoldAssetAddUpdateViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsAssetOnHoldDetail(DTParameters param)
        {
            DTResult<AssetOnHoldAssetAddDataTableList> result = new();
            int totalRow = 0;

            try
            {
                System.Collections.Generic.IEnumerable<AssetOnHoldAssetAddDataTableList> data = await
            _assetOnHoldAssetAddDataTableListRepository.AssetOnHoldAssetAddDataTableListAsync(
            BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
                PTransId = param.TransId,
                PGenericSearch = param.GenericSearch ?? " ",
                PRowNumber = param.Start,
                PPageLength = param.Length
            });

                if (data.Any()) { totalRow = (int)data.FirstOrDefault().TotalRow.Value; }

                result.draw = param.Draw; result.recordsTotal = totalRow; result.recordsFiltered =
                totalRow; result.data = data.ToList();

                return Json(result);
            }
            catch (Exception ex)
            {
                return Json(new { error = ex.Message });
            }
        }

        public async Task<IActionResult> XLDownloadAssetOnHoldFilterGet()
        {
            var invAssetCategoryList = await _selectTcmPLRepository.InvItemTypeList(BaseSpTcmPLGet(), new ParameterSpTcmPL { });
            ViewData["AssetCategoryList"] = new SelectList(invAssetCategoryList, "DataValueField", "DataTextField");

            var invTransTypeList = await _selectTcmPLRepository.InvActionTypeList(BaseSpTcmPLGet(), new ParameterSpTcmPL { });
            ViewData["ActionTypeList"] = new SelectList(invTransTypeList, "DataValueField", "DataTextField", ConstAssetOnHold);

            FilterDataModel filterDataModel = new FilterDataModel();

            return PartialView("_ModalXLDownloadAssetOnHoldFilterGet", filterDataModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> XLDownloadAssetOnHold(string actionType, string assetCategory)
        {
            try
            {
                string StrFimeName;
                //string strAssignCSV = assign.Length > 0 ? string.Join(',', assign) : string.Empty;

                decimal? actionTypeVal = null;
                if (!string.IsNullOrEmpty(actionType))
                {
                    actionTypeVal = decimal.Parse(actionType);
                }

                string assetCategoryVal = " ";
                if (!string.IsNullOrEmpty(assetCategory))
                {
                    assetCategoryVal = assetCategory;
                }

                var timeStamp = DateTime.Now.ToFileTime();
                StrFimeName = "AssetOnHold_" + timeStamp.ToString();

                var data = await _assetOnHoldAssetAddDataTableListRepository.AssetOnHoldAssetAddXLDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PActionType = actionTypeVal,
                        PAssetCategory = assetCategoryVal,
                        PRowNumber = 0,
                        PPageLength = 0
                    });

                if (data == null) { return NotFound(); }

                var json = JsonConvert.SerializeObject(data);

                IEnumerable<AssetOnHoldAssetAddDataTableListExcel> excelData = JsonConvert.DeserializeObject<IEnumerable<AssetOnHoldAssetAddDataTableListExcel>>(json);

                var byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, "Asset On Hold", "AssetOnHold");

                return File(byteContent,
                            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                            StrFimeName + ".xlsx");
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        //XLDownloadAssetOnHoldFilterGet

        //XLDownloadAssetOnHold

        //[HttpGet]
        //public async Task<IActionResult> AssetOnHoldAdd(string id)
        //{
        //    AssetOnHoldAddViewModel invAssetOnHoldAddViewModel = new();

        // var invItemTypeFullList = await _selectTcmPLRepository.InvItemTypeAssetFullList(
        // BaseSpTcmPLGet(), new ParameterSpTcmPL { }); ViewData["ItemTypeFullList"] = new
        // SelectList(invItemTypeFullList, "DataValueField", "DataTextField");

        // AssetOnHoldDetails assetOnHoldDetails = await
        // _invAssetOnHoldDetailsRepository.AssetOnHoldDetails( BaseSpTcmPLGet(), new
        // ParameterSpTcmPL { PTransId = id });

        // invAssetOnHoldAddViewModel.TransId = id; invAssetOnHoldAddViewModel.Empno =
        // assetOnHoldDetails.PEmpno + " - " + assetOnHoldDetails.PEmpName;

        //    return PartialView("_ModalAssetOnHoldAddPartial", invAssetOnHoldAddViewModel);
        //}

        //[HttpPost]
        //[ValidateAntiForgeryToken]
        //public async Task<IActionResult> AssetOnHoldAdd([FromForm] AssetOnHoldAddViewModel invAssetOnHoldAddViewModel)
        //{
        //    try
        //    {
        //        if (ModelState.IsValid)
        //        {
        //            var result = await _invAssetOnHoldRepository.AssetOnHoldCreateAsync(
        //                BaseSpTcmPLGet(),
        //                new ParameterSpTcmPL
        //                {
        //                    PTransId = invAssetOnHoldAddViewModel.TransId,
        //                    PItemId = invAssetOnHoldAddViewModel.ItemId,
        //                    PItemUsable = "Y",
        //                });

        // return RedirectToAction("AssetOnHoldAdd", new { id = invAssetOnHoldAddViewModel.TransId
        // }); //return result.PMessageType != Success // ? throw new
        // Exception(result.PMessageText.Replace("-", " ")) // : (IActionResult)Json(new { success =
        // true, response = result.PMessageText }); } } catch (Exception ex) { return
        // StatusCode((int)HttpStatusCode.InternalServerError,
        // StringHelper.CleanExceptionMessage(ex.Message)); }

        // var invItemTypeFullList = await _selectTcmPLRepository.InvItemTypeAssetFullList(
        // BaseSpTcmPLGet(), new ParameterSpTcmPL { }); ViewData["ItemTypeFullList"] = new
        // SelectList(invItemTypeFullList, "DataValueField", "DataTextField");

        //    return PartialView("_ModalAssetOnHoldAddPartial", invAssetOnHoldAddViewModel);
        //}

        //[HttpGet]
        //public async Task<IActionResult> AssetOnHoldReturnAdd(string id, string parameter)
        //{
        //    AssetOnHoldReturnAddViewModel invAssetOnHoldReturnAddViewModel = new();

        // var returnItemList = await _selectTcmPLRepository.InvReturnItemList( BaseSpTcmPLGet(),
        // new ParameterSpTcmPL { PEmpno = id }); ViewData["ReturnItemList"] = new
        // SelectList(returnItemList, "DataValueField", "DataTextField");

        // AssetOnHoldDetails assetOnHoldDetails = await
        // _invAssetOnHoldDetailsRepository.AssetOnHoldDetails( BaseSpTcmPLGet(), new
        // ParameterSpTcmPL { PTransId = parameter });

        // invAssetOnHoldReturnAddViewModel.TransId = parameter;
        // invAssetOnHoldReturnAddViewModel.TransTypeId = assetOnHoldDetails.PTransTypeId;
        // invAssetOnHoldReturnAddViewModel.Empno = assetOnHoldDetails.PEmpno;
        // invAssetOnHoldReturnAddViewModel.EmpName = assetOnHoldDetails.PEmpno + " - " + assetOnHoldDetails.PEmpName;

        //    return PartialView("_ModalAssetOnHoldReturnAddPartial", invAssetOnHoldReturnAddViewModel);
        //}

        //[HttpPost]
        //[ValidateAntiForgeryToken]
        //public async Task<IActionResult> AssetOnHoldReturnAdd([FromForm] AssetOnHoldReturnAddViewModel invAssetOnHoldReturnAddViewModel)
        //{
        //    try
        //    {
        //        if (ModelState.IsValid)
        //        {
        //            var result = await _invAssetOnHoldRepository.AssetOnHoldCreateAsync(
        //                BaseSpTcmPLGet(),
        //                new ParameterSpTcmPL
        //                {
        //                    PTransId = invAssetOnHoldReturnAddViewModel.TransId,
        //                    PEmpno = invAssetOnHoldReturnAddViewModel.Empno,
        //                    PTransTypeId = invAssetOnHoldReturnAddViewModel.TransTypeId,
        //                    PItemId = invAssetOnHoldReturnAddViewModel.ItemId,
        //                    PItemUsable = invAssetOnHoldReturnAddViewModel.ItemUsable,
        //                });
        //            return RedirectToAction("AssetOnHoldReturnAdd", new { id = invAssetOnHoldReturnAddViewModel.Empno, parameter = invAssetOnHoldReturnAddViewModel.TransId });

        // //return result.PMessageType != Success // ? throw new
        // Exception(result.PMessageText.Replace("-", " ")) // : (IActionResult)Json(new { success =
        // true, response = result.PMessageText }); } } catch (Exception ex) { return
        // StatusCode((int)HttpStatusCode.InternalServerError,
        // StringHelper.CleanExceptionMessage(ex.Message)); }

        // var returnItemList = await _selectTcmPLRepository.InvReturnItemList( BaseSpTcmPLGet(),
        // new ParameterSpTcmPL { PEmpno = invAssetOnHoldReturnAddViewModel.Empno });
        // ViewData["ReturnItemList"] = new SelectList(returnItemList, "DataValueField", "DataTextField");

        //    return PartialView("_ModalAssetOnHoldReturnAddPartial", invAssetOnHoldReturnAddViewModel);
        //}

        //[HttpPost]
        //public async Task<IActionResult> AssetOnHoldIssue(string id)
        //{
        //    try
        //    {
        //        var result = await _invAssetOnHoldRepository.AssetOnHoldIssueAsync(
        //            BaseSpTcmPLGet(),
        //            new ParameterSpTcmPL
        //            {
        //                PTransId = id,
        //                PTransTypeId = ConstPTransTypeIdIssue
        //            }
        //            );

        //        return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
        //    }
        //    catch (Exception ex)
        //    {
        //        return Json(new { success = false, response = ex.Message });
        //    }
        //}

        //[HttpPost]
        //public async Task<IActionResult> AssetOnHoldDelete(string id)
        //{
        //    try
        //    {
        //        var result = await _invAssetOnHoldRepository.AssetOnHoldDeleteAsync(
        //            BaseSpTcmPLGet(),
        //            new ParameterSpTcmPL
        //            {
        //                PTransId = id
        //            }
        //            );

        //        return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
        //    }
        //    catch (Exception ex)
        //    {
        //        return Json(new { success = false, response = ex.Message });
        //    }
        //}

        //[HttpGet]
        //public async Task<IActionResult> AssetOnHoldEdit(string id)
        //{
        //    if (id == null)
        //    {
        //        return NotFound();
        //    }

        // var result = await _invAssetOnHoldDetailsRepository.AssetOnHoldDetails( BaseSpTcmPLGet(),
        // new ParameterSpTcmPL { PTransId = id });

        // AssetOnHoldUpdateViewModel invAssetOnHoldUpdateViewModel = new();

        // if (result.PMessageType == Success) { invAssetOnHoldUpdateViewModel.TransId = id;
        // invAssetOnHoldUpdateViewModel.TransDate = result.PTransDate;
        // invAssetOnHoldUpdateViewModel.Empno = result.PEmpno + " " + result.PEmpName;
        // invAssetOnHoldUpdateViewModel.Remarks = result.PRemarks; }

        //    return PartialView("_ModalAssetOnHoldEditPartial", invAssetOnHoldUpdateViewModel);
        //}

        //[HttpPost]
        //[ValidateAntiForgeryToken]
        //public async Task<IActionResult> AssetOnHoldEdit([FromForm] AssetOnHoldUpdateViewModel invAssetOnHoldUpdateViewModel)
        //{
        //    try
        //    {
        //        if (ModelState.IsValid)
        //        {
        //            var result = await _invAssetOnHoldRepository.AssetOnHoldEditAsync(
        //                BaseSpTcmPLGet(),
        //                new ParameterSpTcmPL
        //                {
        //                    PTransId = invAssetOnHoldUpdateViewModel.TransId,
        //                    PRemarks = invAssetOnHoldUpdateViewModel.Remarks
        //                });

        // return result.PMessageType != Success ? throw new
        // Exception(result.PMessageText.Replace("-", " ")) : (IActionResult)Json(new { success =
        // true, response = result.PMessageText }); } } catch (Exception ex) { return
        // StatusCode((int)HttpStatusCode.InternalServerError,
        // StringHelper.CleanExceptionMessage(ex.Message)); }

        //    return PartialView("_ModalAssetOnHoldEditPartial", invAssetOnHoldUpdateViewModel);
        //}

        //[HttpPost]
        //public async Task<IActionResult> AssetOnHoldDetailDelete(string id)
        //{
        //    try
        //    {
        //        var result = await _invAssetOnHoldRepository.AssetOnHoldDetailDeleteAsync(
        //            BaseSpTcmPLGet(),
        //            new ParameterSpTcmPL
        //            {
        //                PTransId = id.Split("!-!")[0],
        //                PTransDetId = id.Split("!-!")[1],
        //                PTransTypeDesc = id.Split("!-!")[2]
        //            });

        //        return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
        //    }
        //    catch (Exception ex)
        //    {
        //        return Json(new { success = false, response = ex.Message });
        //    }
        //}

        //[HttpGet]
        //public async Task<IActionResult> GetItem(string id)
        //{
        //    if (id == null)
        //    {
        //        return NotFound();
        //    }

        // var itemList = await _selectTcmPLRepository.InvItemList( BaseSpTcmPLGet(), new
        // ParameterSpTcmPL { PItemTypeKeyId = id });

        //    return Json(itemList);
        //}

        //[HttpGet]
        //public async Task<IActionResult> GetReturnItem(string id)
        //{
        //    if (id == null)
        //    {
        //        return NotFound();
        //    }

        // var returnItemList = await _selectTcmPLRepository.InvReturnItemList( BaseSpTcmPLGet(),
        // new ParameterSpTcmPL { PEmpno = id });

        //    return Json(returnItemList);
        //}

        //[HttpGet]
        //public async Task<IActionResult> AssetOnHoldGatePassGenerate(string id)
        //{
        //    try
        //    {
        //        string strFileName;
        //        strFileName = "Gate Pass ";
        //        MemoryStream outputStream = new MemoryStream();

        // AssetOnHoldDetails assetOnHoldDetails = await
        // _invAssetOnHoldDetailsRepository.AssetOnHoldDetails( BaseSpTcmPLGet(), new
        // ParameterSpTcmPL { PTransId = id });

        // if (assetOnHoldDetails == null) return NotFound();

        // System.Collections.Generic.IEnumerable<AssetOnHoldDetailDataTableList>
        // invAssetOnHoldDetailDetails = await
        // _invAssetOnHoldDetailDataTableListRepository.AssetOnHoldDetailDataTableListAsync(
        // BaseSpTcmPLGet(), new ParameterSpTcmPL { PTransId = id } );

        // if (invAssetOnHoldDetailDetails == null) return NotFound();

        // var baseRepository = _configuration["TCMPLAppBaseRepository"]; var areaRepository =
        // _configuration["AreaRepository:DeskManagement"]; var folder =
        // Path.Combine(baseRepository, areaRepository); string docPath = Path.Combine(folder, "LetterTemplate.docx");

        // int[,] aryTable1 = new int[,] { { 3, 5 }, { 1, 2 } }; int[,] aryTab1Val = new int[,] { {
        // 0, 24 }, { 1, 2 } };

        // int[,] aryTable2 = new int[,] { { 0, 0, 0 }, { 3, 4, 5 }, { 6, 7, 8 }, { 9, 10, 11 }, {
        // 12, 13, 14 }, { 15, 16, 17 }, { 18, 19, 20 }, { 21, 22, 23 } };

        // byte[] templateBytes = System.IO.File.ReadAllBytes(docPath);

        // using (MemoryStream templateStream = new MemoryStream()) {
        // templateStream.Write(templateBytes, 0, templateBytes.Length); using
        // (WordprocessingDocument doc = WordprocessingDocument.Open(templateStream, true)) { Table
        // table1 = doc.MainDocumentPart.Document.Body.Elements<Table>().First();

        // for (int i = 0; i <= 1; i++) { TableRow row = table1.Elements<TableRow>().ElementAt(i);
        // for (int j = 0; j < aryTable1.GetLength(i); j++) { TableCell cell =
        // row.Elements<TableCell>().ElementAt(aryTable1[i, j]); Paragraph p =
        // cell.Elements<Paragraph>().First(); DocumentFormat.OpenXml.Drawing.Run r =
        // p.Elements<DocumentFormat.OpenXml.Drawing.Run>().First();
        // DocumentFormat.OpenXml.Drawing.Text t =
        // r.Elements<DocumentFormat.OpenXml.Drawing.Text>().First(); if (i == 0) { if (j == 0)
        // t.Text = assetOnHoldDetails.PGatePassRefNo; else if (j == 1) t.Text =
        // assetOnHoldDetails.PTransDate?.ToString("dd-MMM-yyyy"); } else if (i == 1 && j == 0)
        // t.Text = assetOnHoldDetails.PEmpno + " - " + assetOnHoldDetails.PEmpName; } }

        // Table table2 = doc.MainDocumentPart.Document.Body.Elements<Table>().Last();

        // for (int i = 1; i <= invAssetOnHoldDetailDetails.Count(); i++) { TableRow row =
        // table2.Elements<TableRow>().ElementAt(i); if (invAssetOnHoldDetailDetails.Count() > 7) {
        // if (i > 6) { TableRow r = (TableRow)row.Clone(); table2.AppendChild(r); } } for (int j =
        // 0; j < 3; j++) { TableCell cell = row.Elements<TableCell>().ElementAt(j); Paragraph p =
        // cell.Elements<Paragraph>().First(); DocumentFormat.OpenXml.Drawing.Run r =
        // p.Elements<DocumentFormat.OpenXml.Drawing.Run>().First();
        // DocumentFormat.OpenXml.Drawing.Text t =
        // r.Elements<DocumentFormat.OpenXml.Drawing.Text>().First(); if (j == 0) t.Text =
        // invAssetOnHoldDetailDetails.ElementAt(i - 1).ItemTypeDesc; else if (j == 1) t.Text =
        // invAssetOnHoldDetailDetails.ElementAt(i - 1).ItemId; else if (j == 2) t.Text =
        // invAssetOnHoldDetailDetails.ElementAt(i - 1).ItemDetails; } }

        // doc.Clone(outputStream); }

        // strFileName = strFileName + assetOnHoldDetails.PGatePassRefNo.ToString() + ".docx";

        //            return File(outputStream.ToArray(),
        //                    "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
        //                    strFileName);
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
        //    }
        //}

        //public async Task<IActionResult> AssetOnHoldExcelDownload()
        //{
        //    try
        //    {
        //        var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
        //        {
        //            PModuleName = CurrentUserIdentity.CurrentModule,
        //            PMetaId = CurrentUserIdentity.MetaId,
        //            PPersonId = CurrentUserIdentity.EmployeeId,
        //            PMvcActionName = ConstFilterAssetOnHoldIndex
        //        });
        //        FilterDataModel filterDataModel = new FilterDataModel();
        //        if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
        //            filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

        // string StrFimeName;

        // var timeStamp = DateTime.Now.ToFileTime(); StrFimeName = "AssetOnHold_" + timeStamp.ToString();

        // string strUser = User.Identity.Name;

        // IEnumerable<AssetOnHoldDataTableListExcel> data = await
        // _invAssetOnHoldDataTableListExcelRepository.AssetOnHoldDataTableListForExcelAsync(
        // BaseSpTcmPLGet(), new ParameterSpTcmPL { });

        // if (data == null) { return NotFound(); }

        // byte[] byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(data,
        // "AssetOnHolds", "AssetOnHolds");

        //        return File(byteContent,
        //                    "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
        //                    StrFimeName + ".xlsx");
        //    }
        //    catch (Exception ex)
        //    {
        //        return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
        //    }
        //}

        #endregion AssetOnHoldIndex
    }
}