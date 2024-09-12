using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;


namespace TCMPLApp.WebApp.Models
{
    public class ManhoursProjectionsExpectedJobsProjectModel
    {
        [Required]
        public string Costcode { get; set; }

        [Required]
        [Display(Name = "Project")]
        public string Projno { get; set; }
    }
}
