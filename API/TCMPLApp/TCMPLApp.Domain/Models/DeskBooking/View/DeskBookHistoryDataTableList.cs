using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.DeskBooking
{
    public class DeskBookHistoryDataTableList
    {
        [Display(Name = "Id")]
        public string KeyId { get; set; }

        [Display(Name = "Empno")]
        public string Empno { get; set; }

        [Display(Name = "Employee name")]
        public string EmpName { get; set; }


        [Display(Name = "Desk Id")]
        public string Deskid { get; set; }

        [Display(Name = "Attendance Date")]
        public string AttendanceDate { get; set; }

        [Display(Name = "Day Of Week")]
        public string DayOfWeek { get; set; }

        [Display(Name = "Modified On")]
        public DateTime ModifiedOn { get; set; }

        [Display(Name = "Modified Name")]
        public string ModifiedByEmpName { get; set; }

        [Display(Name = "Shift Code")]
        public string Shiftcode { get; set; }

        [Display(Name = "Office")]
        public string Office { get; set; }
        public string  IsDelete { get; set; }

        public decimal? TotalRow { get; set; }

        public decimal RowNumber { get; set; }
    }
}
