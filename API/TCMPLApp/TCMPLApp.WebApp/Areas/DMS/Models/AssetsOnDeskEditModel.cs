using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class AssetsOnDeskEditModel
    {
        [Required]
        public string DeskNo { get; set; }

        [Display(Name = "Asset category")]
        public string AssetCategory { get; set; }

        [Required]
        [Display(Name = "Asset")]
        public string AssetId { get; set; }

        public string OldAssetId { get; set; }
        public string OldAssetDescription { get; set; }
    }
}