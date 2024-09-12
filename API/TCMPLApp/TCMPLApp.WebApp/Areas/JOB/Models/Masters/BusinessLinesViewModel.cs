namespace TCMPLApp.WebApp.Models
{
    public class BusinessLinesViewModel : Domain.Models.JOB.BusinessLinesDataTableList
    {
        public BusinessLinesViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }
        public FilterDataModel FilterDataModel { get; set; }
    }
}
