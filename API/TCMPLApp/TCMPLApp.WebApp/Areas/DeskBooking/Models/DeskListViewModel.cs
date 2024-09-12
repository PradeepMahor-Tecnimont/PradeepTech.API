namespace TCMPLApp.WebApp.Models
{
    public class DeskListViewModel : Domain.Models.DeskBooking.DeskListDataTableList
    {
        public DeskListViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}