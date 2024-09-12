namespace TCMPLApp.WebApp.Models
{
    public class JobCoMasterViewModel : Domain.Models.JOB.JobCoMasterDataTableList
    {
        public JobCoMasterViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}