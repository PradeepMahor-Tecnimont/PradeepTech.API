namespace TCMPLApp.WebApp.Models
{
    public class DeskBookingAttendanceStatusHistoryViewModel : Domain.Models.DeskBooking.DeskBookingAttendanceStatusDataTableList
    {
        public DeskBookingAttendanceStatusHistoryViewModel()
        {
            FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}
