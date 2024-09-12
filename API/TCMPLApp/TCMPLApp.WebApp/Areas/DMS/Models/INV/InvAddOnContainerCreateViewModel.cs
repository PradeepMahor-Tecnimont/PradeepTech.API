using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class InvAddOnContainerCreateViewModel
    {
        [Required]
        [Display(Name = "Addon item")]
        public string AddonItemId { get; set; }

        [Required]
        [Display(Name = "Container item")]
        public string ContainerItemId { get; set; }
    }
}