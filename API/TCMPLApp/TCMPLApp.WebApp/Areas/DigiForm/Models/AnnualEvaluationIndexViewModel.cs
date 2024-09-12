using TCMPLApp.WebApp.Models;

namespace TCMPLApp.WebApp.Models
{
    public class AnnualEvaluationIndexViewModel : TCMPLApp.Domain.Models.DigiForm.AnnualEvaluationDataTableList
    {
        public AnnualEvaluationIndexViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}
