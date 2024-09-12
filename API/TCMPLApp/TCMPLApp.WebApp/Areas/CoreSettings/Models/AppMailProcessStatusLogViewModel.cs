namespace TCMPLApp.WebApp.Models
{
    public class AppMailProcessStatusLogViewModel : Domain.Models.CoreSettings.AppMailProcessStatusLogDataTableList
    {
        public AppMailProcessStatusLogViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }
        public FilterDataModel FilterDataModel { get; set; }
    }
}
