using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class BGVendorTypeCreateViewModel
    {
        [Required]
        [Display(Name = "Vendor type")]
        public string VendorType { get; set; }

        [Required]
        [Display(Name = "IsVisible")]
        public decimal IsVisible { get; set; }
    }
}