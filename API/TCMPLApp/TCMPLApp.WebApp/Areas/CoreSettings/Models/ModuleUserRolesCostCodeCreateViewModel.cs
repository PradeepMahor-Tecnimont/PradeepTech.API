using System.ComponentModel.DataAnnotations;
using System.Runtime.InteropServices;

namespace TCMPLApp.WebApp.Models
{
    public class ModuleUserRoleCostCodeCreateViewModel
    {
        [Required]
        [Display(Name = "Module")]
        public string ModuleId { get; set; }

        [Display(Name = "Role")]
        public string RoleId { get; set; }

        [Required]
        [Display(Name = "Parent")]
        public string Parent { get; set; }

        [Required]
        [Display(Name = "Employee")]
        public string Empno { get; set; }
    }
}
