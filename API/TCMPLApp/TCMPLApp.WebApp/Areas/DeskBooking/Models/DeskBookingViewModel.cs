using System;
using System.ComponentModel.DataAnnotations;
namespace TCMPLApp.WebApp.Models
{
    public class DeskBookingViewModel
    {
        [Display(Name = "From date")]
        [Required]
        public DateTime? FromDate { get; set; }

        [Display(Name = "To date")]
        [Required]
        public DateTime? ToDate { get; set; }
    }
}
