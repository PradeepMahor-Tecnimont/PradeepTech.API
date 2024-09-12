using System;

namespace TCMPLApp.WebApp.Models
{
    public class HolidaysDataTableListExcel
    {
        public DateTime? Holiday { get; set; }

        public decimal RegionCode { get; set; }

        public string RegionName { get; set; }

        public string Yyyymm { get; set; }

        public string Weekday { get; set; }

        public string Description { get; set; }
    }
}
