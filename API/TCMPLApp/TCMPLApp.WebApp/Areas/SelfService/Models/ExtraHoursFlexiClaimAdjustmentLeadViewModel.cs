namespace TCMPLApp.WebApp.Models
{
    public class ExtraHoursFlexiClaimAdjustmentLeadViewModel
    {
        public string ClaimNo { get; set; }
        public string Empno { get; set; }
        public string Employee { get; set; }
        public decimal ClaimedOt { get; set; }
        public decimal ClaimedHhot { get; set; }
        public decimal ClaimedCo { get; set; }
        public decimal? LeadApprovedOt { get; set; }
        public decimal? LeadApprovedHhot { get; set; }
        public decimal? LeadApprovedCo { get; set; }
    }
}