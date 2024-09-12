using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class BankUpdateViewModel
    {
        [Required]
        [Display(Name = "Application id")]
        public string ApplicationId { get; set; }

        [Required]
        [Display(Name = "Bank description")]
        public string BankDesc { get; set; }

        [Required]
        [Display(Name = "Is active")]
        public decimal IsActive { get; set; }
    }
}