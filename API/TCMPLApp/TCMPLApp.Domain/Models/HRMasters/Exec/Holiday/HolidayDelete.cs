
namespace TCMPLApp.Domain.Models.HRMasters
{
    public class HolidayDelete
    {
        public string CommandText { get => HRMastersProcedure.DeleteHoliday; }
        public int PSrno { get; set; }
        public string OutPSuccess { get; set; }
        public string OutPMessage { get; set; }
    }
}
