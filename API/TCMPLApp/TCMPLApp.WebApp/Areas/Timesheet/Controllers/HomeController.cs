using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Net;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.Common;
using TCMPLApp.WebApp.Classes;
using TCMPLApp.WebApp.Controllers;
using TCMPLApp.WebApp.Models;
using TCMPLApp.Domain.Models.Timesheet;
using System.Linq;
using TCMPLApp.DataAccess.Repositories.Timesheet;

namespace TCMPLApp.WebApp.Areas.Timesheet.Controllers
{
    [Area("Timesheet")]
    public class HomeController : BaseController
    {
        private const string ConstFilterTimesheetIndex = "TimesheetCommonIndex";
        private const string ConstControllerName = "Home";
        private const string ConstActionName = "Index";
        private readonly string YearMode = "A"; //April-March
        private readonly ISelectTcmPLRepository _selectTcmPLRepository;
        private readonly IFilterRepository _filterRepository;
        private readonly ICommonEmployeeDetailsRepository _commonEmployeeDetailsRepository;
        private readonly IEmployeeTimesheetDetailsRepository _employeeTimesheetDetailsRepository;

        public HomeController(
            ISelectTcmPLRepository selectTcmPLRepository,
            IFilterRepository filterRepository,
            ICommonEmployeeDetailsRepository commonEmployeeDetailsRepository,
            IEmployeeTimesheetDetailsRepository employeeTimesheetDetailsRepository)
        {
            _selectTcmPLRepository = selectTcmPLRepository;
            _filterRepository = filterRepository;
            _commonEmployeeDetailsRepository = commonEmployeeDetailsRepository;
            _employeeTimesheetDetailsRepository = employeeTimesheetDetailsRepository;
        }

        public async Task<IActionResult> Index()
        {
            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterTimesheetIndex
            });

            TimesheetViewModel timesheetViewModel = new TimesheetViewModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                timesheetViewModel.FilterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            return View(timesheetViewModel);
        }

        public async Task<IActionResult> FilterGet(string actionName, string controllerName)
        {
            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterTimesheetIndex
            });
            FilterDataModel filterDataModel;
            if (string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = new FilterDataModel();
                filterDataModel.Yyyy = null;
                filterDataModel.Yyyymm = null;
            }
            else
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);


            var years = await _selectTcmPLRepository.SelectYearTimesheet(BaseSpTcmPLGet(), null);
            ViewData["Years"] = new SelectList(years, "DataValueField", "DataTextField", filterDataModel.Yyyy);

            if (!string.IsNullOrEmpty(filterDataModel.Yyyy))
            {
                var yyyymm = await _selectTcmPLRepository.SelectYearMonthTimesheet(BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PYyyy = filterDataModel.Yyyy,
                        PYearmode = YearMode
                    });
                ViewData["Yyyymms"] = new SelectList(yyyymm, "DataValueField", "DataTextField", filterDataModel.Yyyymm);

            }

            filterDataModel.ActionName = actionName == null ? ConstActionName : actionName;
            filterDataModel.ControllerName = controllerName == null ? ConstControllerName : controllerName;

            return PartialView("_ModalConfigurationFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> FilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                string jsonFilter;
                jsonFilter = JsonConvert.SerializeObject(new
                {
                    Yyyy = filterDataModel.Yyyy,
                    Yyyymm = filterDataModel.Yyyymm,
                    User = User.Identity.Name.Substring(User.Identity.Name.IndexOf("\\") + 1)
                });

                var retVal = await _filterRepository.FilterCreateAsync(new Domain.Models.FilterCreate
                {
                    PModuleName = CurrentUserIdentity.CurrentModule,
                    PMetaId = CurrentUserIdentity.MetaId,
                    PPersonId = CurrentUserIdentity.EmployeeId,
                    PMvcActionName = ConstFilterTimesheetIndex,
                    PFilterJson = jsonFilter
                });

                return RedirectToAction(filterDataModel.ActionName, filterDataModel.ControllerName);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        public async Task<IActionResult> GetYearMonthList(string yyyy)
        {

            if (yyyy == null)
            {
                return NotFound();
            }

            var yyyyMMList = await _selectTcmPLRepository.SelectYearMonthTimesheet(BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PYyyy = yyyy,
                    PYearmode = YearMode
                });

            return Json(yyyyMMList);

        }

        public async Task<IActionResult> RedirectPage(string actionName, string controllerName)
        {

            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterTimesheetIndex
            });

            FilterDataModel filterDataModel;
            if (string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                var redirectUrl = new List<SelectListItem> { new SelectListItem { Text = "url", Value = "location.reload();" }
                                                           };
                return Json(redirectUrl);
            }
            else
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

                var redirectUrl = new List<SelectListItem> { new SelectListItem { Text = "url", Value = "location.reload();" } };
                return Json(redirectUrl);
            }
        }

        #region EmployeeTimesheet
        public async Task<IActionResult> EmployeeTimesheet()
        {
            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterTimesheetIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            EmployeeTimesheetDetail employeeTimesheetDetails = new()
            {
                FilterDataModel = filterDataModel
            };

            var empdetails = await _commonEmployeeDetailsRepository.EmployeeDetailAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());


            employeeTimesheetDetails.Empno = empdetails.PForEmpno;
            employeeTimesheetDetails.Name = empdetails.PName;
            employeeTimesheetDetails.DesgCode = empdetails.PDesgCode;
            employeeTimesheetDetails.DesgName = empdetails.PDesgName;
            employeeTimesheetDetails.Parent = empdetails.PParent;
            employeeTimesheetDetails.CostName = empdetails.PCostName;


            IEnumerable<DataField> departmentList = await _selectTcmPLRepository.TimesheetCostcodeList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
                PYymm = filterDataModel.Yyyymm
            });
            if (departmentList.Any())
            {
                ViewData["DepartmentList"] = new SelectList(departmentList, "DataValueField", "DataTextField", departmentList.FirstOrDefault().DataValueField);
            }
            else
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage("Timesheet data is not available for this month"));
            }


            return PartialView("_ModalEmployeeTimesheet", employeeTimesheetDetails);
        }

        [HttpGet]
        public async Task<IActionResult> GetTimesheetData(string costcode, string yymm, string empno)
        {
            var data = await _employeeTimesheetDetailsRepository.TimesheetDetailsAsync(BaseSpTcmPLGet(),
                   new ParameterSpTcmPL
                   {
                       PEmpno = empno,
                       PYymm = yymm,
                       PCostcode = costcode
                   });
            
            return Json(data);
        }
        #endregion EmployeeTimesheet
    }
}
