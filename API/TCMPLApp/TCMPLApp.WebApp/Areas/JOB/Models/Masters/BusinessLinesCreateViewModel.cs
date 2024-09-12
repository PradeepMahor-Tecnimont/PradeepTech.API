using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class BusinessLinesCreateViewModel
    {
        [Required]
        [StringLength(20)]
        [Display(Name = "Business Line ")]
        public string ShortDescription { get; set; }

        [Required]
        [StringLength(100)]
        [Display(Name = "Business Line description")]
        public string Description { get; set; }
    }
}