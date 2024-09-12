using System;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class JobDisciplineMasterDelete
    {
        public string CommandText { get => HRMastersProcedure.JobDisciplineMasterDelete; }        
        public string PDisCd { get; set; }
        public string OutPSuccess { get; set; }
        public string OutPMessage { get; set; }
    }
}
