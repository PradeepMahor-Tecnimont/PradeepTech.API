using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.DMS
{
    public class DeskMasterDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

        [Display(Name = "Desk no")]
        public string DeskId { get; set; }

        [Display(Name = "Office")]
        public string Office { get; set; }

        [Display(Name = "Floor")]
        public string Floor { get; set; }

        [Display(Name = "Seat no")]
        public string SeatNo { get; set; }

        [Display(Name = "Wing")]
        public string Wing { get; set; }

        [Display(Name = "Asset code")]
        public string AssetCode { get; set; }

        [Display(Name = "IsDeleted")]
        public decimal? IsDeleted { get; set; }

        [Display(Name = "Cabin")]
        public string Cabin { get; set; }

        [Display(Name = "Remark")]
        public string Remarks { get; set; }

        [Display(Name = "Last Desk no")]
        public string DeskidOld { get; set; }

        [Display(Name = "Work area code")]
        public string WorkArea { get; set; }

        [Display(Name = "Work area categories")]
        public string WorkAreaCatg { get; set; }

        [Display(Name = "Work area description")]
        public string WorkAreaDesc { get; set; }

        [Display(Name = "Bay")]
        public string Bay { get; set; }

        [Display(Name = "Is blocked")]
        public decimal? IsBlocked { get; set; }
    }
}