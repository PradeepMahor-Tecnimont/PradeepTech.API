namespace TCMPLApp.WebApp.Models
{
    public class DeskAreaDepartmentMapViewModel : Domain.Models.DMS.DeskAreaDepartmentMapDataTableList
    {
        public DeskAreaDepartmentMapViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}