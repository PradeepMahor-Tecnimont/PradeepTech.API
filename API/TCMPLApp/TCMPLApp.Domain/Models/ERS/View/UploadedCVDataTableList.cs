using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.ERS
{
    public class UploadedCVDataTableList
    {
        public decimal? TotalRow { get; set; }

        public decimal RowNumber { get; set; }

        [Display(Name = "Status")]
        public string CvStatus { get; set; }

        public string VacancyJobKeyId { get; set; }

        [Display(Name = "Job reference code")]
        public string JobReferenceCode { get; set; }

        [Display(Name = "Job title")]
        public string ShortDesc { get; set; }

        [Display(Name = "PAN")]
        public string Pan { get; set; }

        [Display(Name = "Name")]
        public string CandidateName { get; set; }

        [Display(Name = "Email")]
        public string CandidateEmail { get; set; }

        [Display(Name = "Mobile")]
        public string CandidateMobile { get; set; }

        public string CandidateCvDispName { get; set; }
        public string CandidateCvOsName { get; set; }
    }
}