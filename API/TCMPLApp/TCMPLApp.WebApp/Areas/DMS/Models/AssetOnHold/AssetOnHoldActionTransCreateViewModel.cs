using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class AssetOnHoldActionTransCreateViewModel
    {
        [Display(Name = "Asset")]
        public string AssetId { get; set; }

        [Display(Name = "Source desk")]
        public string SourceDesk { get; set; }

        [Display(Name = "Target asset")]
        public string TargetAsset { get; set; }

        [Display(Name = "Action type")]
        public decimal? ActionType { get; set; }

        [Display(Name = "Remarks")]
        public string Remarks { get; set; }

        [Display(Name = "Source Employee")]
        public string SourceEmp { get; set; }

        [Display(Name = "Asset old")]
        public string AssetidOld { get; set; }
    }
}