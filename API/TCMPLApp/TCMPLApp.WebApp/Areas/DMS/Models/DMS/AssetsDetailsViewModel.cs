using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class AssetsDetailsViewModel
    {
        [Display(Name = "Asset Id")]
        public string AssetId { get; set; }

        [Display(Name = "Asset Type")]
        public string AssetType { get; set; }

        [Display(Name = "Model")]
        public string Model { get; set; }

        [Display(Name = "Serial Number")]
        public string SerialNum { get; set; }

        [Display(Name = "Warranty End Date")]
        public string WarrantyEnd { get; set; }

        [Display(Name = "Sap Asset Code")]
        public string SapAssetCode { get; set; }

        [Display(Name = "Sub Asset Type")]
        public string SubAssetType { get; set; }

        [Display(Name = "Scrap")]
        public string Scrap { get; set; }

        [Display(Name = "Scrap Date")]
        public string ScrapDate { get; set; }

        [Display(Name = "Employee")]
        public string Employee { get; set; }

        [Display(Name = "Empno")]
        public string Empno { get; set; }

        [Display(Name = "Desk Id")]
        public string DeskId { get; set; }

        [Display(Name = "Status")]
        public string Status { get; set; }

        [Display(Name = "Remarks")]
        public string Remarks { get; set; }
    }
}