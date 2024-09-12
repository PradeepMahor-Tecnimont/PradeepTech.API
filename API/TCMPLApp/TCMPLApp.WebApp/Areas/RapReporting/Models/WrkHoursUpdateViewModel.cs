using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class WrkHoursUpdateViewModel
    {
        [Display(Name = "YYMM")]
        public string Yymm { get; set; }

        [Display(Name = "Office")]
        public string Office { get; set; }

        [Display(Name = "Working hrs")]
        [Range(0, int.MaxValue, ErrorMessage = "Only positive number allowed")]
        public decimal? WorkingHrs { get; set; }

        [Display(Name = "Approved")]
        public DateTime? Apprby { get; set; }

        [Display(Name = "Posted")]
        public DateTime? Postby { get; set; }

        [Display(Name = "Remarks")]
        public string Remarks { get; set; }
    }
}
