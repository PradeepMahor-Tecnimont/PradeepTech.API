using System.Collections;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class WorkAreaCreateViewModel
    {
        [Display(Name = "Id")]
        public string keyid { get; set; }

        [Required]
        [Display(Name = "Empno")]
        public string Empno { get; set; }

        [Display(Name = "Employee name")]
        public string EmployeeName { get; set; }

        [Display(Name = "Grade")]
        public string EmpGrade { get; set; }

        [Display(Name = "Desk")]
        public string Deskid { get; set; }

        [Display(Name = "Assign workspace id")]
        public string FkSwpAssignworkspace { get; set; }

        [Display(Name = "Employee type")]
        public string Emptype { get; set; }

        [Display(Name = "Employee work area")]
        public string EmpWorkArea { get; set; }

        [Display(Name = "Parent")]
        public string Parent { get; set; }

        [Display(Name = "Assign")]
        public string Assign { get; set; }

        [Display(Name = "Date")]
        public string StartDate { get; set; }

        public string ParentDesc { get; set; }
        public string AssignDesc { get; set; }

        public IList WeekDays { get; set; }
        public string Office { get; set; }
        public string Floor { get; set; }
        public string Wing { get; set; }
        public string WorkArea { get; set; }
        public string AreaCategory { get; set; }
        public string WorkAreaDesc { get; set; }
        public string AreaType { get; set; }

        public bool ShowRestrictedDesksInSWSPlanning { get; set; }
        public bool ShowOpenDesksInSWSPlanning { get; set; }
    }
}