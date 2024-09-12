namespace TCMPLApp.WebApp.Models
{
    public class TsConfigViewModel : Domain.Models.RapReporting.TsConfigDataTableList
    {
        public TsConfigViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }
        public FilterDataModel FilterDataModel { get; set; }
    }
}
