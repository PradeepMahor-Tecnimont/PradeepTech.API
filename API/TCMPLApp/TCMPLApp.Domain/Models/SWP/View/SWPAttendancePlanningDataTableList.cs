using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.SWP
{
    public class AttendancePlanningDataTableList
    {
        [Display(Name = "Id")]
        public string keyid { get; set; }

        [Display(Name = "Empno")]
        public string Empno { get; set; }

        [Display(Name = "Employee name")]
        public string EmployeeName { get; set; }

        [Display(Name = "Grade")]
        public string EmpGrade { get; set; }

        [Display(Name = "Project no")]
        public string Projno { get; set; }

        [Display(Name = "Status")]
        public string Status { get; set; }

        [Display(Name = "Attendance date")]
        public string AtndDate { get; set; }

        [Display(Name = "Desk id")]
        public string Deskid { get; set; }

        [Display(Name = "Assign workspace id")]
        public string FkSwpAssignworkspace { get; set; }

        [Display(Name = "Employee type")]
        public string Emptype { get; set; }

        [Display(Name = "Parent")]
        public string Parent { get; set; }

        [Display(Name = "Assign")]
        public string Assign { get; set; }

        [Display(Name = "Monday")]
        public decimal Mon { get; set; }

        [Display(Name = "Tuesday")]
        public decimal Tue { get; set; }

        [Display(Name = "Wednesday")]
        public decimal Wed { get; set; }

        [Display(Name = "Thursday")]
        public decimal Thu { get; set; }

        [Display(Name = "Friday")]
        public decimal Fri { get; set; }

        [Display(Name = "Pending")]
        public string Pending { get; set; }

        public decimal? TotalRow { get; set; }

        public decimal RowNumber { get; set; }
    }
}
