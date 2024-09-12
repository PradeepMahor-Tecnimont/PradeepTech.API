using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class ModuleUserRoleActionsCreateViewModel
    {
        [Required]
        [StringLength(3)]
        [Display(Name = "Module Id")]
        public string ModuleId { get; set; }

        [Required]
        [StringLength(4)]
        [Display(Name = "Role Id")]
        public string RoleId { get; set; }

        [Required]
        [StringLength(3)]
        [Display(Name = "Action Id")]
        public string ActionId { get; set; }

        [Required]
        [StringLength(5)]
        [Display(Name = "Employee No")]
        public string Empno { get; set; }
    }
}
