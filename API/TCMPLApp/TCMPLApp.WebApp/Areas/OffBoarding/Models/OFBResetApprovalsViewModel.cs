namespace TCMPLApp.WebApp.Models
{
    public class OFBResetApprovalsViewModel : Domain.Models.OffBoarding.OFBResetApprovalsDataTableList
    {
        public OFBResetApprovalsViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }
        public FilterDataModel FilterDataModel { get; set; }
    }
}
