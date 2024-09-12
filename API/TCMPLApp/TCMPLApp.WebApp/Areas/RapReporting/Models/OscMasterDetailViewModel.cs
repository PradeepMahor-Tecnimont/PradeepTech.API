using DocumentFormat.OpenXml.Wordprocessing;
using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class OscMasterDetailViewModel
    {
        [Display(Name = "OSCM id")]
        public string OscmId { get; set; }

        [Display(Name = "Contract date")]
        public string OscmDate { get; set; }

        [Display(Name = "Project")]
        public string Projno5 { get; set; }

        [Display(Name = "Name")]
        public string Projno5Desc { get; set; }

        [Display(Name = "Vendor")]
        public string OscmVendor { get; set; }

        [Display(Name = "Name")]
        public string OscmVendorDesc { get; set; }

        [Display(Name = "Scope of work")]
        public string ScopeWorkDesc { get; set; }

        [Display(Name = "Type")]
        public string OscmType { get; set; }

        [Display(Name = "PO number")]
        public string PoNumber { get; set; }

        [Display(Name = "PO Date")]
        [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:dd-MMM-yyyy}")]
        public DateTime? PoDate { get; set; }

        [Display(Name = "PO amount")]
        public decimal? PoAmt { get; set; }

        [Display(Name = "Current estimated PO amount")]
        public decimal? CurPoAmt { get; set; }

        [Display(Name = "Status")]
        public string LockOrigBudgetDesc { get; set; }

        [Display(Name = "Orignal est hours")]
        public decimal? OrigEstHoursTotal { get; set; }

        [Display(Name = "Current est hours")]
        public decimal? CurEstHoursTotal { get; set; }

        [Display(Name = "SES amount")]
        public decimal? SesAmountTotal { get; set; }

        [Display(Name = "Actual booked hours")]
        public decimal? ActualHoursBookedTotal { get; set; }

    }
}