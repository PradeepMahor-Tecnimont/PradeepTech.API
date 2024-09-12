using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using TCMPLApp.WebApp.Models;
using TCMPLApp.DataAccess.Repositories.SWPVaccine;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc.Rendering;
using TCMPLApp.Domain.Models.SWPVaccine;
using TCMPLApp.DataAccess.Repositories.Common;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.Attendance;
using TCMPLApp.WebApp.Classes;
using static TCMPLApp.WebApp.Classes.DTModel;

namespace TCMPLApp.WebApp.Controllers
{
    public class EmployeeDetailsController : BaseController
    {
        private readonly IEmployeeDetailsRepository _employeeDetailsRepository;
        private readonly ISelectTcmPLRepository _selectTcmPLRepository;

        private readonly ISelectTcmPLPagingRepository _selectTcmPLPagingRepository ;
        private readonly ICommonEmployeeDetailsRepository _commonEmployeeDetailsRepository;

        public EmployeeDetailsController(IEmployeeDetailsRepository employeeDetailsRepository,
                                        ICommonEmployeeDetailsRepository commonEmployeeDetailsRepository,
                                        ISelectTcmPLRepository selectTcmPLRepository,
                                        ISelectTcmPLPagingRepository selectTcmPLPagingRepository
                                        )
        {
            _employeeDetailsRepository = employeeDetailsRepository;
            _selectTcmPLRepository = selectTcmPLRepository;
            _selectTcmPLPagingRepository = selectTcmPLPagingRepository;
            _commonEmployeeDetailsRepository = commonEmployeeDetailsRepository;
        }

        public IActionResult Index()
        {
            //var empList = _employeeDetailsRepository.GetEmployeeSelectAsync().ToList();

            //empList.Insert(0, new Domain.Models.DdlModel { Text = "", Val = "" });

            //ViewData["Empno"] = new SelectList(empList, "Val", "Text", null);

            return View();
        }



        [HttpGet]
        public async Task<IActionResult> GetAllActiveEmployeeList(string search, int page)
        {
            Select2ResultList<DataFieldPaging> select2ResultList = new Select2ResultList<DataFieldPaging>();

            //DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            var data = await _selectTcmPLPagingRepository.ActiveEmployeeListAsync(BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PGenericSearch = search,
                    PRowNumber = (page-1)*250,
                    PPageLength = 250
                }
                );
            select2ResultList.items = data.ToList();
            if (data.Count() > 0)
                select2ResultList.totalCount = data.FirstOrDefault().TotalRow ?? 0;
            else
                select2ResultList.totalCount = 0;

            return Json(select2ResultList);

        }

        public async Task<IActionResult> EmployeeWorkspaceDetails()
        {
            var employeeList = await _selectTcmPLRepository.EmpListForWorkspaceDetailsAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            ViewData["Empno"] = new SelectList(employeeList, "DataValueField", "DataTextField", CurrentUserIdentity.EmpNo);

            return View();
        }

        [HttpGet]
        public async Task<IActionResult> GetEmployeeDetails(string empno)
        {
            Domain.Models.Common.EmployeeDetails employeeDetails = new();

            if (!string.IsNullOrEmpty(empno))
            {
                employeeDetails = await _commonEmployeeDetailsRepository.EmployeeDetailAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL { PEmpno = empno });
            }

            //EmployeeDetails employeeDetails = null;

            //if (!string.IsNullOrEmpty(empno))
            //{
            //    employeeDetails = await _employeeDetailsRepository.GetEmployeeDetailsAsync(empno);
            //}
            return PartialView("_EmployeeDetailsPartial", employeeDetails);
        }

        public IActionResult ChangePassword()
        {
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ChangePassword(ChangePasswordViewModel changePasswordViewModel)
        {
            var retVal = await _employeeDetailsRepository.ChangeTimesheetPasswordAsync(
                new ChangePassword
                {
                    ParamEmpno = CurrentUserIdentity.EmpNo,
                    ParamNewPwd1 = changePasswordViewModel.NewPassword,
                    ParamNewPwd2 = changePasswordViewModel.ConfirmPassword
                });
            string sTitle = retVal.OutParamSuccess == "OK" ? "Success" : "Error";

            Notify(sTitle, retVal.OutParamMessage, "", retVal.OutParamSuccess == "OK" ? NotificationType.success : NotificationType.error);

            return View("ChangePassword");
        }
    }
}