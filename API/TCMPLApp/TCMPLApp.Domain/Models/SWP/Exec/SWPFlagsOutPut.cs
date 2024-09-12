using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.SWP
{
    public class SWPFlagsOutPut : DBProcMessageOutput
    {
        public string PRestrictedDesksInSwsPlan { get; set; }

        public string POpenDesksInSwsPlan { get; set; } 

    }
}
