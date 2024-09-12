using System.ComponentModel.DataAnnotations;
using System.Runtime.InteropServices;
using System;
using System.ComponentModel;

namespace TCMPLApp.WebApp.Models
{
    public class ShiftDetailsUpdateViewModel
    {
        [Required]
        [Display(Name = "Shift Code")]
        public string Shiftcode { get; set; }

        [Required]
        [Display(Name = "Shift Description")]
        public string Shiftdesc { get; set; }

        [Required]
        [Display(Name = "Time In")]
        public string TimeIn { get; set; }

        [Required]
        [Display(Name = "Time Out")]
        public string TimeOut { get; set; }

        [Display(Name = "Lunch Time")]
        public decimal? LunchMn { get; set; }

        [Display(Name = "Shift Allowance")]
        public decimal? Shift4allowance { get; set; }

        [Display(Name = "OT Applicable")]
        public decimal? OtApplicable { get; set; }
    }
}
