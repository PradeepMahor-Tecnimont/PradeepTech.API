using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Areas.HRMasters.Models
{
    public class PlaceCreateViewModel
    {
        public string Placeid { get; set; }

        [Required]
        [StringLength(50)]
        [Display(Name = "Place")]
        public string Placedesc { get; set; }
    }
}
