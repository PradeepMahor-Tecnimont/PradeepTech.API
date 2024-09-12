using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class DeskBayCreateViewModel
    {
        [Required]
        [StringLength(4)]
        [Display(Name = "Bay id")]
        public string BayId { get; set; }

        [Required]
        [StringLength(20)]
        [Display(Name = "Bay description")]
        public string BayDesc { get; set; }
    }
}