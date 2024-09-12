using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace TCMPLApp.WebApp.Models
{
    public class ExtraHoursClaimWeekEndTotals
    {
        public DateTime? PDate { get; set; }

        public decimal ClaimedCompoffHrs { get; set; }

        public decimal ClaimedWeekDayExtraHrs{ get; set; }

        public decimal ClaimedHoliDayExtraHrs { get; set; }
        public decimal ApplicableWeekDayExtraHrs { get; set; }
        public decimal ApplicableHoliDayExtraHrs { get; set; }
    }
}
