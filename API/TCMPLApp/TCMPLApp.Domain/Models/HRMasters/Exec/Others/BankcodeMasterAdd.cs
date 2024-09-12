using System;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class BankcodeMasterAdd
    {
        public string CommandText { get => HRMastersProcedure.BankcodeMasterAdd; }
        
        public string PBankcode { get; set; }
        public string PBankcodedesc { get; set; }
        public string OutPSuccess { get; set; }
        public string OutPMessage { get; set; }
    }
}
