using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class DeskMasterExcludeViewModel
    {
        [StringLength(7)]
        [Required]
        [Display(Name = "Desk no")]
        public string Deskid { get; set; }

        [Required]
        [Display(Name = "Desk exclude reason")]
        public string DeskDeletionReason { get; set; }
    }
}