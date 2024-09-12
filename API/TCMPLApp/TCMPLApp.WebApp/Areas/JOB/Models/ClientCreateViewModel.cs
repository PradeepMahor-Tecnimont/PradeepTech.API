using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class ClientCreateViewModel
    {
        public string Projno { get; set; }

        [Required]
        [StringLength(45)]
        [Display(Name = "Client Name")]
        public string ClientName { get; set; }
    }
}
