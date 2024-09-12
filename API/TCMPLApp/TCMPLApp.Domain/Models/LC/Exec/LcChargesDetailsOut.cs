using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.LC
{
    public class LcChargesDetailsOut : DBProcMessageOutput
    {
        public string PLcKeyId { get; set; }
        public string PLcChargesStatusVal { get; set; }
        public string PLcChargesStatusText { get; set; }
        public string PBasicCharges { get; set; }
        public string POtherCharges { get; set; }
        public string PTax { get; set; }
        public string PClintFileName { get; set; }
        public string PServerFileName { get; set; }
        public string PCommissionRate { get; set; }
        public string PDays { get; set; }
        public string PRemarks { get; set; }
        public string PSendToTreasury { get; set; }
    }
}