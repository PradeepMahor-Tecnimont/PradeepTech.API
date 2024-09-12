using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class BankCreateViewModel
    {
        [Required]
        [Display(Name = "Bank description")]
        public string BankDesc { get; set; }

        [Required]
        [Display(Name = "Is active")]
        public decimal IsActive { get; set; }
    }
}