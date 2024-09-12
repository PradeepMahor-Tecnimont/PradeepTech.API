using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;
using System.Collections;

namespace TCMPLApp.Domain.Models.SWP
{
    public class ExcludeEmployeeDataTableList
    {
        [Display(Name = "Id")]
        public string KeyId { get; set; }

        [Display(Name = "Empno")]
        public string Empno { get; set; }

        [Display(Name = "Employee name")]
        public string EmployeeName { get; set; }

        [Display(Name = "Start date")]
        public string StartDate { get; set; }

        [Display(Name = "End date")]
        public string EndDate { get; set; }

        [Display(Name = "Reason")]
        public string Reason { get; set; }

        [Display(Name = "Is active")]
        public decimal IsActive { get; set; }

        [Display(Name = "Modified date")]
        public string ModifiedOn { get; set; }

        [Display(Name = "Modified by")]
        public string ModifiedBy { get; set; }

        public decimal? TotalRow { get; set; }

        public decimal RowNumber { get; set; }
    }
}