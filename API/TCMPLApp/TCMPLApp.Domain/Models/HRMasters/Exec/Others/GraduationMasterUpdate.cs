using System;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class GraduationMasterUpdate
    {
        public string CommandText { get => HRMastersProcedure.GraduationMasterUpdate; }
        public string PGraduationId { get; set; }
        public string PGraduationDesc { get; set; }
        public string OutPSuccess { get; set; }
        public string OutPMessage { get; set; }
    }
}
