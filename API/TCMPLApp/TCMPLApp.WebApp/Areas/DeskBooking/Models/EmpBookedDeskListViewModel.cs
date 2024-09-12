namespace TCMPLApp.WebApp.Models
{
    public class EmpBookedDeskListViewModel : Domain.Models.DeskBooking.EmpBookedDeskListDataTableList
    {
        public EmpBookedDeskListViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}
