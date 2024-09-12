using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class CategoryMaster
    {
        [Required]
        [Display(Name = "Category id")]
        public string Categoryid { get; set; }

        [Display(Name = "Category description")]
        public string Categorydesc { get; set; }

        public int? Emps { get; set; }
    }
}
