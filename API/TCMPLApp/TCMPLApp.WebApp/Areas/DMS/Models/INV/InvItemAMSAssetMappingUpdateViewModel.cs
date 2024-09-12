using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class InvItemAMSAssetMappingUpdateViewModel
    {
        [Required]
        [Display(Name = "AMS Asset Mapping KeyId")]
        public string ItemAMSAssetMappingKeyId { get; set; }

        [Required]
        [Display(Name = "Item type")]
        public string ItemType { get; set; }

        [Required]
        [Display(Name = "Sub asset type")]
        public string SubAssetType { get; set; }
    }
}