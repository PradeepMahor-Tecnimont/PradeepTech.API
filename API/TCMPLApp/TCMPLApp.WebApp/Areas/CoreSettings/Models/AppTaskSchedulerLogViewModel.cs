namespace TCMPLApp.WebApp.Models
{
    public class AppTaskSchedulerLogViewModel : Domain.Models.Logs.AppTaskSchedulerLogDataTableList
    {
        public AppTaskSchedulerLogViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}