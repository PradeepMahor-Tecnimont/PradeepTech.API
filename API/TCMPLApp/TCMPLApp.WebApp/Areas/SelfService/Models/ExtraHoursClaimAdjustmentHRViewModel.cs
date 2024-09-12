using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace TCMPLApp.WebApp.Models
{
    public class ExtraHoursClaimAdjustmentHRViewModel : ExtraHoursClaimAdjustmentHoDViewModel
    {
        public decimal? HRApprovedOt { get; set; }
        public decimal? HRApprovedHhot { get; set; }
        public decimal? HRApprovedCo { get; set; }

    }
}
