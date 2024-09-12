namespace TCMPLApp.WebApp.Models
{
    public class DeskManagementStatusIndexViewModel : Domain.Models.DMS.DeskManagementStatusDataTableList
    {
        public DeskManagementStatusIndexViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}