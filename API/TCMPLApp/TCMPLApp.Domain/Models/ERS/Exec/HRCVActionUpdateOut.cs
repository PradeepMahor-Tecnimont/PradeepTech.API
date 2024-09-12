using System;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.ERS
{
    public class HRCVActionUpdateOut : DBProcMessageOutput
    {        
        [Display(Name = "Job reference code")]
        public string PJobRefCode { get; set; }
                
        [Display(Name = "Email")]
        public string PCandidateEmail { get; set; }
                
        [Display(Name = "Status")]
        public decimal? PCvStatus { get; set; }
    }
}
