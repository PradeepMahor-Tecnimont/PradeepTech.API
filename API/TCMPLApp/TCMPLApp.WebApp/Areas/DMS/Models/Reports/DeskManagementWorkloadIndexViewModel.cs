namespace TCMPLApp.WebApp.Models
{
    public class DeskManagementWorkloadIndexViewModel : Domain.Models.DMS.DeskManagementWorkloadDataTableList
    {
        public DeskManagementWorkloadIndexViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}