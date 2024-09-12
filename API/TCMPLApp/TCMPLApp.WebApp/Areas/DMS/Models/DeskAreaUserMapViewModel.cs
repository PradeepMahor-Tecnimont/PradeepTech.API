namespace TCMPLApp.WebApp.Models
{
    public class DeskAreaUserMapViewModel : Domain.Models.DMS.DeskAreaUserMapDataTableList
    {
        public DeskAreaUserMapViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}