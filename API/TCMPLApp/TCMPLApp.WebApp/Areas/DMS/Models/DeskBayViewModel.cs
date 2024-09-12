namespace TCMPLApp.WebApp.Models
{
    public class DeskBayViewModel : Domain.Models.DMS.BayDataTableList
    {
        public DeskBayViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}