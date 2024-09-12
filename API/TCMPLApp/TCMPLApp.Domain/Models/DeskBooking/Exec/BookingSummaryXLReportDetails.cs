using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.DeskBooking
{
    public class BookingSummaryXLReportDetails : DBProcMessageOutput
    {
        public IEnumerable<SummaryListFields> PSummaryList { get; set; }
        public IEnumerable<DeskListFields> PDeskList { get; set; }
        //public IEnumerable<DeptEmpListFields> PDeptEmpList { get; set; }
        public IEnumerable<BookedEmpListFields> PBookedEmpList { get; set; }
    }
    public class SummaryListFields
    {
        public string Office { get; set; }
        public string Area { get; set; }
        public string AreaDesc { get; set; }
        public decimal DeskCount { get; set; }
        public string Assign { get; set; }
        public decimal DeptEmpCount { get; set; }
        public decimal BookedDesks { get; set; }
    }
    public class DeskListFields
    {
        public string Office { get; set; }
        public string Floor { get; set; }
        public string Wing { get; set; }
        public string Area { get; set; }
        public string AreaDesc { get; set; }
        public string Desk { get; set; }
    }
    //public class DeptEmpListFields
    //{
    //    public string Empno { get; set; }
    //    public string Name { get; set; }
    //    public string Assign { get; set; }
    //    public string AreaId { get; set; }
    //    public string AreaDesc { get; set; }
    //}
    public class BookedEmpListFields
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
