using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.OffBoarding
{
    public class OFBApprovalActionDetails : DBProcMessageOutput
    {
        public string PApprovalRemarks { get; set; }
        public string PIsApprovalDue { get; set; }
    }
}
