using System;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class QualificationMasterDelete
    {
        public string CommandText { get => HRMastersProcedure.QualificationMasterDelete; }
        public string PQualificationId { get; set; }            
        public string OutPSuccess { get; set; }
        public string OutPMessage { get; set; }
    }
}
