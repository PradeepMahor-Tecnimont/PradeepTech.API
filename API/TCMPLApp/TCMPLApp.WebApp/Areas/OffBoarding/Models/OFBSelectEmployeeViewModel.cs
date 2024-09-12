using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class OFBSelectEmployeeViewModel
    {
        [Required]
        [Display(Name = "Employee")]
        public string Empno { get; set; }
    }
}
