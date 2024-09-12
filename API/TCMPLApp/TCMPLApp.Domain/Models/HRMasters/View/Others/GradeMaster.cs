using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class GradeMaster
    {
        [Required]
        [Display(Name = "Grade")]
        public string Gradeid { get; set; }

        [Display(Name = "Description")]
        public string Gradedesc { get; set; }

        public int? Emps { get; set; }
    }
}
