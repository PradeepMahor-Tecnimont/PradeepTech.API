using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class QualificationMaster
    {        
        [Display(Name = "Qualification")]
        public string Qualificationid { get; set; }

        [Display(Name = "Qualification")]
        public string Qualification { get; set; }

        [Display(Name = "Description")]
        public string Qualificationdesc { get; set; }

        public int? Emps { get; set; }
    }
}
