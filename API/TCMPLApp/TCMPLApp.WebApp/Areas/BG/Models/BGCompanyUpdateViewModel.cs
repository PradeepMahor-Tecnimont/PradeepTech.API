using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class BGCompanyUpdateViewModel
    {
        [Required]
        [Display(Name = "Company id")]
        public string CompanyId { get; set; }

        [Required]
        [Display(Name = "Company description")]
        public string CompDesc { get; set; }

        [Required]
        [Display(Name = "Domain")]
        public string Domain { get; set; }

        [Required]
        [Display(Name = "IsVisible")]
        public decimal IsVisible { get; set; }
    }
}