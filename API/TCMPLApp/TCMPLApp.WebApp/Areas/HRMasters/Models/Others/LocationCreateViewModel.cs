using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Areas.HRMasters.Models
{
    public class LocationCreateViewModel
    {
        [Required]
        [StringLength(1)]
        [Display(Name = "Location")]
        public string Locationid { get; set; }
        
        [StringLength(30)]
        [Display(Name = "Description")]
        public string Location { get; set; }
    }
}
