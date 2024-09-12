using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.Common;
namespace TCMPLApp.Domain.Models.DeskBooking
{
    public class BookingSummaryDeptXLReportDetails : DBProcMessageOutput
    {
        public IEnumerable<BookedDeptEmpListFields> PBookedEmpList { get; set; }
    }
    public class BookedDeptEmpListFields
    {
        public string Office { get; set; }
        public string Dept { get; set; }
        public string Empno { get; set; }
        public string Name { get; set; }
        public string Area { get; set; }
        public string AreaDesc { get; set; }
        public string Desk { get; set; }
        public decimal StartTime { get; set; }
        public decimal EndTime { get; set; }
    }
}
