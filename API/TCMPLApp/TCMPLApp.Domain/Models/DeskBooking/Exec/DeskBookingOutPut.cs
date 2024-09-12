using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.Common;
using TCMPLApp.Domain.Models.HRMasters;

namespace TCMPLApp.Domain.Models.DeskBooking
{
    public class DeskBookingOutPut : DBProcMessageOutput
    {
        public IEnumerable<ExcelError> PErrors { get; set; }
    }
}
