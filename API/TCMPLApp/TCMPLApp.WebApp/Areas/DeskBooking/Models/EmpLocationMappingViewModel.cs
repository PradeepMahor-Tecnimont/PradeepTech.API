namespace TCMPLApp.WebApp.Models
{
    public class EmpLocationMappingViewModel : Domain.Models.DeskBooking.EmpLocationMappingDataTableList
    {
        public EmpLocationMappingViewModel()
        {
            FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}
