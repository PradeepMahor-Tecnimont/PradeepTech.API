using Microsoft.AspNetCore.Http;
using System;
using System.ComponentModel.DataAnnotations;
using DocumentFormat.OpenXml.Wordprocessing;

namespace TCMPLApp.WebApp.Models
{
    public class HRVppConfigProcessCreateViewModel
    {
        [Display(Name = "Start date")]
        public DateTime? StartDate { get; set; }

        [Required]
        [Display(Name = "End date")]
        public DateTime? EndDate { get; set; }

        [Display(Name = "Display Premium")]
        public decimal? IsDisplayPremium { get; set; }

        public IFormFile file { get; set; }

        [Display(Name = "Is Draft")]
        public decimal? IsDraft { get; set; }

        [Display(Name = "Joining date")]
        public DateTime? EmpJoiningDate { get; set; }

        [Display(Name = "Initiate Configuration")]
        public decimal? IsInitiateConfig { get; set; }
        
        [Display(Name = "Applicable To All")]
        public decimal? IsApplicableToAll { get; set; }
        public string BtnName { get; set; }
    }
}
