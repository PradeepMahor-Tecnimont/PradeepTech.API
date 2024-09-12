using System.ComponentModel.DataAnnotations;
using System.Runtime.InteropServices;

namespace TCMPLApp.WebApp.Models
{
    public class ModuleUserRolesCreateViewModel
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
        [StringLength(5)]
        [Display(Name = "Employee")]
        public string Empno { get; set; }

        //[Required]
        //[StringLength(8)]
        //[Display(Name = "Person Id")]
        //public string PersonId { get; set; }

        //[Required]
        //[StringLength(7)]
        //[Display(Name = "Module Role Key Id")]
        //public string ModuleRoleKeyId { get; set; }
    }
}