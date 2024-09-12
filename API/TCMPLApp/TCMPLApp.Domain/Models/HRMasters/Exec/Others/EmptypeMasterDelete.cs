using System;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class EmptypeMasterDelete
    {
        public string CommandText { get => HRMastersProcedure.EmptypeMasterDelete; }
        public string PEmptype { get; set; }
        public string OutPSuccess { get; set; }
        public string OutPMessage { get; set; }
    }
}
