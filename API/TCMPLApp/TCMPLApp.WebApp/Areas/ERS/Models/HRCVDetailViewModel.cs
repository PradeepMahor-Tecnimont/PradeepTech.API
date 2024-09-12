using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Areas.ERS
{
    public class HRCVDetailViewModel
    {        
        public string JobKeyId { get; set; }

        [Display(Name = "Email")]
        public string CandidateEmail { get; set; }

        [Display(Name = "Name")]
        public string CandidateName { get; set; }

        [Display(Name = "Mobile no.")]
        public string CandidateMobile { get; set; }

        [Display(Name = "PAN")]
        public string Pan { get; set; }

        [Display(Name = "Job title")]
        public string ShortDesc { get; set; }

        [Display(Name = "CV status")]
        public decimal CvStatus { get; set; }

        [Display(Name = "CV status desc")]
        public string CvStatusDesc { get; set; }
    }
}
