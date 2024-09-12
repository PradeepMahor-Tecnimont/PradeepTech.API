using System;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class EmployeeActivate
    {
        public string CommandText { get => HRMastersProcedure.ActivateEmployee; }   
        public string PEmpno { get; set; }       
        public string OutPSuccess { get; set; }
        public string OutPMessage { get; set; }
    }
}
