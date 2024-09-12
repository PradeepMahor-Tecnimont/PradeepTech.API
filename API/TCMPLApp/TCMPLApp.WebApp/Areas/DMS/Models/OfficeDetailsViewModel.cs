using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class OfficeDetailsViewModel
    {
        [Display(Name = "Office Code")]
        public string OfficeCode { get; set; }

        [Display(Name = "Office Name")]
        public string OfficeName { get; set; }

        [Display(Name = "Office Description")]
        public string OfficeDesc { get; set; }

        [Display(Name = "Office Location Value")]
        public string OfficeLocationVal { get; set; }

        [Display(Name = "Office Location value")]
        public string OfficeLocationTxt { get; set; }

        [Display(Name = "Smart Desk Booking")]
        public string SmartDeskBookingEnabledVal { get; set; }

        [Display(Name = "Smart Desk Booking")]
        public string SmartDeskBookingEnabledTxt { get; set; }
    }
}