using TCMPLApp.Domain.Models.DMS;

namespace TCMPLApp.WebApp.Models
{
    public class AssetOnHoldActionTransDetailViewModel
    {
        public AssetOnHoldActionTransDetailViewModel()
        {
            FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }

        public string TransId { get; set; }
        public AssetOnHoldActionTransDetails ActionTransDetails { get; set; }
    }
}