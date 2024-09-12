using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class VendorCreateViewModel
    {
        [Required]
        [Display(Name = "Vendor name")]
        public string VendorName { get; set; }

        [Required]
        [Display(Name = "Is active")]
        public decimal IsActive { get; set; }
    }
}