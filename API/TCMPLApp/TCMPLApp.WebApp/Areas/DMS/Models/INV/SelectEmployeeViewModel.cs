using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class SelectEmployeeViewModel
    {
        [Required]
        [Display(Name = "Employee")]
        public string Employee { get; set; }
    }
}