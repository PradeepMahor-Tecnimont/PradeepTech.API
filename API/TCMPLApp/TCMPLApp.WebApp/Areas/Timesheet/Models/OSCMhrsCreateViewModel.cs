using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class OSCMhrsCreateViewModel
    {
        [Required]
        [Display(Name = "Period")]
        public string Yymm { get; set; }

        [Display(Name = "Period")]
        public string YymmWords { get; set; }

        [Display(Name = "Parent")]
        public string Parent { get; set; }

        [Required]
        [Display(Name = "Assign")]
        public string Assign { get; set; }

        [Required]
        [Display(Name = "OSC No")]
        public string Empno { get; set; }

        [Required]
        [Display(Name = "Project")]
        public string Projno { get; set; }

        [Required]
        [Display(Name = "WP code")]
        public string Wpcode { get; set; }

        [Required]
        [Display(Name = "Activity")]
        public string Activity { get; set; }

        [Required]
        [Display(Name = "Hours")]        
        [Range(-999999.5, 999999.5, ErrorMessage = "Hours must be between -999999.5 and 999999.5 inclusive")]
        public decimal? Hours { get; set; }
    }
}
