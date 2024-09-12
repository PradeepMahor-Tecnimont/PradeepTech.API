namespace TCMPLApp.WebApp.Models
{
    public class OscHoursViewModel : Domain.Models.RapReporting.OscHoursDataTableList
    {
        public OscHoursViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
        public string OscmType { get; set; }
        public string LockOrigBudgetDesc { get; set; }
    }
}