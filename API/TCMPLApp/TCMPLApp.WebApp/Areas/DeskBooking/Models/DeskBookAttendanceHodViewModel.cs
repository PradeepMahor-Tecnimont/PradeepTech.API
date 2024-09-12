namespace TCMPLApp.WebApp.Models
{
    public class DeskBookAttendanceHodViewModel : Domain.Models.DeskBooking.DeskBookAttendanceHodDataTableList
    {
        public DeskBookAttendanceHodViewModel()
        {
            FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}