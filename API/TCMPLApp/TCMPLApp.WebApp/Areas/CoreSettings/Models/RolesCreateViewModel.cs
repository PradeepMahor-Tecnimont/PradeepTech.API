using System.ComponentModel.DataAnnotations;
using System.Runtime.InteropServices;

namespace TCMPLApp.WebApp.Models
{
    public class RolesCreateViewModel
    {
        [Required]
        [StringLength(30)]
        [Display(Name = "Role Name")]
        public string RoleName { get; set; }

        [Required]
        [StringLength(200)]
        [Display(Name = "Role Description")]
        public string RoleDesc { get; set; }

        [Required]
        [StringLength(2)]
        [Display(Name = "Role is active")]
        public string RoleIsActive { get; set; }

        [Display(Name = "Role id")]
        public string RoleId { get; set; }

        [Display(Name = "Flag")]
        public string FlagId { get; set; }
    }
}