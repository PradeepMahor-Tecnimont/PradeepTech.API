using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class BGGuaranteeTypeCreateViewModel
    {
        [Required]
        [Display(Name = "GuaranteeType id")]
        public string GuaranteeTypeId { get; set; }

        [Required]
        [Display(Name = "Guarantee type")]
        public string GuaranteeType { get; set; }

        [Required]
        [Display(Name = "IsVisible")]
        public decimal IsVisible { get; set; }
    }
}