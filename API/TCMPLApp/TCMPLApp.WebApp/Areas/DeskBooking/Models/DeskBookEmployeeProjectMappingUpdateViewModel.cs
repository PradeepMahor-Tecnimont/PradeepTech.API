using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class DeskBookEmployeeProjectMappingUpdateViewModel
    {
        [Required]
        public string KeyId { get; set; }

        [Display(Name = "Employee")]
        [Required]
        public string Empno { get; set; }

        [Display(Name = "Employee")]
        public string Empname { get; set; }

        [Display(Name = "Project")]
        [Required]
        public string Projno { get; set; }
    }
}