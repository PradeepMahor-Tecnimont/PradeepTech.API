using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.Attendance
{
    public class LeaveOnDutyDetailsOut
    {
        public string PEmpName { get; set; }
        public string POndutyType { get; set; }
        public string POndutySubType { get; set; }
        public string PStartDate { get; set; }
        public string PEndDate { get; set; }
        public string PHh1 { get; set; }
        public string PMi1 { get; set; }
        public string PHh2 { get; set; }
        public string PMi2 { get; set; }
        public string PReason { get; set; }

        public string PLeadName { get; set; }
        public string PLeadApproval { get; set; }
        public string PHodApproval { get; set; }
        public string PHrApproval { get; set; }
        public string PMessageType { get; set; }
        public string PMessageText { get; set; }

    }
}