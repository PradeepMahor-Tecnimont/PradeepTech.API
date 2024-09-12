namespace TCMPLApp.WebApp.Models
{
    public class AppProcessQueueLogViewModel : Domain.Models.Logs.AppProcessQueueLogDataTableList
    {
        public AppProcessQueueLogViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}