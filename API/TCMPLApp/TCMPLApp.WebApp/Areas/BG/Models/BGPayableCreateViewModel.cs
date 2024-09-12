using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class BGPayableCreateViewModel
    {
        [Required]
        [Display(Name = "Employee")]
        public string Empno { get; set; }

        [Required]
        [Display(Name = "Company")]
        public string CompId { get; set; }

        [Required]
        [Display(Name = "IsVisible")]
        public decimal IsVisible { get; set; }
    }
}