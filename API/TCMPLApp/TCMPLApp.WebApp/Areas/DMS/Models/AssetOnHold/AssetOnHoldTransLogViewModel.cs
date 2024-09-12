namespace TCMPLApp.WebApp.Models
{
    public class AssetOnHoldTransLogViewModel : Domain.Models.DMS.AssetOnHoldActionTransDataTableList
    {
        public AssetOnHoldTransLogViewModel()
        {
            FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}