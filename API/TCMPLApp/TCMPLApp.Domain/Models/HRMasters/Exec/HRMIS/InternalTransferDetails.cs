using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class InternalTransferDetails : DBProcMessageOutput
    {
        public string PEmpno { get; set; }
        public string PEmployeeName { get; set; }
        public string PFromCostcode { get; set; }
        public string PToCostcode { get; set; }
        public DateTime? PTransferDate { get; set; }
    }
}
