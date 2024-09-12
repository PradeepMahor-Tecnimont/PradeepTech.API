using System;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Areas.HRMasters.Models
{
    public class EmployeeMasterApplicationsEditViewModel
    {
        [Required]
        [StringLength(5)]
        [Display(Name = "Employee no")]
        public string Empno { get; set; }        

        [DefaultValue(0)]
        [Display(Name = "Expatriate")]
        public Int32? Expatriate { get; set; }

        [DefaultValue(0)]
        [Display(Name = "HR user")]
        public Int32? HrOpr { get; set; }

        [DefaultValue(0)]
        [Display(Name = "Invoicing user")]
        public Int32? InvAuth { get; set; }

        [DefaultValue(0)]
        [Display(Name = "Job sponsor")]
        public Int32? JobIncharge { get; set; }

        [DefaultValue(1)]
        [Display(Name = "New employee")]
        public Int32? Newemp { get; set; }

        [DefaultValue(0)]
        [Display(Name = "Payroll active")]
        public Int32? Payroll { get; set; }

        [DefaultValue(0)]
        [Display(Name = "PROCO user")]
        public Int32? ProcOpr { get; set; }

        [DefaultValue(1)]
        [Display(Name = "Desk required")]
        public Int32? Seatreq { get; set; }

        [DefaultValue(0)]
        [Display(Name = "Timesheet required")]
        public Int32? Submit { get; set; }
    }
}
