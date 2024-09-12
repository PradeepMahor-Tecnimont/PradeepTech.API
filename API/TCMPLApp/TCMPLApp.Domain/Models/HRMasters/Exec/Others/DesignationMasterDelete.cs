using System;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class DesignationMasterDelete
    {
        public string CommandText { get => HRMastersProcedure.DesignationMasterDelete; }
        public string PDesgcode { get; set; }       
        public string OutPSuccess { get; set; }
        public string OutPMessage { get; set; }
    }
}
