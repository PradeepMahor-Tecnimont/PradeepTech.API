using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class InvAddOnContainerDataTableExcel
    {
        [Display(Name = "Addon item")]
        public string AddonItemId { get; set; }

        [Display(Name = "Container item")]
        public string ContainerItemId { get; set; }
    }
}