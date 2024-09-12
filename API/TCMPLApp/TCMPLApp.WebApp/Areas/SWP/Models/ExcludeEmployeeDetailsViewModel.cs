using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.SWP;

namespace TCMPLApp.WebApp.Models
{
    public class ExcludeEmployeeDetailsViewModel
    {
        [Display(Name = "Id")]
        public string keyid { get; set; }

        [Display(Name = "Empno")]
        public string Empno { get; set; }

        [Display(Name = "Employee name")]
        public string EmployeeName { get; set; }

        [Display(Name = "Start date")]
        public string StartDate { get; set; }

        [Display(Name = "End date")]
        public string EndDate { get; set; }

        [Display(Name = "Reason")]
        public string Reason { get; set; }

        [Display(Name = "Is active")]
        public decimal IsActive { get; set; }

        [Display(Name = "Modified date")]
        public string ModifiedOn { get; set; }

        [Display(Name = "Modified by")]
        public string ModifiedBy { get; set; }
    }
}