using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class ScopeOfWorkCreateViewModel
    {
        [Required]
        [StringLength(20)]
        [Display(Name = "Scope Of Work ")]
        public string ShortDescription { get; set; }

        [Required]
        [StringLength(100)]
        [Display(Name = "Scope Of Work description")]
        public string Description { get; set; }
    }
}