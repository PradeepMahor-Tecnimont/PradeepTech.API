using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class OfficesUpdateViewModel
    {
        [Display(Name = "Office Code")]
        public string OfficeCode { get; set; }

        [Display(Name = "Office Name")]
        public string OfficeName { get; set; }

        [Display(Name = "Office Description")]
        public string OfficeDesc { get; set; }

        [Display(Name = "Office Location Value")]
        public string OfficeLocationCode { get; set; }

        [Display(Name = "Office Location value")]
        public string OfficeLocationTxt { get; set; }

        [Display(Name = "Smart Desk Booking")]
        public string SmartDeskBookingEnabled { get; set; }

        [Display(Name = "Smart Desk Booking")]
        public string SmartDeskBookingEnabledTxt { get; set; }
    }
}