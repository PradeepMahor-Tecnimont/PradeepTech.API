namespace TCMPLApp.WebApp.Models
{
    public class OscActualHoursBookedViewModel : Domain.Models.RapReporting.OscActualHoursBookedDataTableList
    {
        public OscActualHoursBookedViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }

        public string OscmId { get; set; }
    }
}