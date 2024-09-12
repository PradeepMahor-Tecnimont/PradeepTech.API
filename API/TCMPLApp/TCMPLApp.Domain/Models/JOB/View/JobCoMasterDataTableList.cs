using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.JOB
{
    public class JobCoMasterDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

        [Display(Name = "Company code")]
        public string Code { get; set; }

        [Display(Name = "Description")]
        public string Description { get; set; }

        public decimal? DeleteAllowed { get; set; }
    }
}