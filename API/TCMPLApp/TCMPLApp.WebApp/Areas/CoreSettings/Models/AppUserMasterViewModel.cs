namespace TCMPLApp.WebApp.Models
{
    public class AppUserMasterViewModel : Domain.Models.CoreSettings.AppUserMasterDataTableList
    {
        public AppUserMasterViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }
        public FilterDataModel FilterDataModel { get; set; }
    }
}
