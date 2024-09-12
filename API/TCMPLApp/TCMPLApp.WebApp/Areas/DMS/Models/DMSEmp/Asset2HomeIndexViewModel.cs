namespace TCMPLApp.WebApp.Models
{
    public class Asset2HomeIndexViewModel : Domain.Models.DMS.DeskAssetTakeHomeDetail
    {
        public Asset2HomeIndexViewModel()
        {
        }
    }

    public class AssetData
    {
        public string asset { get; set; }
        public string asset2Home { get; set; }
    }
}