using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class JobTitleMasterDownload
    {        
        [Display(Name = "Job title code")]
        public string JobtitleCode { get; set; }

        [Display(Name = "Job title")]
        public string Jobtitle { get; set; } 
    }
}
