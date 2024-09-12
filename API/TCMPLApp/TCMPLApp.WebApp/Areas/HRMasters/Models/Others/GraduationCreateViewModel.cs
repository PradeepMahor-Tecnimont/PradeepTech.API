using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Areas.HRMasters.Models
{
    public class GraduationCreateViewModel
    {
        public string Graduationid { get; set; }

        [Required]
        [StringLength(15)]
        [Display(Name = "Graduation")]
        public string Graduationdesc { get; set; }
    }
}
