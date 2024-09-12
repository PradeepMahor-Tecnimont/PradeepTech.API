
namespace TCMPLApp.WebApp.Models
{
    public class WrkHoursViewModel : Domain.Models.RapReporting.WrkHoursDataTableList
    {
        public WrkHoursViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }
        public FilterDataModel FilterDataModel { get; set; }
    }

}