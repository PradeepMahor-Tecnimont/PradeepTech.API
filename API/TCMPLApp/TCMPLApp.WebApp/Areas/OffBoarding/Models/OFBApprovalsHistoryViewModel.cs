namespace TCMPLApp.WebApp.Models
{
    public class OFBApprovalsHistoryViewModel : Domain.Models.OffBoarding.OFBApprovalsHistoryDataTableList
    {
        public OFBApprovalsHistoryViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }
        public FilterDataModel FilterDataModel { get; set; }
    }
}
