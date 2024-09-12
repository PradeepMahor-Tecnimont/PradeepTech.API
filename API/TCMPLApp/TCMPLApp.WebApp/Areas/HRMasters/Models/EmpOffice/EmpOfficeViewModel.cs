using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
namespace TCMPLApp.WebApp.Models
{
    public class EmpOfficeViewModel
    {
        [Required]
        [Display(Name = "Employee No")]
        public string Employee { get; set; }

        [Required]
        [Display(Name = "Office Location")]
        public string EmpOfficeLocation { get; set; }


        [Required]
        [Display(Name = "Start Date")]
        public DateTime? StartDate { get; set; }

        public List<EmployeeLists> EmpList { get; set; }


    }
    public class EmployeeLists
    {
        public string Empno { get; set; }
    }
}
