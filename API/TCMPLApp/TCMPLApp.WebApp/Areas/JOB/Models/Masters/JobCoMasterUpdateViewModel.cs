using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class JobCoMasterUpdateViewModel
    {
        [Required]
        [StringLength(4)]
        [Display(Name = "Company code")]
        public string Code { get; set; }

        [Required]
        [StringLength(100)]
        [Display(Name = "Description")]
        public string Description { get; set; }
    }
}