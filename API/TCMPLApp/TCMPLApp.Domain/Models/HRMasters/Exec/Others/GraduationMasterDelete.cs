using System;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class GraduationMasterDelete
    {
        public string CommandText { get => HRMastersProcedure.GraduationMasterDelete; }
        public string PGraduationId { get; set; }            
        public string OutPSuccess { get; set; }
        public string OutPMessage { get; set; }
    }
}
