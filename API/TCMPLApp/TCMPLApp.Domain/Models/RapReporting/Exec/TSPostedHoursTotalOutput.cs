using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.RapReporting
{
    public class TSPostedHoursTotalOutput : DBProcMessageOutput
    {
        public decimal PTimeMastTotal { get; set; }
        public decimal PTimeDailyOtTotal { get; set; }
        public decimal PTimetranTotal { get; set; }
        public decimal POscMasterTotal { get; set; }
        public decimal POscDetailTotal { get; set; }
        public decimal PTimetranOscTotal { get; set; }
    }
}
