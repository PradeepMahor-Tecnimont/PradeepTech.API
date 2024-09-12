using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.DMS
{
    public class InvItemAsgmtTypesDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

        [Display(Name = "Assignment type code")]
        public string AsgmtCode { get; set; }

        [Display(Name = "Assignment type description")]
        public string AsgmtDesc { get; set; }

        [Display(Name = "Is active")]
        public decimal? IsActiveVal { get; set; }

        [Display(Name = "Is active")]
        public string IsActiveText { get; set; }

        [Display(Name = "Modified on")]
        public string ModifiedOn { get; set; }

        [Display(Name = "Modified by")]
        public string ModifiedBy { get; set; }
    }
}