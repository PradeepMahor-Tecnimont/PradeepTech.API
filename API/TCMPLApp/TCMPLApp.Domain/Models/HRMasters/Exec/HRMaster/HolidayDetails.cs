using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class HolidayDetails : DBProcMessageOutput
    {
        public string PRegionName { get; set; }
        public string PYyyymm { get; set; }
        public string PWeekday { get; set; }
        public string PDescription { get; set; }
    }
}
