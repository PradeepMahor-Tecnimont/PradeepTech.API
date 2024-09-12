using System;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class BankcodeMasterDelete
    {
        public string CommandText { get => HRMastersProcedure.BankcodeMasterDelete; }
        public string PBankcode { get; set; }       
        public string OutPSuccess { get; set; }
        public string OutPMessage { get; set; }
    }
}
