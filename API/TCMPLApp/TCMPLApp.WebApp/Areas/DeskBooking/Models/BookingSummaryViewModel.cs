namespace TCMPLApp.WebApp.Models
{
    public class BookingSummaryViewModel : Domain.Models.DeskBooking.BookingSummaryDataTableList
    {
        public BookingSummaryViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public string BookingDate { get; set; }
        public string ActionId { get; set; }
        public FilterDataModel FilterDataModel { get; set; }
    }
}