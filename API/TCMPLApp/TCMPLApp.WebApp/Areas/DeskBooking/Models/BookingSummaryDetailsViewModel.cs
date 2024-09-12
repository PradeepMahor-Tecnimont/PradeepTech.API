using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class BookingSummaryDetailsViewModel
    {

        [Display(Name = "Office")]
        public string Office { get; set; }

        [Display(Name = "Area")]
        public string AreaId { get; set; }
        public string AreaDesc { get; set; }

        [Display(Name = "Desk Count")]
        public decimal DeskCount { get; set; }

        [Display(Name = "Dept Empno Count")]
        public decimal DeptEmpnoCount { get; set; }

        [Display(Name = "Booked Desks ")]
        public decimal BookedDesks { get; set; }

        [Display(Name = "Costcode")]
        public string Costcode { get; set; }

        [Display(Name = "Booking Date")]
        public DateTime BookingDate { get; set; }

        [Display(Name = "Action Id")]
        public string ActionId { get; set; }

        public string bookingDate { get; set; }
    }
}
