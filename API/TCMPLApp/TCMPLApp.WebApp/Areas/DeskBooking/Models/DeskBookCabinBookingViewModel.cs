namespace TCMPLApp.WebApp.Models
{
    public class DeskBookCabinBookingViewModel : Domain.Models.DeskBooking.DeskBookCabinBookingDataTableList
    {
        public DeskBookCabinBookingViewModel()
        {
            FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}
