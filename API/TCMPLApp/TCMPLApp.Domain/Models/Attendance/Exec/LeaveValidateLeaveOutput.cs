using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.Attendance
{
    public class LeaveValidateLeaveOutput : DBProcMessageOutput
    {
        public decimal PLeavePeriod { get; set; }
        public string PLastReporting { get; set; }
        public string PResuming { get; set; }
    }
}
