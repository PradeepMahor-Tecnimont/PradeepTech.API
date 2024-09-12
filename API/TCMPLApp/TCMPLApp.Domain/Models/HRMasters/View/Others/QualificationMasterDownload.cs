using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class QualificationMasterDownload
    {        
        [Display(Name = "Qualification")]
        public string QualificationCode { get; set; }

        [Display(Name = "Qualification")]
        public string Qualification { get; set; }

        [Display(Name = "Description")]
        public string QualificationDesc { get; set; }
    }
}
