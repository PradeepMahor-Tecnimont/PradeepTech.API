using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class JobEditPmJsViewModel
    {
        [Required]
        [Display(Name = "Project no.")]
        public string Projno { get; set; }

        public string RoleName { get; set; }

        [Display(Name = "ERP project manager")]
        [MaxLength(5)]
        public string PmEmpno { get; set; }

        [Display(Name = "Job sponsor")]
        [MaxLength(5)]
        public string JsEmpno { get; set; }
    }
}
