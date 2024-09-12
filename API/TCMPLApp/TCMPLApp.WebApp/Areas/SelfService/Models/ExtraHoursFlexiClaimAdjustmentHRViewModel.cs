namespace TCMPLApp.WebApp.Models
{
    public class ExtraHoursFlexiClaimAdjustmentHRViewModel : ExtraHoursFlexiClaimAdjustmentHoDViewModel
    {
        public decimal? HRApprovedOt { get; set; }
        public decimal? HRApprovedHhot { get; set; }
        public decimal? HRApprovedCo { get; set; }
    }
}