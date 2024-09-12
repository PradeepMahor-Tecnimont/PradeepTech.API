namespace TCMPLApp.WebApp.Models
{
    public class ProjectTypesViewModel : Domain.Models.JOB.ProjectTypesDataTableList
    {
        public ProjectTypesViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}
