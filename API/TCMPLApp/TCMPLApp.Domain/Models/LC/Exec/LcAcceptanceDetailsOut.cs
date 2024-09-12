using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.LC
{
    public class LcAcceptanceDetailsOut : DBProcMessageOutput
    {
        public string PAcceptanceDate { get; set; }
        public string PRemarks { get; set; }
        public string PPaymentDateAct { get; set; }
        public string PActualAmountPaid { get; set; }
        public string PSendToTreasury { get; set; }
    }
}