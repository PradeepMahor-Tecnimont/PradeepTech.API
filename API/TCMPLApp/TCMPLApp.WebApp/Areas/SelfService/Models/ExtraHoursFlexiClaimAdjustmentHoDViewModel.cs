namespace TCMPLApp.WebApp.Models
{
    public class ExtraHoursFlexiClaimAdjustmentHoDViewModel : ExtraHoursFlexiClaimAdjustmentLeadViewModel
    {
        public decimal? HoDApprovedOt { get; set; }
        public decimal? HoDApprovedHhot { get; set; }
        public decimal? HoDApprovedCo { get; set; }
    }
}