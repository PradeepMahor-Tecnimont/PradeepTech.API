using System;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class EmployeeMasterAddressUpdate
    {
        public string CommandText { get => HRMastersProcedure.EmployeeMasterAddressEdit; }
        public string PEmpno { get; set; }
        public string PAdd1 { get; set; }
        public string PAdd2 { get; set; }
        public string PAdd3 { get; set; }
        public string PAdd4 { get; set; }
        public Int32? PPincode { get; set; }
        public string OutPSuccess { get; set; }
        public string OutPMessage { get; set; }
    }
}
