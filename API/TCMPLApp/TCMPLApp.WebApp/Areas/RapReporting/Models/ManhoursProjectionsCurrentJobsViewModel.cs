using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.WebApp.Models;

namespace TCMPLApp.WebApp.Models
{    
    public class ManhoursProjectionsCurrentJobsViewModel
    {
        [Required]
        [Display(Name = "Cost code")]
        public string Costcode { get; set; }

        [Required]
        [Display(Name = "Project no")]
        public string Projno { get; set; }

        [Required]
        public string Yymm { get; set; }

        [Required]
        [Range(0, 9999999999.99)]
        public decimal Hours { get; set; }
    }
}