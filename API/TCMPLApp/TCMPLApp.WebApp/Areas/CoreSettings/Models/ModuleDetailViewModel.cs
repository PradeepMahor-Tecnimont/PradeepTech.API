using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class ModuleDetailViewModel
    {
        [Display(Name = "Module Id")]
        public string ModuleId { get; set; }

        [Display(Name = "Module Name")]
        public string ModuleName { get; set; }
    }
}
