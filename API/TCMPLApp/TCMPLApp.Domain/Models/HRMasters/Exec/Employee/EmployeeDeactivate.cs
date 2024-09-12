using System;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class EmployeeDeactivate
    {
        public string CommandText { get => HRMastersProcedure.DeactivateEmployee; }   
        public string PEmpno { get; set; }
        public DateTime? PDol { get; set; }
        public string PReasonId { get; set; }
        public string PRemarks { get; set; }
        public string OutPSuccess { get; set; }
        public string OutPMessage { get; set; }
    }
}
