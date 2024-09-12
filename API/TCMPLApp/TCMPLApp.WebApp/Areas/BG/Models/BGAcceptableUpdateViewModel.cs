using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class BGAcceptableUpdateViewModel
    {
        [Required]
        [Display(Name = "Acceptable id")]
        public string AcceptableId { get; set; }

        [Required]
        [Display(Name = "Acceptable name")]
        public string AcceptableName { get; set; }

        [Required]
        [Display(Name = "IsVisible")]
        public decimal IsVisible { get; set; }
    }
}