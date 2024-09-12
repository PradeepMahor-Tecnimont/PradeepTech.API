namespace TCMPLApp.WebApp.Models
{
    public class ModuleActionsViewModel : Domain.Models.CoreSettings.ModuleActionDataTableList
    {
        public ModuleActionsViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}