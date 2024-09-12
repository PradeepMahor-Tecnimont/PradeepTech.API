namespace TCMPLApp.WebApp.Models
{
    public class DeskBookEmployeeProjectMappingViewModel : Domain.Models.DeskBooking.DeskBookEmployeeProjectMappingDataTableList
    {
        public DeskBookEmployeeProjectMappingViewModel()
        {
            FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}
