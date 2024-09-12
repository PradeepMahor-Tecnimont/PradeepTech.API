namespace TCMPLApp.WebApp.Models
{
    public class DeskBookAttendanceHodHistoryViewModel : Domain.Models.DeskBooking.DeskBookAttendanceHodDataTableList
    {
        public DeskBookAttendanceHodHistoryViewModel()
        {
            FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}