using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.Attendance
{
    public class ShiftLunchConfigDetails : DBProcMessageOutput
    {
        public string PShiftDesc { get; set; }
        public decimal? PLunchStartMi { get; set; }
        public decimal? PLunchEndMi { get; set; }
    }
}
