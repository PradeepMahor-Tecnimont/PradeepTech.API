namespace TCMPLApp.WebApp.Models
{
    public class InvItemTypesViewModel : Domain.Models.DMS.InvItemTypesDataTableList
    {
        public InvItemTypesViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}