using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.Attendance
{
    public class LeaveCalendarHodExcelDataTableList
    {
        [Display(Name = "Id")]
        public string Id { get; set; }

        [Display(Name = "Emp no")]
        public string Empno { get; set; }

        [Display(Name = "Emp Name")]
        public string EmpName { get; set; }

        [Display(Name = "Start Date")]
        public string StartDate { get; set; }
        public string AppDate { get; set; }

        [Display(Name = "End Date")]
        public string EndDate { get; set; }
        public string WorkLastDate { get; set; }

        [Display(Name = "Leave Type")]
        public string LeaveType { get; set; }

        public string Reason { get; set; }

        [Display(Name = "Emp Type")]
        public string EmpType { get; set; }

        [Display(Name = "Grade")]
        public string Grade { get; set; }

        public string ApprlStatus { get; set; }

        [Display(Name = "Parent")]
        public string Parent { get; set; }
        public string LeavePeriod { get; set; }

    }
}
