using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.LC
{
    public class LcBankDetailsOut : DBProcMessageOutput
    {
        public string PIssuingBankId { get; set; }
        public string PDiscountingBankId { get; set; }
        public string PAdvisingBankId { get; set; }
        public string PIssuingBank { get; set; }
        public string PDiscountingBank { get; set; }
        public string PAdvisingBank { get; set; }
        public string PValidityDate { get; set; }
        public string PIssueDate { get; set; }
        public string PDurationTypeVal { get; set; }
        public string PDurationTypeText { get; set; }
        public string PNoOfDays { get; set; }
        public string PLcNumber { get; set; }
        public string PPaymentDateEst { get; set; }
        public string PLcStatusVal { get; set; }
        public string PLcStatusText { get; set; }
        public string PRemarks { get; set; }
        public string PSendToTreasury { get; set; }
    }
}