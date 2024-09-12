using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class DeskBlockCreateViewModel
    {
        [Required]
        [Display(Name = "Desk id")]
        public string Deskid { get; set; }

        [Required]
        [Display(Name = "Particulars")]
        public string Remarks { get; set; }

        [Required]
        [Display(Name = "Block reason")]
        public decimal? Blockreason { get; set; }
    }
}