using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class DeskMasterCreateViewModel
    {
        [Required]
        [StringLength(7)]
        [Display(Name = "Desk no")]
        public string Deskid { get; set; }

        [Required]
        [StringLength(5)]
        [Display(Name = "Office")]
        public string Office { get; set; }

        [Required]
        [StringLength(8)]
        [Display(Name = "Floor")]
        public string Floor { get; set; }

        [Required]
        [StringLength(10)]
        [Display(Name = "Seat no")]
        public string Seatno { get; set; }

        [StringLength(5)]
        [Display(Name = "Wing")]
        public string Wing { get; set; }

        [Display(Name = "Is blocked")]
        public decimal? IsBlocked { get; set; }

        [StringLength(1)]
        [Display(Name = "Cabin")]
        public string Cabin { get; set; }

        [StringLength(100)]
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