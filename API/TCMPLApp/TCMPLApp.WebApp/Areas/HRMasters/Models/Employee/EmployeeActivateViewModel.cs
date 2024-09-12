using System;
using System.ComponentModel.DataAnnotations;


namespace TCMPLApp.WebApp.Areas.HRMasters.Models
{
    public class EmployeeActivateViewModel
    {
        [StringLength(5)]
        [Display(Name = "Employee no")]
        public string Empno { get; set; }

        [Display(Name = "Date of leaving")]
        [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:dd-MMM-yyyy}")]
        public DateTime? Dol { get; set; }

        [StringLength(100)]
        [Display(Name = "Leaving Reason")]
        public string ReasonDesc { get; set; }

        [StringLength(200)]
        [Display(Name = "Remarks")]
        public string Remarks { get; set; }
    }
}
