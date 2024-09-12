using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class BGCurrencyUpdateViewModel
    {
        [Required]
        [Display(Name = "Currency id")]
        public string CurrencyId { get; set; }

        [Required]
        [Display(Name = "Currency description")]
        public string CurrDesc { get; set; }

        [Required]
        [Display(Name = "Company")]
        public string CompId { get; set; }

        [Display(Name = "Company Description")]
        public string CompDesc { get; set; }

        [Required]
        [Display(Name = "IsVisible")]
        public decimal IsVisible { get; set; }
    }
}