using System;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class DesignationMasterUpdate
    {
        public string CommandText { get => HRMastersProcedure.DesignationMasterUpdate; }
        public string PDesgcode { get; set; }
        public string PDesg { get; set; }
        public string PDesgNew { get; set; }
        public string POrd { get; set; }
        public string PSubcode { get; set; }
        public string OutPSuccess { get; set; }
        public string OutPMessage { get; set; }
    }
}