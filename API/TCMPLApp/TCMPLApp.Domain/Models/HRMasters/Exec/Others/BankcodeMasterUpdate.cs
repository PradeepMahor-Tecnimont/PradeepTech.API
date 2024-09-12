using System;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class BankcodeMasterUpdate
    {
        public string CommandText { get => HRMastersProcedure.BankcodeMasterUpdate; }
        public string PBankcode { get; set; }
        public string PBankcodedesc { get; set; }
        public string OutPSuccess { get; set; }
        public string OutPMessage { get; set; }
    }
}
