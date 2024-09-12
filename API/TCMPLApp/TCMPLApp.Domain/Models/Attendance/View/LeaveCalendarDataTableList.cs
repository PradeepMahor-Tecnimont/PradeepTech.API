using System;
using System.ComponentModel.DataAnnotations;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.Attendance
{
    public class LeaveCalendarDataTableList
    {
        [Display(Name = "Id")]
        public string Id { get; set; }

        //[Display(Name = "Emp no")]
        //public string Empno { get; set; }

        [Display(Name = "Title")] // Empno no : Emp name
        public string Title { get; set; }

        //[Display(Name = "Employee")]
        //public string Employee { get; set; }

        [Display(Name = "Start")]
        public string Start { get; set; }

        [Display(Name = "End")]
        public string End { get; set; }

        //[Display(Name = "Last working date")]
        //public string WorkLDate { get; set; }

        //[Display(Name = "Leave type")]
        //public string LeaveType { get; set; }

        //[Display(Name = "Reason")]
        //public string Reason { get; set; }

        //[Display(Name = "apprl_status")]
        //public string ApprlStatus { get; set; }

        //public decimal? RowNumber { get; set; }
        //public decimal? TotalRow { get; set; }
    }
}