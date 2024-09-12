using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.OffBoarding
{
    public class OffBoardingExitUpdateUserContactInfo
    {
        public string CommandText { get => OffBoardingProcedure.OffBoardingExitUpdateUserContactInfo; }
        public string PEmpno { get; set; }
        public string PAddress { get; set; }
        public string PMobilePrimary { get; set; }
        public string PAlternateNumber { get; set; }
        public string OutPSuccess { get; set; }
        public string OutPMessage { get; set; }

    }
}
