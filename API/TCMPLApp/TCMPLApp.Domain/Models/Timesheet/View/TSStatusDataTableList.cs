using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace TCMPLApp.Domain.Models.Timesheet
{
    public class TSStatusDataTableList
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

        [Display(Name = "Hours")]
        public decimal? Hours { get; set; }

        [Display(Name = "OT hours")]
        public decimal? OtHours { get; set; }

        [Display(Name = "Other CC hrs")]
        public decimal? CcHours { get; set; }

        [Display(Name = "Other CC OT hrs")]
        public decimal? CcOtHours { get; set; }        

        [Display(Name = "Locked")]
        public decimal? TsLocked { get; set; }

        [Display(Name = "Approved")]
        public decimal? TsApproved { get; set; }

        [Display(Name = "Posted")]
        public decimal? TsPosted { get; set; }

        public decimal? IsActionVisible { get; set; }

        public decimal? IsTsFreeze  { get; set; }
    }
}
