using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class JobDisciplineMasterDownload
    {
              
        [Display(Name = "Job discipline code")]
        public string JobdisciplineCode { get; set; }
                
        [Display(Name = "Job discipline")]
        public string Jobdiscipline { get; set; }


    }
}
