namespace TCMPLApp.WebApp.Models
{
    public class OSCMhrsViewModel : Domain.Models.Timesheet.OSCMhrsDetailsDataTableList
    {
        public OSCMhrsViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }
        public FilterDataModel FilterDataModel { get; set; }        

    }
}
