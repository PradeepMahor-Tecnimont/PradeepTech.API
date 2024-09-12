using System.ComponentModel.DataAnnotations;


namespace TCMPLApp.WebApp.Models
{
    public class PrimaryWorkSpaceEditViewModel
    {
        [Display(Name = "Empno")]
        public string Empno { get; set; }

        [Display(Name = "Employee name")]
        public string EmployeeName { get; set; }

        [Display(Name = "Grade")]
        public string EmpGrade { get; set; }

        [Display(Name = "Work area")]
        public string WorkArea { get; set; }

        [Display(Name = "Employee type")]
        public string Emptype { get; set; }

        [Display(Name = "Email")]
        public string Email { get; set; }

        [Display(Name = "Desk")]
        public string Deskid { get; set; }


        [Display(Name = "Laptop user")]
        public decimal IsLaptopUser { get; set; }

        [Display(Name = "Laptop user")]
        public string IsLaptopUserText { get; set; }

        [Display(Name = "DualMonitor user")]
        public decimal IsDualMonitorUser { get; set; }

        [Display(Name = "DualMonitor user")]
        public string IsDualMonitorUserText
        {
            get { return IsDualMonitorUser == 1 ? "Yes" : "No"; }
        }

        [Display(Name = "Parent")]
        public string Parent { get; set; }

        [Display(Name = "Assign")]
        public string Assign { get; set; }

        [Display(Name = "Workspace")]
        public decimal PrimaryWorkspace { get; set; }

        [Display(Name = "Pending")]
        public string Pending { get; set; }

        [Display(Name = "Eligible for SWP")]
        public string IsSwpEligible { get; set; }

        [Display(Name = "Eligible for SWP")]
        public string IsSwpEligibleDesc { get; set; }

        [Display(Name = "Re-assign workspace")]
        public decimal NewPrimaryWorkspace { get; set; }
    }
}
