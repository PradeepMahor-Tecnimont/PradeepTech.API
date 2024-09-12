using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.Common;
using TCMPLApp.Domain.Models.HRMasters;

namespace TCMPLApp.Domain.Models.Attendance
{
    public class LoPForExcessLeaveOutPut : DBProcMessageOutput
    {
        public IEnumerable<ExcelError> PLopErrors { get; set; }
    }
}
