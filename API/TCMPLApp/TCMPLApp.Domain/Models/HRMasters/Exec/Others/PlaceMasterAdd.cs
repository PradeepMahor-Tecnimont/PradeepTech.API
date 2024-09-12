using System;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class PlaceMasterAdd
    {
        public string CommandText { get => HRMastersProcedure.PlaceMasterAdd; }        
        public string PPlaceId { get; set; }
        public string PPlaceDesc { get; set; }
        public string OutPSuccess { get; set; }
        public string OutPMessage { get; set; }
    }
}
