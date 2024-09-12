using System;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class JobDisciplineMasterAdd
    {
        public string CommandText { get => HRMastersProcedure.JobDisciplineMasterAdd; }
        public string PDisCd { get; set; }
        public string PDisName { get; set; }
        public string OutPSuccess { get; set; }
        public string OutPMessage { get; set; }
    }
}
