using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.Attendance
{
    public class LoPForExcessLeaveDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

        public string KeyId { get; set; }

        [Display(Name = "Application No")]
        public string AppNo { get; set; }
        
        [Display(Name = "Employee")]
        public string Empno { get; set; }
        public string EmpName { get; set; }

        [Display(Name = "LoP Month")]
        public string LopYyyymm { get; set; }

        [Display(Name = "Pay Slip Month")]
        public string PayslipYyyymm { get; set; }

        [Display(Name = "Leave Type")]
        public string Leavetype { get; set; }

        [Display(Name = "Debit/Credit")]
        public string DbCr { get; set; }

        [Display(Name = "Adj Type")]
        public string AdjType { get; set; }

        [Display(Name = "Loss Of Pay")]
        public decimal Lop { get; set; }

        [Display(Name = "Modified By")]
        public string ModifiedBy { get; set; }

        [Display(Name = "Modified On")]
        public DateTime ModifiedOn { get; set; }
    }
}
