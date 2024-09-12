using System.ComponentModel.DataAnnotations;
using System.Runtime.InteropServices;

namespace TCMPLApp.WebApp.Models
{
    public class ModulesCreateViewModel
    {
        
        [Required]
        [StringLength(20)]
        [Display(Name = "Module Name")]
        public string ModuleName { get; set; }

        [Required]
        [StringLength(200)]
        [Display(Name = "Module Long Description")]
        public string ModuleLongDesc { get; set; }

        [Required]
        [StringLength(2)]
        [Display(Name = "IsActive")]
        public string IsActive { get; set; }

        [Required]
        [StringLength(30)]
        [Display(Name = "Module Schema Name")]
        public string ModuleSchemaName { get; set; }
        
        [Required]
        [StringLength(30)]
        [Display(Name = "Function To Check User Access")]
        public string FuncToCheckUserAccess { get; set; }
        
        [Required]
        [StringLength(20)]
        [Display(Name = "Module Short Description")]
        public string ModuleShortDesc { get; set; }

    }
}
