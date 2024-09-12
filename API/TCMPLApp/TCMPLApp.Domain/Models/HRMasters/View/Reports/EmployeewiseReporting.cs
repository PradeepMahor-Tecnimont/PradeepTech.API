using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class EmployeewiseReporting
    {

        [Display(Name = "Employee no")]
        public string Empno { get; set; }

        [Display(Name = "Employee name")]
        public string Name { get; set; }

        [Display(Name = "Parent")]
        public string Parent { get; set; }

        [Display(Name = "Manager")]
        public string Manager { get; set; }

        [Display(Name = "Manager name")]
        public string ManagerName { get; set; }

        [Display(Name = "HoD")]
        public string HoD { get; set; }

        [Display(Name = "HoD name")]
        public string HoDName { get; set; }

        [Display(Name = "secretary")]
        public string Secretary { get; set; }

        [Display(Name = "secretary name")]
        public string SecretaryName { get; set; }
        
    }
}
