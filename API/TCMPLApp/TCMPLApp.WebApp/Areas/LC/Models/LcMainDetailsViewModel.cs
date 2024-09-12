using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class LcMainDetailsViewModel
    {
        [Display(Name = "Application id")]
        public string ApplicationId { get; set; }

        [Display(Name = "Serial no")]
        public string LcSerialNo { get; set; }

        [Display(Name = "Company code")]
        public string CompanyCode { get; set; }

        [Display(Name = "Company full name")]
        public string CompanyFullName { get; set; }

        [Display(Name = "Company short name ")]
        public string CompanyShortName { get; set; }

        [Display(Name = "Payment yyyymm")]
        public string PaymentYyyymm { get; set; }

        [Display(Name = "Payment yyyymm half")]
        public string PaymentYyyymmHalf { get; set; }

        [Display(Name = "Project")]
        public string Project { get; set; }

        [Display(Name = "Vendor")]
        public string Vendor { get; set; }

        [Display(Name = "Currency code")]
        public string Currency { get; set; }

        [Display(Name = "Remarks")]
        public string Remarks { get; set; }

        [Display(Name = "LC amount")]
        public string LcAmount { get; set; }

        [Display(Name = "LC status")]
        public decimal LcStatusVal { get; set; }

        [Display(Name = "LC status")]
        public string LcStatusText { get; set; }

        [Display(Name = "LC Modified date")]
        public string ModifiedOn { get; set; }

        [Display(Name = "LC Modified by")]
        public string ModifiedBy { get; set; }

        [Display(Name = "LC close payment date")]
        public string LcClPaymentDate { get; set; }

        [Display(Name = "LC close actual amount")]
        public string LcClActualAmount { get; set; }

        [Display(Name = "LC close other charges")]
        public string LcClOtherCharges { get; set; }

        [Display(Name = "LC close on date")]
        public string LcClModOn { get; set; }

        [Display(Name = "LC close by")]
        public string LcClModBy { get; set; }

        [Display(Name = "LC close remarks ")]
        public string LcClRemarks { get; set; }

        [Display(Name = "Send to treasury Status")]
        public decimal SendToTreasuryVal { get; set; }

        [Display(Name = "Send to treasury Status")]
        public int SendToTreasuryText { get; set; }

        public IEnumerable<Domain.Models.LC.LcMainPoSapInvoiceDataTableList> lcMainPoSapInvoiceDataTableList { get; set; }
    }
}