
namespace TCMPLApp.WebApp.Models
{
    public class ActivityMasterViewModel : Domain.Models.RapReporting.ActivityMasterDataTableList
    {
        public ActivityMasterViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }
        public FilterDataModel FilterDataModel { get; set; }
    }
}
