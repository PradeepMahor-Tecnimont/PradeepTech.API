using TCMPLApp.WebApp.Models;

namespace TCMPLApp.WebApp.Models
{
    public class IncidentDataTableListViewModel : TCMPLApp.Domain.Models.HSE.IncidentDataTableList
    {
        public IncidentDataTableListViewModel()
        {

            this.FilterDataModel = new FilterDataModel();

        }

        public FilterDataModel FilterDataModel { get; set; }

    }
}
