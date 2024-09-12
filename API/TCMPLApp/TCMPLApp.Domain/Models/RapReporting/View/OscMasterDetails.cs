using System;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.RapReporting
{
    public class OscMasterDetails : DBProcMessageOutput
    {             
        [Display(Name = "Date")]
        public string POscmDate { get; set; }

        [Display(Name = "Project")]
        public string PProjno5 { get; set; }

        [Display(Name = "Name")]
        public string PProjno5Desc { get; set; }

        [Display(Name = "Revc date")]
        public DateTime? PRevcdate { get; set; }

        [Display(Name = "Vendor")]
        public string POscmVendor { get; set; }

        [Display(Name = "Name")]
        public string POscmVendorDesc { get; set; }

        [Display(Name = "Type")]
        public string POscmType { get; set; }

        [Display(Name = "PO number")]
        public string PPoNumber { get; set; }

        [Display(Name = "PO Date")]
        public DateTime? PPoDate { get; set; }

        [Display(Name = "PO amount")]
        public decimal? PPoAmt { get; set; }

        [Display(Name = "Current PO amount")]
        public decimal? PCurPoAmt { get; set; }

        [Display(Name = "Status")]
        public decimal? PLockOrigBudget { get; set; }

        [Display(Name = "Status")]
        public string PLockOrigBudgetDesc { get; set; }

        [Display(Name = "Original est hours")]
        public decimal? POrigEstHoursTotal { get; set; }

        [Display(Name = "Current est hours")]
        public decimal? PCurEstHoursTotal { get; set; }

        [Display(Name = "SES amount")]
        public decimal? PSesAmountTotal { get; set; }

        [Display(Name = "Scope of work")]
        public string POscswId { get; set; }

        [Display(Name = "Scope of work")]
        public string PScopeWorkDesc { get; set; }

        [Display(Name = "Actual hours booked")]
        public decimal? PActualHoursBookedTotal { get; set; }

        

    }
}