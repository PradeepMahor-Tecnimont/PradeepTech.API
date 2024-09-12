using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class BGProjectControlUpdateViewModel
    {
        [Required]
        [Display(Name = "ProjectControl id")]
        public string ProjectControlId { get; set; }

        [Required]
        [Display(Name = "Empno")]
        public string Empno { get; set; }

        [Display(Name = "Employee")]
        public string Employee { get; set; }

        [Required]
        [Display(Name = "Company")]
        public string CompId { get; set; }

        [Required]
        [Display(Name = "IsVisible")]
        public decimal IsVisible { get; set; }
    }
}