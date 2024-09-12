using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Areas.DMS
{
    public class DeskMasterCreateViewModel
    {
        [Required]
        [StringLength(7)]
        [Display(Name = "Desk no")]
        public string Deskid { get; set; }

        [StringLength(5)]
        [Display(Name = "Office")]
        public string Office { get; set; }

        [StringLength(8)]
        [Display(Name = "Floor")]
        public string Floor { get; set; }

        [StringLength(10)]
        [Display(Name = "Seat no")]
        public string Seatno { get; set; }

        [StringLength(5)]
        [Display(Name = "Wing")]
        public string Wing { get; set; }

        [StringLength(20)]
        [Display(Name = "Asset code")]
        public string Assetcode { get; set; }

        [StringLength(1)]
        [Display(Name = "No exist")]
        public string Noexist { get; set; }

        [StringLength(1)]
        [Display(Name = "Cabin")]
        public string Cabin { get; set; }

        [StringLength(20)]
        [Display(Name = "Remark")]
        public string Remarks { get; set; }

        [StringLength(20)]
        [Display(Name = "Bay")]
        public string Bay { get; set; }

        [StringLength(3)]
        [Display(Name = "Work area")]
        public string Workarea { get; set; }
    }
}