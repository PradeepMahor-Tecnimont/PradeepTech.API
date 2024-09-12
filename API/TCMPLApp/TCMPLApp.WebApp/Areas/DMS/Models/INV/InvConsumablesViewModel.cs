namespace TCMPLApp.WebApp.Models
{
    public class InvConsumablesViewModel : Domain.Models.DMS.InvConsumablesDataTableList
    {
        public InvConsumablesViewModel()
        {
            FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}