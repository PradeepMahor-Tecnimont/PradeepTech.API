using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.OffBoarding
{

    public class OffBoardingChildApprovalsStatus
    {
        public string CommandText { get => OffBoardingProcedure.OffBoardingChildApprovalsStatus; }
        public string OutReturnValue { get; set; }
        public string POfbEmpno { get; set; }
        public string PSecondApproverEmpno { get; set; }
        public string PActionId { get; set; }

    }


}
