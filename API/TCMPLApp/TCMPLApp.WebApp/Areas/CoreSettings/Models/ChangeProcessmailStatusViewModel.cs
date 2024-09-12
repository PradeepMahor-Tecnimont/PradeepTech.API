using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class ChangeProcessmailStatusViewModel
    {
        [Required]
        [Display(Name = "Email Process Status")]
        public string ProcessMailStatus { get; set; }
    }
}
