using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.RapReporting
{
    public class ProjactDetails : DBProcMessageOutput
    {
        public string PBudghrs { get; set; }
        public string PNoOfDocs { get; set; }
    }
}
