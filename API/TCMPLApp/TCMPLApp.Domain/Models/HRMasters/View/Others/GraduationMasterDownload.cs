using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class GraduationMasterDownload
    {
        [Required]
        [Display(Name = "Graduation")]
        public string Graduation { get; set; }

        [Display(Name = "Description")]
        public string GraduationDesc { get; set; }
    }
}
