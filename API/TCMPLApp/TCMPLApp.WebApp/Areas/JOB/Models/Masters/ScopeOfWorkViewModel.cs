namespace TCMPLApp.WebApp.Models
{
    public class ScopeOfWorkViewModel : Domain.Models.JOB.ScopeOfWorkDataTableList
    {
        public ScopeOfWorkViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }
        public FilterDataModel FilterDataModel { get; set; }
    }
}
