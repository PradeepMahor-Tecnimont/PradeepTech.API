namespace TCMPLApp.WebApp.Models
{
    public class InvItemGroupsViewModel : Domain.Models.DMS.InvItemGroupDataTableList
    {
        public InvItemGroupsViewModel()
        {
            FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}