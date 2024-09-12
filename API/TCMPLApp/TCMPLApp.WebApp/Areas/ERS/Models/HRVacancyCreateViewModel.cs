using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Areas.ERS
{
    public class HRVacancyCreateViewModel
    {
        public string JobKeyId { get; set; }

        [Required]
        [Display(Name = "Cost code")]
        public string Costcode { get; set; }

        [Required]
        [Display(Name = "Job reference code")]
        public string JobReferenceCode { get; set; }

        [Required]
        [Display(Name = "Open date")]
        public DateTime? JobOpenDate { get; set; }

        [Required]
        [Display(Name = "Job title")]
        public string ShortDesc { get; set; }

        [Required]
        [Display(Name = "Job type")]
        public string JobType { get; set; }

        [Required]
        [Display(Name = "Location")]
        public string JobLocation { get; set; }

        [Required]
        [Display(Name = "Job description 01")]
        public string JobDesc01 { get; set; }

        [Display(Name = "Job description 02")]
        public string JobDesc02 { get; set; }

        [Display(Name = "Job description 03")]
        public string JobDesc03 { get; set; }

        [Display(Name = "Job status")]
        public decimal JobStatus { get; set; } = 1;

        [Display(Name = "Close date")]
        public DateTime? JobCloseDate { get; set; }

    }
}
