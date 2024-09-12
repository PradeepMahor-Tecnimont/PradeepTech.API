using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class JobCloseInitiateViewModel
    {
        [Required]
        [Display(Name = "Project no.")]
        public string Projno { get; set; }

        [Required]
        [Display(Name = "Actual closing date")]
        public DateTime? ActualClosingDate { get; set; }

        [Required]
        [Display(Name = "Notes & reasons for modifications")]
        [MaxLength(455)]
        public string Notes { get; set; }
                
        public string Warning { get; set; }
                
        public string IsConsent { get; set; }

    }
}
