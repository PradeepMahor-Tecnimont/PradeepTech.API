using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class OfficeDataTableExcel
    {
        [Display(Name = "Office Code")]
        public string OfficeCode { get; set; }

        [Display(Name = "Office Name")]
        public string OfficeName { get; set; }

        [Display(Name = "Office Description")]
        public string OfficeDesc { get; set; }

        [Display(Name = "Office Location Code")]
        public string OfficeLocation { get; set; }

        [Display(Name = "Smart Desk Booking Enabled")]
        public string SmartDeskBookingEnabled { get; set; }
    }
}