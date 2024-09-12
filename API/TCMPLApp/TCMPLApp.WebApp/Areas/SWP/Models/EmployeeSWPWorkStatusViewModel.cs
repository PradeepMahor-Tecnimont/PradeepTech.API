using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.SWP;

namespace TCMPLApp.WebApp.Models
{
    public class EmployeeSWPWorkStatusViewModel
    {
        [Required]
        [Display(Name = "Empno")]
        public string Empno { get; set; }

        [Display(Name = "Employee name")]
        public string EmployeeName { get; set; }

        [Display(Name = "Grade")]
        public string EmpGrade { get; set; }

        [Display(Name = "Project no")]
        public string Projno { get; set; }

        [Display(Name = "Attendance date")]
        public string AtndDate { get; set; }

        [Display(Name = "Desk")]
        public string Deskid { get; set; }

        [Display(Name = "Current workspace")]
        public string CurrentWorkspaceText { get; set; }

        public int? CurrentWorkspaceVal { get; set; }

        [Display(Name = "Planning workspace")]
        public string PlanningWorkspaceText { get; set; }

        public int? PlanningWorkspaceVal { get; set; }

        [Display(Name = "Employee type")]
        public string Emptype { get; set; }

        [Display(Name = "Current Office Location")]
        public string CurrentOfficeLocation { get; set; }

        [Display(Name = "Parent")]
        public string Parent { get; set; }

        [Display(Name = "Assign")]
        public string Assign { get; set; }

        public string ParentDesc { get; set; }
        public string AssignDesc { get; set; }

        [Display(Name = "Employee work area")]
        public string EmpWorkArea { get; set; }

        public bool IsShowPlanning { get; set; }

        public OfficeWorkSpaceData OfficeWorkSpaceData { get; set; }

        public string CurrentOffice { get; set; }
        public string CurrentFloor { get; set; }
        public string CurrentWing { get; set; }
        public string CurrentDesk { get; set; }

        public string PlanningOffice { get; set; }
        public string PlanningFloor { get; set; }
        public string PlanningWing { get; set; }
        public string PlanningDesk { get; set; }

        //public IEnumerable<SmartWorkSpaceDataTableList> CurrentWeekDataTableList { get; set; }
        public IEnumerable<EmployeeWorkSpaceDataTableList> CurrentWeekDataTableList { get; set; }

        public IEnumerable<EmployeeWorkSpaceDataTableList> PlanningWeekDataTableList { get; set; }

        public DateTime WeekStartDate { get; set; }
        public DateTime WeekEndDate { get; set; }
        public DateTime? PlanningWeekStartDate { get; set; }
        public DateTime? PlanningWeekEndDate { get; set; }

        public IList WeekDays { get; set; }
    }

    public class OfficeWorkSpaceData
    {
        public string Office { get; set; }
        public string Floor { get; set; }
        public string Wing { get; set; }
        public string Desk { get; set; }
    }
}