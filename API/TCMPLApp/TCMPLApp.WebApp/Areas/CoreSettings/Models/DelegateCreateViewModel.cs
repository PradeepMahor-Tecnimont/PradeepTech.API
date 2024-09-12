using System.ComponentModel.DataAnnotations;
using System.Runtime.InteropServices;

namespace TCMPLApp.WebApp.Models
{
    public class DelegateCreateViewModel
    {
        [Required]
        [Display(Name = "Module")]
        public string ModuleId { get; set; }

        [Required]
        [Display(Name = "Principal employee")]
        public string PrincipalEmpno { get; set; }

        [Required]
        [Display(Name = "OnBehalf employee")]
        public string OnBehalfEmpno { get; set; }
    }
}