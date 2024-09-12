using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.OffBoarding
{
    public class OffBoardingCheckHrManagerCanApprove
    {
        public string CommandText { get => OffBoardingProcedure.OffBoardingCheckHRManagerCanApprove; }
        public string OutReturnValue { get; set; }
        public string PEmpno { get; set; }

    }
}
