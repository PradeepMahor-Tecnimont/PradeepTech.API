using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.DeskBooking
{
    public class DeskBookingPreferencesOutPut : DBProcMessageOutput
    {
        public string PKeyId { get; set; }
        public string PEmpno { get; set; }
        public string POffice { get; set; }
        public string PShift { get; set; }
        public string PShiftDesc { get; set; }
        public string PDeskArea { get; set; }
        public string PDeskAreaDesc { get; set; }
        public string PModifiedOn { get; set; }
        public string PModifiedBy { get; set; }
    }
}
