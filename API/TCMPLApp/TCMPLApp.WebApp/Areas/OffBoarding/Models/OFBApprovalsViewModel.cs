namespace TCMPLApp.WebApp.Models
{
    public class OFBApprovalsViewModel : Domain.Models.OffBoarding.OFBApprovalsPendingDataTableList
    {
        public OFBApprovalsViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }
        public FilterDataModel FilterDataModel { get; set; }
    }
}
