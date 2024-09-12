using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class NewCabinBookingCreateViewModel
    {

        [Display(Name = "Employee Type")]
        public string EmpType { get; set; }

        [Display(Name = "Booking Date")]
        public string BookingDate { get; set; }

        [Display(Name = "Desk")]
        public string Deskid { get; set; }

        [Display(Name = "Guest Name")]
        public string GuestName { get; set; }

    }
}
