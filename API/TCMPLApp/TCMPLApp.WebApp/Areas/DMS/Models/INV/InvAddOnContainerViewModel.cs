namespace TCMPLApp.WebApp.Models
{
    public class InvAddOnContainerViewModel : Domain.Models.DMS.InvAddOnContainerDataTableList
    {
        public InvAddOnContainerViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}