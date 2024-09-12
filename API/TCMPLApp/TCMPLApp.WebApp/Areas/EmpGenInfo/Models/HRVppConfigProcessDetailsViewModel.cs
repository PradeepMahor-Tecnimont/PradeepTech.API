using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models;

namespace TCMPLApp.WebApp.Models
{
    public class HRVppConfigProcessDetailsViewModel
    {
        public string KeyId { get; set; }

        [Display(Name = "Start date")]
        public DateTime? StartDate { get; set; }

        [Required]
        [Display(Name = "End date")]
        public DateTime? EndDate { get; set; }

        [Display(Name = "Is Display Premium")]
        public decimal? IsDisplayPremiumVal { get; set; }

        [Display(Name = "Is Display Premium")]
        public string IsDisplayPremiumText { get; set; }

        [Display(Name = "Is Draft")]
        public decimal? IsDraft { get; set; }

        [Display(Name = "Is Draft")]
        public string IsDraftText { get; set; }

        [Display(Name = "Emp Joining Date")]
        public DateTime? EmpJoiningDate { get; set; }

        [Display(Name = "Is Config Activate")]
        public decimal? IsInitiateConfig { get; set; }

        [Display(Name = "Is Config Activate")]
        public string IsInitiateConfigText { get; set; }

        [Display(Name = "Is Applicable To All")]
        public decimal? IsApplicableToAll { get; set; }

        [Display(Name = "Is Applicable To All")]
        public string IsApplicableToAllText { get; set; }

        [Display(Name = "Created By")]
        public string CreatedBy { get; set; }

        [Display(Name = "Created On")]
        public DateTime? CreatedOn { get; set; }

        [Display(Name = "Modified By")]
        public string ModifiedBy { get; set; }

        [Display(Name = "Modified On")]
        public DateTime? ModifiedOn { get; set; }

        public IEnumerable<VppConfigPremiumDataTableList> vppConfigPremiumDataTableList { get; set; }
    }
}