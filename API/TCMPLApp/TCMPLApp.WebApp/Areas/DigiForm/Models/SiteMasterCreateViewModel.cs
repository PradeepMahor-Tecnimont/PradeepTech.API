using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class SiteMasterCreateViewModel
    {
        [Required]
        [Display(Name = "Site Name")]
        public string SiteName { get; set; }

        [Required]
        [Display(Name = "Site Location")]
        public string SiteLocation { get; set; }

        [Required]
        [Display(Name = "Is Active")]
        public decimal IsActive { get; set; }
    }
}
