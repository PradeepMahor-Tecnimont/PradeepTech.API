using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.SWP
{
    public class SWPHeaderStatusForPrimaryWorkSpaceOutput : DBProcMessageOutput
    {
        public decimal PTotalEmpCount { get; set; }

        public decimal PEmpCountOfficeWorkspace { get; set; }

        public decimal PEmpCountSmartWorkspace { get; set; }

        public decimal PEmpCountNotInHo { get; set; }

        public decimal PEmpPercOfficeWorkspace { get; set; }
        public decimal PEmpPercSmartWorkspace { get; set; }
    }
}