using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class SubBusinessLinesCreateViewModel
    {
        [Required]
        [StringLength(20)]
        [Display(Name = "Sub Business ")]
        public string ShortDescription { get; set; }

        [Required]
        [StringLength(100)]
        [Display(Name = "Sub Business description")]
        public string Description { get; set; }
    }
}