namespace TCMPLApp.WebApp.Models
{
    public class RegionViewModel : Domain.Models.HRMasters.RegionDataTableList
    {
        public RegionViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }
        public FilterDataModel FilterDataModel { get; set; }
    }
}
