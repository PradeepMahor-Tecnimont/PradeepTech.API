using TCMPLApp.WebApp.Models;

namespace TCMPLApp.WebApp.Models
{
    public class OWSEmployeeAbsentViewModel : Domain.Models.SWP.OWSEmployeeAbsentDataTableList
    {
        public OWSEmployeeAbsentViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }

    }
}
