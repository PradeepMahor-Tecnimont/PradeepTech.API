using System;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class QualificationMasterAdd
    {
        public string CommandText { get => HRMastersProcedure.QualificationMasterAdd; }        
        public string PQualificationId { get; set; }
        public string PQualification { get; set; }
        public string PQualificationDesc { get; set; }
        public string OutPSuccess { get; set; }
        public string OutPMessage { get; set; }
    }
}
