using System;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class EmployeeMasterApplications
    {        
        [Display(Name = "Employee no")]
        public string Empno { get; set; }

        public string Name { get; set; }


        [Display(Name = "Expatriate")]
        public Int32? Expatriate { get; set; }

        
        [Display(Name = "HR user")]
        public Int32? HrOpr { get; set; }

        
        [Display(Name = "Invoicing user")]
        public Int32? InvAuth { get; set; }

        
        [Display(Name = "Job sponsor")]
        public Int32? JobIncharge { get; set; }

        
        [Display(Name = "New employee")]
        public Int32? Newemp { get; set; }

        
        [Display(Name = "Payroll active")]
        public Int32? Payroll { get; set; }

        
        [Display(Name = "PROCO user")]
        public Int32? ProcOpr { get; set; }

        
        [Display(Name = "Desk required")]
        public Int32? Seatreq { get; set; }

        
        [Display(Name = "Timesheet required")]
        public Int32? Submit { get; set; }

        public Int32? Status { get; set; }
        public string IsEditable { get; set; }
    }
}
