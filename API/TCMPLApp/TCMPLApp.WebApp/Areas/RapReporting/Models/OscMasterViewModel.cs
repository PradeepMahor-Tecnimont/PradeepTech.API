namespace TCMPLApp.WebApp.Models
{
    public class OscMasterViewModel : Domain.Models.RapReporting.OscMasterDataTableList
    {
        public OscMasterViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}