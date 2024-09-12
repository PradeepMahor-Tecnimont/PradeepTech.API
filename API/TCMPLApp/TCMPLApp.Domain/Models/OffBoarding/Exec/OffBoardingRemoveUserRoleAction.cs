using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.OffBoarding
{
    public class OffBoardingRemoveUserRoleAction
    {
        public string CommandText { get => OffBoardingProcedure.OffBoardingRemoveUserRoleAction; }
        public string PEmpno { get; set; }
        public string PRoleId { get; set; }
        public string PActionId { get; set; }
        public string PEntryByEmpno { get; set; }
        public string OutPSuccess { get; set; }
        public string OutPMessage { get; set; }

    }
}
