using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class NewEmployeeUpdateViewModel
    {
        [Required]
        [Display(Name = "Employee No")]
        public string Empno { get; set; }

        [Required]
        [Display(Name = "Joining Date")]
        public DateTime? JoiningDate { get; set; }

        [Required]
        [Display(Name = "Department")]
        public string Dept { get; set; }
    }
}