using TCMPLApp.Domain.Models.SWP;
using TCMPLApp.WebApp.Models;

namespace TCMPLApp.WebApp.Models
{
    public class DMSOrphanAssetDetailViewModel : DMSOrphanAsset
    {
        public DMSOrphanAssetDetailViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}
