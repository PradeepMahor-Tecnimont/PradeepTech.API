using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.Attendance;
using TCMPLApp.DataAccess.Repositories.Common;
using TCMPLApp.DataAccess.Repositories.SWP;
using TCMPLApp.DataAccess.Repositories.SWPVaccine;
using TCMPLApp.Domain.Models;
using TCMPLApp.Domain.Models.SWP;
using TCMPLApp.WebApp.Models;

namespace TCMPLApp.WebApp.ViewComponents
{
    [ViewComponent(Name = "SWPEmployeeWorkspaceDetails")]
    public class SWPEmployeeWorkspaceDetailsViewComponent : ViewComponent
    {
        private IEmployeePolicyRepository _employeePolicyRepository;
        private readonly IAttendanceEmployeeDetailsRepository _attendanceEmployeeDetailsRepository;
        private readonly ISWPPlanningStatusRepository _swpPlanningStatusRepository;
        private readonly ISWPEmployeeWorkspaceRepository _swpEmployeeWorkspaceRepository;
        private readonly ISWPSmartWorkSpaceDataTableListRepository _smartWorkSpaceDataTableListRepository;
        private readonly ISWPFlagsGenericRepository _swpFlagsGenericRepository;

        private readonly string ConstFlagIdForShowPlanningToEmp = "F004";

        private readonly ICommonEmployeeDetailsRepository _commonEmployeeDetailsRepository;

        public SWPEmployeeWorkspaceDetailsViewComponent(IEmployeePolicyRepository employeePolicyRepository,
            IAttendanceEmployeeDetailsRepository attendanceEmployeeDetailsRepository,
             ISWPPlanningStatusRepository swpPlanningStatusRepository,
             ISWPEmployeeWorkspaceRepository swpEmployeeWorkspaceRepository,
             ISWPSmartWorkSpaceDataTableListRepository swpSmartWorkSpaceDataTableListRepository,
             ISWPFlagsGenericRepository swpFlagsGenericRepository,
             ICommonEmployeeDetailsRepository commonEmployeeDetailsRepository

            )
        {
            _employeePolicyRepository = employeePolicyRepository;
            _attendanceEmployeeDetailsRepository = attendanceEmployeeDetailsRepository;
            _swpPlanningStatusRepository = swpPlanningStatusRepository;
            _swpEmployeeWorkspaceRepository = swpEmployeeWorkspaceRepository;
            _smartWorkSpaceDataTableListRepository = swpSmartWorkSpaceDataTableListRepository;
            _swpFlagsGenericRepository = swpFlagsGenericRepository;
            _commonEmployeeDetailsRepository = commonEmployeeDetailsRepository;
        }

        public async Task<IViewComponentResult> InvokeAsync(string Empno, BaseSpTcmPL baseSpTcmPL, UserIdentity userIdentity)
        {
            var empWorkspaceDetails = await GetWorkDetails(Empno, baseSpTcmPL, userIdentity);
            return View(empWorkspaceDetails);
        }

        public async Task<EmployeeSWPWorkStatusViewModel> GetWorkDetails(string Empno, BaseSpTcmPL baseSpTcmPL, UserIdentity userIdentity)
        {
            EmployeeSWPWorkStatusViewModel model = new EmployeeSWPWorkStatusViewModel();

            var commonEmpdetails = await _commonEmployeeDetailsRepository.EmployeeDetailAsync(baseSpTcmPL, new ParameterSpTcmPL());

            var empdetails = await _attendanceEmployeeDetailsRepository.AttendanceEmployeeDetailsAsync(baseSpTcmPL,
                  new ParameterSpTcmPL
                  {
                      PEmpno = Empno
                  }
              );

            var swpWeekPlanningStatus = await _swpPlanningStatusRepository.GetPlanningWeekDetails(baseSpTcmPL, null);

            var flagDetails = await _swpFlagsGenericRepository.SWPFlagDetails(baseSpTcmPL,
                new ParameterSpTcmPL
                {
                    PFlagId = ConstFlagIdForShowPlanningToEmp
                });

            var empPWSDetails = await _swpEmployeeWorkspaceRepository.GetEmployeePrimaryWorkspace(baseSpTcmPL,
                 new ParameterSpTcmPL
                 {
                     PEmpno = Empno
                 });

            IEnumerable<SmartWorkSpaceDataTableList> planSws = null, currSws = null;

            if (empPWSDetails.PCurrentPws == 2)
            {
                currSws = await _smartWorkSpaceDataTableListRepository.SmartWorkSpaceEmpDataTableList(baseSpTcmPL,
                    new ParameterSpTcmPL
                    {
                        PEmpno = Empno,
                        PDate = swpWeekPlanningStatus.PCurrStartDate
                    }
                    );
            }

            if (empPWSDetails.PPlanningPws.GetValueOrDefault() == 2)
            {
                planSws = await _smartWorkSpaceDataTableListRepository.SmartWorkSpaceEmpDataTableList(baseSpTcmPL,
                    new ParameterSpTcmPL
                    {
                        PEmpno = Empno,
                        PDate = swpWeekPlanningStatus.PPlanStartDate
                    }
                    );
            }

            if (swpWeekPlanningStatus.PPlanningExists == "OK" && swpWeekPlanningStatus.PSwsOpen == "KO" & flagDetails.PFlagValue == "OK")
            {
                model.IsShowPlanning = true;
            }
            else
            {
                model.IsShowPlanning = false;
            }

            model.Empno = empdetails.Empno;
            model.EmployeeName = empdetails.Name;
            model.EmpGrade = empdetails.EmpGrade;
            model.Parent = empdetails.ParentCode;
            model.Assign = empdetails.AssignCode;
            model.Emptype = empdetails.Emptype;
            model.Projno = empdetails.Projno;
            model.ParentDesc = empdetails.ParentDesc;
            model.AssignDesc = empdetails.AssignDesc;
            model.EmpWorkArea = empdetails.WorkArea;

            model.WeekStartDate = swpWeekPlanningStatus.PCurrStartDate;
            model.WeekEndDate = swpWeekPlanningStatus.PCurrEndDate;

            model.PlanningWeekStartDate = swpWeekPlanningStatus.PPlanStartDate;
            model.PlanningWeekEndDate = swpWeekPlanningStatus.PPlanEndDate;

            model.CurrentWorkspaceText = empPWSDetails.PCurrentPwsText;
            model.PlanningWorkspaceText = empPWSDetails.PPlanningPwsText;
            model.CurrentWorkspaceVal = ((int)empPWSDetails.PCurrentPws);
            model.PlanningWorkspaceVal = ((int)empPWSDetails.PPlanningPws.GetValueOrDefault());

            model.CurrentOfficeLocation = commonEmpdetails.PCurrentOfficeLocation;

            model.CurrentDesk = empPWSDetails.PCurrDeskId;
            model.CurrentOffice = empPWSDetails.PCurrOffice;
            model.CurrentFloor = empPWSDetails.PCurrFloor;
            model.CurrentWing = empPWSDetails.PCurrWing;

            model.PlanningDesk = empPWSDetails.PPlanDeskId;
            model.PlanningOffice = empPWSDetails.PPlanOffice;
            model.PlanningFloor = empPWSDetails.PPlanFloor;
            model.PlanningWing = empPWSDetails.PPlanWing;

            if (!(currSws == null))
            {
                var json = JsonConvert.SerializeObject(currSws);

                IEnumerable<EmployeeWorkSpaceDataTableList> currSwsData = JsonConvert.DeserializeObject<IEnumerable<EmployeeWorkSpaceDataTableList>>(json);
                model.CurrentWeekDataTableList = currSwsData;
            }
            if (!(planSws == null))
            {
                var json = JsonConvert.SerializeObject(planSws);

                IEnumerable<EmployeeWorkSpaceDataTableList> planSwsData = JsonConvert.DeserializeObject<IEnumerable<EmployeeWorkSpaceDataTableList>>(json);
                model.PlanningWeekDataTableList = planSwsData;
            }

            return model;
        }
    }
}