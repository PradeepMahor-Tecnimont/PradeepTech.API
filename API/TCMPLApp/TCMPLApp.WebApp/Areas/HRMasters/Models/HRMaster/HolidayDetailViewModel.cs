using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class HolidayDetailViewModel
    {
        [Display(Name = "Holiday")]
        public DateTime? Holiday { get; set; }

        [Display(Name = "Region Code")]
        public string RegionCode { get; set; }

        [Display(Name = "Region")]
        public string RegionName { get; set; }

        [Display(Name = "YearMonth")]
        public string Yyyymm { get; set; }

        [Display(Name = "WeekDay")]
        public string Weekday { get; set; }

        [Display(Name = "Description")]
        public string Description { get; set; }
    }
}
