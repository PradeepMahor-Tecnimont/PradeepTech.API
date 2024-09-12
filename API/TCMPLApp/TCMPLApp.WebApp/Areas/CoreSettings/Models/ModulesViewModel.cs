namespace TCMPLApp.WebApp.Models
{
    public class ModulesViewModel : Domain.Models.CoreSettings.ModulesDataTableList
    {
        public ModulesViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }
        public FilterDataModel FilterDataModel { get; set; }
    }
}
