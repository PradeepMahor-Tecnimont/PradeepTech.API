using System;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class JobGroupMasterDelete
    {
        public string CommandText { get => HRMastersProcedure.JobGroupMasterDelete; }
        public string PGrpCd { get; set; }
        public string OutPSuccess { get; set; }
        public string OutPMessage { get; set; }
    }
}
