using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class OscMasterCreateViewModel
    {
        [Required]
        [Display(Name = "Project")]
        public string Projno5 { get; set; }

        [Required]
        [Display(Name = "Vendor")]
        public string OscmVendor { get; set; }

        [Required]
        [Display(Name = "Scope of work")]
        public string OscswId { get; set; }

        [Required]
        [StringLength(10)]
        [Display(Name = "PO number")]
        public string PoNumber { get; set; }

        [Required]
        [Display(Name = "PO date")]
        public DateTime? PoDate { get; set; }

        [Required]
        [Range(1, int.MaxValue, ErrorMessage = "Only positive number allowed")]
        [Display(Name = "PO amount")]
        public decimal PoAmt { get; set; }

        [Required]
        [Display(Name = "Cost code")]
        public string[] Costcode { get; set; }
    }
}