namespace TCMPLApp.WebApp.Models
{
    public class AssetMapWithEmpViewModel : Domain.Models.DMS.AssetMapWithEmpDataTableList
    {
        public AssetMapWithEmpViewModel()
        {
            FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}
