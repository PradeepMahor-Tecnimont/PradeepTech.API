using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class HolidaysCreateViewModel
    {
        [Required]
        [Display(Name = "Region Code")]
        public string RegionCode { get; set; }

        [Required]
        [Display(Name = "Holiday")]
        public DateTime? Holiday { get; set; }

        [Required]
        [Display(Name = "YearMonth")]
        public string Yyyymm { get; set; }

        [Required]
        [Display(Name = "WeekDay")]
        public string Weekday { get; set; }

        [Required]
        [Display(Name = "Description")]
        public string Description { get; set; }

    }
}
