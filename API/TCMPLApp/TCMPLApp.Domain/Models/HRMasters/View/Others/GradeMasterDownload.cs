using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class GradeMasterDownload
    {       
        [Display(Name = "Grade")]
        public string Grade { get; set; }
    }
}
