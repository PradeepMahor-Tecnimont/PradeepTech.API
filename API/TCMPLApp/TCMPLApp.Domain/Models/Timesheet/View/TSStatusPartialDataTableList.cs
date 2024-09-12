using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace TCMPLApp.Domain.Models.Timesheet
{
    public class TSStatusPartialDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }        

        [Display(Name = "Empno")]
        public string Empno { get; set; }

        [Display(Name = "Employee Name")]
        public string Empname { get; set; }

        [Display(Name = "Employee type")]
        public string Emptype { get; set; }

        [Display(Name = "Parent")]
        public string Parent { get; set; }

        [Display(Name = "Assign")]
        public string Assign { get; set; }

        [Display(Name = "Hours")]
        public decimal? Hours { get; set; }

        [Display(Name = "OT hours")]
        public decimal? OtHours { get; set; }

        [Display(Name = "Other CC hrs")]
        public decimal? CcHours { get; set; }

        [Display(Name = "Other CC OT hrs")]
        public decimal? CcOtHours { get; set; }

        //[Display(Name = "Total hours")]
        //public decimal? TotHours { get; set; }

        [Display(Name = "Status")]
        public decimal? IsStatusTrue { get; set; }

        public string TxtColor { get; set; }

        public string CurrentStatus { get; set; }
    }
}
