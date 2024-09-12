namespace TCMPLApp.WebApp.Models
{
    public class DeskBookEmpBookingDmsViewModel : Domain.Models.DeskBooking.DeskBookEmpBookingDmsDataTableList
    {
        public DeskBookEmpBookingDmsViewModel()
        {
            FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}