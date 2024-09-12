using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.SWP
{
    public class SWSEmployeePresentDataTableList
    {
        [Display(Name = "Empno")]
        public string Empno { get; set; }

        [Display(Name = "Employee name")]
        public string EmployeeName { get; set; }

        [Display(Name = "Parent")]
        public string Parent { get; set; }

        [Display(Name = "Assign")]
        public string Assign { get; set; }


        [Display(Name = "Grade")]
        public string Grade { get; set; }

        [Display(Name = "Emptype")]
        public string Emptype { get; set; }

        //public string PrimaryWorkspaceText { get; set; }
        public string Deskid { get; set; }

        public decimal? PunchCount  { get; set; }

        public string AttendanceStatus { get; set; }

        public string LeaveTourDepu { get; set; }

        public string IsPresent { get; set; }


        public decimal? TotalRow { get; set; }

        public decimal RowNumber { get; set; }

    }
}
