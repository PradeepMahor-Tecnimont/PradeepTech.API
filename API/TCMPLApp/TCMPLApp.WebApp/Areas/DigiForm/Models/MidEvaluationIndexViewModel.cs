using TCMPLApp.WebApp.Models;

namespace TCMPLApp.WebApp.Models
{
    public class MidEvaluationIndexViewModel : TCMPLApp.Domain.Models.DigiForm.MidEvaluationDataTableList
    {
        public MidEvaluationIndexViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }

    }
}
