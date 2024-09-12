using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class DMSGuestMasterCreateViewModel
    {
        [Required]
        [Display(Name = "Guest name")]
        public string GuestName { get; set; }

        [Required]
        [Display(Name = "Cost code")]
        public string CostCode { get; set; }

        [Required]
        [Display(Name = "Project no")]
        public string ProjNo7 { get; set; }

        [Required]
        [Display(Name = "From date")]
        public DateTime? FromDate { get; set; }

        [Required]
        [Display(Name = "To date")]
        public DateTime? ToDate { get; set; }

        [Required]
        [Display(Name = "Target desk")]
        public string TargetDesk { get; set; }
    }
}