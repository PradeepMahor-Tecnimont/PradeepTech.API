using System;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.ERS
{
    public class HRVacancyDetailOut : DBProcMessageOutput
    {
        [Display(Name = "Cost code")]
        public string PCostcode { get; set; }

        [Display(Name = "Cost code name")]
        public string PCostcodeName { get; set; }

        [Display(Name = "Job reference code")]
        public string PJobRefCode { get; set; }

        [Display(Name = "Open date")]
        public DateTime? PJobOpenDate { get; set; }

        [Display(Name = "Short description")]
        public string PShortDesc { get; set; }

        [Display(Name = "Job type")]
        public string PJobType { get; set; }

        [Display(Name = "Location")]
        public string PJobLocation { get; set; }

        [Display(Name = "Job description 01")]
        public string PJobDesc01 { get; set; }

        [Display(Name = "Job description 02")]
        public string PJobDesc02 { get; set; }

        [Display(Name = "Job description 03")]
        public string PJobDesc03 { get; set; }

        [Display(Name = "Close date")]
        public DateTime? PJobCloseDate { get; set; }
    }
}
