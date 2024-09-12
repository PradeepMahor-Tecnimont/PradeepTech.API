using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class JobEditViewModel
    {
        [Required]
        [Display(Name = "Project no.")]
        public string Projno { get; set; }

        [Display(Name = "Maire Group/ TCM Job Number")]
        public string Tcmno { get; set; }
    }
}
