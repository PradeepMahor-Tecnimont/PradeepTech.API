namespace TCMPLApp.WebApp.Models
{
    public class TMAGroupsViewModel : Domain.Models.JOB.TMAGroupsDataTableList
    {
        public TMAGroupsViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }
        public FilterDataModel FilterDataModel { get; set; }

    }
}
