using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.DMS;

namespace TCMPLApp.WebApp.Models
{
    public class InvItemAddOnReturnViewModel : InvItemAddOnDataTableList
    {
        [Required]
        [Display(Name = "Is Addon item usable")]
        public string ItemUsable { get; set; }

        [Required]
        [Display(Name = "Addon item return remarks")]
        public string ReturnRemarks { get; set; }
    }
}