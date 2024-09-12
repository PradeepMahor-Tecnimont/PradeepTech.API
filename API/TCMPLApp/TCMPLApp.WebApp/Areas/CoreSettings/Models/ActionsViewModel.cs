namespace TCMPLApp.WebApp.Models
{
    public class ActionsViewModel : Domain.Models.CoreSettings.ActionsDataTableList
    {
        public ActionsViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }
        public FilterDataModel FilterDataModel { get; set; }
    }
}
