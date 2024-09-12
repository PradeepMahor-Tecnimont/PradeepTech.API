namespace TCMPLApp.WebApp.Models
{
    public class ModuleUserRoleCostCodeViewModel : Domain.Models.CoreSettings.ModuleUserRoleCostCodeDataTableList
    {
        public ModuleUserRoleCostCodeViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }
        public FilterDataModel FilterDataModel { get; set; }
    }
}
