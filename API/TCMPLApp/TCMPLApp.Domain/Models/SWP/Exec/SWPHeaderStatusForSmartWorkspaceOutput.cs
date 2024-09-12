using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.SWP
{
    public class SWPHeaderStatusForSmartWorkspaceOutput : DBProcMessageOutput
    {
        public decimal PEmpCountSmartWorkspace { get; set; }

        public decimal PEmpCountMon { get; set; }

        public decimal PEmpCountTue { get; set; }
        public decimal PEmpCountWed { get; set; }
        public decimal PEmpCountThu { get; set; }
        public decimal PEmpCountFri { get; set; }
        public string PCostcodeDesc { get; set; }
    }
}