using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class ModuleUserRolesBulkCreateViewModel
    {
        [Required]
        [StringLength(3)]
        [Display(Name = "Module")]
        public string ModuleId { get; set; }

        [Required]
        [StringLength(4)]
        [Display(Name = "Role")]
        public string RoleId { get; set; }

        [Required]
        [Display(Name = "Employee")]
        public string Employee { get; set; }

        public List<ModuleUserRolesLists> EmpList { get; set; }
    }
    public class ModuleUserRolesLists
    {
        public string Empno { get; set; }
    }
}
