using System;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class QualificationMasterUpdate
    {
        public string CommandText { get => HRMastersProcedure.QualificationMasterUpdate; }
        public string PQualificationId { get; set; }
        public string PQualification { get; set; }
        public string PQualificationDesc { get; set; }
        public string OutPSuccess { get; set; }
        public string OutPMessage { get; set; }
    }
}
