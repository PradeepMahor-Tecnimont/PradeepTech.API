using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class NewEmployeeDataTableExcel
    {
        [Display(Name = "Empno")]
        public string Empno { get; set; }

        [Display(Name = "Name")]
        public string EmpName { get; set; }

        [Display(Name = "Joining Date")]
        public DateTime? JoiningDate { get; set; }

        [Display(Name = "Department")]
        public string Dept { get; set; }

        //[Display(Name = "Modified By")]
        //public string ModifiedBy { get; set; }

        //[Display(Name = "Modified on")]
        //[DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:dd-MMM-yyyy}")]
        //public DateTime? ModifiedOn { get; set; }
    }
}