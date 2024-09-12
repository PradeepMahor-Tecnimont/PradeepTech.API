using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class InvItemCategoryCreateViewModel
    {
        [Required]
        [StringLength(2)]
        [Display(Name = "Category Code")]
        public string CategoryCode { get; set; }

        [Required]
        [StringLength(100)]
        [Display(Name = "Category description")]
        public string CategoryDescription { get; set; }
    }
}