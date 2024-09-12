namespace TCMPLApp.WebApp.Models
{
    public class DeskAreaUserMapHodViewModel : Domain.Models.DeskBooking.DeskAreaUserMapHodDataTableList
    {
        public DeskAreaUserMapHodViewModel()
        {
            FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}