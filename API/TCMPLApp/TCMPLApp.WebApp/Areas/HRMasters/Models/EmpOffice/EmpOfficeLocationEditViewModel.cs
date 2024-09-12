using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class EmpOfficeLocationEditViewModel
    {
        [Display(Name = "Empno")]
        public string Empno { get; set; }

        [Display(Name = "Employee name")]
        public string Name { get; set; }

        [Display(Name = "Grade")]
        public string Grade { get; set; }

        [Display(Name = "Parent")]
        public string Parent { get; set; }

        [Display(Name = "Assign")]
        public string Assign { get; set; }

        [Display(Name = "Employee type")]
        public string Emptype { get; set; }

        [Required]
        [Display(Name = "Office Location")]
        public string EmpOfficeLocation { get; set; }


        [Required]
        [Display(Name = "Start Date")]
        public DateTime? StartDate { get; set; }

    }
}
