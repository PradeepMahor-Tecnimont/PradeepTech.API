using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class EmployeeResignedCostcode
    {
       
        [Display(Name = "Parent")]
        public string Parent { get; set; }

        [Display(Name = "Costcode")]
        public string Costcode { get; set; }

        [Display(Name = "Count")]
        public int? Cnt { get; set; }

       
        
    }
}
