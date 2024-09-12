using System;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class SubcontractMasterAdd
    {
        public string CommandText { get => HRMastersProcedure.SubcontractMasterAdd; }        
        public string PSubcontract { get; set; }
        public string PDescription { get; set; }
        public string OutPSuccess { get; set; }
        public string OutPMessage { get; set; }
    }
}
