using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class LcAcceptanceEditViewModel
    {
        [Required]
        public string ApplicationId { get; set; }

        [Required]
        [Display(Name = "LC acceptance date")]
        public DateTime AcceptanceDate { get; set; }

        [Required]
        [Display(Name = "LC payment due date (per acceptance)")]
        public DateTime PaymentDateAct { get; set; }

        [Required]
        [Display(Name = "Actual amount paid ")]
        public decimal ActualAmountPaid { get; set; }

        [Required]
        [Display(Name = "Remarks")]
        public string Remarks { get; set; }
    }
}