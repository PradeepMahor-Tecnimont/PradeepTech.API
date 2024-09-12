using System;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class JobTitleMasterAdd
    {
        public string CommandText { get => HRMastersProcedure.JobTitleMasterAdd; }
        public string PTitCd { get; set; }        
        public string PTitle { get; set; }
        public string OutPSuccess { get; set; }
        public string OutPMessage { get; set; }
    }
}
