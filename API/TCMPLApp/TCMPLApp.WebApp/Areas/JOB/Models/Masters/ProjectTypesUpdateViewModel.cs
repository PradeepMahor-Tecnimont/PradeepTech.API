using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class ProjectTypesUpdateViewModel
    {
        [Required]
        public string Code { get; set; }

        [Required]
        [StringLength(20)]
        [Display(Name = "Project Type ")]
        public string ShortDescription { get; set; }

        [Required]
        [StringLength(100)]
        [Display(Name = "Project Type description")]
        public string Description { get; set; }
    }
}