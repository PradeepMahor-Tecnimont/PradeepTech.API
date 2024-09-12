namespace TCMPLApp.WebApp.Models
{
    public class DeskBlockViewModel : Domain.Models.DMS.DeskBlockDataTableList
    {
        public DeskBlockViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}