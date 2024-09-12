using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Areas.HRMasters.Models
{
    public class JobDisciplineCreateViewModel
    {
        [Required]
        [StringLength(8)]
        [Display(Name = "Job discipline code")]
        public string JobdisciplineCode { get; set; }

        [Required]
        [StringLength(50)]
        [Display(Name = "Job discipline")]
        public string Jobdiscipline { get; set; }


    }
}
