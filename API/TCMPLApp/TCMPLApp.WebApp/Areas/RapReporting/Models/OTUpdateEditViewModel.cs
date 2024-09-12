using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class OTUpdateEditViewModel
    {
        [Display(Name = "Costcode")]
        public string Costcode { get; set; }

        [Required]
        [Display(Name = "Yymm")]
        public string Yymm { get; set; }

        [Range(1, 100)]
        [Display(Name = "OT %")]
        public decimal? OT { get; set; }
    }
}
