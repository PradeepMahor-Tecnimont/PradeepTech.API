using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.JOB
{
    public class SegmentsDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

        [Display(Name = "Segment code")]
        public string Code { get; set; }

        [Display(Name = "Segment description")]
        public string Description { get; set; }

        public decimal? DeleteAllowed { get; set; }
    }
}
