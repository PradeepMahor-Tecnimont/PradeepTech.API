using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;
using System.Collections;

namespace TCMPLApp.Domain.Models.SWP
{
    public class FutureEmpComingToOfficeDataTableList
    {
        [Display(Name = "Id")]
        public string KeyId { get; set; }

        [Display(Name = "Empno")]
        public string Empno { get; set; }

        [Display(Name = "Employee name")]
        public string EmployeeName { get; set; }

        [Display(Name = "Employee")]
        public string Employee { get; set; }

        [Display(Name = "Assign")]
        public string Assign { get; set; }

        [Display(Name = "Parent")]
        public string Parent { get; set; }

        [Display(Name = "Current Pws Date")]
        public string CurrPwsDate { get; set; }

        [Display(Name = "Current Pws")]
        public string CurrPws { get; set; }

        [Display(Name = "Current desk")]
        public string CurrDesk { get; set; }

        [Display(Name = "Next week PWS status")]
        public string FuturePws { get; set; }

        [Display(Name = "Next week PWS date")]
        public string FuturePwsDate { get; set; }

        [Display(Name = "Modified by")]
        public string ModifiedBy { get; set; }

        [Display(Name = "Modified on date")]
        public string ModifiedOnDate { get; set; }

        [Display(Name = "DeskId")]
        public string DeskId { get; set; }

        public decimal? PwsVal { get; set; }

        public decimal? TotalRow { get; set; }

        public decimal RowNumber { get; set; }
    }
}