using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class EmployeeResigned
    {

        [Display(Name = "Employee no")]
        public string Empno { get; set; }

        [Display(Name = "Employee name")]
        public string Name { get; set; }

        [Display(Name = "Parent")]
        public string Parent { get; set; }

        [Display(Name = "Costcode")]
        public string Costcode { get; set; }

        [Display(Name = "Emptype")]
        public string Emptype { get; set; }

        [Display(Name = "Grade")]
        public string Grade { get; set; }

        [Display(Name = "Designation")]
        public string Designation { get; set; }

        [Display(Name = "Category")]
        public string Category { get; set; }

        [Display(Name = "Place")]
        public string Place { get; set; }

        [Display(Name = "DOJ")]
        //[DisplayFormat(DataFormatString = "{0:dd-MM-yyyy}")]
        public DateTime? DOJ { get; set; }

        [Display(Name = "DOL")]
        //[DisplayFormat(DataFormatString = "{0:dd-MM-yyyy}")]
        public DateTime? DOL { get; set; }

        [Display(Name = "Remarks")]
        public string Remarks { get; set; }
        
    }
}
