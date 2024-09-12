using System;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class GraduationMasterAdd
    {
        public string CommandText { get => HRMastersProcedure.GraduationMasterAdd; }        
        public string PGraduationId { get; set; }
        public string PGraduationDesc { get; set; }
        public string OutPSuccess { get; set; }
        public string OutPMessage { get; set; }
    }
}
