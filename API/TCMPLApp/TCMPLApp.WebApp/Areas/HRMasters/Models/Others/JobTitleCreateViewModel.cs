using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Areas.HRMasters.Models
{
    public class JobTitleCreateViewModel
    {
        [Required]
        [Display(Name = "Job title code")]
        public string JobtitleCode { get; set; }

        [Required]
        [Display(Name = "Job title")]
        public string Jobtitle { get; set; }
    }
}
