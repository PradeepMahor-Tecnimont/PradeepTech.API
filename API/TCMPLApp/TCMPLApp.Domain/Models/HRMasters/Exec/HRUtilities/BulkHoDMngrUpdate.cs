using System;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class BulkHoDMngrUpdate
    {
        public string CommandText { get => HRMastersProcedure.BulkHoDMngrEdit; }
        public string PHodMngrOld { get; set; }
        public string PHodMngrNew { get; set; }
        public string PType { get; set; }        
        public string OutPSuccess { get; set; }
        public string OutPMessage { get; set; }
    }
}
