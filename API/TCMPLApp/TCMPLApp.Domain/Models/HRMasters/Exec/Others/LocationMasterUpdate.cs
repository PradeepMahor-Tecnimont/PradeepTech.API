using System;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class LocationMasterUpdate
    {
        public string CommandText { get => HRMastersProcedure.LocationMasterUpdate; }
        public string PLocationid { get; set; }
        public string PLocation { get; set; }
        public string OutPSuccess { get; set; }
        public string OutPMessage { get; set; }
    }
}
