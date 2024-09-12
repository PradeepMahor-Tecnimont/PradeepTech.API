using TCMPLApp.Domain.Models.SWP;
using TCMPLApp.WebApp.Models;

namespace TCMPLApp.WebApp.Models
{
    public class DMSAssetTakeHomeDetailViewModel : DMSAssetTakeHome
    {
        public DMSAssetTakeHomeDetailViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}
