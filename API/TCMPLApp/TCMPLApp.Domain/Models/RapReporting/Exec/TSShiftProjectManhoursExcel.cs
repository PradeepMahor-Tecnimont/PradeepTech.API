using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.Attendance;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.RapReporting.Exec
{
    public class TSShiftProjectManhoursExcel : DBProcMessageOutput
    {
        public IEnumerable<TSShiftProjectManhoursTimeMastDataTableList> PTimeMastLog { get; set; }
        public IEnumerable<TSShiftProjectManhoursTimeDailyDataTableList> PTimeDailyLog { get; set; }
        public IEnumerable<TSShiftProjectManhoursTimeOTDataTableList> PTimeOtLog { get; set; }
    }

}
