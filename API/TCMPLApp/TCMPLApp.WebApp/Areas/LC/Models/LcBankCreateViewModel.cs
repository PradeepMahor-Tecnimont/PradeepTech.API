using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class LcBankCreateViewModel
    {
        [Required]
        public string ApplicationId { get; set; }

        [Required]
        [Display(Name = "Issuing bank")]
        public string IssuingBank { get; set; }

        [Required]
        [Display(Name = "Discounting bank")]
        public string DiscountingBank { get; set; }

        [Required]
        [Display(Name = "Advising bank")]
        public string AdvisingBank { get; set; }

        [Required]
        [Display(Name = "Validity date")]
        public DateTime? ValidityDate { get; set; }

        [Required]
        [Display(Name = "Duration type")]
        public string DurationType { get; set; }

        [Required]
        [Display(Name = "Tenure (No Of Days)")]
        public int TenureNoOfDays { get; set; }

        [Display(Name = "LC number")]
        public int? LCNumber { get; set; }

        [Required]
        [Display(Name = "Issue date")]
        public DateTime? IssueDate { get; set; }

        [Required]
        [Display(Name = "LC payment due date (theoretical)")]
        public DateTime? PaymentDateEst { get; set; }

        [Required]
        [Display(Name = "Remarks")]
        public string Remarks { get; set; } = "NA";
    }
}