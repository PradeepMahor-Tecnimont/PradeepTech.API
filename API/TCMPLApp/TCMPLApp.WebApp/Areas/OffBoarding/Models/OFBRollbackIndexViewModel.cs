namespace TCMPLApp.WebApp.Models
{
    public class OFBRollbackIndexViewModel : Domain.Models.OffBoarding.OFBRollbackDataTableList
    {
        public OFBRollbackIndexViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}