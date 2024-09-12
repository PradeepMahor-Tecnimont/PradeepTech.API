using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class ActivityCreateViewModel
    {
        [Required]
        [Display(Name = "Costcode")]
        public string Costcode { get; set; }

        [Required]
        [Display(Name = "Activity")]
        public string Activity { get; set; }

        [Required]
        [Display(Name = "Activity Name")]
        public string Name { get; set; }

        [Required]
        [Display(Name = "TLP code")]
        public string Tlpcode { get; set; }

        [Display(Name = "Activity type")]
        public string ActivityType { get; set; }

        [Display(Name = "Active")]
        public decimal? Active { get; set; }

    }
}
