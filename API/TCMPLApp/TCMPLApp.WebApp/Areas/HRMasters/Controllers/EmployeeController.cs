using ClosedXML.Excel;
using DocumentFormat.OpenXml.Drawing.Charts;
using DocumentFormat.OpenXml.EMMA;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.CodeAnalysis.RulesetToEditorconfig;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using MimeTypes;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.Common;
using TCMPLApp.DataAccess.Repositories.HRMasters;
using TCMPLApp.Domain.Models;

//using TCMPLApp.WebApp.Lib.Models;
using TCMPLApp.Domain.Models.Common;
using TCMPLApp.Domain.Models.DMS;
using TCMPLApp.Domain.Models.HRMasters;
using TCMPLApp.Library.Excel.Template;
using TCMPLApp.Library.Excel.Template.Models;
using TCMPLApp.WebApp.Areas.HRMasters.Models;
using TCMPLApp.WebApp.Classes;
using TCMPLApp.WebApp.Controllers;
using TCMPLApp.WebApp.CustomPolicyProvider;
using TCMPLApp.WebApp.Models;
using static TCMPLApp.WebApp.Classes.DTModel;

namespace TCMPLApp.WebApp.Areas.HRMasters.Controllers
{
    [Area("HRMasters")]
    public class EmployeeController : BaseController
    {
        private const string ConstFilterEmployeeMasterIndex = "Index";

        private readonly IConfiguration _configuration;
        private readonly IHRMastersRepository _hrmastersRepository;
        private readonly IEmployeeMasterRepository _employeeMasterRepository;
        private readonly IEmployeeMasterViewRepository _employeeMasterViewRepository;
        private readonly ISelectRepository _selectRepository;
        private readonly DataAccess.Repositories.SWPVaccine.IUtilityRepository _utilityRepository;
        private readonly IExcelTemplate _excelTemplate;
        private readonly IEmployeeImportRepository _employeeImportRepository;
        private readonly IFilterRepository _filterRepository;
        private readonly IEmployeeMasterDataTableListViewRepository _employeeMasterDataTableListViewRepository;
        private readonly IEmployeeMasterDataTableListExcelViewRepository _employeeMasterDataTableListExcelViewRepository;        

        public EmployeeController(IHRMastersRepository hrmastersRepository,
                                  IEmployeeMasterRepository employeeMasterRepository,
                                  IEmployeeMasterViewRepository employeeMasterViewRepository,
                                  ISelectRepository selectRepository,
                                  IConfiguration configuration,
                                  IExcelTemplate excelTemplate,
                                  DataAccess.Repositories.SWPVaccine.IUtilityRepository utilityRepository,
                                  IEmployeeImportRepository employeeImportRepository,
                                  IFilterRepository filterRepository,
                                  IEmployeeMasterDataTableListViewRepository employeeMasterDataTableListViewRepository,
                                  IEmployeeMasterDataTableListExcelViewRepository employeeMasterDataTableListExcelViewRepository)
        {
            _configuration = configuration;
            _hrmastersRepository = hrmastersRepository;
            _employeeMasterRepository = employeeMasterRepository;
            _employeeMasterViewRepository = employeeMasterViewRepository;
            _selectRepository = selectRepository;
            _excelTemplate = excelTemplate;
            _utilityRepository = utilityRepository;
            _employeeImportRepository = employeeImportRepository;
            _filterRepository = filterRepository;
            _employeeMasterDataTableListViewRepository = employeeMasterDataTableListViewRepository;
            _employeeMasterDataTableListExcelViewRepository = employeeMasterDataTableListExcelViewRepository;            
        }

        public async Task PopulateSelect()
        {
            var costcenterList = await _selectRepository.CostcenterSelectListCacheAsync();
            ViewData["CostcenterList"] = new SelectList(costcenterList, "DataValueField", "DataTextField");

            var designationList = await _selectRepository.DesignationSelectListCacheAsync();
            ViewData["DesgList"] = new SelectList(designationList, "DataValueField", "DataTextField");

            var gradeList = await _selectRepository.GradeSelectListCacheAsync();
            ViewData["GradeList"] = new SelectList(gradeList, "DataValueField", "DataTextField");

            var officeList = await _selectRepository.OfficeSelectListCacheAsync();
            ViewData["OfficeList"] = new SelectList(officeList, "DataValueField", "DataTextField");

            var emptypeList = await _selectRepository.EmptypeSelectListCacheAsync();
            ViewData["EmptypeList"] = new SelectList(emptypeList, "DataValueField", "DataTextField");

            var categoryList = await _selectRepository.CategorySelectListCacheAsync();
            ViewData["CategoryList"] = new SelectList(categoryList, "DataValueField", "DataTextField");

            var genderList = await _selectRepository.GenderSelectListCacheAsync();
            ViewData["GenderList"] = new SelectList(genderList, "DataValueField", "DataTextField");

            var companyList = await _selectRepository.CompanySelectListCacheAsync();
            ViewData["CompanyList"] = new SelectList(companyList, "DataValueField", "DataTextField");

            var toggleList = new List<SelectListItem> { new SelectListItem { Text = "Yes", Value = "Y"},
                                                        new SelectListItem { Text = "No", Value = "N"}
                                                      };
            ViewData["MarriedList"] = new SelectList(toggleList, "Value", "Text");
        }

        #region >>>>>>>>>>> Employee Main <<<<<<<<<<<<<<

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, HRMastersHelper.ActionViewHRMasters)]
        public async Task<IActionResult> Index()
        {
            //UserIdentity currentUserIdentity = CurrentUserIdentity;
            //var result = (await _employeeMasterViewRepository.GetEmployeeMasterListAsync(currentUserIdentity.EmpNo)).ToList().AsQueryable();
            //TCMPLApp.WebApp.Areas.HRMasters.Models.EmployeeMasterMainViewModel employeeMasterMainViewModel = new EmployeeMasterMainViewModel();
            //employeeMasterMainViewModel.FilterDataModel.Status = 1;
            //return View(employeeMasterMainViewModel);

            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterEmployeeMasterIndex
            });

            TCMPLApp.WebApp.Areas.HRMasters.Models.EmployeeMasterMainViewModel employeeMasterMainViewModel = new EmployeeMasterMainViewModel();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                employeeMasterMainViewModel.FilterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            
            
            return View(employeeMasterMainViewModel);
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, HRMastersHelper.ActionViewHRMasters)]
        public async Task<IActionResult> Detail(string id)
        {
            if (id == null)
                return NotFound();

            UserIdentity currentUserIdentity = CurrentUserIdentity;
            var employeeDetail = await _employeeMasterViewRepository.EmployeeMainDetail(id, currentUserIdentity.EmpNo);

            if (employeeDetail == null)
            {
                return NotFound();
            }

            return View(employeeDetail);
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, HRMastersHelper.ActionViewHRMasters)]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetLists(string paramJson)
        {
            //DTResult<EmployeeMasterMain> result = new DTResult<EmployeeMasterMain>();
                        
            //UserIdentity currentUserIdentity = CurrentUserIdentity;
            //var data = (await _employeeMasterViewRepository.GetEmployeeMasterListAsync(currentUserIdentity.EmpNo)).ToList().AsQueryable();

            //// Filtering
            //if (!string.IsNullOrEmpty(param.GenericSearch))
            //{
            //    data = data
            //            .Where(
            //            t => t.Status == param.Status & (t.Name.Trim().ToLower().Contains(param.GenericSearch.Trim().ToLower(), StringComparison.InvariantCultureIgnoreCase)
            //                | t.Empno.Trim().ToLower().Contains(param.GenericSearch.Trim().ToLower(), StringComparison.InvariantCultureIgnoreCase)
            //                | t.Parent.Trim().ToLower().Contains(param.GenericSearch.Trim().ToLower(), StringComparison.InvariantCultureIgnoreCase)
            //                )
            //             );
            //}
            //else
            //{
            //    data = data
            //            .Where(
            //            t => t.Status == param.Status
            //             );
            //}

            //result.draw = param.Draw;
            //result.recordsTotal = data.Count();
            //result.recordsFiltered = data.Count();
            //result.data = data.Skip(param.Start).Take(param.Length).AsNoTracking().ToList();

            //return Json(result);

            DTResult<EmployeeMasterMainDataTableList> result = new();

            var param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            int totalRow = 0;

            try
            {
                System.Collections.Generic.IEnumerable<EmployeeMasterMainDataTableList> data = await _employeeMasterDataTableListViewRepository.GetEmployeeMasterListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch,
                        PStatus = param.Status,
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

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, HRMastersHelper.ActionEditEmplmast)]
        public async Task<IActionResult> EmployeeCreate()
        {
            await PopulateSelect();

            EmployeeCreateViewMainModel employeeCreateViewMainModel = new EmployeeCreateViewMainModel();

            return PartialView("_ModalEmployeeCreatePartial", employeeCreateViewMainModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, HRMastersHelper.ActionEditEmplmast)]
        public async Task<IActionResult> EmployeeCreate([FromForm] EmployeeCreateViewMainModel employeeCreateViewMainModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    EmployeeMasterMainAdd employeeMasterMainAdd = new EmployeeMasterMainAdd
                    {
                        PEmpno = employeeCreateViewMainModel.Empno,
                        PAbbr = employeeCreateViewMainModel.Abbr,
                        PEmptype = employeeCreateViewMainModel.Emptype,
                        PEmail = employeeCreateViewMainModel.Email,
                        PParent = employeeCreateViewMainModel.Parent,
                        PDesgcode = employeeCreateViewMainModel.Desgcode,
                        PDob = (DateTime?)employeeCreateViewMainModel.DoB,
                        PDoj = (DateTime?)employeeCreateViewMainModel.DoJ,
                        POffice = employeeCreateViewMainModel.Office,
                        PSex = employeeCreateViewMainModel.Sex,
                        PCategory = employeeCreateViewMainModel.Category,
                        PMarried = employeeCreateViewMainModel.Married,
                        PMetaid = employeeCreateViewMainModel.Metaid,
                        PPersonid = employeeCreateViewMainModel.Personid,
                        PGrade = employeeCreateViewMainModel.Grade,
                        PCompany = employeeCreateViewMainModel.Company,
                        PFirstname = employeeCreateViewMainModel.Firstname,
                        PMiddlename = employeeCreateViewMainModel.Middlename,
                        PLastname = employeeCreateViewMainModel.Lastname
                    };

                    var retVal = await _employeeMasterRepository.AddEmployee(employeeMasterMainAdd);

                    if (retVal.OutPSuccess == "OK")
                    {
                        return Json(new { success = "OK", response = retVal.OutPMessage });
                    }
                    else
                    {
                        throw new Exception(retVal.OutPMessage.Replace("-", " "));
                    }

                    //if (retVal.OutPSuccess == "OK")
                    //{
                    //    Notify("Success", retVal.OutPMessage, "toaster", NotificationType.success);
                    //}
                    //else
                    //{
                    //    Notify("Error", retVal.OutPMessage, "toaster", NotificationType.error);
                    //}
                }
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
            }

            return RedirectToAction("Index", "Employee");
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, HRMastersHelper.ActionEditEmplmast)]
        public async Task<IActionResult> EmployeeMainEdit(string id)
        {
            if (id == null)
                return NotFound();

            var model = new EmployeeMasterEditViewMainModel();

            UserIdentity currentUserIdentity = CurrentUserIdentity;
            var employeeDetail = await _employeeMasterViewRepository.EmployeeMainDetail(id, currentUserIdentity.EmpNo);

            if (employeeDetail == null)
            {
                return NotFound();
            }

            model.Abbr = employeeDetail.Abbr;
            model.Assign = employeeDetail.Assign;
            model.Category = employeeDetail.Category;
            model.Company = employeeDetail.Company;
            model.Desgcode = employeeDetail.Desgcode;
            model.DoB = employeeDetail.DoB;
            model.DoC = employeeDetail.DoC;
            model.DoJ = employeeDetail.DoJ;
            model.Email = employeeDetail.Email;
            model.Empno = employeeDetail.Empno;
            model.Name = employeeDetail.Name;
            model.Emptype = employeeDetail.Emptype;
            model.Grade = employeeDetail.Grade;
            model.Married = employeeDetail.Married;
            model.Metaid = employeeDetail.Metaid;
            model.Office = employeeDetail.Office;
            model.Parent = employeeDetail.Parent;
            model.Personid = employeeDetail.Personid;
            model.Sex = employeeDetail.Sex;
            model.Firstname = employeeDetail.Firstname;
            model.Middlename = employeeDetail.Middlename;
            model.Lastname = employeeDetail.Lastname;

            var parentList = await _selectRepository.CostcenterSelectListCacheAsync();
            ViewData["ParentList"] = new SelectList(parentList, "DataValueField", "DataTextField", employeeDetail.Parent);

            var assingList = await _selectRepository.CostcenterSelectListCacheAsync();
            ViewData["AssignList"] = new SelectList(parentList, "DataValueField", "DataTextField", employeeDetail.Assign);

            var designationList = await _selectRepository.DesignationSelectListCacheAsync();
            ViewData["DesgList"] = new SelectList(designationList, "DataValueField", "DataTextField", employeeDetail.Desgcode);

            var gradeList = await _selectRepository.GradeSelectListCacheAsync();
            ViewData["GradeList"] = new SelectList(gradeList, "DataValueField", "DataTextField", employeeDetail.Grade);

            var officeList = await _selectRepository.OfficeSelectListCacheAsync();
            ViewData["OfficeList"] = new SelectList(officeList, "DataValueField", "DataTextField", employeeDetail.Office);

            var emptypeList = await _selectRepository.EmptypeSelectListCacheAsync();
            ViewData["EmptypeList"] = new SelectList(emptypeList, "DataValueField", "DataTextField", employeeDetail.Emptype);

            var categoryList = await _selectRepository.CategorySelectListCacheAsync();
            ViewData["CategoryList"] = new SelectList(categoryList, "DataValueField", "DataTextField", employeeDetail.Category);

            var genderList = await _selectRepository.GenderSelectListCacheAsync();
            ViewData["GenderList"] = new SelectList(genderList, "DataValueField", "DataTextField", employeeDetail.Sex);

            var companyList = await _selectRepository.CompanySelectListCacheAsync();
            ViewData["CompanyList"] = new SelectList(companyList, "DataValueField", "DataTextField", employeeDetail.Company);

            var toggleList = new List<SelectListItem> { new SelectListItem { Text = "Yes", Value = "Y"},
                                                        new SelectListItem { Text = "No", Value = "N"}
                                                      };
            ViewData["MarriedList"] = new SelectList(toggleList, "Value", "Text", employeeDetail.Married);

            return PartialView("_ModalEmployeeMainEditPartial", model);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, HRMastersHelper.ActionEditEmplmast)]
        public async Task<IActionResult> EmployeeEdit([FromForm] EmployeeMasterEditViewMainModel employeeEditViewMainModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    EmployeeMasterMainEdit employeeMainEdit = new EmployeeMasterMainEdit
                    {
                        PEmpno = employeeEditViewMainModel.Empno,
                        PAbbr = employeeEditViewMainModel.Abbr,
                        PEmptype = employeeEditViewMainModel.Emptype,
                        PEmail = employeeEditViewMainModel.Email,
                        PParent = employeeEditViewMainModel.Parent,
                        PAssign = employeeEditViewMainModel.Assign,
                        PDesgcode = employeeEditViewMainModel.Desgcode,
                        PDob = (DateTime?)employeeEditViewMainModel.DoB,
                        PDoj = (DateTime?)employeeEditViewMainModel.DoJ,
                        POffice = employeeEditViewMainModel.Office,
                        PSex = employeeEditViewMainModel.Sex,
                        PCategory = employeeEditViewMainModel.Category,
                        PMarried = employeeEditViewMainModel.Married,
                        PMetaid = employeeEditViewMainModel.Metaid,
                        PPersonid = employeeEditViewMainModel.Personid,
                        PGrade = employeeEditViewMainModel.Grade,
                        PCompany = employeeEditViewMainModel.Company,
                        PDoc = (DateTime?)employeeEditViewMainModel.DoC,
                        PFirstname = employeeEditViewMainModel.Firstname,
                        PMiddlename = employeeEditViewMainModel.Middlename,
                        PLastname = employeeEditViewMainModel.Lastname
                    };

                    var retVal = await _employeeMasterRepository.EditEmployeeMain(employeeMainEdit);
                    if (retVal.OutPSuccess == "OK")
                    {
                        return Json(new { success = "OK", response = retVal.OutPMessage });
                    }
                    else
                    {
                        throw new Exception(retVal.OutPMessage.Replace("-", " "));
                    }

                    //if (retVal.OutPSuccess == "OK")
                    //{
                    //    Notify("Success", retVal.OutPMessage, "toaster", NotificationType.success);
                    //}
                    //else
                    //{
                    //    Notify("Error", retVal.OutPMessage, "toaster", NotificationType.error);
                    //}
                }
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
            }

            //return RedirectToAction("Detail", "Employee");
            return RedirectToAction("Detail", "Employee", new { id = employeeEditViewMainModel.Empno });
        }

        #endregion >>>>>>>>>>> Employee Main <<<<<<<<<<<<<<

        #region >>>>>>>>>>> Employee Address <<<<<<<<<<<<<<

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, HRMastersHelper.ActionViewHRMasters)]
        public async Task<IActionResult> AddressDetail(string id)
        {
            if (id == null)
                return NotFound();

            UserIdentity currentUserIdentity = CurrentUserIdentity;
            var addressDetail = await _employeeMasterViewRepository.EmployeeAddressDetail(id, currentUserIdentity.EmpNo);

            if (addressDetail == null)
            {
                return NotFound();
            }

            return PartialView("_EmployeeAddressDetailPartial", addressDetail);
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, HRMastersHelper.ActionEditEmplmast)]
        public async Task<IActionResult> AddressEdit(string id)
        {
            if (id == null)
                return NotFound();

            var model = new EmployeeMasterAddressEditViewModel();

            UserIdentity currentUserIdentity = CurrentUserIdentity;
            var addressDetail = await _employeeMasterViewRepository.EmployeeAddressDetail(id, currentUserIdentity.EmpNo);

            if (addressDetail == null)
            {
                return NotFound();
            }

            model.Empno = addressDetail.Empno;
            model.Add1 = addressDetail.Add1;
            model.Add2 = addressDetail.Add2;
            model.Add3 = addressDetail.Add3;
            model.Add4 = addressDetail.Add4;
            model.Pincode = addressDetail.Pincode;

            ViewData["Name"] = addressDetail.Name;

            return PartialView("_ModalEmployeeAddressEditPartial", model);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, HRMastersHelper.ActionEditEmplmast)]
        public async Task<IActionResult> AddressEdit([FromForm] EmployeeMasterAddressEditViewModel employeeMasterAddressEditViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    EmployeeMasterAddressUpdate employeeAddressUpdate = new EmployeeMasterAddressUpdate
                    {
                        PEmpno = employeeMasterAddressEditViewModel.Empno,
                        PAdd1 = employeeMasterAddressEditViewModel.Add1,
                        PAdd2 = employeeMasterAddressEditViewModel.Add2,
                        PAdd3 = employeeMasterAddressEditViewModel.Add3,
                        PAdd4 = employeeMasterAddressEditViewModel.Add4,
                        PPincode = employeeMasterAddressEditViewModel.Pincode
                    };

                    var retVal = await _employeeMasterRepository.UpdateEmployeeAddress(employeeAddressUpdate);

                    if (retVal.OutPSuccess == "OK")
                    {
                        return Json(new { success = "OK", response = retVal.OutPMessage });
                    }
                    else
                    {
                        throw new Exception(retVal.OutPMessage.Replace("-", " "));
                    }
                }
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
            }

            return RedirectToAction("AddressDetail", "Employee", new { id = employeeMasterAddressEditViewModel.Empno });
        }

        #endregion >>>>>>>>>>> Employee Address <<<<<<<<<<<<<<

        #region >>>>>>>>>>> Employee Applications <<<<<<<<<<<<<<

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, HRMastersHelper.ActionViewHRMasters)]
        public async Task<IActionResult> ApplicationsDetail(string id)
        {
            if (id == null)
                return NotFound();

            UserIdentity currentUserIdentity = CurrentUserIdentity;
            var rolesDetail = await _employeeMasterViewRepository.EmployeeApplicationsDetail(id, currentUserIdentity.EmpNo);

            if (rolesDetail == null)
            {
                return NotFound();
            }

            return PartialView("_EmployeeApplicationsDetailPartial", rolesDetail);
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, HRMastersHelper.ActionEditEmplmast)]
        public async Task<IActionResult> ApplicationsEdit(string id)
        {
            if (id == null)
                return NotFound();

            var model = new EmployeeMasterApplicationsEditViewModel();

            UserIdentity currentUserIdentity = CurrentUserIdentity;
            var applicationsDetail = await _employeeMasterViewRepository.EmployeeApplicationsDetail(id, currentUserIdentity.EmpNo);

            if (applicationsDetail == null)
            {
                return NotFound();
            }

            model.Empno = applicationsDetail.Empno;
            model.Expatriate = applicationsDetail.Expatriate ?? 0;
            model.HrOpr = applicationsDetail.HrOpr ?? 0;
            model.InvAuth = applicationsDetail.InvAuth ?? 0;
            model.JobIncharge = applicationsDetail.JobIncharge ?? 0;
            model.Newemp = applicationsDetail.Newemp ?? 0;
            model.Payroll = applicationsDetail.Payroll ?? 0;
            model.ProcOpr = applicationsDetail.ProcOpr ?? 0;
            model.Seatreq = applicationsDetail.Seatreq ?? 0;
            model.Submit = applicationsDetail.Submit ?? 0;

            var toggleList = new List<SelectListItem> { new SelectListItem { Text = "Yes", Value = "1"},
                                                        new SelectListItem { Text = "No", Value = "0"}
                                                      };
            ViewData["Name"] = applicationsDetail.Name;
            ViewData["ExpatriateList"] = new SelectList(toggleList, "Value", "Text", Convert.ToString(applicationsDetail.Expatriate ?? 0));
            ViewData["HrOprList"] = new SelectList(toggleList, "Value", "Text", Convert.ToString(applicationsDetail.HrOpr ?? 0));
            ViewData["InvAuthList"] = new SelectList(toggleList, "Value", "Text", Convert.ToString(applicationsDetail.InvAuth ?? 0));
            ViewData["JobInchargeList"] = new SelectList(toggleList, "Value", "Text", Convert.ToString(applicationsDetail.JobIncharge ?? 0));
            ViewData["NewempList"] = new SelectList(toggleList, "Value", "Text", Convert.ToString(applicationsDetail.Newemp ?? 0));
            ViewData["PayrollList"] = new SelectList(toggleList, "Value", "Text", Convert.ToString(applicationsDetail.Payroll ?? 0));
            ViewData["ProcOprList"] = new SelectList(toggleList, "Value", "Text", Convert.ToString(applicationsDetail.ProcOpr ?? 0));
            ViewData["SeatreqList"] = new SelectList(toggleList, "Value", "Text", Convert.ToString(applicationsDetail.Seatreq ?? 0));
            ViewData["SubmitList"] = new SelectList(toggleList, "Value", "Text", Convert.ToString(applicationsDetail.Submit ?? 0));

            return PartialView("_ModalEmployeeApplicationsEditPartial", model);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, HRMastersHelper.ActionEditEmplmast)]
        public async Task<IActionResult> ApplicationsEdit([FromForm] EmployeeMasterApplicationsEditViewModel employeeMasterApplicationsEditViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    EmployeeMasterApplicationsUpdate employeeApplicationsUpdate = new EmployeeMasterApplicationsUpdate
                    {
                        PEmpno = employeeMasterApplicationsEditViewModel.Empno,
                        PExpatriate = employeeMasterApplicationsEditViewModel.Expatriate ?? 0,
                        PHrOpr = employeeMasterApplicationsEditViewModel.HrOpr ?? 0,
                        PInvAuth = employeeMasterApplicationsEditViewModel.InvAuth ?? 0,
                        PJobIncharge = employeeMasterApplicationsEditViewModel.JobIncharge ?? 0,
                        PNewemp = employeeMasterApplicationsEditViewModel.Newemp ?? 0,
                        PPayroll = employeeMasterApplicationsEditViewModel.Payroll ?? 0,
                        PProcOpr = employeeMasterApplicationsEditViewModel.ProcOpr ?? 0,
                        PSeatreq = employeeMasterApplicationsEditViewModel.Seatreq ?? 0,
                        PSubmit = employeeMasterApplicationsEditViewModel.Submit ?? 0
                    };

                    var retVal = await _employeeMasterRepository.UpdateEmployeeApplications(employeeApplicationsUpdate);

                    if (retVal.OutPSuccess == "OK")
                    {
                        return Json(new { success = "OK", response = retVal.OutPMessage });
                    }
                    else
                    {
                        throw new Exception(retVal.OutPMessage.Replace("-", " "));
                    }
                    //if (retVal.OutPSuccess == "OK")
                    //{
                    //    Notify("Success", retVal.OutPMessage, "toaster", NotificationType.success);
                    //}
                    //else
                    //{
                    //    Notify("Error", retVal.OutPMessage, "toaster", NotificationType.error);
                    //}
                }
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
            }

            //return RedirectToAction(actionName: nameof(Detail), new { id = employeeMasterApplicationsEditViewModel.Empno });
            return RedirectToAction("ApplicationsDetail", "Employee", new { id = employeeMasterApplicationsEditViewModel.Empno });
        }

        #endregion >>>>>>>>>>> Employee Applications <<<<<<<<<<<<<<

        #region >>>>>>>>>>> Employee Organization details <<<<<<<<<<<<<<

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, HRMastersHelper.ActionViewHRMasters)]
        public async Task<IActionResult> OrganizationDetail(string id)
        {
            if (id == null)
                return NotFound();

            UserIdentity currentUserIdentity = CurrentUserIdentity;
            var rolesDetail = await _employeeMasterViewRepository.EmployeeOrganizationDetail(id, currentUserIdentity.EmpNo);

            if (rolesDetail == null)
            {
                return NotFound();
            }

            return PartialView("_EmployeeOrganizationDetailPartial", rolesDetail);
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, HRMastersHelper.ActionEditEmplmast)]
        public async Task<IActionResult> OrganizationEdit(string id)
        {
            if (id == null)
                return NotFound();

            var model = new EmployeeMasterOrganizationEditViewModel();

            UserIdentity currentUserIdentity = CurrentUserIdentity;
            var organizationDetail = await _employeeMasterViewRepository.EmployeeOrganizationDetail(id, currentUserIdentity.EmpNo);

            if (organizationDetail == null)
            {
                return NotFound();
            }

            var employeeOrganizationQualification = await _employeeMasterViewRepository.EmployeeOrganizationQualificationList(id);
            var employeeOrganizationQualificationList = employeeOrganizationQualification.Select(x => x.QualificationId).ToList();

            model.Empno = organizationDetail.Empno;
            model.Dol = organizationDetail.Dol;
            model.Dor = organizationDetail.Dor;
            model.Secretary = organizationDetail.Secretary;
            model.Mngr = organizationDetail.Mngr;
            model.EmpHod = organizationDetail.EmpHod;
            model.Location = organizationDetail.Location;
            model.Sapemp = organizationDetail.Sapemp;
            model.Itno = organizationDetail.Itno;
            model.ContractEndDate = organizationDetail.ContractEndDate;
            model.Subcontract = organizationDetail.Subcontract;
            model.Cid = organizationDetail.Cid;
            model.Bankcode = organizationDetail.Bankcode;
            model.Acctno = organizationDetail.Acctno;
            model.Ifscno = organizationDetail.Ifscno;
            model.Graduation = organizationDetail.Graduation;
            model.Place = organizationDetail.Place;
            model.Qualification = employeeOrganizationQualificationList.ToArray();
            model.TitCd = organizationDetail.TitCd;
            model.JobTitle = organizationDetail.JobTitle;
            model.Gradyear = organizationDetail.Gradyear;
            model.Expbefore = organizationDetail.Expbefore;
            model.QualGroup = organizationDetail.QualGroup;
            model.Gratutityno = organizationDetail.Gratutityno;
            model.Aadharno = organizationDetail.Aadharno;
            model.Pfno = organizationDetail.Pfno;
            model.Superannuationno = organizationDetail.Superannuationno;
            model.Uanno = organizationDetail.Uanno;
            model.Pensionno = organizationDetail.Pensionno;
            model.DiplomaYear = organizationDetail.DiplomaYear;
            model.PostgraduationYear = organizationDetail.PostgraduationYear;

            var locationList = await _selectRepository.LocationSelectListCacheAsync();
            var employeeeList = await _selectRepository.EmployeeSelectListCacheAsync();
            var subcontractList = await _selectRepository.SubContractSelectListCacheAsync();
            var bankcodeList = await _selectRepository.BankcodeSelectListCacheAsync();
            var placeList = await _selectRepository.PlaceSelectListCacheAsync();
            var graduationList = await _selectRepository.GraduationSelectListCacheAsync();
            var qualificationList = await _selectRepository.QualificationSelectListCacheAsync();
            var jobTitleList = await _selectRepository.JobGroupJobDisciplineJobTitleSelectListCacheAsync();

            ViewData["Name"] = organizationDetail.Name;
            ViewData["LocationList"] = new SelectList(locationList, "DataValueField", "DataTextField", organizationDetail.Location ?? "");
            ViewData["MngrList"] = new SelectList(employeeeList, "DataValueField", "DataTextField", organizationDetail.Mngr ?? "");
            ViewData["EmphodList"] = new SelectList(employeeeList, "DataValueField", "DataTextField", organizationDetail.EmpHod ?? "");
            ViewData["SubcontractList"] = new SelectList(subcontractList, "DataValueField", "DataTextField", organizationDetail.Subcontract ?? "");
            ViewData["BankcodeList"] = new SelectList(bankcodeList, "DataValueField", "DataTextField", organizationDetail.Bankcode ?? "");
            ViewData["Place"] = new SelectList(placeList, "DataValueField", "DataTextField", organizationDetail.Place ?? "");
            ViewData["Graduation"] = new SelectList(graduationList, "DataValueField", "DataTextField", organizationDetail.Graduation ?? "");
            ViewData["Qualification"] = new SelectList(qualificationList, "DataValueField", "DataTextField", employeeOrganizationQualificationList.ToArray());
            ViewData["JobTitle"] = new SelectList(jobTitleList, "DataValueField", "DataTextField", organizationDetail.JobTitle ?? "", "DataGroupField");  

            return PartialView("_ModalEmployeeOrganizationEditPartial", model);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, HRMastersHelper.ActionEditEmplmast)]
        public async Task<IActionResult> OrganizationEdit([FromForm] EmployeeMasterOrganizationEditViewModel employeeMasterOrganizationEditViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    string qualificationList = null;
                    StringBuilder stringBuilder = new StringBuilder();

                    if (employeeMasterOrganizationEditViewModel.Qualification != null)
                    {
                        foreach (var item in employeeMasterOrganizationEditViewModel.Qualification)
                        {
                            stringBuilder.Append(item);
                            stringBuilder.Append(",");
                        }
                        qualificationList = stringBuilder.ToString().Trim(',');
                    }

                    EmployeeMasterOrganizationUpdate employeeOrganizationUpdate = new EmployeeMasterOrganizationUpdate
                    {
                        PEmpno = employeeMasterOrganizationEditViewModel.Empno,
                        PDol = employeeMasterOrganizationEditViewModel.Dol,
                        PDor = employeeMasterOrganizationEditViewModel.Dor,                        
                        PMngr = employeeMasterOrganizationEditViewModel.Mngr,
                        PEmpHod = employeeMasterOrganizationEditViewModel.EmpHod,
                        PLocation = employeeMasterOrganizationEditViewModel.Location,
                        PSapemp = employeeMasterOrganizationEditViewModel.Sapemp,
                        PItno = employeeMasterOrganizationEditViewModel.Itno,
                        PContractEndDate = employeeMasterOrganizationEditViewModel.ContractEndDate,
                        PSubcontract = employeeMasterOrganizationEditViewModel.Subcontract,
                        PCid = employeeMasterOrganizationEditViewModel.Cid,
                        PBankcode = employeeMasterOrganizationEditViewModel.Bankcode,
                        PAcctno = employeeMasterOrganizationEditViewModel.Acctno,
                        PIfscno = employeeMasterOrganizationEditViewModel.Ifscno,
                        PGraduation = employeeMasterOrganizationEditViewModel.Graduation,
                        PPlace = employeeMasterOrganizationEditViewModel.Place,
                        PQualification = qualificationList,
                        PTitCd = employeeMasterOrganizationEditViewModel.TitCd,
                        PJobTitle = employeeMasterOrganizationEditViewModel.JobTitle,
                        PGradyear = employeeMasterOrganizationEditViewModel.Gradyear,
                        PExpbefore = employeeMasterOrganizationEditViewModel.Expbefore,
                        PQualGroup = (int?)employeeMasterOrganizationEditViewModel.QualGroup,
                        PGratutityno = employeeMasterOrganizationEditViewModel.Gratutityno,
                        PAadharno = employeeMasterOrganizationEditViewModel.Aadharno,
                        PPfno = employeeMasterOrganizationEditViewModel.Pfno,
                        PSuperannuationno = employeeMasterOrganizationEditViewModel.Superannuationno,
                        PUanno = employeeMasterOrganizationEditViewModel.Uanno,
                        PPensionno = employeeMasterOrganizationEditViewModel.Pensionno,
                        PDiplomaYear = employeeMasterOrganizationEditViewModel.DiplomaYear,
                        PPostgraduationYear = employeeMasterOrganizationEditViewModel.PostgraduationYear          
                    };

                    var retVal = await _employeeMasterRepository.UpdateEmployeeOrganization(employeeOrganizationUpdate);

                    if (retVal.OutPSuccess == "OK")
                    {
                        return Json(new { success = "OK", response = retVal.OutPMessage });
                    }
                    else
                    {
                        throw new Exception(retVal.OutPMessage.Replace("-", " "));
                    }

                    //if (retVal.OutPSuccess == "OK")
                    //{
                    //    Notify("Success", retVal.OutPMessage, "toaster", NotificationType.success);
                    //}
                    //else
                    //{
                    //    Notify("Error", retVal.OutPMessage, "toaster", NotificationType.error);
                    //}
                }
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
            }

            //return RedirectToAction(actionName: nameof(Detail), new { id = employeeMasterOrganizationEditViewModel.Empno });
            return RedirectToAction("OrganizationDetail", "Employee", new { id = employeeMasterOrganizationEditViewModel.Empno });
        }

        #endregion >>>>>>>>>>> Employee Organization details <<<<<<<<<<<<<<

        #region >>>>>>>>>>> Employee Roles <<<<<<<<<<<<<<

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, HRMastersHelper.ActionViewHRMasters)]
        public async Task<IActionResult> RolesDetail(string id)
        {
            if (id == null)
                return NotFound();

            UserIdentity currentUserIdentity = CurrentUserIdentity;
            var rolesDetail = await _employeeMasterViewRepository.EmployeeRolesDetail(id, currentUserIdentity.EmpNo);

            if (rolesDetail == null)
            {
                return NotFound();
            }

            return PartialView("_EmployeeRolesDetailPartial", rolesDetail);
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, HRMastersHelper.ActionEditEmplmast)]
        public async Task<IActionResult> RolesEdit(string id)
        {
            if (id == null)
                return NotFound();

            var model = new EmployeeMasterRolesEditViewModel();

            UserIdentity currentUserIdentity = CurrentUserIdentity;
            var rolesDetail = await _employeeMasterViewRepository.EmployeeRolesDetail(id, currentUserIdentity.EmpNo);

            if (rolesDetail == null)
            {
                return NotFound();
            }

            model.Empno = rolesDetail.Empno;
            model.AmfiAuth = rolesDetail.AmfiAuth ?? 0;
            model.AmfiUser = rolesDetail.AmfiUser ?? 0;
            model.Costdy = rolesDetail.Costdy ?? 0;
            model.Costhead = rolesDetail.Costhead ?? 0;
            model.Costopr = rolesDetail.Costopr ?? 0;
            model.Dba = rolesDetail.Dba ?? 0;
            model.Director = rolesDetail.Director ?? 0;
            model.Dirop = rolesDetail.Dirop ?? 0;
            model.Projdy = rolesDetail.Projdy ?? 0;
            model.Projmngr = rolesDetail.Projmngr ?? 0;

            var toggleList = new List<SelectListItem> { new SelectListItem { Text = "Yes", Value = "1"},
                                                        new SelectListItem { Text = "No", Value = "0"}
                                                      };
            ViewData["Name"] = rolesDetail.Name;
            ViewData["AmfiAuthList"] = new SelectList(toggleList, "Value", "Text", rolesDetail.AmfiAuth);
            ViewData["AmfiUserList"] = new SelectList(toggleList, "Value", "Text", rolesDetail.AmfiUser);
            ViewData["CostdyList"] = new SelectList(toggleList, "Value", "Text", rolesDetail.Costdy);
            ViewData["CostheadList"] = new SelectList(toggleList, "Value", "Text", rolesDetail.Costhead);
            ViewData["CostoprList"] = new SelectList(toggleList, "Value", "Text", rolesDetail.Costopr);
            ViewData["DbaList"] = new SelectList(toggleList, "Value", "Text", rolesDetail.Dba);
            ViewData["DirectorList"] = new SelectList(toggleList, "Value", "Text", rolesDetail.Director);
            ViewData["DiropList"] = new SelectList(toggleList, "Value", "Text", rolesDetail.Dirop);
            ViewData["ProjdyList"] = new SelectList(toggleList, "Value", "Text", rolesDetail.Projdy);
            ViewData["ProjmngrList"] = new SelectList(toggleList, "Value", "Text", rolesDetail.Projmngr);

            return PartialView("_ModalEmployeeRolesEditPartial", model);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, HRMastersHelper.ActionEditEmplmast)]
        public async Task<IActionResult> RolesEdit([FromForm] EmployeeMasterRolesEditViewModel employeeMasterRolesEditViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    EmployeeMasterRolesUpdate employeeRolesUpdate = new EmployeeMasterRolesUpdate
                    {
                        PEmpno = employeeMasterRolesEditViewModel.Empno,
                        PAmfiAuth = employeeMasterRolesEditViewModel.AmfiAuth ?? 0,
                        PAmfiUser = employeeMasterRolesEditViewModel.AmfiUser ?? 0,
                        PCostdy = employeeMasterRolesEditViewModel.Costdy ?? 0,
                        PCosthead = employeeMasterRolesEditViewModel.Costhead ?? 0,
                        PCostopr = employeeMasterRolesEditViewModel.Costopr ?? 0,
                        PDba = employeeMasterRolesEditViewModel.Dba ?? 0,
                        PDirector = employeeMasterRolesEditViewModel.Director ?? 0,
                        PDirop = employeeMasterRolesEditViewModel.Dirop ?? 0,
                        PProjdy = employeeMasterRolesEditViewModel.Projdy ?? 0,
                        PProjmngr = employeeMasterRolesEditViewModel.Projmngr ?? 0
                    };

                    var retVal = await _employeeMasterRepository.UpdateEmployeeRoles(employeeRolesUpdate);

                    if (retVal.OutPSuccess == "OK")
                    {
                        return Json(new { success = "OK", response = retVal.OutPMessage });
                    }
                    else
                    {
                        throw new Exception(retVal.OutPMessage.Replace("-", " "));
                    }

                    //if (retVal.OutPSuccess == "OK")
                    //{
                    //    Notify("Success", retVal.OutPMessage, "toaster", NotificationType.success);
                    //}
                    //else
                    //{
                    //    Notify("Error", retVal.OutPMessage, "toaster", NotificationType.error);
                    //}
                }
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
            }

            //return RedirectToAction(actionName: nameof(Detail), new { id = employeeMasterRolesEditViewModel.Empno });
            return RedirectToAction("RolesDetail", "Employee", new { id = employeeMasterRolesEditViewModel.Empno });
        }

        #endregion >>>>>>>>>>> Employee Roles <<<<<<<<<<<<<<

        #region >>>>>>>>>>> Employee Miscellaneous Details <<<<<<<<<<<<<<

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, HRMastersHelper.ActionViewHRMasters)]
        public async Task<IActionResult> MiscellaneousDetail(string id)
        {
            if (id == null)
                return NotFound();

            UserIdentity currentUserIdentity = CurrentUserIdentity;
            var miscDetail = await _employeeMasterViewRepository.EmployeeMiscDetail(id, currentUserIdentity.EmpNo);

            if (miscDetail == null)
            {
                return NotFound();
            }

            return PartialView("_EmployeeMiscDetailPartial", miscDetail);
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, HRMastersHelper.ActionEditEmplmast)]
        public async Task<IActionResult> MiscellaneousEdit(string id)
        {
            if (id == null)
                return NotFound();

            var model = new EmployeeMasterMiscEditViewModel();

            UserIdentity currentUserIdentity = CurrentUserIdentity;
            var miscDetail = await _employeeMasterViewRepository.EmployeeMiscDetail(id, currentUserIdentity.EmpNo);

            if (miscDetail == null)
            {
                return NotFound();
            }

            model.Empno = miscDetail.Empno;
            model.DeptCode = miscDetail.DeptCode;
            model.Eow = miscDetail.Eow;
            model.EowDate = miscDetail.EowDate;
            model.EowWeek = miscDetail.EowWeek;
            model.EsiCover = miscDetail.EsiCover;
            model.Ipadd = miscDetail.Ipadd;
            model.Jobcategoorydesc = miscDetail.Jobcategoorydesc;
            model.Jobcategory = miscDetail.Jobcategory;            
            model.Jobsubcategory = miscDetail.Jobsubcategory;
            model.Jobsubcategorydesc = miscDetail.Jobsubcategorydesc;
            model.Jobsubdiscipline = miscDetail.Jobsubdiscipline;
            model.Jobsubdisciplinedesc = miscDetail.Jobsubdisciplinedesc;            
            model.Lastday = miscDetail.Lastday;
            model.LocId = miscDetail.LocId;
            model.NoTcmUpd = miscDetail.NoTcmUpd;
            model.Oldco = miscDetail.Oldco;
            model.Ondeputation = miscDetail.Ondeputation;
            model.Pfslno = miscDetail.Pfslno;
            model.Projno = miscDetail.Projno;
            model.Pwd = miscDetail.Pwd;
            model.Reporting = miscDetail.Reporting;
            model.Reporto = miscDetail.Reporto;
            model.Secretary = miscDetail.Secretary;
            model.TransIn = miscDetail.TransIn;
            model.TransOut = miscDetail.TransOut;
            model.UserDomain = miscDetail.UserDomain;
            model.Userid = miscDetail.Userid;
            model.WebItdecl = miscDetail.WebItdecl;
            model.WinidReqd = miscDetail.WinidReqd;
            var dicList = new Dictionary<int, string>
            {
                { 0, "No" },
                { 1, "Yes" }
            };

            ViewData["Name"] = miscDetail.Name;
            ViewData["NoTcmUpdList"] = new SelectList(dicList, "Key", "Value", miscDetail.NoTcmUpd);
            ViewData["OndeputationList"] = new SelectList(dicList, "Key", "Value", miscDetail.Ondeputation);
            ViewData["ReportingList"] = new SelectList(dicList, "Key", "Value", miscDetail.Reporting);
            ViewData["SecretaryList"] = new SelectList(dicList, "Key", "Value", miscDetail.Secretary);
            ViewData["WebitdeclList"] = new SelectList(dicList, "Key", "Value", miscDetail.WebItdecl);
            ViewData["WinidreqList"] = new SelectList(dicList, "Key", "Value", miscDetail.WinidReqd);

            var jobgroupList = await _selectRepository.HRJobgroupSelectListCacheAsync();
            ViewData["JobgroupList"] = new SelectList(jobgroupList, "DataValueField", "DataTextField", miscDetail.Jobgroup);
            var jobdisciplineList = await _selectRepository.HRJobdisciplineSelectListCacheAsync();
            ViewData["JobdisciplineList"] = new SelectList(jobdisciplineList, "DataValueField", "DataTextField", miscDetail.Jobdiscipline);
            var jobtitleList = await _selectRepository.HRJobtitleSelectListCacheAsync();
            ViewData["JobtitleCodeList"] = new SelectList(jobtitleList, "DataValueField", "DataTextField", miscDetail.JobtitleCode);            

            return PartialView("_ModalEmployeeMiscEditPartial", model);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, HRMastersHelper.ActionEditEmplmast)]
        public async Task<IActionResult> MiscellaneousEdit([FromForm] EmployeeMasterMiscEditViewModel employeeMasterMiscEditViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    EmployeeMasterMiscUpdate employeeMiscUpdate = new EmployeeMasterMiscUpdate
                    {
                        PEmpno = employeeMasterMiscEditViewModel.Empno,
                        PDeptCode = employeeMasterMiscEditViewModel.DeptCode,
                        PEow = employeeMasterMiscEditViewModel.Eow,
                        PEowDate = employeeMasterMiscEditViewModel.EowDate,
                        PEowWeek = employeeMasterMiscEditViewModel.EowWeek,
                        PEsiCover = employeeMasterMiscEditViewModel.EsiCover,
                        PIpadd = employeeMasterMiscEditViewModel.Ipadd,
                        PJobcategoorydesc = employeeMasterMiscEditViewModel.Jobcategoorydesc,
                        PJobcategory = employeeMasterMiscEditViewModel.Jobcategory,
                        PJobdiscipline = employeeMasterMiscEditViewModel.Jobdiscipline,                        
                        PJobgroup = employeeMasterMiscEditViewModel.Jobgroup,                        
                        PJobsubcategory = employeeMasterMiscEditViewModel.Jobsubcategory,
                        PJobsubcategorydesc = employeeMasterMiscEditViewModel.Jobsubcategorydesc,
                        PJobsubdiscipline = employeeMasterMiscEditViewModel.Jobsubdiscipline,
                        PJobsubdisciplinedesc = employeeMasterMiscEditViewModel.Jobsubdisciplinedesc,
                        PJobtitleCode = employeeMasterMiscEditViewModel.JobtitleCode,
                        PLastday = employeeMasterMiscEditViewModel.Lastday,
                        PLocId = employeeMasterMiscEditViewModel.LocId,
                        PNoTcmUpd = employeeMasterMiscEditViewModel.NoTcmUpd,
                        POldco = employeeMasterMiscEditViewModel.Oldco,
                        POndeputation = employeeMasterMiscEditViewModel.Ondeputation,
                        PPfslno = employeeMasterMiscEditViewModel.Pfslno,
                        PProjno = employeeMasterMiscEditViewModel.Projno,
                        PPwd = employeeMasterMiscEditViewModel.Pwd,
                        PReporting = employeeMasterMiscEditViewModel.Reporting,
                        PReporto = employeeMasterMiscEditViewModel.Reporto,
                        PSecretary = employeeMasterMiscEditViewModel.Secretary,
                        PTransIn = employeeMasterMiscEditViewModel.TransIn,
                        PTransOut = employeeMasterMiscEditViewModel.TransOut,
                        PUserDomain = employeeMasterMiscEditViewModel.UserDomain,
                        PUserid = employeeMasterMiscEditViewModel.Userid,
                        PWebItdecl = employeeMasterMiscEditViewModel.WebItdecl,
                        PWinidReqd = employeeMasterMiscEditViewModel.WinidReqd
                    };

                    var retVal = await _employeeMasterRepository.UpdateEmployeeMisc(employeeMiscUpdate);
                    if (retVal.OutPSuccess == "OK")
                    {
                        return Json(new { success = "OK", response = retVal.OutPMessage });
                    }
                    else
                    {
                        throw new Exception(retVal.OutPMessage.Replace("-", " "));
                    }

                    //if (retVal.OutPSuccess == "OK")
                    //{
                    //    Notify("Success", retVal.OutPMessage, "toaster", NotificationType.success);
                    //}
                    //else
                    //{
                    //    Notify("Error", retVal.OutPMessage, "toaster", NotificationType.error);
                    //}
                }
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
            }

            //return RedirectToAction(actionName: nameof(Detail), new { id = employeeMasterMiscEditViewModel.Empno });
            return RedirectToAction("MiscellaneousDetail", "Employee", new { id = employeeMasterMiscEditViewModel.Empno });
        }

        #endregion >>>>>>>>>>> Employee Miscellaneous Details <<<<<<<<<<<<<<

        #region >>>>>>>>>>> Employee Deactivate <<<<<<<<<<<<<<

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, HRMastersHelper.ActionEditEmplmast)]
        public async Task<IActionResult> DeactivateEmployee(String id)
        {
            if (id == null)
                return NotFound();

            var model = new EmployeeDeactivateViewModel();

            UserIdentity currentUserIdentity = CurrentUserIdentity;
            var employeeDetail = await _employeeMasterViewRepository.EmployeeMainDetail(id, currentUserIdentity.EmpNo);

            if (employeeDetail == null)
            {
                return NotFound();
            }

            model.Empno = id;

            var reasonList = await _selectRepository.LeavingReasonSelectListCacheAsync();
            ViewData["ReasonList"] = new SelectList(reasonList, "DataValueField", "DataTextField");

            ViewData["Name"] = employeeDetail.Name;

            return PartialView("_ModalEmployeeDeactivatePartial", model);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, HRMastersHelper.ActionEditEmplmast)]
        public async Task<IActionResult> DeactivateEmployee([FromForm] EmployeeDeactivateViewModel employeDeactivateViewModel)
        {
            if (employeDeactivateViewModel.Empno == null || employeDeactivateViewModel.Dol == null || employeDeactivateViewModel.ReasonId == null)
                return NotFound();

            var employeeDeactivate = new EmployeeDeactivate();

            employeeDeactivate.PEmpno = employeDeactivateViewModel.Empno;
            employeeDeactivate.PDol = (DateTime)employeDeactivateViewModel.Dol;
            employeeDeactivate.PReasonId = employeDeactivateViewModel.ReasonId;
            employeeDeactivate.PRemarks = employeDeactivateViewModel.Remarks;

            var retVal = await _employeeMasterRepository.DeactivateEmployee(employeeDeactivate);

            if (retVal.OutPSuccess == "OK")
            {
                return Json(new { success = "OK", response = retVal.OutPMessage });
            }
            else
            {
                throw new Exception(retVal.OutPMessage.Replace("-", " "));
            }

            //if (retVal.OutPSuccess == "OK")
            //{
            //    Notify("Success", retVal.OutPMessage, "toaster", NotificationType.success);
            //}
            //else
            //{
            //    Notify("Error", retVal.OutPMessage, "toaster", NotificationType.error);
            //}

            //return Redirect("~/HRMasters/Employee");
            //return RedirectToAction("Index", "Employee");
        }

        #endregion >>>>>>>>>>> Employee Deactivate <<<<<<<<<<<<<<

        #region >>>>>>>>>>> Employee Activate <<<<<<<<<<<<<<

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, HRMastersHelper.RolePayRollAdmin)]
        public async Task<IActionResult> ActivateEmployee(String id)
        {
            if (id == null)
                return NotFound();

            var model = new EmployeeActivateViewModel();

            UserIdentity currentUserIdentity = CurrentUserIdentity;
            var employeeDetail = await _employeeMasterViewRepository.EmployeeOrganizationDetail(id, currentUserIdentity.EmpNo);

            if (employeeDetail == null)
            {
                return NotFound();
            }

            model.Empno = id;
            model.Dol = (DateTime)employeeDetail.Dol;
            model.ReasonDesc = employeeDetail.ReasonDesc;
            model.Remarks = employeeDetail.Remarks;

            ViewData["Name"] = employeeDetail.Name;

            return PartialView("_ModalEmployeeActivatePartial", model);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixRole, HRMastersHelper.RolePayRollAdmin)]
        public async Task<IActionResult> ActivateEmployee([FromForm] EmployeeActivateViewModel employeActivateViewModel)
        {
            if (employeActivateViewModel.Empno == null)
                return NotFound();

            var employeeActivate = new EmployeeActivate();

            employeeActivate.PEmpno = employeActivateViewModel.Empno;

            var retVal = await _employeeMasterRepository.ActivateEmployee(employeeActivate);

            if (retVal.OutPSuccess == "OK")
            {
                return Json(new { success = "OK", response = retVal.OutPMessage });
            }
            else
            {
                throw new Exception(retVal.OutPMessage.Replace("-", " "));
            }

            //if (retVal.OutPSuccess == "OK")
            //{
            //    Notify("Success", retVal.OutPMessage, "toaster", NotificationType.success);
            //}
            //else
            //{
            //    Notify("Error", retVal.OutPMessage, "toaster", NotificationType.error);
            //}

            //return Redirect("~/HRMasters/Employee");
            //return RedirectToAction("Index", "Employee");
        }

        #endregion >>>>>>>>>>> Employee Activate <<<<<<<<<<<<<<

        #region Filter

        public async Task<IActionResult> FilterGet()
        {
            var statusList = new List<SelectListItem> { new SelectListItem { Text = "Active", Value = "1"},
                                                        new SelectListItem { Text = "Deactive", Value = "0"}
                                                        };

            ViewData["StatusList"] = new SelectList(statusList, "Value", "Text");

            //FilterDataModel filterDataModel = new FilterDataModel();

            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterEmployeeMasterIndex
            });

            FilterDataModel filterDataModel = new FilterDataModel();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            if (filterDataModel.Status == null)
                filterDataModel.Status = 1;

            return PartialView("_FilterSetPartial", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> FilterSet([FromForm] FilterDataModel filterDataModel)
        {
            //var statusList = new List<SelectListItem> { new SelectListItem { Text = "Active", Value = "1"},
            //                                                new SelectListItem { Text = "Deactive", Value = "0"}
            //                                              };

            //ViewData["StatusList"] = new SelectList(statusList, "Value", "Text");

            //return Json(new { success = true, status = filterDataModel.Status });

            try
            {
                string jsonFilter;

                jsonFilter = JsonConvert.SerializeObject(new { Status = filterDataModel.Status });

                var retVal = await _filterRepository.FilterCreateAsync(new Domain.Models.FilterCreate
                {
                    PModuleName = CurrentUserIdentity.CurrentModule,
                    PMetaId = CurrentUserIdentity.MetaId,
                    PPersonId = CurrentUserIdentity.EmployeeId,
                    PMvcActionName = ConstFilterEmployeeMasterIndex,
                    PFilterJson = jsonFilter
                });

                return Json(new { success = true, status = filterDataModel.Status });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        //public async Task<IActionResult> FilterSet()
        //{
        //    //var filterDataModel = GetFilterSession(RouteData.Values["controller"].ToString());

        // var filterDataModel = new FilterDataModel();

        // var costcenterList = await _selectRepository.CostcenterSelectListCacheAsync();
        // ViewData["CostcenterList"] = new SelectList(costcenterList, "DataValueField", "DataTextField");

        // //ViewData["BusinessEntityId"] = new SelectList(businessEntities, "DataValueField",
        // "DataTextField", filterDataModel.BusinessEntityId, "DataGroupField");

        // //var dynamicFormTypeList = await _selectRepository.DynamicFormTypeListCacheAsync( //
        // BaseSpGet(), // null // );

        // //ViewData["DynamicFormTypeList"] = new SelectList(dynamicFormTypeList, "DataValueField",
        // "DataTextField", filterDataModel.DynamicFormTypeList, "DataGroupField");

        // //var dynamicFormSubTypeList = await _selectRepository.DynamicFormSubTypeListCacheAsync(
        // // BaseSpGet(), // null);

        // //ViewData["DynamicFormSubTypeList"] = new SelectList(dynamicFormSubTypeList,
        // "DataValueField", "DataTextField", filterDataModel.DynamicFormSubTypeList, "DataGroupField");

        // var statusList = new List<SelectListItem> { new SelectListItem { Text = "Active", Value =
        // "1"}, new SelectListItem { Text = "Deactive", Value = "0"} }; ViewData["StatusList"] =
        // new SelectList(statusList, "Value", "Text", filterDataModel.Status);
        // //ViewData["StatusList"] = new SelectList(statusList, "DataValueField", "DataTextField", filterDataModel.Status);

        //    return PartialView("_FilterSetPartial", filterDataModel);
        //}

        //[HttpPost]
        //[ValidateAntiForgeryToken]
        //public IActionResult FilterSet([FromForm] FilterDataModel filterDataModel)
        //{
        //    try
        //    {
        //        if (ModelState.IsValid)
        //        {
        //            SetFilterSession(RouteData.Values["controller"].ToString(), filterDataModel);
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
        //    }

        //    return PartialView("_FilterSetPartial", filterDataModel);
        //}

        #endregion Filter

        #region >>>>>>>>>>> Clone Employee <<<<<<<<<<<<<<

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, HRMastersHelper.ActionEditEmplmast)]
        public async Task<IActionResult> CloneEmployee(String id)
        {
            if (id == null)
                return NotFound();

            var model = new EmployeeCloneViewModel();

            UserIdentity currentUserIdentity = CurrentUserIdentity;
            var employeeDetail = await _employeeMasterViewRepository.EmployeeMainDetail(id, currentUserIdentity.EmpNo);

            if (employeeDetail == null)
            {
                return NotFound();
            }

            model.Empno = id;

            var emptypeList = await _selectRepository.EmptypeSelectListCacheAsync();
            ViewData["EmptypeList"] = new SelectList(emptypeList, "DataValueField", "DataTextField");

            var placeList = await _selectRepository.PlaceSelectListCacheAsync();
            ViewData["PlaceList"] = new SelectList(placeList, "DataValueField", "DataTextField");

            var costcenterList = await _selectRepository.CostcenterSelectListCacheAsync();
            ViewData["CostcenterList"] = new SelectList(costcenterList, "DataValueField", "DataTextField");

            ViewData["Name"] = employeeDetail.Name;

            return PartialView("_ModalCloneEmployeePartial", model);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, HRMastersHelper.ActionEditEmplmast)]
        public async Task<IActionResult> CloneEmployee([FromForm] EmployeeCloneViewModel employeCloneViewModel)
        {
            if (employeCloneViewModel.Empno == null || employeCloneViewModel.Emptype == null || employeCloneViewModel.EmpnoNew == null)
                return NotFound();

            var employeeClone = new EmployeeClone();

            employeeClone.PEmpno = employeCloneViewModel.Empno;
            employeeClone.PEmptype = employeCloneViewModel.Emptype;
            employeeClone.PEmpnoNew = employeCloneViewModel.EmpnoNew;
            employeeClone.PDoj = (DateTime?)employeCloneViewModel.DoJ;
            employeeClone.PParent = employeCloneViewModel.Parent;
            employeeClone.PAssign = employeCloneViewModel.Assign;
            employeeClone.POffice = employeCloneViewModel.Office;

            var retVal = await _employeeMasterRepository.CloneEmployee(employeeClone);

            if (retVal.OutPSuccess == "OK")
            {
                Notify("Success", retVal.OutPMessage, "toaster", NotificationType.success);
            }
            else
            {
                Notify("Error", retVal.OutPMessage, "toaster", NotificationType.error);
            }

            //return Redirect("~/HRMasters/Employee");

            return RedirectToAction("Index");
        }

        #endregion >>>>>>>>>>> Clone Employee <<<<<<<<<<<<<<

        #region >>>>>>>>>>> Excel Download <<<<<<<<<<<<<<

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, HRMastersHelper.ActionViewHRMasters)]
        public async Task<IActionResult> ExcelDownload(int? statusflag)
        {
            try
            {                
                string StrFimeName;

                string strUser = User.Identity.Name;

                var timeStamp = DateTime.Now.ToFileTime();
                StrFimeName = "EmployeeMaster_" + timeStamp.ToString();

                var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
                {
                    PModuleName = CurrentUserIdentity.CurrentModule,
                    PMetaId = CurrentUserIdentity.MetaId,
                    PPersonId = CurrentUserIdentity.EmployeeId,
                    PMvcActionName = ConstFilterEmployeeMasterIndex
                });

                FilterDataModel filterDataModel = new FilterDataModel();
                if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                    filterDataModel = Newtonsoft.Json.JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

                //IEnumerable<EmployeeMasterMainDataTableListExcel> data = await _employeeMasterDataTableListExcelViewRepository.GetEmployeeMasterForExcelAsync(
                //    BaseSpTcmPLGet(),
                //    new ParameterSpTcmPL
                //    {
                //        PGenericSearch = filterDataModel.GenericSearch,
                //        PStatus = statusflag
                //    });

                var result = (await _employeeMasterDataTableListExcelViewRepository.GetEmployeeMasterForExcelAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = filterDataModel.GenericSearch,
                        PStatus = statusflag
                    })).ToList();

                if (result == null) { return NotFound(); }

                //------------------

                //System.Data.DataTable dt = new System.Data.DataTable();
                //System.Data.DataTable dt_temp = new System.Data.DataTable();
                //ListtoDataTableConverter converter = new ListtoDataTableConverter();

                //dt = converter.ToDataTable(data.ToList());

                //dt_temp = dt.Clone();

                //dt_temp.Columns["dob"].DataType = typeof(DateTime);
                //dt_temp.Columns["doj"].DataType = typeof(DateTime);
                //dt_temp.Columns["doc"].DataType = typeof(DateTime);
                //dt_temp.Columns["dol"].DataType = typeof(DateTime);
                //dt_temp.Columns["dor"].DataType = typeof(DateTime);
                //foreach (DataRow rr in dt.Rows)
                //{
                //    dt_temp.Rows.Add(new object[] {
                //                            rr[0] == DBNull.Value ? string.Empty : rr[0],
                //                            rr[1] == DBNull.Value ? string.Empty : rr[1],
                //                            rr[2] == DBNull.Value ? string.Empty : rr[2],
                //                            rr[3] == DBNull.Value ? string.Empty : rr[3],
                //                            rr[4] == DBNull.Value ? string.Empty : rr[4],
                //                            rr[5] == DBNull.Value ? string.Empty : rr[5],
                //                            rr[6] == DBNull.Value ? string.Empty : rr[6],
                //                            rr[7] == DBNull.Value ? string.Empty : rr[7],
                //                            rr[8] == DBNull.Value ? string.Empty : rr[8],
                //                            rr[9] == DBNull.Value ? string.Empty : rr[9],
                //                            rr[10] == DBNull.Value ? string.Empty : rr[10],
                //                            rr[11] == DBNull.Value ? string.Empty : rr[11],
                //                            rr[12] == DBNull.Value ? string.Empty : rr[12],
                //                            rr[13] == DBNull.Value ? string.Empty : rr[13],
                //                            rr[14] == DBNull.Value ? string.Empty : rr[14],
                //                            rr[15] == DBNull.Value ? string.Empty : rr[15],
                //                            rr[16] == DBNull.Value ? string.Empty : rr[16],
                //                            rr[17] == DBNull.Value ? string.Empty : rr[17],
                //                            rr[18] == DBNull.Value ? string.Empty : rr[18],
                //                            rr[19] == DBNull.Value ? (DateTime?)null : Convert.ToDateTime(rr[19]),
                //                            rr[20] == DBNull.Value ? (DateTime?)null : Convert.ToDateTime(rr[20]),
                //                            rr[21] == DBNull.Value ? (DateTime?)null : Convert.ToDateTime(rr[21]),
                //                            rr[22] == DBNull.Value ? (DateTime?)null : Convert.ToDateTime(rr[22]),
                //                            rr[23] == DBNull.Value ? (DateTime?)null : Convert.ToDateTime(rr[23]),
                //                            rr[24] == DBNull.Value ? string.Empty : rr[24],
                //                            rr[25] == DBNull.Value ? string.Empty : rr[25],                                            
                //                            rr[26] == DBNull.Value ? string.Empty : rr[26],
                //                            rr[27] == DBNull.Value ? (decimal?) null : rr[27],
                //                            rr[28] == DBNull.Value ? string.Empty : rr[28],
                //                            rr[29] == DBNull.Value ? string.Empty : rr[29],
                //                            rr[30] == DBNull.Value ? string.Empty : rr[30],
                //                            rr[31] == DBNull.Value ? string.Empty : rr[31],
                //                            rr[32] == DBNull.Value ? string.Empty : rr[32],
                //                            rr[33] == DBNull.Value ? string.Empty : rr[33],
                //                            rr[34] == DBNull.Value ? string.Empty : rr[34],
                //                            rr[35] == DBNull.Value ? string.Empty : rr[35],
                //                            rr[36] == DBNull.Value ? string.Empty : rr[36],
                //                            rr[37] == DBNull.Value ? string.Empty : rr[37],
                //                            rr[38] == DBNull.Value ? string.Empty : rr[38],
                //                            rr[39] == DBNull.Value ? string.Empty : rr[39],
                //                            rr[40] == DBNull.Value ? string.Empty : rr[40],                                            
                //                            rr[41] == DBNull.Value ? string.Empty : rr[41],
                //                            rr[42] == DBNull.Value ? (int?) null : rr[42],
                //                            rr[43] == DBNull.Value ? string.Empty : rr[43],
                //                            rr[44] == DBNull.Value ? string.Empty : rr[44],
                //                            rr[45] == DBNull.Value ? string.Empty : rr[45],
                //                            rr[46] == DBNull.Value ? string.Empty : rr[46],
                //                            rr[47] == DBNull.Value ? string.Empty : rr[47],
                //                            rr[48] == DBNull.Value ? string.Empty : rr[48],
                //                            rr[49] == DBNull.Value ? string.Empty : rr[49],
                //                            rr[50] == DBNull.Value ? string.Empty : rr[50],
                //                            rr[51] == DBNull.Value ? string.Empty : rr[51],
                //                            rr[52] == DBNull.Value ? string.Empty : rr[52],
                //                            rr[53] == DBNull.Value ? string.Empty : rr[53],
                //                            rr[54] == DBNull.Value ? string.Empty : rr[54],
                //                            rr[55] == DBNull.Value ? string.Empty : rr[55],
                //                            rr[56] == DBNull.Value ? string.Empty : rr[56],
                //                            rr[57] == DBNull.Value ? string.Empty : rr[57],
                //                            rr[58] == DBNull.Value ? string.Empty : rr[58],
                //                            rr[59] == DBNull.Value ? string.Empty : rr[59],
                //                            rr[60] == DBNull.Value ? string.Empty : rr[60]

                //        });
                //}
                //dt = dt_temp;
                                
                using (XLWorkbook wb = new XLWorkbook())
                {
                    var mimeType = MimeTypeMap.GetMimeType("xlsx");
                    var sheet1 = wb.Worksheets.Add("HR Master");
                    sheet1.Cell(1, 1).InsertTable(result);

                    using (MemoryStream stream = new MemoryStream())
                    {
                        wb.SaveAs(stream);
                        stream.Position = 0;
                        FileContentResult file = File(stream.ToArray(), mimeType, StrFimeName);
                        return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
                    }
                }

                //------------------


                //var json = JsonConvert.SerializeObject(dt);
                //IEnumerable<EmployeeMasterMainDataTableListExcel> excelData = JsonConvert.DeserializeObject<IEnumerable<EmployeeMasterMainDataTableListExcel>>(json);
                //byte[] byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, "EmployeeMasters", "EmployeeMasters");
                //var mimeType = MimeTypeMap.GetMimeType("xlsx");
                //FileContentResult file = File(byteContent, mimeType, StrFimeName);
                //return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));                

            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
           
        }

        #endregion >>>>>>>>>>> Excel Download <<<<<<<<<<<<<<

        #region >>>>>>>>>>> Excel Import <<<<<<<<<<<<<<

        [HttpGet]
        public IActionResult EmployeeImport()
        {
            return PartialView("_EmployeeMasterImportPartial");
        }

        public IActionResult EmployeeXLTemplate()
        {
            //var leaveTypes = await _selectTcmPLRepository.LeaveTypeListAsync(BaseSpTcmPLGet(), null);

            var dictionaryItems = new List<Library.Excel.Template.Models.DictionaryItem>();

            //foreach (var item in leaveTypes)
            //{
            //    dictionaryItems.Add(new DictionaryItem { FieldName = "LeaveType", Value = item.DataValueField });
            //}

            Stream ms = _excelTemplate.ExportEmployeeMaster("v01",
                    new Library.Excel.Template.Models.DictionaryCollection
                    {
                        DictionaryItems = dictionaryItems
                    },
                500);
            var fileName = "ImportEmployeeMaster.xlsx";
            var mimeType = MimeTypeMap.GetMimeType("xlsx");

            ms.Position = 0;
            return File(ms, mimeType, fileName);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> EmployeesXLUpload(IFormFile file)
        {
            try
            {
                if (file == null || file.Length == 0)
                    return Json(new { success = false, response = "File not uploaded due to an error" });

                FileInfo fileInfo = new FileInfo(file.FileName);

                Guid storageId = Guid.NewGuid();
                var stream = file.OpenReadStream();
                var fileName = file.FileName;
                var fileSize = file.Length;
                var mimeType = MimeTypeMap.GetMimeType(fileInfo.Extension);

                // Check file validation
                if (!fileInfo.Extension.Contains("xls"))
                    return Json(new { success = false, response = "Excel file not recognized" });

                // Try to convert stream to a class

                string json = string.Empty;

                // Call database json stored procedure

                List<Library.Excel.Template.Models.Employee> employees = _excelTemplate.ImportEmployeeMaster(stream);

                string[] aryEmployees = employees.Select(p =>
                                                            p.Empno + "~!~" +
                                                            //p.Name + "~!~" +         // this need to remove and add First, Middle and Last name
                                                            p.FirstName + "~!~" +
                                                            p.MiddleName + "~!~" +
                                                            p.LastName + "~!~" +
                                                            p.Emptype + "~!~" +
                                                            p.Gender + "~!~" +
                                                            p.Category + "~!~" +
                                                            p.Grade + "~!~" +
                                                            p.Designation + "~!~" +
                                                            p.DOB?.ToString("yyyyMMdd") + "~!~" +
                                                            p.DOJ?.ToString("yyyyMMdd") + "~!~" +
                                                            p.ContractEndDate?.ToString("yyyyMMdd") + "~!~" +
                                                            p.Parent + "~!~" +
                                                            p.Assigned + "~!~" +
                                                            p.Office + "~!~" +
                                                            p.SubcontractAgency + "~!~" +
                                                            p.Location + "~!~" +
                                                            p.Place).ToArray();

                var uploadOutPut = await _employeeImportRepository.ImportEmployeesAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PEmployees = aryEmployees
                        }
                    );

                List<ImportFileResultViewModel> importFileResults = new List<ImportFileResultViewModel>();

                if (uploadOutPut.PEmployeesErrors?.Length > 0)
                {
                    foreach (string err in uploadOutPut.PEmployeesErrors)
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

        #endregion >>>>>>>>>>> Excel Import <<<<<<<<<<<<<<

        
    }
}