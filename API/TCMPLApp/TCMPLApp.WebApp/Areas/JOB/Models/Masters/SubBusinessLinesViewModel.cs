namespace TCMPLApp.WebApp.Models
{
    public class SubBusinessLinesViewModel : Domain.Models.JOB.SubBusinessLinesDataTableList
    {
        public SubBusinessLinesViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}
