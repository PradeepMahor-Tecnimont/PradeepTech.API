using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class EmploymentOfRelativesViewModel
    {
        [Required]
        [Display(Name = "Is relative in office")]
        public string IsRelativeInOffice { get; set; }
        public int? RelativeCount { get; set; }
    }
}