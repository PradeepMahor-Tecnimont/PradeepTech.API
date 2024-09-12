using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class EmpLocationMapCreateViewModel
    {
        [Required]
        [Display(Name = "Employee")]
        public string Empno { get; set; }

        [Required]
        [Display(Name = "Office Location")]
        public string OfficeLocationCode { get; set; }
    }
}