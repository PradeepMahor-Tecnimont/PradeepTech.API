using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.Attendance
{
    public class LeaveLeaveDetailsOut
    {
        public string PEmpno { get; set; }
        public string PEmpName { get; set; }
        public string PLeaveType { get; set; }
        public string PApplicationDate { get; set; }
        public string PStartDate { get; set; }
        public string PEndDate { get; set; }
        public string PLeavePeriod { get; set; }
        public string PLastReporting { get; set; }
        public string PResuming { get; set; }
        public string PProjno { get; set; }
        public string PCareTaker { get; set; }
        public string PReason { get; set; }
        public string PMedCertAvailable { get; set; }
        public string PContactAddress { get; set; }
        public string PContactStd { get; set; }
        public string PContactPhone { get; set; }
        public string POffice { get; set; }
        public string PLeadName { get; set; }
        public string PDiscrepancy { get; set; }
        public string PMedCertFileNm { get; set; }
        public string PLeadApproval { get; set; }
        public string PHodApproval { get; set; }
        public string PHrApproval { get; set; }
        public string PLeadReason { get; set; }
        public string PHodReason { get; set; }
        public string PHrReason { get; set; }
        public string PFlagIsAdj { get; set; }
        public string PFlagCanDel { get; set; }
        public string PMessageType { get; set; }
        public string PMessageText { get; set; }

    }

    public class LeaveSLLeaveDetailsOut : LeaveLeaveDetailsOut
    {
        public decimal? PSlAvailed { get; set; }
        public decimal? PSlApplied { get; set; }
        public string PFlagCanApprove { get; set; }
    }
}
