using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.Attendance
{
    public class HolidayAttendanceDetailsOut : DBProcMessageOutput
    {
        public string PEmployee { get; set; }
        public string PProjno { get; set; }
        public string PLeadName { get; set; }
        public string PAttendanceDate { get; set; }
        public string PPunchInTime { get; set; }
        public string PPunchOutTime { get; set; }
        public string PRemarks { get; set; }
        public string POffice { get; set; }
        public string PLeadApprl { get; set; }
        public string PLeadApprlDate { get; set; }
        public string PLeadApprlEmpno { get; set; }
        public string PHodApprl { get; set; }
        public string PHodApprlDate { get; set; }
        public string PHrApprl { get; set; }
        public string PHrApprlDate { get; set; }
        public string PDescription { get; set; }
        public string PApplicationDate { get; set; }
        public string PHodRemarks { get; set; }
        public string PHrRemarks { get; set; }
        public string PLeadRemarks { get; set; }
    }
}