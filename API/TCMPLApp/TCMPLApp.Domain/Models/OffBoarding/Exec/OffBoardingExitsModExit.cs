using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.OffBoarding
{
    public class OffBoardingExitsModExit
    {
        public string CommandText { get => OffBoardingProcedure.OffBoardingExitModifyExit ; }
        public string PEmpno { get; set; }
        public DateTime PEndByDate { get; set; }
        public DateTime PRelieveDate { get; set; }
        public DateTime PResignDate { get; set; }
        public string PRemarks { get; set; }
        public string PAddress { get; set; }
        public string PPrimaryMobile { get; set; }
        public string PAlternateMobile { get; set; }
        public string PEmailId { get; set; }
        public string PEntryByEmpno { get; set; }
        public string OutPSuccess { get; set; }
        public string OutPMessage { get; set; }

    }
}
