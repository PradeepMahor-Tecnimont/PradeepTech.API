using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class OfficesCreateViewModel
    {
        [Required]
        [StringLength(4)]
        [Display(Name = "Office Code")]
        public string OfficeCode { get; set; }

        [Required]
        [StringLength(10)]
        [Display(Name = "Office Name")]
        public string OfficeName { get; set; }

        [Required]
        [StringLength(100)]
        [Display(Name = "Office Description")]
        public string OfficeDesc { get; set; }

        [Required]
        [StringLength(2)]
        [Display(Name = "Office Location Code")]
        public string OfficeLocationCode { get; set; }

        [Required]
        [StringLength(2)]
        [Display(Name = "Smart Desk Booking")]
        public string SmartDeskBookingEnabled { get; set; }
    }
}