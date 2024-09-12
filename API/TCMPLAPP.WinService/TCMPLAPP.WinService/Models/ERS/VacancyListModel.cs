using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace TCMPLAPP.WinService.Models
{  
    public class VacancyListModel
    {
        public string Status { get; set; }
        public string MessageCode { get; set; }
        public string Message { get; set; }
        public List<VacancyData> data { get; set; }
    }

    public class VacancyData
    {
        public decimal? TotalRow { get; set; }

        public decimal RowNumber { get; set; }

        public string JobKeyId { get; set; }

        [Display(Name = "Job reference code")]
        public string JobReferenceCode { get; set; }

        [Display(Name = "Costcode")]
        public string Costcode { get; set; }

        [Display(Name = "Job title")]
        public string ShortDesc { get; set; }

        [Display(Name = "Job type")]
        public string JobType { get; set; }

        [Display(Name = "Location")]
        public string JobLocation { get; set; }

        [Display(Name = "Uploaded CVs")]
        public decimal? UploadedCvs { get; set; }
    }
}
