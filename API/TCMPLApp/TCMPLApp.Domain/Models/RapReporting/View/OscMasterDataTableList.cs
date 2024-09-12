using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.RapReporting
{
    public class OscMasterDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

        [Display(Name = "OSCM id")]
        public string OscmId { get; set; }

        [Display(Name = "Date")]
        public string OscmDate { get; set; }

        [Display(Name = "Project")]
        public string Projno5 { get; set; }

        [Display(Name = "Name")]
        public string Projno5Desc { get; set; }

        [Display(Name = "Vendor")]
        public string OscmVendor { get; set; }

        [Display(Name = "Name")]
        public string OscmVendorDesc { get; set; }

        [Display(Name = "Type")]
        public string OscmType { get; set; }

        [Display(Name = "PO number")]
        public string PoNumber { get; set; }

        [Display(Name = "PO Date")]
        public string PoDate { get; set; }

        [Display(Name = "PO amount")]
        public double? PoAmt { get; set; }

        [Display(Name = "Current PO amount")]
        public double? CurPoAmt { get; set; }

        [Display(Name = "Status")]
        public string LockOrigBudgetDesc { get; set; }

    }
}