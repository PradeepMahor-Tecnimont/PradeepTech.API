namespace TCMPLApp.WebApp.Models
{
    public class InvItemNotInServiceViewModel : Domain.Models.DMS.InvItemNotInServiceDataTableList
    {
        public InvItemNotInServiceViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}