namespace TCMPLApp.WebApp.Models
{
    public class DeskBookingAttendanceStatusViewModel : Domain.Models.DeskBooking.DeskBookingAttendanceStatusDataTableList
    {
        public DeskBookingAttendanceStatusViewModel()
        {
            FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}
