using DocumentFormat.OpenXml.Drawing.Charts;
using DocumentFormat.OpenXml.Office2010.Excel;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using MimeTypes;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.Common;
using TCMPLApp.DataAccess.Repositories.DMS;
using TCMPLApp.DataAccess.Repositories.SWPVaccine;
using TCMPLApp.Domain.Models.DMS;
using TCMPLApp.Library.Excel.Template;
using TCMPLApp.Library.Excel.Template.Models;
using TCMPLApp.WebApp.Classes;
using TCMPLApp.WebApp.Controllers;
using TCMPLApp.WebApp.Models;
using static TCMPLApp.WebApp.Classes.DTModel;

namespace TCMPLApp.WebApp.Areas.DMS.Controllers
{
    [Authorize]
    [Area("DMS")]
    public class MovementsController : BaseController
    {
        private const string ConstFilterMovementIndex = "Index";
        private const string DefaultUserEmpno = "01938";
        private const string AssetMovementType = "A";
        private const string EmployeeMovementType = "E";

        private readonly ISelectTcmPLRepository _selectTcmPLRepository;
        private readonly IExcelTemplate _excelTemplate;
        private readonly IFilterRepository _filterRepository;
        private readonly IUtilityRepository _utilityRepository;
        private readonly IMovementsDataTableListRepository _movementsDataTableListRepository;
        private readonly IMovementsSelectedDeskDataTableListRepository _movementsSelectedDeskDataTableListRepository;
        private readonly IMovementsSelectedDeskRepository _movementsSelectedDeskRepository;
        private readonly IMovementsDeskAssignmentRepository _movementsDeskAssignmentRepository;
        private readonly IMovementsAssetAssignmentRepository _movementsAssetAssignmentRepository;
        private readonly IMovementAssignmentDataTableListRepository _movementAssignmentDataTableListRepository;
        private readonly IMovementsImportRepository _movementsImportRepository;
        private readonly IFlexiToDMSDataTableListRepository _flexiToDMSDataTableListRepository;
        private readonly IFlexiToDMSRepository _flexiToDMSRepository;

        public MovementsController(
                //IDMSEmployeeRepository dmsEmployeeRepository,
                IFilterRepository filterRepository,
                IExcelTemplate excelTemplate,
                IUtilityRepository utilityRepository,
                ISelectTcmPLRepository selectTcmPLRepository,
                IMovementsDataTableListRepository movementsDataTableListRepository,
                IMovementsSelectedDeskDataTableListRepository movementsSelectedDeskDataTableListRepository,
                IMovementsSelectedDeskRepository movementsSelectedDeskRepository,
                IMovementsDeskAssignmentRepository movementsDeskAssignmentRepository,
                IMovementsAssetAssignmentRepository movementsAssetAssignmentRepository,
                IMovementAssignmentDataTableListRepository movementAssignmentDataTableListRepository,
                IMovementsImportRepository movementsImportRepository,
                IFlexiToDMSDataTableListRepository flexiToDMSDataTableListRepository,
                IFlexiToDMSRepository flexiToDMSRepository
            )
        {
            //_dmsEmployeeRepository = dmsEmployeeRepository;
            _filterRepository = filterRepository;
            _excelTemplate = excelTemplate;
            _utilityRepository = utilityRepository;
            _selectTcmPLRepository = selectTcmPLRepository;
            _movementsDataTableListRepository = movementsDataTableListRepository;
            _movementsSelectedDeskDataTableListRepository = movementsSelectedDeskDataTableListRepository;
            _movementsSelectedDeskRepository = movementsSelectedDeskRepository;
            _movementsDeskAssignmentRepository = movementsDeskAssignmentRepository;
            _movementsAssetAssignmentRepository = movementsAssetAssignmentRepository;
            _movementAssignmentDataTableListRepository = movementAssignmentDataTableListRepository;
            _movementsImportRepository = movementsImportRepository;
            _flexiToDMSDataTableListRepository = flexiToDMSDataTableListRepository;
            _flexiToDMSRepository = flexiToDMSRepository;
        }

        #region Movements CRUD

        public async Task<IActionResult> Index()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterMovementIndex
            });

            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            MovementsIndexViewModel movementsIndexViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            var v_empno = CurrentUserIdentity.EmpNo.ToString();
            if (string.IsNullOrEmpty(v_empno))
            {
                v_empno = DefaultUserEmpno;
            }

            string v_guidid = Guid.NewGuid().ToString("N").ToUpper();

            ViewData["SessionId"] = v_empno + v_guidid.Substring(1, 15).ToUpper();

            return View(movementsIndexViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetLists(DTParameters param)
        {
            DTResult<MovementsDataTableList> result = new();
            int totalRow = 0;

            try
            {
                IEnumerable<MovementsDataTableList> data = await _movementsDataTableListRepository.MovementsDataTableListAsync(
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

        public IActionResult Create(string id)
        {
            MovementsCreateViewModel movements = new();

            //AssetsOnDeskViewModel assetsOnDeskViewModel = new();
            try
            {
                if (string.IsNullOrEmpty(id))
                {
                    return NotFound();

                    //var v_empno = CurrentUserIdentity.EmpNo.ToString();
                    //if (string.IsNullOrEmpty(v_empno))
                    //{
                    //    v_empno = "01938";
                    //}

                    //string v_guidid = Guid.NewGuid().ToString();

                    //id = v_empno + v_guidid.Substring(1, 15);
                }

                //var resultSource = await _movementsSelectedDeskDataTableListRepository.MovementsSourceDeskDataTableListAsync(
                //                   BaseSpTcmPLGet(),
                //                   new ParameterSpTcmPL
                //                   {
                //                       PSessionId = id
                //                   });

                //var resultTarget = await _movementsSelectedDeskDataTableListRepository.MovementsTargetDeskDataTableListAsync(
                //                   BaseSpTcmPLGet(),
                //                   new ParameterSpTcmPL
                //                   {
                //                       PSessionId = id
                //                   });

                //var result = await _deskAsgmtMasterDetailRepository.DeskAsgmtMasterDetail(
                //                   BaseSpTcmPLGet(),
                //                   new ParameterSpTcmPL
                //                   {
                //                       PGenericSearch = id
                //                   });

                // if (resultSource.PMessageType == Success)
                // {
                movements.Sid = id;
                movements.SourceDeskList = null;
                movements.TargetDeskList = null;
                movements.TargetAssignments = null;
                ViewData["SessionId"] = id;

                //assetsOnDeskViewModel.DeskNo = result.PDeskno;
                //assetsOnDeskViewModel.CabinDesk = result.PCabinDesk;
                //assetsOnDeskViewModel.Floor = result.PFloor;
                //assetsOnDeskViewModel.Office = result.POffice;
                //assetsOnDeskViewModel.Area = result.PArea;

                //var data = await _assetsOnDeskDataTableListRepository.AssetsOnDeskDataTableListAsync(
                //    BaseSpTcmPLGet(),
                //    new ParameterSpTcmPL
                //    {
                //        PGenericSearch = result.PDeskno
                //    });

                //assetsOnDeskViewModel.assetsOnDeskDataTableList = data;
                //}
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
            }

            return View(movements);
        }

        public async Task<IActionResult> Edit(string id)
        {
            MovementsCreateViewModel movements = new();

            try
            {
                if (string.IsNullOrEmpty(id))
                {
                    return NotFound();
                }

                var sourceDeskList = await _movementsSelectedDeskDataTableListRepository.MovementsSourceDeskDataTableListAsync(
                                                                                    BaseSpTcmPLGet(),
                                                                                    new ParameterSpTcmPL
                                                                                    {
                                                                                        PSessionId = id
                                                                                    });

                var targetDeskList = await _movementsSelectedDeskDataTableListRepository.MovementsTargetDeskDataTableListAsync(
                                                                                   BaseSpTcmPLGet(),
                                                                                   new ParameterSpTcmPL
                                                                                   {
                                                                                       PSessionId = id
                                                                                   });

                var targetAssignments = await _movementAssignmentDataTableListRepository.MovementAssignmentDataTableListAsync(
                                                                                    BaseSpTcmPLGet(),
                                                                                    new ParameterSpTcmPL
                                                                                    {
                                                                                        PSessionId = id
                                                                                    });

                movements.Sid = id;
                movements.SourceDeskList = sourceDeskList.ToList();
                movements.TargetDeskList = targetDeskList.ToList();
                movements.TargetAssignments = targetAssignments.ToList();
                ViewData["SessionId"] = id;
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
            }

            return View(movements);
        }

        [HttpPost]
        public async Task<IActionResult> Delete(string id)
        {
            try
            {
                var result = await _movementsDeskAssignmentRepository.MovementsRequestDeleteAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PSessionId = id
                    });

                //if (result.PMessageType == Success)
                //{
                //    Notify("Success", result.PMessageText.Replace("-", " "), "toaster", NotificationType.success);
                //}
                //else
                //{
                //    throw new Exception(result.PMessageText.Replace("-", " "));
                //}
                return result.PMessageType != IsOk
                 ? throw new Exception(result.PMessageText.Replace("-", " "))
                 : (IActionResult)Json(new { success = true, response = result.PMessageText });

                //return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
                //return Json(new { success = false, response = ex.Message });
            }
        }

        #endregion Movements CRUD

        #region Source desk selection

        public async Task<IActionResult> SourceDeskIndex(string id)
        {
            SelectedDeskIndexViewModel sourceDeskList = new();

            try
            {
                if (string.IsNullOrEmpty(id))
                {
                    return NotFound();
                }

                var result = await _movementsSelectedDeskDataTableListRepository.MovementsSourceDeskDataTableListAsync(
                                                                                    BaseSpTcmPLGet(),
                                                                                    new ParameterSpTcmPL
                                                                                    {
                                                                                        PSessionId = id
                                                                                    });

                sourceDeskList.Sid = id;
                sourceDeskList.MovementsSelectedDeskDataTableLists = result;
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
            }

            return PartialView("_ModalSourceDeskIndexPartial", sourceDeskList);
        }

        public async Task<IActionResult> SourceDeskCreate(string id)
        {
            SelectedDeskCreateViewModel sourceDeskCreateViewModel = new();

            if (string.IsNullOrEmpty(id))
            {
                return NotFound();
            }

            var sourceDeskList = await _selectTcmPLRepository.SourceDeskListAsync(
                                    BaseSpTcmPLGet(),
                                    new ParameterSpTcmPL
                                    {
                                        PSessionId = id
                                    });

            ViewData["SourceDeskList"] = new SelectList(sourceDeskList, "DataValueField", "DataTextField");

            ViewData["SessionId"] = id;
            return PartialView("_ModalSourceDeskCreatePartial", sourceDeskCreateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> SourceDeskCreate([FromForm] SelectedDeskCreateViewModel sourceDeskCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _movementsSelectedDeskRepository.MovementsSourceDeskCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PSessionId = sourceDeskCreateViewModel.Sid,
                            PDeskid = sourceDeskCreateViewModel.Deskid
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

            var sourceDeskList = await _selectTcmPLRepository.SourceDeskListAsync(
                                   BaseSpTcmPLGet(),
                                   new ParameterSpTcmPL
                                   {
                                       PSessionId = sourceDeskCreateViewModel.Sid
                                   });

            ViewData["SourceDeskList"] = new SelectList(sourceDeskList, "DataValueField", "DataTextField", sourceDeskCreateViewModel.Deskid?.ToString());

            return PartialView("_ModalSourceDeskCreate", sourceDeskCreateViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> SourceDeskDelete(string id)
        {
            SelectedDeskIndexViewModel sourceDeskDetails = new();

            try
            {
                if (id == null)
                    return NotFound();

                var sid = id.Split("!-!")[0];
                var deskid = id.Split("!-!")[1];

                if (string.IsNullOrEmpty(sid) && string.IsNullOrEmpty(deskid))
                {
                    return NotFound();
                }

                var result = await _movementsSelectedDeskDataTableListRepository.MovementsSourceDeskDataTableListAsync(
                                                                                    BaseSpTcmPLGet(),
                                                                                    new ParameterSpTcmPL
                                                                                    {
                                                                                        PSessionId = sid
                                                                                    });

                var desk_result = result.Where(m => m.DeskId == deskid);

                sourceDeskDetails.Sid = sid;
                sourceDeskDetails.MovementsSelectedDeskDataTableLists = desk_result;

                ViewData["DeskId"] = deskid;
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
            }

            return PartialView("_ModalSourceDeskDeletePartial", sourceDeskDetails);
        }

        [HttpPost]
        public async Task<IActionResult> SourceDeskDelete(string sid, string deskid)
        {
            if (sid == null || deskid == null)
                return NotFound("Parameter can not be null !!!");

            try
            {
                var result = await _movementsSelectedDeskRepository.MovementsSourceDeskDeleteAsync(
                                        BaseSpTcmPLGet(),
                                        new ParameterSpTcmPL
                                        {
                                            PSessionId = sid,
                                            PDeskId = deskid
                                        });

                if (result.PMessageType == IsOk)
                {
                    //Notify("Success", result.PMessageText.Replace("-", " "), "toaster", NotificationType.success);
                    return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
                }
                else
                {
                    throw new Exception(result.PMessageText.Replace("-", " "));
                }
            }
            catch (Exception ex)
            {
                //Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            //SelectedDeskIndexViewModel sourceDeskDetails = new();

            //var model = await _movementsSelectedDeskDataTableListRepository.MovementsSourceDeskDataTableListAsync(
            //                                                                        BaseSpTcmPLGet(),
            //                                                                        new ParameterSpTcmPL
            //                                                                        {
            //                                                                            PSessionId = sid
            //                                                                        });
            //var desk_result = model.Where(m => m.DeskId == deskid);

            //sourceDeskDetails.Sid = sid;
            //sourceDeskDetails.MovementsSelectedDeskDataTableLists = desk_result;

            //return PartialView("_ModalSourceDeskDeletePartial", sourceDeskDetails);
        }

        #endregion Source desk selection

        #region Target desk selection

        public async Task<IActionResult> TargetDeskIndex(string id)
        {
            SelectedDeskIndexViewModel targetDeskList = new();

            try
            {
                if (string.IsNullOrEmpty(id))
                {
                    return NotFound();
                }

                var result = await _movementsSelectedDeskDataTableListRepository.MovementsTargetDeskDataTableListAsync(
                                                                                    BaseSpTcmPLGet(),
                                                                                    new ParameterSpTcmPL
                                                                                    {
                                                                                        PSessionId = id
                                                                                    });

                targetDeskList.Sid = id;
                targetDeskList.MovementsSelectedDeskDataTableLists = result;
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
            }

            return PartialView("_ModalTargetDeskIndexPartial", targetDeskList);
        }

        public async Task<IActionResult> TargetDeskCreate(string id)
        {
            SelectedDeskCreateViewModel targetDeskCreateViewModel = new();

            if (string.IsNullOrEmpty(id))
            {
                return NotFound();
            }

            var targetDeskList = await _selectTcmPLRepository.TargetDeskListAsync(
                                    BaseSpTcmPLGet(),
                                    new ParameterSpTcmPL
                                    {
                                        PSessionId = id
                                    });

            ViewData["TargetDeskList"] = new SelectList(targetDeskList, "DataValueField", "DataTextField");
            ViewData["SessionId"] = id;

            return PartialView("_ModalTargetDeskCreatePartial", targetDeskCreateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> TargetDeskCreate([FromForm] SelectedDeskCreateViewModel targetDeskCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _movementsSelectedDeskRepository.MovementsTargetDeskCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PSessionId = targetDeskCreateViewModel.Sid,
                            PDeskId = targetDeskCreateViewModel.Deskid
                        });

                    //return result.PMessageType != Success
                    //    ? throw new Exception(result.PMessageText.Replace("-", " "))
                    //    : (IActionResult)Json(new { success = true, response = result.PMessageText });

                    if (result.PMessageType == IsOk)
                    {
                        return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
                    }
                    else
                    {
                        throw new Exception(result.PMessageText.Replace("-", " "));
                    }
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            var targetDeskList = await _selectTcmPLRepository.TargetDeskListAsync(
                                   BaseSpTcmPLGet(),
                                   new ParameterSpTcmPL
                                   {
                                       PSessionId = targetDeskCreateViewModel.Sid
                                   });

            ViewData["TargetDeskList"] = new SelectList(targetDeskList, "DataValueField", "DataTextField", targetDeskCreateViewModel.Deskid?.ToString());

            return PartialView("_ModalTargetDeskCreate", targetDeskCreateViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> TargetDeskDelete(string id)
        {
            SelectedDeskIndexViewModel targetDeskDetails = new();

            try
            {
                if (id == null)
                    return NotFound();

                var sid = id.Split("!-!")[0];
                var deskid = id.Split("!-!")[1];

                if (string.IsNullOrEmpty(sid) && string.IsNullOrEmpty(deskid))
                {
                    return NotFound();
                }

                var result = await _movementsSelectedDeskDataTableListRepository.MovementsTargetDeskDataTableListAsync(
                                                                                    BaseSpTcmPLGet(),
                                                                                    new ParameterSpTcmPL
                                                                                    {
                                                                                        PSessionId = sid
                                                                                    });

                var desk_result = result.Where(m => m.DeskId == deskid);

                targetDeskDetails.Sid = sid;
                targetDeskDetails.MovementsSelectedDeskDataTableLists = desk_result;

                ViewData["DeskId"] = deskid;
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
            }

            return PartialView("_ModalTargetDeskDeletePartial", targetDeskDetails);
        }

        [HttpPost]
        public async Task<IActionResult> TargetDeskDelete(string sid, string deskid)
        {
            try
            {
                var result = await _movementsSelectedDeskRepository.MovementsTargetDeskDeleteAsync(
                                        BaseSpTcmPLGet(),
                                        new ParameterSpTcmPL
                                        {
                                            PSessionId = sid,
                                            PDeskId = deskid
                                        });

                if (result.PMessageType == IsOk)
                {
                    //Notify("Success", result.PMessageText.Replace("-", " "), "toaster", NotificationType.success);
                    return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
                }
                else
                {
                    throw new Exception(result.PMessageText.Replace("-", " "));
                }
            }
            catch (Exception ex)
            {
                //Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        #endregion Target desk selection

        #region Asset assignments

        public async Task<IActionResult> AssetAssignmentCreate(string sid, string movetype, string deskid, string assetid)
        {
            AssetAssignmentCreateViewModel assetAssignmentCreateViewModel = new();

            if (string.IsNullOrEmpty(sid) && string.IsNullOrEmpty(deskid) && string.IsNullOrEmpty(assetid))
            {
                return NotFound();
            }

            assetAssignmentCreateViewModel.Sid = sid;
            assetAssignmentCreateViewModel.CurrDeskid = deskid;
            assetAssignmentCreateViewModel.Movetype = movetype;
            assetAssignmentCreateViewModel.Deskid = string.Empty;
            assetAssignmentCreateViewModel.Assetid = assetid;

            var targetAssignmentDeskList = await _selectTcmPLRepository.TargetAssignmentDeskListAsync(
                                    BaseSpTcmPLGet(),
                                    new ParameterSpTcmPL
                                    {
                                        PSessionId = sid,
                                        PMovetype = EmployeeMovementType
                                    });

            ViewData["TargetAssignmentDeskList"] = new SelectList(targetAssignmentDeskList, "DataValueField", "DataTextField");

            return PartialView("_ModalAssetAssignmentCreatePartial", assetAssignmentCreateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> AssetAssignmentCreate([FromForm] AssetAssignmentCreateViewModel assetAssignmentCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _movementsAssetAssignmentRepository.MovementsAssetAssignmentCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PSessionId = assetAssignmentCreateViewModel.Sid,
                            PDeskidOld = assetAssignmentCreateViewModel.CurrDeskid,
                            PMovetype = assetAssignmentCreateViewModel.Movetype,
                            PDeskId = assetAssignmentCreateViewModel.Deskid,
                            PAssetId = assetAssignmentCreateViewModel.Assetid
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

            var targetAssignmentDeskList = await _selectTcmPLRepository.TargetAssignmentDeskListAsync(
                                    BaseSpTcmPLGet(),
                                    new ParameterSpTcmPL
                                    {
                                        PSessionId = assetAssignmentCreateViewModel.Sid,
                                        PMovetype = EmployeeMovementType
                                    });

            ViewData["TargetAssignmentDeskList"] = new SelectList(targetAssignmentDeskList, "DataValueField", "DataTextField", assetAssignmentCreateViewModel.Deskid);

            return PartialView("_ModalDeskAssignmentCreatePartial", assetAssignmentCreateViewModel);
        }

        #endregion Asset assignments

        #region Desk assignments

        public async Task<IActionResult> DeskAssignmentCreate(string sid, string currdeskid)
        {
            DeskAssignmentCreateViewModel deskAssignmentCreateViewModel = new();

            if (string.IsNullOrEmpty(sid) && string.IsNullOrEmpty(currdeskid))
            {
                return NotFound();
            }

            deskAssignmentCreateViewModel.Sid = sid;
            deskAssignmentCreateViewModel.CurrDeskid = currdeskid;
            deskAssignmentCreateViewModel.Deskid = string.Empty;

            var targetAssignmentDeskList = await _selectTcmPLRepository.TargetAssignmentDeskListAsync(
                                    BaseSpTcmPLGet(),
                                    new ParameterSpTcmPL
                                    {
                                        PSessionId = sid,
                                        PMovetype = AssetMovementType
                                    });
            ViewData["SessionId"] = sid;
            ViewData["TargetAssignmentDeskList"] = new SelectList(targetAssignmentDeskList, "DataValueField", "DataTextField");

            return PartialView("_ModalDeskAssignmentCreatePartial", deskAssignmentCreateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeskAssignmentCreate([FromForm] DeskAssignmentCreateViewModel deskAssignmentCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _movementsDeskAssignmentRepository.MovementsDeskAssignmentCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PSessionId = deskAssignmentCreateViewModel.Sid,
                            PDeskIdOld = deskAssignmentCreateViewModel.CurrDeskid,
                            PDeskId = deskAssignmentCreateViewModel.Deskid
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

            var targetAssignmentDeskList = await _selectTcmPLRepository.TargetAssignmentDeskListAsync(
                                    BaseSpTcmPLGet(),
                                    new ParameterSpTcmPL
                                    {
                                        PSessionId = deskAssignmentCreateViewModel.Sid,
                                        PMovetype = AssetMovementType
                                    });

            ViewData["TargetAssignmentDeskList"] = new SelectList(targetAssignmentDeskList, "DataValueField", "DataTextField");

            return PartialView("_ModalDeskAssignmentCreatePartial", deskAssignmentCreateViewModel);
        }

        #endregion Desk assignments

        #region Movement assignements

        public async Task<IActionResult> DeskAssetDetail(string sid, string deskid, string category, string assetflag)
        {
            DeskAssetDetailViewModel deskAssets = new();

            try
            {
                if (string.IsNullOrEmpty(sid) && string.IsNullOrEmpty(deskid) && string.IsNullOrEmpty(category))
                {
                    return NotFound();
                }

                var result = await _movementsSelectedDeskDataTableListRepository.DeskAssetDetailDataTableListAsync(
                                                                                    BaseSpTcmPLGet(),
                                                                                    new ParameterSpTcmPL
                                                                                    {
                                                                                        PSessionId = sid,
                                                                                        PDeskid = deskid,
                                                                                        PCategory = category,
                                                                                        PAssetFlag = int.Parse(assetflag ?? "0")
                                                                                    });

                deskAssets.Sid = sid;
                deskAssets.DeskAssetDataTableLists = result;

                ViewData["DeskId"] = deskid;
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
            }

            return PartialView("_ModalDeskAssetDetailPartial", deskAssets);
        }

        public async Task<IActionResult> MovementAssignmentIndex(string id)
        {
            MovementAssignmentIndexViewModel movementAssignmentList = new();

            try
            {
                if (string.IsNullOrEmpty(id))
                {
                    return NotFound();
                }

                var result = await _movementAssignmentDataTableListRepository.MovementAssignmentDataTableListAsync(
                                                                                    BaseSpTcmPLGet(),
                                                                                    new ParameterSpTcmPL
                                                                                    {
                                                                                        PSessionId = id
                                                                                    });

                movementAssignmentList.Sid = id;
                movementAssignmentList.MovementsAssignmentsDataTableLists = result;
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
            }

            return PartialView("_ModalMovementAssignmentIndexPartial", movementAssignmentList);
        }

        [HttpPost]
        public async Task<IActionResult> MovementAssignmentDelete(string id)
        {
            try
            {
                if (id == null)
                    return NotFound();

                var sid = id.Split("!-!")[0];
                var currdeskid = id.Split("!-!")[1];
                var targetdeskid = id.Split("!-!")[2];

                if (string.IsNullOrEmpty(sid) && string.IsNullOrEmpty(currdeskid) && string.IsNullOrEmpty(targetdeskid))
                {
                    return NotFound();
                }

                var result = await _movementsDeskAssignmentRepository.MovementsDeskAssignmentDeleteAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PSessionId = sid,
                        PDeskidOld = currdeskid,
                        PDeskid = targetdeskid
                    });

                if (result.PMessageType == IsOk)
                {
                    //Notify("Success", result.PMessageText.Replace("-", " "), "toaster", NotificationType.success);
                    return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
                }
                else
                {
                    throw new Exception(result.PMessageText.Replace("-", " "));
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        #endregion Movement assignements

        #region Approval

        public async Task<IActionResult> MovementApprove(string id)
        {
            if (id == null)
                return NotFound();

            string msgText = string.Empty;

            try
            {
                var result = await _movementsDeskAssignmentRepository.MovementsApprovalAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PSessionId = id
                        });

                if (result.PMessageType != "OK")
                {
                    Notify("Error", result.PMessageText.Replace("-", " "), "toaster", NotificationType.error);
                    return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(result.PMessageText.Replace("-", " ")));
                }
                else
                {
                    Notify("Success", result.PMessageText.Replace("-", " "), "toaster", NotificationType.success);
                    return Json(new { success = result.PMessageType == IsOk, message = result.PMessageText });
                }
            }
            catch (Exception ex)
            {
                msgText = ex.Message.ToString();
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(msgText));
            }
        }

        #endregion Approval

        #region Excel import

        [HttpGet]
        public IActionResult ImportMovements(string id)
        {
            if (id == null)
                return NotFound();

            ViewData["SessionId"] = id;

            return PartialView("_ModalTemplateImport");
        }

        [HttpGet]
        public IActionResult MovementsXLTemplateDownload()
        {
            var dictionaryItems = new List<Library.Excel.Template.Models.DictionaryItem>();

            Stream ms = _excelTemplate.ExportDMSEmpAssetMovement("v01",
                    new Library.Excel.Template.Models.DictionaryCollection
                    {
                        DictionaryItems = dictionaryItems
                    },
                    500);
            var fileName = "ImportDMSEmpAssetMovement.xlsx";
            var mimeType = MimeTypeMap.GetMimeType("xlsx");

            ms.Position = 0;
            return File(ms, mimeType, fileName);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> MovementsXLTemplateUpload(IFormFile file, string id)
        {
            try
            {
                if (file == null || file.Length == 0)
                    return Json(new { success = false, response = "File not uploaded due to unrecongnised parameters" });

                FileInfo fileInfo = new FileInfo(file.FileName);

                Guid storageId = Guid.NewGuid();
                var stream = file.OpenReadStream();
                var fileName = file.FileName;
                var fileSize = file.Length;
                var mimeType = MimeTypeMap.GetMimeType(fileInfo.Extension);

                // Check file validation
                if (!fileInfo.Extension.Contains("xls"))
                    return Json(new { success = false, response = "Excel file not recognized" });

                string json = string.Empty;

                List<EmpAssetMovement> MovementsItems = _excelTemplate.ImportDMSEmpAssetMovement(stream);

                string[] aryMovements = MovementsItems.Select(p =>
                                                            p.Empno + "~!~" +
                                                            p.CurrentDesk + "~!~" +
                                                            p.TargetDesk + "~!~" +
                                                            p.MoveAssets + "~!~" +
                                                            p.MoveEmployee).ToArray();

                var uploadOutPut = await _movementsImportRepository.ImportMovementsAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PMovements = aryMovements,
                            PSessionId = id
                        }
                    );

                List<ImportFileResultViewModel> importFileResults = new List<ImportFileResultViewModel>();

                if (uploadOutPut.PMovementsErrors?.Length > 0)
                {
                    foreach (string err in uploadOutPut.PMovementsErrors)
                    {
                        string[] aryErr = err.Split("~!~");
                        importFileResults.Add(new ImportFileResultViewModel
                        {
                            ErrorType = (ImportFileValidationErrorTypeEnum)Enum.Parse(typeof(ImportFileValidationErrorTypeEnum), aryErr[5], true),
                            ExcelRowNumber = int.Parse(aryErr[2]),
                            FieldName = aryErr[3],
                            Id = int.Parse(aryErr[0]),
                            Section = aryErr[1],
                            Message = aryErr[6],
                        });
                    }
                }

                List<Library.Excel.Template.Models.ValidationItem> validationItems = new List<Library.Excel.Template.Models.ValidationItem>();

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

                if (uploadOutPut.PMessageType != "OK")
                {
                    if (importFileResults.Count > 0)
                    {
                        var streamError = _excelTemplate.ValidateImport(stream, validationItems);
                        FileContentResult fileContentResult = File(streamError.ToArray(), mimeType, fileName);

                        var resultJsonError = new
                        {
                            success = false,
                            response = uploadOutPut.PMessageText,
                            data = importFileResults,
                            fileContent = fileContentResult
                        };

                        return Json(resultJsonError);
                    }
                    else
                    {
                        var resultJsonError = new
                        {
                            success = false,
                            response = uploadOutPut.PMessageText,
                            data = importFileResults
                        };

                        return Json(resultJsonError);
                    }
                }
                else
                {
                    var resultJson = new
                    {
                        success = true,
                        response = "Import data successfully executed"
                    };

                    return Json(resultJson);
                }
            }
            catch (Exception ex)
            {
                var resultJson = new
                {
                    success = false,
                    response = ex.Message
                };

                return Json(resultJson);
            }
        }

        #endregion Excel import

        #region Flexi to DMS

        public async Task<IActionResult> FlexiToDMSIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterMovementIndex
            });

            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            FlexiToDMSIndexViewModel flexiToDMSIndexViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(flexiToDMSIndexViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetFlexiToDMSLists(DTParameters param)
        {
            DTResult<FlexiToDMSDataTableList> result = new();
            int totalRow = 0;

            try
            {
                IEnumerable<FlexiToDMSDataTableList> data = await _flexiToDMSDataTableListRepository.FlexiToDMSDataTableListAsync(
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

        [HttpPost]
        public async Task<IActionResult> FlexiToDMSRollback(string id)
        {
            try
            {
                var result = await _flexiToDMSRepository.FlexiToDMSRollbackAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PKeyId = id
                    });

                return Json(new { success = result.PMessageType == IsOk, response = result.PMessageType, message = result.PMessageText });

                //return result.PMessageType != IsOk
                // ? throw new Exception(result.PMessageText.Replace("-", " "))
                // : (IActionResult)Json(new { success = true, response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        [HttpGet]
        public IActionResult ImportFlexiDeskToDMS()
        {
            FlexiToDMSImportViewModel flexiToDMSImportViewModel = new();

            return PartialView("_ModalImportFlexiToDMSPartial", flexiToDMSImportViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ImportFlexiDeskToDMS(FlexiToDMSImportViewModel flexiToDMSImportViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var jsonstring = flexiToDMSImportViewModel.Deskid;

                    jsonstring = jsonstring.Replace(" ", "");

                    if(jsonstring == null || jsonstring == "")
                        throw new Exception("Please Enter Valid Deskid");

                    //if (jsonstring != null)
                    //{                        
                    //    if (jsonstring.Length >= 5 && jsonstring.Length <= 7)
                    //    {
                    //        throw new Exception("Please Enter Valid Deskid");
                    //    }
                    //}

                    //string[] arrItems = jsonstring.Split(',');

                    string[] arrItems = jsonstring.Split(new string[] { Environment.NewLine }, StringSplitOptions.None);

                    List<ReturnDeskid> returnDeskList = new List<ReturnDeskid>();

                    foreach (var desk in arrItems)
                    {
                        if (desk != "" && desk.Length >= 5 && desk.Length <= 7)
                        {
                            returnDeskList.Add(new ReturnDeskid { Deskid = desk });
                        }
                    }
                    if (!returnDeskList.Any())
                    {
                        throw new Exception("Please enter valid deskid (max length: 7)");
                    }
                    string formattedJson = JsonConvert.SerializeObject(returnDeskList);

                    var result = await _flexiToDMSRepository.ImportFlexiDeskToDMSJSonAsync(
                              BaseSpTcmPLGet(),
                              new ParameterSpTcmPL
                              {
                                  PParameterJson = formattedJson
                              });

                    return result.PMessageType != IsOk
                        ? throw new Exception(result.PMessageText.Replace("-", " "))
                        : (IActionResult)Json(new { success = true, response = result.PMessageText });
                }
                throw new Exception("Please Enter Valid Deskid");
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }        

        public string MultilineToCSV(string sourceStr)
        {
            if (string.IsNullOrEmpty(sourceStr))
            {
                return ("");
            }

            bool s = !Regex.IsMatch(sourceStr, @"[^0-9A-Za-z, \r\n]");

            if (!s)
            {
                throw new Exception("Please Enter Valid Desid");
            }

            string retVal = sourceStr.Replace(System.Environment.NewLine, ",");

            retVal = Regex.Replace(retVal, @"\s+", ",");

            return retVal;
        }

        #endregion Flexi to DMS
    }
}