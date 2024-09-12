namespace TCMPLApp.WebApp.Models
{
    public class ModuleUserRolesViewModel : Domain.Models.CoreSettings.ModuleUserRolesDataTableList
    {
        public ModuleUserRolesViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }
        public FilterDataModel FilterDataModel { get; set; }
    }
}
