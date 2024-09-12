using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;


namespace TCMPLApp.Domain.Models.HRMasters
{
    public class EmployeeMasterOrganizationQualificationDataTableList
    {        
        [Display(Name = "Employee no")]
        public string Empno { get; set; }

        [Display(Name = "Qualification")]
        public string QualificationId { get; set; }

        [Display(Name = "Qualification")]
        public string Qualification { get; set; }
    }
}
