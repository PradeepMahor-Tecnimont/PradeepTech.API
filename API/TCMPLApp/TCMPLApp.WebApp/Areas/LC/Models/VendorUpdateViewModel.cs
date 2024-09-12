using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class VendorUpdateViewModel
    {
        [Required]
        [Display(Name = "Application id")]
        public string ApplicationId { get; set; }

        [Required]
        [Display(Name = "Vendor name")]
        public string VendorName { get; set; }

        [Required]
        [Display(Name = "Is active")]
        public decimal IsActive { get; set; }
    }
}