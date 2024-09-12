using System;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class HolidayMasterAdd
    {
        public string CommandText { get => HRMastersProcedure.HolidayMasterAdd; }
        public DateTime PHoliday { get; set; }
        public string PDescription { get; set; }
        public string OutPSuccess { get; set; }
        public string OutPMessage { get; set; }
    }
}
