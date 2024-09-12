using TCMPLApp.WebApp.Models;

namespace TCMPLApp.WebApp.Models
{
    public class CostcodeChangeRequestIndexViewModel : TCMPLApp.Domain.Models.DigiForm.CostcodeChangeRequestDataTableList
    {
        public CostcodeChangeRequestIndexViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}
