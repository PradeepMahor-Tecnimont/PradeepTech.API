namespace TCMPLApp.WebApp.Models
{
    public class HolidaysViewModel : Domain.Models.HRMasters.RegionHolidaysDataTableList
    {
        public HolidaysViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }
        public FilterDataModel FilterDataModel { get; set; }
    }
}
