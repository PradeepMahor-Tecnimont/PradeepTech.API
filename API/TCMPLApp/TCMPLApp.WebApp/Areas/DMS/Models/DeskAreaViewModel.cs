namespace TCMPLApp.WebApp.Models
{
    public class DeskAreaViewModel : Domain.Models.DMS.DeskAreaDataTableList
    {
        public DeskAreaViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}