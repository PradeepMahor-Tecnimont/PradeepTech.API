using System;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class SubcontractMasterUpdate
    {
        public string CommandText { get => HRMastersProcedure.SubcontractMasterUpdate; }
        public string PSubcontract { get; set; }
        public string PDescription { get; set; }
        public string OutPSuccess { get; set; }
        public string OutPMessage { get; set; }
    }
}
