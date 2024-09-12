using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.ERS
{
    public class HRVacanciesDataTableList
    {
        public decimal? TotalRow { get; set; }

        public decimal RowNumber { get; set; }

        public string JobKeyId { get; set; }

        [Display(Name = "Job reference code")]
        public string JobReferenceCode { get; set; }

        [Display(Name = "Job open date")]
        public DateTime JobOpenDate { get; set; }

        [Display(Name = "Job title")]
        public string ShortDesc { get; set; }

        [Display(Name = "Job type")]
        public string JobType { get; set; }

        [Display(Name = "Location")]
        public string JobLocation { get; set; }

        [Display(Name = "Uploaded CVs")]
        public decimal? UploadedCvs { get; set; }

        [Display(Name = "Job status")]
        public decimal JobStatus { get; set; }

    }
}