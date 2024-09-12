using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.OffBoarding
{
    public class OffBoardingResetApproval
    {
        public string CommandText { get => OffBoardingProcedure.OffBoardingResetApproval; }
        public string POfbEmpno { get; set; }
        public string PActionId { get; set; }
        public string PResetByEmpno { get; set; }
        public string OutPSuccess { get; set; }
        public string OutPMessage { get; set; }

    }
}
