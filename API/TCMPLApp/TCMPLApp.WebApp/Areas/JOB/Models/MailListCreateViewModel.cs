using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class MailListCreateViewModel
    {
        [Display(Name = "Job No")]
        public string Projno { get; set; }

        [Display(Name = "Costcode")]
        [Required]
        public string Costcode { get; set; }

    }
}
