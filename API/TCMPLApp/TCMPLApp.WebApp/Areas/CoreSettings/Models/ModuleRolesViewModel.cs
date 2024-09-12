namespace TCMPLApp.WebApp.Models
{
    public class ModuleRolesViewModel : Domain.Models.CoreSettings.ModuleRolesDataTableList
    {
        public ModuleRolesViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }
        public FilterDataModel FilterDataModel { get; set; }
    }
}
