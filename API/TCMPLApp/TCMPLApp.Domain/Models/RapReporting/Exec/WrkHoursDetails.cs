using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.RapReporting
{
    public class WrkHoursDetails : DBProcMessageOutput
    {
        public decimal? PWorkingHrs { get; set; }
        public DateTime? PApprby { get; set; }
        public DateTime? PPostby { get; set; }
        public string PRemarks { get; set; }
    }
}
