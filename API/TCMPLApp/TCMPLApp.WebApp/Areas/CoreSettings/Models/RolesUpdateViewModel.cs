using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class RolesUpdateViewModel
    {
        [Required]
        [StringLength(4)]
        [Display(Name = "Role Id")]
        public string RoleId { get; set; }

        [Required]
        [StringLength(20)]
        [Display(Name = "Role Name")]
        public string RoleName { get; set; }

        [Required]
        [StringLength(200)]
        [Display(Name = "Role Description")]
        public string RoleDesc { get; set; }

        [Required]
        [StringLength(2)]
        [Display(Name = "Role IsActive")]
        public string RoleIsActive { get; set; }
    }
}
