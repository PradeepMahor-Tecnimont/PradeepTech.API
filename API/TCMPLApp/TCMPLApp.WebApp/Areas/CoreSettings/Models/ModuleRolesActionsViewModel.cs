namespace TCMPLApp.WebApp.Models
{
    public class ModuleRolesActionsViewModel : Domain.Models.CoreSettings.ModuleRolesActionsDataTableList
    {
        public ModuleRolesActionsViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }
        public FilterDataModel FilterDataModel { get; set; }
    }
}
