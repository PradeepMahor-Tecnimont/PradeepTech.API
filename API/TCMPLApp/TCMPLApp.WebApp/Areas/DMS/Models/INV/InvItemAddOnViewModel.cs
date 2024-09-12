namespace TCMPLApp.WebApp.Models
{
    public class InvItemAddOnViewModel : Domain.Models.DMS.InvItemAddOnDataTableList
    {
        public InvItemAddOnViewModel()
        {
            FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}