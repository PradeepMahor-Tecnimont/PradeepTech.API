namespace TCMPLApp.WebApp.Models
{
    public class ModuleUserRoleActionsViewModel : Domain.Models.CoreSettings.ModuleUserRoleActionsDataTableList
    {
        public ModuleUserRoleActionsViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }
        public FilterDataModel FilterDataModel { get; set; }
    }
}
