using System;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class HolidayMasterUpdate
    {
        public string CommandText { get => HRMastersProcedure.HolidayMasterUpdate; }
        public int PSrno { get; set; }
        public DateTime PHoliday { get; set; }        
        public string PDescription { get; set; }
        public string OutPSuccess { get; set; }
        public string OutPMessage { get; set; }
    }
}
