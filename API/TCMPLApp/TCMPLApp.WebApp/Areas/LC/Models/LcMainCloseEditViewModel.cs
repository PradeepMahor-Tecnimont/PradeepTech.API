using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class LcMainCloseEditViewModel
    {
        public string LcSerialNo { get; set; }

        [Required]
        public string ApplicationId { get; set; }

        [Required]
        [Display(Name = "LC close payment date")]
        public DateTime? LcClPaymentDate { get; set; }

        [Required]
        [Display(Name = "LC close actual amount")]
        public decimal? LcClActualAmount { get; set; }

        [Required]
        [Display(Name = "LC close other charges")]
        public decimal? LcClOtherCharges { get; set; }

        [Required]
        [Display(Name = "Is active")]
        public decimal IsActive { get; set; }

        [Required]
        [Display(Name = "LC close remarks ")]
        public string LcClRemarks { get; set; }
    }
}