using System;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class JobTitleMasterDelete
    {
        public string CommandText { get => HRMastersProcedure.JobTitleMasterDelete; }
        public string PTitCd { get; set; }
        public string OutPSuccess { get; set; }
        public string OutPMessage { get; set; }
    }
}
