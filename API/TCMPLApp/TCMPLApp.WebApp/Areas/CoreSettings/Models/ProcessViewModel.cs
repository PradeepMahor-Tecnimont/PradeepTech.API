namespace TCMPLApp.WebApp.Models
{
    public class ProcessViewModel : Domain.Models.Logs.ProcessDataTableList
    {
        public ProcessViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}