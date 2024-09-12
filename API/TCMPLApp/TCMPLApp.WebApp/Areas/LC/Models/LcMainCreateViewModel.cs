using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class LcMainCreateViewModel
    {
        [Required]
        [Display(Name = "Company code")]
        public string CompanyCode { get; set; }

        [Required]
        [MaxLength(6)]
        [RegularExpression("([1-9][0-9]*)")]
        [Display(Name = "Payment yyyymm")]
        public string PaymentYyyymm { get; set; }

        [Required]
        [Display(Name = "Payment yyyymm half")]
        public decimal PaymentYyyymmHalf { get; set; }

        [Required]
        [Display(Name = "Project no")]
        public string Projno { get; set; }

        [Required]
        [Display(Name = "Vendor")]
        public string Vendor { get; set; }

        [Required]
        [Display(Name = "Currency code")]
        public string Currency { get; set; }

        [Required]
        [Display(Name = "Remarks")]
        public string Remarks { get; set; } = "NA";

        [Required]
        [Display(Name = "LC Amount")]
        public decimal LcAmount { get; set; }

        [Display(Name = "Send to treasury")]
        public int SendToTreasury { get; set; }
    }
}