using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.EmpGenInfo
{
    public class HRVppConfigProcessDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }
        public string KeyId { get; set; }

        [Display(Name = "Start Date")]
        public DateTime? StartDate { get; set; }

        [Display(Name = "End Date")]
        public DateTime? EndDate { get; set; }

        [Display(Name = "Is Display Premium")]
        public string IsDisplayPremiumText { get; set; }
        public decimal? IsDisplayPremiumVal { get; set; }

        [Display(Name = "Is Draft")]
        public string IsDraftText { get; set; }

        public decimal? IsDraftVal { get; set; }
        
        [Display(Name = "Is Applicable To All")]
        public string IsApplicableToAllText { get; set; }
        public decimal? IsApplicableToAllVal { get; set; }

        [Display(Name = "Emp Joining Date")]
        public DateTime? EmpJoiningDate { get; set; }

        [Display(Name = "Is Active")]
        public string IsInitiateConfigText { get; set; }
        public decimal? IsInitiateConfigVal { get; set; }
        public decimal? CanEdit { get; set; }
        public decimal? CanDeactivate { get; set; }
        public decimal? CanActivate { get; set; }

        [Display(Name = "Modified On")]
        public DateTime? ModifiedOn { get; set; }

    }
}
