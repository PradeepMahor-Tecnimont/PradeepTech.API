using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.Attendance
{
    public class ShiftHalfDayConfigDetails : DBProcMessageOutput
    {
        public string PShiftDesc { get; set; }
        public decimal? PHdFhStartMi { get; set; }
        public decimal? PHdFhEndMi { get; set; }
        public decimal? PHdShStartMi { get; set; }
        public decimal? PHdShEndMi { get; set; }
    }
}
