using System;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class OfficeMasterDelete
    {
        public string CommandText { get => HRMastersProcedure.OfficeMasterDelete; }
        public string POffice { get; set; }       
        public string OutPSuccess { get; set; }
        public string OutPMessage { get; set; }
    }
}
