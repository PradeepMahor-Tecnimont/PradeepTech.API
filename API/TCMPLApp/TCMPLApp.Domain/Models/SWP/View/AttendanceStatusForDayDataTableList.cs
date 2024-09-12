using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.SWP
{
    public class AttendanceStatusForDayDataTableList
    {
        [Display(Name = "Empno")]
        public string Empno { get; set; }

        [Display(Name = "Employee name")]
        public string EmployeeName { get; set; }

        [Display(Name = "Email")]
        public string Email { get; set; }

        [Display(Name = "Parent")]
        public string Parent { get; set; }

        [Display(Name = "Assign")]
        public string Assign { get; set; }

        [Display(Name = "Employee type")]
        public string EmpType { get; set; }

        [Display(Name = "Grade")]
        public string Grade { get; set; }

        [Display(Name = "Date of joining")]
        public DateTime Doj { get; set; }

        [Display(Name = "D date")]
        public DateTime DDate { get; set; }


        [Display(Name = "Can work smartly")]
        public string CanWorkSmartly { get; set; }

        [Display(Name = "N primary workspace")]
        public string NPws { get; set; }

        [Display(Name = "C primary workspace")]
        public string CPws { get; set; }

        [Display(Name = "Attendance status")]
        public string AttendStatus { get; set; }

        [Display(Name = "Attendance required")]
        public string AttendRequired { get; set; }

    }
}