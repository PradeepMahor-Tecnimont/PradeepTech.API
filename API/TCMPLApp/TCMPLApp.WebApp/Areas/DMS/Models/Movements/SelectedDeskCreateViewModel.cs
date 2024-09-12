using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class SelectedDeskCreateViewModel
    {
        [Display(Name = "Session Id")]
        public string Sid { get; set; }

        [Display(Name = "Desk")]
        public string Deskid { get; set; }
    }
}