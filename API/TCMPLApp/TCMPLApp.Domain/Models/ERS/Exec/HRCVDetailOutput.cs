using System;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.ERS
{
    public class HRCVDetailOutput : DBProcMessageOutput
    {
        [Display(Name = "Name")]
        public string PCandidateName { get; set; }

        [Display(Name = "Mobile no.")]
        public string PCandidateMobile { get; set; }

        [Display(Name = "PAN")]
        public string PPan { get; set; }

        [Display(Name = "Job title")]
        public string PShortDesc { get; set; }

        [Display(Name = "CV status")]
        public decimal PCvStatus { get; set; }

        [Display(Name = "CV status desc")]
        public string PCvStatusDesc { get; set; }
    }
}
