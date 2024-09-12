using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.OffBoarding
{
    
    public class OffBoardingAddUserAccess
    {
        public string CommandText { get => OffBoardingProcedure.OffBoardingAddUserAccess; }
        public string PEmpno { get; set; }
        public string PRoleActionId { get; set; }
        public string OutPSuccess { get; set; }
        public string OutPMessage { get; set; }

    }
}
