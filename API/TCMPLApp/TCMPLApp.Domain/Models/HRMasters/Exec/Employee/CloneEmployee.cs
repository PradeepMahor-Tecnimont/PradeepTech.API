using System;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class EmployeeClone
    {
        public string CommandText { get => HRMastersProcedure.CloneEmployee; }   
        public string PEmpno { get; set; }
        public string PEmptype { get; set; }
        public string PEmpnoNew { get; set; }
        public DateTime? PDoj { get; set; }
        public string PParent { get; set; }
        public string PAssign { get; set; }
        public string POffice { get; set; }
        public string OutPSuccess { get; set; }
        public string OutPMessage { get; set; }
    }
}
