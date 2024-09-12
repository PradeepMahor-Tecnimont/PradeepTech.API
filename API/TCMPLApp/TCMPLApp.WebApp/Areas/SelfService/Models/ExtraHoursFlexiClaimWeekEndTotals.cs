using System;

namespace TCMPLApp.WebApp.Models
{
    public class ExtraHoursFlexiClaimWeekEndTotals
    {
        public DateTime? PDate { get; set; }

        public decimal ClaimedCompoffHrs { get; set; }

        public decimal ClaimedWeekDayExtraHrs { get; set; }

        public decimal ClaimedHoliDayExtraHrs { get; set; }
        public decimal ApplicableWeekDayExtraHrs { get; set; }
        public decimal ApplicableHoliDayExtraHrs { get; set; }
    }
}