using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class GraduationMaster
    {
        [Required]
        [Display(Name = "Graduation")]
        public string Graduationid { get; set; }

        [Display(Name = "Description")]
        public string Graduationdesc { get; set; }

        public int? Emps { get; set; }
    }
}
