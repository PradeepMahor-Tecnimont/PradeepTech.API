using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Areas.ERS
{
    public class VacancyDetailViewModel
    {
        public string JobKeyId { get; set; }

        [Display(Name = "Job reference code")]
        public string JobReferenceCode { get; set; }

        [Display(Name = "Open date")]
        [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:dd-MMM-yyyy}")]
        public DateTime? JobOpenDate { get; set; }

        [Display(Name = "Job Title")]
        public string ShortDesc { get; set; }

        [Display(Name = "Job type")]
        public string JobType { get; set; }

        [Display(Name = "Location")]
        public string JobLocation { get; set; }

        [Display(Name = "Job description 01")]
        public string JobDesc01 { get; set; }

        [Display(Name = "Job description 02")]
        public string JobDesc02 { get; set; }

        [Display(Name = "Job description 03")]
        public string JobDesc03 { get; set; }

    }
}
