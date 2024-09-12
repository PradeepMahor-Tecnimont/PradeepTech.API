namespace TCMPLApp.WebApp.Models
{
    public class DeskBookHistoryViewModel : Domain.Models.DeskBooking.DeskBookHistoryDataTableList
    {
        public DeskBookHistoryViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}
