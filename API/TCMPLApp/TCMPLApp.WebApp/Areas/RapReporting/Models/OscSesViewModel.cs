namespace TCMPLApp.WebApp.Models
{
    public class OscSesViewModel : Domain.Models.RapReporting.OscSesDataTableList
    {
        public OscSesViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }

        public string OscmType { get; set; }
        public string LockOrigBudgetDesc { get; set; }
    }
}