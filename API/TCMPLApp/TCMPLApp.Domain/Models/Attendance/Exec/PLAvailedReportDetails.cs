using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.Common;
using TCMPLApp.Domain.Models.ReportSiteMap;

namespace TCMPLApp.Domain.Models.Attendance
{
    public class PLAvailedReportDetails : DBProcMessageOutput
    {
        public IEnumerable<PLDebitsReportFields> PPlDebits { get; set; }
        public IEnumerable<PLCreditsReportFields> PPlCredits { get; set; }
        public IEnumerable<OpenBalanceReportFields> POpenBal { get; set; }
    }

    public class PLDebitsReportFields
    {
        public string Empno { get; set; }

        public string AppNo { get; set; }
        public DateTime? Bdate { get; set; }
        public DateTime? Edate { get; set; }
        public decimal Leaveperiod { get; set; }
        public string Leavetype { get; set; }
        public DateTime? NuBdate { get; set; }
        public DateTime? NuEdate { get; set; }
        public decimal HolidayCount { get; set; }
        public decimal NuLeavePeriod { get; set; }
        public string DbCr { get; set; }
        public string AdjType { get; set; }
        public string FromTb { get; set; }

    }
    public class PLCreditsReportFields
    {
        public string Empno { get; set; }

        public string AppNo { get; set; }
        public DateTime? Bdate { get; set; }
        public DateTime? Edate { get; set; }
        public decimal Leaveperiod { get; set; }
        public string Leavetype { get; set; }
        public string DbCr { get; set; }
        public string AdjType { get; set; }
        public string FromTb { get; set; }
    }
    public class OpenBalanceReportFields
    {
        public string Empno { get; set; }

        public string Name { get; set; }
        public string Parent { get; set; }
        public string Assign { get; set; }
        public string Grade { get; set; }
        public string Emptype { get; set; }
        public DateTime? Doj { get; set; }
        public decimal OpenBal { get; set; }
    }
}
