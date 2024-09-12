using Microsoft.AspNetCore.Http;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class LcChargesCreateViewModel
    {
        [Required]
        public string ApplicationId { get; set; }

        [Required]
        [Display(Name = "LC Status")]
        public string LcChargesStatus { get; set; }

        [Required]
        [Display(Name = "Basic charges")]
        public decimal BasicCharges { get; set; }

        [Required]
        [Display(Name = "Other charges")]
        public decimal OtherCharges { get; set; }

        [Required]
        [Display(Name = "Tax")]
        public decimal Tax { get; set; }

        [Display(Name = "Commission rate")]
        public decimal CommissionRate { get; set; }

        [Display(Name = "Days")]
        public int Days { get; set; }

        [Required]
        [Display(Name = "Remarks")]
        public string Remarks { get; set; } = "NA";

        public IFormFile file { get; set; }
    }
}