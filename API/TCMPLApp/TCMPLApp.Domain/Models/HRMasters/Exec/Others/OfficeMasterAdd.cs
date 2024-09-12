using System;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class OfficeMasterAdd
    {
        public string CommandText { get => HRMastersProcedure.OfficeMasterAdd; }        
        public string POffice { get; set; }
        public string PName { get; set; }
        public string OutPSuccess { get; set; }
        public string OutPMessage { get; set; }
    }
}
