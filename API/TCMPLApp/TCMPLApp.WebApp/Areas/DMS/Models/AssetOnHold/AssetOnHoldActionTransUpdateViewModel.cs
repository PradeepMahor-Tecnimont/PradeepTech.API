using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class AssetOnHoldActionTransUpdateViewModel
    {
        [Required]
        [Display(Name = "ActiontransId")]
        public string ActiontransId { get; set; }

        [Required]
        [Display(Name = "Asset")]
        public string AssetId { get; set; }

        [Required]
        [Display(Name = "Source desk")]
        public string SourceDesk { get; set; }

        [Required]
        [Display(Name = "Target asset")]
        public string TargetAsset { get; set; }

        [Required]
        [Display(Name = "Action type")]
        public decimal? ActionType { get; set; }

        [Required]
        [Display(Name = "Remarks")]
        public string Remarks { get; set; }

        [Required]
        [Display(Name = "Source Employee")]
        public string SourceEmp { get; set; }

        [Required]
        [Display(Name = "Asset old")]
        public string AssetidOld { get; set; }
    }
}