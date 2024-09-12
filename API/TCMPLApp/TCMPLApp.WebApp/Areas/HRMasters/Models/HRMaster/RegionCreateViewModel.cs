using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class RegionCreateViewModel
    {
        
        [Display(Name = "Region Code")]
        public string RegionCode { get; set; }

        [Required]
        [Display(Name = "Region Name")]
        public string RegionName { get; set; }
    }
}
