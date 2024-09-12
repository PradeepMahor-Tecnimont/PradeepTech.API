using System.ComponentModel.DataAnnotations;
using System.Runtime.InteropServices;

namespace TCMPLApp.WebApp.Models
{
    public class ModuleRolesActionsUpdateViewModel
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
        [StringLength(4)]
        [Display(Name = "Action Id")]
        public string ActionId { get; set; }

        [Required]
        [StringLength(11)]
        [Display(Name = "Module Role Action Key Id")]
        public string ModuleRoleActionKeyId { get; set; }

        [Required]
        [StringLength(7)]
        [Display(Name = "Module Role Key Id")]
        public string ModuleRoleKeyId { get; set; }
    }
}
