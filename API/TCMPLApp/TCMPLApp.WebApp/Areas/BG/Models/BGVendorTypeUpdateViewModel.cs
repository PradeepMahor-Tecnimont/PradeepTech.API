using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class BGVendorTypeUpdateViewModel
    {
        [Required]
        [Display(Name = "VendorType id")]
        public string VendorTypeId { get; set; }

        [Display(Name = "VendorType")]
        public string VendorType { get; set; }

        [Required]
        [Display(Name = "IsVisible")]
        public decimal IsVisible { get; set; }
    }
}