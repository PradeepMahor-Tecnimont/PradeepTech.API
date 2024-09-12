using System;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class SubcontractMasterDelete
    {
        public string CommandText { get => HRMastersProcedure.SubcontractMasterDelete; }
        public string PSubcontract { get; set; }       
        public string OutPSuccess { get; set; }
        public string OutPMessage { get; set; }
    }
}
