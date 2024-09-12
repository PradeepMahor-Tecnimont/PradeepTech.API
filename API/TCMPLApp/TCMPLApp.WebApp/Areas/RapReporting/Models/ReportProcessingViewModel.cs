namespace TCMPLApp.WebApp.Models
{
    public class ReportProcessingViewModel : Domain.Models.RapReporting.ProcessingDataDataTableList
    {
        public ReportProcessingViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }
        public FilterDataModel FilterDataModel { get; set; }

        public string KeyId { get; set; }
    }
}
