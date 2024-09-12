using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class DeskAreaOfficeMapDetailsViewModel
    {
        [Display(Name = "Area")]
        public string AreaText { get; set; }

        [Display(Name = "Office")]
        public string OfficeText { get; set; }
    }
}