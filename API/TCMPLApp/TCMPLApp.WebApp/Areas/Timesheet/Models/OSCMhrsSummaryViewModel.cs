namespace TCMPLApp.WebApp.Models
{
    public class OSCMhrsSummaryViewModel : Domain.Models.Timesheet.OSCMhrsSummaryDataTableList
    {
        public OSCMhrsSummaryViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }
        public FilterDataModel FilterDataModel { get; set; }
    }
}
