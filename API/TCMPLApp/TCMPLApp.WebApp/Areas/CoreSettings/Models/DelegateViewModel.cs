namespace TCMPLApp.WebApp.Models
{
    public class DelegateViewModel : Domain.Models.CoreSettings.DelegateDataTableList
    {
        public DelegateViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}