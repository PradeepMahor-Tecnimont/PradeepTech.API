
namespace TCMPLApp.WebApp.Models
{
    public class RapHoursViewModel : Domain.Models.RapReporting.RapHoursDataTableList
    {
        public RapHoursViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }
        public FilterDataModel FilterDataModel { get; set; }
    }
}