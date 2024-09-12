using TCMPLApp.Domain.Models.DMS;

namespace TCMPLApp.WebApp.Models
{
    public class EmpDeskInMoreThan1PlacesIndexViewModel : EmpDeskInMoreThanPlacesDataTableList
    {
        public EmpDeskInMoreThan1PlacesIndexViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}