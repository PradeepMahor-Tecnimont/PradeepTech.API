using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class ModuleActionsUpdateViewModel
    {
        [Required]
        [StringLength(3)]
        [Display(Name = "Module Id")]
        public string ModuleId { get; set; }

        [Required]
        [StringLength(4)]
        [Display(Name = "Action Id")]
        public string ActionId { get; set; }

        [Required]
        [StringLength(2)]
        [Display(Name = "Action IsActive")]
        public string ActionIsActive { get; set; }

        [Required]
        [StringLength(7)]
        [Display(Name = "Module Action Key Id")]
        public string ModuleActionKeyId { get; set; }
    }
}