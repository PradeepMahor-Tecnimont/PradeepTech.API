using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class ContractEmployee
    {
        [Display(Name = "Empno")]
        public string Empno { get; set; }

        [Display(Name = "Payroll")]
        public string Payroll { get; set; }

        [Display(Name = "Name")]
        public string Name { get; set; }

        [Display(Name = "Parent")]
        public string Parent { get; set; }

        [Display(Name = "Assign")]
        public string Assign { get; set; }

        [Display(Name = "DoB")]
        public DateTime? Dob { get; set; }

        [Display(Name = "DoJ")]
        public DateTime? Doj { get; set; }

        [Display(Name = "Designation")]
        public string Desg { get; set; }

        [Display(Name = "Emptype")]
        public string Emptype { get; set; }

        [Display(Name = "Grade")]
        public string Grade { get; set; }        

    }
}
