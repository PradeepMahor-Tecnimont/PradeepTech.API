using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class CategorywiseEmployee
    {

        [Display(Name = "Category")]
        public string Category { get; set; }               

        [Display(Name = "Employee nos")]
        public int? Nos { get; set; }

    }
}
