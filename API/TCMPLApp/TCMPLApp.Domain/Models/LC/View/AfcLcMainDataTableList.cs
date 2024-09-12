using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.LC
{
    public class AfcLcMainDataTableList
    {
        [Display(Name = "Serial no")]
        public string LcSerialNo { get; set; }

        [Display(Name = "Application id")]
        public string ApplicationId { get; set; }

        [Display(Name = "Company code")]
        public string CompanyCode { get; set; }

        [Display(Name = "Payment yyyymm")]
        public string PaymentYyyymm { get; set; }

        [Display(Name = "Payment yyyymm half")]
        public string PaymentYyyymmHalf { get; set; }

        [Display(Name = "Project")]
        public string Projno { get; set; }

        [Display(Name = "Vendor")]
        public string Vendor { get; set; }

        [Display(Name = "Currency code")]
        public string CurrencyCode { get; set; }

        [Display(Name = "Currency description")]
        public string CurrencyDesc { get; set; }

        [Display(Name = "LC Status")]
        public decimal LcStatus { get; set; }

        [Display(Name = "Send to treasury Status")]
        public decimal SendToTreasury { get; set; }

        [Display(Name = "LC Modified date")]
        public string ModifiedOn { get; set; }

        [Display(Name = "LC Modified by")]
        public string ModifiedBy { get; set; }

        public decimal? TotalRow { get; set; }

        public decimal RowNumber { get; set; }
    }
}