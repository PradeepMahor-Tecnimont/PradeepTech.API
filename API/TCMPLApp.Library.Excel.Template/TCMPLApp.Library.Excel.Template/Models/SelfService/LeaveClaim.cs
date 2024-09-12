using System;

namespace TCMPLApp.Library.Excel.Template.Models
{
    public class LeaveClaim
    {
        public string Empno { get; set; }

        public string LeaveType { get; set; }

        public decimal NoOfDays { get; set; }

        public DateTime StartDate { get; set; }
        public DateTime? EndDate { get; set; }

        public string Reason { get; set; }
        public string AdjustmentType { get; set; }
    }
}