using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace TCMPLApp.WebApp.Models
{
    public class ExtraHoursClaimAdjustmentHoDViewModel : ExtraHoursClaimAdjustmentLeadViewModel
    {
        public decimal? HoDApprovedOt { get; set; }
        public decimal? HoDApprovedHhot { get; set; }
        public decimal? HoDApprovedCo { get; set; }

    }
}
