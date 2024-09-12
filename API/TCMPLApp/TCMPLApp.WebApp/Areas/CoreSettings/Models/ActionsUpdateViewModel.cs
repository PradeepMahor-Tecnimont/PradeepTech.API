using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class ActionsUpdateViewModel
    {
        [Required]
        [StringLength(4)]
        [Display(Name = "Action Id")]
        public string ActionId { get; set; }

        [Required]
        [StringLength(30)]
        [Display(Name = "Action Name")]
        public string ActionName { get; set; }

        [Required]
        [StringLength(200)]
        [Display(Name = "Action Description")]
        public string ActionDesc { get; set; }
    }
}