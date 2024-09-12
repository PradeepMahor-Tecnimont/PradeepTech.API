using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class AssetAssignmentCreateViewModel
    {
        [Display(Name = "Session Id")]
        public string Sid { get; set; }

        [Display(Name = "Current desk no")]
        public string CurrDeskid { get; set; }

        public string Movetype { get; set; }

        [Display(Name = "Asset")]
        public string Assetid { get; set; }

        [Display(Name = "Assignment desk no")]
        public string Deskid { get; set; }
    }
}