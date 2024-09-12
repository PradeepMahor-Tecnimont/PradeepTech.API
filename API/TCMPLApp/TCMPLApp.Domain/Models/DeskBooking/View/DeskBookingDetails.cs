using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.DeskBooking
{
    public class DeskBookingDetails : DBProcMessageOutput
    {
        public string PKeyId { get; set; }
        public string PDeskid { get; set; }
        public string PAttendanceDate { get; set; }
        public decimal? PStartTime { get; set; }
        public decimal? PEndTime { get; set; }
        public DateTime? PModifiedOn { get; set; }
        public string PModifiedBy { get; set; }
        public string PShiftcode { get; set; }
        public string POffice { get; set; }
    }
}