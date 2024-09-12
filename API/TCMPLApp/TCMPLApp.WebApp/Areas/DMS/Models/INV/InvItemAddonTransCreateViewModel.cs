using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class InvItemAddOnTransCreateViewModel
    {
        //[Required]
        //[Display(Name = "Transaction date")]
        //public DateTime? TransDate { get; set; }

        //[Required]
        //[Display(Name = "Transaction type")]
        //public string TransTypeId { get; set; }

        [Required]
        [Display(Name = "Addon item type")]
        public string AddonItemType { get; set; }

        [Required]
        [Display(Name = "Addon item")]
        public string AddonItemId { get; set; }

        [Required]
        [Display(Name = "Container item type")]
        public string ContainerItemType { get; set; }

        [Required]
        [Display(Name = "Container item")]
        public string ContainerItemId { get; set; }

        [Display(Name = "Remarks")]
        [MaxLength(100)]
        public string Remarks { get; set; }
    }
}