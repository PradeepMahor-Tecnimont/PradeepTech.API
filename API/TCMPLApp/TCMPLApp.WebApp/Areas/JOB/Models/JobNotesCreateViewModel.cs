using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class JobNotesCreateViewModel
    {
        [Required]
        [Display(Name = "Project no.")]
        public string Projno { get; set; }

        [Required]
        [Display(Name = "Description (Type of work, Purpose of work etc.)")]
        [MaxLength(255)]
        public string Description { get; set; }

        [Required]
        [Display(Name = "Notes & reasons for modifications")]
        [MaxLength(455)]
        public string Notes { get; set; }

    }
}
