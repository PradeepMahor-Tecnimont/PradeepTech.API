namespace TCMPLApp.Domain.Models.Attendance
{
    public class ExtraHoursFlexiDetailsOut
    {
        public string PEmpName { get; set; }
        public string PClaimNo { get; set; }

        public string PClaimedOt { get; set; }
        public string PClaimedHhot { get; set; }
        public string PClaimedCo { get; set; }

        public string PLeadApprovedOt { get; set; }

        public string PLeadApprovedHhot { get; set; }

        public string PLeadApprovedCo { get; set; }

        public string PHodApprovedOt { get; set; }

        public string PHodApprovedHhot { get; set; }

        public string PHodApprovedCo { get; set; }

        public string PHrApprovedOt { get; set; }

        public string PHrApprovedHhot { get; set; }

        public string PHrApprovedCo { get; set; }
        public string PMessageType { get; set; }

        public string PMessageText { get; set; }
    }
}