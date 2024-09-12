using System;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class LocationMasterDelete
    {
        public string CommandText { get => HRMastersProcedure.LocationMasterDelete; }
        public string PLocationid { get; set; }       
        public string OutPSuccess { get; set; }
        public string OutPMessage { get; set; }
    }
}
