using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.DMS
{
    public class OfficeDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

        [Display(Name = "Office Code")]
        public string OfficeCode { get; set; }

        [Display(Name = "Office Name")]
        public string OfficeName { get; set; }

        [Display(Name = "Office Description")]
        public string OfficeDesc { get; set; }

        [Display(Name = "Office Location Code")]
        public string OfficeLocationVal { get; set; }

        [Display(Name = "Office Location")]
        public string OfficeLocationTxt { get; set; }

        [Display(Name = "Smart Desk Booking Enabled")]
        public string SmartDeskBookingEnabledTxt { get; set; }

        public string SmartDeskBookingEnabled { get; set; }
    }
}