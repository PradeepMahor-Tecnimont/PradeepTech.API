using System;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class GradeMasterUpdate
    {
        public string CommandText { get => HRMastersProcedure.GradeMasterUpdate; }
        public string PGradeId { get; set; }
        public string PGradeDesc { get; set; }
        public string OutPSuccess { get; set; }
        public string OutPMessage { get; set; }
    }
}
