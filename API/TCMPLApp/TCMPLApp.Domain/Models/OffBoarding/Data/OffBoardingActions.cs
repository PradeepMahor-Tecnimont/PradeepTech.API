using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.OffBoarding
{

    public class OffBoardingActions
    {
        public string ActionId { get; set; }
        public string RoleId { get; set; }
        public string ActionName { get; set; }
        public string ActionDesc { get; set; }
        public string IsActionForHod { get; set; }
        public string HodCostcode { get; set; }
        public string CheckerActionId { get; set; }
        public string GroupName { get; set; }

    }
}
