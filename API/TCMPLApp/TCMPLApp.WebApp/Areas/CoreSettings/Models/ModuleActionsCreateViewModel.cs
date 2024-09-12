using System.ComponentModel.DataAnnotations;
using System.Runtime.InteropServices;

namespace TCMPLApp.WebApp.Models
{
    public class ModuleActionsCreateViewModel
    {
        [Required]
        [StringLength(3)]
        [Display(Name = "Module Id")]
        public string ModuleId { get; set; }

        [Display(Name = "Action Id")]
        public string ActionId { get; set; }

        [Required]
        [StringLength(2)]
        [Display(Name = "Action IsActive")]
        public string ActionIsActive { get; set; }
    }
}