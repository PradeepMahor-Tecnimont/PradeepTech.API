using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace TCMPLApp.WebApp.Models
{
    public class OffBoardingUserAccessCreateViewModel
    {
        [Required]
        [Display(Name = "Employee")]
        public string Empno { get; set; }

        [Required]
        [Display(Name ="Role - Action")]
        public string RoleActionId { get; set; }

    }
}
