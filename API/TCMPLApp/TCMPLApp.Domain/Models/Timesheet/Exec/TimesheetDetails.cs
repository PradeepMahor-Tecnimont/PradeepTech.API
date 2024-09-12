using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.Common;
using TCMPLApp.Domain.Models.DeskBooking;

namespace TCMPLApp.Domain.Models.Timesheet
{
    public class TimesheetDetails : DBProcMessageOutput
    {
        public string PParent { get; set; }
        public decimal PLocked { get; set; }
        public decimal PApproved { get; set; }
        public decimal PPosted { get; set; }
        public DateTime PApprOn { get; set; }
        public string PGrp { get; set; }
        public decimal PTotNhr { get; set; }
        public decimal PTotOhr { get; set; }
        public string PCompany { get; set; }
        public string PRemark { get; set; }
        public decimal PExceed { get; set; }
        public string PStatus { get; set; }
        public IEnumerable<DailyHours> PTimeDaily { get; set; }
        public IEnumerable<OverTimeHours> PTimeOt { get; set; }
        public IEnumerable<Holidays> PHolidays { get; set; }
    }
    public class DailyHours
    {
        public string Yymm { get; set; }
        public string Empno { get; set; }
        public string Parent { get; set; }
        public string Assign { get; set; }
        public string Projno { get; set; }
        public string Wpcode { get; set; }
        public string Activity { get; set; }
        public decimal D1 { get; set; }
        public decimal D2 { get; set; }
        public decimal D3 { get; set; }
        public decimal D4 { get; set; }
        public decimal D5 { get; set; }
        public decimal D6 { get; set; }
        public decimal D7 { get; set; }
        public decimal D8 { get; set; }
        public decimal D9 { get; set; }
        public decimal D10 { get; set; }
        public decimal D11 { get; set; }
        public decimal D12 { get; set; }
        public decimal D13 { get; set; }
        public decimal D14 { get; set; }
        public decimal D15 { get; set; }
        public decimal D16 { get; set; }
        public decimal D17 { get; set; }
        public decimal D18 { get; set; }
        public decimal D19 { get; set; }
        public decimal D20 { get; set; }
        public decimal D21 { get; set; }
        public decimal D22 { get; set; }
        public decimal D23 { get; set; }
        public decimal D24 { get; set; }
        public decimal D25 { get; set; }
        public decimal D26 { get; set; }
        public decimal D27 { get; set; }
        public decimal D28 { get; set; }
        public decimal D29 { get; set; }
        public decimal D30 { get; set; }
        public decimal D31 { get; set; }
        public decimal Total { get; set; }
        public string Grp { get; set; }
        public string Company { get; set; }
    }
    public class OverTimeHours
    {
        public string Yymm { get; set; }
        public string Empno { get; set; }
        public string Parent { get; set; }
        public string Assign { get; set; }
        public string Projno { get; set; }
        public string Wpcode { get; set; }
        public string Activity { get; set; }
        public decimal D1 { get; set; }
        public decimal D2 { get; set; }
        public decimal D3 { get; set; }
        public decimal D4 { get; set; }
        public decimal D5 { get; set; }
        public decimal D6 { get; set; }
        public decimal D7 { get; set; }
        public decimal D8 { get; set; }
        public decimal D9 { get; set; }
        public decimal D10 { get; set; }
        public decimal D11 { get; set; }
        public decimal D12 { get; set; }
        public decimal D13 { get; set; }
        public decimal D14 { get; set; }
        public decimal D15 { get; set; }
        public decimal D16 { get; set; }
        public decimal D17 { get; set; }
        public decimal D18 { get; set; }
        public decimal D19 { get; set; }
        public decimal D20 { get; set; }
        public decimal D21 { get; set; }
        public decimal D22 { get; set; }
        public decimal D23 { get; set; }
        public decimal D24 { get; set; }
        public decimal D25 { get; set; }
        public decimal D26 { get; set; }
        public decimal D27 { get; set; }
        public decimal D28 { get; set; }
        public decimal D29 { get; set; }
        public decimal D30 { get; set; }
        public decimal D31 { get; set; }
        public decimal Total { get; set; }
        public string Grp { get; set; }
        public string Company { get; set; }
    }
    public class Holidays
    {
        public string Days { get; set; }
    }
}
