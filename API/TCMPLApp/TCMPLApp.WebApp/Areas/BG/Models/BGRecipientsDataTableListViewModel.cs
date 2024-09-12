namespace TCMPLApp.WebApp.Models
{
    public class BGRecipientsDataTableListViewModel : Domain.Models.BG.BGRecipientsDataTableList
    {
        public BGRecipientsDataTableListViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}