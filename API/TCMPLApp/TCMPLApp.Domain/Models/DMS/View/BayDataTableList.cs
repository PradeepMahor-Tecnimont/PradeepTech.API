using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.DMS
{
    public class BayDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

        [Display(Name = "Bay Id")]
        public string BayId { get; set; }

        [Display(Name = "Bay description")]
        public string BayDesc { get; set; }

        public decimal? BayCount { get; set; }
    }
}