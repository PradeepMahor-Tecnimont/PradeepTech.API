using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.RapReporting
{
    public class ExpectedJobsDetailsOut : DBProcMessageOutput
    {
        public string PName { get; set; }
        public string PActive { get; set; }
        public string PBu { get; set; }
        public string PActivefuture { get; set; }
        public string PFinalProjno { get; set; }
        public string PNewcostcode { get; set; }
        public string PTcmno { get; set; }
        public string PLck { get; set; }
        public string PProjType { get; set; }
    }
}