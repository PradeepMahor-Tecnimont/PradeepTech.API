using TCMPLApp.Domain.Models.SWP;
using TCMPLApp.WebApp.Models;

namespace TCMPLApp.WebApp.Models
{
    public class DMSAssetTakeHomeIndexViewModel : DMSAssetTakeHomeDataTableList
    {
        public DMSAssetTakeHomeIndexViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}
