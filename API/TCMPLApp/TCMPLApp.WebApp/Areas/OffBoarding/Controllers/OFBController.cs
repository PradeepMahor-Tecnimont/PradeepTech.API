using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.Common;
using TCMPLApp.WebApp.Controllers;
using TCMPLApp.WebApp.Models;
using TCMPLApp.DataAccess.Repositories.SWPVaccine;
using Microsoft.AspNetCore.Mvc.Rendering;
using System.Collections.Generic;
using System;
using TCMPLApp.Domain.Models.OffBoarding;
using System.Linq;
using System.Net;
using TCMPLApp.WebApp.Classes;
using TCMPLApp.DataAccess.Repositories.OffBoarding;
using static TCMPLApp.WebApp.Classes.DTModel;
using TCMPLApp.WebApp.CustomPolicyProvider;
using MimeTypes;
using TCMPLApp.Domain.Models.Common;
using TCMPLApp.Domain.Models.Timesheet;
using TCMPLApp.Library.Excel.Template.Models;
using Microsoft.AspNetCore.Authorization;
using TCMPLApp.Domain.Models.DMS;
using DocumentFormat.OpenXml.Drawing.Charts;
using OfficeOpenXml.FormulaParsing.Excel.Functions.DateTime;
using DocumentFormat.OpenXml.Math;
using DocumentFormat.OpenXml.Packaging;
using System.IO;
using TCMPLApp.Library.Excel.Writer;
using System.Linq.Dynamic.Core.Tokenizer;
using ClosedXML.Excel;

namespace TCMPLApp.WebApp.Areas.OffBoarding.Controllers
{
    [Area("OffBoarding")]
    public class OFBController : BaseController
    {
        //private readonly string Success = "OK";

        private const string ConstFilterOFBInitIndex = "OFBInitIndex";
        private const string ConstFilterOFBRollbackPendingIndex = "OFBRollbackPendingIndex";
        private const string ConstFilterOFBRollbackHistoryIndex = "OFBRollbackHistoryIndex";
        private const string ConstFilterOFBApprovalsIndex = "OFBApprovalsIndex";
        private const string ConstFilterOFBAllApprovalsHistoryIndex = "OFBAllApprovalsHistoryIndex";
        private const string ConstFilterOFBPendingApprovalsHistoryIndex = "OFBPendingApprovalsHistoryIndex";
        private const string ConstFilterOFBApproveApprovalsHistoryIndex = "OFBApproveApprovalsHistoryIndex";
        private const string ConstFilterOFBResetApprovalsIndex = "OFBResetApprovalsIndex";
        private const string ConstFilterOFBEmployeeInfoIndex = "OFBEmployeeInfoIndex";

        private const string ConstXLDownloadTypeAllApprovalHistory = "AllApprovalHistory";
        private const string ConstXLDownloadTypeApprovedApprovalHistory = "ApprovedApprovalHistory";
        private const string ConstXLDownloadTypeApprovals = "Approvals";
        private const string ConstXLDownloadTypeConfidentialXLDownload = "ConfidentialXLDownload";
        private const string ConstXLDownloadTypeAllApprovalHistorySummary = "AllApprovalHistorySummary";

        private readonly IFilterRepository _filterRepository;
        private readonly IUtilityRepository _utilityRepository;
        private readonly ISelectTcmPLRepository _selectTcmPLRepository;
        private readonly IOFBInitRepository _oFBInitRepository;
        private readonly IOFBInitDataTableListRepository _oFBInitDataTableListRepository;

        private readonly IOFBInitDetailRepository _oFBInitDetailRepository;
        private readonly IOFBPendingApprovalsDataTableListRepository _oFBPendingApprovalsDataTableListRepository;
        private readonly IOFBHistoryDataTableListRepository _oFBApprovalsHistoryDataTableListRepository;
        private readonly IOFBApprovalDetailRepository _oFBApprovalDetailRepository;
        private readonly IOFBApprovalRepository _oFBApprovalRepository;
        private readonly IOFBApprovalDetailsDataTableListRepository _oFBApprovalDetailsDataTableListRepository;
        private readonly IOFBHistoryXLDataTableListRepository _oFBHistoryXLDataTableListRepository;
        private readonly IOFBApprovalsDataTableListRepository _oFBApprovalsDataTableListRepository;
        private readonly IOFBApprovalsXLDataTableListRepository _oFBApprovalsXLDataTableListRepository;
        private readonly IOFBResetApprovalsDataTableListRepository _oFBResetApprovalsDataTableListRepository;
        private readonly IOFBResetApprovalsRepository _oFBResetApprovalsRepository;
        private readonly IOFBApprovalActionDetailRepository _oFBApprovalActionDetailRepository;

        private readonly IOFBRollbackRepository _oFBRollbackRepository;
        private readonly IOFBEmpExitDetailsRepository _oFBEmpExitDetailsRepository;
        private readonly IOFBRollbackDataTableListRepository _oFBRollbackDataTableListRepository;
        private readonly IOFBDeptmntExitApprovalsDataTableListRepository _oFBDeptmntExitApprovalsDataTableListRepository;
        private readonly IEmployeeDetailsRepository _employeeDetailsRepository;

        private readonly ICommonEmployeeDetailsRepository _commonEmployeeDetailsRepository;

        public OFBController(
                                IFilterRepository filterRepository,
                                IUtilityRepository utilityRepository,
                                ISelectTcmPLRepository selectTcmPLRepository,
                                IOFBInitRepository oFBInitRepository,
                                IOFBInitDataTableListRepository oFBInitDataTableListRepository,

                                IOFBInitDetailRepository oFBInitDetailRepository,
                                IOFBPendingApprovalsDataTableListRepository oFBPendingApprovalsDataTableListRepository,
                                IOFBHistoryDataTableListRepository oFBApprovalsHistoryDataTableListRepository,
                                IOFBApprovalDetailRepository oFBApprovalDetailRepository,
                                IOFBApprovalRepository oFBApprovalRepository,
                                IOFBApprovalDetailsDataTableListRepository oFBApprovalDetailsDataTableListRepository,
                                IOFBRollbackRepository oFBRollbackRepository,
                                IOFBEmpExitDetailsRepository oFBEmpExitDetailsRepository,
                                IOFBRollbackDataTableListRepository oFBRollbackDataTableListRepository,
                                IOFBHistoryXLDataTableListRepository oFBHistoryXLDataTableListRepository,
                                IOFBApprovalsDataTableListRepository oFBApprovalsDataTableListRepository,
                                IOFBApprovalsXLDataTableListRepository oFBApprovalsXLDataTableListRepository,
                                IOFBResetApprovalsDataTableListRepository oFBResetApprovalsDataTableListRepository,
                                IOFBResetApprovalsRepository oFBResetApprovalsRepository,
                                IOFBDeptmntExitApprovalsDataTableListRepository oFBDeptmntExitApprovalsDataTableListRepository,
                                IEmployeeDetailsRepository employeeDetailsRepository,
                                ICommonEmployeeDetailsRepository commonEmployeeDetailsRepository,
                                IOFBApprovalActionDetailRepository oFBApprovalActionDetailRepository)
        {
            _filterRepository = filterRepository;
            _utilityRepository = utilityRepository;
            _selectTcmPLRepository = selectTcmPLRepository;
            _oFBInitRepository = oFBInitRepository;
            _oFBInitDataTableListRepository = oFBInitDataTableListRepository;

            _oFBInitDetailRepository = oFBInitDetailRepository;
            _oFBPendingApprovalsDataTableListRepository = oFBPendingApprovalsDataTableListRepository;
            _oFBApprovalsHistoryDataTableListRepository = oFBApprovalsHistoryDataTableListRepository;
            _oFBApprovalDetailRepository = oFBApprovalDetailRepository;
            _oFBApprovalRepository = oFBApprovalRepository;
            _oFBApprovalDetailsDataTableListRepository = oFBApprovalDetailsDataTableListRepository;
            _oFBRollbackRepository = oFBRollbackRepository;
            _oFBEmpExitDetailsRepository = oFBEmpExitDetailsRepository;
            _oFBRollbackDataTableListRepository = oFBRollbackDataTableListRepository;
            _oFBHistoryXLDataTableListRepository = oFBHistoryXLDataTableListRepository;
            _oFBApprovalsDataTableListRepository = oFBApprovalsDataTableListRepository;
            _oFBApprovalsXLDataTableListRepository = oFBApprovalsXLDataTableListRepository;
            _oFBDeptmntExitApprovalsDataTableListRepository = oFBDeptmntExitApprovalsDataTableListRepository;
            _employeeDetailsRepository = employeeDetailsRepository;
            _oFBResetApprovalsDataTableListRepository = oFBResetApprovalsDataTableListRepository;
            _oFBResetApprovalsRepository = oFBResetApprovalsRepository;
            _commonEmployeeDetailsRepository = commonEmployeeDetailsRepository;
            _oFBApprovalActionDetailRepository = oFBApprovalActionDetailRepository;
        }

        #region OFBInit

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, OffBoardingHelper.ActionInitializeOffBoarding)]
        public async Task<IActionResult> OFBInitIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterOFBInitIndex
            });

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            OFBInitViewModel oFBInitViewModel = new()
            {
                FilterDataModel = filterDataModel
            };
            return View(oFBInitViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, OffBoardingHelper.ActionInitializeOffBoarding)]
        public async Task<JsonResult> GetListsOFBInit(string paramJSon)
        {
            DTResult<OFBInitDataTableList> result = new();

            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJSon);

            int totalRow = 0;

            System.Collections.Generic.IEnumerable<OFBInitDataTableList> data = await _oFBInitDataTableListRepository.OFBInitDataTableListAsync(
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

        public async Task<IActionResult> SelectEmployee()
        {
            OFBSelectEmployeeViewModel oFBSelectEmployeeViewModel = new();

            var ofbEmployeeList = await _selectTcmPLRepository.OFBEmployeeList(BaseSpTcmPLGet(), null);

            ViewData["EmployeeList"] = new SelectList(ofbEmployeeList, "DataValueField", "DataTextField");

            return PartialView("_ModalSelectEmployee", oFBSelectEmployeeViewModel);

            //return View("OFBInitCreate");
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, OffBoardingHelper.ActionInitializeOffBoarding)]
        public async Task<IActionResult> OFBInitCreateIndex(string employee)
        {
            if (string.IsNullOrEmpty(employee))
            {
                Notify("Error", "Invalid or blank Employee..", "toaster", NotificationType.error);
                return RedirectToAction("OFBInitIndex");
            }

            var employeeDetails = await _commonEmployeeDetailsRepository.EmployeeDetailAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL { PEmpno = employee });

            OFBInitDetails result = await _oFBInitDetailRepository.OFBInitDetail(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PEmpno = employee
                });

            if (result.PMessageType == NotOk || result.PEmpOfbExists == IsOk)
            {
                Notify("Error", result.PMessageType == NotOk ? result.PMessageText : "OffBoarding for the employee already initiated.", "", NotificationType.error);
                return RedirectToAction("OFBInitIndex");
            }
            OFBInitCreateViewModel oFBInitCreateViewModel = new OFBInitCreateViewModel();

            if (result.PMessageType == IsOk)
            {
                oFBInitCreateViewModel.Empno = employee;
                oFBInitCreateViewModel.EmployeeName = employee + " -  " + employeeDetails.PName;
                oFBInitCreateViewModel.PersonId = employeeDetails.PEmpPersonId;
                oFBInitCreateViewModel.Grade = employeeDetails.PGrade;
                oFBInitCreateViewModel.EmpType = employeeDetails.PEmpType;
                oFBInitCreateViewModel.Doj = employeeDetails.PDoj;
                oFBInitCreateViewModel.DesgCode = employeeDetails.PDesgCode;
                oFBInitCreateViewModel.DesgName = employeeDetails.PDesgName;
                oFBInitCreateViewModel.Hod = employeeDetails.PHoD;
                oFBInitCreateViewModel.HodName = employeeDetails.PHoDName;
                oFBInitCreateViewModel.CostName = employeeDetails.PParent + " - " + employeeDetails.PCostName;

                oFBInitCreateViewModel.Hod = employeeDetails.PHoD;
                oFBInitCreateViewModel.HodName = employeeDetails.PHoDName;

                oFBInitCreateViewModel.RelievingDate = result.PRelievingDate;

                oFBInitCreateViewModel.ResignationDate = result.PResignationDate;
            }
            return View(oFBInitCreateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, OffBoardingHelper.ActionInitializeOffBoarding)]
        public async Task<IActionResult> OFBInitCreate([FromForm] OFBInitCreateViewModel oFBInitCreateViewModel)
        {
            if (ModelState.IsValid)
            {
                Domain.Models.Common.DBProcMessageOutput result = await _oFBInitRepository.OFBInitCreateAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PEmpno = oFBInitCreateViewModel.Empno,
                        PRemarks = oFBInitCreateViewModel.Remarks,
                        PEndByDate = oFBInitCreateViewModel.EndByDate,
                        PRelievingDate = oFBInitCreateViewModel.RelievingDate,
                        PAddress = oFBInitCreateViewModel.Address,
                        PResignationDate = oFBInitCreateViewModel.ResignationDate,
                        PEmailId = oFBInitCreateViewModel.EmailId,
                        PPrimaryMobile = oFBInitCreateViewModel.MobilePrimary,
                        PAlternateMobile = oFBInitCreateViewModel.AlternateNumber,
                    });
                if (result.PMessageType == IsOk)
                {
                    Notify("Success", "Procedure executed successfully", "", NotificationType.success);
                    return RedirectToAction("OFBInitEdit", new { id = oFBInitCreateViewModel.Empno });
                }
                else
                {
                    Notify("Error", result.PMessageText, "", NotificationType.error);
                }
            }
            var employeeDetails = await _commonEmployeeDetailsRepository.EmployeeDetailAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL { PEmpno = oFBInitCreateViewModel.Empno });

            oFBInitCreateViewModel.EmployeeName = employeeDetails.PName;
            oFBInitCreateViewModel.PersonId = employeeDetails.PEmpPersonId;
            oFBInitCreateViewModel.Grade = employeeDetails.PGrade;
            oFBInitCreateViewModel.EmpType = employeeDetails.PEmpType;
            oFBInitCreateViewModel.Doj = employeeDetails.PDoj;
            oFBInitCreateViewModel.DesgCode = employeeDetails.PDesgCode;
            oFBInitCreateViewModel.DesgName = employeeDetails.PDesgName;

            oFBInitCreateViewModel.Hod = employeeDetails.PHoD;
            oFBInitCreateViewModel.HodName = employeeDetails.PHoDName;

            return View("OFBInitCreateIndex", oFBInitCreateViewModel);
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, OffBoardingHelper.ActionInitializeOffBoarding)]
        public async Task<IActionResult> OFBInitEdit(string id)
        {
            if (id == null)
            {
                return NotFound();
            }
            string empno = id.ToUpper();
            var employeeDetails = await _commonEmployeeDetailsRepository.EmployeeDetailAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL { PEmpno = empno });

            OFBInitDetails result = await _oFBInitDetailRepository.OFBInitDetail(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PEmpno = empno
                });

            OFBInitEditViewModel oFBInitEditViewModel = new();

            if (result.PMessageType == IsOk)
            {
                oFBInitEditViewModel.Empno = empno;
                oFBInitEditViewModel.EmployeeName = empno + " -  " + employeeDetails.PName;
                oFBInitEditViewModel.PersonId = employeeDetails.PEmpPersonId;
                oFBInitEditViewModel.Grade = employeeDetails.PGrade;
                oFBInitEditViewModel.EmpType = employeeDetails.PEmpType;
                oFBInitEditViewModel.Doj = employeeDetails.PDoj;
                oFBInitEditViewModel.DesgCode = employeeDetails.PDesgCode;
                oFBInitEditViewModel.DesgName = employeeDetails.PDesgName;
                oFBInitEditViewModel.Hod = employeeDetails.PHoD;
                oFBInitEditViewModel.HodName = employeeDetails.PHoDName;
                oFBInitEditViewModel.CostName = employeeDetails.PParent + " - " + employeeDetails.PCostName;

                oFBInitEditViewModel.Hod = employeeDetails.PHoD;
                oFBInitEditViewModel.HodName = employeeDetails.PHoDName;
                oFBInitEditViewModel.Remarks = result.PRemarks;

                oFBInitEditViewModel.EndByDate = result.PEndByDate;
                oFBInitEditViewModel.RelievingDate = result.PRelievingDate;
                oFBInitEditViewModel.Address = result.PAddress;
                oFBInitEditViewModel.ResignationDate = result.PResignationDate;
                oFBInitEditViewModel.EmailId = result.PEmailId;
                oFBInitEditViewModel.MobilePrimary = result.PPrimaryMobile;
                oFBInitEditViewModel.AlternateNumber = result.PAlternateMobile;

                return View("OFBInitEdit", oFBInitEditViewModel);
            }
            return RedirectToAction("OFBInitIndex");
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, OffBoardingHelper.ActionInitializeOffBoarding)]
        public async Task<IActionResult> OFBInitEdit([FromForm] OFBInitEditViewModel oFBInitEditViewModel)
        {
            if (ModelState.IsValid)
            {
                Domain.Models.Common.DBProcMessageOutput result = await _oFBInitRepository.OFBInitEditAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PEmpno = oFBInitEditViewModel.Empno,
                        PRemarks = oFBInitEditViewModel.Remarks,
                        PEndByDate = oFBInitEditViewModel.EndByDate,
                        PRelievingDate = oFBInitEditViewModel.RelievingDate,
                        PAddress = oFBInitEditViewModel.Address,
                        PResignationDate = oFBInitEditViewModel.ResignationDate,
                        PEmailId = oFBInitEditViewModel.EmailId,
                        PPrimaryMobile = oFBInitEditViewModel.MobilePrimary,
                        PAlternateMobile = oFBInitEditViewModel.AlternateNumber
                    });

                if (result.PMessageType == IsOk)
                {
                    Notify("Success", "Procedure executed successfully", "", NotificationType.success);
                    return RedirectToAction("OFBInitEdit", new { id = oFBInitEditViewModel.Empno });
                }
                else
                {
                    Notify("Error", result.PMessageText, "", NotificationType.error);
                }
            }
            return View("OFBInitEdit", oFBInitEditViewModel);
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, OffBoardingHelper.ActionCreateRollbackRequest)]
        public async Task<IActionResult> OFBRollback(string empno)
        {
            if (empno == null)
            {
                return NotFound();
            }

            var empDetails = await _commonEmployeeDetailsRepository.EmployeeDetailAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL { PEmpno = empno });

            OFBRollbackRequestViewModel oFBRollbackRequestViewModel = new()
            {
                Empno = empno
            };

            OFBInitDetails empExitDetails = await _oFBInitDetailRepository.OFBInitDetail(
                   BaseSpTcmPLGet(),
                   new ParameterSpTcmPL
                   {
                       PEmpno = empno
                   });

            if (empExitDetails.PMessageType != IsOk)
            {
                throw new Exception(empExitDetails.PMessageText.Replace("-", " "));
            }

            oFBRollbackRequestViewModel.EndByDate = empExitDetails.PEndByDate;
            oFBRollbackRequestViewModel.ResignationDate = empExitDetails.PResignationDate;
            oFBRollbackRequestViewModel.RelievingDate = empExitDetails.PRelievingDate;

            oFBRollbackRequestViewModel.EmailId = empExitDetails.PEmailId;
            oFBRollbackRequestViewModel.AlternateMobile = empExitDetails.PAlternateMobile;
            oFBRollbackRequestViewModel.PrimaryMobile = empExitDetails.PPrimaryMobile;
            oFBRollbackRequestViewModel.Address = empExitDetails.PAddress;
            oFBRollbackRequestViewModel.Remarks = empExitDetails.PRemarks;

            oFBRollbackRequestViewModel.EmployeeName = empDetails.PName;
            oFBRollbackRequestViewModel.EmpType = empDetails.PEmpType;
            oFBRollbackRequestViewModel.CostName = empDetails.PCostName;
            oFBRollbackRequestViewModel.CostCode = empDetails.PParent;
            oFBRollbackRequestViewModel.Grade = empDetails.PGrade;
            oFBRollbackRequestViewModel.Hod = empDetails.PHoD;
            oFBRollbackRequestViewModel.HodName = empDetails.PHoDName;
            oFBRollbackRequestViewModel.DesgCode = empDetails.PDesgCode;
            oFBRollbackRequestViewModel.DesgName = empDetails.PDesgName;

            return PartialView("_ModalOFBRollbackRequest", oFBRollbackRequestViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, OffBoardingHelper.ActionCreateRollbackRequest)]
        public async Task<IActionResult> OFBRollback(OFBRollbackRequestViewModel oFBRollbackRequestViewModel)
        {
            if (ModelState.IsValid)
            {
                Domain.Models.Common.DBProcMessageOutput result = await _oFBRollbackRepository.RollbackRequestCreateAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PEmpno = oFBRollbackRequestViewModel.Empno,
                        PRemarks = oFBRollbackRequestViewModel.RollbackRemarks,
                    });

                //if (result.PMessageType == IsOk)
                //{
                //    Notify("Success", "Procedure executed successfully", "", NotificationType.success);
                //}
                //else
                //{
                //    Notify("Error", result.PMessageText, "", NotificationType.error);
                //}

                return result.PMessageType == NotOk
                    ? throw new Exception(result.PMessageText.Replace("-", " "))
                    : (IActionResult)Json(new { success = true, response = result.PMessageText });
            }
            return PartialView("_ModalOFBRollbackRequest", oFBRollbackRequestViewModel);
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, OffBoardingHelper.ActionInitializeOffBoarding)]
        public async Task<IActionResult> OFBInitExcelDownload()
        {
            var retVal = await RetriveFilter(ConstFilterOFBInitIndex);

            FilterDataModel filterDataModel;
            if (string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = new FilterDataModel();
                filterDataModel.StartYear = DateTime.Now.AddYears(-2);
                filterDataModel.EndYear = DateTime.Now;
            }
            else
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            return PartialView("_ModalOFBInitFilterSet", filterDataModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, OffBoardingHelper.ActionInitializeOffBoarding)]
        public async Task<IActionResult> OFBInitExcelDownload(string startYear, string endYear)
        {
            if (Convert.ToInt32(endYear) - Convert.ToInt32(startYear) > 3)
            {
                throw new Exception("Please Select Valid Year.!");
            }
            var timeStamp = DateTime.Now.ToFileTime();

            string fileName = "Off Boarding Init Details_" + timeStamp.ToString();
            string reportTitle = "Off Boarding Init Details from " + startYear + " To " + endYear + " onward " + DateTime.Now.ToString();
            string sheetName = "Off Boarding Init Details";

            var data = await _oFBHistoryXLDataTableListRepository.OFBHistoryAllContactInfoDataTableListForExcelAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PStartYear = startYear,
                    PEndYear = endYear,
                });

            if (data.Count() == 0) { throw new Exception("No Data Found"); }

            byte[] byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(data, reportTitle, sheetName);

            return File(byteContent,
                        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                        fileName + ".xlsx");
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, OffBoardingHelper.ActionInitializeOffBoarding)]
        public async Task<IActionResult> InitDetails(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            OFBInitDetailsViewModel oFBInitDetailsViewModel = await GetInitDetail(id, null);
            oFBInitDetailsViewModel.ViewName = "OFBInitIndex";

            return View("OFBInitDetails", oFBInitDetailsViewModel);
        }

        #endregion OFBInit

        #region OFBApprove

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, OffBoardingHelper.ActionActionForApprovalTile)]
        public async Task<IActionResult> OFBApprovalsIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterOFBApprovalsIndex
            });

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            OFBInitViewModel oFBInitViewModel = new()
            {
                FilterDataModel = filterDataModel
            };
            return View(oFBInitViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsOFBPendingApprovals(string paramJSon)
        {
            DTResult<OFBInitDataTableList> result = new();

            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJSon);

            int totalRow = 0;

            System.Collections.Generic.IEnumerable<OFBInitDataTableList> data = await _oFBPendingApprovalsDataTableListRepository.OFBPendingApprovalsDataTableListAsync(
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

        public async Task<IActionResult> OFBInitDetails(string id, string actionid, string actiondesc)
        {
            if (id == null || actionid == null)
            {
                return NotFound();
            }
            OFBApprovalUpdateViewModel oFBApprovalUpdateViewModel = new();
            oFBApprovalUpdateViewModel.ActionDesc = actiondesc;

            var employeeDetails = await _commonEmployeeDetailsRepository.EmployeeDetailAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL { PEmpno = id });

            OFBInitDetails result = await _oFBInitDetailRepository.OFBInitDetail(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PEmpno = id
                });

            if (result.PMessageType == IsOk)
            {
                oFBApprovalUpdateViewModel.Empno = id;
                oFBApprovalUpdateViewModel.EmployeeName = employeeDetails.PName;
                oFBApprovalUpdateViewModel.PersonId = employeeDetails.PEmpPersonId;
                oFBApprovalUpdateViewModel.Parent = employeeDetails.PAssign + " - " + employeeDetails.PAssignName;
                oFBApprovalUpdateViewModel.Grade = employeeDetails.PGrade;
                oFBApprovalUpdateViewModel.InitiatorRemarks = result.PRemarks;
                oFBApprovalUpdateViewModel.MobilePrimary = result.PPrimaryMobile;
                oFBApprovalUpdateViewModel.AlternateNumber = result.PAlternateMobile;
                oFBApprovalUpdateViewModel.Address = result.PAddress;
                oFBApprovalUpdateViewModel.EmailId = result.PEmailId;
                oFBApprovalUpdateViewModel.RelievingDate = result.PRelievingDate.GetValueOrDefault();
                oFBApprovalUpdateViewModel.ResignationDate = result.PResignationDate.GetValueOrDefault();
                oFBApprovalUpdateViewModel.Doj = employeeDetails.PDoj;
                oFBApprovalUpdateViewModel.ApprovalActionId = actionid;
            }

            OFBApprovalActionDetails data = await _oFBApprovalActionDetailRepository.OFBActionApprovalDetail(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PEmpno = id,
                    PApprlActionId = actionid
                });

            if (data.PMessageType == IsOk)
            {
                oFBApprovalUpdateViewModel.Remarks = data.PApprovalRemarks;
                oFBApprovalUpdateViewModel.IsApprovalDue = data.PIsApprovalDue;
            }
            else
            {
                Notify("Error", result.PMessageText, "", NotificationType.error);
                return RedirectToAction("OFBApprovalsIndex");
            }

            if (oFBApprovalUpdateViewModel.IsApprovalDue == NotOk)
            {
                Notify("Error", result.PMessageType == NotOk ? result.PMessageText : "Approval not yet due.", "", NotificationType.error);
                return RedirectToAction("OFBApprovalsIndex");
            }
            return View("OFBInitApprovalDetails", oFBApprovalUpdateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, OffBoardingHelper.ActionActionForApprovalTile)]
        public async Task<IActionResult> OFBApprovalUpdate([FromForm] OFBApprovalUpdateViewModel oFBApprovalUpdateViewModel)
        {
            if (!(CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == oFBApprovalUpdateViewModel.ApprovalActionId)))
            {
                return Unauthorized();
            }
            if (ModelState.IsValid)
            {
                Domain.Models.Common.DBProcMessageOutput result = new();
                if (oFBApprovalUpdateViewModel.ApprovalType == "HOLD")
                {
                    result = await _oFBApprovalRepository.OFBApprovalHoldAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PEmpno = oFBApprovalUpdateViewModel.Empno,
                        PRemarks = oFBApprovalUpdateViewModel.Remarks,
                        //PActionId = oFBApprovalUpdateViewModel.ActionId,
                        PApprlActionId = oFBApprovalUpdateViewModel.ApprovalActionId
                    });
                }
                else
                {
                    result = await _oFBApprovalRepository.OFBApprovalEditAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PEmpno = oFBApprovalUpdateViewModel.Empno,
                        PRemarks = oFBApprovalUpdateViewModel.Remarks,
                        //PActionId = oFBApprovalUpdateViewModel.ActionId,
                        PApprlActionId = oFBApprovalUpdateViewModel.ApprovalActionId
                    });
                }
                if (result.PMessageType == IsOk)
                {
                    Notify("Success", "Procedure executed successfully", "", NotificationType.success);
                    return RedirectToAction("OFBDetails", new { id = oFBApprovalUpdateViewModel.Empno, actionid = oFBApprovalUpdateViewModel.ApprovalActionId });
                }
                else
                {
                    Notify("Error", result.PMessageText, "", NotificationType.error);
                }
            }
            return View("OFBInitApprovalDetails", oFBApprovalUpdateViewModel);
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, OffBoardingHelper.ActionViewApprovals)]
        public async Task<IActionResult> OFBApprovalsDetailsIndex(string id)
        {
            if (id == null)
                return NotFound();

            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterOFBApprovalsIndex
            });

            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            OFBApprovalDetailsViewModel oFBApprovalDetailsViewModel = new()
            {
                FilterDataModel = filterDataModel
            };
            return PartialView("_OFBApprovalsDetailsIndexPartial", oFBApprovalDetailsViewModel);
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, OffBoardingHelper.ActionActionForApprovalTile)]
        public async Task<IActionResult> OFBApprovalsHistoryDetailsIndex(string id)
        {
            if (id == null)
                return NotFound();

            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterOFBApprovalsIndex
            });

            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            OFBApprovalDetailsViewModel oFBApprovalDetailsViewModel = new()
            {
                FilterDataModel = filterDataModel
            };
            oFBApprovalDetailsViewModel.ViewName = "HistoryIndex";
            return PartialView("_OFBApprovalsDetailsIndexPartial", oFBApprovalDetailsViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, OffBoardingHelper.ActionViewApprovals)]
        public async Task<JsonResult> GetListsOFBApprovalsDetails(string paramJSon)
        {
            DTResult<OFBApprovalDetailsDataTableList> result = new();

            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJSon);

            int totalRow = 0;
            System.Collections.Generic.IEnumerable<OFBApprovalDetailsDataTableList> data = null;

            if (
                CurrentUserIdentity.ProfileActions.Any(a => a.ActionId == OffBoardingHelper.ActionViewAllApprovals)
                || (CurrentUserIdentity.ProfileActions.Any(a => a.ActionId == OffBoardingHelper.ActionViewSelfOFB && CurrentUserIdentity.EmpNo == param.Empno))
                )
            {
                data = await _oFBApprovalDetailsDataTableListRepository.OFBApprovalDetailsAllDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PEmpno = param.Empno,
                    }
                );
            }
            else
            {
                data = await _oFBApprovalDetailsDataTableListRepository.OFBApprovalDetailsDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PEmpno = param.Empno,
                    }
                );
            }
            if (data.Any())
            {
                totalRow = (int)data.Count();
            }

            result.draw = param.Draw;
            result.recordsTotal = totalRow;
            result.recordsFiltered = totalRow;
            result.data = data.ToList();

            return Json(result);
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, OffBoardingHelper.ActionActionForApprovalTile)]
        public async Task<IActionResult> OFBApprovalsHistoryIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterOFBApprovalsIndex
            });

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            OFBInitViewModel oFBInitViewModel = new()
            {
                FilterDataModel = filterDataModel
            };
            ViewData["XLDownloadType"] = ConstXLDownloadTypeApprovals;
            return View(oFBInitViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsOFBApprovalsHistory(string paramJSon)
        {
            DTResult<OFBInitDataTableList> result = new();

            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJSon);

            int totalRow = 0;

            System.Collections.Generic.IEnumerable<OFBInitDataTableList> data = await _oFBApprovalsDataTableListRepository.OFBApprovalsDataTableListAsync(
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

        public async Task<IActionResult> OFBDetails(string id)
        {
            if (id == null)
            {
                return NotFound();
            }
            OFBInitDetailsViewModel oFBInitDetailsViewModel = await GetInitDetail(id, null);
            oFBInitDetailsViewModel.ViewName = "OFBApprovedHistoryIndex";

            return View("OFBInitDetails", oFBInitDetailsViewModel);
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, OffBoardingHelper.ActionActionForApprovalTile)]
        public async Task<IActionResult> OFBApprovalsXL(string startYear, string endYear)
        {
            long timeStamp = DateTime.Now.ToFileTime();
            string fileName = "OFB Approvals History Details_" + timeStamp.ToString();
            string reportTitle = "OFB Approvals History Details from " + startYear + " To " + endYear + " onward " + DateTime.Now.ToString();
            string sheetName = "OFB Approvals History Details";

            var data = await _oFBApprovalsXLDataTableListRepository.OFBApprovalsDataTableListForExcelAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PStartYear = startYear,
                    PEndYear = endYear,
                });

            if (data == null || data.Count() == 0) { throw new Exception("No Data Found"); }

            //var json = JsonConvert.SerializeObject(data);

            //IEnumerable<OFBApprovalsHistroyXLViewModel> excelData = JsonConvert.DeserializeObject<IEnumerable<OFBApprovalsHistroyXLViewModel>>(json);

            byte[] byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(data, reportTitle, sheetName);

            return File(byteContent,
                        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                        fileName + ".xlsx");
        }

        #endregion OFBApprove

        #region ApprovalsHistory

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, OffBoardingHelper.ActionViewHistory)]
        public async Task<IActionResult> OFBHistoryIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterOFBAllApprovalsHistoryIndex
            });

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            OFBInitViewModel oFBInitViewModel = new()
            {
                FilterDataModel = filterDataModel
            };
            ViewData["XLDownloadType"] = ConstXLDownloadTypeAllApprovalHistory;
            return View(oFBInitViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, OffBoardingHelper.ActionViewHistory)]
        public async Task<JsonResult> GetListsOFBAllApprovalsHistory(string paramJSon)
        {
            DTResult<OFBInitDataTableList> result = new();

            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJSon);

            int totalRow = 0;

            System.Collections.Generic.IEnumerable<OFBInitDataTableList> data = await _oFBApprovalsHistoryDataTableListRepository.OFBAllApprovalsHistoryDataTableListAsync(
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

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, OffBoardingHelper.ActionViewHistory)]
        public async Task<IActionResult> OFBPendingApprovalsIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterOFBPendingApprovalsHistoryIndex
            });

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            OFBInitViewModel oFBInitViewModel = new()
            {
                FilterDataModel = filterDataModel
            };
            return PartialView("_OFBPendingApprovalsDetailsPartial", oFBInitViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, OffBoardingHelper.ActionViewHistory)]
        public async Task<JsonResult> GetListsOFBPendingApprovalsHistory(string paramJSon)
        {
            DTResult<OFBInitDataTableList> result = new();

            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJSon);

            int totalRow = 0;

            System.Collections.Generic.IEnumerable<OFBInitDataTableList> data = await _oFBApprovalsHistoryDataTableListRepository.OFBPendingApprovalsHistoryDataTableListAsync(
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

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, OffBoardingHelper.ActionViewHistory)]
        public async Task<IActionResult> OFBPendingAppHistoryExcelDownload()
        {
            var timeStamp = DateTime.Now.ToFileTime();
            string fileName = "OFB Pending Approvals Details_" + timeStamp.ToString();
            string reportTitle = "OFB Pending Approvals Details ";
            string sheetName = "OFB Pending Approvals Details";

            var data = await _oFBHistoryXLDataTableListRepository.OFBHistoryPendingDataTableListForExcelAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                });

            if (data == null || data.Count() == 0) { throw new Exception("No Data Found"); }

            var json = JsonConvert.SerializeObject(data);

            IEnumerable<OFBApprovalsHistroyXLViewModel> excelData = JsonConvert.DeserializeObject<IEnumerable<OFBApprovalsHistroyXLViewModel>>(json);

            byte[] byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, reportTitle, sheetName);

            var mimeType = MimeTypeMap.GetMimeType("xlsx");

            FileContentResult file = File(byteContent, mimeType, fileName);

            return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, OffBoardingHelper.ActionViewHistory)]
        public async Task<IActionResult> OFBPendingAppHistorySummaryExcelDownload()
        {
            string excelFileName = "OFB_Pending.xlsx";
            var timeStamp = DateTime.Now.ToFileTime();                                 

            IEnumerable<OFBHistroyXLDataTableList> data = await _oFBHistoryXLDataTableListRepository.OFBHistoryPendingDataTableListSummaryForExcelAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {                    
                });

            if (data == null || data.Count() == 0) { throw new Exception("No Data Found"); }

            OFBApprovalsListXLViewModel oFBApprovalsListXLViewModel = new();            
            foreach (var item in data.Select(s => new { s.Empno, s.EmployeeName, s.Emptype, s.Parent, s.DepartmentName, s.Grade, s.RelievingDate, 
                                                        s.ActionDesc, s.ApprovalDate, s.ApprovalStatus, s.InitiatorRemarks, s.TemplateDesc, s.EmpnoName, 
                                                        s.DeptName, s.TmKeyId, s.TgKeyId
                                                      }))
            {
                oFBApprovalsListXLViewModel.Data.Add(
                   new OFBApprovalList
                   {
                       Empno = item.Empno,
                       EmployeeName = item.EmployeeName,
                       Emptype = item.Emptype,
                       Parent = item.Parent,
                       DepartmentName = item.DepartmentName,
                       Grade = item.Grade,
                       RelievingDate = item.RelievingDate,
                       ActionDesc = item.ActionDesc,
                       ApprovalDate = item.ApprovalDate,
                       ApprovalStatus = item.ApprovalStatus,
                       InitiatorRemarks = item.InitiatorRemarks,
                       TemplateDesc = item.TemplateDesc,
                       EmpnoName = item.EmpnoName,
                       DeptName = item.DeptName,
                       TmKeyId = item.TmKeyId,
                       TgKeyId = item.TgKeyId
                   });
            };
            if (oFBApprovalsListXLViewModel.Data == null || oFBApprovalsListXLViewModel.Data.Count() == 0) { throw new Exception("No Data Found"); }

            
            string stringFileName = "OFB Pending Summary_" + timeStamp;
            using (XLWorkbook wb = XLWorkbook.OpenFromTemplate((StorageHelper.GetTemplateFilePath(StorageHelper.Offboarding.Repository, FileName: excelFileName, Configuration))))
            {
                var sheet1 = wb.Worksheet("OFB Pending Approvals Details");
                sheet1.Table("Summary").ReplaceData(oFBApprovalsListXLViewModel.Data);

                using (MemoryStream stream = new MemoryStream())
                {
                    wb.SaveAs(stream);
                    stream.Position = 0;
                    byte[] byteContent = stream.ToArray();

                    var mimeType = MimeTypeMap.GetMimeType("xlsx");

                    FileContentResult file = File(byteContent, mimeType, stringFileName);

                    return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
                }
            }                                      
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, OffBoardingHelper.ActionViewHistory)]
        public async Task<IActionResult> OFBAllApprovalHistorySummaryXL(string startYear, string endYear)
        {
            string excelFileName = "OFB_Approved.xlsx";
            var timeStamp = DateTime.Now.ToFileTime();

            IEnumerable<OFBHistroyXLDataTableList> data = await _oFBHistoryXLDataTableListRepository.OFBHistoryApprovedDataTableListSummaryForExcelAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PStartYear = startYear,
                    PEndYear = endYear,
                });

            if (data == null || data.Count() == 0) { throw new Exception("No Data Found"); }

            OFBApprovalsListXLViewModel oFBApprovalsListXLViewModel = new();
            foreach (var item in data.Select(s => new {
                s.Empno,
                s.EmployeeName,
                s.Emptype,
                s.Parent,
                s.DepartmentName,
                s.Grade,
                s.RelievingDate,
                s.ActionDesc,
                s.ApprovalDate,
                s.ApprovalStatus,
                s.InitiatorRemarks,
                s.TemplateDesc,
                s.EmpnoName,
                s.DeptName,
                s.TmKeyId,
                s.TgKeyId
            }))
            {
                oFBApprovalsListXLViewModel.Data.Add(
                   new OFBApprovalList
                   {
                       Empno = item.Empno,
                       EmployeeName = item.EmployeeName,
                       Emptype = item.Emptype,
                       Parent = item.Parent,
                       DepartmentName = item.DepartmentName,
                       Grade = item.Grade,
                       RelievingDate = item.RelievingDate,
                       ActionDesc = item.ActionDesc,
                       ApprovalDate = item.ApprovalDate,
                       ApprovalStatus = item.ApprovalStatus,
                       InitiatorRemarks = item.InitiatorRemarks,
                       TemplateDesc = item.TemplateDesc,
                       EmpnoName = item.EmpnoName,
                       DeptName = item.DeptName,
                       TmKeyId = item.TmKeyId,
                       TgKeyId = item.TgKeyId
                   });
            };
            if (oFBApprovalsListXLViewModel.Data == null || oFBApprovalsListXLViewModel.Data.Count() == 0) { throw new Exception("No Data Found"); }


            string stringFileName = "OFB Approved Summary_" + timeStamp;
            using (XLWorkbook wb = XLWorkbook.OpenFromTemplate((StorageHelper.GetTemplateFilePath(StorageHelper.Offboarding.Repository, FileName: excelFileName, Configuration))))
            {
                var sheet1 = wb.Worksheet("OFB Approved Approvals Details");
                sheet1.Table("Summary").ReplaceData(oFBApprovalsListXLViewModel.Data);

                using (MemoryStream stream = new MemoryStream())
                {
                    wb.SaveAs(stream);
                    stream.Position = 0;
                    byte[] byteContent = stream.ToArray();
                    return File(byteContent,
                        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                        stringFileName + ".xlsx");

                    //var mimeType = MimeTypeMap.GetMimeType("xlsx");

                    //FileContentResult file = File(byteContent, mimeType, stringFileName);

                    //return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
                }
            }
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, OffBoardingHelper.ActionViewHistory)]
        public async Task<IActionResult> OFBApprovedApprovalsIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterOFBApproveApprovalsHistoryIndex
            });

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            OFBInitViewModel oFBInitViewModel = new()
            {
                FilterDataModel = filterDataModel
            };
            ViewData["XLDownloadType"] = ConstXLDownloadTypeApprovedApprovalHistory;
            return PartialView("_OFBApprovedApprovalsDetailsPartial", oFBInitViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsOFBApprovedApprovalsHistory(string paramJSon)
        {
            DTResult<OFBInitDataTableList> result = new();

            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJSon);

            int totalRow = 0;

            System.Collections.Generic.IEnumerable<OFBInitDataTableList> data = await _oFBApprovalsHistoryDataTableListRepository.OFBApproveApprovalsHistoryDataTableListAsync(
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

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, OffBoardingHelper.ActionViewHistory)]
        public async Task<IActionResult> OFBHistoryDetails(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            OFBInitDetailsViewModel oFBInitDetailsViewModel = await GetInitDetail(id, null);
            oFBInitDetailsViewModel.ViewName = "HistoryIndex";
            return View("OFBInitDetails", oFBInitDetailsViewModel);
        }

        [HttpGet]
        //[RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, OffBoardingHelper.ActionViewHistory)]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, OffBoardingHelper.ActionViewApprovals)]
        public IActionResult GetAllApprovals(string id, string empname, string parent, string deptname, DateTime relivevingdate)
        {
            OFBApprovalDetailsViewModel oFBApprovalDetailsViewModel = new();
            oFBApprovalDetailsViewModel.Empno = id;
            oFBApprovalDetailsViewModel.EmpName = empname;
            oFBApprovalDetailsViewModel.Parent = parent;
            oFBApprovalDetailsViewModel.ParentName = deptname;
            oFBApprovalDetailsViewModel.RelievingDate = relivevingdate;
            return PartialView("_ModalOFBApprovalDetailsPartial", oFBApprovalDetailsViewModel);
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, OffBoardingHelper.ActionNormalReport)]
        public IActionResult OFBExcelDownload(string typeId)
        {
            if (typeId == null)
            {
                return NotFound();
            }

            FilterDataModel filterDataModel = new();
            filterDataModel.StartYear = DateTime.Now.AddYears(-2);
            filterDataModel.EndYear = DateTime.Now;
            ViewData["XLDownloadType"] = typeId;
            return PartialView("_ModalExportFilterSet", filterDataModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, OffBoardingHelper.ActionNormalReport)]
        public IActionResult OFBExcelDownload(string startYear, string endYear, string typeId)
        {
            if (string.IsNullOrEmpty(typeId))
            {
                throw new Exception("Invalid request..");
            }

            if (Convert.ToInt32(endYear) - Convert.ToInt32(startYear) > 3)
            {
                throw new Exception("Please Select Valid Year.!");
            }

            if (typeId == ConstXLDownloadTypeAllApprovalHistory)
            {
                return RedirectToAction("OFBAllApprovalHistoryXL", new { startYear, endYear });
            }

            if (typeId == ConstXLDownloadTypeApprovals)
            {
                return RedirectToAction("OFBApprovalsXL", new { startYear, endYear });
            }
            if (typeId == ConstXLDownloadTypeConfidentialXLDownload)
            {
                return RedirectToAction("OFBClassifiedApprovalHistoryXL", new { startYear, endYear });
            }
            if (typeId == ConstXLDownloadTypeAllApprovalHistorySummary)
            {
                return RedirectToAction("OFBAllApprovalHistorySummaryXL", new { startYear, endYear });
            }
            FilterDataModel filterDataModel = new()
            {
                StartYear = Convert.ToDateTime(startYear),
                EndYear = Convert.ToDateTime(endYear)
            };

            ViewBag["TypeId"] = typeId;

            return PartialView("_ModalExportFilterSet", filterDataModel);
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, OffBoardingHelper.ActionViewHistory)]
        public async Task<IActionResult> OFBAllApprovalHistoryXL(string startYear, string endYear)
        {
            long timeStamp = DateTime.Now.ToFileTime();
            string fileName = "OFB All Approvals Details_" + timeStamp.ToString();
            string reportTitle = "OFB All Approvals Details from " + startYear + " To " + endYear + " onward " + DateTime.Now.ToString();
            string sheetName = "OFB All Approvals Details";

            string strUser = User.Identity.Name;

            var data = await _oFBHistoryXLDataTableListRepository.OFBHistoryAllDataTableListForExcelAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PStartYear = startYear,
                    PEndYear = endYear,
                });

            if (data == null || data.Count() == 0) { throw new Exception("No Data Found"); }

            var json = JsonConvert.SerializeObject(data);

            IEnumerable<OFBApprovalsHistroyXLViewModel> excelData = JsonConvert.DeserializeObject<IEnumerable<OFBApprovalsHistroyXLViewModel>>(json);

            byte[] byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, reportTitle, sheetName);

            return File(byteContent,
                        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                        fileName + ".xlsx");
        }

        //[RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, OffBoardingHelper.ActionViewApprovals)]
        //public async Task<IActionResult> OFBPendingApprovalHistoryXL(string startYear, string endYear)
        //{
        //    long timeStamp = DateTime.Now.ToFileTime();
        //    string fileName = "OFB Pending Approvals Details_" + timeStamp.ToString();
        //    string reportTitle = "OFB Pending Approvals Details" + startYear + " To " + endYear + " onward " + DateTime.Now.ToString();
        //    string sheetName = "OFB Pending Approvals Details";

        //    string strUser = User.Identity.Name;

        //    IEnumerable<OFBApprovalsHistroyXLDataTableList> data = await _oFBApprovalsXLDataTableListRepository.OFBPendingApprovalsDataTableListForExcelAsync(
        //        BaseSpTcmPLGet(),
        //        new ParameterSpTcmPL
        //        {
        //            PStartYear = startYear,
        //            PEndYear = endYear,
        //        });

        //    if (data == null || data.Count() == 0) { throw new Exception("No Data Found"); }

        //    var json = JsonConvert.SerializeObject(data);

        //    IEnumerable<OFBApprovalsHistroyXLViewModel> excelData = JsonConvert.DeserializeObject<IEnumerable<OFBApprovalsHistroyXLViewModel>>(json);

        //    byte[] byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, reportTitle, sheetName);

        //    return File(byteContent,
        //                "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
        //                fileName + ".xlsx");
        //}

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, OffBoardingHelper.ActionClassifiedReport)]
        public async Task<IActionResult> OFBClassifiedApprovalHistoryXL(string startYear, string endYear)
        {
            long timeStamp = DateTime.Now.ToFileTime();
            string fileName = "OFB All Classified Approvals Details_" + timeStamp.ToString();
            string reportTitle = "OFB All Classified Approvals Details from " + startYear + " To " + endYear + " onward " + DateTime.Now.ToString(); ;
            string sheetName = "OFB All Approvals Details";

            IEnumerable<OFBHistroyXLDataTableList> data = await _oFBHistoryXLDataTableListRepository.OFBHistoryAllContactInfoDataTableListForExcelAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PStartYear = startYear,
                    PEndYear = endYear,
                });

            if (data == null || data.Count() == 0) { throw new Exception("No Data Found"); }

            byte[] byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(data, reportTitle, sheetName);

            return File(byteContent,
                        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                        fileName + ".xlsx");
        }

        #endregion ApprovalsHistory

        private async Task<Domain.Models.FilterRetrieve> RetriveFilter(string ActionName)
        {
            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ActionName
            });
            return retVal;
        }

        #region OFBRollback

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, OffBoardingHelper.ActionApproveRollbackRequest)]
        public async Task<IActionResult> OFBRollbackPendingIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterOFBRollbackPendingIndex
            });

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            OFBRollbackIndexViewModel oFBRollbackViewModel = new()
            {
                FilterDataModel = filterDataModel
            };
            return View(oFBRollbackViewModel);
        }

        public async Task<IActionResult> OFBRollbackHistoryIndex()
        {
            if (!(CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.OffBoarding.OffBoardingHelper.ActionCreateRollbackRequest) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.OffBoarding.OffBoardingHelper.ActionApproveRollbackRequest)))
            {
                return Unauthorized();
            }

            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterOFBRollbackHistoryIndex
            });

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            OFBRollbackIndexViewModel oFBRollbackViewModel = new()
            {
                FilterDataModel = filterDataModel
            };
            return View(oFBRollbackViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsOFBRollbackPending(string paramJSon)
        {
            DTResult<OFBRollbackDataTableList> result = new();

            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJSon);

            int totalRow = 0;

            System.Collections.Generic.IEnumerable<OFBRollbackDataTableList> data = await _oFBRollbackDataTableListRepository.RollbackPendingDataTableListAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PGenericSearch = param.GenericSearch ?? " ",
                    PStatus = 0,
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

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsOFBRollbackHistory(string paramJSon)
        {
            DTResult<OFBRollbackDataTableList> result = new();

            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJSon);

            int totalRow = 0;

            System.Collections.Generic.IEnumerable<OFBRollbackDataTableList> data = await _oFBRollbackDataTableListRepository.RollbackHistoryDataTableListAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PGenericSearch = param.GenericSearch ?? " ",
                    PStatus = 1,
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

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, OffBoardingHelper.ActionApproveRollbackRequest)]
        public async Task<IActionResult> OFBRollbackApprove(string id)
        {
            Domain.Models.Common.DBProcMessageOutput result = await _oFBRollbackRepository.RollbackRequestApproveAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PEmpno = id
                }
                );

            return Json(new { success = result.PMessageType == "OK", response = result.PMessageType, message = result.PMessageText });
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, OffBoardingHelper.ActionCreateRollbackRequest)]
        public async Task<IActionResult> OFBRollbackDelete(string id)
        {
            Domain.Models.Common.DBProcMessageOutput result = await _oFBRollbackRepository.RollbackRequestDeleteAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PEmpno = id
                }
                );

            return Json(new { success = result.PMessageType == "OK", response = result.PMessageType, message = result.PMessageText });
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, OffBoardingHelper.ActionApproveRollbackRequest)]
        public async Task<IActionResult> OFBRollbackExcelDownloadPending()
        {
            //string startYear, string endYear
            //if (Convert.ToInt32(endYear) - Convert.ToInt32(startYear) > 3)
            //{
            //    throw new Exception("Please Select Valid Year.!");
            //}
            var timeStamp = DateTime.Now.ToFileTime();

            string fileName = "Off Boarding Rollback Pending List_" + timeStamp.ToString();
            string reportTitle = "Off Boarding Rollback Pending List";
            string sheetName = "OFB Rollback Pending";

            IEnumerable<OFBRollbackDataTableList> data = await _oFBRollbackDataTableListRepository.RollbackXLPendingDataTableListAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PStatus = 0
                });

            if (data == null) { return NotFound(); }

            var json = JsonConvert.SerializeObject(data);

            IEnumerable<OFBRollbackDataTableListPendingExcel> excelData = JsonConvert.DeserializeObject<IEnumerable<OFBRollbackDataTableListPendingExcel>>(json);

            var byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, reportTitle, sheetName);

            var mimeType = MimeTypeMap.GetMimeType("xlsx");

            FileContentResult file = File(byteContent, mimeType, fileName);

            return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
        }

        public async Task<IActionResult> OFBRollbackExcelDownloadHistory()
        {
            if (!(CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.OffBoarding.OffBoardingHelper.ActionCreateRollbackRequest) ||
                CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.Domain.Models.OffBoarding.OffBoardingHelper.ActionApproveRollbackRequest)))
            {
                return Unauthorized();
            }

            //string startYear, string endYear
            //if (Convert.ToInt32(endYear) - Convert.ToInt32(startYear) > 3)
            //{
            //    throw new Exception("Please Select Valid Year.!");
            //}
            var timeStamp = DateTime.Now.ToFileTime();

            string fileName = "Off Boarding Rollback History List_" + timeStamp.ToString();
            string reportTitle = "Off Boarding Rollback History List";
            string sheetName = "OFB Rollback History";

            IEnumerable<OFBRollbackDataTableList> data = await _oFBRollbackDataTableListRepository.RollbackXLHistoryDataTableListAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PStatus = 1
                });

            if (data == null) { return NotFound(); }

            var json = JsonConvert.SerializeObject(data);

            IEnumerable<OFBRollbackDataTableListHistoryExcel> excelData = JsonConvert.DeserializeObject<IEnumerable<OFBRollbackDataTableListHistoryExcel>>(json);

            var byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, reportTitle, sheetName);

            var mimeType = MimeTypeMap.GetMimeType("xlsx");

            FileContentResult file = File(byteContent, mimeType, fileName);

            return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
        }

        public async Task<IActionResult> SelectEmployeeForRollback()
        {
            OFBSelectEmployeeViewModel oFBSelectEmployeeViewModel = new();

            var ofbEmployeeList = await _selectTcmPLRepository.OFBRollbackEmployeeList(BaseSpTcmPLGet(), null);

            ViewData["EmployeeList"] = new SelectList(ofbEmployeeList, "DataValueField", "DataTextField");

            return PartialView("_ModalSelectEmployeeForRollback", oFBSelectEmployeeViewModel);

        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, OffBoardingHelper.ActionCreateRollbackRequest)]
        public async Task<IActionResult> OFBRollbackCreateIndex(string employee)
        {
            if (string.IsNullOrEmpty(employee))
            {
                Notify("Error", "Invalid or blank Employee..", "toaster", NotificationType.error);
                return RedirectToAction("OFBRollbackPendingIndex");
            }

            var employeeDetails = await _commonEmployeeDetailsRepository.EmployeeDetailAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL { PEmpno = employee });

            OFBInitDetails result = await _oFBInitDetailRepository.OFBRollbackDetail(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PEmpno = employee
                });
            
            if (result.PMessageType != IsOk)
            {
                Notify("Error", result.PMessageType == NotOk ? result.PMessageText : "Rollback for the employee already initiated.", "", NotificationType.error);
                return RedirectToAction("OFBRollbackPendingIndex");
            }
            
            OFBRollbackRequestViewModel oFBRollbackRequestViewModel = new OFBRollbackRequestViewModel();

            if (result.PMessageType == IsOk)
            {
                oFBRollbackRequestViewModel.Empno = employee;
                oFBRollbackRequestViewModel.PersonId = employeeDetails.PEmpPersonId;
                oFBRollbackRequestViewModel.EmployeeName = employee + " -  " + employeeDetails.PName;
                oFBRollbackRequestViewModel.Grade = employeeDetails.PGrade;
                oFBRollbackRequestViewModel.EmpType = employeeDetails.PEmpType;
                oFBRollbackRequestViewModel.Doj = employeeDetails.PDoj;
                oFBRollbackRequestViewModel.DesgCode = employeeDetails.PDesgCode;
                oFBRollbackRequestViewModel.DesgName = employeeDetails.PDesgName;
                oFBRollbackRequestViewModel.Hod = employeeDetails.PHoD;
                oFBRollbackRequestViewModel.HodName = employeeDetails.PHoDName;
                oFBRollbackRequestViewModel.CostName = employeeDetails.PParent + " - " + employeeDetails.PCostName;
                oFBRollbackRequestViewModel.Hod = employeeDetails.PHoD;
                oFBRollbackRequestViewModel.HodName = employeeDetails.PHoDName;
                oFBRollbackRequestViewModel.Address = result.PAddress;
                oFBRollbackRequestViewModel.RelievingDate = result.PRelievingDate;
                oFBRollbackRequestViewModel.EmailId = result.PEmailId;
                oFBRollbackRequestViewModel.EndByDate = result.PEndByDate;
                oFBRollbackRequestViewModel.ResignationDate = result.PResignationDate;
                oFBRollbackRequestViewModel.Remarks = result.PRemarks;
            }
            return View(oFBRollbackRequestViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, OffBoardingHelper.ActionCreateRollbackRequest)]
        public async Task<IActionResult> OFBRollbackCreate(OFBRollbackRequestViewModel oFBRollbackRequestViewModel)
        {
            if (ModelState.IsValid)
            {
                Domain.Models.Common.DBProcMessageOutput result = await _oFBRollbackRepository.RollbackRequestCreateAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PEmpno = oFBRollbackRequestViewModel.Empno,
                        PRemarks = oFBRollbackRequestViewModel.RollbackRemarks,
                    });

                if (result.PMessageType == IsOk)
                {
                    Notify("Success", "Procedure executed successfully", "", NotificationType.success);
                }
                else
                {
                    Notify("Error", result.PMessageText, "", NotificationType.error);
                }
            }
            return View("OFBRollbackPendingIndex");
        }
        
        #endregion OFBRollback

        #region ResetApprovals

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, OffBoardingHelper.ActionResetApprovals)]
        public async Task<IActionResult> OFBResetApprovalsIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterOFBResetApprovalsIndex
            });

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            OFBResetApprovalsViewModel oFBResetApprovalsViewModel = new()
            {
                FilterDataModel = filterDataModel
            };
            return View(oFBResetApprovalsViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsOFBResetApprovals(string paramJSon)
        {
            DTResult<OFBResetApprovalsDataTableList> result = new();

            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJSon);

            int totalRow = 0;

            System.Collections.Generic.IEnumerable<OFBResetApprovalsDataTableList> data = await _oFBResetApprovalsDataTableListRepository.OFBResetApprovalsDataTableListAsync(
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

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, OffBoardingHelper.ActionResetApprovals)]
        public async Task<IActionResult> ResetApproval(string id, string actionid)
        {
            var result = await _oFBResetApprovalsRepository.IOFBResetApprovalAsync(
            BaseSpTcmPLGet(),
            new ParameterSpTcmPL
            {
                PEmpno = id,
                PApprlActionId = actionid
            });

            return Json(new { success = result.PMessageType == "OK", response = result.PMessageText, message = result.PMessageText });
        }

        #endregion ResetApprovals

        #region OFBEmployeeDetails

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, OffBoardingHelper.ActionViewSelfOFB)]
        public async Task<IActionResult> OFBEmployeeInfoIndex()
        {
            var employeeDetails = await _commonEmployeeDetailsRepository.EmployeeDetailAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL { });

            OFBInitDetailsViewModel oFBInitDetailsViewModel = await GetInitDetail(employeeDetails.PForEmpno, null);
            oFBInitDetailsViewModel.ViewName = "HistoryIndex";

            return View("OFBEmployeeInfoIndex", oFBInitDetailsViewModel);
        }

        //[HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, OffBoardingHelper.ActionPrintExitForm)]
        public async Task<IActionResult> OFBPrintForm(string empno)
        {
            try
            {
                if (empno == null)
                {
                    return NotFound();
                }

                var empDetails = await _commonEmployeeDetailsRepository.EmployeeDetailAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL { PEmpno = empno });

                OFBInitDetails empExitDetails = await _oFBInitDetailRepository.OFBInitDetail(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PEmpno = empno
                    });

                //OFBExit empExitDetails = await _oFBEmpExitDetailsRepository.EmpExitDetail(
                //    BaseSpTcmPLGet(),
                //    new ParameterSpTcmPL
                //    {
                //        PEmpno = empno
                //    }
                //    );

                IEnumerable<OffBoardingEmployeeExitApprovals> approvals = await _oFBDeptmntExitApprovalsDataTableListRepository.DeptmntExitApprovalsDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PEmpno = empno
                    });

                //var empDetails = await _employeeDetailsRepository.GetEmployeeDetailsAsync(Empno);
                //var empExitDetails = await _offBoardingExitRepository.GetEmployeeExitDetails(Empno);
                //var approvals = await _offBoardingExitRepository.GetDepartmentExitApprovals(Empno);

                ViewData["EmployeeInfo"] = empDetails;

                ViewData["EmployeeExitDetails"] = empExitDetails;

                return PartialView("_ExitPrintPartial", approvals);
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        #endregion OFBEmployeeDetails

        public async Task<OFBInitDetailsViewModel> GetInitDetail(string id, string actionid)
        {
            OFBInitDetailsViewModel oFBInitDetailsViewModel = new();

            var employeeDetails = await _commonEmployeeDetailsRepository.EmployeeDetailAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL { PEmpno = id });

            OFBInitDetails result = await _oFBInitDetailRepository.OFBInitDetail(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PEmpno = id
                });

            if (result.PMessageType == IsOk)
            {
                oFBInitDetailsViewModel.Empno = id;
                oFBInitDetailsViewModel.EmployeeName = employeeDetails.PName;
                oFBInitDetailsViewModel.PersonId = employeeDetails.PEmpPersonId;
                oFBInitDetailsViewModel.Parent = employeeDetails.PAssign + " - " + employeeDetails.PAssignName;
                oFBInitDetailsViewModel.Grade = employeeDetails.PGrade;
                oFBInitDetailsViewModel.EmpType = employeeDetails.PEmpType;
                oFBInitDetailsViewModel.Hod = employeeDetails.PHoD;
                oFBInitDetailsViewModel.HodName = employeeDetails.PHoDName;
                oFBInitDetailsViewModel.DesgCode = employeeDetails.PDesgCode;
                oFBInitDetailsViewModel.DesgName = employeeDetails.PDesgName;
                oFBInitDetailsViewModel.InitiatorRemarks = result.PRemarks;
                oFBInitDetailsViewModel.MobilePrimary = result.PPrimaryMobile;
                oFBInitDetailsViewModel.AlternateNumber = result.PAlternateMobile;
                oFBInitDetailsViewModel.Address = result.PAddress;
                oFBInitDetailsViewModel.EmailId = result.PEmailId;
                oFBInitDetailsViewModel.RelievingDate = result.PRelievingDate.GetValueOrDefault();
                oFBInitDetailsViewModel.ResignationDate = result.PResignationDate.GetValueOrDefault();
                oFBInitDetailsViewModel.Doj = employeeDetails.PDoj;
                oFBInitDetailsViewModel.EndByDate = result.PEndByDate;
            }
            if (actionid != null)
            {
                OFBApprovalActionDetails data = await _oFBApprovalActionDetailRepository.OFBActionApprovalDetail(
                            BaseSpTcmPLGet(),
                            new ParameterSpTcmPL
                            {
                                PEmpno = id,
                                PApprlActionId = actionid
                            });
                if (data.PMessageType == IsOk)
                {
                    oFBInitDetailsViewModel.Remarks = data.PApprovalRemarks;
                }
                else
                {
                    Notify("Error", result.PMessageText, "", NotificationType.error);
                }
            }

            return oFBInitDetailsViewModel;
        }
    }
}