using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class LeaveCalendarHodDataTableListExcel
    {
        public string Id { get; set; }
        public string EmpName { get; set; }
        public string Parent { get; set; }
        public string Grade { get; set; }
        public string EmpType { get; set; }
        public string LeaveType { get; set; }
        public string AppDate { get; set; }
        public string StartDate { get; set; }
        public string EndDate { get; set; }
        public string WorkLastDate { get; set; }
        public string Reason { get; set; }
        public string LeavePeriod { get; set; }
    }
}
