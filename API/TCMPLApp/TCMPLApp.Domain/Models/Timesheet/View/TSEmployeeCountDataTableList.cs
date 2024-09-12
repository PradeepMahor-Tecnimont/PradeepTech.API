using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace TCMPLApp.Domain.Models.Timesheet
{
    public class TSEmployeeCountDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

        [Display(Name = "Month")]
        public string Yymm { get; set; }

        [Display(Name = "Empno")]
        public string Empno { get; set; }

        [Display(Name = "Employee Name")]
        public string Empname { get; set; }

        [Display(Name = "Employee type")]
        public string Emptype { get; set; }

        [Display(Name = "Parent costcode")]
        public string Parent { get; set; }

        [Display(Name = "Assign costcode")]
        public string Assign { get; set; }

        [Display(Name = "Timesheet type")]
        public string TimesheetType { get; set; }

        [Display(Name = "Status")]
        public string StatusName { get; set; }
    }
}
