using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class RemoveAssetOnHoldViewModel
    {
        [Required]
        [Display(Name = "Unqid")]
        public string Unqid { get; set; }

        [Display(Name = "Asset category")]
        public string AssetCategory { get; set; }

        [Required]
        [Display(Name = "Asset")]
        public string AssetId { get; set; }

        [Display(Name = "Asset")]
        public string AssetDesc { get; set; }

        [Display(Name = "Desk")]
        public string DeskId { get; set; }

        [Display(Name = "Employee")]
        public string Empno { get; set; }

        public string Empname { get; set; }

        [Required]
        [Display(Name = "Action type")]
        public string ActionType { get; set; }

        [Required]
        [Display(Name = "AssignCode")]
        public string AssignCode { get; set; }

        [Required]
        [Display(Name = "Remarks")]
        public string Remarks { get; set; }
    }
}