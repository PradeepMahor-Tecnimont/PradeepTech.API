using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Areas.HRMasters.Models
{
    public class JobGroupCreateViewModel
    {
        [Required]
        [StringLength(2)]
        [Display(Name = "Job group code")]
        public string GrpCd { get; set; }

        [Required]
        [StringLength(50)]
        [Display(Name = "Job group")]
        public string GrpName { get; set; }

        [Required]
        [StringLength(50)]
        [Display(Name = "Milan job group")]
        public string MilanGrpName { get; set; }
    }
}
