using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class InternalTransferDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

        public string KeyId { get; set; }

        [Display(Name = "Employee")]
        public string EmployeeName { get; set; }

        [Display(Name = "From Dept")]
        public string FromDept { get; set; }

        [Display(Name = "To Dept")]
        public string ToDept{ get; set; }

        [Display(Name = "Travel date")]
        public DateTime? TransferDate { get; set; }

    }
    public class InternalTransferDataTableExcel
    {
        public string EmployeeName { get; set; }
        public string Grade { get; set; }
        public string Emptype { get; set; }
        public string Sex { get; set; }
        public DateTime Doj { get; set; }
        public decimal? Age { get; set; }
        public string Designation { get; set; }
        public string FromDept { get; set; }
        public string FromDeptName { get; set; }
        public string ToDept { get; set; }
        public string ToDeptName { get; set; }
        public DateTime TransferDate { get; set; }

    }
}
