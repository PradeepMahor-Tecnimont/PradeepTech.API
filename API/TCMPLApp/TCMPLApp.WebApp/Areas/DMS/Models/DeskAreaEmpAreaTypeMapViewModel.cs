namespace TCMPLApp.WebApp.Models
{
    public class DeskAreaEmpAreaTypeMapViewModel : Domain.Models.DMS.DeskAreaEmpAreaTypeMapDataTableList
    {
        public DeskAreaEmpAreaTypeMapViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}