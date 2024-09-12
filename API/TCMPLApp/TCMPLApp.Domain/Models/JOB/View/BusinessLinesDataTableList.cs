using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.JOB
{
    public class BusinessLinesDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

        [Display(Name = "Code")]
        public string Code { get; set; }

        [Display(Name = "Short Description")]
        public string ShortDescription { get; set; }

        [Display(Name = "Business Lines description")]
        public string Description { get; set; }

        public decimal? DeleteAllowed { get; set; }
    }
}