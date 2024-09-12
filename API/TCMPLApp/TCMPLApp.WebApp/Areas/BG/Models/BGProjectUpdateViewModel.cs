using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class BGProjectUpdateViewModel
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

        [Display(Name = "Closed")]
        public decimal? Isclosed { get; set; }
    }
}