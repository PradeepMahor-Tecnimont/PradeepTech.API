using System.Collections;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class SmartAttendancePlanningCreateViewModel
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

        [Display(Name = "Project no")]
        public string Projno { get; set; }

        [Display(Name = "Status")]
        public string Status { get; set; }

        [Display(Name = "Attendance date")]
        public string AtndDate { get; set; }

        [Display(Name = "Desk")]
        public string Deskid { get; set; }

        [Display(Name = "Assign workspace id")]
        public string FkSwpAssignworkspace { get; set; }

        [Display(Name = "Employee type")]
        public string Emptype { get; set; }

        [Display(Name = "Parent")]
        public string Parent { get; set; }

        [Display(Name = "Assign")]
        public string Assign { get; set; }

        [Display(Name = "Monday")]
        public bool ChkMonday { get; set; }

        [Display(Name = "Tuesday")]
        public bool ChkTuesday { get; set; }

        [Display(Name = "Wednesday")]
        public bool ChkWednesday { get; set; }

        [Display(Name = "Thursday")]
        public bool ChkThursday { get; set; }

        [Display(Name = "Friday")]
        public bool ChkFriday { get; set; }

        [Display(Name = "Monday")]
        public string MondayDate { get; set; }

        [Display(Name = "Tuesday")]
        public string TuesdayDate { get; set; }

        [Display(Name = "Wednesday")]
        public string WednesdayDate { get; set; }

        [Display(Name = "Thursday")]
        public string ThursdayDate { get; set; }

        [Display(Name = "Friday")]
        public string FridayDate { get; set; }

        public string ParentDesc { get; set; }
        public string AssignDesc { get; set; }

        [Display(Name = "Employee work area")]
        public string EmpWorkArea { get; set; }

        [Display(Name = "")]
        public string DeskMon { get; set; }

        [Display(Name = "")]
        public string DeskTue { get; set; }

        [Display(Name = "")]
        public string DeskWed { get; set; }

        [Display(Name = "")]
        public string DeskThu { get; set; }

        [Display(Name = "")]
        public string DeskFri { get; set; }

        public IList WeekDays { get; set; }
    }
}