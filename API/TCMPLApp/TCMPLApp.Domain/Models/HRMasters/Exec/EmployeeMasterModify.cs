using System;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class EmployeeMasterModify
    {
        [Required]
        [Display(Name = "Employee no")]
        public string Empno { get; set; }

        [Display(Name = "Employee name")]
        public string Name { get; set; }

        [Display(Name = "Abbrivation")]
        public string Abbr { get; set; }

        [Display(Name = "Employee type")]
        public string Emptype { get; set; }

        [Display(Name = "Email")]
        public string Email { get; set; }

        [Display(Name = "Assign costcode")]
        public string Assign { get; set; }

        [Display(Name = "Parent costcode")]
        public string Parent { get; set; }
    }

    public class employeeMasterModifyOutput : BaseResponse
    {

    }
}
