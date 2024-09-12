using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class LcPoSapInvoiceCreateViewModel
    {
        [Required]
        public string LcKeyId { get; set; }

        [Required]
        [Display(Name = "Purchase order")]
        public decimal? Po { get; set; }

        [Required]
        [Display(Name = "Sap doc no")]
        public decimal? Sap { get; set; }

        [Required]
        [Display(Name = "Invoice no")]
        public decimal? Invoice { get; set; }
    }
}