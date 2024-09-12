using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class BGPPCUpdateViewModel
    {
        [Required]
        [Display(Name = "PPC id")]
        public string PPCId { get; set; }

        [Required]
        [Display(Name = "Empno")]
        public string Empno { get; set; }

        [Display(Name = "Employee")]
        public string Employee { get; set; }

        [Required]
        [Display(Name = "Company")]
        public string CompId { get; set; }

        [Required]
        [Display(Name = "Project")]
        public string Projno { get; set; }

        [Display(Name = "Project")]
        public string Project { get; set; }

        [Required]
        [Display(Name = "IsVisible")]
        public decimal IsVisible { get; set; }
    }
}