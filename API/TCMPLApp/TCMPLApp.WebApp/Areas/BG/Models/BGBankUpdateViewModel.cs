using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class BGBankUpdateViewModel
    {
        [Required]
        [Display(Name = "Bank id")]
        public string BankId { get; set; }

        [Required]
        [Display(Name = "Bank name")]
        public string BankName { get; set; }

        [Required]
        [Display(Name = "Company")]
        public string CompId { get; set; }

        [Required]
        [Display(Name = "IsVisible")]
        public decimal IsVisible { get; set; }
    }
}