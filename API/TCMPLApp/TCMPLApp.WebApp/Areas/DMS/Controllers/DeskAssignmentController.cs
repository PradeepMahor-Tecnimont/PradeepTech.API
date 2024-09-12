using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Newtonsoft.Json;
using NuGet.Protocol;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.Common;
using TCMPLApp.DataAccess.Repositories.DMS;
using TCMPLApp.DataAccess.Repositories.SWPVaccine;
using TCMPLApp.Domain.Models.DMS;
using TCMPLApp.WebApp.Classes;
using TCMPLApp.WebApp.Controllers;
using TCMPLApp.WebApp.CustomPolicyProvider;
using TCMPLApp.WebApp.Models;

namespace TCMPLApp.WebApp.Areas.DMS.Controllers
{
    [Authorize]
    [Area("DMS")]
    public class DeskAssignmentController : BaseController
    {
        private readonly IEmployeeDetailsRepository _employeeDetailsRepository;

        private readonly IEmployeeAssetsDataTableListRepository _employeeAssetsDataTableListRepository;
        private readonly IDeskAsgmtMasterDetailRepository _deskAsgmtMasterDetailRepository;
        private readonly IAssetsOnDeskDataTableListRepository _assetsOnDeskDataTableListRepository;
        private readonly IAssetsOnDeskRepository _assetsOnDeskRepository;
        private readonly ISelectTcmPLRepository _selectTcmPLRepository;
        private readonly ICommonEmployeeDetailsRepository _commonEmployeeDetailsRepository;
        private readonly IDeskAndEmpDetailDataTableListRepository _deskAndEmpDetailDataTableListRepository;

        public DeskAssignmentController(IEmployeeDetailsRepository employeeDetailsRepository,
            IDMSEmployeeRepository dmsEmployeeRepository,
            IDeskMasterRepository deskMasterRepository,
            IDeskMasterViewRepository deskMasterViewRepository,
            IDeskMasterDataTableListRepository deskMasterDataTableListRepository,
            IDeskAsgmtMasterDetailRepository deskAsgmtMasterDetailRepository,
            IEmployeeAssetsDataTableListRepository employeeAssetsDataTableListRepository,
            IAssetsOnDeskDataTableListRepository assetsOnDeskDataTableListRepository,
            IAssetsOnDeskRepository assetsOnDeskRepository,
            ISelectTcmPLRepository selectTcmPLRepository,
            ICommonEmployeeDetailsRepository commonEmployeeDetailsRepository,
            IDeskAndEmpDetailDataTableListRepository deskAndEmpDetailDataTableListRepository
            )
        {
            _employeeDetailsRepository = employeeDetailsRepository;
            _deskAsgmtMasterDetailRepository = deskAsgmtMasterDetailRepository;
            _employeeAssetsDataTableListRepository = employeeAssetsDataTableListRepository;
            _assetsOnDeskDataTableListRepository = assetsOnDeskDataTableListRepository;
            _assetsOnDeskRepository = assetsOnDeskRepository;
            _selectTcmPLRepository = selectTcmPLRepository;
            _commonEmployeeDetailsRepository = commonEmployeeDetailsRepository;
            _deskAndEmpDetailDataTableListRepository = deskAndEmpDetailDataTableListRepository;
        }

        //[HttpGet]
        //[RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DMSHelper.ActionITAdm)]
        //public async Task<IActionResult> DeskAssignmentIndex(string search)
        //{
        //    DeskAssignmentViewModel deskAssignmentViewModel = new DeskAssignmentViewModel();

        //    try
        //    {
        //        if (!string.IsNullOrEmpty(search))
        //        {
        //            deskAssignmentViewModel.SearchByDeskNoOrEmp = search;
        //            var result = await _deskAsgmtMasterDetailRepository.DeskAsgmtMasterDetail(
        //                      BaseSpTcmPLGet(),
        //                      new ParameterSpTcmPL
        //                      {
        //                          PGenericSearch = deskAssignmentViewModel.SearchByDeskNoOrEmp.ToUpper()
        //                      });

        //            if (result.PMessageType == IsOk)
        //            {
        //                deskAssignmentViewModel.DeskNo = result.PDeskno;
        //                deskAssignmentViewModel.Emp1 = result.PEmp1;
        //                deskAssignmentViewModel.Emp2 = result.PEmp2;
        //                deskAssignmentViewModel.IsBlocked = result.PIsBlocked;
        //                deskAssignmentViewModel.BlockedReason = result.PBlockedReason;
        //            }
        //            else
        //            {
        //                deskAssignmentViewModel.DeskNo = "";
        //                deskAssignmentViewModel.Emp1 = "";
        //                deskAssignmentViewModel.Emp2 = "";
        //            }
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
        //    }

        //    return View(deskAssignmentViewModel);
        //}

        //[HttpPost]
        //[RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DMSHelper.ActionITAdm)]
        //public async Task<IActionResult> DeskAssignmentIndex([FromForm] DeskAssignmentViewModel deskAssignmentViewModel)
        //{
        //    try
        //    {
        //        if (!string.IsNullOrEmpty(deskAssignmentViewModel.SearchByDeskNoOrEmp))
        //        {
        //            var result = await _deskAsgmtMasterDetailRepository.DeskAsgmtMasterDetail(
        //                      BaseSpTcmPLGet(),
        //                      new ParameterSpTcmPL
        //                      {
        //                          PGenericSearch = deskAssignmentViewModel.SearchByDeskNoOrEmp
        //                      });

        //            if (result.PMessageType == IsOk)
        //            {
        //                deskAssignmentViewModel.DeskNo = result.PDeskno;
        //                deskAssignmentViewModel.Emp1 = result.PEmp1;
        //                deskAssignmentViewModel.Emp2 = result.PEmp2;
        //                deskAssignmentViewModel.IsBlocked = result.PIsBlocked;
        //                deskAssignmentViewModel.BlockedReason = result.PBlockedReason;
        //            }
        //            else
        //            {
        //                deskAssignmentViewModel.DeskNo = "";
        //                deskAssignmentViewModel.Emp1 = "";
        //                deskAssignmentViewModel.Emp2 = "";
        //            }
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
        //    }

        //    return View(deskAssignmentViewModel);
        //}

        public async Task<IActionResult> AssetsOnDeskIndexPartial(string id)
        {
            AssetsOnDeskViewModel assetsOnDeskViewModel = new();
            try
            {
                if (string.IsNullOrEmpty(id))
                {
                    return NotFound();
                }

                var result = await _deskAsgmtMasterDetailRepository.DeskAsgmtMasterDetail(
                                   BaseSpTcmPLGet(),
                                   new ParameterSpTcmPL
                                   {
                                       PGenericSearch = id
                                   });

                if (result.PMessageType == IsOk)
                {
                    assetsOnDeskViewModel.DeskNo = result.PDeskno;
                    assetsOnDeskViewModel.CabinDesk = result.PCabinDesk;
                    assetsOnDeskViewModel.Floor = result.PFloor;
                    assetsOnDeskViewModel.Office = result.POffice;
                    assetsOnDeskViewModel.Area = result.PArea;

                    var data = await _assetsOnDeskDataTableListRepository.AssetsOnDeskDataTableListAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PGenericSearch = result.PDeskno
                        });

                    assetsOnDeskViewModel.assetsOnDeskDataTableList = data;
                }
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
            }

            return PartialView("_AssetsOnDeskIndexPartial", assetsOnDeskViewModel);
        }

        public async Task<IActionResult> EmployeeAssetsIndexPartial(string id)
        {
            EmployeeAssetsViewModel employeeAssetsViewModel = new();
            try
            {
                if (string.IsNullOrEmpty(id))
                {
                    return NotFound();
                }

                var employeeDetail = await _commonEmployeeDetailsRepository.EmployeeDetailAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PEmpno = id
                    });

                var data = await _employeeAssetsDataTableListRepository.EmployeeAssetsDataTableListAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PGenericSearch = id
                        });

                employeeAssetsViewModel.Empno = employeeDetail.PForEmpno;
                employeeAssetsViewModel.Employee = employeeDetail.PName;
                employeeAssetsViewModel.Parent = employeeDetail.PParent;
                employeeAssetsViewModel.Assign = employeeDetail.PAssign;
                employeeAssetsViewModel.Grade = employeeDetail.PGrade;
                employeeAssetsViewModel.employeeAssetsDataTableList = data;
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
            }

            return PartialView("_EmployeeAssetsIndexPartial", employeeAssetsViewModel);
        }

        public async Task<IActionResult> AssetsOnDeskAdd(string deskno, string itemTypeCode)
        {
            AssetsOnDeskEditModel assetsOnDeskEditModel = new();

            try
            {
                if (string.IsNullOrEmpty(deskno) || string.IsNullOrEmpty(itemTypeCode))
                {
                    return NotFound();
                }

                assetsOnDeskEditModel.DeskNo = deskno;

                var invAssetCategoryList = await _selectTcmPLRepository.InvItemType4DeskList(BaseSpTcmPLGet(), new ParameterSpTcmPL
                {
                });

                string ItemTypeKey = invAssetCategoryList.Where(x => x.DataTextField.Substring(0, 2) == itemTypeCode).FirstOrDefault().DataValueField;

                ViewData["AssetCategoryList"] = new SelectList(invAssetCategoryList, "DataValueField", "DataTextField", ItemTypeKey);

                var invAssetsList = await _selectTcmPLRepository.InvItemAmsAssetMappingList(BaseSpTcmPLGet(), new ParameterSpTcmPL
                {
                    PItemTypeKeyId = ItemTypeKey
                });

                ViewData["AssetsList"] = new SelectList(invAssetsList, "DataValueField", "DataTextField");

                return PartialView("_ModalAssetsOnDeskAddPartial", assetsOnDeskEditModel);
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
            }

            return PartialView("_ModalAssetsOnDeskAddPartial", assetsOnDeskEditModel);
        }

        [HttpPost]
        public async Task<IActionResult> AssetsOnDeskAdd([FromForm] AssetsOnDeskEditModel assetsOnDeskEditModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _assetsOnDeskRepository.AddAssetsToDeskAsync(
                              BaseSpTcmPLGet(),
                              new ParameterSpTcmPL
                              {
                                  PDeskId = assetsOnDeskEditModel.DeskNo,
                                  PAssetId = assetsOnDeskEditModel.AssetId,
                              });

                    if (result.PMessageType == IsOk)
                    {
                        Notify("Success", result.PMessageText.Replace("-", " "), "toaster", NotificationType.success);
                    }
                    else
                    {
                        Exception exception = new Exception(result.PMessageText.Replace("-", " "));
                        throw exception;
                    }
                }
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
            }

            var invAssetCategoryList = await _selectTcmPLRepository.InvItemType4DeskList(BaseSpTcmPLGet(), null);
            ViewData["AssetCategoryList"] = new SelectList(invAssetCategoryList, "DataValueField", "DataTextField", assetsOnDeskEditModel.AssetCategory);
            ViewData["AssetsList"] = null;

            return PartialView("_ModalAssetsOnDeskAddPartial", assetsOnDeskEditModel);
        }

        public async Task<IActionResult> ReplaceAssetsFromDesk(string deskno, string itemTypeCode, string assetId, string itemdesc)
        {
            AssetsOnDeskEditModel assetsOnDeskEditModel = new();

            try
            {
                if (string.IsNullOrEmpty(deskno) || string.IsNullOrEmpty(itemTypeCode))
                {
                    return NotFound();
                }

                assetsOnDeskEditModel.DeskNo = deskno;
                assetsOnDeskEditModel.OldAssetDescription = itemdesc;
                assetsOnDeskEditModel.OldAssetId = assetId;

                var invAssetCategoryList = await _selectTcmPLRepository.InvItemTypeList(BaseSpTcmPLGet(), new ParameterSpTcmPL
                {
                    PItemTypeCode = itemTypeCode
                });

                string ItemTypeKey = invAssetCategoryList.FirstOrDefault().DataValueField;

                ViewData["AssetCategoryList"] = new SelectList(invAssetCategoryList, "DataValueField", "DataTextField", ItemTypeKey);

                var invAssetsList = await _selectTcmPLRepository.InvItemAmsAssetMappingList(BaseSpTcmPLGet(), new ParameterSpTcmPL
                {
                    PItemTypeKeyId = ItemTypeKey
                });

                ViewData["AssetsList"] = new SelectList(invAssetsList, "DataValueField", "DataTextField");

                return PartialView("_ModalAssetsOnDeskEditPartial", assetsOnDeskEditModel);
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
            }

            return PartialView("_ModalAssetsOnDeskEditPartial", assetsOnDeskEditModel);
        }

        [HttpPost]
        public async Task<IActionResult> ReplaceAssetsFromDesk([FromForm] AssetsOnDeskEditModel assetsOnDeskEditModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _assetsOnDeskRepository.ReplaceAssetsFromDeskAsync(
                              BaseSpTcmPLGet(),
                              new ParameterSpTcmPL
                              {
                                  PDeskId = assetsOnDeskEditModel.DeskNo,
                                  PAssetId = assetsOnDeskEditModel.AssetId,
                                  POldAssetId = assetsOnDeskEditModel.OldAssetId,
                              });

                    if (result.PMessageType == IsOk)
                    {
                        Notify("Success", result.PMessageText.Replace("-", " "), "toaster", NotificationType.success);
                    }
                    else
                    {
                        Exception exception = new Exception(result.PMessageText.Replace("-", " "));
                        throw exception;
                    }
                }
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
            }

            var invAssetCategoryList = await _selectTcmPLRepository.InvItemTypeList(BaseSpTcmPLGet(), null);
            ViewData["AssetCategoryList"] = new SelectList(invAssetCategoryList, "DataValueField", "DataTextField", assetsOnDeskEditModel.AssetCategory);
            ViewData["AssetsList"] = null;

            return PartialView("_ModalAssetsOnDeskEditPartial", assetsOnDeskEditModel);
        }

        public async Task<IActionResult> GetAssetList(string assetCategory)
        {
            try
            {
                if (string.IsNullOrEmpty(assetCategory))
                {
                    return NotFound();
                }

                var invAssetsList = (await _selectTcmPLRepository.InvItemAmsAssetMappingList(
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

            return NotFound();
        }

        public async Task<IActionResult> AddEmpToDesk(string deskno)
        {
            EmpToDeskCreateModel empToDeskCreateModel = new();

            try
            {
                if (string.IsNullOrEmpty(deskno))
                {
                    return NotFound();
                }

                empToDeskCreateModel.DeskNo = deskno;

                var dmsEmployeeList = await _selectTcmPLRepository.DmsEmp4AsgmtList(BaseSpTcmPLGet(), null);

                ViewData["EmployeeList"] = new SelectList(dmsEmployeeList, "DataValueField", "DataTextField");
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
            }

            return PartialView("_ModalAddEmpToDeskPartial", empToDeskCreateModel);
        }

        [HttpPost]
        public async Task<IActionResult> AddEmpToDesk([FromForm] EmpToDeskCreateModel empToDeskCreateModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _assetsOnDeskRepository.AddEmpToDeskAsync(
                              BaseSpTcmPLGet(),
                              new ParameterSpTcmPL
                              {
                                  PDeskId = empToDeskCreateModel.DeskNo,
                                  PEmpno = empToDeskCreateModel.Employee
                              });

                    if (result.PMessageType == IsOk)
                    {
                        Notify("Success", result.PMessageText.Replace("-", " "), "toaster", NotificationType.success);
                    }
                    else
                    {
                        Exception exception = new Exception(result.PMessageText.Replace("-", " "));
                        throw exception;
                    }
                }
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
            }

            var dmsEmployeeList = await _selectTcmPLRepository.EmployeeListForHRAsync(BaseSpTcmPLGet(), null);
            ViewData["EmployeeList"] = new SelectList(dmsEmployeeList, "DataValueField", "DataTextField");

            return PartialView("_ModalAddEmpToDeskPartial", empToDeskCreateModel);
        }

        [HttpPost]
        public async Task<IActionResult> DeleteEmpFromDesk(string deskno, string empno, string costcode)
        {
            try
            {
                var result = await _assetsOnDeskRepository.DeleteEmpFromDeskAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL { PDeskId = deskno, PEmpno = empno, PCostcode = costcode }
                    );

                if (result.PMessageType == IsOk)
                {
                    Notify("Success", result.PMessageText.Replace("-", " "), "toaster", NotificationType.success);
                }
                else
                {
                    Exception exception = new Exception(result.PMessageText.Replace("-", " "));
                    throw exception;
                }

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        [HttpPost]
        public async Task<IActionResult> DeleteAssetsFromDesk(string deskno, string assetid)
        {
            try
            {
                var result = await _assetsOnDeskRepository.DeleteAssetsFromDeskAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL { PDeskId = deskno, PAssetId = assetid }
                    );

                if (result.PMessageType == IsOk)
                {
                    Notify("Success", result.PMessageText.Replace("-", " "), "toaster", NotificationType.success);
                }
                else
                {
                    Exception exception = new Exception(result.PMessageText.Replace("-", " "));
                    throw exception;
                }

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        #region Desk Details for Help Desk Engg [Search by DeskNo/Empno]

        //[HttpGet]
        //public async Task<IActionResult> DeskAssignmentIndexReadonly(string search)
        //{
        //    DeskAssignmentViewModel deskAssignmentViewModel = new DeskAssignmentViewModel();

        //    try
        //    {
        //        if (!string.IsNullOrEmpty(search))
        //        {
        //            deskAssignmentViewModel.SearchByDeskNoOrEmp = search;
        //            var result = await _deskAsgmtMasterDetailRepository.DeskAsgmtMasterForEnggDetail(
        //                      BaseSpTcmPLGet(),
        //                      new ParameterSpTcmPL
        //                      {
        //                          PGenericSearch = deskAssignmentViewModel.SearchByDeskNoOrEmp.ToUpper()
        //                      });

        //            if (result.PMessageType == IsOk)
        //            {
        //                deskAssignmentViewModel.DeskNo = result.PDeskno;
        //                deskAssignmentViewModel.Emp1 = result.PEmp1;
        //                deskAssignmentViewModel.Emp2 = result.PEmp2;
        //                deskAssignmentViewModel.IsBlocked = result.PIsBlocked;
        //                deskAssignmentViewModel.BlockedReason = result.PBlockedReason;
        //            }
        //            else
        //            {
        //                deskAssignmentViewModel.DeskNo = "";
        //                deskAssignmentViewModel.Emp1 = "";
        //                deskAssignmentViewModel.Emp2 = "";
        //            }
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
        //    }

        //    return View(deskAssignmentViewModel);
        //}

        //[HttpPost]
        //public async Task<IActionResult> DeskAssignmentIndexReadonly([FromForm] DeskAssignmentViewModel deskAssignmentViewModel)
        //{
        //    try
        //    {
        //        if (!string.IsNullOrEmpty(deskAssignmentViewModel.SearchByDeskNoOrEmp))
        //        {
        //            var result = await _deskAsgmtMasterDetailRepository.DeskAsgmtMasterForEnggDetail(
        //                      BaseSpTcmPLGet(),
        //                      new ParameterSpTcmPL
        //                      {
        //                          PGenericSearch = deskAssignmentViewModel.SearchByDeskNoOrEmp
        //                      });

        //            if (result.PMessageType == IsOk)
        //            {
        //                deskAssignmentViewModel.DeskNo = result.PDeskno;
        //                deskAssignmentViewModel.Emp1 = result.PEmp1;
        //                deskAssignmentViewModel.Emp2 = result.PEmp2;
        //                deskAssignmentViewModel.IsBlocked = result.PIsBlocked;
        //                deskAssignmentViewModel.BlockedReason = result.PBlockedReason;
        //            }
        //            else
        //            {
        //                var employeeDetail = await _employeeDetailsRepository.GetEmployeeDetailsAsync(deskAssignmentViewModel.SearchByDeskNoOrEmp);

        //                if (employeeDetail != null)
        //                {
        //                    deskAssignmentViewModel.Emp1 = employeeDetail.Empno;
        //                }
        //                else
        //                {
        //                    deskAssignmentViewModel.Emp1 = "";
        //                }

        //                deskAssignmentViewModel.DeskNo = "";
        //                deskAssignmentViewModel.Emp2 = "";
        //            }
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
        //    }

        //    return View(deskAssignmentViewModel);
        //}

        public async Task<IActionResult> AssetsOnDeskIndexPartialReadonly(string id)
        {
            AssetsOnDeskViewModel assetsOnDeskViewModel = new();
            try
            {
                if (string.IsNullOrEmpty(id))
                {
                    return NotFound();
                }

                var result = await _deskAsgmtMasterDetailRepository.DeskAsgmtMasterForEnggDetail(
                                   BaseSpTcmPLGet(),
                                   new ParameterSpTcmPL
                                   {
                                       PGenericSearch = id
                                   });

                if (result.PMessageType == IsOk)
                {
                    assetsOnDeskViewModel.DeskNo = result.PDeskno;
                    assetsOnDeskViewModel.CabinDesk = result.PCabinDesk;
                    assetsOnDeskViewModel.Floor = result.PFloor;
                    assetsOnDeskViewModel.Office = result.POffice;
                    assetsOnDeskViewModel.Area = result.PArea;

                    var data = await _assetsOnDeskDataTableListRepository.AssetsOnDeskForEnggDataTableListAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PGenericSearch = result.PDeskno
                        });

                    assetsOnDeskViewModel.assetsOnDeskDataTableList = data;
                }
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
            }

            return PartialView("_AssetsOnDeskIndexReadonlyPartial", assetsOnDeskViewModel);
        }

        public async Task<IActionResult> EmployeeAssetsIndexPartialReadonly(string id)
        {
            EmployeeAssetsViewModel employeeAssetsViewModel = new();
            try
            {
                if (string.IsNullOrEmpty(id))
                {
                    return NotFound();
                }

                var employeeDetail = await _commonEmployeeDetailsRepository.EmployeeDetailAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PEmpno = id
                    });

                var data = await _employeeAssetsDataTableListRepository.EmployeeAssetsForEnggDataTableListAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PGenericSearch = id
                        });

                employeeAssetsViewModel.Empno = employeeDetail.PForEmpno;
                employeeAssetsViewModel.Employee = employeeDetail.PName;
                employeeAssetsViewModel.Parent = employeeDetail.PParent;
                employeeAssetsViewModel.Assign = employeeDetail.PAssign;
                employeeAssetsViewModel.Grade = employeeDetail.PGrade;
                employeeAssetsViewModel.employeeAssetsDataTableList = data;
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
            }

            return PartialView("_EmployeeAssetsIndexReadonlyPartial", employeeAssetsViewModel);
        }

        #endregion Desk Details for Help Desk Engg [Search by DeskNo/Empno]

        #region Desk + Emp details

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DMSHelper.ActionITAdm)]
        public async Task<IActionResult> DeskAssignmentNewIndex(string search)
        {
            DeskAssignmentNewViewModel deskAssignmentViewModel = new DeskAssignmentNewViewModel();

            deskAssignmentViewModel.SearchByDeskNoOrEmpNo = search;

            DeskTileViewModel deskTileViewModel = new();
            DeskAndEmpDetails deskAndEmpDetails = new();
            var employee1TileViewModel = new EmployeeTileViewModel();
            var employee2TileViewModel = new EmployeeTileViewModel();

            Models.DeskDetailHeaderFields deskDetailHeaderFields = new();
            Models.EmployeeDetailHeaderFields employee1DetailHeaderFields = new();
            Models.EmployeeDetailHeaderFields employee2DetailHeaderFields = new();

            employee1TileViewModel.EmployeeDetailHeaderFields = employee1DetailHeaderFields;
            employee2TileViewModel.EmployeeDetailHeaderFields = employee2DetailHeaderFields;
            deskTileViewModel.DeskDetailHeaderFields = deskDetailHeaderFields;

            deskAssignmentViewModel.DeskTileViewModel = deskTileViewModel;
            deskAssignmentViewModel.Employee1TileViewModel = employee1TileViewModel;
            deskAssignmentViewModel.Employee2TileViewModel = employee2TileViewModel;

            try
            {
                if (!string.IsNullOrEmpty(deskAssignmentViewModel.SearchByDeskNoOrEmpNo))
                {
                    deskAndEmpDetails = await _deskAndEmpDetailDataTableListRepository.DmsDetailListAsync(
                              BaseSpTcmPLGet(),
                              new ParameterSpTcmPL
                              {
                                  PGenericSearch = deskAssignmentViewModel.SearchByDeskNoOrEmpNo.Trim().ToUpper()
                              });

                    if (deskAndEmpDetails.PMessageType == IsOk)
                    {
                        deskAssignmentViewModel.TrueFlag = deskAndEmpDetails.PTrueFlag;
                        if (deskAndEmpDetails.PDeskDetailJson is not null)
                        {
                            var deskDetaillist = JsonConvert.DeserializeObject<List<Models.DeskDetailHeaderFields>>(deskAndEmpDetails.PDeskDetailJson);
                            int i = 0;
                            foreach (var deskDetail in deskDetaillist)
                            {
                                i++;
                                if (i is 1)
                                {
                                    deskDetailHeaderFields = deskDetail;
                                }
                            }
                        }
                        if (deskAndEmpDetails.PEmpDetailJson is not null)
                        {
                            var employeeDetaillist = JsonConvert.DeserializeObject<List<Models.EmployeeDetailHeaderFields>>(deskAndEmpDetails.PEmpDetailJson);
                            int i = 0;
                            foreach (var employeeDetail in employeeDetaillist)
                            {
                                i++;
                                if (i is 1)
                                {
                                    employee1DetailHeaderFields = employeeDetail;
                                }
                                if (i is 2)
                                {
                                    employee2DetailHeaderFields = employeeDetail;
                                }
                            }
                        }
                    }
                    deskTileViewModel.DeskDetailHeaderFields = deskDetailHeaderFields;
                    deskTileViewModel.DeskAssetsList = deskAndEmpDetails.PDeskAssetsList;
                }

                deskAssignmentViewModel.MasterList = deskAndEmpDetails.PMasterList;

                employee1TileViewModel.EmployeeDetailHeaderFields = employee1DetailHeaderFields;
                employee1TileViewModel.EmployeeAssetsList = deskAndEmpDetails.PEmp1AssetsList;

                employee2TileViewModel.EmployeeDetailHeaderFields = employee2DetailHeaderFields;
                employee2TileViewModel.EmployeeAssetsList = deskAndEmpDetails.PEmp2AssetsList;

                deskAssignmentViewModel.DeskTileViewModel = deskTileViewModel;
                deskAssignmentViewModel.Employee1TileViewModel = employee1TileViewModel;
                deskAssignmentViewModel.Employee2TileViewModel = employee2TileViewModel;
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
            }

            return View(deskAssignmentViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DMSHelper.ActionITAdm)]
        public async Task<IActionResult> DeskAssignmentNewIndex([FromForm] DeskAssignmentNewViewModel deskAssignmentViewModel)
        {
            DeskTileViewModel deskTileViewModel = new();
            DeskAndEmpDetails deskAndEmpDetails = new();
            var employee1TileViewModel = new EmployeeTileViewModel();
            var employee2TileViewModel = new EmployeeTileViewModel();

            Models.DeskDetailHeaderFields deskDetailHeaderFields = new();
            Models.EmployeeDetailHeaderFields employee1DetailHeaderFields = new();
            Models.EmployeeDetailHeaderFields employee2DetailHeaderFields = new();

            employee1TileViewModel.EmployeeDetailHeaderFields = employee1DetailHeaderFields;
            employee2TileViewModel.EmployeeDetailHeaderFields = employee2DetailHeaderFields;
            deskTileViewModel.DeskDetailHeaderFields = deskDetailHeaderFields;

            deskAssignmentViewModel.DeskTileViewModel = deskTileViewModel;
            deskAssignmentViewModel.Employee1TileViewModel = employee1TileViewModel;
            deskAssignmentViewModel.Employee2TileViewModel = employee2TileViewModel;

            try
            {
                if (!string.IsNullOrEmpty(deskAssignmentViewModel.SearchByDeskNoOrEmpNo))
                {
                    deskAndEmpDetails = await _deskAndEmpDetailDataTableListRepository.DmsDetailListAsync(
                              BaseSpTcmPLGet(),
                              new ParameterSpTcmPL
                              {
                                  PGenericSearch = deskAssignmentViewModel.SearchByDeskNoOrEmpNo.Trim().ToUpper()
                              });

                    if (deskAndEmpDetails.PMessageType == IsOk)
                    {
                        deskAssignmentViewModel.TrueFlag = deskAndEmpDetails.PTrueFlag;
                        if (deskAndEmpDetails.PDeskDetailJson is not null)
                        {
                            var deskDetaillist = JsonConvert.DeserializeObject<List<Models.DeskDetailHeaderFields>>(deskAndEmpDetails.PDeskDetailJson);
                            int i = 0;
                            foreach (var deskDetail in deskDetaillist)
                            {
                                i++;
                                if (i is 1)
                                {
                                    deskDetailHeaderFields = deskDetail;
                                }
                            }
                        }
                        if (deskAndEmpDetails.PEmpDetailJson is not null)
                        {
                            var employeeDetaillist = JsonConvert.DeserializeObject<List<Models.EmployeeDetailHeaderFields>>(deskAndEmpDetails.PEmpDetailJson);
                            int i = 0;
                            foreach (var employeeDetail in employeeDetaillist)
                            {
                                i++;
                                if (i is 1)
                                {
                                    employee1DetailHeaderFields = employeeDetail;
                                }
                                if (i is 2)
                                {
                                    employee2DetailHeaderFields = employeeDetail;
                                }
                            }
                        }
                    }
                    deskTileViewModel.DeskDetailHeaderFields = deskDetailHeaderFields;
                    deskTileViewModel.DeskAssetsList = deskAndEmpDetails.PDeskAssetsList;
                }
                deskAssignmentViewModel.MasterList = deskAndEmpDetails.PMasterList;

                employee1TileViewModel.EmployeeDetailHeaderFields = employee1DetailHeaderFields;
                employee1TileViewModel.EmployeeAssetsList = deskAndEmpDetails.PEmp1AssetsList;

                employee2TileViewModel.EmployeeDetailHeaderFields = employee2DetailHeaderFields;
                employee2TileViewModel.EmployeeAssetsList = deskAndEmpDetails.PEmp2AssetsList;

                deskAssignmentViewModel.DeskTileViewModel = deskTileViewModel;
                deskAssignmentViewModel.Employee1TileViewModel = employee1TileViewModel;
                deskAssignmentViewModel.Employee2TileViewModel = employee2TileViewModel;
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
            }

            return View(deskAssignmentViewModel);
        }

        #endregion Desk + Emp details

        #region Desk + Emp details for IT Help-DeskEng

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DMSHelper.ActionITHelpDesk)]
        public async Task<IActionResult> DeskAssignmentNewIndexReadonly(string search)
        {
            DeskAssignmentNewViewModel deskAssignmentViewModel = new DeskAssignmentNewViewModel();

            deskAssignmentViewModel.SearchByDeskNoOrEmpNo = search;

            DeskTileViewModel deskTileViewModel = new();
            DeskAndEmpDetails deskAndEmpDetails = new();
            var employee1TileViewModel = new EmployeeTileViewModel();
            var employee2TileViewModel = new EmployeeTileViewModel();

            Models.DeskDetailHeaderFields deskDetailHeaderFields = new();
            Models.EmployeeDetailHeaderFields employee1DetailHeaderFields = new();
            Models.EmployeeDetailHeaderFields employee2DetailHeaderFields = new();

            employee1TileViewModel.EmployeeDetailHeaderFields = employee1DetailHeaderFields;
            employee2TileViewModel.EmployeeDetailHeaderFields = employee2DetailHeaderFields;
            deskTileViewModel.DeskDetailHeaderFields = deskDetailHeaderFields;

            deskAssignmentViewModel.DeskTileViewModel = deskTileViewModel;
            deskAssignmentViewModel.Employee1TileViewModel = employee1TileViewModel;
            deskAssignmentViewModel.Employee2TileViewModel = employee2TileViewModel;

            try
            {
                if (!string.IsNullOrEmpty(deskAssignmentViewModel.SearchByDeskNoOrEmpNo))
                {
                    deskAndEmpDetails = await _deskAndEmpDetailDataTableListRepository.DmsDetailListAsync(
                              BaseSpTcmPLGet(),
                              new ParameterSpTcmPL
                              {
                                  PGenericSearch = deskAssignmentViewModel.SearchByDeskNoOrEmpNo.Trim().ToUpper()
                              });

                    if (deskAndEmpDetails.PMessageType == IsOk)
                    {
                        deskAssignmentViewModel.TrueFlag = deskAndEmpDetails.PTrueFlag;
                        if (deskAndEmpDetails.PDeskDetailJson is not null)
                        {
                            var deskDetaillist = JsonConvert.DeserializeObject<List<Models.DeskDetailHeaderFields>>(deskAndEmpDetails.PDeskDetailJson);
                            int i = 0;
                            foreach (var deskDetail in deskDetaillist)
                            {
                                i++;
                                if (i is 1)
                                {
                                    deskDetailHeaderFields = deskDetail;
                                }
                            }
                        }
                        if (deskAndEmpDetails.PEmpDetailJson is not null)
                        {
                            var employeeDetaillist = JsonConvert.DeserializeObject<List<Models.EmployeeDetailHeaderFields>>(deskAndEmpDetails.PEmpDetailJson);
                            int i = 0;
                            foreach (var employeeDetail in employeeDetaillist)
                            {
                                i++;
                                if (i is 1)
                                {
                                    employee1DetailHeaderFields = employeeDetail;
                                }
                                if (i is 2)
                                {
                                    employee2DetailHeaderFields = employeeDetail;
                                }
                            }
                        }
                    }
                    deskTileViewModel.DeskDetailHeaderFields = deskDetailHeaderFields;
                    deskTileViewModel.DeskAssetsList = deskAndEmpDetails.PDeskAssetsList;
                }

                deskAssignmentViewModel.MasterList = deskAndEmpDetails.PMasterList;

                employee1TileViewModel.EmployeeDetailHeaderFields = employee1DetailHeaderFields;
                employee1TileViewModel.EmployeeAssetsList = deskAndEmpDetails.PEmp1AssetsList;

                employee2TileViewModel.EmployeeDetailHeaderFields = employee2DetailHeaderFields;
                employee2TileViewModel.EmployeeAssetsList = deskAndEmpDetails.PEmp2AssetsList;

                deskAssignmentViewModel.DeskTileViewModel = deskTileViewModel;
                deskAssignmentViewModel.Employee1TileViewModel = employee1TileViewModel;
                deskAssignmentViewModel.Employee2TileViewModel = employee2TileViewModel;
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
            }

            return View(deskAssignmentViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DMSHelper.ActionITHelpDesk)]
        public async Task<IActionResult> DeskAssignmentNewIndexReadonly([FromForm] DeskAssignmentNewViewModel deskAssignmentViewModel)
        {
            DeskTileViewModel deskTileViewModel = new();
            DeskAndEmpDetails deskAndEmpDetails = new();
            var employee1TileViewModel = new EmployeeTileViewModel();
            var employee2TileViewModel = new EmployeeTileViewModel();

            Models.DeskDetailHeaderFields deskDetailHeaderFields = new();
            Models.EmployeeDetailHeaderFields employee1DetailHeaderFields = new();
            Models.EmployeeDetailHeaderFields employee2DetailHeaderFields = new();

            employee1TileViewModel.EmployeeDetailHeaderFields = employee1DetailHeaderFields;
            employee2TileViewModel.EmployeeDetailHeaderFields = employee2DetailHeaderFields;
            deskTileViewModel.DeskDetailHeaderFields = deskDetailHeaderFields;

            deskAssignmentViewModel.DeskTileViewModel = deskTileViewModel;
            deskAssignmentViewModel.Employee1TileViewModel = employee1TileViewModel;
            deskAssignmentViewModel.Employee2TileViewModel = employee2TileViewModel;

            try
            {
                if (!string.IsNullOrEmpty(deskAssignmentViewModel.SearchByDeskNoOrEmpNo))
                {
                    deskAndEmpDetails = await _deskAndEmpDetailDataTableListRepository.DmsDetailListAsync(
                              BaseSpTcmPLGet(),
                              new ParameterSpTcmPL
                              {
                                  PGenericSearch = deskAssignmentViewModel.SearchByDeskNoOrEmpNo.Trim().ToUpper()
                              });

                    if (deskAndEmpDetails.PMessageType == IsOk)
                    {
                        deskAssignmentViewModel.TrueFlag = deskAndEmpDetails.PTrueFlag;
                        if (deskAndEmpDetails.PDeskDetailJson is not null)
                        {
                            var deskDetaillist = JsonConvert.DeserializeObject<List<Models.DeskDetailHeaderFields>>(deskAndEmpDetails.PDeskDetailJson);
                            int i = 0;
                            foreach (var deskDetail in deskDetaillist)
                            {
                                i++;
                                if (i is 1)
                                {
                                    deskDetailHeaderFields = deskDetail;
                                }
                            }
                        }
                        if (deskAndEmpDetails.PEmpDetailJson is not null)
                        {
                            var employeeDetaillist = JsonConvert.DeserializeObject<List<Models.EmployeeDetailHeaderFields>>(deskAndEmpDetails.PEmpDetailJson);
                            int i = 0;
                            foreach (var employeeDetail in employeeDetaillist)
                            {
                                i++;
                                if (i is 1)
                                {
                                    employee1DetailHeaderFields = employeeDetail;
                                }
                                if (i is 2)
                                {
                                    employee2DetailHeaderFields = employeeDetail;
                                }
                            }
                        }
                    }
                    deskTileViewModel.DeskDetailHeaderFields = deskDetailHeaderFields;
                    deskTileViewModel.DeskAssetsList = deskAndEmpDetails.PDeskAssetsList;
                }
                deskAssignmentViewModel.MasterList = deskAndEmpDetails.PMasterList;

                employee1TileViewModel.EmployeeDetailHeaderFields = employee1DetailHeaderFields;
                employee1TileViewModel.EmployeeAssetsList = deskAndEmpDetails.PEmp1AssetsList;

                employee2TileViewModel.EmployeeDetailHeaderFields = employee2DetailHeaderFields;
                employee2TileViewModel.EmployeeAssetsList = deskAndEmpDetails.PEmp2AssetsList;

                deskAssignmentViewModel.DeskTileViewModel = deskTileViewModel;
                deskAssignmentViewModel.Employee1TileViewModel = employee1TileViewModel;
                deskAssignmentViewModel.Employee2TileViewModel = employee2TileViewModel;
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
            }

            return View(deskAssignmentViewModel);
        }

        #endregion Desk + Emp details for IT Help-DeskEng
    }
}