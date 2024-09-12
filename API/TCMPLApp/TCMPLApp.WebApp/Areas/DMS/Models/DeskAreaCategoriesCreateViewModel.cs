using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class DeskAreaCategoriesCreateViewModel
    {
        [Required]
        [StringLength(4)]
        [Display(Name = "Area categories code")]
        public string AreaCatgCode { get; set; }

        [Required]
        [StringLength(100)]
        [Display(Name = "Area categories description")]
        public string AreaDesc { get; set; }
    }
}