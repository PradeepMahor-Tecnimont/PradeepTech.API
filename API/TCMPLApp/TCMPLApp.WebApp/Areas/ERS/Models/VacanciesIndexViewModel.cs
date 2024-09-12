using TCMPLApp.WebApp.Models;

namespace TCMPLApp.WebApp.Areas.ERS.Models
{
    public class VacanciesIndexViewModel : TCMPLApp.Domain.Models.ERS.VacanciesDataTableList
    {
        public VacanciesIndexViewModel()
        {

            this.FilterDataModel = new FilterDataModel();

        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}