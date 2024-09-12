using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class AssetOnHoldAssetAddDataTableListExcel
    {
        [Display(Name = "Desk id")]
        public string Deskid { get; set; }

        [Display(Name = "Asset id")]
        public string Assetid { get; set; }

        [Display(Name = "Asset description")]
        public string AssetDesc { get; set; }

        [Display(Name = "Employee no")]
        public string Empno { get; set; }

        [Display(Name = "Employee")]
        public string EmpName { get; set; }

        [Display(Name = "Action description")]
        public string ActionTypeText { get; set; }

        [Display(Name = "Assign")]
        public string Assign { get; set; }

        [Display(Name = "Remarks")]
        public string Remarks { get; set; }
    }
}