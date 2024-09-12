namespace TCMPLApp.WebApp.Models
{
    public class DeskBookEmpBookingDmsHistoryViewModel : Domain.Models.DeskBooking.DeskBookEmpBookingDmsDataTableList
    {
        public DeskBookEmpBookingDmsHistoryViewModel()
        {
            FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}