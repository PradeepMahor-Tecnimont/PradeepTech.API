using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class HRVppConfigProcessUpdateViewModel
    {
        public string keyid { get; set; }

        [Display(Name = "Start date")]
        public DateTime? StartDate { get; set; }

        [Required]
        [Display(Name = "End date")]
        public DateTime? EndDate { get; set; }

        [Display(Name = "Is Display Premium")]
        public decimal? IsDisplayPremium { get; set; }

        [Display(Name = "Is Draft")]
        public decimal? IsDraft { get; set; }

        [Display(Name = "Emp Joining Date")]
        public DateTime? EmpJoiningDate { get; set; }

        [Display(Name = "Is Initiate Config")]
        public decimal? IsInitiateConfig { get; set; }

        [Display(Name = "Applicable To All")]
        public decimal? IsApplicableToAll { get; set; }
    }
}
