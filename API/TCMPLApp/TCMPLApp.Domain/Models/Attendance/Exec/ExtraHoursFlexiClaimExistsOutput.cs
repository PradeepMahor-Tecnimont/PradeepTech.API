using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.Attendance
{
    public class ExtraHoursFlexiClaimExistsOutput : DBProcMessageOutput
    {
        public string PClaimExists { get; set; }
    }
}