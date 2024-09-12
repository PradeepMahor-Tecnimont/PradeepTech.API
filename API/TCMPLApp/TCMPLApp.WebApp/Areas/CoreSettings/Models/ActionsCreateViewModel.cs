using System.ComponentModel.DataAnnotations;
using System.Runtime.InteropServices;

namespace TCMPLApp.WebApp.Models
{
    public class ActionsCreateViewModel
    {
        [Required]
        [StringLength(30)]
        [Display(Name = "Action Name")]
        public string ActionName { get; set; }

        [Required]
        [StringLength(200)]
        [Display(Name = "Action Description")]
        public string ActionDesc { get; set; }

        [Display(Name = "Action Id")]
        public string ActionId { get; set; }
    }
}