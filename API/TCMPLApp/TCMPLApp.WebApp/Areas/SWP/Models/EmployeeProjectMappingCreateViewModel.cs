using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace TCMPLApp.WebApp.Models
{
    public class EmployeeProjectMappingCreateViewModel
    {
        [Display(Name = "Employee")]
        [Required]
        public string Empno { get; set; }

        [Display(Name = "Project")]
        [Required]
        public string Projno { get; set; }

    }


}