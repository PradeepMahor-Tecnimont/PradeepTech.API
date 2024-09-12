using ClosedXML.Excel;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore.Query.SqlExpressions;
using MimeTypes;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.Common;
using TCMPLApp.DataAccess.Repositories.EmpGenInfo;
using TCMPLApp.DataAccess.Repositories.SWPVaccine;
using TCMPLApp.Domain.Models.EmpGenInfo;
using TCMPLApp.Domain.Models.SWPVaccine;
using TCMPLApp.WebApp.Classes;
using TCMPLApp.WebApp.Controllers;
using TCMPLApp.WebApp.CustomPolicyProvider;
using TCMPLApp.WebApp.Models;
using static TCMPLApp.WebApp.Classes.DTModel;
using DataField = TCMPLApp.DataAccess.Models.DataField;

namespace TCMPLApp.WebApp.Areas.EmpGenInfo.Controllers
{
    [Authorize]
    [Area("EmpGenInfo")]
    public class GeneralInfoController : BaseController
    {
        //private string Success = "OK";

        private readonly IEmployeeDetailsRepository _employeeDetailsRepository;
        private readonly ISelectTcmPLRepository _selectTcmPLRepository;
        private readonly IVoluntaryParentPolicyDataTableListRepository _vPPDataTableListRepository;
        private readonly IHRVoluntaryParentPolicyDataTableListRepository _hrVPPDataTableListRepository;
        private readonly IVoluntaryParentPolicyRepository _voluntaryParentPolicyRepository;
        private readonly IUtilityRepository _utilityRepository;
        private readonly IVoluntaryParentPolicyDetailRepository _voluntaryParentPolicyDetailRepository;
        private readonly IHRVoluntaryParentPolicyDetailRepository _hrVoluntaryParentPolicyDetailRepository;
        private readonly IHRVoluntaryParentPolicyDetailDataTableListRepository _hrVoluntaryParentPolicyDetailDataTableListRepository;
        private readonly IVoluntaryParentPolicyConfigurationRepository _voluntaryParentPolicyConfigurationRepository;
        private readonly ICommonEmployeeDetailsRepository _commonEmployeeDetailsRepository;

        public GeneralInfoController(IEmployeeDetailsRepository employeeDetailsRepository,
                                    ISelectTcmPLRepository selectTcmPLRepository,
                                    IVoluntaryParentPolicyDataTableListRepository vPPDataTableListRepository,
                                    IHRVoluntaryParentPolicyDataTableListRepository hrVPPDataTableListRepository,
                                    IVoluntaryParentPolicyRepository voluntaryParentPolicyRepository,
                                    IUtilityRepository utilityRepository,
                                    IVoluntaryParentPolicyDetailRepository voluntaryParentPolicyDetailRepository,
                                    IHRVoluntaryParentPolicyDetailRepository hrVoluntaryParentPolicyDetailRepository,
                                    IHRVoluntaryParentPolicyDetailDataTableListRepository hrVoluntaryParentPolicyDetailDataTableListRepository,
                                    IVoluntaryParentPolicyConfigurationRepository voluntaryParentPolicyConfigurationRepository,
                                    ICommonEmployeeDetailsRepository commonEmployeeDetailsRepository
            )
        {
            _employeeDetailsRepository = employeeDetailsRepository;
            _selectTcmPLRepository = selectTcmPLRepository;
            _vPPDataTableListRepository = vPPDataTableListRepository;
            _hrVPPDataTableListRepository = hrVPPDataTableListRepository;
            _voluntaryParentPolicyRepository = voluntaryParentPolicyRepository;
            _utilityRepository = utilityRepository;
            _voluntaryParentPolicyDetailRepository = voluntaryParentPolicyDetailRepository;

            _hrVoluntaryParentPolicyDetailRepository = hrVoluntaryParentPolicyDetailRepository;
            _hrVoluntaryParentPolicyDetailDataTableListRepository = hrVoluntaryParentPolicyDetailDataTableListRepository;
            _voluntaryParentPolicyConfigurationRepository = voluntaryParentPolicyConfigurationRepository;

            _commonEmployeeDetailsRepository = commonEmployeeDetailsRepository;
        }

        #region VoluntaryParentPolicy

        //VoluntaryParentPolicy
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionVPPUpdateInfo)]
        public async Task<IActionResult> VoluntaryParentPolicyIndex()
        {
            //string empno = CurrentUserIdentity.EmpNo;
            //EmployeeDetails employeeDetail = await _employeeDetailsRepository.GetEmployeeDetailsAsync(empno);
            var employeeDetail = await _commonEmployeeDetailsRepository.EmployeeDetailAsync(
                BaseSpTcmPLGet(),
                null);

            if (employeeDetail.PEmpType == "R" || employeeDetail.PEmpType == "F")
            {
                IEnumerable<DataField> sumInsureds = await _selectTcmPLRepository.VppSumInsuredsConfigSelectList(BaseSpTcmPLGet(), null);
                ViewData["SumInsureds"] = new SelectList(sumInsureds, "DataValueField", "DataTextField");

                var result = await _voluntaryParentPolicyDetailRepository.VoluntaryParentPolicyDetail(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                    });

                var resultVppConfig = await _voluntaryParentPolicyConfigurationRepository.VoluntaryParentPolicyConfiguration(
                   BaseSpTcmPLGet(),
                   new ParameterSpTcmPL
                   {
                   });

                VoluntaryParentPolicyViewModel voluntaryParentPolicyViewModel = new();
                voluntaryParentPolicyViewModel.VoluntaryParentPolicyDetail = result;
                if (result.PIsLock == null)
                {
                    voluntaryParentPolicyViewModel.VoluntaryParentPolicyDetail.PIsLock = 0;
                }

                if (resultVppConfig.PMessageType == IsOk)
                {
                    voluntaryParentPolicyViewModel.ConfigId = resultVppConfig.PConfigId;
                    voluntaryParentPolicyViewModel.IsEnableMod = resultVppConfig.PIsEnableMod;
                    voluntaryParentPolicyViewModel.IsDisplayPremium = resultVppConfig.PIsDisplayPremium;
                }

                return View(voluntaryParentPolicyViewModel);
            }
            else
                return NotFound();
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionVPPUpdateInfo)]
        public async Task<JsonResult> GetVoluntaryParentPolicyList(DTParameters param)
        {
            int totalRow = 0;

            DTResult<VoluntaryParentPolicyDataTableList> result = new();

            try
            {
                IEnumerable<VoluntaryParentPolicyDataTableList> data = await _vPPDataTableListRepository.VoluntaryParentPolicyDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                    }
                );

                if (data.Any())
                {
                    totalRow = data.Count();
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
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionVPPUpdateInfo)]
        public async Task<IActionResult> VoluntaryParentPolicyCreate()
        {
            if (!CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.WebApp.Classes.ActionFeatureHelper.ActionFeatureVpp))
            {
                return NotFound();
            }

            var resultVppConfig = await _voluntaryParentPolicyConfigurationRepository.VoluntaryParentPolicyConfiguration(
                                   BaseSpTcmPLGet(),
                                   new ParameterSpTcmPL
                                   {
                                   });

            if (resultVppConfig.PMessageType == IsOk)
            {
                if (string.IsNullOrEmpty(resultVppConfig.PConfigId))
                {
                    return NotFound("Error : Config id not found..!");
                }
                if (resultVppConfig.PIsEnableMod == 0)
                {
                    return NotFound("Error :- Modification window is closed, Modification not allowed");
                }
                if (resultVppConfig.PIsDisplayPremium == 0)
                {
                    return NotFound("No need to display premium amount");
                }
            }

            VoluntaryParentPolicyCreateViewModel voluntaryParentPolicyCreateViewModel = new();

            IEnumerable<DataField> vppRelations = await _selectTcmPLRepository.VppRelationList(BaseSpTcmPLGet(), null);
            ViewData["VppRelations"] = new SelectList(vppRelations, "DataValueField", "DataTextField");

            IEnumerable<DataField> sumInsureds = await _selectTcmPLRepository.VppSumInsuredsConfigSelectList(BaseSpTcmPLGet(), null);
            ViewData["SumInsureds"] = new SelectList(sumInsureds, "DataValueField", "DataTextField");

            var result = await _voluntaryParentPolicyDetailRepository.VoluntaryParentPolicyDetail(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                });

            if (result.PInsuredSumWords != null)
            {
                ViewData["InsuredSumWords"] = result.PInsuredSumWords;
                voluntaryParentPolicyCreateViewModel.InsuredSumId = result.PInsuredSumId;
                ViewData["ShowInsuredSumDropdownlist"] = "hidden";
                ViewData["ShowInsuredSumLabel"] = "";
            }
            else
            {
                ViewData["ShowInsuredSumDropdownlist"] = "";
                ViewData["ShowInsuredSumLabel"] = "hidden";
            }

            voluntaryParentPolicyCreateViewModel.Empno = CurrentUserIdentity.EmpNo;
            voluntaryParentPolicyCreateViewModel.Name = CurrentUserIdentity.Name;

            return PartialView("_ModalCreateVoluntaryParentPolicyPartial", voluntaryParentPolicyCreateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionVPPUpdateInfo)]
        public async Task<IActionResult> VoluntaryParentPolicyCreate([FromForm] VoluntaryParentPolicyCreateViewModel voluntaryParentPolicyCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var resultVppConfig = await _voluntaryParentPolicyConfigurationRepository.VoluntaryParentPolicyConfiguration(
                                  BaseSpTcmPLGet(),
                                  new ParameterSpTcmPL
                                  {
                                  });

                    if (resultVppConfig.PMessageType == IsOk)
                    {
                        if (string.IsNullOrEmpty(resultVppConfig.PConfigId))
                        {
                            return NotFound("Error : Config id not found..!");
                        }
                        if (resultVppConfig.PIsEnableMod == 0)
                        {
                            return NotFound("Error :- Modification window is closed, Modification not allowed");
                        }
                        if (resultVppConfig.PIsDisplayPremium == 0)
                        {
                            return NotFound("No need to display premium amount");
                        }
                    }

                    var result = await _voluntaryParentPolicyRepository.VoluntaryParentPolicyCreateAsync(
                    BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PEmpno = voluntaryParentPolicyCreateViewModel.Empno,
                            PName = voluntaryParentPolicyCreateViewModel.Name,
                            PRelationId = voluntaryParentPolicyCreateViewModel.Relation,
                            PDob = voluntaryParentPolicyCreateViewModel.Dob,
                            PGender = voluntaryParentPolicyCreateViewModel.Gender,
                            PInsuredSumId = voluntaryParentPolicyCreateViewModel.InsuredSumId,
                        });

                    //if (result.PMessageType != Success)
                    //{
                    //    throw new Exception(result.PMessageText.Replace("-", " "));
                    //}
                    //else
                    //{
                    //    return Json(new { success = result.PMessageType == Success, response = result.PMessageText });
                    //}
                    return RedirectToAction("VoluntaryParentPolicyCreate");
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            IEnumerable<DataField> vppRelations = await _selectTcmPLRepository.VppRelationList(BaseSpTcmPLGet(), null);
            ViewData["VppRelations"] = new SelectList(vppRelations, "DataValueField", "DataTextField");

            IEnumerable<DataField> sumInsureds = await _selectTcmPLRepository.VppSumInsuredsConfigSelectList(BaseSpTcmPLGet(), null);
            ViewData["SumInsureds"] = new SelectList(sumInsureds, "DataValueField", "DataTextField");

            var resultDetail = await _voluntaryParentPolicyDetailRepository.VoluntaryParentPolicyDetail(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                        });

            if (resultDetail.PInsuredSumWords != null)
            {
                ViewData["InsuredSumWords"] = resultDetail.PInsuredSumWords;
                voluntaryParentPolicyCreateViewModel.InsuredSumId = resultDetail.PInsuredSumId;
                ViewData["ShowInsuredSumDropdownlist"] = "hidden";
                ViewData["ShowInsuredSumLabel"] = "";
            }
            else
            {
                ViewData["ShowInsuredSumDropdownlist"] = "";
                ViewData["ShowInsuredSumLabel"] = "hidden";
            }

            voluntaryParentPolicyCreateViewModel.Empno = CurrentUserIdentity.EmpNo;
            voluntaryParentPolicyCreateViewModel.Name = CurrentUserIdentity.Name;

            return PartialView("_ModalCreateVoluntaryParentPolicyPartial", voluntaryParentPolicyCreateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionVPPUpdateInfo)]
        public async Task<IActionResult> VoluntaryParentPolicyUpdate(string keyId, string insuredSumId)
        {
            if (!CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.WebApp.Classes.ActionFeatureHelper.ActionFeatureVpp))
            {
                return NotFound();
            }
            try
            {
                var result = await _voluntaryParentPolicyRepository.VoluntaryParentPolicyUpdateAsync(
                BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PKeyId = keyId,
                        PInsuredSumId = insuredSumId
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
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionVPPUpdateInfo)]
        public async Task<IActionResult> VoluntaryParentPolicyDelete(string id)
        {
            if (!CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.WebApp.Classes.ActionFeatureHelper.ActionFeatureVpp))
            {
                return NotFound();
            }
            try
            {
                if (id == null)
                {
                    return NotFound();
                }

                var result = await _voluntaryParentPolicyRepository.VoluntaryParentPolicyDeleteAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PKeyId = id.Split("!-!")[0],
                        PKeyIdDetail = id.Split("!-!")[1]
                    }
                    );

                return result.PMessageType != IsOk
                       ? (IActionResult)Json(new { success = false, response = result.PMessageText, message = result.PMessageText })
                       : (IActionResult)Json(new { success = true, response = result.PMessageText, message = result.PMessageText });
            }
            catch (Exception ex)
            {
                throw new CustomJsonException(ex.Message);
            }
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionVPPUpdateInfo)]
        public async Task<IActionResult> VoluntaryParentPolicyLock(string id)
        {
            if (!CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.WebApp.Classes.ActionFeatureHelper.ActionFeatureVpp))
            {
                return NotFound();
            }
            try
            {
                if (id == null)
                {
                    return NotFound();
                }

                var result = await _voluntaryParentPolicyRepository.VoluntaryParentPolicyLockAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PKeyId = id
                    }
                    );

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        #endregion VoluntaryParentPolicy

        #region HRVoluntary

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionVPPManagement)]
        public IActionResult VoluntaryParentPolicyForHRIndex()
        {
            HRVoluntaryParentPolicyViewModel hrVoluntaryParentPolicyViewModel = new();
            return View(hrVoluntaryParentPolicyViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionVPPManagement)]
        public async Task<JsonResult> GetVoluntaryParentPolicyForHRList(DTParameters param)
        {
            int totalRow = 0;

            DTResult<HRVoluntaryParentPolicyDataTableList> result = new();

            try
            {
                IEnumerable<HRVoluntaryParentPolicyDataTableList> data = await _hrVPPDataTableListRepository.HRVoluntaryParentPolicyDataTableList(
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
                return Json(new
                {
                    error = ex.Message
                });
            }
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionVPPManagement)]
        public async Task<IActionResult> ExcelDownloadHRVPP()
        {
            try
            {
                string StrFileName;

                long timeStamp = DateTime.Now.ToFileTime();
                StrFileName = "VoluntaryParentsPolicy_" + timeStamp.ToString();

                string strUser = User.Identity.Name;

                IEnumerable<HRVoluntaryParentPolicyDataTableList> data = await _hrVPPDataTableListRepository.ExcelHRVoluntaryParentPolicyDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                    });

                IEnumerable<HRVoluntaryParentPolicyDataTableList> dataNotLocked = await _hrVPPDataTableListRepository.ExcelNotLockedHRVoluntaryParentPolicyDataTableList(
                   BaseSpTcmPLGet(),
                   new ParameterSpTcmPL
                   {
                   });

                IEnumerable<HRVoluntaryParentPolicyDataTableList> dataNotFiled = await _hrVPPDataTableListRepository.ExcelNotFiledHRVoluntaryParentPolicyDataTableList(
                  BaseSpTcmPLGet(),
                  new ParameterSpTcmPL
                  {
                  });

                if (data == null) { return NotFound(); }

                var jsonVoluntaryParentsPolicy = JsonConvert.SerializeObject(data);
                VoluntaryParentsPolicy voluntaryParentsPolicy = new();
                IEnumerable<VoluntaryParentsPolicy> excelVoluntaryParentsPolicyData = JsonConvert.DeserializeObject<IEnumerable<VoluntaryParentsPolicy>>(jsonVoluntaryParentsPolicy);

                var jsonNotLockedVoluntaryParentsPolicy = JsonConvert.SerializeObject(dataNotLocked);
                VoluntaryParentsPolicy NotLockedvoluntaryParentsPolicy = new();
                IEnumerable<VoluntaryParentsPolicy> excelNotLockedVoluntaryParentsPolicyData = JsonConvert.DeserializeObject<IEnumerable<VoluntaryParentsPolicy>>(jsonNotLockedVoluntaryParentsPolicy);

                var jsonNotFiledVoluntaryParentsPolicy = JsonConvert.SerializeObject(dataNotFiled);
                VoluntaryParentsPolicy NotFiledvoluntaryParentsPolicy = new();
                IEnumerable<VoluntaryParentsPolicy> excelNotFiledVoluntaryParentsPolicyData = JsonConvert.DeserializeObject<IEnumerable<VoluntaryParentsPolicy>>(jsonNotFiledVoluntaryParentsPolicy);

                foreach (var item in data.OrderBy(a => a.Empno).Select(s => new { s.Empno, s.Employee, s.EmpDob, s.Parent, s.Grade, s.Designation, s.Email, s.ModifiedOn, s.ParentsCount, s.InsuredSumWords, s.PremiumAmt, s.GstAmt, s.TotalPremium, s.MyParentsCount, s.MyParentsPremiumAmt, s.MyParentsGstAmt, s.MyParentsTotalPremium, s.InlawsCount, s.InlawsPremiumAmt, s.InlawsGstAmt, s.InlawsTotalPremium }).GroupBy(t => new { t.Empno, t.Employee, t.EmpDob, t.Parent, t.Grade, t.Designation, t.Email, t.ModifiedOn, t.ParentsCount, t.InsuredSumWords, t.PremiumAmt, t.GstAmt, t.TotalPremium, t.MyParentsCount, t.MyParentsPremiumAmt, t.MyParentsGstAmt, t.MyParentsTotalPremium, t.InlawsCount, t.InlawsPremiumAmt, t.InlawsGstAmt, t.InlawsTotalPremium }))
                {
                    voluntaryParentsPolicy.PremiumDetail.Add(
                       new PremiumDetails
                       {
                           Empno = item.Key.Empno,
                           Employee = item.Key.Employee,
                           EmpDob = item.Key.EmpDob,
                           Parent = item.Key.Parent,
                           Grade = item.Key.Grade,
                           Designation = item.Key.Designation,
                           Email = item.Key.Email,
                           ModifiedOn = item.Key.ModifiedOn,
                           InsuredSumWords = item.Key.InsuredSumWords,
                           ParentsCount = item.Key.MyParentsCount,
                           ParentsPremiumAmt = item.Key.MyParentsPremiumAmt,
                           ParentsGstAmt = item.Key.MyParentsGstAmt,
                           ParentsPremium = item.Key.MyParentsTotalPremium,
                           InlawsCount = item.Key.InlawsCount,
                           InlawsPremiumAmt = item.Key.InlawsPremiumAmt,
                           InlawsGstAmt = item.Key.InlawsGstAmt,
                           InlawsPremium = item.Key.InlawsTotalPremium,
                           TotalCount = item.Key.ParentsCount,
                           TotalPremiumAmt = item.Key.PremiumAmt,
                           TotalGstAmt = item.Key.GstAmt,
                           TotalPremium = item.Key.TotalPremium
                       });
                };
                var excelPremiumDetailsData = voluntaryParentsPolicy.PremiumDetail.DistinctBy(x => x.Empno).OrderBy(i => i.Empno);

                byte[] xls_Bytes = null;
                using (XLWorkbook wb = new XLWorkbook())
                {
                    ExcelFromIEnumerable(wb, excelVoluntaryParentsPolicyData, "Voluntary Parents Policy", "VoluntaryParentsPolicy");
                    ExcelFromIEnumerable(wb, excelPremiumDetailsData, "Premium Details", "PremiumDetails");
                    ExcelFromIEnumerable(wb, excelNotLockedVoluntaryParentsPolicyData, "Not Locked Voluntary Parents Policy", "NotLockedVoluntaryParentsPolicy");
                    ExcelFromIEnumerable(wb, excelNotFiledVoluntaryParentsPolicyData, "Not Filed Voluntary Parents Policy", "NotFiledVoluntaryParentsPolicy");
                    wb.Worksheet("VoluntaryParentsPolicy").Column(14).Delete();
                    wb.Worksheet("NotLockedVoluntaryParentsPolicy").Column(13).Delete();
                    wb.Worksheet("NotFiledVoluntaryParentsPolicy").Column(13).Delete();
                    wb.CalculateMode = XLCalculateMode.Auto;

                    using (MemoryStream ms = new MemoryStream())
                    {
                        wb.SaveAs(ms);
                        byte[] buffer = ms.GetBuffer();
                        long length = ms.Length;
                        xls_Bytes = ms.ToArray();
                    }

                    wb.Dispose();
                }

                var mimeType = MimeTypeMap.GetMimeType("xlsx");

                FileContentResult file = File(xls_Bytes, mimeType, StrFileName);

                return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionVPPManagement)]
        public async Task<IActionResult> VoluntaryParentsPolicyDetailForHRIndex(string id)
        {
            try
            {
                if (string.IsNullOrEmpty(id))
                {
                    return NotFound();
                }

                var result = await _hrVoluntaryParentPolicyDetailRepository.HRVoluntaryParentPolicyDetail(
                 BaseSpTcmPLGet(),
                 new ParameterSpTcmPL
                 {
                     PEmpno = id,
                 });

                HRVoluntaryParentPolicyDetailViewModel hrVoluntaryParentPolicyDetailViewModel = new();
                hrVoluntaryParentPolicyDetailViewModel.hrVoluntaryParentPolicyDetail = result;

                return PartialView("_ModalVoluntaryParentsPolicyDetailForHRIndex", hrVoluntaryParentPolicyDetailViewModel);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionVPPManagement)]
        public async Task<JsonResult> GetListVoluntaryParentsPolicyDetail(DTParameters param)
        {
            int totalRow = 0;

            DTResult<HRVoluntaryParentPolicyDetailDataTableList> result = new();

            try
            {
                IEnumerable<HRVoluntaryParentPolicyDetailDataTableList> data = await _hrVoluntaryParentPolicyDetailDataTableListRepository.HRVoluntaryParentPolicyDetailDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PKeyId = param.ApplicationId
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

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionVPPManagement)]
        public async Task<IActionResult> VoluntaryParentPolicyUnLock(string id)
        {
            try
            {
                if (id == null)
                {
                    return NotFound();
                }

                var result = await _voluntaryParentPolicyRepository.VoluntaryParentPolicyUnLockForHRAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PKeyId = id
                    }
                    );

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        public void ExcelFromIEnumerable<T>(XLWorkbook wb, IEnumerable<T> dt, string ReportTitle, string Sheetname)
        {
            var columns = (dt.GetType().GetGenericArguments()[0]).GetProperties();

            Int32 cols = columns.Count();
            Int32 rows = dt.ToList().Count;

            IXLWorksheet ws = wb.Worksheets.Add(Sheetname);
            if (cols < 20)
            {
                ws.Range(1, 1, 1, cols).Value = ReportTitle;
                ws.Range(1, 1, 1, cols).Style.Font.FontSize = 16;
                ws.Range(1, 1, 1, cols).Style.Font.Bold = true;
                ws.Range(1, 1, 1, cols).Merge();
                ws.Range(1, 1, 1, cols).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
            }
            else
            {
                ws.Range(1, 1, 1, 1).Value = ReportTitle;
                ws.Range(1, 1, 1, 1).Style.Font.FontSize = 16;
                ws.Range(1, 1, 1, 1).Style.Font.Bold = true;
            }
            ws.Cell(3, 1).InsertTable(dt);

            var rngTable = ws.Range("A3:" + Convert.ToChar(65 + (cols - 1)) + (rows + 3));
            rngTable.Style.Border.TopBorder = XLBorderStyleValues.Thin;
            rngTable.Style.Border.TopBorderColor = XLColor.LightGray;
            rngTable.Style.Border.BottomBorder = XLBorderStyleValues.Thin;
            rngTable.Style.Border.BottomBorderColor = XLColor.LightGray;
            rngTable.Style.Border.LeftBorder = XLBorderStyleValues.Thin;
            rngTable.Style.Border.LeftBorderColor = XLColor.LightGray;
            rngTable.Style.Border.RightBorder = XLBorderStyleValues.Thin;
            rngTable.Style.Border.RightBorderColor = XLColor.LightGray;

            ws.Tables.FirstOrDefault().SetShowAutoFilter(false);
            ws.Columns().AdjustToContents();
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionVPPUpdateInfo)]
        public async Task<IActionResult> HrVoluntaryParentPolicyDelete(string id)
        {
            if (!CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == TCMPLApp.WebApp.Classes.ActionFeatureHelper.ActionFeatureVpp))
            {
                return NotFound();
            }
            try
            {
                if (id == null)
                {
                    return NotFound();
                }

                var result = await _voluntaryParentPolicyRepository.VoluntaryParentPolicyDeleteHrAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PKeyId = id.Split("!-!")[0],
                        PKeyIdDetail = id.Split("!-!")[1]
                    }
                    );

                return result.PMessageType != IsOk
                       ? (IActionResult)Json(new { success = false, response = result.PMessageText, message = result.PMessageText })
                       : (IActionResult)Json(new { success = true, response = result.PMessageText, message = result.PMessageText });
            }
            catch (Exception ex)
            {
                throw new CustomJsonException(ex.Message);
            }
        }

        #endregion HRVoluntary
    }
}