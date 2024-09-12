using System;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class PlaceMasterUpdate
    {
        public string CommandText { get => HRMastersProcedure.PlaceMasterUpdate; }
        public string PPlaceId { get; set; }
        public string PPlaceDesc { get; set; }
        public string OutPSuccess { get; set; }
        public string OutPMessage { get; set; }
    }
}
