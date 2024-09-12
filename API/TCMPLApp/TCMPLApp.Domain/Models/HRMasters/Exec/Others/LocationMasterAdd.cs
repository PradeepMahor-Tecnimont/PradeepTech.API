using System;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class LocationMasterAdd
    {
        public string CommandText { get => HRMastersProcedure.LocationMasterAdd; }
        
        public string PLocationid { get; set; }
        public string PLocation { get; set; }
        public string OutPSuccess { get; set; }
        public string OutPMessage { get; set; }
    }
}
