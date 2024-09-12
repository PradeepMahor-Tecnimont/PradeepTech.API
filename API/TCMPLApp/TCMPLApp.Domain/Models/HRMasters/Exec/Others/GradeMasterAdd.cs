using System;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class GradeMasterAdd
    {
        public string CommandText { get => HRMastersProcedure.GradeMasterAdd; }        
        public string PGradeId { get; set; }
        public string PGradeDesc { get; set; }
        public string OutPSuccess { get; set; }
        public string OutPMessage { get; set; }
    }
}
