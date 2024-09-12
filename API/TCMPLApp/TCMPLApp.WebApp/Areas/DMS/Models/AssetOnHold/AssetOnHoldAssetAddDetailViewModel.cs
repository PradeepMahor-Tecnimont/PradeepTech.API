namespace TCMPLApp.WebApp.Models
{
    public class AssetOnHoldAssetAddDetailViewModel : Domain.Models.DMS.AssetOnHoldAssetAddDataTableList
    {
        public AssetOnHoldAssetAddDetailViewModel()
        {
            FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }

        public string TransId { get; set; }
    }
}