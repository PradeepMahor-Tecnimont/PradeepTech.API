namespace TCMPLApp.WebApp.Models
{
    public class FloorPlanViewModel : Domain.Models.DeskBooking.BookedDeskDataTableList
    {
        public FloorPlanViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }

        public string AttendanceDate { get; set; }
        public string ActionId { get; set; }
    }
}