namespace TCMPLApp.WebApp.Models
{
    public class HRVppConfigProcessStatusViewModel : Domain.Models.EmpGenInfo.HRVppConfigProcessDataTableList
    {
        public HRVppConfigProcessStatusViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }
        public FilterDataModel FilterDataModel { get; set; }
    }
}
