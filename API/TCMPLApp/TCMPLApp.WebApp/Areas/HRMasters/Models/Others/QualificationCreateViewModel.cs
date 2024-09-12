using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Areas.HRMasters.Models
{
    public class QualificationCreateViewModel
    {
        public string Qualificationid { get; set; }

        [Required]
        [StringLength(50)]
        public string Qualification { get; set; }

        [Required]
        [StringLength(100)]
        [Display(Name = "Description")]
        public string Qualificationdesc { get; set; }
    }
}
