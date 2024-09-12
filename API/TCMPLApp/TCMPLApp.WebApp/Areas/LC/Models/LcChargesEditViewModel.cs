using Microsoft.AspNetCore.Http;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class LcChargesEditViewModel
    {
        [Required]
        public string ApplicationId { get; set; }

        [Required]
        public string LcKeyId { get; set; }

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

        [Required]
        [Display(Name = "Remarks")]
        public string Remarks { get; set; }

        [Display(Name = "Clint File name")]
        public string ClintFileName { get; set; }

        [Display(Name = "Server file name")]
        public string ServerFileName { get; set; }

        [Display(Name = "Commission rate")]
        public decimal CommissionRate { get; set; }

        [Display(Name = "Days")]
        public int Days { get; set; }

        public IFormFile file { get; set; }
    }
}