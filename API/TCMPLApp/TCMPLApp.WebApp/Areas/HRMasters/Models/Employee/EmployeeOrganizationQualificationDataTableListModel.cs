using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;


namespace TCMPLApp.WebApp.Areas.HRMasters.Models
{
    public class EmployeeOrganizationQualificationDataTableListModel
    {        
        [Display(Name = "Employee no")]
        public string Empno { get; set; }

        [Display(Name = "Qualification")]
        public string QualificationId { get; set; }

        [Display(Name = "Qualification")]
        public string Qualification { get; set; }
    }
}
