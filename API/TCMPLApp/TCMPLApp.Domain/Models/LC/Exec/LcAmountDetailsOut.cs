using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.LC
{
    public class LcAmountDetailsOut : DBProcMessageOutput
    {
        public string PLcKeyId { get; set; }
        public string PCurrencyKeyId { get; set; }
        public string PCurrencyCode { get; set; }
        public string PCurrencyDesc { get; set; }
        public string PExchangeRateDate { get; set; }
        public string PExchangeRate { get; set; }
        public string PLcAmount { get; set; }
        public string PAmountInInr { get; set; }
        public string PSendToTreasury { get; set; }
    }
}