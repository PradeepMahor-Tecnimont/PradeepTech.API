using TCMPLApp.WebApp.Models;

namespace TCMPLApp.WebApp.Models
{
    public class SWSEmployeePresentViewModel : Domain.Models.SWP.SWSEmployeePresentDataTableList
    {
        public SWSEmployeePresentViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }

    }
}
