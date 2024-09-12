namespace TCMPLApp.WebApp.Models
{
    public class DeskAreaProjectMapViewModel : Domain.Models.DMS.DeskAreaProjectMapDataTableList
    {
        public DeskAreaProjectMapViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}