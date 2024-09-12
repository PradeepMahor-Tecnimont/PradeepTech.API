namespace TCMPLApp.WebApp.Models
{
    public class OFBApprovedApprovalsViewModel : Domain.Models.OffBoarding.OFBApprovedApprovalsDataTableList
    {
        public OFBApprovedApprovalsViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }
        public FilterDataModel FilterDataModel { get; set; }
    }
}
