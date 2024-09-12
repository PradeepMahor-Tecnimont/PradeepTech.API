using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class JobGroupMaster
    {
        [Required]
        [Display(Name = "Job group code")]
        public string JobGroupCode { get; set; }

        [Display(Name = "Job group")]
        public string JobGroup { get; set; }

        [Display(Name = "Milan job group")]
        public string MilanJobGroup { get; set; }

        public int? Emps { get; set; }
    }
}
