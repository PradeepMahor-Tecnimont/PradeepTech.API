namespace TCMPLApp.WebApp.Models
{
    public class DeskAreaOfficeMapViewModel : Domain.Models.DMS.DeskAreaOfficeMapDataTableList
    {
        public DeskAreaOfficeMapViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}