using System;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class GradeMasterDelete
    {
        public string CommandText { get => HRMastersProcedure.GradeMasterDelete; }
        public string PGradeId { get; set; }            
        public string OutPSuccess { get; set; }
        public string OutPMessage { get; set; }
    }
}
