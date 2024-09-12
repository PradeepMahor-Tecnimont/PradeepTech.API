using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.Timesheet
{
    public class EmployeeTimesheetDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

        [Display(Name = "Emp no")]
        public string Empno { get; set; }

        [Display(Name = "Employee")]
        public string EmployeeName { get; set; }

        [Display(Name = "Assign code")]
        public string Assign { get; set; }

        [Display(Name = "Assign")]
        public string AssignName { get; set; }
    }
}
