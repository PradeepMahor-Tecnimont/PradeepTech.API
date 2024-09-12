using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.Attendance
{
    public class LeaveCreateLeaveOutput : DBProcMessageOutput
    {
        public string PNewApplicationId { get; set; }
    }
}
