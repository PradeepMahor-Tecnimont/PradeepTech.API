namespace TCMPLApp.WebApp.Models
{
    public class OFBInitViewModel : Domain.Models.OffBoarding.OFBInitDataTableList
    {
        public OFBInitViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }
        public FilterDataModel FilterDataModel { get; set; }

    }
}
