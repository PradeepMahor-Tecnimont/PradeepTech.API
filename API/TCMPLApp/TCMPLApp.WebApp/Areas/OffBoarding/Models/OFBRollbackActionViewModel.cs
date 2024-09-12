using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class OFBRollbackActionViewModel
    {
        [Display(Name = "EmpNo")]
        [Required]
        public string Empno { get; set; }

        [Display(Name = "Employee Name")]
        public string EmployeeName { get; set; }

        [Display(Name = "Remarks")]
        [Required]
        [MaxLength(200)]
        public string Remarks { get; set; }
    }
}