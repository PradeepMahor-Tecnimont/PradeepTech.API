using TCMPLApp.WebApp.Models;

namespace TCMPLApp.WebApp.Models
{
    public class FutureEmpComingToOfficeViewModel : Domain.Models.SWP.FutureEmpComingToOfficeDataTableList
    {
        public FutureEmpComingToOfficeViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}