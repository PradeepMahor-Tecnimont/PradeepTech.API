using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class BGProjectCreateViewModel
    {
        [Required]
        [Display(Name = "Project no")]
        public string Projnum { get; set; }

        [Required]
        [Display(Name = "Name")]
        public string Name { get; set; }

        [Required]
        [Display(Name = "Manager name")]
        public string Mngrname { get; set; }

        [Required]
        [Display(Name = "Manager email")]
        public string Mngremail { get; set; }

    }
}