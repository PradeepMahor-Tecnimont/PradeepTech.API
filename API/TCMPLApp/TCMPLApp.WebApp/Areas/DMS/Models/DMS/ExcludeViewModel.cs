namespace TCMPLApp.WebApp.Models
{
    public class ExcludeViewModel : Domain.Models.DMS.ExcludeDataTableList
    {
        public ExcludeViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}