using System;
using System.ComponentModel.DataAnnotations;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.Attendance
{
    public class ExtraHoursClaimsDataTableList
    {

        [Display(Name = "Claim date")]
        public DateTime ClaimDate { get; set; }

        [Display(Name = "Claim no")]
        public string ClaimNo { get; set; }

        [Display(Name = "Claim period")]
        public string ClaimPeriod { get; set; }

        [Display(Name = "Lead approver")]
        public string LeadName { get; set; }

        [Display(Name = "Claimed extra hours")]
        public decimal ClaimedOt { get; set; }

        [Display(Name = "Claimed holiday extrahours")]
        public decimal ClaimedHhot { get; set; }

        [Display(Name = "Claimed compoff")]
        public decimal ClaimedCo { get; set; }

        [Display(Name = "Lead approval")]
        public string LeadApprovalDesc { get; set; }

        [Display(Name = "HoD approval")]
        public string HodApprovalDesc { get; set; }

        [Display(Name = "HR approval")]
        public string HrdApprovalDesc { get; set; }

        [Display(Name = "Lead remarks")]
        public string LeadRemarks { get; set; }

        [Display(Name = "HoD remarks")]
        public string HodRemarks { get; set; }

        [Display(Name = "HR remarks")]
        public string HrdRemarks { get; set; }

        [Display(Name = "Lead approved extrahours")]
        public decimal? LeadApprovedOt { get; set; }

        [Display(Name = "Lead approved holiday extrahours")]
        public decimal? LeadApprovedHhot { get; set; }

        [Display(Name = "Lead approaved compoff")]
        public decimal? LeadApprovedCo { get; set; }

        [Display(Name = "HoD approved extrahours")]
        public decimal? HodApprovedOt { get; set; }

        [Display(Name = "HoD approved holiday extrahours")]
        public decimal? HodApprovedHhot { get; set; }

        [Display(Name = "HoD approaved compoff")]
        public decimal? HodApprovedCo { get; set; }

        [Display(Name = "HR approved extrahours")]
        public decimal? HrdApprovedOt { get; set; }

        [Display(Name = "HR approved holiday extrahours")]
        public decimal? HrdApprovedHhot { get; set; }

        [Display(Name = "HR approaved compoff")]
        public decimal? HrdApprovedCo { get; set; }
        public decimal? CanDeleteClaim { get; set; }


        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

    }
}
