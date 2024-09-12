namespace TCMPLApp.WebApp.Models
{
    public class OscDetailViewModel : Domain.Models.RapReporting.OscDetailDataTableList
    {
        public OscDetailViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }

        public string OscmType { get; set; }
        public string LockOrigBudgetDesc { get; set; }
    }
}