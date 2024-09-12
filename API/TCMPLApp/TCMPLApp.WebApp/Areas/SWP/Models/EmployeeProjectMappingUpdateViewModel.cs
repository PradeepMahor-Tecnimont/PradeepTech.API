using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace TCMPLApp.WebApp.Models
{
    public class EmployeeProjectMappingUpdateViewModel
    {
        [Required]
        public string KeyId { get; set; }

        [Display(Name = "Employee")]
        [Required]
        public string Empno { get; set; }

        [Display(Name = "Employee")]
        public string Empname { get; set; }

        [Display(Name = "Project")]
        [Required]
        public string Projno { get; set; }
    }
}