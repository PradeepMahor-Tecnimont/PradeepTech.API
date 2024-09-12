using TCMPLApp.WebApp.Models;

namespace TCMPLApp.WebApp.Areas.ERS.Models
{
    public class HRVacanciesIndexViewModel : TCMPLApp.Domain.Models.ERS.HRVacanciesDataTableList
    {
        public HRVacanciesIndexViewModel()
        {

            this.FilterDataModel = new FilterDataModel();

        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}