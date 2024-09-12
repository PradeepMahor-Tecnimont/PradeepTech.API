namespace TCMPLApp.WebApp.Models
{
    public class LogbookViewModel : Domain.Models.Logbook.LogbookDataTableList
    {
        public LogbookViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }
        public FilterDataModel FilterDataModel { get; set; }
    }
}
