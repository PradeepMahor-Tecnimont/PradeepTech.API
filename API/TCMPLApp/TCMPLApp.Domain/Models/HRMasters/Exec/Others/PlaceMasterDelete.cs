using System;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class PlaceMasterDelete
    {
        public string CommandText { get => HRMastersProcedure.PlaceMasterDelete; }
        public string PPlaceId { get; set; }            
        public string OutPSuccess { get; set; }
        public string OutPMessage { get; set; }
    }
}
