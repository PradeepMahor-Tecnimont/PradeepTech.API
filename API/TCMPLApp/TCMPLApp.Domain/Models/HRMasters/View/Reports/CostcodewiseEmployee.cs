using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class CostcodewiseEmployee
    {

        [Display(Name = "Costcode")]
        public string Costcode { get; set; }

        [Display(Name = "Name")]
        public string Name { get; set; }

        [Display(Name = "Employee nos")]
        public int? Nos { get; set; }

    }
}
