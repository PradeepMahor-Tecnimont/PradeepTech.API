using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class AssetOnHoldAssetAddCreateViewModel
    {
        [Display(Name = "Asset category")]
        public string AssetCategory { get; set; }

        [Required]
        [Display(Name = "Asset")]
        public string AssetId { get; set; }

        [Display(Name = "Desk")]
        public string DeskId { get; set; }

        [Display(Name = "Employee")]
        public string Empno { get; set; }

        [Required]
        [Display(Name = "Action type")]
        public string ActionType { get; set; }

        [Required]
        [Display(Name = "Assign")]
        public string AssignCode { get; set; }

        [Required]
        [Display(Name = "Remarks")]
        public string Remarks { get; set; }
    }
}