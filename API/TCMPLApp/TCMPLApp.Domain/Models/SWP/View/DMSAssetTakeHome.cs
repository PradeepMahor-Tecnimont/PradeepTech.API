using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.SWP
{
    public class DMSAssetTakeHome
    {
        public decimal? TotalRow { get; set; }

        public decimal RowNumber { get; set; }

        [Display(Name = "Unqid")]
        public string Unqid { get; set; }

        [Display(Name = "Desk")]
        public string Deskid { get; set; }

        [Display(Name = "Empno")]
        public string Empno { get; set; }

        [Display(Name = "Asset Id")]
        public string Assetid { get; set; }

        [Display(Name = "Asset Type")]
        public string AssetType { get; set; }

        [Display(Name = "Description")]
        public string Description { get; set; }

        [Display(Name = "Take Home")]
        public decimal? Istaking2home { get; set; }

        public decimal? Requestconfirm { get; set; }
    }
}