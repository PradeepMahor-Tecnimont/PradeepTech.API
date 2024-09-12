namespace TCMPLApp.WebApp.Models
{
    public class TSPostedHoursViewModel : Domain.Models.RapReporting.TSPostedHoursDataTableList
    {
        public TSPostedHoursViewModel()
        {
            FilterDataModel = new FilterDataModel();
        }
        public FilterDataModel FilterDataModel { get; set; }
    }
}
