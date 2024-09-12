using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class ShiftDetailsViewModel
    {
        [Display(Name = "Shiftcode")]
        public string Shiftcode { get; set; }

        [Display(Name = "Shift Description")]
        public string Shiftdesc { get; set; }

        [Display(Name = "Time In")]
        public decimal? TimeinHh { get; set; }

        [Display(Name = "Time In Min")]
        public decimal? TimeinMn { get; set; }

        [Display(Name = "Time Out")]
        public decimal? TimeoutHh { get; set; }

        [Display(Name = "Time Out Min")]
        public decimal? TimeoutMn { get; set; }

        [Display(Name = "Shift Allowance")]
        public decimal? Shift4allowance { get; set; }
        public string Shift4allowanceText { get; set; }

        [Display(Name = "Lunch")]
        public decimal? LunchMn { get; set; }

        [Display(Name = "OT Applicable")]
        public decimal? OtApplicable { get; set; }
        public string OtApplicableText { get; set; }
    }
}
