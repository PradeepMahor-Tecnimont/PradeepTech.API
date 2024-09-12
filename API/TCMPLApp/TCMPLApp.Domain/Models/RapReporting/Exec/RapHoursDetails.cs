using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.RapReporting
{
    public class RapHoursDetails : DBProcMessageOutput
    {
        public decimal? PWorkDays { get; set; }
        public decimal? PWeekend { get; set; }
        public decimal? PHolidays { get; set; }
        public decimal? PLeave { get; set; }
        public decimal? PTotDays { get; set; }
        public decimal? PWorkingHr { get; set; }
    }
}
