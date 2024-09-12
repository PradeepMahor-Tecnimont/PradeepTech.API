namespace TCMPLApp.WebApp.Models
{
    public class VUModuleUserRoleActionsViewModel : Domain.Models.CoreSettings.VUModuleUserRoleActionsDataTableList
    {
        public VUModuleUserRoleActionsViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }
        public FilterDataModel FilterDataModel { get; set; }
    }
}
