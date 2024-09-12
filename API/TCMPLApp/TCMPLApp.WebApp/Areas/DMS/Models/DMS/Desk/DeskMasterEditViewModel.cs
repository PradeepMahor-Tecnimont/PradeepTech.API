using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Areas.DMS
{
    public class DeskMasterEditViewModel
    {
        [Required]
        [StringLength(7)]
        [Display(Name = "Desk no")]
        public string Deskid { get; set; }

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