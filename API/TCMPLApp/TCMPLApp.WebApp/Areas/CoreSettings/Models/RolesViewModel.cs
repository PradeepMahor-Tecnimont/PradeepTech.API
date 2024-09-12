namespace TCMPLApp.WebApp.Models
{
    public class RolesViewModel : Domain.Models.CoreSettings.RolesDataTableList
    {
        public RolesViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }
        public FilterDataModel FilterDataModel { get; set; }
    }
}
