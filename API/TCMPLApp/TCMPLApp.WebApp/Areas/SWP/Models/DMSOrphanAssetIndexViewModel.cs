using TCMPLApp.Domain.Models.SWP;
using TCMPLApp.WebApp.Models;

namespace TCMPLApp.WebApp.Models
{
    public class DMSOrphanAssetIndexViewModel : DMSOrphanAssetDataTableList
    {
        public DMSOrphanAssetIndexViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}
