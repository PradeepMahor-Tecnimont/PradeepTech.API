using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class DeskAssignmentCreateViewModel
    {
        [Display(Name = "Session Id")]
        public string Sid { get; set; }

        [Display(Name = "Current desk no")]
        public string CurrDeskid { get; set; }

        [Display(Name = "Assignment desk no")]
        public string Deskid { get; set; }
    }
}