using System;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class JobGroupMasterAdd
    {
        public string CommandText { get => HRMastersProcedure.JobGroupMasterAdd; }        
        public string PGrpCd { get; set; }
        public string PGrpName { get; set; }
        public string PGrpMilan { get; set; }
        public string OutPSuccess { get; set; }
        public string OutPMessage { get; set; }
    }
}
