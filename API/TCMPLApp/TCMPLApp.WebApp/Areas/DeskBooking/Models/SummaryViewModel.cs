namespace TCMPLApp.WebApp.Models
{
    public class SummaryViewModel : Domain.Models.DeskBooking.SummaryDataTableList
    {
        public SummaryViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}
