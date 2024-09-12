using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class BGVendorUpdateViewModel
    {
        [Required]
        [Display(Name = "Vendor id")]
        public string VendorId { get; set; }

        [Display(Name = "Vendor name")]
        public string VendorName { get; set; }

        [Required]
        [Display(Name = "Company")]
        public string CompId { get; set; }

        [Required]
        [Display(Name = "IsVisible")]
        public decimal IsVisible { get; set; }
    }
}