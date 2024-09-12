using System;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class OfficeMasterUpdate
    {
        public string CommandText { get => HRMastersProcedure.OfficeMasterUpdate; }
        public string POffice { get; set; }
        public string PName { get; set; }
        public string OutPSuccess { get; set; }
        public string OutPMessage { get; set; }
    }
}
