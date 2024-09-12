using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace TCMPLApp.Domain.Models.DMS
{
    public class NewEmployeeDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

        [Display(Name = "Empno")]
        public string Empno { get; set; }

        [Display(Name = "Name")]
        public string EmpName { get; set; }

        [Display(Name = "Joining Date")]
        public DateTime? JoiningDate { get; set; }

        [Display(Name = "Department")]
        public string Dept { get; set; }

        [Display(Name = "Parent")]
        public string Parent { get; set; }

        //[Display(Name = "Modified By")]
        //public string ModifiedBy { get; set; }

        //[Display(Name = "Modified on")]
        //[DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:dd-MMM-yyyy}")]
        //public DateTime? ModifiedOn { get; set; }
    }
}