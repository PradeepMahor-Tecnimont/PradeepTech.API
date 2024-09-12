using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class CurrencyUpdateViewModel
    {
        [Required]
        [Display(Name = "Application id")]
        public string ApplicationId { get; set; }

        [Required]
        [Display(Name = "Currency code")]
        public string CurrencyCode { get; set; }

        [Required]
        [Display(Name = "Currency description")]
        public string CurrencyDesc { get; set; }

        [Required]
        [Display(Name = "Is active")]
        public decimal IsActive { get; set; }
    }
}