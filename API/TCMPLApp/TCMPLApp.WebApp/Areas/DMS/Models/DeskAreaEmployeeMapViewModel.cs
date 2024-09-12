namespace TCMPLApp.WebApp.Models
{
    public class DeskAreaEmployeeMapViewModel : Domain.Models.DMS.DeskAreaEmployeeMapDataTableList
    {
        public DeskAreaEmployeeMapViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}