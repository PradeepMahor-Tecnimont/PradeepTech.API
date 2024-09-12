
namespace TCMPLApp.Domain.Models.HRMasters
{
    public class WeekendHoliday
    {
        public string CommandText { get => HRMastersProcedure.PopulateWeekendHoliday; }
        public string PYyyy { get; set; }
        public string OutPSuccess { get; set; }
        public string OutPMessage { get; set; }
    }
}
