namespace TCMPLApp.WebApp.Models
{
    public class ProjactMasterViewModel : Domain.Models.RapReporting.ProjactMasterDataTableList
    {
        public ProjactMasterViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }
        public FilterDataModel FilterDataModel { get; set; }
    }
}
