using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Areas.HRMasters.Models
{
    public class GradeCreateViewModel
    {
        [Required]
        [StringLength(2)]
        [Display(Name = "Grade")]
        public string Gradeid { get; set; }
        
        [StringLength(50)]
        [Display(Name = "Description")]
        public string Gradedesc { get; set; }
    }
}
