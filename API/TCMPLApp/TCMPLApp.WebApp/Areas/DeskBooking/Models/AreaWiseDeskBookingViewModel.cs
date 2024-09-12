namespace TCMPLApp.WebApp.Models
{
    public class AreaWiseDeskBookingViewModel : Domain.Models.DeskBooking.AreaWiseDeskBookingDataTableList
    {
        public AreaWiseDeskBookingViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}
