using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class DeskBookEmployeeProjectMappingCreateViewModel
    {
        [Display(Name = "Employee")]
        [Required]
        public string Empno { get; set; }

        [Display(Name = "Project")]
        [Required]
        public string Projno { get; set; }
    }
}