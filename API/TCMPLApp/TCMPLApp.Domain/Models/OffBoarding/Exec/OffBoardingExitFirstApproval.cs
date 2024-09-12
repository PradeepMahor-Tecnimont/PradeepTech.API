using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.OffBoarding
{

    public class OffBoardingExitFirstApproval
    {
        public string CommandText { get => OffBoardingProcedure.OffBoardingExitFirstApproval; }
        public string PEmpno { get; set; }
        public string PRemarks { get; set; }
        public string PApprovedByEmpno { get; set; }
        public string PIsApprovalHold { get; set; }
        public string OutPSuccess { get; set; }
        public string OutPMessage { get; set; }

    }
}
