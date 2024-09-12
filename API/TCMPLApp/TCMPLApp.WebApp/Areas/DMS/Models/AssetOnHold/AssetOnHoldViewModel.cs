namespace TCMPLApp.WebApp.Models
{
    public class AssetOnHoldViewModel : Domain.Models.DMS.AssetOnHoldAssetAddDataTableList
    {
        public AssetOnHoldViewModel()
        {
            FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}