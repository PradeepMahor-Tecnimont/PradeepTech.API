using System;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class JobDisciplineMasterUpdate
    {
        public string CommandText { get => HRMastersProcedure.JobDisciplineMasterUpdate; }        
        public string PDisCd { get; set; }
        public string PDisName { get; set; }
        public string OutPSuccess { get; set; }
        public string OutPMessage { get; set; }
    }
}
