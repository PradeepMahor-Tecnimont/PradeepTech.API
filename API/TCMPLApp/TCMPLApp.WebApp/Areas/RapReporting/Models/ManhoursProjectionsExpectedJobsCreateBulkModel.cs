using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.WebApp.Models;

namespace TCMPLApp.WebApp.Models
{    
    public class ManhoursProjectionsExpectedJobsCreateBulkModel
    {
        [Required]
        [Display(Name = "Cost code")]
        public string Costcode { get; set; }

        [Required]
        [Display(Name = "Project no")]
        public string Projno { get; set; }

        [Required]
        [Display(Name = "Add no. of months")]
        [Range(1, 200)]
        public int Months { get; set; }

        [Required]
        [Range(0, 9999999999.99)]
        public decimal Hours { get; set; }
    }
}