using System;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class EmployeeMasterApplicationsUpdate
    {
        public string CommandText { get => HRMastersProcedure.EmployeeMasterApplicationsEdit; }
        public string PEmpno { get; set; }        
        public Int32 PExpatriate { get; set; }
        public Int32 PHrOpr { get; set; }
        public Int32 PInvAuth { get; set; }
        public Int32 PJobIncharge { get; set; }
        public Int32 PNewemp { get; set; }
        public Int32 PPayroll { get; set; }
        public Int32 PProcOpr { get; set; }
        public Int32 PSeatreq { get; set; }
        public Int32 PSubmit { get; set; }
        public string OutPSuccess { get; set; }
        public string OutPMessage { get; set; }
    }
}
